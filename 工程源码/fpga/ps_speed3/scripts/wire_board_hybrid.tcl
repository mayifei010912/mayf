set root [file normalize [file join [file dirname [info script]] ..]]
open_project [file join $root vivado board_hybrid board_hybrid.xpr]
if {![llength [get_files -quiet */hybrid_fista_board_bd.v]]} {add_files [file join $root rtl hybrid_fista_board_bd.v]}
open_bd_design [get_files */system.bd]
delete_bd_objs [get_bd_cells hybrid_reconstruction]
create_bd_cell -type module -reference hybrid_fista_board_bd hybrid_reconstruction
if {[llength [get_bd_cells -quiet hybrid_clock]]} {error "Already wired; inspect saved project instead of duplicating connections"}
set input_hz [get_property CONFIG.FREQ_HZ [get_bd_pins zynq_ultra_ps_e_0/pl_clk0]]
create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 hybrid_clock
set_property -dict [list CONFIG.PRIM_IN_FREQ [expr {$input_hz/1.0e6}] CONFIG.CLKOUT1_REQUESTED_OUT_FREQ 50.000 CONFIG.RESET_TYPE ACTIVE_LOW] [get_bd_cells hybrid_clock]
connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_clk0] [get_bd_pins hybrid_clock/clk_in1]
connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_resetn0] [get_bd_pins hybrid_clock/resetn]
create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 hybrid_reset
set_property CONFIG.C_AUX_RESET_HIGH 0 [get_bd_cells hybrid_reset]
connect_bd_net [get_bd_pins hybrid_clock/clk_out1] [get_bd_pins hybrid_reset/slowest_sync_clk] [get_bd_pins hybrid_reconstruction/aclk]
connect_bd_net [get_bd_pins hybrid_clock/locked] [get_bd_pins hybrid_reset/dcm_locked]
connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_resetn0] [get_bd_pins hybrid_reset/ext_reset_in]
connect_bd_net [get_bd_pins nlos_one/dout] [get_bd_pins hybrid_reset/aux_reset_in]
connect_bd_net [get_bd_pins nlos_zero/dout] [get_bd_pins hybrid_reset/mb_debug_sys_rst]
connect_bd_net [get_bd_pins hybrid_reset/peripheral_aresetn] [get_bd_pins hybrid_reconstruction/aresetn]
# Existing HPM0 smartconnect already owns A1000000 old-kernel access.
set_property -dict [list CONFIG.NUM_MI 3 CONFIG.NUM_CLKS 1] [get_bd_cells nlos_link]
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_clock_converter:2.1 hybrid_control_cdc
set_property -dict [list CONFIG.PROTOCOL AXI4LITE CONFIG.DATA_WIDTH 32 CONFIG.ADDR_WIDTH 32] [get_bd_cells hybrid_control_cdc]
connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_clk0] [get_bd_pins hybrid_control_cdc/s_axi_aclk]
connect_bd_net [get_bd_pins nlos_reset/peripheral_aresetn] [get_bd_pins hybrid_control_cdc/s_axi_aresetn]
connect_bd_net [get_bd_pins hybrid_clock/clk_out1] [get_bd_pins hybrid_control_cdc/m_axi_aclk]
connect_bd_net [get_bd_pins hybrid_reset/peripheral_aresetn] [get_bd_pins hybrid_control_cdc/m_axi_aresetn]
connect_bd_intf_net [get_bd_intf_pins nlos_link/M02_AXI] [get_bd_intf_pins hybrid_control_cdc/S_AXI]
connect_bd_intf_net [get_bd_intf_pins hybrid_control_cdc/M_AXI] [get_bd_intf_pins hybrid_reconstruction/s_axi]
# Share the existing video DDR interconnect through an additional independent port.
set_property CONFIG.NUM_SI 3 [get_bd_cells axi_interconnect_hp0]
connect_bd_net [get_bd_pins hybrid_clock/clk_out1] [get_bd_pins axi_interconnect_hp0/S02_ACLK]
connect_bd_net [get_bd_pins hybrid_reset/peripheral_aresetn] [get_bd_pins axi_interconnect_hp0/S02_ARESETN]
connect_bd_intf_net [get_bd_intf_pins hybrid_reconstruction/m_axi] [get_bd_intf_pins axi_interconnect_hp0/S02_AXI]
set ctrlseg [get_bd_addr_segs -of_objects [get_bd_intf_pins hybrid_reconstruction/s_axi]]
if {[llength $ctrlseg]!=1} {error "Expected one new control register segment: $ctrlseg"}
assign_bd_address -offset 0xA2000000 -range 0x100 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] $ctrlseg
assign_bd_address -target_address_space [get_bd_addr_spaces hybrid_reconstruction/m_axi] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_DDR_LOW]
validate_bd_design
if {[get_property CONFIG.C_EXT_RESET_HIGH [get_bd_cells hybrid_reset]]!=0} {error "New kernel external reset polarity is wrong"}
save_bd_design
set wrappers [make_wrapper -files [get_files */system.bd] -top]
add_files $wrappers
set_property top system_wrapper [current_fileset]
set_property target_language Verilog [current_project]
update_compile_order -fileset sources_1
set support [file join $root board_support]
set_property STEPS.OPT_DESIGN.TCL.PRE [file join $support PenumbraSight_hdmi_fix_20261016 check_board_shared_impl_constraints.tcl] [get_runs impl_1]
set_property STEPS.OPT_DESIGN.TCL.POST [file join $support PenumbraSight_mdio_timing_20261018 mdio_postopt.tcl] [get_runs impl_1]
set f [open [file join $root reports board_integration_pass.txt] w]
puts $f "BD validated: preserved old NLOS, video, Ethernet; new HYF1 at 0xA2000000 / 256 bytes; dedicated 50 MHz clock."
puts $f "G read master accesses PS HP0 low DDR through new interconnect input; no arbitrary physical DDR is reserved."
puts $f "Original board XPR and release bitstream were not modified. Whole-board synthesis/implementation and DMA allocation remain required."
close $f
close_project
puts "PASS HYBRID BOARD BD VALIDATION"
