set task_dir F:/fpga/PenumbraSight_hybrid_FISTA_20261030/board_support/PenumbraSight_hpd_fix_20261018
set_param general.maxThreads 2
open_checkpoint F:/fpga/PenumbraSight_hybrid_FISTA_20261030/board_support/PenumbraSight_video_bringup_20261018/video_aux_fixed_routed.dcp
set task_hpd [get_ports -filter {NAME == "GPIO_tri_io[8]"}]
if {[llength $task_hpd] != 1} {error {HPD port missing}}
if {[get_property PACKAGE_PIN $task_hpd] ne "T6" || [get_property IOSTANDARD $task_hpd] ne "SSTL12"} {error {Unexpected HPD pin or I/O standard}}
puts "BANK65_VREF_BEFORE [get_property INTERNAL_VREF [get_iobanks 65]]"
set task_cells [get_cells -hier -filter {IS_PRIMITIVE == 1}]
set task_locs [get_property LOC $task_cells]
set task_bels [get_property BEL $task_cells]
set_property INTERNAL_VREF 0.6 [get_iobanks 65]
puts "BANK65_VREF_AFTER [get_property INTERNAL_VREF [get_iobanks 65]]"
if {[get_property LOC $task_cells] ne $task_locs || [get_property BEL $task_cells] ne $task_bels} {error {Placement changed unexpectedly}}
report_property -file [file join $task_dir vref_port_properties.rpt] $task_hpd
report_io -file [file join $task_dir vref_io.rpt]
report_route_status -file [file join $task_dir vref_route.rpt]
report_timing_summary -delay_type min_max -file [file join $task_dir vref_timing.rpt]
foreach task_dt {max min} {
 if {[llength [get_timing_paths -delay_type $task_dt -slack_lesser_than 0 -max_paths 1]]} {error {Timing violation}}
}
report_drc -file [file join $task_dir vref_drc.rpt]
if {[llength [get_drc_violations -quiet -filter {SEVERITY == Error || SEVERITY == {Critical Warning}}]]} {error {DRC did not pass}}
write_checkpoint -force [file join $task_dir hpd_vref_routed.dcp]
write_bitstream -force [file join $task_dir hpd_vref.bit]
puts {HPD_VREF_CANDIDATE_READY: ONE BANK REFERENCE PROPERTY; NO SYNTHESIS PLACEMENT OR ROUTING RUN}
close_design
exit
