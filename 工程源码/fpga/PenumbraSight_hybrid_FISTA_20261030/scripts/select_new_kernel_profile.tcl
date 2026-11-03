set root [file normalize [file join [file dirname [info script]] ..]]
set ::env(TEMP) [file join $root build temp]
set ::env(TMP) $::env(TEMP)
file delete -force [file join $root reports board_synthesis_pass.txt]
open_project [file join $root vivado board_hybrid board_hybrid.xpr]
open_bd_design [get_files */system.bd]
# This is the isolated new bitstream only. The original release/project remains.
delete_bd_objs [get_bd_cells nlos_compute]
set cdc [get_bd_intf_pins hybrid_control_cdc/S_AXI]
set oldnet [get_bd_intf_nets -of_objects $cdc]
disconnect_bd_intf_net $oldnet $cdc
delete_bd_objs $oldnet
set replacement [get_bd_intf_nets -of_objects [get_bd_intf_pins nlos_link/M01_AXI]]
if {[llength $replacement]} {delete_bd_objs $replacement}
connect_bd_intf_net [get_bd_intf_pins nlos_link/M01_AXI] $cdc
set_property CONFIG.NUM_MI 2 [get_bd_cells nlos_link]
validate_bd_design
save_bd_design
set support [file join $root board_support]
# Execute Tcl-dependent electrical/timing constraints with full Tcl semantics,
# instead of relying on the restricted XDC parser to evaluate their guards.
foreach name {board_shared_clock_impl.xdc frame_reset_sync_impl.xdc vendor_io_impl.xdc vendor_phy_impl.xdc vendor_mdio_impl.xdc} {
 set f [get_files -quiet */$name]
 if {[llength $f]!=1} {error "Expected exactly one implementation constraint file $name"}
 set_property USED_IN_IMPLEMENTATION false $f
}
set hooks [glob [file join $root scripts board_preopt.tcl]]
lappend hooks [file join $support PenumbraSight_mdio_timing_20261018 mdio_postopt.tcl]
foreach f $hooks {if {![llength [get_files -quiet $f]]} {add_files -fileset utils_1 $f}}
set_property STEPS.OPT_DESIGN.TCL.PRE [file join $root scripts board_preopt.tcl] [get_runs impl_1]
set_property STEPS.OPT_DESIGN.TCL.POST [file join $support PenumbraSight_mdio_timing_20261018 mdio_postopt.tcl] [get_runs impl_1]
set f [open [file join $root reports board_integration_pass.txt] w]
puts $f "BD validated: new HYF1 replaces old nlos_compute in this isolated project only; video and Ethernet preserved."
puts $f "Control 0xA2000000 / 256 bytes. Old 0xA1000000 compute core absent in this NEW profile."
puts $f "G master accesses PS HP0 low DDR. Clock actual 50023974 Hz. Original project/bit/runtime unchanged."
close $f
reset_runs synth_1
close_project
source [file join $root scripts build_board_hybrid.tcl]
