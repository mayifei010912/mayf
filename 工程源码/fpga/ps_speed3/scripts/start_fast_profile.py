from pathlib import Path
import os,subprocess,time,json
r=Path('/root/nlos_stage2/hybrid_fista_20261031');out=r/'performance_20261031'
assert (out/'baseline20_profile.json').exists() and not (out/'fast20.log').exists()
for p in out.glob('*.pid'):
 q=Path('/proc/'+p.read_text().strip())
 assert not q.exists() or (q/'stat').read_text().split()[2]=='Z','Another experiment is running'
env=os.environ.copy();env.update(OPENBLAS_NUM_THREADS='1',OMP_NUM_THREADS='1')
with (out/'fast20.log').open('x') as f:
 p=subprocess.Popen(['python3',str(out/'profile_fast.py')],stdout=f,stderr=subprocess.STDOUT,env=env,start_new_session=True)
(out/'fast20.pid').write_text(str(p.pid));print('FAST_PROFILE_STARTED',p.pid,flush=True)
