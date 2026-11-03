from pathlib import Path
import os,subprocess,json,time
r=Path('/root/nlos_stage2/hybrid_fista_20261031')
pre=json.loads((r/'reports/remaining_preflight.json').read_text())
assert pre['boot_id']==Path('/proc/sys/kernel/random/boot_id').read_text().strip()
assert 0<=time.time()-pre['time']<600
out=r/'performance_20261031';assert not (out/'baseline20.log').exists()
env=os.environ.copy();env.update(OPENBLAS_NUM_THREADS='1',OMP_NUM_THREADS='1')
with (out/'baseline20.log').open('x') as f:
 p=subprocess.Popen(['python3',str(out/'profile_baseline.py')],stdout=f,stderr=subprocess.STDOUT,env=env,start_new_session=True)
(out/'baseline20.pid').write_text(str(p.pid));print('PROFILE_STARTED',p.pid,flush=True)
