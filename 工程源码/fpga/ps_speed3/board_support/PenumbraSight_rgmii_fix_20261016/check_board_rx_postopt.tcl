set ::penumbra_team_fpga [file normalize [file join [file dirname [info script]] ..]]
source $::penumbra_team_fpga/PenumbraSight_reset_sync_20261016/check_reset_postopt.tcl
set rx_delays [get_cells -hier -filter {REF_NAME == IDELAYE3 && NAME =~ *gmii2rgmii_calibrated_0*}]
if {[llength $rx_delays]!=5} {error "Expected five board RX IDELAYE3 cells"}
foreach cell $rx_delays {
    if {[get_property DELAY_VALUE $cell]!=550 || abs([get_property REFCLK_FREQUENCY $cell]-399.996004)>0.001} {error "RX calibration configuration changed: $cell"}
}
set rx_resets [get_pins -hier -filter {REF_PIN_NAME == CLR && (NAME =~ *gmii2rgmii_calibrated_0*reference_release_reg* || NAME =~ *gmii2rgmii_calibrated_0*ready_pipe_reg*)}]
if {[llength $rx_resets]!=6} {error "Expected exactly six RX synchronizer CLR pins"}
foreach pin $rx_resets {
    if {![get_property ASYNC_REG [get_cells -of_objects $pin]]} {error "ASYNC_REG missing: $pin"}
}
set rx_pll [get_cells -hier -filter {REF_NAME =~ PLLE4* && NAME =~ *rgmii_ref_clock*}]
if {[llength $rx_pll]!=1 || [get_property CLKFBOUT_MULT $rx_pll]!=12 || [get_property CLKOUT0_DIVIDE $rx_pll]!=3} {error "Fixed RX reference PLL missing"}
set rx_refclock [get_clocks -of_objects [get_pins -of_objects $rx_pll -filter {REF_PIN_NAME == CLKOUT0}]]
if {[llength $rx_refclock]!=1 || abs([get_property PERIOD $rx_refclock]-2.500025)>0.001} {error "RX reference clock mismatch"}
puts "BOARD RX POST-OPT CHECK PASS: five 550 ps delays, fixed nominal 400 MHz reference, six ASYNC_REG reset stages"
