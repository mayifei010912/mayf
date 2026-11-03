import pathlib,json,hashlib,re,py_compile,sys
R=pathlib.Path(__file__).resolve().parents[1]
def sha(p):return hashlib.sha256(pathlib.Path(p).read_bytes()).hexdigest()
models={p.name:sha(p) for p in (R/'data').glob('*.bin')}
(R/'reports/model_hashes.json').write_text(json.dumps(models,indent=2))
baseline=json.loads(pathlib.Path('F:/fpga/PenumbraSight_offline_optimization_20261030/受保护文件校验.json').read_text(encoding='utf-8-sig'))
bad=[p for p,digest in baseline.items() if sha(p)!=digest]
paper_root=pathlib.Path('F:/fpga/PenumbraSight_MATLAB_RAW_20261030')
paper=json.loads((paper_root/'paper_source_manifest.json').read_text(encoding='utf-8-sig'))
badpaper=[d['relative_path'] for d in paper if sha(paper_root/d['relative_path'])!=d['sha256']]
origA=sha(paper_root/'output/A_measured.mat')
protection=dict(old_runtime_files=len(baseline),old_runtime_unchanged=not bad,changed_old_files=bad,
    paper_files=len(paper),paper_unchanged=not badpaper,changed_paper_files=badpaper,
    frozen_A_sha256=origA,frozen_A_unchanged=origA=='724e0eb8eb3734d6d22868354cfe4d17117eb1f318edb0fe526dd172f2cface7')
copied=json.loads((R/'reports/board_source_copy_manifest.json').read_text(encoding='utf-8'))
changed_board_sources=[d['source'] for d in copied if sha(d['source'])!=d['sha256']]
protection['original_board_source_files_checked']=len(copied)
protection['original_board_sources_unchanged']=not changed_board_sources
assert not changed_board_sources
for p in (R/'arm').glob('*.py'):py_compile.compile(str(p),doraise=True)
small=(R/'reports/xsim_small.log').read_text(encoding='utf-8');full=(R/'reports/xsim_full.log').read_text(encoding='utf-8')
assert '[PASS HYBRID AXIL]' in small and '[PASS HYBRID AXIL]' in full
assert 'Fatal:' not in full and 'cannot be opened' not in full
assert not bad and not badpaper and protection['frozen_A_unchanged']
status=dict(architecture='ARM outer/inner stopping + FPGA Gram/TV, fixed real RAW static reproduction',
   rtl_small_pass=True,rtl_full_pass=True,full_g_coefficients=1044**2,full_g_outputs=1044,tv_bit_exact_rounds=4,
   standalone_synthesis=True,standalone_LUT=15240,standalone_DSP=68,standalone_BRAM36=2,
   board_bd_validated=(R/'reports/board_integration_pass.txt').exists(),
   board_synthesis=(R/'reports/board_synthesis_pass.txt').exists(),
   routed_bitstream=(R/'vivado/board_hybrid/board_hybrid.bit').exists(),
   physical_board_tested=False,dma_driver_built_on_board=False,
   cpu_reference_scope='Three channels reached max 1100 iterations; outer tolerance not reached; CPU reference only',
   protection=protection)
status['new_bit_legacy_core_removed']=True
driver=R/'arm/driver/penumbra_gram.ko'
driver_log=R/'reports/driver_board_validation.log'
status['dma_driver_built']=driver.exists() and 'DRIVER_BUILD_COMPLETE_NOT_YET_LOADED' in (R/'reports/driver_build.log').read_text(encoding='utf-8')
status['dma_driver_buffer_board_tested']=driver_log.exists() and '[PASS PHYSICAL DMA BUFFER]' in driver_log.read_text(encoding='utf-8')
if driver.exists(): status['dma_driver_sha256']=sha(driver)
status['dma_driver_build_environment']='Existing Ubuntu 22.04 VM, Arm GCC 9.2.1, vendor atk-zup 5.4 source + running-board configuration'
physical_log=R/'reports/physical_hybrid_native_selftest.log'
if physical_log.exists():
    physical_text=physical_log.read_text(encoding='utf-8')
    status['physical_board_tested']=True
    status['physical_board_pass']='[PASS PHYSICAL BOARD HYF1]' in physical_text
    status['physical_core_id_verified']='PHYSICAL_HYF1_ID 0x48594631 N 1044' in physical_text
    status['physical_board_bus_error']='Kernel panic' in physical_text
    status['first_mmap_attempt_failed_then_recovered']=True
    status['current_mmio_access']='Native C single volatile 32-bit LDR/STR with DSB'
