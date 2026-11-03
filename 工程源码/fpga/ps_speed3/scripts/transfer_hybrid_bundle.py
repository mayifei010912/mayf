"""921600 baud, CRC per packet + SHA256 whole bundle; restores 115200 baud."""
import sys,pathlib,hashlib,base64,zlib,time
R=pathlib.Path(__file__).resolve().parents[1]
sys.path.insert(0,str(R/'kernel_support/python_deps'))
import serial
data=(R/'kernel_support/board_bundle.tar.gz').read_bytes();sha=hashlib.sha256(data).hexdigest()
log=[];s=serial.Serial();s.port='COM11';s.baudrate=115200;s.timeout=.1;s.write_timeout=3;s.dtr=False;s.rts=False
def wait(marker,seconds):
 end=time.monotonic()+seconds;b=b''
 while time.monotonic()<end:
  b+=s.read(max(s.in_waiting,1))
  if marker in b:log.append(b.decode(errors='replace'));return b
 raise TimeoutError('Missing UART marker '+repr(marker)+': '+b[-200:].decode(errors='replace'))
try:
 s.open();s.reset_input_buffer()
 s.write(('python3 /tmp/receive_hybrid_bundle.py %d %s\r'%(len(data),sha)).encode())
 wait(b'HYBRID_FAST_SWITCH',8);s.baudrate=921600
 wait(b'HYBRID_FRAMED_READY',5);start=time.monotonic();retries=0
 for seq,off in enumerate(range(0,len(data),1024)):
  chunk=data[off:off+1024]
  packet=b'HYBRID_PKT:'+str(seq).encode()+b':'+base64.b64encode(chunk)+b':'+('%08x'%(zlib.crc32(chunk)&0xffffffff)).encode()+b'\n'
  for attempt in range(5):
   s.write(packet)
   reply=wait(b'\n',3)
   if ('HYBRID_ACK:%d\n'%seq).encode() in reply:break
   retries+=1
  else:raise RuntimeError('Packet rejected: '+str(seq))
  if seq%256==0:print('TRANSFER',min(off+1024,len(data)),'/',len(data),'seconds',round(time.monotonic()-start,1),'retries',retries,flush=True)
 # Final ACK and COMPLETE can arrive together; inspect the buffered transcript.
 complete='HYBRID_FRAMED_COMPLETE:'+sha
 if complete not in ''.join(log):wait(complete.encode(),20)
 print('[PASS HYBRID BUNDLE TRANSFER]',len(data),'bytes',round(time.monotonic()-start,1),'seconds',flush=True)
finally:
 if s.is_open:
  if sys.exc_info()[0]:
   try:s.write(b'HYBRID_ABORT\n');time.sleep(.3)
   except Exception:pass
  s.baudrate=115200;s.close()
 (R/'reports/board_bundle_transfer.log').write_text(''.join(log),encoding='utf-8')
