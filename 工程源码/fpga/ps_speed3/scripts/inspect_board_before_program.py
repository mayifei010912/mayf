from pathlib import Path
import os,json
print('HYBRID_PREPROGRAM_INSPECTION')
for p in Path('/proc').iterdir():
 if not p.name.isdigit():continue
 try:
  cmd=(p/'cmdline').read_bytes().replace(b'\0',b' ').decode(errors='replace')
  if any(k in cmd for k in ['nlos','show_fpga','camera_live','weston','fb-test']):print('PROCESS',p.name,cmd)
 except OSError:pass
for p in Path('/sys/bus/platform/devices').iterdir():
 if not (p/'of_node').exists() or not (p/'driver').exists():continue
 of=str((p/'of_node').resolve())
 if 'amba_pl' in of:print('PL_DRIVER',p.name,(p/'driver').resolve().name,of)
print('INTERRUPTS')
for ln in Path('/proc/interrupts').read_text().splitlines():
 if any(k in ln.lower() for k in ['v_frmbuf','drm','axi','mipi','vcap','gem']):print(ln)
print('HYBRID_PREPROGRAM_INSPECTION_END')
