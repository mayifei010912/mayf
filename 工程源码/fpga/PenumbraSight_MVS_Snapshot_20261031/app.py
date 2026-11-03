from pathlib import Path
import os,sys,json,time,hashlib,base64,zlib,subprocess,uuid,re,shutil,html,threading,functools,http.server,argparse
import numpy as np
from PIL import Image
from serial_rpc import BoardRPC
import reset_control
from status_io import write_json,write_text as atomic_write_text
ROOT=Path(__file__).resolve().parent
BOARD='/root/nlos_stage2/hybrid_fista_20261031/mvs_snapshot'
MANUAL_REQUEST=None
ENGINE_MODE='automatic'
ENGINE_ID=uuid.uuid4().hex
class ResetRequested(Exception):pass

def check_reset():
 if reset_control.requested(ENGINE_ID):raise ResetRequested()

def pause(seconds):
 end=time.monotonic()+seconds
 while time.monotonic()<end:
  check_reset();time.sleep(min(.2,max(0,end-time.monotonic())))

def stop_requested():
 if ENGINE_MODE!='automatic':return False
 try:return json.loads((ROOT/'auto_stop.json').read_text(encoding='utf-8')).get('run_id')==ENGINE_ID
 except (OSError,ValueError):return False

def manual_status(phase,**fields):
 if MANUAL_REQUEST is None:return
 data=json.loads(MANUAL_REQUEST.read_text(encoding='utf-8')) if MANUAL_REQUEST.exists() else {}
 if phase=='FAILED' and data.get('phase')=='CANCELLED':return
 data.update(phase=phase,**fields);write(MANUAL_REQUEST,data)

def validate_raw(path):
 path=Path(path)
 if not path.is_file() or path.suffix.lower()!='.raw':raise ValueError('请选择MVS保存的原始.raw文件；预览PNG/JPG不能代替12位RAW。')
 fmt=re.search(r'_p([^._]+)',path.name,re.I)
 if fmt and fmt[1].lower()!='bayergb12':raise ValueError('像素格式不符：'+fmt[1]+'；需要非Packed的BayerGB12。')
 dims=re.search(r'_w(\d+)_h(\d+)',path.name,re.I)
 if dims and (int(dims[1]),int(dims[2]))!=(5472,3648):raise ValueError('RAW文件名中的分辨率不符，需要5472×3648。')
 stat=path.stat()
 if stat.st_size!=5472*3648*2:raise ValueError('RAW大小不符，需要5472×3648 BayerGB12、每像素16位，共39,923,712字节。')
 return path
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def write(path,data):
 write_json(path,data)
def dashboard(message,job=None,phase='STATUS',**fields):
 queued=0
 for p in (ROOT/'jobs').glob('*/status.json'):
  try:
   if p.parent!=job and json.loads(p.read_text(encoding='utf-8')).get('phase') in ('QUEUED','PREPROCESSING','BOARD_RUNNING'):queued+=1
  except (OSError,ValueError):continue
 runtime=dict(pid=os.getpid(),run_id=ENGINE_ID,mode=ENGINE_MODE,phase=phase,message=message,job_id=job.name if job else None,queue_count=queued,updated_at=time.time(),stop_requested=stop_requested(),supports_reset=True,**fields)
 # Display publication must never abort an already-submitted hardware job.
 try:write(ROOT/'ui_status.json',runtime)
 except OSError as error:print('UI_STATUS_WRITE_DEFERRED',repr(error),flush=True)
 parts=['<html><head><meta charset="utf-8"><meta http-equiv="refresh" content="8"><title>MVS → FPGA</title></head><body style="font:18px sans-serif;background:#101b27;color:white;padding:30px">',
 '<h1>MVS 抓拍 → FPGA 单张重构</h1><p>'+html.escape(message)+'</p>',
 '<p>保存格式：5472×3648 BayerGB12 RAW（每像素16位，低12位有效）。固定场景与相机参数；完整RGB参考耗时约 11.4分钟（不同照片可能变化）。</p>',
 '<p>拍照目录：'+html.escape(str(ROOT/'captures'))+'</p>']
 if job:
  parts.append('<p>任务：'+job.name+'</p>')
  for name,label in [('wall_preview.png','拍摄的墙面采样区（仅预览提亮）'),('reconstruction.png','ARM＋FPGA 重构结果（统一RGB显示比例）')]:
   if (job/name).exists():parts.append('<h3>'+label+'</h3><img style="max-width:900px;image-rendering:pixelated" src="jobs/'+job.name+'/'+name+'">')
 parts.append('<p>重构清晰度未保证；达到迭代上限会明确记录，不伪称收敛。</p></body></html>')
 try:atomic_write_text(ROOT/'status.html',''.join(parts))
 except OSError as error:print('UI_HTML_WRITE_DEFERRED',repr(error),flush=True)
