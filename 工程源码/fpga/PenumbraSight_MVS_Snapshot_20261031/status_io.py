"""Atomic local status files with Windows shared-delete readers and bounded retry.

No board access. A replacement never truncates the previous complete snapshot.
"""
from pathlib import Path
from contextlib import contextmanager
import json,os,time,uuid

@contextmanager
def open_shared_text(path,encoding='utf-8'):
 if os.name!='nt':
  with Path(path).open('r',encoding=encoding) as stream:yield stream
  return
 import ctypes,msvcrt
 from ctypes import wintypes
 kernel=ctypes.WinDLL('kernel32',use_last_error=True)
 create=kernel.CreateFileW
 create.argtypes=[wintypes.LPCWSTR,wintypes.DWORD,wintypes.DWORD,ctypes.c_void_p,wintypes.DWORD,wintypes.DWORD,wintypes.HANDLE]
 create.restype=wintypes.HANDLE
 # GENERIC_READ; FILE_SHARE_READ|WRITE|DELETE; OPEN_EXISTING.
 handle=create(str(Path(path).resolve()),0x80000000,7,None,3,0x80,None)
 if handle==ctypes.c_void_p(-1).value:raise ctypes.WinError(ctypes.get_last_error())
 try:fd=msvcrt.open_osfhandle(handle,os.O_RDONLY|os.O_BINARY)
 except BaseException:
  close=kernel.CloseHandle;close.argtypes=[wintypes.HANDLE];close(handle);raise
 with os.fdopen(fd,'r',encoding=encoding) as stream:yield stream

def read_text(path,encoding='utf-8'):
 with open_shared_text(path,encoding) as stream:return stream.read()

def write_text(path,text,timeout=3.0):
 p=Path(path);temporary=p.with_name(p.name+'.'+uuid.uuid4().hex+'.partial')
 try:
  temporary.write_text(text,encoding='utf-8')
  deadline=time.monotonic()+timeout;delay=.01
  while True:
   try:os.replace(temporary,p);return
   except OSError as error:
    transient=getattr(error,'winerror',None) in (5,32,33) or isinstance(error,PermissionError)
    if not transient or time.monotonic()>=deadline:raise
    time.sleep(min(delay,max(0,deadline-time.monotonic())));delay=min(.1,delay*1.5)
 finally:
  try:temporary.unlink(missing_ok=True)
  except OSError:pass

def write_json(path,data):
 write_text(path,json.dumps(data,ensure_ascii=False,indent=2))
