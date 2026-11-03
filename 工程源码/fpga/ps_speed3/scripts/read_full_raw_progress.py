from pathlib import Path
import json,time
r=Path('/root/nlos_stage2/hybrid_fista_20261031')
s=json.loads((r/'reports/raw_rgb_batch.json').read_text());print(json.dumps(s),flush=True)
print('BATCH_ELAPSED_SECONDS',round(time.time()-s['start'],1),flush=True)
for c in range(3):
 p=r/('reports/raw_full_channel'+str(c)+'.log')
 if p.exists():print('CHANNEL',c,'\n'+'\n'.join(p.read_text().splitlines()[-2:]),flush=True)
print('CPU_ONLINE',Path('/sys/devices/system/cpu/online').read_text().strip(),flush=True)
