set work [file normalize [file dirname [info script]]]
set fh [open [file join $work project hdmi_probe.sim sim_1 behav xsim simulate.log] r]
set sim [read $fh]
close $fh
if {[string first {[PASS] HDMI CLOCK/SERIALIZER PROBE} $sim]<0 || [string first {Fatal:} $sim]>=0} {error "Functional probe must pass first"}
set_param general.maxThreads 2
open_project [file join $work project hdmi_probe.xpr]
add_files -fileset constrs_1 -norecurse [file join $work probe.xdc]
launch_runs synth_1 -jobs 2
wait_on_run synth_1
if {[get_property PROGRESS [get_runs synth_1]] ne "100%"} {error "HDMI probe synthesis failed"}
open_run synth_1
opt_design
place_design
route_design
write_checkpoint -force [file join $work hdmi_safe_routed.dcp]
report_timing_summary -report_unconstrained -file [file join $work hdmi_safe_routed_timing.rpt]
report_drc -file [file join $work hdmi_safe_drc.rpt]
report_route_status -file [file join $work hdmi_safe_route_status.rpt]
report_clocks -file [file join $work hdmi_safe_clocks.rpt]
puts "ISOLATED HDMI IMPLEMENTATION COMPLETE; inspect timing and scope"
close_project
