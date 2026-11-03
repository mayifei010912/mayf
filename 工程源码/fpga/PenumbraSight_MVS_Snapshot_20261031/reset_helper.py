"""Reset an orphaned app job only when no host processing worker owns the UART."""
from pathlib import Path
import sys,json,msvcrt,re,time
from reset_control import ROOT,perform_reset,write,read,cancel_local_queue,finish_reset,ACTIVE_PHASES
from serial_rpc import BoardRPC
ident=sys.argv[1];assert re.fullmatch('[a-f0-9]{32}',ident)
try:
 with (ROOT/'watcher.lock').open('a+b') as lock:
  end=time.monotonic()+180
  while True:
   result=read(ROOT/'reset_status.json')
   if result.get('request_id')==ident and result.get('phase') in ('RESETTED','RESET_FAILED'):raise SystemExit(0)
   try:lock.seek(0);msvcrt.locking(lock.fileno(),msvcrt.LK_NBLCK,1);break
   except OSError:
    if time.monotonic()>end:raise TimeoutError('处理程序未在安全点响应重置，请查看日志；没有强杀任何进程')
    time.sleep(.2)
  result=read(ROOT/'reset_status.json')
  if result.get('request_id')==ident and result.get('phase') in ('RESETTED','RESET_FAILED'):raise SystemExit(0)
  pending=any(read(p).get('phase') in ACTIVE_PHASES for p in (ROOT/'jobs').glob('*/status.json'))
  if not pending:
   finish_reset(ident,dict(hardware='no_pending_job_no_hardware_access',local_jobs_cancelled=cancel_local_queue(ident)));raise SystemExit(0)
  config=json.loads((ROOT/'config.json').read_text(encoding='utf-8'))
  port=config['port']
  if port=='auto':
   from serial.tools import list_ports
   ports=[p.device for p in list_ports.comports() if p.vid==0x1a86 and p.pid==0x7523]
   assert len(ports)==1,'需要唯一的开发板PS_UART串口'
   port=ports[0]
  config['port']=port
  perform_reset(BoardRPC(port),config,ident)
except Exception as e:
 write(ROOT/'reset_status.json',dict(phase='RESET_FAILED',request_id=ident,message='重置未完成：'+str(e)+'。请检查串口与后台占用后重试。'))
 raise
