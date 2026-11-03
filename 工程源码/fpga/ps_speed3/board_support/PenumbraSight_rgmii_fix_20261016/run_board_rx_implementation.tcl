set rx_work F:/fpga/PenumbraSight_hybrid_FISTA_20261030/board_support/PenumbraSight_rgmii_fix_20261016
set rx_board F:/fpga/PenumbraSight_hybrid_FISTA_20261030/board_support/PenumbraSight_board_synth_20261016
set_param general.maxThreads 2
if {![file exists [file join $rx_work board_rx_synthesis_check.txt]]} {error "Synthesis check missing"}
if {![file exists [file join $rx_work backup_before_board_rx system_wrapper_routed.dcp]]} {error "Previous successful route backup missing"}
open_project [file join $rx_board project mpsoc_p4_board_nlos.xpr]
if {[get_property PART [current_project]] ne {xczu4ev-sfvc784-2-i}} {error "Unexpected FPGA part"}
set rx_synth [get_runs synth_1]
puts "EXISTING SYNTHESIS: [get_property STATUS $rx_synth]; NEEDS_REFRESH=[get_property NEEDS_REFRESH $rx_synth]"
if {![regexp {synth_design Complete} [get_property STATUS $rx_synth]]} {error "Completed synthesis required"}
if {[get_property NEEDS_REFRESH $rx_synth]} {
    # The interrupted redundant compile_c left the HLS run refresh flag set,
    # although Vivado subsequently exported its matching cache and top synthesis completed.
    # Acknowledge only this verified cache export, never changed design sources.
    set refreshed [list]
    foreach r [get_runs -filter {IS_SYNTHESIS == 1}] {
        if {[get_property NEEDS_REFRESH $r]} {lappend refreshed $r}
    }
    if {[lsort $refreshed] ne [lsort {synth_1 system_v_frmbuf_rd_0_3_synth_1}]} {error "Unexpected stale runs: $refreshed"}
    set synth_dcp [file join $rx_board project mpsoc_p4_board_nlos.runs synth_1 system_wrapper.dcp]
    foreach f [get_files -all] {
        if {[file isfile $f] && [get_property FILE_TYPE $f] ne {TCL} && [file mtime $f]>[file mtime $synth_dcp]} {error "Design file newer than checkpoint: $f"}
    }
    set proof [exec $::env(NLOS_RX_PYTHON) -I [file join $rx_work verify_framebuffer_cache_reuse.py]]
    puts $proof
    if {[string first {VERIFIED CACHE REUSE PASS} $proof]<0} {error "Cache proof missing"}
    set_property NEEDS_REFRESH false [get_runs system_v_frmbuf_rd_0_3_synth_1]
    set_property NEEDS_REFRESH false $rx_synth
    puts "ACKNOWLEDGED VERIFIED CACHE EXPORT: only framebuffer and dependent top refresh flags cleared; no source/checkpoint changes"
}
set rx_xdc [get_files [file join $rx_work board_rgmii_rx_impl.xdc]]
if {[llength $rx_xdc]!=1 || ![get_property USED_IN_IMPLEMENTATION $rx_xdc]} {error "RX implementation constraints missing"}
set rx_run [get_runs impl_1]
foreach script {check_board_rx_postopt.tcl report_board_rx_postroute.tcl} {
    set p [file join $rx_work $script]
    if {[llength [get_files -quiet $p]]==0} {add_files -fileset utils_1 -norecurse $p}
}
set_property STEPS.OPT_DESIGN.TCL.PRE F:/fpga/PenumbraSight_hybrid_FISTA_20261030/board_support/PenumbraSight_hdmi_fix_20261016/check_board_shared_impl_constraints.tcl $rx_run
set_property STEPS.OPT_DESIGN.TCL.POST [file join $rx_work check_board_rx_postopt.tcl] $rx_run
set_property STEPS.ROUTE_DESIGN.TCL.POST [file join $rx_work report_board_rx_postroute.tcl] $rx_run
puts "BOARD RX IMPLEMENTATION START: reuse completed synthesis; route_design only"
launch_runs impl_1 -to_step route_design -jobs 1
wait_on_run impl_1
set rx_status [get_property STATUS $rx_run]
puts "BOARD RX IMPLEMENTATION STATUS: $rx_status"
if {![regexp {route_design Complete} $rx_status]} {error "Board RX implementation incomplete: $rx_status"}
set rx_run_dir [get_property DIRECTORY $rx_run]
foreach {src dst} {
    system_wrapper_timing_summary_routed.rpt board_rx_routed_timing.rpt
    system_wrapper_drc_routed.rpt board_rx_routed_drc.rpt
    system_wrapper_bus_skew_routed.rpt board_rx_routed_bus_skew.rpt
} {
    if {![file exists [file join $rx_run_dir $src]]} {error "Missing implementation report: $src"}
    file copy -force [file join $rx_run_dir $src] [file join $rx_work $dst]
}
open_run impl_1
report_utilization -file [file join $rx_work board_rx_routed_utilization.rpt]
report_clocks -file [file join $rx_work board_rx_routed_clocks.rpt]
set f [open [file join $rx_work board_rx_implementation_complete.txt] w]
puts $f "BOARD RX IMPLEMENTATION AND REPORTS COMPLETE"
puts $f "route_design complete; review reports for timing/DRC pass, no bitstream or hardware test"
close $f
close_project
