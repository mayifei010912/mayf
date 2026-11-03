from pathlib import Path
import os,subprocess,time,json
r=Path('/root/nlos_stage2/hybrid_fista_20261031');out=r/'performance_20261031'
pre=json.loads((r/'reports/remaining_preflight.json').read_text())
assert pre['boot_id']==Path('/proc/sys/kernel/random/boot_id').read_text().strip()
assert 0<=time.time()-pre['time']<300
assert not (out/'fast_rgb.log').exists()
for p in out.glob('*.pid'):
 q=Path('/proc/'+p.read_text().strip())
 if q.exists():assert (q/'stat').read_text().split()[2]=='Z','Another experiment is running'
env=os.environ.copy();env.update(OPENBLAS_NUM_THREADS='1',OMP_NUM_THREADS='1')
with (out/'fast_rgb.log').open('x') as f:
 p=subprocess.Popen(['python3',str(out/'run_fast_rgb.py')],stdout=f,stderr=subprocess.STDOUT,env=env,start_new_session=True)
(out/'fast_rgb.pid').write_text(str(p.pid));print('FAST_RGB_STARTED',p.pid,flush=True)
