"""Decode collected result blocks only, verifying every file's SHA256."""
from pathlib import Path
import argparse,re,base64,zlib,hashlib,json
p=argparse.ArgumentParser();p.add_argument('log');a=p.parse_args()
r=Path(__file__).resolve().parents[1]
text=Path(a.log).read_text(encoding='utf-8')
pattern=r'(?m)^RESULT_FILE_BEGIN (\S+) ([0-9a-f]{64})\s*\n([A-Za-z0-9+/=\s]+?)^RESULT_FILE_END \1\s*$'
files=[]
for m in re.finditer(pattern,text):
 name,digest,payload=m.groups();parts=Path(name).parts
 assert not Path(name).is_absolute() and '..' not in parts
 data=zlib.decompress(base64.b64decode(''.join(payload.split()),validate=True))
 assert hashlib.sha256(data).hexdigest()==digest,name+' checksum mismatch'
 target=r/'reports'/('board_'+Path(name).name)
 target.write_bytes(data);files.append({'name':target.name,'bytes':len(data),'sha256':digest})
assert len(files)>=4,'Missing or incomplete transfer blocks'
print(json.dumps(files,indent=2))
