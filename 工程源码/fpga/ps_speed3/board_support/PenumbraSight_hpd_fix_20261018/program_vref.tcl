set task_dir F:/fpga/PenumbraSight_hybrid_FISTA_20261030/board_support/PenumbraSight_hpd_fix_20261018
open_hw_manager
connect_hw_server -url localhost:3122
refresh_hw_server
set t [get_hw_targets -quiet *210512180081]
if {[llength $t] != 1} {error "Expected replacement JTAG adapter"}
current_hw_target $t
set_property PARAM.FREQUENCY 1000000 $t
open_hw_target
set d [get_hw_devices xczu4_0]
current_hw_device $d
refresh_hw_device -update_hw_probes false $d
if {[get_property VARIANT_NAME $d] ne "zu4ev"} {error "Wrong FPGA variant"}
set_property PROBES.FILE {} $d
set_property FULL_PROBES.FILE {} $d
set_property PROGRAM.FILE [file join $task_dir hpd_vref.bit] $d
program_hw_devices $d
refresh_hw_device -update_hw_probes false $d
foreach p [list_property $d] {if {[string match *DONE* $p]} {puts "DEVICE_DONE $p [get_property $p $d]"}}
puts "RELEASE_VARIANT [get_property VARIANT_NAME $d]"
puts {RELEASE_PROGRAMMED_VOLATILE_ONLY}
close_hw_target
disconnect_hw_server
close_hw_manager
exit

