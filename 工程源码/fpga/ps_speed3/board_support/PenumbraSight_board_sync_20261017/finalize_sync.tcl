set work F:/fpga/PenumbraSight_hybrid_FISTA_20261030/board_support/PenumbraSight_board_sync_20261017
source [file join $work check_synced_netlist.tcl]
# Applying this file is idempotent and also verifies both objects at the linked top.
read_xdc F:/fpga/PenumbraSight_hybrid_FISTA_20261030/board_support/PenumbraSight_rgmii_eco_20261017/control_eco_guard_impl.xdc
if {[llength $nlos_tx_ready_c]!=1 || [llength $nlos_tx_guard_rst]!=1} {error "TX guard objects missing"}
set py [lindex [glob C:/Users/*/.cache/codex-runtimes/codex-primary-runtime/dependencies/python/python.exe] 0]
puts [exec $py -I [file join $work verify_current_framebuffer_cache.py]]
set synthcp F:/fpga/PenumbraSight_hybrid_FISTA_20261030/board_support/PenumbraSight_board_synth_20261016/project/mpsoc_p4_board_nlos.runs/synth_control_sync/system_wrapper.dcp
if {![file exists $synthcp]} {error "Fresh top synthesis checkpoint missing"}
set fresh [file mtime $synthcp]
set examined 0
foreach f [get_files -compile_order sources -used_in synthesis] {
    set p [get_property NAME $f]
    if {[file exists $p] && ![file isdirectory $p]} {
        if {[file mtime $p]>$fresh} {error "Synthesis input newer than fresh top checkpoint: $p"}
        incr examined
    }
}
puts "FRESH SYNTHESIS INPUT AUDIT PASS: $examined compile-order files not newer than completed checkpoint"
# Only acknowledge the proven unchanged HLS cache export, and its freshly
# completed parent. Leave genuinely stale old synth_1 refresh status intact.
foreach name {system_v_frmbuf_rd_0_3_synth_1 synth_control_sync} {
    set r [get_runs $name]
    if {![regexp {synth_design Complete} [get_property STATUS $r]]} {error "Run incomplete: $name"}
    if {[get_property NEEDS_REFRESH $r]} {set_property NEEDS_REFRESH false $r}
}
set imp [get_runs impl_control_sync]
set checkpoint [get_property INCREMENTAL_CHECKPOINT $imp]
if {$checkpoint ne {F:/fpga/PenumbraSight_hybrid_FISTA_20261030/board_support/PenumbraSight_rgmii_eco_20261017/system_wrapper_control_eco_routed.dcp} || ![file exists $checkpoint]} {error "Incremental checkpoint mismatch"}
set guard [get_files F:/fpga/PenumbraSight_hybrid_FISTA_20261030/board_support/PenumbraSight_rgmii_eco_20261017/control_eco_guard_impl.xdc]
if {[get_property USED_IN_SYNTHESIS $guard] || ![get_property USED_IN_IMPLEMENTATION $guard]} {error "Guard XDC run scope mismatch"}
current_run -synthesis [get_runs synth_control_sync]
current_run -implementation $imp
report_utilization -file [file join $work synced_synth_utilization.rpt]
foreach r {system_v_frmbuf_rd_0_3_synth_1 synth_control_sync impl_control_sync synth_1} {puts "FINAL_RUN $r [get_property STATUS [get_runs $r]] refresh=[get_property NEEDS_REFRESH [get_runs $r]]"}
set f [open [file join $work project_sync_complete.txt] w]
puts $f "PROJECT SOURCE AND SYNTHESIS SYNC PASS"
puts $f "Five corrected delay control clocks and synchronized TX calibration reset verified directly in fresh linked synthesis. Previous routed ECO retained as incremental checkpoint. External Ethernet timing closure and board test pending."
close $f
close_project
puts "FORMAL PROJECT SYNC COMPLETE; NO IMPLEMENTATION OR HARDWARE ACCESS PERFORMED"
exit
