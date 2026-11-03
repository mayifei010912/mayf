set vr F:/fpga/PenumbraSight_hybrid_FISTA_20261030/board_support/PenumbraSight_video_bringup_20261018
set pr F:/fpga/PenumbraSight_hybrid_FISTA_20261030/board_support/PenumbraSight_board_vendor_gmii_20261017
foreach pair {{source_full/system/system.bd system_before_aux_fix.bd} {board_vendor_gmii.xpr project_before_aux_fix.xpr}} {
 lassign $pair original backup
 if {![file exists [file join $vr $backup]]} {file copy [file join $pr $original] [file join $vr $backup]}
}
open_project [file join $pr board_vendor_gmii.xpr]
set bd [get_files */source_full/system/system.bd]
open_bd_design $bd
set pin [get_bd_pins hdmi_pixel_reset/aux_reset_in]
set net [get_bd_nets -of_objects $pin]
set one [get_bd_pins nlos_one/dout]
if {[get_property CONFIG.CONST_VAL [get_bd_cells nlos_one]] != 1} {error "Expected constant one"}
if {$net ne [get_bd_nets -of_objects $one]} {
 disconnect_bd_net $net $pin
 connect_bd_net $one $pin
}
validate_bd_design
if {[get_property CONFIG.C_AUX_RESET_HIGH [get_bd_cells hdmi_pixel_reset]] != 0} {error "Unexpected auxiliary reset polarity"}
if {[get_bd_nets -of_objects $pin] ne [get_bd_nets -of_objects $one]} {error "AUX not inactive high"}
if {[get_bd_nets -of_objects [get_bd_pins hdmi_pixel_reset/mb_debug_sys_rst]] ne [get_bd_nets -of_objects [get_bd_pins hdmi_reset_zero/dout]]} {error "Debug reset changed"}
save_bd_design
generate_target synthesis $bd
write_bd_tcl -force [file join $vr video_aux_corrected_bd.tcl]
puts {BD AUX RESET FIX PASS: ACTIVE LOW AUX=1; ACTIVE HIGH DEBUG=0; NO SYNTHESIS RUN LAUNCHED}
close_project
exit
