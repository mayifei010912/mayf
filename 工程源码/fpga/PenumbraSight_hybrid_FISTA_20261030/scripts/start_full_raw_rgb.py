from pathlib import Path
import subprocess,os
r=Path('/root/nlos_stage2/hybrid_fista_20261031')
worker='''from pathlib import Path
import subprocess,json,os,time
r=Path('/root/nlos_stage2/hybrid_fista_20261031')
status={'scope':'physical ARM + FPGA, saved real RAW, RGB, max 1100 iterations/channel','channels':[],'phase':'STARTING','start':time.time()}
path=r/'reports/raw_rgb_batch.json'
def save():path.write_text(json.dumps(status,indent=2))
save()
env=os.environ.copy();env.update(OPENBLAS_NUM_THREADS='1',OMP_NUM_THREADS='1')
for c in range(3):
 status['phase']='RUNNING_CHANNEL_'+str(c);save();start=time.monotonic()
 with (r/('reports/raw_full_channel'+str(c)+'.log')).open('w') as log:
  result=subprocess.run(['python3',str(r/'arm/hybrid_solver.py'),'--control-base','0xA2000000','--dma-device','/dev/penumbra_gram','--channel',str(c),'--output-tag','raw1100'],stdout=log,stderr=subprocess.STDOUT,env=env)
 if result.returncode:
  status.update(phase='FAILED',failed_channel=c,returncode=result.returncode);save();raise SystemExit(result.returncode)
 trace=json.loads((r/('reports/hybrid_FPGA_HYF1_channel'+str(c)+'_raw1100.json')).read_text())
 status['channels'].append({'channel':c,'seconds':time.monotonic()-start,'iterations':len(trace['trace']),'converged':trace['converged']});save()
status['phase']='COMPLETE';status['total_seconds']=time.time()-status['start'];save()
'''
p=r/'run_full_raw_rgb.py';p.write_text(worker)
assert not (r/'reports/raw_rgb_batch.json').exists(),'Full batch already exists; inspect before launching twice'
log=(r/'reports/raw_full_batch.log').open('w')
proc=subprocess.Popen(['python3',str(p)],stdout=log,stderr=subprocess.STDOUT,start_new_session=True)
(r/'reports/raw_full_batch.pid').write_text(str(proc.pid))
print('FULL_RAW_RGB_STARTED',proc.pid,flush=True)
