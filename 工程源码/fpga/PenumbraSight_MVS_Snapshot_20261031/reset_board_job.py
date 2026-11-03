"""Board-side stop: pause the producer, drain hardware, reset, then terminate.

No FPGA programming, driver unload or DMA allocation is performed. Importing
this module has no effects; run() is called only for an explicit stop/reset.
"""
from pathlib import Path
import os,time,json,signal,ctypes,mmap
BASE=Path('/root/nlos_stage2/hybrid_fista_20261031')

def quiesce_and_stop(process,hardware_factory):
 process.suspend();process.wait_stopped()
 with hardware_factory() as hw:
  hw.check_identity();hw.wait_idle();hw.reset_idle()
 process.kill_stopped();process.wait_exit()

class OwnedProcess:
 def __init__(self,pid,jobid):
  self.pid=int(pid);self.path=Path('/proc')/str(self.pid);self.jobid=jobid
  self.start_tick=self.identity()[0]
 def identity(self):
  stat=(self.path/'stat').read_text();tail=stat[stat.rfind(')')+2:].split()
  argv=[s.decode() for s in (self.path/'cmdline').read_bytes().split(bytes([0])) if s]
  expected=str(BASE/'mvs_snapshot/board_worker.py')
  assert len(argv)>=3 and argv[1]==expected and argv[2]==self.jobid,'Refuse to stop unrelated process'
  return tail[19],tail[0]
 def verify(self):
  tick,state=self.identity();assert tick==self.start_tick,'PID changed';return state
 def suspend(self):self.verify();os.kill(self.pid,signal.SIGSTOP)
 def wait_stopped(self):
  end=time.monotonic()+3
  while self.verify() not in ('T','t'):
   if time.monotonic()>end:raise TimeoutError('Worker did not suspend; no reset or kill performed')
   time.sleep(.01)
  # Let already-issued, barrier-protected MMIO transactions settle.
  time.sleep(.05)
 def kill_stopped(self):
  assert self.verify() in ('T','t');os.kill(self.pid,signal.SIGKILL)
 def wait_exit(self):
  end=time.monotonic()+3
  while self.path.exists():
   try:stat=(self.path/'stat').read_text()
   except FileNotFoundError:return
   state=stat[stat.rfind(')')+2:].split()[0]
   if state=='Z':return
   if time.monotonic()>end:raise TimeoutError('Worker termination not yet confirmed')
   time.sleep(.01)

class NativeMMIO:
 def __enter__(self):
  self.fd=os.open('/dev/mem',os.O_RDWR|os.O_SYNC)
  self.mm=mmap.mmap(self.fd,4096,flags=mmap.MAP_SHARED,prot=mmap.PROT_READ|mmap.PROT_WRITE,offset=0xA2000000)
  self.addr=ctypes.addressof(ctypes.c_char.from_buffer(self.mm))
  self.lib=ctypes.CDLL(str(BASE/'arm/libhybrid_mmio.so'))
  self.lib.hybrid_read32.argtypes=[ctypes.c_void_p,ctypes.c_uint32];self.lib.hybrid_read32.restype=ctypes.c_uint32
  self.lib.hybrid_write32.argtypes=[ctypes.c_void_p,ctypes.c_uint32,ctypes.c_uint32];self.lib.hybrid_write32.restype=None
  return self
 def read(self,a):return int(self.lib.hybrid_read32(self.addr,a))
 def check_identity(self):assert self.read(0)==0x48594631 and self.read(0x3c)==1044,'HYF1 identity mismatch'
 def wait_idle(self):
  end=time.monotonic()+30;idle_since=None
  while True:
   if self.read(8)&2:idle_since=None
   elif idle_since is None:idle_since=time.monotonic()
   elif time.monotonic()-idle_since>=.02:return
   if time.monotonic()>end:raise TimeoutError('FPGA still busy; worker kept suspended, DMA buffer retained; no kill/reset')
   time.sleep(.01)
 def reset_idle(self):
  assert not self.read(8)&2,'Never reset an active DDR command'
  self.lib.hybrid_write32(self.addr,4,7);time.sleep(.02)
  assert not self.read(8)&(2|4|8|16) and self.read(0x38)==0,'Core reset not confirmed'
 def __exit__(self,*args):self.mm.close();os.close(self.fd)

