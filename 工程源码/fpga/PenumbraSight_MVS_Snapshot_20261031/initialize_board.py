"""Restore the already validated HYF1 configuration only when a user starts app.py.

This does not synthesize/place/route or install a different kernel. No operation
from this module is executed at import time. The app's exclusive lock is held.
"""
from pathlib import Path
import json,hashlib,subprocess,socket,time,os

ROOT=Path(__file__).resolve().parent
BASE=Path('F:/fpga/PenumbraSight_hybrid_FISTA_20261030')
REMOTE='/root/nlos_stage2/hybrid_fista_20261031'
BIT_SHA='acd983c5a12389b8590e66fd2faeedec519b31fadc508f6b055fa8220c706ff6'

def board_state(rpc):
 code="""from pathlib import Path
import json
r=Path(REMOTE);boot=Path('/proc/sys/kernel/random/boot_id').read_text().strip()
p=r/'reports/physical_hybrid_selftest.json'
tested=json.loads(p.read_text()) if p.exists() else {}
q=r/'preprogram_state.json';pre=json.loads(q.read_text()) if q.exists() else {}
active=r/'mvs_snapshot/active.json';busy=False
if active.exists():
 a=json.loads(active.read_text());proc=Path('/proc/%d'%a['pid'])
 busy=proc.exists() and (proc/'stat').read_text().split()[2]!='Z' and b'board_worker.py' in (proc/'cmdline').read_bytes()
for proc in Path('/proc').iterdir():
 if not proc.name.isdigit():continue
 try:
  cmd=(proc/'cmdline').read_bytes().replace(bytes([0]),b' ');alive=(proc/'stat').read_text().split()[2]!='Z'
 except OSError:continue
 if alive and cmd.startswith(b'python3 /root/nlos_stage2/hybrid_fista_20261031/speed_stage') and b'/validate_speed' in cmd:busy=True
profile_path=r/'reports/active_bit_profile.json'
profile=json.loads(profile_path.read_text()) if profile_path.exists() else {}
profile_sha=profile.get('bit_sha256') if profile.get('boot_id')==boot else None
print('INIT_STATE:'+json.dumps({'boot_id':boot,'ready':tested.get('boot_id')==boot and tested.get('result')=='PASS' and Path('/dev/penumbra_gram').exists(),'quiesced':pre.get('boot_id')==boot and pre.get('quiesced',False),'busy':busy,'profile_sha256':profile_sha}))
""".replace('REMOTE',repr(REMOTE))
 out=rpc.execute(code).replace('\r','')
 return json.loads(next(s[len('INIT_STATE:'):] for s in out.splitlines() if s.startswith('INIT_STATE:')))

