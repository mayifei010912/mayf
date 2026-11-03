set_param general.maxThreads 2
open_checkpoint F:/fpga/PenumbraSight_hybrid_FISTA_20261030/board_support/PenumbraSight_mdio_timing_20261018/vendor_mdio_verified_routed.dcp
set rstcells [get_cells -hier -filter {NAME =~ *hdmi_pixel_reset*}]
puts "HDMI_RESET_CELL_COUNT [llength $rstcells]"
foreach c $rstcells {puts "HDMI_RESET_CELL $c [get_property REF_NAME $c]"}
foreach p [get_pins -hier -filter {NAME =~ *hdmi_pixel_reset*aux_reset*}] {puts "AUX_PIN $p NET=[get_nets -of_objects $p]"}
foreach p [get_pins -hier -filter {NAME =~ *hdmi_out*frame_reset_sync*global_resetn*}] {puts "FRAME_GLOBAL $p FANIN=[all_fanin -flat -startpoints_only -to $p]"}
puts "FRAME_CELLS [llength [get_cells -hier -filter {NAME =~ *hdmi_out*v_frmbuf_rd_0*}]]"
puts {VIDEO_ECO_INSPECTION_READY}
