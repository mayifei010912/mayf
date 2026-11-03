set work F:/fpga/PenumbraSight_hybrid_FISTA_20261030/board_support/PenumbraSight_interface_closure_20261017
set_param general.maxThreads 1
open_project [file join $work official_ip_project official_bridge.xpr]
open_example_project -dir [file join $work official_example] [get_ips nlos_vendor_gmii]
puts "EXAMPLE_DIR [get_property DIRECTORY [current_project]]"
puts "EXAMPLE_SIM_TOP [get_property TOP [get_filesets sim_1]]"
set_property xsim.simulate.runtime all [get_filesets sim_1]
launch_simulation
close_sim
close_project
