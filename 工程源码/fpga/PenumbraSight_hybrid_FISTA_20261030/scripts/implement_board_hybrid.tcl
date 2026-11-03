set root [file normalize [file join [file dirname [info script]] ..]]
set ::env(TEMP) F:/fpga/hybrid_tmp_1030
file mkdir $::env(TEMP)
set ::env(TMP) $::env(TEMP)
if {![file exists [file join $root reports board_synthesis_pass.txt]]} {error "Whole-board synthesis has not passed"}
open_project [file join $root vivado board_hybrid board_hybrid.xpr]
set_param general.maxThreads 4
launch_runs impl_1 -to_step route_design -jobs 4
wait_on_run impl_1
if {[get_property PROGRESS [get_runs impl_1]] ne "100%"} {error "Board route did not finish"}
open_run impl_1
set hybrid_ffs [get_cells -hier -filter {NAME =~ *hybrid_reconstruction* && REF_NAME =~ FD*}]
if {[llength $hybrid_ffs]<1000} {error "New kernel sequential cells missing"}
set hybrid_clocks [get_clocks -of_objects [get_pins -of_objects $hybrid_ffs -filter {REF_PIN_NAME == C}]]
if {[llength $hybrid_clocks]!=1} {error "Expected one timed kernel clock: $hybrid_clocks"}
set hybrid_period [get_property PERIOD $hybrid_clocks]
if {$hybrid_period<19.9 || $hybrid_period>20.1} {error "New kernel not timed near 50 MHz: $hybrid_period ns"}
report_timing_summary -file [file join $root reports board_timing_routed.rpt]
report_drc -file [file join $root reports board_drc_routed.rpt]
set badtiming [get_timing_paths -quiet -slack_lesser_than 0 -max_paths 1]
set badhold [get_timing_paths -quiet -delay_type min -slack_lesser_than 0 -max_paths 1]
if {[llength $badtiming] || [llength $badhold]} {error "Routed timing has negative slack; bitstream not generated"}
set drc_errors [get_drc_violations -quiet -filter {SEVERITY == Error}]
if {[llength $drc_errors]} {error "DRC errors remain; bitstream not generated"}
write_checkpoint -force [file join $root reports board_hybrid_routed.dcp]
write_bitstream -force [file join $root vivado board_hybrid board_hybrid.bit]
close_project
puts "PASS ROUTED BITSTREAM GENERATED - physical board validation still required"
