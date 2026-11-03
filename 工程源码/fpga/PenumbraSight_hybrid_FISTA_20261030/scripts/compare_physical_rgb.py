"""Validate all available physical channels; compose RGB only when all pass."""
from pathlib import Path
import numpy as np,json
r=Path(__file__).resolve().parents[1]
channels=[];physical=[];reference=[]
for c in range(3):
 p=r/('reports/board_hybrid_FPGA_HYF1_channel'+str(c)+'_raw1100.npy')
 if not p.exists():continue
 a=np.load(p);b=np.load(r/('reports/hybrid_reference_CPU_channel'+str(c)+'.npy'))
 da=json.loads(p.with_suffix('.json').read_text(encoding='utf-8'))
 db=json.loads((r/('reports/hybrid_reference_CPU_channel'+str(c)+'.json')).read_text(encoding='utf-8'))
 assert a.shape==b.shape==(29,36) and np.all(np.isfinite(a))
 assert len(da['trace'])==len(db['trace']) and da['converged']==db['converged']
 control_keys=['iteration','step','prox_theta','tv_iterations','backtracks']
 control_equal=all(all(x[k]==y[k] for k in control_keys) for x,y in zip(da['trace'],db['trace']))
 trace_errors={k:max(abs(x[k]-y[k]) for x,y in zip(da['trace'],db['trace'])) for k in ['e','data_cost_minus_constant']}
 trace_close=all(np.allclose([x[k] for x in da['trace']],[x[k] for x in db['trace']],rtol=1e-12,atol=1e-7) for k in trace_errors)
 equal=bool(np.array_equal(a,b))
 meta=json.loads((r/('reports/board_red_full_summary.json' if c==0 else 'reports/board_channel'+str(c)+'_full_summary.json')).read_text(encoding='utf-8'))
 d={'channel':c,'name':'RGB'[c],'samples':int(a.size),'array_equal':equal,
    'max_abs_difference':float(np.max(np.abs(a-b))),
    'relative_L2':float(np.linalg.norm(a-b)/max(np.linalg.norm(b),1e-30)),
    'iterations':len(da['trace']),'converged':da['converged'],
    'control_path_equal':control_equal,'float_trace_within_tolerance':trace_close,
    'float_trace_max_abs_errors':trace_errors,'seconds':meta['seconds'],'boot_id':meta['boot_id']}
 channels.append(d);physical.append(a);reference.append(b)
 assert equal and control_equal and trace_close,'FPGA result or iteration path differs: '+str(c)
summary={'scope':'Physical ARM + FPGA saved real RAW versus the CPU integer kernel reference; not live camera',
 'source_grid':[29,36], 'channels':channels,'complete_RGB':len(channels)==3,
 'total_samples':sum(d['samples'] for d in channels),'all_array_equal':all(d['array_equal'] for d in channels),
 'all_control_paths_equal':all(d['control_path_equal'] for d in channels),
 'all_float_traces_within_tolerance':all(d['float_trace_within_tolerance'] for d in channels),
 'max_abs_difference':max(d['max_abs_difference'] for d in channels),
 'total_sequential_compute_seconds':sum(d['seconds'] for d in channels),
 'all_converged':all(d['converged'] for d in channels),
 'pending_channels':[c for c in range(3) if not any(d['channel']==c for d in channels)],
 'quality_note':'Exact agreement validates hardware arithmetic and scheduling; it does not establish optical reconstruction quality or MATLAB-double bit equivalence.'}
if len(channels)==3:
 a=np.stack(physical,axis=2);b=np.stack(reference,axis=2)
 np.save(r/'reports/physical_rgb_raw1100.npy',a)
 np.save(r/'reports/cpu_rgb_raw1100.npy',b)
 # MATLAB reads each row-major native image with reshape([36,29]) transpose.
 for i,ch in enumerate('rgb'):
  physical[i].astype('<f8').tofile(r/('reports/physical_'+ch+'_native.bin'))
  reference[i].astype('<f8').tofile(r/('reports/cpu_'+ch+'_native.bin'))
(r/'reports/physical_rgb_full_comparison.json').write_text(json.dumps(summary,indent=2),encoding='utf-8')
print(json.dumps(summary,indent=2))
