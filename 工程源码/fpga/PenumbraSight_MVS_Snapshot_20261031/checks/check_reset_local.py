"""Cancellation safety/dispatch tests. No real signals, MMIO, MATLAB or FPGA."""
from pathlib import Path
import json,sys,time,tkinter as tk
from unittest.mock import patch
from PIL import Image
ROOT=Path(__file__).resolve().parents[1];sys.path.insert(0,str(ROOT))
import app,reset_control as rc,reset_board_job as rb,initialize_board,manual_gui,auto_gui
events=[]
class Producer:
 stopped=False;killed=False
 def suspend(self):self.stopped=True;events.append('suspend')
 def wait_stopped(self):assert self.stopped;events.append('confirmed_stop')
 def kill_stopped(self):assert 'idle_reset' in events;self.killed=True;events.append('kill')
 def wait_exit(self):assert self.killed;events.append('exit')
class Hardware:
 def __enter__(self):events.append('map');return self
 def check_identity(self):events.append('identity')
 def wait_idle(self):events.extend(['busy','busy','idle'])
 def reset_idle(self):assert events[-1]=='idle';events.append('idle_reset')
 def __exit__(self,*args):events.append('unmap')
p=Producer();rb.quiesce_and_stop(p,Hardware)
assert events==['suspend','confirmed_stop','map','identity','busy','busy','idle','idle_reset','unmap','kill','exit']
class TimeoutHardware(Hardware):
 def wait_idle(self):raise TimeoutError('still busy')
events.clear();p=Producer()
try:rb.quiesce_and_stop(p,TimeoutHardware)
except TimeoutError:pass
else:raise AssertionError('Timeout ignored')
assert p.stopped and not p.killed and 'idle_reset' not in events

dest=ROOT/'checks'/('reset_local_'+time.strftime('%Y%m%d_%H%M%S'));dest.mkdir()
(dest/'reset_board_job.py').write_bytes((ROOT/'reset_board_job.py').read_bytes())
cfg=json.loads((ROOT/'config.json').read_text());cfg.update(port='FAKE_PORT',open_result=False)
(dest/'config.json').write_text(json.dumps(cfg));(dest/'captures').mkdir();(dest/'jobs').mkdir();(dest/'manual_requests').mkdir()
source=dest/'captures/one_w5472_h3648_pBayerGB12.raw'
with source.open('wb') as f:f.truncate(5472*3648*2)
done=dest/'jobs/20261101_saved_done';done.mkdir();rc.write(done/'status.json',dict(phase='DONE'));rc.write(done/'capture.json',dict(capture_key='done',source_path='old.raw'))
Image.new('RGB',(36,29)).save(done/'reconstruction.png');saved=(done/'reconstruction.png').read_bytes()
current=[None];rpc_calls=[]
class FakeBoard:
 def __init__(self,*a,**kw):pass
 def execute(self,code,timeout=0):
  assert 'reset_board_job.py' in code,'Unexpected board operation in a local test'
  rpc_calls.append(code)
  return 'RESET_RESULT:'+json.dumps(dict(result='RESET',hardware='SIMULATED_IDLE_RESET',job_id=current[0].name,completed_before_reset=False))+'\n'
class Server:
 def __init__(self,*a,**kw):pass
 def serve_forever(self):pass
def processing(self,job,cap):
 assert cap==1100;current[0]=job;rc.write(job/'status.json',dict(phase='BOARD_RUNNING'))
 rc.write(dest/'reset_request.json',dict(run_id=app.ENGINE_ID,request_id='f'*32));raise app.ResetRequested()
