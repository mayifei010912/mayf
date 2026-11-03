from pathlib import Path
import json,base64,zlib,hashlib,subprocess
r=Path('/root/nlos_stage2/hybrid_fista_20261031');out=r/'performance_20261031'
s=json.loads((out/'fast_rgb_summary.json').read_text())
assert s['phase']=='COMPLETE' and s['all_samples_exact'] and len(s['channels'])==3
p=Path('/proc/'+(out/'fast_rgb.pid').read_text().strip())
assert not p.exists() or (p/'stat').read_text().split()[2]=='Z','Fast worker still running'
boot=Path('/proc/sys/kernel/random/boot_id').read_text().strip();assert boot==s['boot_id']
messages=subprocess.check_output(['dmesg']).decode(errors='replace')
health={'boot_id':boot,'cpu_online':Path('/sys/devices/system/cpu/online').read_text().strip(),
 'driver_loaded':Path('/sys/module/penumbra_gram').exists(),
 'bus_error':('SError Interrupt on CPU' in messages or 'Kernel panic' in messages),
 'baseline_file_hashes':{name:hashlib.sha256((r/name).read_bytes()).hexdigest() for name in
  ['arm/hybrid_solver.py','arm/libhybrid_mmio.so','arm/gram_buffer.py','data/G_q32_rowmajor.bin']}}
assert health['cpu_online']=='0-3' and health['driver_loaded'] and not health['bus_error']
(out/'performance_end_health.json').write_text(json.dumps(health,indent=2))
names=['baseline20_profile.json','baseline20_output.npy','baseline20_trace.json','baseline20.log',
 'fast20_profile.json','fast20_output.npy','fast20_trace.json','fast20.log',
 'fast_rgb_summary.json','fast_rgb.log','performance_end_health.json']
for c in range(3):names+=['fast_channel%d_output.npy'%c,'fast_channel%d_trace.json'%c]
for name in names:
 data=(out/name).read_bytes();payload=base64.b64encode(zlib.compress(data)).decode()
 relative='performance_20261031/'+name
 print('RESULT_FILE_BEGIN',relative,hashlib.sha256(data).hexdigest(),flush=True)
 for i in range(0,len(payload),76):print(payload[i:i+76],flush=True)
 print('RESULT_FILE_END',relative,flush=True)
print('[PASS PERFORMANCE RESULTS COLLECTED] 3132 exact outputs, healthy board',flush=True)
