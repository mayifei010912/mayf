"""Exercise actual Windows sharing locks and local UI publication, no hardware."""
from pathlib import Path
import sys,time,json,threading,ctypes,concurrent.futures
from ctypes import wintypes
from unittest.mock import patch
ROOT=Path(__file__).resolve().parents[1];sys.path.insert(0,str(ROOT))
import status_io as io,app
out=ROOT/'checks'/('status_io_'+time.strftime('%Y%m%d_%H%M%S'));out.mkdir()
p=out/'state.json';io.write_json(p,{'old':True})
kernel=ctypes.WinDLL('kernel32',use_last_error=True);create=kernel.CreateFileW
create.argtypes=[wintypes.LPCWSTR,wintypes.DWORD,wintypes.DWORD,ctypes.c_void_p,wintypes.DWORD,wintypes.DWORD,wintypes.HANDLE];create.restype=wintypes.HANDLE
close=kernel.CloseHandle;close.argtypes=[wintypes.HANDLE];close.restype=wintypes.BOOL
def lock():
 handle=create(str(p),0x80000000,1,None,3,0x80,None)
 assert handle!=ctypes.c_void_p(-1).value
 return handle
h=lock()
def release():time.sleep(.2);assert close(h)
thread=threading.Thread(target=release);thread.start()
io.write_json(p,{'new':True});thread.join()
assert json.loads(io.read_text(p))=={'new':True}
with io.open_shared_text(p) as reader:assert json.loads(reader.read())=={'new':True}
def writer(n):
 for j in range(20):io.write_json(p,{'writer':n,'payload':'x'*4000,'iteration':j})
with concurrent.futures.ThreadPoolExecutor(max_workers=4) as pool:list(pool.map(writer,range(4)))
assert len(json.loads(io.read_text(p))['payload'])==4000
assert not list(out.glob('*.partial'))
h=lock()
try:
 try:io.write_text(p,'new',timeout=.05)
 except PermissionError:pass
 else:raise AssertionError('Lock unexpectedly ignored')
finally:assert close(h)
assert len(json.loads(io.read_text(p))['payload'])==4000
with patch.object(app,'ROOT',out),patch.object(app,'write',side_effect=PermissionError('test lock')),patch.object(app,'atomic_write_text',side_effect=PermissionError('test lock')):
 app.dashboard('still computing',phase='COMPUTING')
report=dict(status='PASS',real_windows_sharing_violation_retry=True,shared_reader_decodes_json=True,
 concurrent_unique_temp_files=True,persistent_lock_preserves_previous=True,ui_failure_does_not_abort_job=True,hardware_access=False)
(ROOT/'checks'/'status_io_report.json').write_text(json.dumps(report,indent=2));print(report)
