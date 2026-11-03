from pathlib import Path
import json,hashlib
r=Path(__file__).resolve().parents[1]
m=json.loads((r/'reports/package_source_manifest.json').read_text())
p={k:v for k,v in m.items() if k.replace('\\','/').split('/')[0] in ['arm','rtl','matlab']}
assert len(p)>10,'Protected manifest is unexpectedly empty'
bad=[k for k,v in p.items() if hashlib.sha256((r/k).read_bytes()).hexdigest()!=v]
assert not bad,'Validated baseline changed: '+str(bad)
f=r/'performance_20261031/protected_baseline_manifest.json'
if f.exists() and json.loads(f.read_text()):assert json.loads(f.read_text())==p
f.write_text(json.dumps(p,indent=2))
assert hashlib.sha256((r/'vivado/board_hybrid/board_hybrid.bit').read_bytes()).hexdigest()=='acd983c5a12389b8590e66fd2faeedec519b31fadc508f6b055fa8220c706ff6'
print('VALIDATED_BASELINE_UNCHANGED',len(p),'files; routed bit unchanged')
