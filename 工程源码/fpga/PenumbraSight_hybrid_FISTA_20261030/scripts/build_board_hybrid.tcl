set root [file normalize [file join [file dirname [info script]] ..]]
set ::env(TEMP) [file join $root build temp]
set ::env(TMP) $::env(TEMP)
if {![file exists [file join $root reports board_integration_pass.txt]]} {error "Run and pass board BD integration before building"}
open_project [file join $root vivado board_hybrid board_hybrid.xpr]
set_param general.maxThreads 4
generate_target all [get_files */system.bd]
create_ip_run [get_files */system.bd]
launch_runs synth_1 -jobs 4
wait_on_run synth_1
if {[get_property PROGRESS [get_runs synth_1]] ne "100%" || [get_property STATUS [get_runs synth_1]] ne "synth_design Complete!"} {error "Whole-board synthesis failed"}
open_run synth_1
report_utilization -file [file join $root reports board_utilization_synth.rpt]
report_timing_summary -file [file join $root reports board_timing_synth.rpt]
write_checkpoint -force [file join $root reports board_hybrid_synth.dcp]
set f [open [file join $root reports board_synthesis_pass.txt] w]
puts $f "Whole board synthesis passed; this is not yet a routed bitstream or a board computation test."
close $f
close_project
puts "PASS WHOLE BOARD HYBRID SYNTHESIS"