class App:
 def __init__(self,config):
  self.cfg=config;self.rpc=BoardRPC(config['port']);self.observed={}
  (ROOT/'captures').mkdir(exist_ok=True);(ROOT/'jobs').mkdir(exist_ok=True)
  self.known={json.loads(p.read_text(encoding='utf-8'))['capture_key'] for p in (ROOT/'jobs').glob('*/capture.json')}
  self.known.update(reset_control.read(ROOT/'ignored_captures.json',[]))
 def enqueue(self,path,force=False):
  path=validate_raw(path);stat=path.stat();key=hashlib.sha256((str(path.resolve())+str(stat.st_mtime_ns)+str(stat.st_size)).encode()).hexdigest()
  if key in self.known and not force:return
  ident=time.strftime('%Y%m%d_%H%M%S')+'_'+uuid.uuid4().hex[:8];job=ROOT/'jobs'/ident;job.mkdir()
  copied=job/'capture.raw';shutil.copyfile(path,copied)
  if path.stat().st_mtime_ns!=stat.st_mtime_ns or sha(path)!=sha(copied):raise RuntimeError('RAW保存仍在变化，请等待保存完成')
  # Freeze camera calibration per new job; historical jobs retain their mapping.
  mapping_path=ROOT/'camera_mapping.json'
  if mapping_path.exists():shutil.copyfile(mapping_path,job/'camera_mapping.json')
  capture={'capture_key':key,'source_path':str(path),'raw_path':str(copied),'raw_sha256':sha(copied)}
  write(job/'capture.json',capture);write(job/'status.json',{'phase':'QUEUED'});self.known.add(key)
  return job
 def scan(self):
  if not self.cfg.get('_watch_captures',True) or stop_requested() or reset_control.requested(ENGINE_ID):return
  for path in (ROOT/'captures').rglob('*'):
   if not path.is_file() or path.suffix.lower()!='.raw':continue
   st=path.stat();sig=(st.st_size,st.st_mtime_ns);old=self.observed.get(str(path))
   if not old or old[0]!=sig:self.observed[str(path)]=(sig,time.monotonic());continue
   if time.monotonic()-old[1]>=3:
    key=hashlib.sha256((str(path.resolve())+str(st.st_mtime_ns)+str(st.st_size)).encode()).hexdigest()
    if key not in self.known:
     if st.st_size==5472*3648*2:self.enqueue(path)
     else:dashboard('检测到RAW，但大小与约定格式不符，暂不计算：'+path.name)
 def install(self):
  ready=self.rpc.execute("from pathlib import Path;import json;r=Path('/root/nlos_stage2/hybrid_fista_20261031');assert Path('/sys/module/penumbra_gram').exists(),'New FPGA configuration/driver required';assert json.loads((r/'reports/physical_hybrid_selftest.json').read_text())['boot_id']==Path('/proc/sys/kernel/random/boot_id').read_text().strip(),'Board rebooted; initialize verified HYF1 configuration first';print('VERIFIED_BOARD_BOOT_READY')")
  d=(ROOT/'board_worker.py').read_bytes();payload=base64.b64encode(zlib.compress(d)).decode()
  code="from pathlib import Path;import base64,zlib,hashlib;r=Path('"+BOARD+"');r.mkdir(exist_ok=True);(r/'jobs').mkdir(exist_ok=True);d=zlib.decompress(base64.b64decode('"+payload+"'));assert hashlib.sha256(d).hexdigest()=='"+hashlib.sha256(d).hexdigest()+"';p=r/'board_worker.py';assert not p.exists() or p.read_bytes()==d,'Different worker already installed';p.write_bytes(d);print('MVS_WORKER_READY')"
  self.rpc.execute(code)
 def submit(self,job,max_outer):
  report=json.loads((job/'input_report.json').read_text(encoding='utf-8'))
  request={'job_id':job.name,'raw_sha256':report['raw_sha256'],'bias_sha256':report['bias_sha256'],
   'matrix_sha256':report['matrix_sha256'],'max_outer':max_outer}
  data=(job/'bias_q32_rgb.bin').read_bytes();encoded=base64.b64encode(zlib.compress(data)).decode()
  code="""from pathlib import Path
import json,base64,zlib,hashlib,subprocess,os
r=Path(BOARD);j=r/'jobs'/IDENT;j.mkdir(exist_ok=True)
request=REQUEST;data=zlib.decompress(base64.b64decode(PAYLOAD))
assert hashlib.sha256(data).hexdigest()==request['bias_sha256']
if (j/'request.json').exists():assert json.loads((j/'request.json').read_text())==request
else:(j/'request.json').write_text(json.dumps(request));(j/'bias_q32_rgb.bin').write_bytes(data)
active=r/'active.json'
if active.exists():
 a=json.loads(active.read_text());p=Path('/proc/%d'%a['pid'])
 running=p.exists() and (p/'stat').read_text().split()[2]!='Z' and b'board_worker.py' in (p/'cmdline').read_bytes()
 if running:assert a['job_id']==IDENT,'Another snapshot job is still computing'
else:running=False
if not running and not (j/'status.json').exists():
 env=os.environ.copy();env.update(OPENBLAS_NUM_THREADS='1',OMP_NUM_THREADS='1')
 with (j/'compute.log').open('w') as f:p=subprocess.Popen(['python3',str(r/'board_worker.py'),IDENT],stdout=f,stderr=subprocess.STDOUT,env=env,start_new_session=True)
 active.write_text(json.dumps({'job_id':IDENT,'pid':p.pid}))
print('MVS_SUBMITTED')
""".replace('BOARD',repr(BOARD)).replace('IDENT',repr(job.name)).replace('REQUEST',repr(request)).replace('PAYLOAD',repr(encoded))
  self.rpc.execute(code);write(job/'status.json',{'phase':'BOARD_RUNNING','request':request})
 def poll(self,job):
  code="""from pathlib import Path
import json
r=Path(JOB);p=r/'status.json';s=json.loads(p.read_text()) if p.exists() else {'phase':'STARTING'}
t=(r/'compute.log').read_text() if (r/'compute.log').exists() else ''
s['last_progress']=t.splitlines()[-1] if t.splitlines() else ''
if s['phase'] not in ('DONE','FAILED'):
 active=r.parent.parent/'active.json';a=json.loads(active.read_text()) if active.exists() else {}
 proc=Path('/proc/%d'%a.get('pid',-1))
 alive=a.get('job_id')==r.name and proc.exists() and (proc/'stat').read_text().split()[2]!='Z' and b'board_worker.py' in (proc/'cmdline').read_bytes()
 if not alive:
  s=json.loads(p.read_text()) if p.exists() else s
  if s['phase']!='DONE':s.update(phase='FAILED',error='计算进程已退出或板子已重启，请保留 compute.log，不自动重复执行本任务')
print('MVS_STATUS:'+json.dumps(s))
""".replace('JOB',repr(BOARD+'/jobs/'+job.name))
  out=self.rpc.execute(code).replace('\r','');m=re.search(r'(?m)^MVS_STATUS:(\{[^\n]*\})$',out)
  if not m:raise RuntimeError('板端状态返回不完整，请保留日志后重新打开自动处理程序')
  return json.loads(m[1])
 def finish(self,job,state,open_result=True):
  data=self.rpc.download(BOARD+'/jobs/'+job.name+'/result.npy');assert hashlib.sha256(data).hexdigest()==state['result_sha256']
  (job/'reconstruction.npy').write_bytes(data);a=np.load(job/'reconstruction.npy',allow_pickle=False)
  assert a.shape==(29,36,3) and np.all(np.isfinite(a))
  scale=max(float(np.max(a)),np.finfo(float).eps);rgb=np.uint8(np.rint(np.clip(a/scale,0,1)*255))
  # Preserve native signed data and explicitly store the world's x-right view.
  Image.fromarray(rgb).save(job/'reconstruction_native.png')
  world=Image.fromarray(rgb[:,::-1,:]).resize((960,464),Image.Resampling.NEAREST)
  world.save(job/'reconstruction_world_x_right.png')
  display=rgb[:,::-1,:] if self.cfg.get('flip_horizontal',False) else rgb
  Image.fromarray(display).resize((960,464),Image.Resampling.NEAREST).save(job/'reconstruction.png')
  state=dict(state,hardware_profile=self.cfg.get('hardware_profile','baseline'),bit_sha256=self.cfg.get('bit_sha256'))
  write(job/'result_report.json',state)
  write(job/'status.json',{'phase':'DONE','seconds':state['seconds']})
  suffix='；本次达到迭代上限，未判定收敛。' if not all(c['converged'] for c in state['channels']) else '；满足停止条件。'
  dashboard('计算完成，用时 %.1f 分钟。结果已保存'%(state['seconds']/60)+suffix,job,phase='DONE',seconds=state['seconds'])
  if open_result and self.cfg.get('open_result',True):
   try:os.startfile(str(job/'reconstruction.png'))
   except OSError as e:print('结果已保存，系统看图应用未能打开，请在浏览器结果页查看：',e,flush=True)
 def process(self,job,max_outer):
  check_reset()
  status=json.loads((job/'status.json').read_text(encoding='utf-8'))
  if status['phase']!='BOARD_RUNNING':
   dashboard('正在解码RAW并生成本次测量数据……',job,phase='PREPROCESSING')
   write(job/'status.json',{'phase':'PREPROCESSING'})
   # JSON job paths contain only the generated ID; no raw file name enters MATLAB code.
   expr="addpath('"+str(ROOT).replace('\\','/')+"');prepare_job('"+str(job).replace('\\','/')+"')"
   if (job/'input_report.json').exists():
    prepared=json.loads((job/'input_report.json').read_text(encoding='utf-8'))
    assert prepared['raw_sha256']==sha(job/'capture.raw') and prepared['bias_sha256']==sha(job/'bias_q32_rgb.bin')
   else:
    with (job/'matlab.log').open('w',encoding='utf-8') as log:
     p=subprocess.Popen([self.cfg['matlab'],'-batch',expr],stdout=log,stderr=subprocess.STDOUT,cwd=ROOT,creationflags=subprocess.CREATE_NO_WINDOW)
     while p.poll() is None:
      if reset_control.requested(ENGINE_ID):
       # Only this app's own MATLAB process tree; never touch other MATLABs.
       if p.poll() is None:subprocess.run(['taskkill','/PID',str(p.pid),'/T','/F'],stdout=log,stderr=subprocess.STDOUT,creationflags=subprocess.CREATE_NO_WINDOW)
       p.wait(timeout=30);raise ResetRequested()
      time.sleep(.2)
    if p.returncode:raise RuntimeError('RAW预处理失败，详见 '+str(job/'matlab.log'))
   check_reset();self.submit(job,max_outer)
  while True:
   check_reset();self.scan();state=self.poll(job);check_reset();phase=state['phase'];write(job/'progress.json',state)
   print('JOB_STATUS',job.name,phase,state.get('channel'),state.get('last_progress',''),flush=True)
   if phase=='DONE':self.finish(job,state);return
   if phase=='FAILED':raise RuntimeError('板端计算失败：'+state.get('error','未知原因'))
   if phase=='CANCELLED':raise ResetRequested()
   dashboard('开发板计算中：通道 '+str(state.get('channel',0)+1)+'/3；'+state.get('last_progress',''),job,phase='COMPUTING',channel=state.get('channel',0),last_progress=state.get('last_progress',''),iteration_cap=max_outer)
   pause(15)
