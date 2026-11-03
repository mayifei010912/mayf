set root F:/fpga/PenumbraSight_hybrid_FISTA_20261030
if {![file exists $root/reports/board_quiesced_20261031.txt]} {error "Board PL clients have not been quiesced"}
if {[clock seconds]-[file mtime $root/reports/board_quiesced_20261031.txt]>300} {error "Quiesce proof is stale; inspect board again"}
if {![file exists $root/vivado/board_hybrid/board_hybrid.bit]} {error "New bit missing"}
open_hw_manager
connect_hw_server -url localhost:3121
refresh_hw_server
set target [get_hw_targets -quiet *C305BDB3ABCD]
if {[llength $target]!=1} {error "Expected the adapter verified in this session"}
current_hw_target $target
set_property PARAM.FREQUENCY 1000000 $target
open_hw_target
set d [get_hw_devices -quiet xczu4_0]
if {[llength $d]!=1} {error "ZU4 device missing"}
refresh_hw_device -update_hw_probes false $d
if {[get_property VARIANT_NAME $d] ne "zu4ev"} {error "Wrong FPGA variant"}
set_property PROBES.FILE {} $d
set_property FULL_PROBES.FILE {} $d
set_property PROGRAM.FILE $root/vivado/board_hybrid/board_hybrid.bit $d
program_hw_devices $d
refresh_hw_device -update_hw_probes false $d
puts "HYBRID_PROGRAMMED_VOLATILE_ONLY - physical compute check still required"
close_hw_target
disconnect_hw_server
close_hw_manager
exit
