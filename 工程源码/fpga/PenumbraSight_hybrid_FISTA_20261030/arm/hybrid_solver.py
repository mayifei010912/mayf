"""ARM control for the author's FISTA/TV solver; FPGA implements Gx and dual TV.
No reference image is accepted by the solver. This module never programs an FPGA.
MMIO mode requires an explicitly assigned control base and a DMA-reserved G buffer.
"""
import argparse, ctypes, json, math, mmap, os, pathlib, time
import numpy as np

ROOT = pathlib.Path(__file__).resolve().parents[1]
QX, QD = 20, 28

def round_int(x, shift):
    return ((abs(int(x)) + (1 << (shift-1))) >> shift) * (-1 if x < 0 else 1)

def quantize(x, frac=20):
    a = np.asarray(x) * (2.0**frac)
    q = np.copysign(np.floor(np.abs(a)+0.5), a)
    if not np.all(np.isfinite(q)) or np.any(q < -2**31) or np.any(q > 2**31-1):
        raise OverflowError('signed32 input range exceeded; refusing silent clipping')
    return q.astype(np.int64)

class ExactTV:
    """Independent integer oracle for RTL. MATLAB column-major indexing."""
    def __init__(self, h, w): self.h,self.w,self.n=h,w,h*w
    def load(self, b): self.b=list(map(int,b)); self.valid=False
    def iteration(self, theta, invtheta, beta, reset):
        n,h,w=self.n,self.h,self.w
        if reset:
            self.r=[0]*n;self.s=[0]*n;self.po=[0]*n;self.qo=[0]*n;self.valid=True
            self.theta,self.inv=theta,invtheta
        if not self.valid or theta!=self.theta or invtheta!=self.inv:
            raise ValueError('invalid TV resume')
        sol=[]
        for k in range(n):
            i,j=k%h,k//h
            l=self.r[k]+self.s[k]-(self.r[k-1] if i else 0)-(self.s[k-h] if j else 0)
            v=self.b[k]-round_int(theta*l,40)
            if not -2**31<=v<2**31: raise OverflowError('TV solution clipped')
            sol.append(v)
        r=[];s=[];po=[];qo=[]
        for k in range(n):
            i,j=k%h,k//h
            dv=sol[k]-sol[k+1] if i<h-1 else 0
            dh=sol[k]-sol[k+h] if j<w-1 else 0
            tr=self.r[k]+round_int(invtheta*dv,24)
            ts=self.s[k]+round_int(invtheta*dh,24)
            if not (-2**63<=tr<2**63 and -2**63<=ts<2**63):
                raise OverflowError('dual intermediate out of range')
            weight=max(1<<QD, math.isqrt(tr*tr+ts*ts))
            p=(abs(tr)<<QD)//weight*(-1 if tr<0 else 1)
            q=(abs(ts)<<QD)//weight*(-1 if ts<0 else 1)
            rn=p+round_int(beta*(p-self.po[k]),30)
            sn=q+round_int(beta*(q-self.qo[k]),30)
            if not(-2**31<=rn<2**31 and -2**31<=sn<2**31):
                raise OverflowError('extrapolated dual clipped')
            r.append(rn);s.append(sn);po.append(p);qo.append(q)
        self.r,self.s,self.po,self.qo=r,s,po,qo
        return np.array(sol,dtype=np.int64)

class ReferenceCore:
    """Computer-only reference. exact=True uses big-integer Gx and exact RTL TV."""
    def __init__(self, root=ROOT, exact=True):
        self.meta=json.loads((root/'reports/gram_export.json').read_text())
        self.h,self.w=self.meta['rows'],self.meta['cols']; self.n=self.h*self.w
        self.g=np.fromfile(root/'data/G_q32_rowmajor.bin',dtype='<i8').reshape(self.n,self.n)
        self.gobj=self.g.astype(object) if exact else self.g.astype(np.float64)/(2.0**32)
        self.tv=ExactTV(self.h,self.w);self.exact=exact
    def matvec(self,x):
        q=quantize(x)
        if self.exact: return np.array(self.gobj@q.astype(object),dtype=np.float64)/(2.0**52)
        return self.gobj@(q/(2.0**20))
    def tv_load(self,b):self.tv.load(quantize(b))
    def tv_iteration(self,theta,inv,beta,reset):
        return self.tv.iteration(theta,inv,beta,reset)/(2.0**20)
    def close(self):pass

