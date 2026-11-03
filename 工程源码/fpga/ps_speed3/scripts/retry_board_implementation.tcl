set root [file normalize [file join [file dirname [info script]] ..]]
open_project [file join $root vivado board_hybrid board_hybrid.xpr]
if {![llength [get_files -quiet */board_postopt.tcl]]} {add_files -fileset utils_1 [file join $root scripts board_postopt.tcl]}
set_property STEPS.OPT_DESIGN.TCL.POST [file join $root scripts board_postopt.tcl] [get_runs impl_1]
reset_runs impl_1
close_project
source [file join $root scripts implement_board_hybrid.tcl]
