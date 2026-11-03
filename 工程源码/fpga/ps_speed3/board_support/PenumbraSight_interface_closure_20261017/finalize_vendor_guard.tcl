set work F:/fpga/PenumbraSight_hybrid_FISTA_20261030/board_support/PenumbraSight_interface_closure_20261017
set_param general.maxThreads 2
open_checkpoint [file join $work vendor_mmcm_routed.dcp]
source [file join $work vendor_phy_timing.tcl]
source [file join $work add_vendor_cal_guard.tcl]
source [file join $work place_vendor_guard.tcl]
route_design -eco
route_design -finalize
write_checkpoint -force [file join $work vendor_mmcm_guard_routed.dcp]
report_route_status -file [file join $work vendor_final_route.rpt]
report_timing_summary -delay_type min_max -report_unconstrained -file [file join $work vendor_final_timing.rpt]
report_drc -file [file join $work vendor_final_drc.rpt]
report_timing -to [get_ports {RGMII_td[*] RGMII_tx_ctl}] -delay_type min_max -max_paths 10 -path_type full_clock_expanded -file [file join $work vendor_final_tx.rpt]
report_timing -to [get_pins -of [get_cells -hier -filter {NAME =~ *vendor_gmii*rgmii_tx_ctl_out && REF_NAME == OSERDESE3}] -filter {REF_PIN_NAME == RST}] -delay_type max -max_paths 3 -file [file join $work vendor_guard_reset_path.rpt]
source [file join $work audit_vendor_rates.tcl]
close_design
