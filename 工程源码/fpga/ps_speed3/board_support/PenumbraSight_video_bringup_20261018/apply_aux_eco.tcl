set task_video F:/fpga/PenumbraSight_hybrid_FISTA_20261030/board_support/PenumbraSight_video_bringup_20261018
set cells_before [get_cells -hier -filter {IS_PRIMITIVE == 1}]
set locs_before [get_property LOC $cells_before]
set bels_before [get_property BEL $cells_before]
set aux_first [get_cells -hier -filter {NAME =~ *hdmi_pixel_reset*ACT_LO_AUX*IN_cdc_to && REF_NAME == FDRE}]
if {[llength $aux_first] != 1 || ![get_property ASYNC_REG $aux_first]} {error "Expected AUX synchronizer first stage"}
set aux_d [get_pins $aux_first/D]
set aux_old [get_nets -of_objects $aux_d]
set aux_driver [get_cells -of_objects [get_pins -leaf -of_objects $aux_old -filter {DIRECTION == OUT}]]
if {[llength $aux_driver] != 1 || [get_property REF_NAME $aux_driver] ne "VCC"} {error "Expected inverted active-low AUX tied to one"}
set old_sinks [get_pins -leaf -of_objects $aux_old -filter {DIRECTION == IN}]
if {[llength $old_sinks] != 1 || $old_sinks ne $aux_d} {error "Unexpected AUX constant fanout"}
set zero_net [get_nets -of_objects [get_pins $aux_first/R]]
set zero_driver [get_cells -of_objects [get_pins -leaf -of_objects $zero_net -filter {DIRECTION == OUT}]]
if {[get_property REF_NAME $zero_driver] ne "GND"} {error "Reset pin does not provide known ground net"}
disconnect_net -net $aux_old -objects $aux_d
connect_net -hier -net $zero_net -objects $aux_d
puts "VIDEO_AUX_ECO_CHANGED_ONE_SINK $aux_d from=VCC to=GND; equivalent external active-low AUX=1"
route_design -eco
route_design -finalize
if {[get_property LOC $cells_before] ne $locs_before || [get_property BEL $cells_before] ne $bels_before} {error "Existing placement changed"}
if {[llength [get_cells -hier -filter {IS_PRIMITIVE == 1}]] != [llength $cells_before]} {error "Unexpected primitive count change"}
report_route_status -file [file join $task_video video_aux_route.rpt]
report_timing_summary -delay_type min_max -report_unconstrained -file [file join $task_video video_aux_timing.rpt]
foreach dt {max min} {if {[llength [get_timing_paths -delay_type $dt -slack_lesser_than 0 -max_paths 1]]} {error "Timing violation after AUX ECO"}}
report_drc -file [file join $task_video video_aux_drc.rpt]
if {[llength [get_drc_violations -quiet -filter {SEVERITY == Error || SEVERITY == {Critical Warning}}]]} {error "DRC failed after AUX ECO"}
report_bus_skew -file [file join $task_video video_aux_bus_skew.rpt]
write_checkpoint -force [file join $task_video video_aux_fixed_routed.dcp]
write_bitstream -force [file join $task_video video_aux_fixed.bit]
puts {VIDEO AUX ECO IMPLEMENTATION PASS: ONE CONSTANT SINK CHANGED; ALL EXISTING PLACEMENTS PRESERVED}
