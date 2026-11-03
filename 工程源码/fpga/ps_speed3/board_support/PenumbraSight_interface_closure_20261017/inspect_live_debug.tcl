open_hw_manager
connect_hw_server -url localhost:3122
refresh_hw_server
set t [get_hw_targets -quiet *210512180081]
if {[llength $t]!=1} {error "Replacement JTAG cable not uniquely found"}
current_hw_target $t
set_property PARAM.FREQUENCY 5000000 $t
open_hw_target
set d [get_hw_devices xczu4_0]
current_hw_device $d
refresh_hw_device -update_hw_probes false $d
puts "LIVE_PART: [get_property PART $d]"
puts "LIVE_ILAS: [get_hw_ilas -quiet -of_objects $d]"
puts "LIVE_VIOS: [get_hw_vios -quiet -of_objects $d]"
report_property $d
close_hw_target
disconnect_hw_server
close_hw_manager
puts LIVE_DEBUG_INSPECTION_COMPLETE
