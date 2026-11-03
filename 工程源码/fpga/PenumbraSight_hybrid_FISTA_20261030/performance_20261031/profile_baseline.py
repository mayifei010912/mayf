"""A bounded physical run. Instrumentation does not change the baseline solver."""
from pathlib import Path
import sys,time,json,numpy as np
from collections import defaultdict
R=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(R/'arm'))
from hybrid_solver import MMIOCore,reconstruct_channel
from gram_buffer import GramBuffer

class ProfiledCore(MMIOCore):
 def __init__(self,*args):
  self.times=defaultdict(float);self.calls=defaultdict(int);self.phase='outside';super().__init__(*args)
 def measured(self,name,fn,*args):
  start=time.perf_counter()
  try:return fn(*args)
  finally:self.times[name]+=time.perf_counter()-start;self.calls[name]+=1
 def load(self,b):return self.measured('load_'+self.phase,super().load,b)
 def wait(self):return self.measured('wait_'+self.phase,super().wait)
 def matvec_raw(self,x):
  old=self.phase;self.phase='gx'
  try:return self.measured('gx_total',super().matvec_raw,x)
  finally:self.phase=old
 def tv_iteration(self,*args):
  old=self.phase;self.phase='tv'
  try:return self.measured('tv_total',super().tv_iteration,*args)
  finally:self.phase=old

out=R/'performance_20261031';out.mkdir(exist_ok=True)
assert not (out/'baseline20_profile.json').exists(),'Baseline profile already exists'
start=time.perf_counter();manifest=json.loads((R/'reports/model_hashes.json').read_text())
allocation=GramBuffer(R/'data/G_q32_rowmajor.bin',expected_sha256=manifest['G_q32_rowmajor.bin'])
core=ProfiledCore(0xA2000000,allocation.address)
allocation_seconds=time.perf_counter()-start
try:
 bias=np.fromfile(R/'data/bias_q32_rgb.bin',dtype='<i8').reshape(3,1044)[0]/2.**32
 start=time.perf_counter();g=np.fromfile(R/'data/G_q32_rowmajor.bin',dtype='<i8').reshape(1044,1044)/2.**32
 x0=np.linalg.solve(g,bias);initialization_seconds=time.perf_counter()-start
 start=time.perf_counter();x,trace,converged=reconstruct_channel(core,x0,bias,1000,20);elapsed=time.perf_counter()-start
 t=dict(core.times)
 categories={'Gx_vector_load':t.get('load_gx',0),'Gx_wait':t.get('wait_gx',0),
  'Gx_readback_and_control':t['gx_total']-t.get('load_gx',0)-t.get('wait_gx',0),
  'TV_vector_load':t.get('load_outside',0),'TV_wait':t.get('wait_tv',0),
  'TV_readback_and_control':t['tv_total']-t.get('wait_tv',0),
  'ARM_math_and_scheduling':elapsed-t['gx_total']-t['tv_total']-t.get('load_outside',0)}
 result={'scope':'physical baseline, unchanged solver, red channel 20 iterations','seconds':elapsed,
  'initialization_seconds':initialization_seconds,'allocation_seconds':allocation_seconds,
  'categories_seconds':categories,'calls':dict(core.calls),'iterations':len(trace),'converged':converged,
  'boot_id':Path('/proc/sys/kernel/random/boot_id').read_text().strip()}
 np.save(out/'baseline20_output.npy',x.reshape(29,36,order='F'))
 (out/'baseline20_trace.json').write_text(json.dumps(trace))
 (out/'baseline20_profile.json').write_text(json.dumps(result,indent=2))
 print('PROFILE_JSON:'+json.dumps(result),flush=True)
finally:core.close();allocation.close()
