set work [file normalize [file dirname [info script]]]
set_param general.maxThreads 2
open_project [file join $work project hdmi_probe.xpr]
open_run synth_1
opt_design
place_design -directive Explore
phys_opt_design -directive Explore
route_design -directive Explore
write_checkpoint -force [file join $work hdmi_physopt_routed.dcp]
report_timing_summary -report_unconstrained -file [file join $work hdmi_physopt_timing.rpt]
report_drc -file [file join $work hdmi_physopt_drc.rpt]
report_route_status -file [file join $work hdmi_physopt_route_status.rpt]
puts "PHYSOPT HDMI PROBE COMPLETE; inspect final report"
