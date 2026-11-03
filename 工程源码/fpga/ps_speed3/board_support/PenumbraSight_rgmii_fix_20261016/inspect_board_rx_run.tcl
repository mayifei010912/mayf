open_project F:/fpga/PenumbraSight_hybrid_FISTA_20261030/board_support/PenumbraSight_board_synth_20261016/project/mpsoc_p4_board_nlos.xpr
foreach r [get_runs -filter {IS_SYNTHESIS == 1}] {puts "RUN_STATE $r [get_property STATUS $r] refresh=[get_property NEEDS_REFRESH $r]"}
report_property [get_runs synth_1]
set start [clock scan {2026-10-16 23:58:33} -format {%Y-%m-%d %H:%M:%S}]
foreach f [get_files -all] {
 if {[file exists $f] && [file mtime $f]>$start} {puts "NEWER_FILE [clock format [file mtime $f]] $f"}
}
close_project
