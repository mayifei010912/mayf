open_hw_manager
connect_hw_server -url localhost:3121
refresh_hw_server
set targets [get_hw_targets -quiet]
puts "HYBRID_JTAG_TARGETS $targets"
if {[llength $targets]!=1} {error "Expected one connected JTAG target; no programming performed"}
current_hw_target [lindex $targets 0]
set_property PARAM.FREQUENCY 1000000 [current_hw_target]
open_hw_target
puts "HYBRID_JTAG_DEVICES [get_hw_devices -quiet]"
set parts [get_hw_devices -quiet xczu4*]
if {[llength $parts]!=1} {error "ZU4 device not uniquely detected"}
refresh_hw_device -update_hw_probes false [lindex $parts 0]
puts "HYBRID_JTAG_VARIANT [get_property VARIANT_NAME [lindex $parts 0]]"
puts "PASS READONLY JTAG CONNECTION - no bitstream downloaded"
close_hw_target
disconnect_hw_server
close_hw_manager
exit
