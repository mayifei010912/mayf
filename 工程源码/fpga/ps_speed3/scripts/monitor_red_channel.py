import pathlib,sys,time,re,json
R=pathlib.Path(__file__).resolve().parents[1]
sys.path.insert(0,str(R/'kernel_support/python_deps'))
import serial
code="from pathlib import Path;import json,time,re;r=Path('/root/nlos_stage2/hybrid_fista_20261031');s=json.loads((r/'reports/raw_rgb_batch.json').read_text());f=r/'reports/hybrid_FPGA_HYF1_channel0_raw1100.json';t=(r/'reports/raw_full_channel0.log').read_text();it=re.findall(r'ITERATION (\\d+)',t);print('PROGRESS_JSON:'+json.dumps({'iteration':int(it[-1]) if it else 0,'elapsed':round(time.time()-s['start'],1),'done':f.exists(),'tail':t.splitlines()[-1] if t.splitlines() else '', 'cpu':Path('/sys/devices/system/cpu/online').read_text().strip()}));print('PROGRESS_END')"
assert len(code)<2000
while True:
 s=serial.Serial();s.port='COM11';s.baudrate=115200;s.timeout=.2;s.write_timeout=3;s.dtr=False;s.rts=False
 try:
  s.open();s.reset_input_buffer();s.write(('python3 -c "'+code+'"\r').encode())
  data=b'';end=time.monotonic()+10
  while time.monotonic()<end:
   data+=s.read(max(s.in_waiting,1))
   if re.search(rb'(?m)^PROGRESS_END\r?$',data):break
  m=re.search(rb'(?m)^PROGRESS_JSON:(\{[^\r\n]+\})\r?$',data)
  if not m:raise RuntimeError('Board progress response missing: '+data[-500:].decode(errors='replace'))
  status=json.loads(m[1]);print(json.dumps(status),flush=True)
  (R/'reports/red_channel_progress.json').write_text(json.dumps(status,indent=2),encoding='utf-8')
  if status['done']:break
  if 'Traceback' in status['tail'] or 'Error' in status['tail']:raise RuntimeError(status['tail'])
 finally:s.close()
 time.sleep(30)
