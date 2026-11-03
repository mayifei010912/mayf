set work F:/fpga/PenumbraSight_hybrid_FISTA_20261030/board_support/PenumbraSight_reset_sync_20261016
create_project -force hdmi_reset_sync [file join $work sim_project] -part xczu4ev-sfvc784-2-i
add_files -norecurse [file join $work hdmi_frame_reset_sync.v]
add_files -fileset sim_1 -norecurse [file join $work tb_hdmi_frame_reset_sync.sv]
set_property top hdmi_frame_reset_sync [get_filesets sources_1]
set_property top tb_hdmi_frame_reset_sync [get_filesets sim_1]
set_property xsim.simulate.runtime all [get_filesets sim_1]
launch_simulation
close_sim
set fid [open [file join $work sim_project hdmi_reset_sync.sim sim_1 behav xsim simulate.log] r]
set log [read $fid]
close $fid
if {[string first {[PASS] HDMI FRAME RESET SYNC} $log]<0 || [string first {Fatal:} $log]>=0} {error "Reset synchronization simulation failed"}
puts "RESET SYNC SIMULATION CHECK PASS"
close_project
