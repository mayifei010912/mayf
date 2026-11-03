set task_dir F:/fpga/PenumbraSight_hybrid_FISTA_20261030/board_support/PenumbraSight_mdio_timing_20261018
set_param general.maxThreads 2
open_checkpoint F:/fpga/PenumbraSight_hybrid_FISTA_20261030/board_support/PenumbraSight_interface_closure_20261017/vendor_rgmii_verified_routed.dcp
source [file join $task_dir mdio_edge_timing.tcl]
report_clocks -file [file join $task_dir clocks.rpt]
report_timing -to [get_ports MDIO_mdio_io] -delay_type min_max -max_paths 20 -nworst 20 -path_type full_clock_expanded -file [file join $task_dir mdio_output.rpt]
report_timing -from [get_ports MDIO_mdio_io] -delay_type min_max -max_paths 20 -nworst 20 -path_type full_clock_expanded -file [file join $task_dir mdio_input.rpt]
report_timing -through [get_pins MDIO_mdio_iobuf/OBUFT/T] -delay_type min_max -max_paths 10 -nworst 10 -path_type full_clock_expanded -file [file join $task_dir mdio_enable.rpt]
foreach pin {EMIOENET0MDIOO EMIOENET0MDIOTN EMIOENET0MDIOI EMIOENET0MDIOMDC} {
  set p [get_pins $mdio_ps/$pin]
  puts "PS8_PIN $pin CLOCKS=[get_clocks -quiet -of_objects $p]"
}
puts {MDIO REPORTS READY}
close_design
exit