class MMIOCore:
    """Use only after new kernel is integrated and driver has DMA-mapped full G.
    G must be physically contiguous, device-visible/coherent, 8-byte aligned,
    below 4 GiB and at least N*N*8 bytes. This class NEVER allocates random DDR.
    A driver must own the G allocation; --ddr-base alone does not make it safe.
    """
    def __init__(self, control_base, gram_dma_address, h=29,w=36, device='/dev/mem',timeout=30):
        if control_base%4096 or gram_dma_address%8 or not 0<=gram_dma_address<2**32:
            raise ValueError('unaligned/out-of-range physical address')
        self.h,self.w,self.n=h,w,h*w;self.timeout=timeout
        self.fd=os.open(device,os.O_RDWR|os.O_SYNC)
        self.mm=mmap.mmap(self.fd,4096,flags=mmap.MAP_SHARED,prot=mmap.PROT_READ|mmap.PROT_WRITE,offset=control_base)
        self.register_address=ctypes.addressof(ctypes.c_char.from_buffer(self.mm))
        self.native=ctypes.CDLL(str(pathlib.Path(__file__).with_name('libhybrid_mmio.so')))
        self.native.hybrid_read32.argtypes=[ctypes.c_void_p,ctypes.c_uint32]
        self.native.hybrid_read32.restype=ctypes.c_uint32
        self.native.hybrid_write32.argtypes=[ctypes.c_void_p,ctypes.c_uint32,ctypes.c_uint32]
        self.native.hybrid_write32.restype=None
        if self.read(0)!=0x48594631: self.close(); raise RuntimeError('new HYF1 kernel ID not present')
        if self.read(0x3c)!=self.n: self.close(); raise RuntimeError('wrong kernel dimensions')
        self.write(0x04,7);self.write(0x14,gram_dma_address)
    def read(self,a):return int(self.native.hybrid_read32(self.register_address,a))
    def write(self,a,v):self.native.hybrid_write32(self.register_address,a,int(v)&0xffffffff)
    def load(self,b):
        self.write(4,1)
        for i,v in enumerate(quantize(b)):
            self.write(0xc,i);self.write(0x10,v);self.write(4,2)
        if self.read(0x38)!=self.n:raise RuntimeError('vector not fully loaded')
    def wait(self):
        end=time.monotonic()+self.timeout
        while True:
            s=self.read(8)
            if s&(8|16):raise RuntimeError('kernel error/saturation: '+hex(s))
            if s&4 and not s&2:return
            if time.monotonic()>end:raise TimeoutError('kernel timeout')
    def matvec_raw(self,x):
        self.load(x);self.write(4,3);self.wait();out=[]
        for i in range(self.n):
            self.write(0xc,i)
            v=sum(self.read(0x28+4*j)<<(32*j) for j in range(4))
            if v&(1<<127):v-=1<<128
            out.append(v)
        return out
    def matvec(self,x):return np.array(self.matvec_raw(x),dtype=np.float64)/(2.0**52)
    def tv_load(self,b):self.load(b)
    def tv_iteration(self,theta,inv,beta,reset):
        self.write(0x18,theta);self.write(0x1c,inv);self.write(0x20,inv>>32);self.write(0x24,beta)
        self.write(4,4 if reset else 5);self.wait();out=[]
        for i in range(self.n):
            self.write(0xc,i);v=self.read(0x28)
            if v&(1<<31):v-=1<<32
            out.append(v/(2.0**20))
        return np.array(out)
    def close(self):
        self.mm.close();os.close(self.fd)

