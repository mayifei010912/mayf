set work F:/fpga/PenumbraSight_hybrid_FISTA_20261030/board_support/PenumbraSight_interface_closure_20261017
set_param general.maxThreads 2
source [file join $work vendor_phy_timing.tcl]
source F:/fpga/PenumbraSight_hybrid_FISTA_20261030/board_support/PenumbraSight_hdmi_fix_20261016/check_board_shared_impl_constraints.tcl
opt_design
source F:/fpga/PenumbraSight_hybrid_FISTA_20261030/board_support/PenumbraSight_reset_sync_20261016/check_reset_postopt.tcl
write_checkpoint -force [file join $work vendor_opt.dcp]
read_checkpoint -incremental F:/fpga/PenumbraSight_hybrid_FISTA_20261030/board_support/PenumbraSight_rgmii_eco_20261017/system_wrapper_control_eco_routed.dcp
place_design
phys_opt_design
route_design
write_checkpoint -force [file join $work vendor_routed_candidate.dcp]
report_route_status -file [file join $work vendor_routed_status.rpt]
report_timing_summary -delay_type min_max -report_unconstrained -file [file join $work vendor_routed_timing.rpt]
report_drc -file [file join $work vendor_routed_drc.rpt]
report_timing -from [get_ports {RGMII_rd[*] RGMII_rx_ctl}] -delay_type min_max -max_paths 12 -path_type full_clock_expanded -file [file join $work vendor_rx_paths.rpt]
report_timing -to [get_ports {RGMII_td[*] RGMII_tx_ctl}] -delay_type min_max -max_paths 12 -path_type full_clock_expanded -file [file join $work vendor_tx_paths.rpt]
puts "VENDOR ROUTED CANDIDATE REPORTS COMPLETE; MDIO AND RATE AUDIT STILL REQUIRED"
