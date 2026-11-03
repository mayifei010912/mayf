set root F:/fpga/PenumbraSight_hybrid_FISTA_20261030/board_support/PenumbraSight_board_vendor_gmii_20261017
set work F:/fpga/PenumbraSight_hybrid_FISTA_20261030/board_support/PenumbraSight_interface_closure_20261017
set_param general.maxThreads 2
open_project [file join $root board_vendor_gmii.xpr]
config_ip_cache -use_cache_location [file join $root board_vendor_gmii.cache ip]
set bd [get_files */source_full/system/system.bd]
open_bd_design $bd
foreach name {rgmii_ref_clock_refclk rgmii_ref_clock_cal_resetn} {
 set net [get_bd_nets -quiet $name]
 if {[llength $net] && [llength [get_bd_pins -of_objects $net]]==0 && [llength [get_bd_ports -of_objects $net]]==0} {delete_bd_objs $net}
}
validate_bd_design
save_bd_design
generate_target synthesis $bd
set io [file join $root source vendor_io_impl.xdc]
if {[llength [get_files -quiet $io]]==0} {add_files -fileset constrs_1 -norecurse $io}
set_property USED_IN_SYNTHESIS false [get_files $io]
set_property USED_IN_IMPLEMENTATION true [get_files $io]
update_compile_order -fileset sources_1
set syn synth_vendor_gmii
if {[llength [get_runs -quiet $syn]]==0} {create_run $syn -flow {Vivado Synthesis 2020} -strategy {Vivado Synthesis Defaults} -srcset sources_1 -constrset constrs_1 -part xczu4ev-sfvc784-2-i}
set imp impl_vendor_gmii
if {[llength [get_runs -quiet $imp]]==0} {create_run $imp -parent_run $syn -flow {Vivado Implementation 2020} -strategy {Vivado Implementation Defaults} -constrset constrs_1 -part xczu4ev-sfvc784-2-i}
set_property INCREMENTAL_CHECKPOINT F:/fpga/PenumbraSight_hybrid_FISTA_20261030/board_support/PenumbraSight_rgmii_eco_20261017/system_wrapper_control_eco_routed.dcp [get_runs $imp]
set_property STEPS.OPT_DESIGN.TCL.PRE F:/fpga/PenumbraSight_hybrid_FISTA_20261030/board_support/PenumbraSight_hdmi_fix_20261016/check_board_shared_impl_constraints.tcl [get_runs $imp]
set_property STEPS.OPT_DESIGN.TCL.POST F:/fpga/PenumbraSight_hybrid_FISTA_20261030/board_support/PenumbraSight_reset_sync_20261016/check_reset_postopt.tcl [get_runs $imp]
current_run -synthesis [get_runs $syn]
current_run -implementation [get_runs $imp]
report_ip_status -file [file join $work vendor_board_ip_status.rpt]
launch_runs $syn -jobs 2
wait_on_run $syn
if {![regexp {synth_design Complete} [get_property STATUS [get_runs $syn]]]} {error "Vendor integration top synthesis failed"}
open_run $syn
report_clocks -file [file join $work vendor_synth_clocks.rpt]
report_utilization -file [file join $work vendor_board_synth_utilization.rpt]
write_checkpoint -force [file join $work vendor_board_linked_synth.dcp]
puts "VENDOR BOARD LINKED SYNTHESIS COMPLETE; IMPLEMENTATION NOT YET STARTED"
close_project
