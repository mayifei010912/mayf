set root [file normalize [file join [file dirname [info script]] ..]]
set ::env(TEMP) [file join $root build temp]
set ::env(TMP) $::env(TEMP)
open_project [file join $root vivado board_hybrid board_hybrid.xpr]
reset_runs system_hybrid_reconstruction_1_synth_1
reset_runs synth_1
close_project
source [file join $root scripts build_board_hybrid.tcl]