def main():
 global MANUAL_REQUEST,ENGINE_MODE,ENGINE_ID
 p=argparse.ArgumentParser();p.add_argument('--submit');p.add_argument('--once',action='store_true');p.add_argument('--max-outer',type=int,default=1100);p.add_argument('--no-browser',action='store_true');p.add_argument('--manual',action='store_true');p.add_argument('--manual-request');args=p.parse_args()
 ENGINE_MODE='manual' if args.manual else 'automatic';ENGINE_ID=uuid.uuid4().hex;MANUAL_REQUEST=None
 if args.manual_request:
  if not args.manual or not re.fullmatch('[a-f0-9]{32}',args.manual_request):p.error('Invalid manual request')
  (ROOT/'manual_requests').mkdir(exist_ok=True);MANUAL_REQUEST=ROOT/'manual_requests'/(args.manual_request+'.json')
  if reset_control.read(MANUAL_REQUEST).get('phase')=='CANCELLED':return
  manual_status('INITIALIZING',worker_pid=os.getpid())
 if args.manual:
  if not args.submit:p.error('--manual requires a RAW input')
  validate_raw(args.submit);args.once=True
 config=json.loads((ROOT/'config.json').read_text(encoding='utf-8'))
 config['_watch_captures']=not args.manual
 if config['port']=='auto':
  from serial.tools import list_ports
  ports=[p for p in list_ports.comports() if p.vid==0x1a86 and p.pid==0x7523]
  if len(ports)!=1:raise RuntimeError('需要唯一的 CH340 开发板串口；请接 PS_UART，或在 config.json 指定 port 为 COM编号。当前候选：'+str([p.device for p in ports]))
  config['port']=ports[0].device
 print('UART_PORT',config['port'],flush=True);app=App(config)
 # OS-held lock prevents two watcher instances across normal exit and crashes.
 import msvcrt
 lock=(ROOT/'watcher.lock').open('a+b');lock.seek(0);lock.write(b'1');lock.flush();lock.seek(0)
 try:msvcrt.locking(lock.fileno(),msvcrt.LK_NBLCK,1)
 except OSError:
  if args.manual:raise RuntimeError('自动版或另一个选图任务正在运行。本次没有提交；请等任务完成并关闭原处理窗口后再试。')
  print('自动处理程序已在运行，打开现有结果页面。',flush=True)
  os.startfile('http://127.0.0.1:%d/status.html'%config['dashboard_port']);return
 try:run_session(app,args,config)
 except ResetRequested:
  action=reset_control.read(ROOT/'reset_request.json');ident=action.get('request_id',uuid.uuid4().hex)
  manual_status('RESETTING')
  reset_control.perform_reset(app.rpc,config,ident,app)

