from pathlib import Path
import json,base64,zlib,hashlib,time,os,signal
r=Path('/root/nlos_stage2/hybrid_fista_20261031')
result=r/'reports/hybrid_FPGA_HYF1_channel0_raw1100.json'
assert result.exists(),'Red channel has not finished'
d=json.loads(result.read_text())
assert len(d['trace'])<=1100
batch=json.loads((r/'reports/raw_rgb_batch.json').read_text())
summary={'scope':'physical ARM+FPGA saved real RAW red channel','iterations':len(d['trace']),'converged':d['converged'],'seconds':result.stat().st_mtime-batch['start'],'remaining_channels':[1,2],'boot_id':Path('/proc/sys/kernel/random/boot_id').read_text().strip()}
(r/'reports/red_full_summary.json').write_text(json.dumps(summary,indent=2))
control=json.loads((r/'reports/raw_batch_control.json').read_text())
assert control['boot_id']==summary['boot_id']
parent=Path('/proc/%d'%control['parent_pid'])
if parent.exists():
 assert b'/root/nlos_stage2/hybrid_fista_20261031/run_full_raw_rgb.py' in (parent/'cmdline').read_bytes()
 assert (parent/'stat').read_text().split()[2]=='T','Scheduling parent was unexpectedly resumed'
 os.kill(control['parent_pid'],signal.SIGTERM);os.kill(control['parent_pid'],signal.SIGCONT)
control['mode']='red channel finished; scheduler terminated; green/blue not started'
(r/'reports/raw_batch_control.json').write_text(json.dumps(control,indent=2))
batch['phase']='RED_COMPLETE_PENDING_GREEN_BLUE';batch['channels']=[{'channel':0,'seconds':summary['seconds'],'iterations':summary['iterations'],'converged':summary['converged']}]
(r/'reports/raw_rgb_batch.json').write_text(json.dumps(batch,indent=2))
for name in ['reports/hybrid_FPGA_HYF1_channel0_raw1100.npy','reports/hybrid_FPGA_HYF1_channel0_raw1100.json','reports/raw_full_channel0.log','reports/red_full_summary.json','reports/raw_batch_control.json']:
 p=r/name;data=p.read_bytes();payload=base64.b64encode(zlib.compress(data)).decode()
 print('RESULT_FILE_BEGIN',name,hashlib.sha256(data).hexdigest(),flush=True)
 for i in range(0,len(payload),76):print(payload[i:i+76],flush=True)
 print('RESULT_FILE_END',name,flush=True)
print(json.dumps(summary),flush=True)
