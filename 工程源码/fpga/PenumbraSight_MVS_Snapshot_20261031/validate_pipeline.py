from pathlib import Path
import json,hashlib
from app import App
r=Path(__file__).resolve().parent;a=App(json.loads((r/'config.json').read_text()))
raw=Path('C:/Users/马逸飞/Desktop/抓拍图像/Image_20261030160344791_w5472_h3648_pBayerGB12.raw')
assert hashlib.sha256(raw.read_bytes()).hexdigest()=='6142f0186b4d16ab949744b4937dd9cfc9b9fd857d7306e0cdcc97170c9e17ba'
job=a.enqueue(raw)
assert job is not None
(r/'validation_job.txt').write_text(str(job),encoding='utf-8')
print('VALIDATION_JOB',job,flush=True)
print(a.rpc.execute("print('SNAPSHOT_RPC_READY')"),flush=True)
