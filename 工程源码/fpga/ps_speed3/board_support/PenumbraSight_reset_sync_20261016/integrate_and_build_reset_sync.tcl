set work F:/fpga/PenumbraSight_hybrid_FISTA_20261030/board_support/PenumbraSight_reset_sync_20261016
set board F:/fpga/PenumbraSight_hybrid_FISTA_20261030/board_support/PenumbraSight_board_synth_20261016
set previous F:/fpga/PenumbraSight_hybrid_FISTA_20261030/board_support/PenumbraSight_hdmi_fix_20261016
set_param general.maxThreads 2
set fid [open [file join $work sim_project hdmi_reset_sync.sim sim_1 behav xsim simulate.log] r]
set sim [read $fid]
close $fid
if {[string first {[PASS] HDMI FRAME RESET SYNC} $sim] < 0} {error "Reset unit simulation must pass first"}
open_project [file join $board project mpsoc_p4_board_nlos.xpr]
config_ip_cache -use_cache_location [file join $board project mpsoc_p4_board_nlos.cache ip]
add_files -norecurse [file join $work hdmi_frame_reset_sync.v]
update_compile_order -fileset sources_1
set bd [get_files */source_full/system/system.bd]
open_bd_design $bd
set ps [get_bd_cells zynq_ultra_ps_e_0]
set ps_config [dict create]
foreach key [list_property $ps] {
    if {[string match CONFIG.* $key]} {dict set ps_config $key [get_property $key $ps]}
}
set addr [dict create]
foreach seg [get_bd_addr_segs -of_objects [get_bd_addr_spaces zynq_ultra_ps_e_0/Data]] {
    dict set addr $seg [list [get_property OFFSET $seg] [get_property RANGE $seg]]
}
if {[dict size $addr] != 18} {error "Unexpected original PS address count"}
create_bd_cell -type module -reference hdmi_frame_reset_sync hdmi_out/frame_reset_sync
connect_bd_net [get_bd_pins hdmi_out/pclk] [get_bd_pins hdmi_out/frame_reset_sync/clk]
connect_bd_net [get_bd_pins hdmi_out/aresetn] [get_bd_pins hdmi_out/frame_reset_sync/global_resetn]
set target [get_bd_pins hdmi_out/v_frmbuf_rd_0/ap_rst_n]
set oldnet [get_bd_nets -of_objects $target]
disconnect_bd_net $oldnet $target
connect_bd_net [get_bd_pins hdmi_out/xlslice_0/Dout] [get_bd_pins hdmi_out/frame_reset_sync/software_resetn]
connect_bd_net [get_bd_pins hdmi_out/frame_reset_sync/resetn] $target
set hz [get_property CONFIG.FREQ_HZ [get_bd_pins hdmi_shared/pixel_clock]]
set_property CONFIG.FREQ_HZ $hz [get_bd_pins hdmi_out/frame_reset_sync/clk]
validate_bd_design
foreach key [dict keys $ps_config] {
    if {[get_property $key $ps] ne [dict get $ps_config $key]} {error "PS configuration changed: $key"}
}
set now [get_bd_addr_segs -of_objects [get_bd_addr_spaces zynq_ultra_ps_e_0/Data]]
if {[llength $now] != 18} {error "PS address count changed"}
foreach seg [dict keys $addr] {
    if {[list [get_property OFFSET [get_bd_addr_segs $seg]] [get_property RANGE [get_bd_addr_segs $seg]]] ne [dict get $addr $seg]} {error "PS address changed: $seg"}
}
if {[get_bd_nets -of_objects $target] ne [get_bd_nets -of_objects [get_bd_pins hdmi_out/frame_reset_sync/resetn]]} {error "Framebuffer reset not synchronized"}
save_bd_design
generate_target all $bd
set xdc [file join $work frame_reset_sync_impl.xdc]
add_files -fileset constrs_1 -norecurse $xdc
set_property USED_IN_SYNTHESIS false [get_files $xdc]
set_property USED_IN_IMPLEMENTATION true [get_files $xdc]
foreach script {check_reset_postopt.tcl report_reset_postroute.tcl} {
    add_files -fileset utils_1 -norecurse [file join $work $script]
}
puts "FRAME RESET BD CHECK PASS: synchronized framebuffer reset at $hz Hz; PS configuration and 18 address mappings preserved"
update_compile_order -fileset sources_1
reset_run synth_1
launch_runs synth_1 -jobs 2
wait_on_run synth_1
if {![regexp -nocase {complete} [get_property STATUS [get_runs synth_1]]]} {error "Reset-sync board synthesis failed"}
puts "FRAME RESET BOARD SYNTHESIS PASS"
set run [get_runs impl_1]
set_property STEPS.OPT_DESIGN.TCL.PRE [file join $previous check_board_shared_impl_constraints.tcl] $run
set_property STEPS.OPT_DESIGN.TCL.POST [file join $work check_reset_postopt.tcl] $run
set_property STEPS.ROUTE_DESIGN.TCL.POST [file join $work report_reset_postroute.tcl] $run
launch_runs impl_1 -to_step route_design -jobs 1
wait_on_run impl_1
set status [get_property STATUS $run]
puts "FRAME RESET BOARD IMPLEMENTATION STATUS: $status"
if {![regexp -nocase {route_design Complete} $status]} {error "Reset-sync board implementation did not complete"}
set run_dir [get_property DIRECTORY $run]
foreach {source dest} {
    system_wrapper_timing_summary_routed.rpt board_reset_sync_timing.rpt
    system_wrapper_drc_routed.rpt board_reset_sync_drc.rpt
    system_wrapper_bus_skew_routed.rpt board_reset_sync_bus_skew.rpt
    system_wrapper_utilization_placed.rpt board_reset_sync_utilization.rpt
} {
    file copy -force [file join $run_dir $source] [file join $work $dest]
}
puts "FRAME RESET BOARD BUILD REPORTS COMPLETE: inspect routed timing, CDC and DRC before bitstream"
close_project
