set board F:/fpga/PenumbraSight_hybrid_FISTA_20261030/board_support/PenumbraSight_board_synth_20261016
set out F:/fpga/PenumbraSight_hybrid_FISTA_20261030/board_support/PenumbraSight_hdmi_fix_20261016
set_param general.maxThreads 2
open_project [file join $board project mpsoc_p4_board_nlos.xpr]
config_ip_cache -use_cache_location [file join $board project mpsoc_p4_board_nlos.cache ip]
if {[get_property PART [current_project]] ne {xczu4ev-sfvc784-2-i}} {error "Unexpected FPGA part"}
if {![regexp -nocase {complete} [get_property STATUS [get_runs synth_1]]]} {error "Synthesis must be complete"}
set run [get_runs impl_1]
foreach script {check_board_shared_impl_constraints.tcl check_board_shared_postopt.tcl} {
    set path [file join $out $script]
    if {[llength [get_files -quiet $path]] == 0} {add_files -fileset utils_1 -norecurse $path}
}
set_property STEPS.OPT_DESIGN.TCL.PRE [file join $out check_board_shared_impl_constraints.tcl] $run
set_property STEPS.OPT_DESIGN.TCL.POST [file join $out check_board_shared_postopt.tcl] $run
if {[regexp -nocase {error} [get_property STATUS $run]]} {reset_run impl_1}
launch_runs impl_1 -to_step route_design -jobs 1
wait_on_run impl_1
set status [get_property STATUS $run]
puts "BOARD IMPLEMENTATION RUN STATUS: $status"
if {![regexp -nocase {route_design Complete} $status]} {error "Board routing did not complete; inspect impl_1/runme.log"}
open_run impl_1
report_utilization -file [file join $out board_shared_routed_utilization.rpt]
report_timing_summary -delay_type min_max -report_unconstrained -file [file join $out board_shared_routed_timing.rpt]
report_route_status -file [file join $out board_shared_route_status.rpt]
report_drc -file [file join $out board_shared_routed_drc.rpt]
report_bus_skew -file [file join $out board_shared_routed_bus_skew.rpt]
report_clocks -file [file join $out board_shared_routed_clocks.rpt]
puts "BOARD SHARED CLOCK IMPLEMENTATION REPORTS COMPLETE: inspect timing/DRC before bitstream"
close_project
