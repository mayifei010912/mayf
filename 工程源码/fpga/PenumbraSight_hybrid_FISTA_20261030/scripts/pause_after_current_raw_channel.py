from pathlib import Path
import os,signal,json,time
r=Path('/root/nlos_stage2/hybrid_fista_20261031')
s=json.loads((r/'reports/raw_rgb_batch.json').read_text())
assert s['phase']=='RUNNING_CHANNEL_0',s
pid=int((r/'reports/raw_full_batch.pid').read_text())
cmd=Path('/proc/%d/cmdline'%pid).read_bytes()
assert b'/root/nlos_stage2/hybrid_fista_20261031/run_full_raw_rgb.py' in cmd
os.kill(pid,signal.SIGSTOP)
control={'mode':'finish current channel only; scheduling parent paused','parent_pid':pid,'boot_id':Path('/proc/sys/kernel/random/boot_id').read_text().strip(),'time':time.time(),'remaining_channels':[1,2]}
(r/'reports/raw_batch_control.json').write_text(json.dumps(control,indent=2))
print('CURRENT_CHANNEL_CONTINUES_PARENT_PAUSED',pid,flush=True)
