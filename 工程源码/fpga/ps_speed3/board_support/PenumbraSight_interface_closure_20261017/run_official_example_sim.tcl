set_param general.maxThreads 1
open_project F:/fpga/PenumbraSight_hybrid_FISTA_20261030/board_support/PenumbraSight_interface_closure_20261017/official_example/nlos_vendor_gmii_ex/nlos_vendor_gmii_ex.xpr
puts "EXAMPLE_SIM_TOP [get_property TOP [get_filesets sim_1]]"
set_property xsim.simulate.runtime all [get_filesets sim_1]
launch_simulation
close_sim
close_project
