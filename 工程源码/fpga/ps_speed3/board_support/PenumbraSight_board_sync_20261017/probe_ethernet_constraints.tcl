set work F:/fpga/PenumbraSight_hybrid_FISTA_20261030/board_support/PenumbraSight_board_sync_20261017
set_param general.maxThreads 2
open_checkpoint F:/fpga/PenumbraSight_hybrid_FISTA_20261030/board_support/PenumbraSight_rgmii_eco_20261017/system_wrapper_control_eco_routed.dcp
set rxclk [get_clocks RGMII_rxc]
set rxports [get_ports {RGMII_rd[*] RGMII_rx_ctl}]
set txports [get_ports {RGMII_td[*] RGMII_tx_ctl}]
set txsource [get_pins system_i/gmii2rgmii_calibrated_0/inst/u_rgmii_rx/rx_clock_buffer/O]
if {[llength $txports]!=5 || [llength $txsource]!=1} {error "TX topology missing"}
# Receiver model below shifts the external PHY capture edge by its internal
# delay. It is a planning clock at the output boundary, not a claim that the FPGA
# physically generates that shifted phase. Keep delay uncertainty in I/O budgets.
set mdio [get_ports MDIO_mdio_io]
set mdc [get_clocks mdio0_mdc_clock]
if {[llength $mdc]!=1 || [get_property PERIOD $mdc]<80} {error "PHY MDC clock exceeds datasheet frequency"}
# YT8521 Table 139: tSU/tH 10 ns, tCO 0..20 ns. +/-0.2 ns assumed PCB skew.
set_input_delay -clock $mdc -min -0.2 $mdio
set_input_delay -clock $mdc -max 20.2 $mdio
set_output_delay -clock $mdc -max 10.2 $mdio
set_output_delay -clock $mdc -min -10.2 $mdio
report_timing -from $mdio -delay_type max -max_paths 3 -file [file join $work mdio_input_setup_probe.rpt]
report_timing -from $mdio -delay_type min -max_paths 3 -file [file join $work mdio_input_hold_probe.rpt]
report_timing -to $mdio -delay_type max -max_paths 3 -file [file join $work mdio_output_setup_probe.rpt]
report_timing -to $mdio -delay_type min -max_paths 3 -file [file join $work mdio_output_hold_probe.rpt]
set f [open [file join $work ethernet_constraint_probe.tsv] w]
puts $f "scenario\ttx_delay_ns\tperiod_ns\tduty\ttx_setup_ns\ttx_hold_ns\trx_setup_ns\trx_hold_ns"
# A003 delay selectors are nominal 150 ps/step. +/-150 ps delay uncertainty is
# an assumption for planning, not a datasheet guaranteed PVT bound.
foreach {scenario delay} {observed_code1 0.15 candidate_code12 1.8 candidate_code13 1.95 ideal_midpoint 1.875} {
    foreach {period duty} {8.0 0.5} {
        create_generated_clock -name nlos_phy_tx_capture -source $txsource -edges {1 2 3} -edge_shift [list $delay $delay $delay] [get_ports RGMII_txc]
        set txclock [get_clocks nlos_phy_tx_capture]
        set maxout [expr {1.0+0.2+0.15}]
        set minout [expr {-1.0-0.2-0.15}]
        foreach edge {rise fall} {
            if {$edge eq {rise}} {set opts [list]} else {set opts [list -clock_fall -add_delay]}
            set_output_delay -clock $txclock {*}$opts -max $maxout $txports
            set_output_delay -clock $txclock {*}$opts -min $minout $txports
        }
        set ts [get_timing_paths -to $txports -delay_type max -max_paths 1]
        set th [get_timing_paths -to $txports -delay_type min -max_paths 1]
        set rs [get_timing_paths -from $rxports -delay_type max -max_paths 1]
        set rh [get_timing_paths -from $rxports -delay_type min -max_paths 1]
        foreach p [list $ts $th $rs $rh] {if {[llength $p]!=1} {error "Ethernet probe timing path missing"}}
        puts $f "$scenario\t$delay\t$period\t$duty\t[get_property SLACK $ts]\t[get_property SLACK $th]\t[get_property SLACK $rs]\t[get_property SLACK $rh]"
        puts "ETHERNET CONSTRAINT PROBE $scenario: TX setup=[get_property SLACK $ts] hold=[get_property SLACK $th]; RX setup=[get_property SLACK $rs] hold=[get_property SLACK $rh]"
        report_timing -to $txports -delay_type max -max_paths 5 -file [file join $work ${scenario}_tx_setup_probe.rpt]
        report_timing -to $txports -delay_type min -max_paths 5 -file [file join $work ${scenario}_tx_hold_probe.rpt]
    }
}
close $f
check_timing -verbose -file [file join $work ethernet_probe_check_timing.rpt]
puts "READ-ONLY ETHERNET TIMING PROBE COMPLETE: no project constraints, checkpoint or PHY registers modified"
close_design
