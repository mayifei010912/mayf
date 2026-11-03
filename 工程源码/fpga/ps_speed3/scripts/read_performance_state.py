from pathlib import Path
import json
r=Path('/root/nlos_stage2/hybrid_fista_20261031/performance_20261031')
for p in sorted(r.glob('*.log')):
 print('PERF_LOG',p.name,'\n'+'\n'.join(p.read_text().splitlines()[-2:]),flush=True)
for p in sorted(r.glob('*_profile.json')):
 print('PERF_PROFILE',p.name,p.read_text(),flush=True)
for p in sorted(r.glob('*_summary.json')):
 print('PERF_SUMMARY',p.name,p.read_text(),flush=True)
