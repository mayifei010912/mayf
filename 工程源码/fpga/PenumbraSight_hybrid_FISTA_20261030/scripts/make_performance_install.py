"""Prepare a checksummed serial installer confined to the experimental folder."""
from pathlib import Path
import sys,hashlib,base64,zlib,json
r=Path(__file__).resolve().parents[1];files={}
for name in sys.argv[1:]:
 p=r/'performance_20261031'/name
 assert p.is_file() and p.parent==(r/'performance_20261031')
 d=p.read_bytes();files[name]=[hashlib.sha256(d).hexdigest(),base64.b64encode(zlib.compress(d)).decode()]
code="from pathlib import Path\nimport base64,zlib,hashlib\nr=Path('/root/nlos_stage2/hybrid_fista_20261031/performance_20261031');r.mkdir(exist_ok=True)\nfiles="+repr(files)+"\nfor name,(digest,payload) in files.items():\n assert Path(name).name==name\n data=zlib.decompress(base64.b64decode(payload));assert hashlib.sha256(data).hexdigest()==digest\n p=r/name\n if p.exists():assert hashlib.sha256(p.read_bytes()).hexdigest()==digest,'Different experimental file exists: '+name\n else:p.write_bytes(data)\n print('INSTALLED_EXPERIMENT',name,len(data),digest,flush=True)\n"
(r/'scripts/install_performance_payload.py').write_text(code,encoding='utf-8')
print('Prepared',len(files),'experimental files')
