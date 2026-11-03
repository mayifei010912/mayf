"""Checked shell RPC over the board's existing UART; port closed between polls."""
from pathlib import Path
import sys,base64,zlib,hashlib,time,re,uuid
sys.path.insert(0,'F:/fpga/PenumbraSight_hybrid_FISTA_20261030/kernel_support/python_deps')
import serial
class BoardRPC:
 def __init__(self,port='COM11'):self.port=port
 def execute(self,code,timeout=30):
  token=uuid.uuid4().hex;payload=base64.b64encode(zlib.compress(code.encode())).decode();digest=hashlib.sha256(code.encode()).hexdigest()
  s=serial.Serial();s.port=self.port;s.baudrate=115200;s.timeout=.15;s.write_timeout=5;s.dtr=False;s.rts=False
  def line(x):s.write((x+'\r').encode())
  def until(pattern,seconds):
   data=b'';end=time.monotonic()+seconds
   while time.monotonic()<end:
    data+=s.read(max(1,s.in_waiting))
    m=re.search(pattern,data.replace(b'\r',b''),re.M)
    if m:return data,m
   raise TimeoutError('Board UART response missing: '+data[-800:].decode(errors='replace'))
  try:
   s.open();s.reset_input_buffer();line('echo MVS_READY_'+token)
   until(('^MVS_READY_'+token+r'\r?$').encode(),5)
   line(': > /tmp/mvs_snapshot_rpc.b64')
   for i in range(0,len(payload),600):
    mark='MVS_ACK_'+token+'_'+str(i)
    line("printf '%s' '"+payload[i:i+600]+"' >> /tmp/mvs_snapshot_rpc.b64; echo "+mark)
    until(('^'+mark+r'\r?$').encode(),5)
   command="import base64,zlib,hashlib;d=zlib.decompress(base64.b64decode(open('/tmp/mvs_snapshot_rpc.b64','rb').read()));assert hashlib.sha256(d).hexdigest()=='"+digest+"';exec(compile(d,'mvs_rpc','exec'))"
   line('python3 -c "'+command+'"; echo MVS_DONE_'+token+':$?')
   data,m=until(('^MVS_DONE_'+token+r':(\d+)\r?$').encode(),timeout)
   text=data.decode(errors='replace')
   if int(m[1]):raise RuntimeError(text[-4000:])
   return text
  finally:
   if s.is_open:s.close()
 def download(self,path):
  assert re.fullmatch(r'/root/nlos_stage2/hybrid_fista_20261031/mvs_snapshot/jobs/[A-Za-z0-9_]+/result.npy',path)
  code="from pathlib import Path;import base64,zlib,hashlib;p=Path("+repr(path)+");d=p.read_bytes();b=base64.b64encode(zlib.compress(d)).decode();print('BLOB_BEGIN:'+hashlib.sha256(d).hexdigest());[print(b[i:i+76]) for i in range(0,len(b),76)];print('BLOB_END')"
  text=self.execute(code,60);m=re.search(r'(?m)^BLOB_BEGIN:([0-9a-f]{64})\s*\n([A-Za-z0-9+/=\s]+?)^BLOB_END',text);assert m
  data=zlib.decompress(base64.b64decode(''.join(m[2].split()),validate=True));assert hashlib.sha256(data).hexdigest()==m[1]
  return data
