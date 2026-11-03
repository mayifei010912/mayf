set work [file normalize [file dirname [info script]]]
set fh [open [file join $work shared_project hdmi_shared_probe.sim sim_1 behav xsim simulate.log] r]
set sim [read $fh]
close $fh
if {[string first {[PASS] HDMI CLOCK/SERIALIZER PROBE} $sim]<0 || [string first {Fatal:} $sim]>=0} {error "Functional shared-clock probe must pass first"}
set_param general.maxThreads 2
open_project [file join $work shared_project hdmi_shared_probe.xpr]
launch_runs synth_1 -jobs 2
wait_on_run synth_1
if {[get_property PROGRESS [get_runs synth_1]] ne "100%"} {error "Shared HDMI synthesis failed"}
open_run synth_1
opt_design
place_design
route_design
write_checkpoint -force [file join $work hdmi_shared_routed.dcp]
report_timing_summary -report_unconstrained -file [file join $work hdmi_shared_timing.rpt]
report_drc -file [file join $work hdmi_shared_drc.rpt]
report_route_status -file [file join $work hdmi_shared_route_status.rpt]
report_clocks -file [file join $work hdmi_shared_clocks.rpt]
puts "ISOLATED SHARED HDMI IMPLEMENTATION COMPLETE; inspect timing and scope"
close_project
