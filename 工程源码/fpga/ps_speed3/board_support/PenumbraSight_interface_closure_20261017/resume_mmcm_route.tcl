set work F:/fpga/PenumbraSight_hybrid_FISTA_20261030/board_support/PenumbraSight_interface_closure_20261017
set_param general.maxThreads 2
open_checkpoint [file join $work vendor_mmcm_opt.dcp]
read_checkpoint -incremental [file join $work vendor_routed_candidate.dcp]
# The placer selected nonadjacent sites for the new cascaded BUFG mux pair.
# Reserve an adjacent legal pair within the MMCM clock region instead.
set stem system_i/vendor_gmii/U0/i_gmii_to_rgmii_block
set_property LOC BUFGCTRL_X0Y22 [get_cells $stem/i_bufgmux_gmii_90_clk]
set_property LOC BUFGCTRL_X0Y23 [get_cells $stem/i_bufgmux_gmii_clk_25m_2_5m_90]
set task_mipi_buf [get_cells -hier -filter {NAME =~ *GEN_PLL_IN_IP_USP.pll0_clkout0_buf && REF_NAME == BUFGCE}]
if {[llength $task_mipi_buf]!=1} {error "Expected one MIPI PLL output buffer"}
set_property LOC BUFGCE_X0Y65 $task_mipi_buf
place_design
route_design
write_checkpoint -force [file join $work vendor_mmcm_routed.dcp]
report_route_status -file [file join $work vendor_mmcm_route.rpt]
report_timing_summary -delay_type min_max -report_unconstrained -file [file join $work vendor_mmcm_timing.rpt]
report_drc -file [file join $work vendor_mmcm_drc.rpt]
report_bus_skew -file [file join $work vendor_mmcm_bus_skew.rpt]
report_timing -from [get_ports {RGMII_rd[*] RGMII_rx_ctl}] -delay_type min_max -max_paths 10 -path_type full_clock_expanded -file [file join $work vendor_mmcm_rx.rpt]
report_timing -to [get_ports {RGMII_td[*] RGMII_tx_ctl}] -delay_type min_max -max_paths 10 -path_type full_clock_expanded -file [file join $work vendor_mmcm_tx.rpt]
source [file join $work audit_vendor_rates.tcl]
close_design
