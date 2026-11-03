set board F:/fpga/PenumbraSight_hybrid_FISTA_20261030/board_support/PenumbraSight_board_synth_20261016
set_param general.maxThreads 2
open_project [file join $board project mpsoc_p4_board_nlos.xpr]
set xdc [get_files F:/fpga/PenumbraSight_hybrid_FISTA_20261030/board_support/PenumbraSight_hdmi_fix_20261016/board_shared_clock_impl.xdc]
if {[llength $xdc] != 1 || [get_property USED_IN_SYNTHESIS $xdc] || ![get_property USED_IN_IMPLEMENTATION $xdc]} {
    error "HDMI clock group XDC is not implementation-only"
}
reset_run synth_1
launch_runs synth_1 -jobs 2
wait_on_run synth_1
set run [get_runs synth_1]
set status [get_property STATUS $run]
puts "BOARD SYNTHESIS CORRECTED XDC STATUS: $status"
if {[get_property PROGRESS $run] ne {100%} || ![regexp -nocase {complete} $status]} {
    error "Corrected-XDC synthesis did not complete"
}
set logfile [file join $board project mpsoc_p4_board_nlos.runs synth_1 runme.log]
set fid [open $logfile r]
set log [read $fid]
close $fid
if {[string first {Designutils 20-1307} $log] >= 0 ||
    [string first {hdmi_shared_clock_pins} $log] >= 0 ||
    [string first {board_shared_clock_impl.xdc} $log] >= 0} {
    error "Unsupported HDMI XDC syntax still reached synthesis"
}
puts "BOARD SHARED CLOCK SYNTHESIS XDC RECHECK PASS: unsupported HDMI constraint absent"
close_project
