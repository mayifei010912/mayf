from pathlib import Path
import json,numpy as np,hashlib
r=Path(__file__).resolve().parents[1];reports=r/'reports';out=r/'performance_20261031'
baseline=json.loads((reports/'physical_rgb_full_comparison.json').read_text())
fast=json.loads((reports/'board_fast_rgb_summary.json').read_text())
short_before=json.loads((reports/'board_baseline20_profile.json').read_text())
short_after=json.loads((reports/'board_fast20_profile.json').read_text())
health=json.loads((reports/'board_performance_end_health.json').read_text())
protected=json.loads((out/'protected_baseline_manifest.json').read_text())
assert len(protected)>10 and all(hashlib.sha256((r/k).read_bytes()).hexdigest()==v for k,v in protected.items())
for name,digest in health['baseline_file_hashes'].items():assert hashlib.sha256((r/name).read_bytes()).hexdigest()==digest
channels=[]
for c in range(3):
 a=np.load(reports/('board_fast_channel%d_output.npy'%c))
 b=np.load(reports/('board_hybrid_FPGA_HYF1_channel%d_raw1100.npy'%c))
 cpu=np.load(reports/('hybrid_reference_CPU_channel%d.npy'%c))
 assert np.array_equal(a,b) and np.array_equal(a,cpu) and a.shape==(29,36)
 d=fast['channels'][c];old=baseline['channels'][c]
 assert d['channel']==c and d['control_path_equal']
 channels.append({**d,'name':'RGB'[c],'baseline_seconds':old['seconds'],
                  'speedup':old['seconds']/d['seconds'],'cpu_array_equal':True})
result={'scope':'Physical saved-RAW RGB; C bulk MMIO only; original RTL, bit, matrix and solver unchanged',
 'baseline_full_RGB_seconds':baseline['total_sequential_compute_seconds'],
 'fast_full_RGB_seconds':fast['total_seconds'],
 'full_RGB_speedup':baseline['total_sequential_compute_seconds']/fast['total_seconds'],
 'all_3132_samples_exact':True,'channels':channels,
 'baseline20_seconds':short_before['seconds'],'fast20_seconds':short_after['seconds'],
 'short_speedup':short_after['speedup'],'short_baseline_categories':short_before['categories_seconds'],
 'short_fast_categories':short_after['categories_seconds'],
 'validated_baseline_files_unchanged':len(protected),'board_health':health,
 'not_realtime':True,'quality_note':'Speed only; reconstruction pixels unchanged. All channels reach 1100 iteration cap without outer convergence.'}
(reports/'performance_comparison.json').write_text(json.dumps(result,indent=2),encoding='utf-8')
print(json.dumps(result,indent=2))
