"""Shared explicit reset protocol for both GUIs and their processing worker."""
from pathlib import Path
import os,json,time,uuid,sys,subprocess,msvcrt,re,hashlib
ROOT=Path(__file__).resolve().parent
ACTIVE_PHASES={'QUEUED','PREPROCESSING','BOARD_RUNNING'}

def read(path,default=None):
 try:
  from status_io import read_text
  return json.loads(read_text(path))
 except (OSError,ValueError):return {} if default is None else default
def write(path,data):
 from status_io import write_json
 write_json(path,data)
def backend_running():
 with (ROOT/'watcher.lock').open('a+b') as f:
  f.seek(0)
  try:msvcrt.locking(f.fileno(),msvcrt.LK_NBLCK,1)
  except OSError:return True
  f.seek(0);msvcrt.locking(f.fileno(),msvcrt.LK_UNLCK,1)
 return False
def requested(run_id):return read(ROOT/'reset_request.json').get('run_id')==run_id

def cancel_local_queue(request_id):
 cancelled=[]
 for p in (ROOT/'jobs').glob('*/status.json'):
  state=read(p)
  if state.get('phase') in ACTIVE_PHASES:
   state.update(phase='CANCELLED',reason='用户停止并重置',cancelled_at=time.time(),reset_request_id=request_id)
   write(p,state);write(p.parent/'progress.json',state);cancelled.append(p.parent.name)
 for p in (ROOT/'manual_requests').glob('*.json'):
  state=read(p)
  if state.get('phase') in ('STARTING','INITIALIZING','RUNNING','RESETTING'):
   state.update(phase='CANCELLED',reason='用户停止并重置',reset_request_id=request_id);write(p,state)
 # Do not replay already-present capture files after clearing the queue.
 ignored=set(read(ROOT/'ignored_captures.json',[]))
 for p in (ROOT/'captures').rglob('*.raw'):
  if not p.is_file():continue
  st=p.stat();ignored.add(hashlib.sha256((str(p.resolve())+str(st.st_mtime_ns)+str(st.st_size)).encode()).hexdigest())
 write(ROOT/'ignored_captures.json',sorted(ignored));return cancelled

def finish_reset(request_id,result):
 status=dict(phase='RESETTED',request_id=request_id,message='已停止并重置，可重新选择图片或开始监听。',result=result,finished_at=time.time())
 write(ROOT/'reset_status.json',status)
 write(ROOT/'ui_status.json',dict(pid=os.getpid(),run_id='',mode='automatic',phase='RESETTED',message=status['message'],job_id=None,queue_count=0,updated_at=time.time(),supports_reset=True,reset_request_id=request_id))
 return status

def perform_reset(rpc,config,request_id,app=None):
 write(ROOT/'reset_status.json',dict(phase='RESETTING',request_id=request_id,message='正在暂停板端调度并等待FPGA安全空闲…'))
 try:
  code=(ROOT/'reset_board_job.py').read_text(encoding='utf-8')
  out=rpc.execute("exec(compile("+repr(code)+",'reset_board_job.py','exec'),{'__name__':'__main__','EXPECTED_BIT_SHA':"+repr(config.get('bit_sha256'))+"})",50).replace('\r','')
  match=re.search(r'(?m)^RESET_RESULT:(\{.*\})$',out);assert match,'Reset result not returned'
  result=json.loads(match[1]);assert result['result']=='RESET'
  if result.get('completed_before_reset'):
   job=ROOT/'jobs'/result['job_id']
   if job.exists() and not (job/'reconstruction.png').exists():
    if app is None:
     from app import App
     app=App(dict(config,_watch_captures=False))
    app.finish(job,result['job_state'],open_result=False)
  result['local_jobs_cancelled']=cancel_local_queue(request_id)
  return finish_reset(request_id,result)
 except Exception as e:
  message='停止重置未完成：'+str(e)+'。不要假定板端已停，请恢复串口后重试。'
  status=dict(phase='RESET_FAILED',request_id=request_id,message=message)
  write(ROOT/'reset_status.json',status)
  write(ROOT/'ui_status.json',dict(pid=os.getpid(),run_id='',mode='automatic',phase='RESET_FAILED',message=message,job_id=None,queue_count=0,updated_at=time.time(),supports_reset=True,reset_request_id=request_id))
  raise

def request_reset():
 ident=uuid.uuid4().hex;runtime=read(ROOT/'ui_status.json')
 if backend_running():
  if not runtime.get('supports_reset') or not runtime.get('run_id'):
   raise RuntimeError('当前后台仍是旧版，请先关闭旧版处理进程后重开新入口；新按钮不会强行终止旧进程。')
  write(ROOT/'reset_status.json',dict(phase='REQUESTED',request_id=ident,message='已请求停止并重置，等待安全点…'))
  write(ROOT/'reset_request.json',dict(run_id=runtime['run_id'],request_id=ident,requested_at=time.time()))
 else:
  write(ROOT/'reset_status.json',dict(phase='REQUESTED',request_id=ident,message='正在停止并重置…'))
 # The helper only takes over if the main worker has exited before handling
 # the request; the OS lock prevents concurrent UART/hardware operations.
 with (ROOT/'reset.log').open('a',encoding='utf-8') as log:
  subprocess.Popen([str(Path(sys.executable).with_name('python.exe')),'-u',str(ROOT/'reset_helper.py'),ident],cwd=ROOT,stdout=log,stderr=subprocess.STDOUT,creationflags=subprocess.CREATE_NO_WINDOW)
 return ident
