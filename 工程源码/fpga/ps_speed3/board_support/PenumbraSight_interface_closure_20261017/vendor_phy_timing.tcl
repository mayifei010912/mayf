# YT8521S Table 138: integrated RX skew provides >=1 ns setup/hold.
# Board data/clock skew allowance is +/-0.2 ns, pending PCB trace extraction.
# Keep the IP's DDR edge pairing: setup uses the corresponding source edge;
# hold uses the next opposite data edge. The generated clock follows physical TXC.
set rx [get_ports {RGMII_rd[*] RGMII_rx_ctl}]
set tx [get_ports {RGMII_td[*] RGMII_tx_ctl}]
set rvirtual [get_clocks system_vendor_gmii_0_rgmii_rx_clk]
set tforward [get_clocks system_vendor_gmii_0_rgmii_tx_clk]
if {[llength $rx]!=5 || [llength $tx]!=5 || [llength $rvirtual]!=1 || [llength $tforward]!=1} {error "Vendor RGMII timing scope mismatch"}
# Vivado 2020.2 represents MMCM phase shift as clock latency here: the
# forwarded clock waveform remains {0 4}. Capture the SAME source edge,
# rather than accidentally allowing an additional whole 8 ns cycle.
set task_txsource [get_clocks -of [get_pins -of [get_cells -hier -filter {NAME =~ *vendor_gmii*i_bufgmux_gmii_clk}] -filter {REF_PIN_NAME == O}]]
# The synthesized BUFGMUX uses inverted CE0, noninverted CE1 and both S pins
# tied high. A raw speed value of 1 selects gigabit on BOTH CE pins.
foreach task_mux [get_cells -hier -filter {NAME =~ *vendor_gmii*i_bufgmux_gmii_clk || NAME =~ *vendor_gmii*i_bufgmux_gmii_90_clk}] {
  foreach task_pin {CE0 CE1 S0 S1} {set_case_analysis 1 [get_pins $task_mux/$task_pin]}
}
set_multicycle_path -from $task_txsource -to $tforward -setup 0
set_multicycle_path -from $task_txsource -to $tforward -hold -1
set_input_delay -clock $rvirtual -max -0.8 $rx
set_input_delay -clock $rvirtual -min -3.2 $rx
set_input_delay -clock $rvirtual -clock_fall -max -0.8 -add_delay $rx
set_input_delay -clock $rvirtual -clock_fall -min -3.2 -add_delay $rx
# Requires PHY TX internal delay disabled: skew is generated inside FPGA.
set_output_delay -clock $tforward -max 1.2 $tx
set_output_delay -clock $tforward -min -1.2 $tx
set_output_delay -clock $tforward -clock_fall -max 1.2 -add_delay $tx
set_output_delay -clock $tforward -clock_fall -min -1.2 -add_delay $tx
set_property -dict {SLEW FAST DRIVE 12} [get_ports {RGMII_td[*] RGMII_tx_ctl RGMII_txc}]
set rxdelay [get_cells -hier -filter {NAME =~ *vendor_gmii*gen_rgmii_rx_zqup* && REF_NAME == IDELAYE3}]
if {[llength $rxdelay]!=5} {error "Expected five vendor receive IDELAYs"}
set_property DELAY_VALUE 550 $rxdelay
# PS BD metadata gives 374996246 Hz. The PS IP's generated XDC truncates
# this to 2.666 ns, spuriously exceeding the MMCM 375 MHz input limit.
set task_ref_hz 374996246.0
set task_ref_period [expr {1.0e9/$task_ref_hz}]
create_clock -name clk_pl_1 -period $task_ref_period [get_pins {system_i/zynq_ultra_ps_e_0/inst/PS8_i/PLCLK[1]}]
set task_delays [get_cells -hier -filter {NAME =~ *vendor_gmii* && REF_NAME =~ *DELAYE3}]
set_property REFCLK_FREQUENCY [expr {$task_ref_hz/1.0e6}] $task_delays
set_property CLKIN1_PERIOD $task_ref_period [get_cells -hier -filter {NAME =~ *vendor_gmii* && REF_NAME == MMCME4_ADV}]
set task_mux_outputs [get_pins -of [get_cells -hier -filter {NAME =~ *vendor_gmii*i_bufgmux_gmii_clk || NAME =~ *vendor_gmii*i_bufgmux_gmii_90_clk}] -filter {REF_PIN_NAME == O}]
if {[llength $task_mux_outputs]==2} {
  set_property CLOCK_DELAY_GROUP vendor_gmii_tx_phase_group [get_nets -of $task_mux_outputs]
  set task_stem system_i/vendor_gmii/U0/i_gmii_to_rgmii_block
  set_property LOC BUFGCTRL_X0Y22 [get_cells $task_stem/i_bufgmux_gmii_90_clk]
  set_property LOC BUFGCTRL_X0Y23 [get_cells $task_stem/i_bufgmux_gmii_clk_25m_2_5m_90]
  set task_mipi_buf [get_cells -hier -filter {NAME =~ *GEN_PLL_IN_IP_USP.pll0_clkout0_buf && REF_NAME == BUFGCE}]
  if {[llength $task_mipi_buf]!=1} {error "Expected one MIPI PLL output buffer"}
  set_property LOC BUFGCE_X0Y65 $task_mipi_buf
}
puts "YT8521 RGMII constraints applied: 1ns setup/hold + 0.2ns PCB skew; RX IDELAY 550ps; PHY TX delay must be disabled"