if (R/'reports/physical_smoke20_comparison.json').exists():
    status['real_RAW_20_iteration_board_comparison']=json.loads((R/'reports/physical_smoke20_comparison.json').read_text(encoding='utf-8'))
if (R/'reports/physical_red_full_comparison.json').exists():
    status['real_RAW_red_1100_board_comparison']=json.loads((R/'reports/physical_red_full_comparison.json').read_text(encoding='utf-8'))
    status['pending_raw_channels']=['G','B']
    status['current_board_mode']='New volatile HYF1 bit; old display/autostart paused; compute idle after red batch'
if (R/'reports/physical_rgb_full_comparison.json').exists():
    rgb=json.loads((R/'reports/physical_rgb_full_comparison.json').read_text(encoding='utf-8'))
    status['real_RAW_RGB_board_comparison']=rgb
    status['pending_raw_channels']=['RGB'[c] for c in rgb['pending_channels']]
    status['physical_saved_RAW_RGB_complete']=rgb['complete_RGB'] and rgb['all_array_equal']
    if status['physical_saved_RAW_RGB_complete']:
        status['current_board_mode']='New volatile HYF1 bit; old display/autostart paused; saved-RAW RGB complete; compute idle'
if (R/'reports/performance_comparison.json').exists():
    perf=json.loads((R/'reports/performance_comparison.json').read_text(encoding='utf-8'))
    status['bulk_transport_full_RGB_speedup']=perf['full_RGB_speedup']
    status['bulk_transport_full_RGB_seconds']=perf['fast_full_RGB_seconds']
    status['bulk_transport_all_3132_samples_exact']=perf['all_3132_samples_exact']
    status['bulk_transport_scope']='Isolated C bulk MMIO transport; validated baseline ARM/RTL/bit unchanged; no live camera'
    status['current_board_mode']='New volatile HYF1 bit; old display/autostart paused; compute idle after complete bulk transport RGB test'
bit=R/'vivado/board_hybrid/board_hybrid.bit'
if bit.exists():
    timing=(R/'reports/board_timing_routed.rpt').read_text(encoding='utf-8')
    route_log=(R/'reports/board_route_clean_console.log').read_text(encoding='utf-8')
    drc=(R/'reports/board_drc_routed.rpt').read_text(encoding='utf-8')
    assert 'PASS ROUTED BITSTREAM GENERATED' in route_log
    assert 'All user specified timing constraints are met.' in timing
    assert not re.search(r'\|\s*[^|]+\|\s*Error\s*\|',drc)
    timing_row=re.search(r'WNS\(ns\).*?\n\s*[- ]+\n\s*([\d.\-]+)\s+([\d.\-]+)\s+(\d+)\s+(\d+)\s+([\d.\-]+)\s+([\d.\-]+)',timing)
    assert timing_row,'Timing summary row was not recognized'
    status['routed_setup_WNS_ns']=float(timing_row[1])
    status['routed_hold_WHS_ns']=float(timing_row[5])
    assert status['routed_setup_WNS_ns']>=0 and status['routed_hold_WHS_ns']>=0
    status['routed_DRC_errors']=0
    status['bitstream_bytes']=bit.stat().st_size
    status['bitstream_sha256']=sha(bit)
    status['compute_clock_Hz']=49999500
    status['routed_timing_scope']='Existing board constraints; external I/O advisories remain documented in timing report; not physical validation'
if (R/'reports/board_utilization_synth.rpt').exists():
    resources={}
    for line in (R/'reports/board_utilization_synth.rpt').read_text(encoding='utf-8').splitlines():
        parts=[s.strip() for s in line.split('|')]
        if len(parts)>5 and parts[1] in ('CLB LUTs*','Block RAM Tile','URAM','DSPs'):
            resources[parts[1]]=dict(used=float(parts[2]),available=float(parts[4]))
    status['whole_board_resources_synth']=resources
(R/'reports/package_source_manifest.json').write_text(json.dumps({str(p.relative_to(R)):sha(p) for folder in ('rtl','arm','scripts','matlab') for p in (R/folder).rglob('*') if p.is_file() and '__pycache__' not in p.parts},indent=2))
(R/'reports/stage_status.json').write_text(json.dumps(status,ensure_ascii=False,indent=2),encoding='utf-8')
print(json.dumps(status,ensure_ascii=False,indent=2))
