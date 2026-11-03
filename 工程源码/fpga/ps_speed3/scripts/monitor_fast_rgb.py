"""Host progress reader for the isolated bulk-transport equivalence run."""
from pathlib import Path
import sys,time,json,re
R=Path(__file__).resolve().parents[1];sys.path.insert(0,str(R/'kernel_support/python_deps'))
import serial
code="from pathlib import Path;import json,time,re;r=Path('/root/nlos_stage2/hybrid_fista_20261031/performance_20261031');s=json.loads((r/'fast_rgb_state.json').read_text());t=(r/'fast_rgb.log').read_text();seg=t.rsplit('FAST_CHANNEL_BEGIN',1)[-1];it=re.findall(r'ITERATION (\\d+)',seg);p=Path('/proc/'+(r/'fast_rgb.pid').read_text().strip());run=p.exists() and (p/'stat').read_text().split()[2]!='Z';print('PROGRESS_JSON:'+json.dumps({'phase':s['phase'],'channel':s.get('active_channel'),'iteration':int(it[-1]) if it else 0,'completed_channels':[x['channel'] for x in s['channels']],'elapsed':round(time.monotonic()-s['start_monotonic'],1),'running':run,'tail':t.splitlines()[-1] if t else '', 'same_boot':Path('/proc/sys/kernel/random/boot_id').read_text().strip()==s['boot_id']}));print('PROGRESS_END')"
assert len(code)<2000
while True:
 s=serial.Serial();s.port='COM11';s.baudrate=115200;s.timeout=.2;s.write_timeout=3;s.dtr=False;s.rts=False
 try:
  s.open();s.reset_input_buffer();s.write(('python3 -c "'+code+'"\r').encode());data=b'';end=time.monotonic()+10
  while time.monotonic()<end:
   data+=s.read(max(s.in_waiting,1))
   if re.search(rb'(?m)^PROGRESS_END\r?$',data):break
  m=re.search(rb'(?m)^PROGRESS_JSON:(\{[^\r\n]+\})\r?$',data)
  if not m:raise RuntimeError(data[-500:].decode(errors='replace'))
  status=json.loads(m[1]);print(json.dumps(status),flush=True)
  (R/'reports/fast_rgb_progress.json').write_text(json.dumps(status,indent=2))
  assert status['same_boot'] and status['phase']!='FAILED',status
  if status['phase']=='COMPLETE' and not status['running']:break
  assert status['running'],'Worker ended without a complete summary'
 finally:s.close()
 time.sleep(30)
