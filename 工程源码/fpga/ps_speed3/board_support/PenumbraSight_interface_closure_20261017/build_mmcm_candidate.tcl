set root F:/fpga/PenumbraSight_hybrid_FISTA_20261030/board_support/PenumbraSight_board_vendor_gmii_20261017
set work F:/fpga/PenumbraSight_hybrid_FISTA_20261030/board_support/PenumbraSight_interface_closure_20261017
set_param general.maxThreads 2
open_project [file join $root board_vendor_gmii.xpr]
config_ip_cache -use_cache_location [file join $root board_vendor_gmii.cache ip]
set syn synth_vendor_mmcm
if {[llength [get_runs -quiet $syn]]==0} {create_run $syn -flow {Vivado Synthesis 2020} -strategy {Vivado Synthesis Defaults} -srcset sources_1 -constrset constrs_1 -part xczu4ev-sfvc784-2-i}
current_run -synthesis [get_runs $syn]
launch_runs $syn -jobs 2
wait_on_run $syn
if {![regexp {synth_design Complete} [get_property STATUS [get_runs $syn]]]} {error "MMCM variant synthesis failed"}
open_run $syn
source [file join $work vendor_phy_timing.tcl]
source F:/fpga/PenumbraSight_hybrid_FISTA_20261030/board_support/PenumbraSight_hdmi_fix_20261016/check_board_shared_impl_constraints.tcl
opt_design
source F:/fpga/PenumbraSight_hybrid_FISTA_20261030/board_support/PenumbraSight_reset_sync_20261016/check_reset_postopt.tcl
write_checkpoint -force [file join $work vendor_mmcm_opt.dcp]
read_checkpoint -incremental [file join $work vendor_routed_candidate.dcp]
place_design
route_design
write_checkpoint -force [file join $work vendor_mmcm_routed.dcp]
report_route_status -file [file join $work vendor_mmcm_route.rpt]
report_timing_summary -delay_type min_max -report_unconstrained -file [file join $work vendor_mmcm_timing.rpt]
report_drc -file [file join $work vendor_mmcm_drc.rpt]
report_bus_skew -file [file join $work vendor_mmcm_bus_skew.rpt]
report_timing -from [get_ports {RGMII_rd[*] RGMII_rx_ctl}] -delay_type min_max -max_paths 10 -path_type full_clock_expanded -file [file join $work vendor_mmcm_rx.rpt]
report_timing -to [get_ports {RGMII_td[*] RGMII_tx_ctl}] -delay_type min_max -max_paths 10 -path_type full_clock_expanded -file [file join $work vendor_mmcm_tx.rpt]
puts "MMCM CANDIDATE ROUTED REPORTS COMPLETE; MDIO AND RATE AUDIT STILL REQUIRED"
close_project
