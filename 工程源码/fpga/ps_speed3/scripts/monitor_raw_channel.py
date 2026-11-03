"""Host-only serial progress monitor; never starts or alters the solver."""
import pathlib,sys,time,re,json,argparse
R=pathlib.Path(__file__).resolve().parents[1]
sys.path.insert(0,str(R/'kernel_support/python_deps'))
import serial
p=argparse.ArgumentParser();p.add_argument('--channel',type=int,choices=[1,2],required=True)
a=p.parse_args();c=a.channel
code=("from pathlib import Path;import json,time,re;r=Path('/root/nlos_stage2/hybrid_fista_20261031');"
 "s=json.loads((r/'reports/raw_rgb_batch.json').read_text());c="+str(c)+";"
 "f=r/('reports/hybrid_FPGA_HYF1_channel'+str(c)+'_raw1100.json');"
 "t=(r/('reports/raw_full_channel'+str(c)+'.log')).read_text();it=re.findall(r'ITERATION (\\d+)',t);"
 "p=Path('/proc/%d'%s['active_pid']);running=p.exists() and (p/'stat').read_text().split()[2]!='Z';"
 "print('PROGRESS_JSON:'+json.dumps({'channel':c,'iteration':int(it[-1]) if it else 0,"
 "'elapsed':round(time.monotonic()-s['active_started_monotonic'],1),"
 "'done':f.exists(),'running':running,'tail':t.splitlines()[-1] if t.splitlines() else '',"
 "'cpu':Path('/sys/devices/system/cpu/online').read_text().strip(),"
 "'same_boot':Path('/proc/sys/kernel/random/boot_id').read_text().strip()==s['active_boot_id']}));print('PROGRESS_END')")
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
  (R/('reports/channel%d_progress.json'%c)).write_text(json.dumps(status,indent=2),encoding='utf-8')
  assert status['same_boot'] and status['cpu']=='0-3','Board state changed'
  if status['done'] and not status['running']:break
  if not status['running'] or 'Traceback' in status['tail'] or 'Error' in status['tail']:raise RuntimeError(status['tail'])
 finally:s.close()
 time.sleep(30)
