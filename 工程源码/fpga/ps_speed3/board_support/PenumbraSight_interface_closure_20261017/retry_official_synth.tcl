set_param general.maxThreads 1
open_project F:/fpga/PenumbraSight_hybrid_FISTA_20261030/board_support/PenumbraSight_interface_closure_20261017/official_ip_project/official_bridge.xpr
set ip [get_ips nlos_vendor_gmii]
create_ip_run $ip
set r [get_runs nlos_vendor_gmii_synth_1]
launch_runs $r -jobs 1
wait_on_run $r
puts "OFFICIAL IP RUN STATUS: [get_property STATUS $r]"
if {![regexp {synth_design Complete} [get_property STATUS $r]]} {error "Official bridge IP synthesis did not complete"}
close_project
