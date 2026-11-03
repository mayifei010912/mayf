import importlib.util,json,math,pathlib,sys,hashlib
import numpy as np
ROOT=pathlib.Path(__file__).resolve().parents[1]
sys.path.insert(0,str(ROOT/'arm'))
from hybrid_solver import ExactTV, round_int

def mem(name,values,bits):
    with (ROOT/'data'/name).open('w',encoding='ascii') as f:
        for v in np.asarray(values,dtype=object).flat:f.write(f'{int(v)&((1<<bits)-1):0{(bits+3)//4}x}\n')

def make(tag,h,w,g,x,b,theta):
    n=h*w;gx=g.astype(object)@x.astype(object)
    inv=(1<<64)//(8*theta);tv=ExactTV(h,w);tv.load(b);t=1.;betas=[];sols=[]
    for i in range(4):
        t=(1+math.sqrt(1+4*t*t))/2
        beta=int(math.floor((t-1)/t*2**30+0.5));betas.append(beta)
        sols.extend(tv.iteration(theta,inv,beta,i==0).tolist())
    mem(tag+'_G.mem',g.reshape(-1),64);mem(tag+'_x.mem',x,32);mem(tag+'_gx.mem',gx,112)
    mem(tag+'_tv_b.mem',b,32);mem(tag+'_tv_expected.mem',sols,32)
    mem(tag+'_config.mem',[theta,inv&0xffffffff,inv>>32,*betas],32)
    return dict(pixels=n,gram_coefficients=n*n,tv_iterations=4,thetaQ32=theta,invQ32=inv)

meta=json.loads((ROOT/'reports/gram_export.json').read_text())
n=meta['pixels'];g=np.fromfile(ROOT/'data/G_q32_rowmajor.bin',dtype='<i8').reshape(n,n)
x=np.fromfile(ROOT/'data/initial_x_q20_rgb.bin',dtype='<i4')[:n].astype(np.int64)
bias=np.fromfile(ROOT/'data/bias_q32_rgb.bin',dtype='<i8')[:n].astype(object)
grad=g.astype(object)@x.astype(object)-(bias<<20)
b=np.array([int(v)-round_int(int(d)*int(meta['safeStepQ48']),80) for v,d in zip(x,grad)],dtype=np.int64)
full=make('full',29,36,g,x,b,int(meta['thetaQ32']))
rng=np.random.default_rng(420)
sg=rng.integers(-(1<<47),1<<47,size=(12,12),dtype=np.int64)
sx=np.array([(-1 if i%2 else 1)*(i+1)*23571 for i in range(12)],dtype=np.int64)
sb=np.array([(-1 if i%3 else 1)*(i+1)*315571 for i in range(12)],dtype=np.int64)
small=make('small',3,4,sg,sx,sb,19545433)
report=dict(full=full,small=small,sourceA=meta['sourceSHA256'],reference='independent Python big-integer MAC, integer sqrt/division TV, no unknowns allowed')
(ROOT/'reports/test_fixture_report.json').write_text(json.dumps(report,indent=2))
print(json.dumps(report,indent=2))
