# Run on the preserved routed MMCM variant. This only changes the analysis view.
set work F:/fpga/PenumbraSight_hybrid_FISTA_20261030/board_support/PenumbraSight_interface_closure_20261017
set stem system_i/vendor_gmii/U0/i_gmii_to_rgmii_block
if {![info exists audit_rates]} {set audit_rates {1000 100 10}}
if {![info exists audit_append]} {set audit_append 0}
set f [open [file join $work vendor_rate_audit.tsv] [expr {$audit_append ? "a" : "w"}]]
if {!$audit_append} {puts $f "rate\trx_period\tduty\trx_setup\trx_hold\ttx_setup\ttx_hold"}
proc set_mux {cell high} {
  # BUFGMUX maps to BUFGCTRL with inverted CE0 and shared raw speed net.
  # Select each physical pin using its inversion property, not idealized pins.
  foreach {pin active} [list CE0 [expr {!$high}] CE1 $high S0 1 S1 1] {
    set inverted [get_property IS_INVERTED [get_pins $cell/$pin]]
    set value [expr {$active ^ $inverted}]
    set_case_analysis $value [get_pins $cell/$pin]
  }
}
proc worst_slack {ports direction delay} {
  if {$direction eq "input"} {set paths [get_timing_paths -from $ports -delay_type $delay -max_paths 1]
  } else {set paths [get_timing_paths -to $ports -delay_type $delay -max_paths 1]}
  if {[llength $paths]!=1} {error "Missing $direction $delay timing path"}
  return [get_property SLACK $paths]
}
set rp [get_ports {RGMII_rd[*] RGMII_rx_ctl}]
set tp [get_ports {RGMII_td[*] RGMII_tx_ctl}]
foreach rate $audit_rates {
  set high [expr {$rate==1000}]
  foreach suffix {i_bufgmux_gmii_clk i_bufgmux_gmii_90_clk} {set_mux $stem/$suffix $high}
  if {!$high} {
    foreach suffix {i_bufgmux_gmii_clk_25m_2_5m i_bufgmux_gmii_clk_25m_2_5m_90} {set_mux $stem/$suffix [expr {$rate==100}]}
    set index [expr {$rate==100 ? 1 : 0}]
    set master [get_clocks -of [get_pins $stem/i_bufgmux_gmii_clk_25m_2_5m_90/I$index]]
  } else {set master [get_clocks -of [get_pins $stem/i_bufgmux_gmii_90_clk/I1]]}
  if {[llength $master]!=1} {error "Expected one TX clock master for $rate: $master"}
  set cp [get_pins -of [get_cells -hier -filter {NAME =~ *vendor_gmii*rgmii_txc_out}] -filter {REF_PIN_NAME == CLK}]
  create_generated_clock -add -name system_vendor_gmii_0_rgmii_tx_clk -divide_by 1 -source $cp -master_clock $master [get_ports RGMII_txc]
  if {!$high} {set src [get_clocks -of [get_pins $stem/i_bufgmux_gmii_clk_25m_2_5m/I$index]]
  } else {set src [get_clocks -of [get_pins $stem/i_bufgmux_gmii_clk/I1]]}
  set dst [get_clocks system_vendor_gmii_0_rgmii_tx_clk]
  set_multicycle_path -from $src -to $dst -setup 0
  set_multicycle_path -from $src -to $dst -hold -1
  report_clocks -file [file join $work audit_${rate}_clocks.rpt]
  set_false_path -rise_from $src -fall_to $dst -setup
  set_false_path -fall_from $src -rise_to $dst -setup
  set_false_path -rise_from $src -rise_to $dst -hold
  set_false_path -fall_from $src -fall_to $dst -hold
  set_output_delay -clock $dst -max 1.2 $tp
  set_output_delay -clock $dst -min -1.2 $tp
  set_output_delay -clock $dst -clock_fall -max 1.2 -add_delay $tp
  set_output_delay -clock $dst -clock_fall -min -1.2 -add_delay $tp
  if {$rate==1000} {set cases {{8.0 0.5} {7.2 0.45} {7.2 0.55} {8.8 0.45} {8.8 0.55}}
  } elseif {$rate==100} {set cases {{40.0 0.4} {40.0 0.6}}
  } else {set cases {{400.0 0.4} {400.0 0.6}}}
  foreach test $cases {
    lassign $test period duty
    set high_ns [expr {$period*$duty}]
    set low_ns [expr {$period-$high_ns}]
    create_clock -name RGMII_rxc -period $period -waveform [list 0 $high_ns] [get_ports RGMII_rxc]
    create_clock -name system_vendor_gmii_0_rgmii_rx_clk -period $period -waveform [list 0 $high_ns]
    set_input_delay -clock system_vendor_gmii_0_rgmii_rx_clk -max -0.8 $rp
    set_input_delay -clock system_vendor_gmii_0_rgmii_rx_clk -min [expr {-$low_ns+0.8}] $rp
    set_input_delay -clock system_vendor_gmii_0_rgmii_rx_clk -clock_fall -max -0.8 -add_delay $rp
    set_input_delay -clock system_vendor_gmii_0_rgmii_rx_clk -clock_fall -min [expr {-$high_ns+0.8}] -add_delay $rp
    set row [list $rate $period $duty [worst_slack $rp input max] [worst_slack $rp input min] [worst_slack $tp output max] [worst_slack $tp output min]]
    puts $f [join $row \t]
    flush $f
    puts "RATE_CASE $row"
    report_timing -to $tp -delay_type min_max -max_paths 10 -path_type full_clock_expanded -file [file join $work rate_${rate}_${period}_${duty}_tx.rpt]
  }
}
close $f
puts "RATE AUDIT COMPLETE; RESTORE ROUTED CHECKPOINT BEFORE FURTHER IMPLEMENTATION"
