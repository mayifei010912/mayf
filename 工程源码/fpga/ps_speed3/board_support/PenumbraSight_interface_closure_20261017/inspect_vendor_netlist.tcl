set f [open F:/fpga/PenumbraSight_hybrid_FISTA_20261030/board_support/PenumbraSight_interface_closure_20261017/vendor_netlist_details.txt w]
foreach pattern {*vendor_gmii*rgmii_txc* *vendor_gmii*delay_rgmii* *vendor_gmii*MDIO* *vendor_gmii*mdio* *vendor_gmii*i_bufgmux*} {
  foreach cell [get_cells -hier -filter "NAME =~ $pattern"] {
    puts $f "CELL $cell REF=[get_property REF_NAME $cell]"
    foreach prop {INIT DELAY_VALUE DELAY_FORMAT DELAY_TYPE REFCLK_FREQUENCY UPDATE_MODE IS_C_INVERTED IS_CLK_INVERTED} {
      if {[lsearch -exact [list_property $cell] $prop]>=0} {puts $f "  $prop=[get_property $prop $cell]"}
    }
    foreach pin [get_pins -of $cell] {
      set name [get_property REF_PIN_NAME $pin]
      if {$name in {CLK C D D1 D2 D3 D4 D5 D6 D7 D8 Q O ODDRE1_I ODDRE1_O CE0 CE1 S0 S1 I0 I1}} {
        puts $f "  $name [get_nets -of $pin] [get_clocks -quiet -of $pin]"
      }
    }
  }
}
close $f
report_exceptions -file F:/fpga/PenumbraSight_hybrid_FISTA_20261030/board_support/PenumbraSight_interface_closure_20261017/vendor_synth_exceptions.rpt
puts VENDOR_NETLIST_INSPECTION_COMPLETE
