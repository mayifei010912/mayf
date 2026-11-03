set root [file normalize [file join [file dirname [info script]] ..]]
set proof [file join $root reports board_quiesced_for_speed2.json]
if {![file exists $proof] || [clock seconds]-[file mtime $proof]>300} {error "Fresh idle/quiesced board proof required"}
if {![file exists [file join $root reports SPEED2_BIT_COMPLETE.txt]]} {error "Speed2 build did not pass"}
open_hw_manager
connect_hw_server -url localhost:3121
refresh_hw_server
set target [get_hw_targets -quiet *C305BDB3ABCD]
if {[llength $target]!=1} {error "Expected verified adapter"}
current_hw_target $target
set_property PARAM.FREQUENCY 1000000 $target
open_hw_target
set d [get_hw_devices -quiet xczu4_0]
if {[llength $d]!=1} {error "ZU4 device missing"}
refresh_hw_device -update_hw_probes false $d
if {[get_property VARIANT_NAME $d] ne "zu4ev"} {error "Wrong FPGA variant"}
set_property PROBES.FILE {} $d
set_property FULL_PROBES.FILE {} $d
set_property PROGRAM.FILE [file join $root vivado board_hybrid board_speed2.bit] $d
program_hw_devices $d
refresh_hw_device -update_hw_probes false $d
puts "SPEED2_PROGRAMMED_VOLATILE_ONLY; PHYSICAL CHECK REQUIRED"
close_hw_target
disconnect_hw_server
close_hw_manager
exit
