set root [file normalize [file join [file dirname [info script]] ..]]
create_project hybrid_fista_zu4ev [file join $root vivado hybrid_fista_zu4ev] -part xczu4ev-sfvc784-2-i
set_property target_language Verilog [current_project]
add_files [glob [file join $root rtl *.v]]
set_property top hybrid_fista_accel [current_fileset]
add_files -fileset sim_1 [file join $root sim tb_hybrid_axil.sv]
set_property top tb_hybrid_axil [get_filesets sim_1]
update_compile_order -fileset sources_1
synth_design -top hybrid_fista_accel -part xczu4ev-sfvc784-2-i -mode out_of_context
create_clock -period 20.000 [get_ports aclk]
report_utilization -file [file join $root reports hybrid_utilization_synth.rpt]
report_timing_summary -file [file join $root reports hybrid_timing_synth.rpt]
write_checkpoint [file join $root reports hybrid_synth.dcp]
puts "PASS HYBRID SYNTHESIS ONLY - no board implementation"
close_project
