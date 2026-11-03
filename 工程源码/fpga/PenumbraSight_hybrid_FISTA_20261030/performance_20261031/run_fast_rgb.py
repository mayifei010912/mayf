"""Full physical RGB equivalence test, using only the experimental transport."""
from pathlib import Path
import sys,time,json,numpy as np
R=Path(__file__).resolve().parents[1];out=Path(__file__).resolve().parent
sys.path.insert(0,str(R/'arm'))
from hybrid_solver import reconstruct_channel
from gram_buffer import GramBuffer
from fast_mmio import FastMMIOCore
assert not (out/'fast_rgb_summary.json').exists()
profile=json.loads((out/'fast20_profile.json').read_text())
boot=Path('/proc/sys/kernel/random/boot_id').read_text().strip()
assert profile['array_equal_to_baseline'] and boot==profile['boot_id']
manifest=json.loads((R/'reports/model_hashes.json').read_text())
start=time.monotonic();allocation=GramBuffer(R/'data/G_q32_rowmajor.bin',expected_sha256=manifest['G_q32_rowmajor.bin'])
core=FastMMIOCore(0xA2000000,allocation.address)
state={'scope':'physical C bulk transport; same fixed RAW, matrix, baseline solver and 1100 iteration cap',
 'boot_id':boot,'phase':'STARTING','channels':[],'start_monotonic':start}
def save():(out/'fast_rgb_state.json').write_text(json.dumps(state,indent=2))
save()
try:
 g=np.fromfile(R/'data/G_q32_rowmajor.bin',dtype='<i8').reshape(1044,1044)/2.**32
 biases=np.fromfile(R/'data/bias_q32_rgb.bin',dtype='<i8').reshape(3,1044)/2.**32
 for c in range(3):
  assert not (out/('fast_channel%d_output.npy'%c)).exists()
  state.update(phase='RUNNING',active_channel=c,channel_start_monotonic=time.monotonic());save()
  print('FAST_CHANNEL_BEGIN',c,flush=True)
  channel_start=time.monotonic();x0=np.linalg.solve(g,biases[c])
  x,trace,converged=reconstruct_channel(core,x0,biases[c],1000,1100)
  seconds=time.monotonic()-channel_start;native=x.reshape(29,36,order='F')
  old=np.load(R/('reports/hybrid_FPGA_HYF1_channel%d_raw1100.npy'%c))
  meta=json.loads((R/('reports/hybrid_FPGA_HYF1_channel%d_raw1100.json'%c)).read_text())
  same=np.array_equal(native,old);keys=['iteration','step','prox_theta','tv_iterations','backtracks']
  control_equal=len(trace)==len(meta['trace']) and all(all(a[k]==b[k] for k in keys) for a,b in zip(trace,meta['trace']))
  assert same and control_equal and converged==meta['converged'],'Fast transport differs from validated full output'
  np.save(out/('fast_channel%d_output.npy'%c),native)
  (out/('fast_channel%d_trace.json'%c)).write_text(json.dumps(trace))
  result={'channel':c,'seconds':seconds,'iterations':len(trace),'converged':converged,
   'array_equal_to_baseline':bool(same),'max_abs_difference':float(np.max(np.abs(native-old))),
   'control_path_equal':control_equal,'full_trace_equal':trace==meta['trace']}
  state['channels'].append(result);save();print('FAST_CHANNEL_COMPLETE:'+json.dumps(result),flush=True)
 state.update(phase='COMPLETE',total_seconds=time.monotonic()-start,all_samples_exact=True,total_samples=3132);save()
 (out/'fast_rgb_summary.json').write_text(json.dumps(state,indent=2))
 print('[PASS FAST FULL RGB] 3132 samples unchanged',flush=True)
except Exception as e:
 state.update(phase='FAILED',error=repr(e));save();raise
finally:core.close();allocation.close()
