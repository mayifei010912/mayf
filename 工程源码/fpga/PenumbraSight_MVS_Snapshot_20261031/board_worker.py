"""Job-specific input and output; imports the unchanged validated solver."""
from pathlib import Path
import sys,json,time,hashlib,re,os,traceback
import numpy as np
BASE=Path('/root/nlos_stage2/hybrid_fista_20261031')
APP=BASE/'mvs_snapshot';jobid=sys.argv[1];assert re.fullmatch(r'[A-Za-z0-9_]+',jobid)
job=APP/'jobs'/jobid;request=json.loads((job/'request.json').read_text())
assert request['matrix_sha256']=='724e0eb8eb3734d6d22868354cfe4d17117eb1f318edb0fe526dd172f2cface7'
assert 1<=request.get('max_outer',1100)<=1100
sys.path[:0]=[str(BASE/'performance_20261031'),str(BASE/'arm')]
from hybrid_solver import reconstruct_channel
from gram_buffer import GramBuffer
from fast_mmio import FastMMIOCore
state={'job_id':jobid,'phase':'STARTING','channels':[],'boot_id':Path('/proc/sys/kernel/random/boot_id').read_text().strip()}
def save():
 p=job/'status.partial';p.write_text(json.dumps(state));os.replace(p,job/'status.json')
save();core=allocation=None;start=time.monotonic()
try:
 assert hashlib.sha256((job/'bias_q32_rgb.bin').read_bytes()).hexdigest()==request['bias_sha256']
 manifest=json.loads((BASE/'reports/model_hashes.json').read_text())
 assert manifest['G_q32_rowmajor.bin']=='b70971f7c22c41c7ebf4521845bf8ec20d7c4c011c5da7f60aeab9b94f4ab487'
 allocation=GramBuffer(BASE/'data/G_q32_rowmajor.bin',expected_sha256=manifest['G_q32_rowmajor.bin'])
 core=FastMMIOCore(0xA2000000,allocation.address)
 g=np.fromfile(BASE/'data/G_q32_rowmajor.bin',dtype='<i8').reshape(1044,1044)/2.**32
 biases=np.fromfile(job/'bias_q32_rgb.bin',dtype='<i8');assert biases.size==3132
 biases=biases.reshape(3,1044)/2.**32;images=[]
 for c in range(3):
  state.update(phase='COMPUTING',channel=c);save();print('CHANNEL_BEGIN',c,flush=True);t=time.monotonic()
  x0=np.linalg.solve(g,biases[c])
  x,trace,converged=reconstruct_channel(core,x0,biases[c],1000,request.get('max_outer',1100))
  images.append(x.reshape(29,36,order='F'))
  (job/('trace%d.json'%c)).write_text(json.dumps(trace))
  state['channels'].append({'channel':c,'seconds':time.monotonic()-t,'iterations':len(trace),'converged':converged});save()
 result=np.stack(images,axis=2);np.save(job/'result.npy',result)
 state.update(phase='DONE',seconds=time.monotonic()-start,result_sha256=hashlib.sha256((job/'result.npy').read_bytes()).hexdigest(),
  max_outer=request.get('max_outer',1100),input=request);save()
 print('MVS_JOB_COMPLETE',jobid,flush=True)
except Exception as e:
 state.update(phase='FAILED',error=repr(e));save();traceback.print_exc();raise
finally:
 if core:core.close()
 if allocation:allocation.close()
