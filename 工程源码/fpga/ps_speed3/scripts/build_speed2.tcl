set root [file normalize [file join [file dirname [info script]] ..]]
set ::env(TEMP) [file join $root build temp]
set ::env(TMP) $::env(TEMP)
set sim [open [file join $root reports xsim_full.log] r]
set simtext [read $sim];close $sim
if {[string first {[PASS HYBRID AXIL]} $simtext]<0 || [string first {Fatal:} $simtext]>=0} {error "Full numerical simulation has not passed"}
set sf [open [file join $root reports xsim_full_stream.log] r]
set st [read $sf];close $sf
if {[string first {[PASS HYBRID AXIL]} $st]<0 || [string first {Fatal:} $st]>=0} {error "Continuous AXI stream simulation has not passed"}
open_project [file join $root vivado board_hybrid board_hybrid.xpr]
set_param general.maxThreads 4
foreach name {fixed_g_axi_reader64.v fixed_g_matvec_pipe.v} {
 set f [file join $root rtl $name]
 if {![llength [get_files -quiet $f]]} {add_files $f}
}
update_compile_order -fileset sources_1
open_bd_design [get_files */system.bd]
set module_ips [get_ips -quiet *hybrid_reconstruction*]
puts "MODULE_IPS: $module_ips"
if {[llength $module_ips]!=1} {error "Expected exactly one reconstruction module IP"}
if {[catch {update_module_reference $module_ips} update_result update_opts]} {
 puts "MODULE_UPDATE_ERROR: $update_result"
 puts "MODULE_UPDATE_OPTIONS: $update_opts"
 error "Failed to refresh module reference"
}
validate_bd_design
save_bd_design
set_property STEPS.OPT_DESIGN.TCL.PRE [file join $root scripts board_preopt.tcl] [get_runs impl_1]
set_property STEPS.OPT_DESIGN.TCL.POST [file join $root scripts board_postopt.tcl] [get_runs impl_1]
generate_target all [get_files */system.bd]
create_ip_run [get_files */system.bd]
set kernel_runs [get_runs -quiet *hybrid_reconstruction*_synth_1]
if {[llength $kernel_runs]!=1} {error "Expected one kernel OOC synthesis run: $kernel_runs"}
reset_runs $kernel_runs
reset_runs synth_1
launch_runs synth_1 -jobs 4
wait_on_run synth_1
if {[get_property STATUS [get_runs synth_1]] ne "synth_design Complete!"} {error "Whole-board synthesis failed"}
open_run synth_1
report_utilization -file [file join $root reports board_utilization_synth.rpt]
write_checkpoint -force [file join $root reports board_speed2_synth.dcp]
close_design
launch_runs impl_1 -to_step route_design -jobs 4
wait_on_run impl_1
if {[get_property PROGRESS [get_runs impl_1]] ne "100%"} {error "Board route incomplete"}
open_run impl_1
report_timing_summary -file [file join $root reports board_timing_routed.rpt]
report_drc -file [file join $root reports board_drc_routed.rpt]
set ffs [get_cells -hier -filter {NAME =~ *hybrid_reconstruction* && REF_NAME =~ FD*}]
if {[llength $ffs]<1000} {error "Expected new kernel cells"}
set clocks [get_clocks -of_objects [get_pins -of_objects $ffs -filter {REF_PIN_NAME == C}]]
if {[llength $clocks]!=1} {error "Kernel clocks not unique: $clocks"}
set period [get_property PERIOD $clocks]
if {$period<19.9||$period>20.1} {error "Kernel clock must remain 50 MHz"}
if {[llength [get_timing_paths -quiet -slack_lesser_than 0 -max_paths 1]] || [llength [get_timing_paths -quiet -delay_type min -slack_lesser_than 0 -max_paths 1]]} {error "Negative routed timing; do not generate bit"}
if {[llength [get_drc_violations -quiet -filter {SEVERITY == Error}]]} {error "DRC errors"}
write_checkpoint -force [file join $root reports board_speed2_routed.dcp]
write_bitstream -force [file join $root vivado board_hybrid board_speed2.bit]
set f [open [file join $root reports SPEED2_BIT_COMPLETE.txt] w]
puts $f "Full Gx/TV simulation passed; whole-board route/timing/DRC passed; physical validation still required."
close $f
close_project
puts "PASS SPEED2 ROUTED BITSTREAM; NO BOARD DOWNLOAD PERFORMED"
exit
