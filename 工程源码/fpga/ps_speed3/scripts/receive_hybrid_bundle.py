"""UART file receiver. Writes only the isolated new board directory."""
import os,sys,termios,tty,select,time,base64,zlib,hashlib,tarfile,io,json
from pathlib import Path
size=int(sys.argv[1]);sha=sys.argv[2]
root=Path('/root/nlos_stage2/hybrid_fista_20261031');root.mkdir(parents=True,exist_ok=True)
target=root/'bundle.tar.gz';saved=termios.tcgetattr(0)
def reply(s):os.write(1,(s+'\n').encode())
try:
 tty.setraw(0);reply('HYBRID_FAST_SWITCH');termios.tcdrain(1)
 fast=termios.tcgetattr(0);fast[4]=fast[5]=termios.B921600;termios.tcsetattr(0,termios.TCSADRAIN,fast)
 time.sleep(.2);reply('HYBRID_FRAMED_READY')
 buffer=b'';seq=0;received=0;last=time.monotonic()
 with open(str(target)+'.partial','wb') as f:
  while received<size:
   if time.monotonic()-last>20:raise RuntimeError('UART idle timeout')
   if not select.select([0],[],[],1)[0]:continue
   buffer+=os.read(0,8192)
   while b'\n' in buffer:
    line,buffer=buffer.split(b'\n',1)
    if line==b'HYBRID_ABORT':raise RuntimeError('Host aborted transfer')
    try:
     magic,n,payload,crc=line.strip().split(b':');assert magic==b'HYBRID_PKT'
     n=int(n);data=base64.b64decode(payload,validate=True)
     assert zlib.crc32(data)&0xffffffff==int(crc,16) and len(data)<=1024
     if n==seq:
      assert received+len(data)<=size;f.write(data);received+=len(data);seq+=1
     elif n!=seq-1:raise ValueError('sequence')
     last=time.monotonic();reply('HYBRID_ACK:%d'%n)
    except Exception:reply('HYBRID_RETRY:%d'%seq)
    if received==size:break
   if len(buffer)>5000:buffer=b'';reply('HYBRID_RETRY:%d'%seq)
 content=Path(str(target)+'.partial').read_bytes();assert hashlib.sha256(content).hexdigest()==sha
 os.replace(str(target)+'.partial',str(target))
 with tarfile.open(fileobj=io.BytesIO(content),mode='r:gz') as archive:
  for m in archive.getmembers():
   assert m.isfile() and not m.name.startswith('/') and '..' not in Path(m.name).parts
   assert m.size<12000000
   out=root/m.name;out.parent.mkdir(parents=True,exist_ok=True);out.write_bytes(archive.extractfile(m).read())
 manifest=json.loads((root/'reports/model_hashes.json').read_text())
 assert hashlib.sha256((root/'data/G_q32_rowmajor.bin').read_bytes()).hexdigest()==manifest['G_q32_rowmajor.bin']
 reply('HYBRID_FRAMED_COMPLETE:'+sha);termios.tcdrain(1)
finally:termios.tcsetattr(0,termios.TCSADRAIN,saved)
