"""Local automatic-flow and safe-stop checks, with no hardware or MATLAB."""
from pathlib import Path
import json,sys,time,tkinter as tk
from unittest.mock import patch
from PIL import Image
ROOT=Path(__file__).resolve().parents[1];sys.path.insert(0,str(ROOT))
import app,initialize_board,auto_gui
dest=ROOT/'checks'/('auto_local_'+time.strftime('%Y%m%d_%H%M%S'));dest.mkdir()
cfg=json.loads((ROOT/'config.json').read_text());cfg.update(port='FAKE_PORT',open_result=False)
(dest/'config.json').write_text(json.dumps(cfg))
(dest/'captures').mkdir();(dest/'jobs').mkdir()
source=dest/'captures/one_w5472_h3648_pBayerGB12.raw'
with source.open('wb') as f:f.truncate(5472*3648*2)
def fixture(name,phase):
 p=dest/'jobs'/name;p.mkdir();app.write(p/'status.json',{'phase':phase});app.write(p/'capture.json',{'capture_key':name,'source_path':'TEST_ONLY.raw'});return p
active=fixture('20261101_000001_active','BOARD_RUNNING');waiting=fixture('20261101_000002_waiting','QUEUED')
app.write(dest/'auto_stop.json',{'run_id':'stale_previous_run'})
calls=[];clock=[0]
class NeverBoard:
 def __init__(self,*a,**kw):pass
 def execute(self,*a,**kw):raise AssertionError('A local UI check must never access hardware')
class FakeServer:
 def __init__(self,*a,**kw):pass
 def serve_forever(self):pass
def monotonic():clock[0]+=5;return clock[0]
def poll(self,job):
 assert job==active;calls.append(job.name)
 if len(calls)==1:
  assert not app.stop_requested(),'Stale stop request blocked a new run'
  app.write(dest/'auto_stop.json',{'run_id':app.ENGINE_ID})
  return {'phase':'COMPUTING','channel':0,'last_progress':'ITERATION 1 TV 4 BACKTRACKS 0'}
 return {'phase':'DONE','seconds':1,'channels':[{'converged':False}]*3}
def finish(self,job,state):
 app.write(job/'status.json',{'phase':'DONE'});app.write(job/'result_report.json',state)
 Image.new('RGB',(36,29)).save(job/'reconstruction.png');Image.new('RGB',(128,128)).save(job/'wall_preview.png')
 app.dashboard('TEST_ONLY current task completed',job,phase='DONE')
with patch.object(app,'ROOT',dest),patch.object(app,'BoardRPC',NeverBoard),patch.object(app.http.server,'ThreadingHTTPServer',FakeServer),patch.object(initialize_board,'ensure_ready',lambda *args:None),patch.object(app.App,'install',lambda self:None),patch.object(app.App,'poll',poll),patch.object(app.App,'finish',finish),patch.object(app.time,'sleep',lambda _:None),patch.object(app.time,'monotonic',monotonic),patch.object(sys,'argv',['app.py','--no-browser']):
 app.main()
assert len(calls)==2,'Stop interrupted the active task or started another'
assert json.loads((active/'status.json').read_text())['phase']=='DONE'
assert json.loads((waiting/'status.json').read_text())['phase']=='QUEUED'
new_jobs=[p for p in (dest/'jobs').iterdir() if p not in (active,waiting)]
assert len(new_jobs)==1,'New stable RAW not detected exactly once'
assert json.loads((new_jobs[0]/'status.json').read_text())['phase']=='QUEUED'
runtime=json.loads((dest/'ui_status.json').read_text());assert runtime['phase']=='STOPPED' and runtime['mode']=='automatic' and runtime['queue_count']==2
with patch.object(auto_gui,'ROOT',dest),patch.object(auto_gui,'worker_running',lambda:False):
 root=tk.Tk();root.withdraw();window=auto_gui.Window(root);window.poll();root.update_idletasks()
 assert '已停止' in window.status.get()
 assert str(window.start_button.cget('state'))=='normal'
 assert str(window.stop_button.cget('state'))=='disabled'
 assert str(window.result_button.cget('state'))=='normal'
 root.destroy()
report=dict(result='PASS',hardware_accessed=False,matlab_run=False,stable_capture_queued_once=True,stale_stop_ignored=True,current_task_completed_after_stop=True,waiting_tasks_preserved=True,hidden_GUI_status_and_result_buttons_checked=True,test_directory=str(dest))
(ROOT/'checks/auto_gui_local_report.json').write_text(json.dumps(report,ensure_ascii=False,indent=2),encoding='utf-8')
print(json.dumps(report,ensure_ascii=False,indent=2))
