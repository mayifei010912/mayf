from pathlib import Path
import os,signal,time,json
root=Path('/root/nlos_stage2/hybrid_fista_20261031')
state={'boot_id':Path('/proc/sys/kernel/random/boot_id').read_text().strip(),'paused':[],'terminated':[],'unbound':[]}
out=root/'preprogram_state.json'
if out.exists():
 previous=json.loads(out.read_text())
 assert previous['boot_id']!=state['boot_id'],'Already quiesced in this boot; inspect before repeating'
 archived=root/('preprogram_state_'+previous['boot_id']+'.json')
 assert not archived.exists(),'Previous boot journal already archived'
 out.rename(archived)
def save():out.write_text(json.dumps(state,indent=2))
save()
processes=[]
for p in Path('/proc').iterdir():
 if not p.name.isdigit() or int(p.name)==os.getpid():continue
 try:cmd=(p/'cmdline').read_bytes().replace(b'\0',b' ').decode(errors='replace')
 except OSError:continue
 if cmd.startswith('python3 /root/nlos_tools/autostart.py'):
  os.kill(int(p.name),signal.SIGSTOP);state['paused'].append({'pid':int(p.name),'cmd':cmd});save()
 if cmd.startswith('python3 /root/nlos_tools/show_fpga_rgb.py') or cmd.startswith('python3 /root/nlos_stage2/fpga_live_trial_20261028/'):
  processes.append((int(p.name),cmd))
for pid,cmd in processes:
 os.kill(pid,signal.SIGTERM);deadline=time.monotonic()+45
 while Path('/proc/%d'%pid).exists() and time.monotonic()<deadline:
  stat=Path('/proc/%d/stat'%pid)
  if stat.exists() and stat.read_text().split()[2]=='Z':break
  time.sleep(.1)
 if Path('/proc/%d/stat'%pid).exists():assert Path('/proc/%d/stat'%pid).read_text().split()[2]=='Z','Display process did not stop'
 state['terminated'].append({'pid':pid,'cmd':cmd});save();print('STOPPED',pid,flush=True)
names=['amba_pl@0:drm_pl_disp_hdmi','amba_pl@0:atk_hdmi_drm','a0060000.v_frmbuf_rd','a0080000.v_frmbuf_rd','a00c0000.v_frmbuf_wr','a0050000.v_tc','a00a0000.v_tc']
for name in names:
 p=Path('/sys/bus/platform/devices')/name
 if not (p/'driver').exists():continue
 assert 'amba_pl' in str((p/'of_node').resolve())
 driver=(p/'driver').resolve()
 (driver/'unbind').write_text(name)
 assert not (p/'driver').exists(),name+' still bound'
 state['unbound'].append({'device':name,'driver':str(driver)});save();print('UNBOUND',name,flush=True)
remaining=[p.name for p in Path('/sys/bus/platform/devices').iterdir() if (p/'driver').exists() and (p/'of_node').exists() and 'amba_pl' in str((p/'of_node').resolve())]
allowed={'a0020000.gpio','a0090000.gpio','a00e0000.gpio','a0030000.clk_wiz'}
assert set(remaining)<=allowed,remaining
state['kept_static_peripherals']=remaining
state['quiesced']=True;save()
print('[PASS BOARD PL QUIESCED] display/DMA clients stopped; static GPIO/clocks preserved',flush=True)