def save(path,data):
 temp=path.with_suffix('.reset.partial');temp.write_text(json.dumps(data));os.replace(temp,path)

def run(expected_sha=None):
 root=BASE/'mvs_snapshot';boot=Path('/proc/sys/kernel/random/boot_id').read_text().strip()
 proof=BASE/'reports/physical_hybrid_selftest.json'
 verified=json.loads(proof.read_text()) if proof.exists() else {}
 ready=verified.get('boot_id')==boot and verified.get('result')=='PASS' and Path('/dev/penumbra_gram').exists()
 profile_path=BASE/'reports/active_bit_profile.json'
 profile=json.loads(profile_path.read_text()) if profile_path.exists() else {}
 if expected_sha:ready=ready and profile.get('boot_id')==boot and profile.get('bit_sha256')==expected_sha
 active=root/'active.json';a=json.loads(active.read_text()) if active.exists() else {}
 jid=a.get('job_id');job=root/'jobs'/str(jid) if jid else None
 if jid:assert all(c.isalnum() or c=='_' for c in jid),'Invalid job ID'
 pid=a.get('pid',-1);proc=Path('/proc')/str(pid)
 prior=json.loads((job/'status.json').read_text()) if job and (job/'status.json').exists() else {}
 if prior.get('boot_id') and prior['boot_id']!=boot:pid=-1;proc=Path('/proc/-1')
 live=False
 if proc.exists() and int(pid)>1:
  try:
   stat=(proc/'stat').read_text();argv=[s.decode() for s in (proc/'cmdline').read_bytes().split(bytes([0])) if s]
   live=stat[stat.rfind(')')+2:].split()[0]!='Z' and len(argv)>=3 and argv[1]==str(root/'board_worker.py') and argv[2]==jid
  except FileNotFoundError:pass
 for p in Path('/proc').iterdir():
  if not p.name.isdigit() or (live and p.name==str(pid)):continue
  try:cmd=(p/'cmdline').read_bytes().replace(bytes([0]),b' ')
  except OSError:continue
  own=cmd.startswith(b'python3 /root/nlos_stage2/hybrid_fista_20261031/mvs_snapshot/board_worker.py')
  other=cmd.startswith((b'python3 /root/nlos_stage2/hybrid_fista_20261031/speed_stage',b'python3 /root/nlos_tools/show_fpga_rgb.py',b'python3 /root/nlos_stage2/fpga_live_trial_20261028/'))
  assert not own and not ((ready or live) and other),'Another hardware producer is active; refuse app reset'
 if live:
  assert ready,'No same-boot hardware proof; no process or MMIO action performed'
  try:
   producer=OwnedProcess(pid,jid);quiesce_and_stop(producer,NativeMMIO)
  except Exception:
   # Completion can race with a click; only treat a genuinely exited process
   # as that race. A suspended producer on a hardware failure stays pinned.
   if proc.exists():
    stat=(proc/'stat').read_text()
    if stat[stat.rfind(')')+2:].split()[0]!='Z':raise
   with NativeMMIO() as hw:hw.check_identity();hw.wait_idle();hw.reset_idle()
 elif ready:
  with NativeMMIO() as hw:hw.check_identity();hw.wait_idle();hw.reset_idle()
 hardware='HYF1_IDLE_RESET_CONFIRMED' if ready else 'not_initialized_no_active_worker'
 state=json.loads((job/'status.json').read_text()) if job and (job/'status.json').exists() else {}
 completed=state.get('phase')=='DONE'
 if job and not completed:
  state.update(phase='CANCELLED',reason='User stop/reset',reset_complete=True,cancelled_at=time.time())
  save(job/'status.json',state)
 if jid:save(active,dict(job_id=jid,pid=0,last_phase='DONE' if completed else 'CANCELLED'))
 return {'result':'RESET','hardware':hardware,'boot_id':boot,'job_id':jid,'completed_before_reset':completed,'job_state':state}

if __name__=='__main__':print('RESET_RESULT:'+json.dumps(run(globals().get('EXPECTED_BIT_SHA'))),flush=True)
