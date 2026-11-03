set work F:/fpga/PenumbraSight_hybrid_FISTA_20261030/board_support/PenumbraSight_interface_closure_20261017
set_param general.maxThreads 2
open_project [file join $work official_ip_project official_bridge.xpr]
set ip [get_ips nlos_vendor_gmii]
set_property CONFIG.RGMII_TXC_SKEW 2 $ip
generate_target all $ip
open_example_project -force -dir [file join $work mmcm_example] $ip
close_project
set examples [glob [file join $work mmcm_example * *.xpr]]
if {[llength $examples]!=1} {error "Expected one MMCM example project: $examples"}
open_project [lindex $examples 0]
set_property xsim.simulate.runtime all [get_filesets sim_1]
launch_simulation
close_sim
close_project
puts "MMCM EXAMPLE SIMULATION FINISHED; CHECK TEST COMPLETED SUCCESSFULLY IN LOG"
