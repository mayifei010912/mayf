set work [file normalize [file dirname [info script]]]
set vendor [file join $work ip_repo DVI_TX ip src]
set_param general.maxThreads 2
create_project -force hdmi_shared_probe [file join $work shared_project] -part xczu4ev-sfvc784-2-i
set_property target_language Verilog [current_project]
create_ip -name clk_wiz -vendor xilinx.com -library ip -version 6.0 -module_name hdmi_shared_clock
set_property -dict [list CONFIG.PRIM_IN_FREQ 100.000 CONFIG.PRIM_SOURCE No_buffer \
    CONFIG.NUM_OUT_CLKS 4 CONFIG.CLKOUT1_REQUESTED_OUT_FREQ 33.3333 \
    CONFIG.CLKOUT2_USED true CONFIG.CLKOUT2_REQUESTED_OUT_FREQ 148.5 \
    CONFIG.CLKOUT3_USED true CONFIG.CLKOUT3_REQUESTED_OUT_FREQ 742.5 \
    CONFIG.CLKOUT4_USED true CONFIG.CLKOUT4_REQUESTED_OUT_FREQ 371.25 \
    CONFIG.CLKOUT4_DRIVES No_buffer CONFIG.USE_RESET true \
    CONFIG.RESET_TYPE ACTIVE_HIGH CONFIG.USE_LOCKED true] [get_ips hdmi_shared_clock]
generate_target all [get_ips hdmi_shared_clock]
foreach name {serializer_10_to_1.v dvi_transmitter_top.v dvi_encoder.v asyn_rst_syn.v} {
    add_files -norecurse [file join $vendor $name]
}
add_files -norecurse [file join $work hdmi_shared_probe.v]
add_files -norecurse [file join $work hdmi_clock_shared.v]
add_files -fileset sim_1 -norecurse [file join $work tb_hdmi_clock_probe.sv]
add_files -fileset constrs_1 -norecurse [file join $work shared_probe.xdc]
set_property top hdmi_clock_probe [get_filesets sources_1]
set_property top tb_hdmi_clock_probe [get_filesets sim_1]
set_property xsim.simulate.runtime all [get_filesets sim_1]
update_compile_order -fileset sources_1
launch_simulation
close_sim
set fid [open [file join $work shared_project hdmi_shared_probe.sim sim_1 behav xsim simulate.log] r]
set sim [read $fid]
close $fid
if {[string first {[PASS] HDMI CLOCK/SERIALIZER PROBE} $sim]<0 || [string first {Fatal:} $sim]>=0} {error "Shared-clock simulation failed"}
puts "SHARED HDMI CLOCK/SERIALIZER SIMULATION CHECK PASS"
close_project
