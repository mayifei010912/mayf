set work F:/fpga/PenumbraSight_hybrid_FISTA_20261030/board_support/PenumbraSight_rgmii_fix_20261016
create_project -force board_clock_rx [file join $work board_clock_sim] -part xczu4ev-sfvc784-2-i
add_files -norecurse [list [file join $work rgmii_calibration_clock.v] [file join $work ip_repo gmii_calibrated rgmii_rx_calibrated.v]]
add_files -fileset sim_1 -norecurse [file join $work tb_rgmii_rx_board_clock.sv]
set_property top rgmii_rx_calibrated [get_filesets sources_1]
set_property top tb_rgmii_rx_board_clock [get_filesets sim_1]
set_property xsim.simulate.runtime all [get_filesets sim_1]
launch_simulation
close_sim
set f [open [file join $work board_clock_sim board_clock_rx.sim sim_1 behav xsim simulate.log] r]
set s [read $f]; close $f
if {[string first {[PASS] BOARD CLOCK CALIBRATED RGMII RX: 768} $s]<0 || [string first {Fatal:} $s]>=0} {error "Board reference-clock receiver simulation failed"}
puts "BOARD FIXED NOMINAL 400 MHZ CLOCK AND RX SIMULATION CHECK PASS"
close_project
