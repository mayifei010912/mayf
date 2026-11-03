set work [file normalize [file dirname [info script]]]
source [file join $work resume_sim.tcl]
open_project [file join $work project hdmi_probe.xpr]
reset_run synth_1
close_project
source [file join $work implement_probe.tcl]
