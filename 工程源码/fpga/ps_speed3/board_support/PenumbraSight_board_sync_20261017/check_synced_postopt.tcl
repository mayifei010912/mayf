set ::penumbra_team_fpga [file normalize [file join [file dirname [info script]] ..]]
source $::penumbra_team_fpga/PenumbraSight_rgmii_fix_20261016/check_board_rx_postopt.tcl
source $::penumbra_team_fpga/PenumbraSight_board_sync_20261017/check_synced_netlist.tcl
set nlos_tx_ready_c [get_pins -hier -filter {NAME == "system_i/gmii2rgmii_calibrated_0/inst/u_rgmii_rx/ready_pipe_reg[2]/C"}]
set nlos_tx_guard_rst [get_pins -hier -filter {NAME =~ *gmii2rgmii_calibrated_0*ODDRE1_tx_ctl/* && (REF_PIN_NAME == RST || REF_PIN_NAME == SR)}]
if {[llength $nlos_tx_ready_c]!=1 || [llength $nlos_tx_guard_rst]!=1} {error "TX guard propagation constraint objects missing"}
puts "SYNCED IMPLEMENTATION POST-OPT CHECK PASS: corrected clocks, calibration reset guard and implementation constraints present"
