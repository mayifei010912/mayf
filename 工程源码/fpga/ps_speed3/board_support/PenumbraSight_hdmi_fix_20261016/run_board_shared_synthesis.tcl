# Full-board synthesis of the HDMI shared-clock board COPY, without implementation or hardware access.
set board F:/fpga/PenumbraSight_hybrid_FISTA_20261030/board_support/PenumbraSight_board_synth_20261016
set out F:/fpga/PenumbraSight_hybrid_FISTA_20261030/board_support/PenumbraSight_hdmi_fix_20261016
set_param general.maxThreads 2
open_project [file join $board project mpsoc_p4_board_nlos.xpr]
if {[get_property PART [current_project]] ne {xczu4ev-sfvc784-2-i}} {error "Unexpected FPGA part"}
set bd [get_files */source_full/system/system.bd]
if {[llength $bd] != 1} {error "Board BD missing"}
open_bd_design $bd
if {[llength [get_bd_cells -quiet hdmi_shared]] != 1} {error "Shared HDMI clock absent"}
update_compile_order -fileset sources_1
launch_runs synth_1 -jobs 2
wait_on_run synth_1
set run [get_runs synth_1]
set status [get_property STATUS $run]
set progress [get_property PROGRESS $run]
puts "BOARD SYNTHESIS RUN STATUS: $status ; progress=$progress"
if {$progress ne {100%} || ![regexp -nocase {complete} $status]} {
    error "Full-board synthesis failed; inspect synth_1/runme.log"
}
open_run synth_1
report_utilization -file [file join $out board_shared_synth_utilization.rpt]
report_timing_summary -delay_type min_max -report_unconstrained -file [file join $out board_shared_synth_timing.rpt]
report_drc -file [file join $out board_shared_synth_drc.rpt]
report_clocks -file [file join $out board_shared_synth_clocks.rpt]
puts "BOARD SHARED CLOCK SYNTHESIS PASS: full XCZU4EV design compiled"
puts "Scope: post-synthesis reports only; implementation, routed timing, bitstream and board operation pending"
close_project
