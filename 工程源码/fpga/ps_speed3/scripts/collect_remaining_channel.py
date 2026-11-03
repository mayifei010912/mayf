"""On-board result collection and batch journal, with no solver or MMIO writes."""
from pathlib import Path
import json,base64,zlib,hashlib,time
import numpy as np
r=Path('/root/nlos_stage2/hybrid_fista_20261031')
s=json.loads((r/'reports/raw_rgb_batch.json').read_text())
c=s['active_channel']
assert c in [1,2] and s['phase']=='RUNNING_SINGLE_CHANNEL_'+str(c)
boot=Path('/proc/sys/kernel/random/boot_id').read_text().strip()
assert boot==s['active_boot_id'],'Board rebooted during this channel'
p=Path('/proc/%d'%s['active_pid'])
assert not p.exists() or (p/'stat').read_text().split()[2]=='Z','Solver still running'
base='reports/hybrid_FPGA_HYF1_channel'+str(c)+'_raw1100'
d=json.loads((r/(base+'.json')).read_text())
v=np.load(r/(base+'.npy'))
assert d['scope']=='FPGA_HYF1' and d['initialization']=='arm-ls'
assert v.shape==(29,36) and np.all(np.isfinite(v))
assert (len(d['trace'])==1100) or (d['converged'] and 10<len(d['trace'])<1100)
summary={'scope':'physical ARM+FPGA saved real RAW channel', 'channel':c,
 'iterations':len(d['trace']),'converged':d['converged'],
 'seconds':(r/(base+'.json')).stat().st_mtime-s['active_started'],
 'boot_id':boot,'last_e':d['trace'][-1]['e']}
summary_path='reports/channel'+str(c)+'_full_summary.json'
(r/summary_path).write_text(json.dumps(summary,indent=2))
assert not any(a['channel']==c for a in s['channels']),'Channel already recorded'
s['channels'].append(summary)
complete=[k for k in range(3) if (r/('reports/hybrid_FPGA_HYF1_channel'+str(k)+'_raw1100.json')).exists()]
s['completed_channels']=complete
s['phase']='COMPLETE' if complete==[0,1,2] else 'PARTIAL_COMPLETE_PENDING'
s['completed_compute_seconds']=sum(a['seconds'] for a in s['channels'])
(r/'reports/raw_rgb_batch.json').write_text(json.dumps(s,indent=2))
for name in [base+'.npy',base+'.json','reports/raw_full_channel'+str(c)+'.log',summary_path,
             'reports/raw_rgb_batch.json','reports/physical_hybrid_selftest.json',
             'reports/remaining_preflight.json','preprogram_state.json','driver_validation.json']:
 data=(r/name).read_bytes();payload=base64.b64encode(zlib.compress(data)).decode()
 print('RESULT_FILE_BEGIN',name,hashlib.sha256(data).hexdigest(),flush=True)
 for i in range(0,len(payload),76):print(payload[i:i+76],flush=True)
 print('RESULT_FILE_END',name,flush=True)
print('CHANNEL_SUMMARY:'+json.dumps(summary),flush=True)
print('[PASS RAW CHANNEL COLLECTED]',c,flush=True)
