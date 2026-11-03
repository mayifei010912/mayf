"""Experimental transport only. Arithmetic and stopping rules remain baseline."""
from pathlib import Path
import sys,ctypes,numpy as np
R=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(R/'arm'))
from hybrid_solver import MMIOCore,quantize

class FastMMIOCore(MMIOCore):
 def __init__(self,*args,**kwargs):
  super().__init__(*args,**kwargs)
  try:
   self.bulk=ctypes.CDLL(str(Path(__file__).with_name('libhybrid_bulk_mmio.so')))
   for name,typ in [('hybrid_bulk_load',ctypes.c_int32),('hybrid_bulk_read_gx',ctypes.c_uint32),('hybrid_bulk_read_tv',ctypes.c_int32)]:
    fn=getattr(self.bulk,name);fn.argtypes=[ctypes.c_void_p,ctypes.POINTER(typ),ctypes.c_uint32];fn.restype=ctypes.c_int
   self.gx_words=(ctypes.c_uint32*(self.n*4))()
   self.tv_words=(ctypes.c_int32*self.n)()
  except Exception:self.close();raise
 def load(self,b):
  q=np.ascontiguousarray(quantize(b),dtype=np.int32)
  if q.size!=self.n:raise ValueError('wrong vector length')
  status=self.bulk.hybrid_bulk_load(self.register_address,q.ctypes.data_as(ctypes.POINTER(ctypes.c_int32)),self.n)
  if status:raise RuntimeError('Bulk load status '+str(status))
 def matvec_raw(self,x):
  self.load(x);self.write(4,3);self.wait()
  if self.bulk.hybrid_bulk_read_gx(self.register_address,self.gx_words,self.n):raise RuntimeError('Bulk Gx read failed')
  data=bytes(self.gx_words)
  return [int.from_bytes(data[i*16:(i+1)*16],'little',signed=True) for i in range(self.n)]
 def tv_iteration(self,theta,inv,beta,reset):
  self.write(0x18,theta);self.write(0x1c,inv);self.write(0x20,inv>>32);self.write(0x24,beta)
  self.write(4,4 if reset else 5);self.wait()
  if self.bulk.hybrid_bulk_read_tv(self.register_address,self.tv_words,self.n):raise RuntimeError('Bulk TV read failed')
  return np.ctypeslib.as_array(self.tv_words).astype(np.float64)/(2.0**20)
