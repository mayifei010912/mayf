set work F:/fpga/PenumbraSight_hybrid_FISTA_20261030/board_support/PenumbraSight_interface_closure_20261017
set_param general.maxThreads 2
open_checkpoint F:/fpga/PenumbraSight_hybrid_FISTA_20261030/board_support/PenumbraSight_ethernet_tx_20261017/system_wrapper_tx_clock_eco_routed.dcp
set txports [get_ports {RGMII_td[*] RGMII_tx_ctl}]
set txall [get_ports {RGMII_td[*] RGMII_tx_ctl RGMII_txc}]
set rxports [get_ports {RGMII_rd[*] RGMII_rx_ctl}]
foreach p $txall {puts "ORIGINAL_IO $p DRIVE=[get_property DRIVE $p] SLEW=[get_property SLEW $p]"}
set source [get_pins system_i/gmii2rgmii_calibrated_0/inst/u_rgmii_tx/ODDRE1_tx_clock/CLK]
set f [open [file join $work io_probe.tsv] w]
puts $f "case\tphy_delay_ns\ttx_setup_ns\ttx_hold_ns"
proc io_probe {label delay} {
 global source txports f work
 create_generated_clock -name nlos_phy_tx_capture -source $source -edges {1 2 3} -edge_shift [list $delay $delay $delay] [get_ports RGMII_txc]
 foreach edge {rise fall} {
  if {$edge eq {rise}} {set opts {}} else {set opts {-clock_fall -add_delay}}
  set_output_delay -clock nlos_phy_tx_capture {*}$opts -max 1.35 $txports
  set_output_delay -clock nlos_phy_tx_capture {*}$opts -min -1.35 $txports
 }
 set s [get_property SLACK [get_timing_paths -to $txports -delay_type max -max_paths 1]]
 set h [get_property SLACK [get_timing_paths -to $txports -delay_type min -max_paths 1]]
 puts $f "$label\t$delay\t$s\t$h"; flush $f
 puts "IO_PROBE $label delay=$delay setup=$s hold=$h"
 report_timing -to $txports -delay_type max -max_paths 5 -file [file join $work ${label}_setup.rpt]
 report_timing -to $txports -delay_type min -max_paths 5 -file [file join $work ${label}_hold.rpt]
}
set_property -dict {SLEW FAST DRIVE 12} $txall
io_probe fast12_code13 1.95
io_probe fast12_code14 2.1
set_property -dict {SLEW FAST DRIVE 16} $txall
io_probe fast16_code13 1.95
io_probe fast16_code14 2.1
close $f
puts "IO PLANNING PROBE COMPLETE; ORIGINAL SOURCE AND ROUTED CHECKPOINT UNMODIFIED"
