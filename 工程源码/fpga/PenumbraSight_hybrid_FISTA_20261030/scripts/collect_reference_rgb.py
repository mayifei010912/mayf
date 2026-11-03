import pathlib,json,numpy as np
r=pathlib.Path(__file__).resolve().parents[1]
xs=[np.load(r/f'reports/hybrid_reference_CPU_channel{c}.npy') for c in range(3)]
np.concatenate([x.reshape(-1,order='F') for x in xs]).astype('<f8').tofile(r/'reports/hybrid_reference_RGB_native.bin')
summary=[]
for c in range(3):
    d=json.loads((r/f'reports/hybrid_reference_CPU_channel{c}.json').read_text())
    trace=d['trace']
    summary.append(dict(channel=c,outer_iterations=len(trace),tolerance_reached=d['converged'],
        last_e=trace[-1]['e'],tv_inner_calls=sum(t['tv_iterations'] for t in trace),
        note='TV calls above count accepted trials only; backtracking trials also execute TV'))
(r/'reports/arm_reference_RGB_summary.json').write_text(json.dumps(dict(scope='CPU exact-integer kernel oracle; NOT board output',channels=summary),indent=2))
print(json.dumps(summary,indent=2))
