set work F:/fpga/PenumbraSight_hybrid_FISTA_20261030/board_support/PenumbraSight_interface_closure_20261017
source [file join $work vendor_phy_timing.tcl]
set task_ctl [get_cells -hier -filter {NAME =~ *vendor_gmii*rgmii_tx_ctl_out && REF_NAME == OSERDESE3}]
set task_sources [all_fanin -flat -startpoints_only -only_cells -to [get_pins $task_ctl/RST]]
if {[lsearch -exact $task_sources nlos_vendor_cal_guard_sync_2]<0} {error "Final guard synchronizer does not drive TX_CTL reset"}
foreach i {0 1 2} {
  if {[get_property INIT [get_cells nlos_vendor_cal_guard_sync_$i]] ne "1'b0"} {error "Guard initialization incorrect"}
  if {![get_property ASYNC_REG [get_cells nlos_vendor_cal_guard_sync_$i]]} {error "Guard synchronizer attribute absent"}
}
report_timing_summary -delay_type min_max -report_unconstrained -file [file join $work vendor_final_timing.rpt]
report_timing -to [get_ports {RGMII_td[*] RGMII_tx_ctl}] -delay_type min_max -max_paths 10 -path_type full_clock_expanded -file [file join $work vendor_final_tx.rpt]
report_clocks -file [file join $work vendor_final_clocks.rpt]
report_drc -file [file join $work vendor_final_drc.rpt]
write_checkpoint -force [file join $work vendor_rgmii_verified_routed.dcp]
set audit_rates {100 10}
set audit_append 1
source [file join $work audit_vendor_rates.tcl]
puts "NOMINAL AND RATE AUDIT COMPLETE"
