set root [file normalize [file join [file dirname [info script]] ..]]
set src F:/fpga/PenumbraSight_team_20261028/01_vivado/fpga/project/board_vendor_gmii.xpr
open_project -read_only $src
set out [open [file join $root scripts board_sources.tcl] w]
puts $out "# Read-only inventory of the preserved board project; sources are not modified."
puts $out [list set vendor_repos [get_property ip_repo_paths [current_project]]]
set sources {}
foreach f [get_files -of_objects [get_filesets sources_1]] {
 if {[get_property FILE_TYPE $f] ne "Block Designs" && [file extension $f] ni {.xci .xcix}} {lappend sources [file normalize $f]}
}
puts $out [list set vendor_hdl $sources]
set constraints {}
foreach f [get_files -of_objects [get_filesets constrs_1]] {
 lappend constraints [list [file normalize $f] [get_property USED_IN_SYNTHESIS $f] [get_property USED_IN_IMPLEMENTATION $f] [get_property PROCESSING_ORDER $f]]
}
puts $out [list set vendor_constraints $constraints]
close $out
open_bd_design [get_files */system.bd]
write_bd_tcl -force [file join $root scripts vendor_bd_snapshot.tcl]
set fp [open [file join $root reports board_snapshot.txt] w]
puts $fp "SOURCE $src"
puts $fp "READONLY original HDL/constraints registered=$sources"
foreach c [get_bd_cells -hier -filter {VLNV =~ *axi_interconnect*}] {
 puts $fp "INTERCONNECT $c [get_property CONFIG.NUM_SI $c] [get_property CONFIG.NUM_MI $c]"
}
foreach i [get_bd_intf_pins -hier -filter {NAME =~ *HPM* || NAME =~ *HP0* || NAME =~ *HPC*}] {
 puts $fp "BUS $i NET=[get_bd_intf_nets -of_objects $i]"
}
foreach c {zynq_ultra_ps_e_0 clk_wiz_0 nlos_reset axi_interconnect_hp0 axi_interconnect_0} {
 foreach p [get_bd_pins -of_objects [get_bd_cells $c] -filter {TYPE == clk || TYPE == rst}] {puts $fp "PIN $p [get_bd_nets -of_objects $p]"}
}
close $fp
close_project
puts "PASS READONLY BOARD SNAPSHOT"
