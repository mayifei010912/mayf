"""Read-only checks before continuing the saved-RAW RGB hardware batch."""
from pathlib import Path
import json, hashlib, subprocess, mmap, ctypes, os, time

r = Path('/root/nlos_stage2/hybrid_fista_20261031')
boot = Path('/proc/sys/kernel/random/boot_id').read_text().strip()
tested = json.loads((r/'reports/physical_hybrid_selftest.json').read_text())
assert boot == tested['boot_id'], 'Board rebooted; re-establish the new-bit test configuration first'
assert tested['result'] == 'PASS'
assert Path('/sys/module/penumbra_gram').exists() and Path('/dev/penumbra_gram').exists()
assert json.loads((r/'preprogram_state.json').read_text())['quiesced']
cpu = Path('/sys/devices/system/cpu/online').read_text().strip()
assert cpu == '0-3'
messages = subprocess.check_output(['dmesg']).decode(errors='replace')
assert 'SError Interrupt on CPU' not in messages and 'Kernel panic' not in messages
active = []
for p in Path('/proc').iterdir():
    if not p.name.isdigit(): continue
    try:
        args = (p/'cmdline').read_bytes().split(b'\0')
        if any(a.endswith(b'/arm/hybrid_solver.py') for a in args): active.append(int(p.name))
    except (FileNotFoundError, PermissionError, ProcessLookupError): pass
assert not active, 'Another solver is active: ' + str(active)
expected = json.loads((r/'reports/model_hashes.json').read_text())
for name, digest in expected.items():
    assert hashlib.sha256((r/'data'/name).read_bytes()).hexdigest() == digest, name + ' changed'
fd = os.open('/dev/mem', os.O_RDWR | os.O_SYNC)
mm = mmap.mmap(fd, 4096, flags=mmap.MAP_SHARED, prot=mmap.PROT_READ|mmap.PROT_WRITE, offset=0xA2000000)
try:
    lib = ctypes.CDLL(str(r/'arm/libhybrid_mmio.so'))
    lib.hybrid_read32.argtypes = [ctypes.c_void_p, ctypes.c_uint32]
    lib.hybrid_read32.restype = ctypes.c_uint32
    address = ctypes.addressof(ctypes.c_char.from_buffer(mm))
    core_id = lib.hybrid_read32(address, 0)
    n = lib.hybrid_read32(address, 0x3c)
    assert core_id == 0x48594631 and n == 1044
finally:
    mm.close(); os.close(fd)
batch = json.loads((r/'reports/raw_rgb_batch.json').read_text())
result = {'boot_id': boot, 'cpu_online': cpu, 'core_id': hex(core_id), 'N': n,
          'active_solver_pids': active, 'driver_loaded': True, 'model_hashes_verified': True,
          'phase': batch['phase'], 'time': time.time(), 'result': 'PASS'}
print(json.dumps(result), flush=True)
(r/'reports/remaining_preflight.json').write_text(json.dumps(result, indent=2))
print('[PASS REMAINING RAW PREFLIGHT]', flush=True)
