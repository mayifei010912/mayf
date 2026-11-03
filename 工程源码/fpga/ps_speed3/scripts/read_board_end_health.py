from pathlib import Path
import json,subprocess
r=Path('/root/nlos_stage2/hybrid_fista_20261031')
batch=json.loads((r/'reports/raw_rgb_batch.json').read_text())
active=[]
for p in Path('/proc').iterdir():
 if not p.name.isdigit():continue
 try:args=(p/'cmdline').read_bytes().split(b'\0')
 except OSError:continue
 if any(a.endswith(b'/arm/hybrid_solver.py') for a in args):active.append(int(p.name))
messages=subprocess.check_output(['dmesg']).decode(errors='replace')
report={'cpu_online':Path('/sys/devices/system/cpu/online').read_text().strip(),'driver_loaded':Path('/sys/module/penumbra_gram').exists(),'active_solver_pids':active,'boot_id':Path('/proc/sys/kernel/random/boot_id').read_text().strip(),'batch_phase':batch['phase'],'current_boot_bus_error':('SError Interrupt on CPU' in messages or 'Kernel panic' in messages),'current_mode':'new fixed-G FPGA bit; display/autostart paused; compute idle after saved-RAW batch'}
assert report['cpu_online']=='0-3' and report['driver_loaded'] and not active and not report['current_boot_bus_error']
print(json.dumps(report),flush=True)
(r/'reports/end_health.json').write_text(json.dumps(report,indent=2))
print('[PASS END HEALTH]',flush=True)
