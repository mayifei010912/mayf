set board F:/fpga/PenumbraSight_hybrid_FISTA_20261030/board_support/PenumbraSight_board_synth_20261016
set xdc F:/fpga/PenumbraSight_hybrid_FISTA_20261030/board_support/PenumbraSight_hdmi_fix_20261016/board_shared_clock_impl.xdc
open_project [file join $board project mpsoc_p4_board_nlos.xpr]
if {[llength [get_files -quiet $xdc]] == 0} {add_files -fileset constrs_1 -norecurse $xdc}
set file [get_files $xdc]
set_property USED_IN_SYNTHESIS false $file
set_property USED_IN_IMPLEMENTATION true $file
puts "HDMI CLOCK IMPLEMENTATION XDC ATTACHED: $xdc"
close_project