def run_session(app,args,config):
 server=http.server.ThreadingHTTPServer(('127.0.0.1',config['dashboard_port']),functools.partial(http.server.SimpleHTTPRequestHandler,directory=str(ROOT)))
 threading.Thread(target=server.serve_forever,daemon=True).start()
 dashboard('正在启动处理服务。',phase='INITIALIZING')
 if not args.no_browser:os.startfile('http://127.0.0.1:%d/status.html'%config['dashboard_port'])
 from initialize_board import ensure_ready,board_state
 dashboard('正在检查开发板状态；重新上电后会加载已验证的计算配置。',phase='INITIALIZING')
 if args.manual and board_state(app.rpc)['busy']:raise RuntimeError('板端仍有任务在计算，请用原自动入口恢复查看，等完成后再提交选图任务。')
 check_reset();ensure_ready(app.rpc,config);check_reset()
 check_reset();app.install();check_reset()
 completed=sorted((ROOT/'jobs').glob('*/reconstruction.png'))
 last_job=completed[-1].parent if completed else None
 dashboard('已就绪，准备处理你选择的RAW。' if args.manual else '已就绪，等待你在 MVS 点击一次抓图。',last_job,phase='WAITING')
 print('READY: 等待 MVS 单张 RAW；浏览器 http://127.0.0.1:%d/status.html'%config['dashboard_port'],flush=True)
 selected=app.enqueue(args.submit,force=args.manual) if args.submit else None
 if args.manual:manual_status('RUNNING',job_id=selected.name,hardware_profile=config.get('hardware_profile'),bit_sha256=config.get('bit_sha256'))
 while True:
  check_reset()
  if stop_requested():dashboard('已停止监听；排队任务保留，下次启动后继续。',last_job,phase='STOPPED');return
  app.scan();pending=[]
  for s in sorted((ROOT/'jobs').glob('*/status.json')):
   if args.manual and s.parent!=selected:continue
   if json.loads(s.read_text(encoding='utf-8'))['phase'] in ['QUEUED','PREPROCESSING','BOARD_RUNNING']:pending.append(s.parent)
  if pending:
   if stop_requested():dashboard('已停止监听；排队任务保留。',last_job,phase='STOPPED');return
   job=pending[0]
   try:app.process(job,args.max_outer)
   except ResetRequested:raise
   except Exception as e:
    previous=json.loads((job/'status.json').read_text(encoding='utf-8'))
    previous['error']=repr(e)
    if str(e).startswith('板端计算失败：'):previous['phase']='FAILED'
    write(job/'status.json',previous);dashboard(str(e),job,phase='FAILED');raise
   last_job=job
   if args.once:
    if args.manual:manual_status('DONE',job_id=job.name,result_path=str(job/'reconstruction.png'))
    return
  elif args.once:return
  else:dashboard('正在监听MVS抓拍，等待新的RAW照片。',last_job,phase='WAITING')
  time.sleep(2)
if __name__=='__main__':
 class Tee:
  def __init__(self,console,log):self.console=console;self.log=log
  def write(self,data):
   self.console.write(data)
   if not self.log.closed:self.log.write(data)
   return len(data)
  def flush(self):
   self.console.flush()
   if not self.log.closed:self.log.flush()
 with (ROOT/'watcher.log').open('a',encoding='utf-8',buffering=1) as log:
  sys.stdout=Tee(sys.stdout,log);sys.stderr=Tee(sys.stderr,log)
  try:main()
  except KeyboardInterrupt:
   print('已停止电脑端监听；已提交的板端计算可在重新启动后继续取回。',flush=True)
   dashboard('电脑端监听已退出；已提交的任务可重新启动后取回。',phase='STOPPED')
  except Exception as e:
   import traceback
   manual_status('FAILED',error=str(e))
   traceback.print_exc();dashboard('程序已停止：'+str(e)+'。请查看 watcher.log，处理后重新打开启动入口。',phase='FAILED')
   raise SystemExit(1)
