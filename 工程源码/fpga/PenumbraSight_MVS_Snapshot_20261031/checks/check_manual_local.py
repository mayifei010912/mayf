"""Isolated dispatch checks. Fake board, fake server; never execute FPGA/MATLAB."""
from pathlib import Path
import sys,json,time,hashlib
from unittest.mock import patch
ROOT=Path(__file__).resolve().parents[1];sys.path.insert(0,str(ROOT))
import app,initialize_board
dest=ROOT/'checks'/('local_'+time.strftime('%Y%m%d_%H%M%S'));dest.mkdir()
source=dest/'selected_w5472_h3648_pBayerGB12.raw'
with source.open('wb') as f:f.truncate(5472*3648*2)
cfg=json.loads((ROOT/'config.json').read_text());cfg.update(port='FAKE_PORT',open_result=False)
(dest/'config.json').write_text(json.dumps(cfg))
calls=[]
class NeverBoard:
 def __init__(self,*a,**kw):pass
 def execute(self,*a,**kw):raise AssertionError('Hardware must not be accessed by local checks')
class FakeServer:
 def __init__(self,*a,**kw):pass
 def serve_forever(self):pass
def process(self,job,cap):
 assert not self.cfg['_watch_captures'] and cap==1100
 assert json.loads((job/'capture.json').read_text())['source_path']==str(source)
 calls.append(job.name);app.write(job/'status.json',{'phase':'DONE'})
with patch.object(app,'ROOT',dest),patch.object(app,'BoardRPC',NeverBoard):
 instance=app.App(dict(cfg,_watch_captures=False))
 one=instance.enqueue(source);assert instance.enqueue(source) is None
 two=instance.enqueue(source,force=True);assert one!=two
 (dest/'captures/new_unselected.raw').write_bytes(b'not yet captured')
 instance.scan();assert not instance.observed
 assert len(list((dest/'jobs').glob('*/capture.json')))==2
 for name in ['bad.jpg','bad_pBayerGB12Packed.raw','bad_w100_h200_pBayerGB12.raw','too_small.raw']:
  p=dest/name;p.write_bytes(b'bad')
  try:instance.enqueue(p,force=True)
  except ValueError:pass
  else:raise AssertionError('Invalid input accepted: '+name)
 assert len(list((dest/'jobs').glob('*/capture.json')))==2
 ident='a'*32
 with patch.object(app.http.server,'ThreadingHTTPServer',FakeServer),patch.object(initialize_board,'board_state',lambda rpc:{'busy':False}),patch.object(initialize_board,'ensure_ready',lambda *args:None),patch.object(app.App,'install',lambda self:None),patch.object(app.App,'process',process),patch.object(sys,'argv',['app.py','--manual','--submit',str(source),'--manual-request',ident,'--no-browser']):
  app.main()
 assert len(calls)==1,'Manual command processed unrelated queued jobs'
 state=json.loads((dest/'manual_requests'/(ident+'.json')).read_text())
 assert state['phase']=='DONE' and state['job_id']==calls[0]
 for job in [one,two]:assert json.loads((job/'status.json').read_text())['phase']=='QUEUED'
report=dict(result='PASS',hardware_accessed=False,matlab_run=False,invalid_inputs_rejected=True,auto_dedup_preserved=True,manual_rerun_allowed=True,manual_does_not_scan_captures=True,only_selected_job_dispatched=True,iteration_cap=1100,test_directory=str(dest))
(ROOT/'checks/manual_local_report.json').write_text(json.dumps(report,indent=2),encoding='utf-8')
print(json.dumps(report,ensure_ascii=False,indent=2))
