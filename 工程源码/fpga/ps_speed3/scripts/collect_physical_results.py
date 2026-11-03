from pathlib import Path
import os,base64,zlib,hashlib,json
r=Path('/root/nlos_stage2/hybrid_fista_20261031')
p=r/'reports/raw_smoke20_channel0.log'
print('RAW_SMOKE_LOG',p.read_text()[-2500:] if p.exists() else 'missing',flush=True)
pid=int((r/'reports/raw_smoke20.pid').read_text())
running=Path('/proc/%d'%pid).exists()
if running:
 stat=Path('/proc/%d/stat'%pid)
 running=stat.exists() and stat.read_text().split()[2]!='Z'
print('RAW_SMOKE_RUNNING',running,flush=True)
for name in ['reports/physical_hybrid_selftest.json','driver_validation.json','preprogram_state.json','reports/hybrid_FPGA_HYF1_channel0_smoke20.npy','reports/hybrid_FPGA_HYF1_channel0_smoke20.json','reports/raw_smoke20_channel0.log']:
 p=r/name
 if not p.exists():continue
 data=p.read_bytes();payload=base64.b64encode(zlib.compress(data)).decode()
 print('RESULT_FILE_BEGIN',name,hashlib.sha256(data).hexdigest(),flush=True)
 for i in range(0,len(payload),76):print(payload[i:i+76],flush=True)
 print('RESULT_FILE_END',name,flush=True)
print('BOARD_CPU_ONLINE',Path('/sys/devices/system/cpu/online').read_text().strip(),flush=True)
