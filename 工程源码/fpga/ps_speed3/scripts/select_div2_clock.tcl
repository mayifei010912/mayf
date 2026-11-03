set root [file normalize [file join [file dirname [info script]] ..]]
open_project [file join $root vivado board_hybrid board_hybrid.xpr]
add_files [file join $root rtl hybrid_clock_div2.v]
add_files [file join $root rtl hybrid_fista_board_div2_bd.v]
open_bd_design [get_files */system.bd]
delete_bd_objs [get_bd_cells hybrid_clock]
create_bd_cell -type module -reference hybrid_clock_div2 hybrid_clock
connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_clk0] [get_bd_pins hybrid_clock/clk_in1]
connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_resetn0] [get_bd_pins hybrid_clock/resetn]
connect_bd_net [get_bd_pins hybrid_clock/clk_out1] [get_bd_pins hybrid_reset/slowest_sync_clk]
connect_bd_net [get_bd_pins hybrid_clock/locked] [get_bd_pins hybrid_reset/dcm_locked]
delete_bd_objs [get_bd_cells hybrid_reconstruction]
create_bd_cell -type module -reference hybrid_fista_board_div2_bd hybrid_reconstruction
connect_bd_net [get_bd_pins hybrid_clock/clk_out1] [get_bd_pins hybrid_reconstruction/aclk]
connect_bd_net [get_bd_pins hybrid_reset/peripheral_aresetn] [get_bd_pins hybrid_reconstruction/aresetn]
# Recreate only the two nets whose endpoint module was replaced.
foreach spec {{hybrid_control_cdc/M_AXI hybrid_reconstruction/s_axi} {axi_interconnect_hp0/S02_AXI hybrid_reconstruction/m_axi}} {
 lassign $spec a b
 set old [get_bd_intf_nets -of_objects [get_bd_intf_pins $a]]
 if {[llength $old]} {delete_bd_objs $old}
 connect_bd_intf_net [get_bd_intf_pins $a] [get_bd_intf_pins $b]
}
set seg [get_bd_addr_segs -of_objects [get_bd_intf_pins hybrid_reconstruction/s_axi]]
assign_bd_address -offset 0xA2000000 -range 0x100 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] $seg
assign_bd_address -target_address_space [get_bd_addr_spaces hybrid_reconstruction/m_axi] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_DDR_LOW]
validate_bd_design
save_bd_design
set f [open [file join $root reports board_integration_pass.txt] w]
puts $f "BD validated: HYF1 replaces the old compute core in this isolated project; camera/video/Ethernet retained."
puts $f "Control 0xA2000000 / 256 bytes; G reads PS HP0 low DDR. Original project/bit/runtime unchanged."
puts $f "PS PL clock divided by BUFGCE_DIV 2; actual 49999500 Hz; no additional MMCM."
close $f
reset_runs synth_1
close_project
file delete -force [file join $root reports board_synthesis_pass.txt]
source [file join $root scripts build_board_hybrid.tcl]