with patch.object(app,'ROOT',dest),patch.object(rc,'ROOT',dest),patch.object(app,'BoardRPC',FakeBoard),patch.object(app.http.server,'ThreadingHTTPServer',Server),patch.object(initialize_board,'ensure_ready',lambda *a:None),patch.object(initialize_board,'board_state',lambda *a:{'busy':False}),patch.object(app.App,'install',lambda *a:None),patch.object(app.App,'process',processing),patch.object(sys,'argv',['app.py','--manual','--submit',str(source),'--manual-request','b'*32,'--no-browser']):
 app.main()
 assert rc.read(dest/'reset_status.json')['phase']=='RESETTED'
 assert rc.read(current[0]/'status.json')['phase']=='CANCELLED'
 assert rc.read(dest/'manual_requests'/('b'*32+'.json'))['phase']=='CANCELLED'
 assert (done/'reconstruction.png').read_bytes()==saved and rc.read(done/'status.json')['phase']=='DONE'
 fresh=app.App(dict(cfg,_watch_captures=True));fresh.scan();assert len(list((dest/'jobs').glob('*/status.json')))==2,'Cancelled capture was replayed'
 repeated=fresh.enqueue(source,force=True);assert repeated and repeated!=current[0]
 # The same reset handler must stop automatic processing and clear its queue.
 with patch.object(sys,'argv',['app.py','--no-browser']):app.main()
 assert rc.read(repeated/'status.json')['phase']=='CANCELLED'
assert len(rpc_calls)==2

# CPU preprocessing cancellation must target only the app-owned MATLAB PID.
matlab_job=dest/'jobs/matlab_case';matlab_job.mkdir();rc.write(matlab_job/'status.json',dict(phase='QUEUED'))
kills=[]
rc.write(dest/'reset_request.json',dict(run_id='another_run'))
class Matlab:
 pid=12345
 def poll(self):rc.write(dest/'reset_request.json',dict(run_id=app.ENGINE_ID,request_id='e'*32));return None
 def wait(self,timeout):return 0
with patch.object(app,'ROOT',dest),patch.object(rc,'ROOT',dest),patch.object(app,'BoardRPC',FakeBoard),patch.object(app.subprocess,'Popen',lambda *a,**kw:Matlab()),patch.object(app.subprocess,'run',lambda command,**kw:kills.append(command)):
 try:app.App(dict(cfg,_watch_captures=False)).process(matlab_job,1100)
 except app.ResetRequested:pass
 else:raise AssertionError('MATLAB cancellation did not stop dispatch')
assert kills==[['taskkill','/PID','12345','/T','/F']]

# Hidden GUI reset feedback; mock the controller launch to prevent side effects.
with patch.object(rc,'ROOT',dest),patch.object(manual_gui,'ROOT',dest),patch.object(auto_gui,'ROOT',dest),patch.object(manual_gui,'worker_running',lambda:False),patch.object(auto_gui,'worker_running',lambda:False),patch.object(rc,'backend_running',lambda:False),patch.object(rc.subprocess,'Popen',lambda *a,**kw:object()):
 for cls in [manual_gui.Window,auto_gui.Window]:
  root=tk.Tk();root.withdraw();window=cls(root);window.reset()
  ident=window.reset_id;rc.write(dest/'reset_status.json',dict(phase='RESETTED',request_id=ident,message='已停止并重置'))
  assert window.poll_reset() and window.job is None
  assert str(window.start_button.cget('state'))=='normal'
  assert str(window.reset_button.cget('state'))=='normal'
  root.destroy()
report=dict(result='PASS',real_hardware_accessed=False,real_processes_signalled=False,real_matlab_started=False,pause_then_idle_reset_then_kill_order_verified=True,timeout_never_kills_or_resets_busy_hardware=True,both_dispatch_modes_cancelled=True,raw_and_completed_results_preserved=True,cancelled_photos_not_auto_replayed=True,manual_retry_supported=True,matlab_cancel_scoped_to_owned_PID=True,both_GUI_reset_controls_checked=True,test_directory=str(dest))
(ROOT/'checks/reset_local_report.json').write_text(json.dumps(report,ensure_ascii=False,indent=2),encoding='utf-8')
print(json.dumps(report,ensure_ascii=False,indent=2))
