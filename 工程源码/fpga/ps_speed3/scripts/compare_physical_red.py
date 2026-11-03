from pathlib import Path
import json,numpy as np
R=Path(__file__).resolve().parents[1]
a=np.load(R/'reports/board_hybrid_FPGA_HYF1_channel0_raw1100.npy')
b=np.load(R/'reports/hybrid_reference_CPU_channel0.npy')
meta=json.loads((R/'reports/board_red_full_summary.json').read_text())
diff=a-b
summary={**meta,'comparison':'Physical red channel versus CPU integer-core model, same real RAW and measured fixed matrix','samples':int(a.size),'array_equal':bool(np.array_equal(a,b)),'max_abs_difference':float(np.max(np.abs(diff))),'relative_L2':float(np.linalg.norm(diff)/max(np.linalg.norm(b),1e-30))}
(R/'reports/physical_red_full_comparison.json').write_text(json.dumps(summary,indent=2))
a.astype('<f8').tofile(R/'reports/physical_red_native.bin')
b.astype('<f8').tofile(R/'reports/cpu_red_native.bin')
print(json.dumps(summary,indent=2))
