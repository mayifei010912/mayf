# For the preserved AUX CDC chain, active-low AUX=1 is compiled to D=0.
# A future synthesis may remove the permanently-zero AUX chain; the BD
# connectivity check is the authoritative source-level check in that case.
set video_aux_first [get_cells -hier -quiet -filter {NAME =~ *hdmi_pixel_reset*ACT_LO_AUX*IN_cdc_to && REF_NAME == FDRE}]
if {[llength $video_aux_first] > 1} {error "Unexpected HDMI auxiliary CDC inventory"}
if {[llength $video_aux_first] == 1} {
 set video_aux_net [get_nets -of_objects [get_pins $video_aux_first/D]]
 set video_aux_driver [get_cells -of_objects [get_pins -leaf -of_objects $video_aux_net -filter {DIRECTION == OUT}]]
 if {[llength $video_aux_driver] != 1 || [get_property REF_NAME $video_aux_driver] ne "GND"} {error "HDMI auxiliary reset is permanently asserted"}
 puts {VIDEO AUX NETLIST GUARD PASS: inactive auxiliary reset}
} else {puts {VIDEO AUX CDC optimized away; verify source BD inactive AUX connection}}
