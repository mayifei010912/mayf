set work [file normalize [file dirname [info script]]]
open_project [file join $work project hdmi_probe.xpr]
# The clock IP has its own synthesis run; refreshing only the parent is insufficient.
reset_run hdmi_safe_clock_synth_1
reset_run synth_1
close_project
source [file join $work implement_probe.tcl]
