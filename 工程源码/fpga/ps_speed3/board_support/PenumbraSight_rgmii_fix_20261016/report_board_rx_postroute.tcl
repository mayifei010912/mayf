set ::penumbra_team_fpga [file normalize [file join [file dirname [info script]] ..]]
set rx_report_dir $::penumbra_team_fpga/PenumbraSight_rgmii_fix_20261016
report_route_status -file [file join $rx_report_dir board_rx_route_status.rpt]
set rx_input_ports [get_ports {RGMII_rd[*] RGMII_rx_ctl}]
if {[llength $rx_input_ports]!=5} {error "RX input ports missing after route"}
report_timing -from $rx_input_ports -delay_type max -max_paths 10 -file [file join $rx_report_dir board_rx_input_setup.rpt]
report_timing -from $rx_input_ports -delay_type min -max_paths 10 -file [file join $rx_report_dir board_rx_input_hold.rpt]
set rx_setup [get_timing_paths -from $rx_input_ports -delay_type max -max_paths 1]
set rx_hold [get_timing_paths -from $rx_input_ports -delay_type min -max_paths 1]
if {[llength $rx_setup]!=1 || [llength $rx_hold]!=1} {error "RX timing paths unavailable"}
puts "BOARD RX ROUTED INPUT TIMING: setup=[get_property SLACK $rx_setup] ns hold=[get_property SLACK $rx_hold] ns; assumed PCB allowance +/-0.2 ns"
puts "BOARD RX ROUTE REPORTS COMPLETE; inspect full-design timing and DRC before board download"