def tv_value(x,h,w):
    a=np.asarray(x).reshape((h,w),order='F')
    dv=np.zeros_like(a);dh=np.zeros_like(a)
    dv[:-1,:]=a[:-1,:]-a[1:,:];dh[:,:-1]=a[:,:-1]-a[:,1:]
    return np.sqrt(dv*dv+dh*dh).sum()

def board_self_test(core):
    if not isinstance(core,MMIOCore):raise ValueError('Board self-test requires real MMIO core')
    def fixture(name,bits):
        values=[int(s,16) for s in (ROOT/'data'/name).read_text().split()]
        return [v-(1<<bits) if v&(1<<(bits-1)) else v for v in values]
    x=np.array(fixture('full_x.mem',32))/(2.0**20)
    expected=fixture('full_gx.mem',112);got=core.matvec_raw(x)
    if got!=expected:raise RuntimeError('Board Gx differs from integer reference')
    cfg=[int(s,16) for s in (ROOT/'data/full_config.mem').read_text().split()]
    b=np.array(fixture('full_tv_b.mem',32))/(2.0**20);ex=fixture('full_tv_expected.mem',32)
    core.tv_load(b)
    for k in range(4):
        got=quantize(core.tv_iteration(cfg[0],cfg[1]+(cfg[2]<<32),cfg[3+k],k==0)).tolist()
        if got!=ex[k*core.n:(k+1)*core.n]:raise RuntimeError('Board TV iteration mismatch '+str(k))
    print('[PASS PHYSICAL BOARD HYF1] 1044 Gx samples and four TV iterations bit-exact',flush=True)

def prox(core,b,theta,max_inner=4096):
    thetaq=int(math.floor(theta*2**32+0.5))
    if not 256<=thetaq<2**32:raise ValueError('TV theta outside validated Q32 hardware range')
    inv=(1<<64)//(8*thetaq)
    core.tv_load(b);old_val=0.;t=1.
    for it in range(max_inner):
        t=(1+math.sqrt(1+4*t*t))/2
        # Author assigns t_old=t before beta, so beta=(t-1)/t here.
        beta=int(math.floor(((t-1)/t)*2**30+0.5))
        sol=core.tv_iteration(thetaq,inv,beta,it==0)
        cur=.5*np.square(b-sol).sum()+theta*tv_value(sol,core.h,core.w)
        rel=abs(cur-old_val)/cur if cur else 0.
        if rel<1e-6:return sol,it+1
        old_val=cur
    raise RuntimeError('TV tolerance not reached; explicit guard, no false convergence')

def reconstruct_channel(core,x0,bias,lam,max_outer=1100):
    """Preserves source spectral-matrix norms, backtracking, and prox-lambda update order."""
    # ARM cost, gradient and line search must use exactly the same Q20 iterate
    # submitted to hardware. Keeping an unquantized momentum point here makes
    # the line search compare different functions and can collapse its step.
    xold=quantize(x0)/(2.0**20);yold=xold.copy();told=1.;step=1e-5;prox_theta=lam*step;trace=[]
    def cost(x):return .5*np.dot(x,core.matvec(x))-np.dot(bias,x)
    for it in range(1,max_outer+1):
        gy=core.matvec(yold);grad=gy-bias;oldc=.5*np.dot(yold,gy)-np.dot(bias,yold)
        # The original updates opts_proj.lambda only inside backtracking, not on step*=5.
        xn,ni=prox(core,yold-step*grad,prox_theta)
        tn=.5*(1+math.sqrt(1+4*told*told));backtracks=0
        while True:
            c=cost(xn);d=xn-yold
            norm2=np.linalg.norm(d.reshape((core.h,core.w),order='F'),2)
            if c<=oldc+np.dot(grad,d)+norm2**2/(2*step):break
            step*=.3;prox_theta=lam*step;backtracks+=1
            if backtracks>80:raise RuntimeError('line search did not accept')
            xn,ni=prox(core,yold-step*grad,prox_theta)
        yn=xn+(told-1)/tn*(xn-xold)
        e=np.linalg.norm((xn-xold).reshape((core.h,core.w),order='F'),2)/core.n
        trace.append(dict(iteration=it,step=step,prox_theta=prox_theta,tv_iterations=ni,backtracks=backtracks,e=float(e),data_cost_minus_constant=float(c)))
        if it==1 or it%10==0:print('ITERATION',it,'TV',ni,'BACKTRACKS',backtracks,'E',float(e),flush=True)
        if it>10 and e<2.4e-6:return xn,trace,True
        xold,yold,told=xn,quantize(yn)/(2.0**20),tn;step*=5
    return xn,trace,False

