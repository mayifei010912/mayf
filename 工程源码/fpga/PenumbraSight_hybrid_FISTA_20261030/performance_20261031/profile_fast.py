from pathlib import Path
import sys,time,json,numpy as np
from collections import defaultdict
R=Path(__file__).resolve().parents[1];sys.path.insert(0,str(R/'arm'))
from hybrid_solver import reconstruct_channel,board_self_test
from gram_buffer import GramBuffer
from fast_mmio import FastMMIOCore

class ProfiledFast(FastMMIOCore):
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

out=R/'performance_20261031';assert not (out/'fast20_profile.json').exists()
manifest=json.loads((R/'reports/model_hashes.json').read_text())
allocation=GramBuffer(R/'data/G_q32_rowmajor.bin',expected_sha256=manifest['G_q32_rowmajor.bin'])
core=ProfiledFast(0xA2000000,allocation.address)
try:
 board_self_test(core)
 core.times.clear();core.calls.clear()
 bias=np.fromfile(R/'data/bias_q32_rgb.bin',dtype='<i8').reshape(3,1044)[0]/2.**32
 start=time.perf_counter();g=np.fromfile(R/'data/G_q32_rowmajor.bin',dtype='<i8').reshape(1044,1044)/2.**32
 x0=np.linalg.solve(g,bias);initialization_seconds=time.perf_counter()-start
 start=time.perf_counter();x,trace,converged=reconstruct_channel(core,x0,bias,1000,20);elapsed=time.perf_counter()-start
 baseline=np.load(out/'baseline20_output.npy')
 assert np.array_equal(x.reshape(29,36,order='F'),baseline),'Bulk transport changed results'
 old_trace=json.loads((out/'baseline20_trace.json').read_text())
 assert trace==old_trace,'Bulk transport changed iteration trace on same board'
 t=dict(core.times)
 categories={'Gx_vector_load':t.get('load_gx',0),'Gx_wait':t.get('wait_gx',0),
  'Gx_readback_and_control':t['gx_total']-t.get('load_gx',0)-t.get('wait_gx',0),
  'TV_vector_load':t.get('load_outside',0),'TV_wait':t.get('wait_tv',0),
  'TV_readback_and_control':t['tv_total']-t.get('wait_tv',0),
  'ARM_math_and_scheduling':elapsed-t['gx_total']-t['tv_total']-t.get('load_outside',0)}
 base=json.loads((out/'baseline20_profile.json').read_text())
 result={'scope':'physical C bulk transport, unchanged algorithm, red 20 iterations','seconds':elapsed,
  'initialization_seconds':initialization_seconds,'categories_seconds':categories,'calls':dict(core.calls),
  'iterations':len(trace),'converged':converged,'array_equal_to_baseline':True,'same_board_trace_equal':True,
  'baseline_seconds':base['seconds'],'speedup':base['seconds']/elapsed,
  'boot_id':Path('/proc/sys/kernel/random/boot_id').read_text().strip()}
 np.save(out/'fast20_output.npy',x.reshape(29,36,order='F'))
 (out/'fast20_trace.json').write_text(json.dumps(trace))
 (out/'fast20_profile.json').write_text(json.dumps(result,indent=2))
 print('FAST_PROFILE_JSON:'+json.dumps(result),flush=True)
finally:core.close();allocation.close()