def ensure_ready(rpc,config=None):
 config=config or {}
 expected_sha=config.get('bit_sha256',BIT_SHA)
 state=board_state(rpc)
 if state['ready'] and state.get('profile_sha256')==expected_sha:
  print('BOARD_READY: current boot already initialized',flush=True);return
 if state['busy']:raise RuntimeError('板端仍有照片在计算，拒绝重新配置 FPGA')
 bit=Path(config.get('bit_path',str(BASE/'vivado/board_hybrid/board_hybrid.bit')))
 assert hashlib.sha256(bit.read_bytes()).hexdigest()==expected_sha,'已验证 bit 文件发生变化，停止初始化'
 logs=ROOT/'initialization';logs.mkdir(exist_ok=True)
 def remote_script(name,timeout=90):
  print('BOARD_INIT',name,flush=True)
  out=rpc.execute((BASE/'scripts'/name).read_text(encoding='utf-8-sig'),timeout)
  (logs/(name+'.log')).write_text(out,encoding='utf-8')
 if not state['quiesced']:remote_script('quiesce_board_for_hybrid.py')
 # Verify the same boot and absence of legacy display/DMA clients, including retries.
 guard="""from pathlib import Path
import json
r=Path(REMOTE);s=json.loads((r/'preprogram_state.json').read_text())
assert s['quiesced'] and s['boot_id']==BOOT==Path('/proc/sys/kernel/random/boot_id').read_text().strip(),'Board boot changed during initialization'
allowed={'a0020000.gpio','a0090000.gpio','a00e0000.gpio','a0030000.clk_wiz'}
remaining=[p.name for p in Path('/sys/bus/platform/devices').iterdir() if (p/'driver').exists() and (p/'of_node').exists() and 'amba_pl' in str((p/'of_node').resolve())]
assert set(remaining)<=allowed,remaining
for p in Path('/proc').iterdir():
 if not p.name.isdigit():continue
 try:cmd=(p/'cmdline').read_bytes().replace(b'\\0',b' ').decode(errors='replace')
 except OSError:continue
 assert not cmd.startswith(('python3 /root/nlos_tools/show_fpga_rgb.py','python3 /root/nlos_stage2/fpga_live_trial_20261028/')),'Legacy display still running'
print('QUIESCED_FOR_SNAPSHOT')
""".replace('REMOTE',repr(REMOTE)).replace('BOOT',repr(state['boot_id']))
 rpc.execute(guard)
 # Reuse the matching, previously tested module and its normal allocation check.
 remote_script('execute_driver_validation.py')
 proof=logs/'board_quiesced.txt';proof.write_text(json.dumps(state),encoding='utf-8')
 original=(BASE/'scripts/program_new_hybrid.tcl').read_text(encoding='utf-8-sig')
 tcl=logs/'program_verified_hyf1.tcl'
 original=original.replace('$root/vivado/board_hybrid/board_hybrid.bit',bit.as_posix())
 tcl.write_text(original.replace('$root/reports/board_quiesced_20261031.txt',proof.as_posix()),encoding='utf-8')
 def server_up():
  try:
   with socket.create_connection(('127.0.0.1',3121),timeout=.5):return True
  except OSError:return False
 if not server_up():
  serverlog=(logs/'hw_server.log').open('ab')
  subprocess.Popen(['F:/Xilinx/Vivado/2020.2/bin/hw_server.bat','-s','tcp::3121'],stdout=serverlog,stderr=subprocess.STDOUT,creationflags=subprocess.CREATE_NO_WINDOW)
  serverlog.close()
  deadline=time.monotonic()+20
  while not server_up():
   if time.monotonic()>deadline:raise RuntimeError('hw_server 未启动，请查看 initialization/hw_server.log')
   time.sleep(.5)
 print('BOARD_INIT: loading validated bit through JTAG; no new build',flush=True)
 with (logs/'vivado_program.log').open('w',encoding='utf-8') as log:
  result=subprocess.run(['F:/Xilinx/Vivado/2020.2/bin/vivado.bat','-mode','batch','-source',str(tcl),'-log',str(logs/'vivado.log'),'-journal',str(logs/'vivado.jou')],cwd=logs,stdout=log,stderr=subprocess.STDOUT,creationflags=subprocess.CREATE_NO_WINDOW)
 if result.returncode:raise RuntimeError('JTAG 加载失败，请检查下载器连接并查看 initialization/vivado_program.log')
 rpc.execute("from pathlib import Path;assert Path('/proc/sys/kernel/random/boot_id').read_text().strip()=="+repr(state['boot_id']))
 # The existing short physical check creates the same-boot proof required by app.py.
 # This is an initialization check, not a full RAW reconstruction.
 remote_script('run_physical_hybrid_selftest.py',120)
 profile={'boot_id':state['boot_id'],'bit_sha256':expected_sha}
 rpc.execute("from pathlib import Path;p=Path("+repr(REMOTE+'/reports/active_bit_profile.json')+");p.write_text("+repr(json.dumps(profile))+")")
 final_state=board_state(rpc)
 if not final_state['ready'] or final_state.get('profile_sha256')!=expected_sha:raise RuntimeError('开发板初始化未完成')
 print('BOARD_READY: initialization complete',flush=True)