def main():
    p=argparse.ArgumentParser()
    p.add_argument('--reference',action='store_true',help='Computer reference only, no FPGA accessed')
    p.add_argument('--control-base',type=lambda s:int(s,0));p.add_argument('--gram-dma-address',type=lambda s:int(s,0))
    p.add_argument('--dma-owned-by-driver',action='store_true')
    p.add_argument('--dma-device',help='Driver-owned coherent buffer, normally /dev/penumbra_gram')
    p.add_argument('--max-outer',type=int,default=1100);p.add_argument('--channel',type=int,choices=[0,1,2],default=0)
    p.add_argument('--self-test',action='store_true',help='On board: verify complete Gx and four TV rounds before full solver')
    p.add_argument('--initialization',choices=['exported','arm-ls'],default='arm-ls',help='arm-ls solves G*x=bias on ARM; exported preserves frozen MATLAB operation order')
    p.add_argument('--output-tag',default='',help='Optional result label for a bounded diagnostic run')
    a=p.parse_args();meta=json.loads((ROOT/'reports/gram_export.json').read_text())
    allocation=None
    if a.reference:core=ReferenceCore()
    elif a.control_base is not None and a.dma_device:
        from gram_buffer import GramBuffer
        manifest=json.loads((ROOT/'reports/model_hashes.json').read_text())
        allocation=GramBuffer(ROOT/'data/G_q32_rowmajor.bin',a.dma_device,manifest['G_q32_rowmajor.bin'])
        try:core=MMIOCore(a.control_base,allocation.address)
        except Exception:allocation.close();raise
    elif a.control_base is not None and a.gram_dma_address is not None and a.dma_owned_by_driver:
        core=MMIOCore(a.control_base,a.gram_dma_address)
    else:p.error('Choose --reference, or explicit control/DMA addresses after driver allocation')
    try:
        if a.self_test:
            board_self_test(core);return
        x0=np.fromfile(ROOT/'data/initial_x_q20_rgb.bin',dtype='<i4').reshape((3,1044))[a.channel]/2.**20
        bias=np.fromfile(ROOT/'data/bias_q32_rgb.bin',dtype='<i8').reshape((3,1044))[a.channel]/2.**32
        if a.initialization=='arm-ls':
            g=np.fromfile(ROOT/'data/G_q32_rowmajor.bin',dtype='<i8').reshape((1044,1044))/(2.0**32)
            x0=np.linalg.solve(g,bias)
        x,trace,converged=reconstruct_channel(core,x0,bias,meta['tvLambda'][a.channel],a.max_outer)
        label='reference_CPU' if a.reference else 'FPGA_HYF1'
        if a.output_tag and (not a.output_tag.replace('_','').isalnum()):raise ValueError('Output tag must contain only letters, numbers and underscores')
        out=ROOT/'reports'/('hybrid_'+label+'_channel'+str(a.channel)+('_'+a.output_tag if a.output_tag else ''))
        np.save(str(out)+'.npy',x.reshape((29,36),order='F'))
        pathlib.Path(str(out)+'.json').write_text(json.dumps(dict(scope=label,initialization=a.initialization,converged=converged,trace=trace),indent=2))
        print(label,'iterations',len(trace),'converged',converged,flush=True)
    finally:
        core.close()
        if allocation:allocation.close()
if __name__=='__main__':main()
