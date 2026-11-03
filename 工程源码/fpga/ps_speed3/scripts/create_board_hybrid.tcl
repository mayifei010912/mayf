set root [file normalize [file join [file dirname [info script]] ..]]
source [file join $root scripts isolated_board_sources.tcl]
set projectfile [file join $root vivado board_hybrid board_hybrid.xpr]
if {[file exists $projectfile]} {open_project $projectfile} else {
 create_project board_hybrid [file join $root vivado board_hybrid] -part xczu4ev-sfvc784-2-i
 set_property ip_repo_paths $board_repos [current_project]
 update_ip_catalog
 add_files $board_hdl
 add_files [glob [file join $root rtl *.v]]
 add_files [file join $root board_source system.bd]
}
foreach item $board_constraints {
 lassign $item path synth impl order
 if {![llength [get_files -quiet $path]]} {add_files -fileset constrs_1 $path}
 set_property USED_IN_SYNTHESIS $synth [get_files $path]
 set_property USED_IN_IMPLEMENTATION $impl [get_files $path]
 set_property PROCESSING_ORDER $order [get_files $path]
}
open_bd_design [get_files */system.bd]
set fp [open [file join $root reports board_snapshot.txt] w]
foreach c [get_bd_cells -hier -filter {VLNV =~ *axi_interconnect*}] {
 puts $fp "INTERCONNECT $c SI=[get_property CONFIG.NUM_SI $c] MI=[get_property CONFIG.NUM_MI $c]"
}
foreach p [get_bd_pins -hier -filter {NAME =~ *pl_clk* || NAME =~ *pl_reset*}] {puts $fp "PIN $p [get_bd_nets -of_objects $p]"}
foreach i [get_bd_intf_pins -hier -filter {NAME =~ *HPM* || NAME =~ *HP0* || NAME =~ *HPC*}] {puts $fp "BUS $i [get_bd_intf_nets -of_objects $i]"}
foreach p [get_bd_pins -of_objects [get_bd_cells {axi_interconnect_hp0 axi_interconnect_0 nlos_compute}] -filter {TYPE == clk || TYPE == rst}] {puts $fp "PIN $p [get_bd_nets -of_objects $p]"}
close $fp
# Leave the existing video, Ethernet and old NLOS core connected as before.
if {![llength [get_bd_cells -quiet hybrid_reconstruction]]} {create_bd_cell -type module -reference hybrid_fista_accel hybrid_reconstruction}
set f [open [file join $root reports new_module_interfaces.txt] w]
foreach p [get_bd_intf_pins hybrid_reconstruction/*] {puts $f "INTF $p [get_property VLNV $p]"}
foreach p [get_bd_pins hybrid_reconstruction/*] {puts $f "PIN $p"}
close $f
save_bd_design
close_project
puts "PASS ISOLATED BOARD CREATED - new accelerator not yet wired"
