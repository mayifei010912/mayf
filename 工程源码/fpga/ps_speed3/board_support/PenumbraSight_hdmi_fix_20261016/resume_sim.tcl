set work [file normalize [file dirname [info script]]]
open_project [file join $work project hdmi_probe.xpr]
set old [get_files -quiet F:/fpga/PenumbraSight_hybrid_FISTA_20261030/board_support/PenumbraSight_board_base_20261015/4ev/ip_repo/DVI_TX/ip/src/serializer_10_to_1.v]
if {[llength $old]} {remove_files $old}
add_files -norecurse [file join $work ip_repo DVI_TX ip src serializer_10_to_1.v]
update_compile_order -fileset sources_1
launch_simulation
close_sim
set fid [open [file join $work project hdmi_probe.sim sim_1 behav xsim simulate.log] r]
set evidence [read $fid]
close $fid
if {[string first {[PASS] HDMI CLOCK/SERIALIZER PROBE} $evidence]<0 || [string first {Fatal:} $evidence]>=0} {error "HDMI probe simulation failed"}
puts "HDMI CLOCK/SERIALIZER SIMULATION CHECK PASS"
close_project
