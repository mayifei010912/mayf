set work [file normalize [file dirname [info script]]]
open_project [file join $work project hdmi_probe.xpr]
set_property -dict [list CONFIG.CLKOUT2_MATCHED_ROUTING false \
    CONFIG.CLKOUT3_MATCHED_ROUTING false CONFIG.CLKOUT4_MATCHED_ROUTING false \
    CONFIG.CLKOUT3_DRIVES No_buffer] [get_ips hdmi_safe_clock]
generate_target all [get_ips hdmi_safe_clock]
add_files -norecurse [file join $work hdmi_clock_pair.v]
update_compile_order -fileset sources_1
launch_simulation
close_sim
set fid [open [file join $work project hdmi_probe.sim sim_1 behav xsim simulate.log] r]
set evidence [read $fid]
close $fid
if {[string first {[PASS] HDMI CLOCK/SERIALIZER PROBE} $evidence]<0 || [string first {Fatal:} $evidence]>=0} {error "Parallel clock simulation failed"}
puts "PARALLEL HDMI CLOCK SIMULATION CHECK PASS"
reset_run synth_1
reset_run hdmi_safe_clock_synth_1
close_project
source [file join $work implement_probe.tcl]
