"""One complete color per invocation; requires the verified new kernel and driver."""
from pathlib import Path
import json,subprocess,os,time
r=Path('/root/nlos_stage2/hybrid_fista_20261031')
s=json.loads((r/'reports/raw_rgb_batch.json').read_text())
assert s['phase'] in ['RED_COMPLETE_PENDING_GREEN_BLUE','PARTIAL_COMPLETE_PENDING'],'Inspect current batch before another launch'
preflight=json.loads((r/'reports/remaining_preflight.json').read_text())
boot=Path('/proc/sys/kernel/random/boot_id').read_text().strip()
assert preflight['result']=='PASS' and preflight['boot_id']==boot
assert 0<=time.time()-preflight['time']<300,'Read-only preflight is stale'
for p in Path('/proc').iterdir():
 if not p.name.isdigit():continue
 try:args=(p/'cmdline').read_bytes().split(b'\0')
 except OSError:continue
 assert not any(a.endswith(b'/arm/hybrid_solver.py') for a in args),'Another solver is active'
remaining=[c for c in [1,2] if not (r/('reports/hybrid_FPGA_HYF1_channel'+str(c)+'_raw1100.json')).exists()]
assert remaining,'All RGB outputs already exist'
c=remaining[0]
assert not (r/('reports/hybrid_FPGA_HYF1_channel'+str(c)+'_raw1100.npy')).exists(),'Partial output exists; inspect before launching'
logpath=r/('reports/raw_full_channel'+str(c)+'.log')
assert not logpath.exists(),'Previous channel log exists; inspect before launching'
env=os.environ.copy();env.update(OPENBLAS_NUM_THREADS='1',OMP_NUM_THREADS='1')
log=logpath.open('x')
p=subprocess.Popen(['python3',str(r/'arm/hybrid_solver.py'),'--control-base','0xA2000000','--dma-device','/dev/penumbra_gram','--channel',str(c),'--output-tag','raw1100'],stdout=log,stderr=subprocess.STDOUT,env=env,start_new_session=True)
(r/'reports/raw_single_channel.pid').write_text(str(p.pid))
s.update(phase='RUNNING_SINGLE_CHANNEL_'+str(c),active_channel=c,active_pid=p.pid,
 active_boot_id=boot,active_started=time.time(),active_started_monotonic=time.monotonic())
(r/'reports/raw_rgb_batch.json').write_text(json.dumps(s,indent=2))
print('SINGLE_RAW_CHANNEL_STARTED',c,p.pid,flush=True)
