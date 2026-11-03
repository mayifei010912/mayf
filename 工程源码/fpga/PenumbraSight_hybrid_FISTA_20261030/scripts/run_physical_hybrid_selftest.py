from pathlib import Path
import sys,time,json,hashlib,os
root=Path('/root/nlos_stage2/hybrid_fista_20261031')
sys.path.insert(0,str(root/'arm'))
from hybrid_solver import MMIOCore,board_self_test
from gram_buffer import GramBuffer
assert Path('/dev/penumbra_gram').exists()
assert json.loads((root/'preprogram_state.json').read_text())['quiesced']
manifest=json.loads((root/'reports/model_hashes.json').read_text())
start=time.monotonic()
allocation=GramBuffer(root/'data/G_q32_rowmajor.bin',expected_sha256=manifest['G_q32_rowmajor.bin'])
core=None
try:
 core=MMIOCore(0xA2000000,allocation.address)
 print('PHYSICAL_HYF1_ID',hex(core.read(0)),'N',core.read(0x3c),'DMA',hex(allocation.address),flush=True)
 core.write(4,1)
 for index in range(2):
  core.write(0xc,index);core.write(0x10,0);core.write(4,2)
  assert core.read(0x38)==index+1,'Native register command was not accepted exactly once'
 print('NATIVE_REGISTER_LOAD_PASS 2 sequential entries',flush=True)
 board_self_test(core)
 result={'scope':'physical FPGA Gx and four TV rounds; not complete RAW reconstruction','boot_id':Path('/proc/sys/kernel/random/boot_id').read_text().strip(),'core_id':hex(core.read(0)),'N':core.n,'G_coefficients':core.n**2,'G_outputs_bit_exact':core.n,'TV_rounds_bit_exact':4,'G_sha256':manifest['G_q32_rowmajor.bin'],'dma_address':hex(allocation.address),'seconds':time.monotonic()-start,'result':'PASS'}
 (root/'reports/physical_hybrid_selftest.json').write_text(json.dumps(result,indent=2))
 print(json.dumps(result),flush=True)
finally:
 if core:core.close()
 allocation.close()
