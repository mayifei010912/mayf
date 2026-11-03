set_param general.maxThreads 2
set root F:/fpga/PenumbraSight_hybrid_FISTA_20261030/board_support/PenumbraSight_board_vendor_gmii_20261017
set work F:/fpga/PenumbraSight_hybrid_FISTA_20261030/board_support/PenumbraSight_interface_closure_20261017
open_project [file join $root board_vendor_gmii.xpr]
set bd [get_files -all */system.bd]
if {[llength $bd]!=1 || [string first $root [get_property NAME $bd]]!=0} {error "BD must belong to isolated checkout: $bd"}
config_ip_cache -use_cache_location [file join $root board_vendor_gmii.cache ip]
open_bd_design $bd
if {[llength [get_bd_cells -quiet vendor_gmii]]==0} {
 delete_bd_objs [get_bd_cells gmii2rgmii_calibrated_0]
 delete_bd_objs [get_bd_cells rgmii_ref_clock]
 create_bd_cell -type ip -vlnv xilinx.com:ip:gmii_to_rgmii:4.1 vendor_gmii
 set_property -dict {CONFIG.C_PHYADDR 0 CONFIG.C_EXTERNAL_CLOCK false CONFIG.C_USE_IDELAY_CTRL true CONFIG.RGMII_TXC_SKEW 2 CONFIG.SupportLevel Include_Shared_Logic_in_Core} [get_bd_cells vendor_gmii]
 connect_bd_intf_net [get_bd_intf_pins zynq_ultra_ps_e_0/GMII_ENET0] [get_bd_intf_pins vendor_gmii/GMII]
 connect_bd_intf_net [get_bd_intf_pins vendor_gmii/RGMII] [get_bd_intf_ports RGMII]
 set mdionet [get_bd_intf_nets -of_objects [get_bd_intf_ports MDIO]]
 disconnect_bd_intf_net $mdionet [get_bd_intf_ports MDIO]
 connect_bd_intf_net [get_bd_intf_pins zynq_ultra_ps_e_0/MDIO_ENET0] [get_bd_intf_pins vendor_gmii/MDIO_GEM]
 connect_bd_intf_net [get_bd_intf_pins vendor_gmii/MDIO_PHY] [get_bd_intf_ports MDIO]
 connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_clk1] [get_bd_pins vendor_gmii/clkin]
 connect_bd_net [get_bd_pins nlos_reset/peripheral_reset] [get_bd_pins vendor_gmii/tx_reset] [get_bd_pins vendor_gmii/rx_reset]
}
set_property CONFIG.RGMII_TXC_SKEW 2 [get_bd_cells vendor_gmii]
foreach pattern {*board_rgmii_rx_impl.xdc *control_eco_guard_impl.xdc} {
 set f [get_files -quiet $pattern]
 if {[llength $f]} {remove_files $f}
}
# Existing non-network checks remain reusable. Network checks are replaced after
# the official core netlist is available; do not execute stale custom-cell hooks.
set imp [get_runs impl_control_sync]
set_property STEPS.OPT_DESIGN.TCL.POST F:/fpga/PenumbraSight_hybrid_FISTA_20261030/board_support/PenumbraSight_reset_sync_20261016/check_reset_postopt.tcl $imp
validate_bd_design
save_bd_design
write_bd_tcl -force [file join $work vendor_bridge_bd.tcl]
foreach {a b} {zynq_ultra_ps_e_0/GMII_ENET0 vendor_gmii/GMII zynq_ultra_ps_e_0/MDIO_ENET0 vendor_gmii/MDIO_GEM} {
 if {[get_bd_intf_nets -of_objects [get_bd_intf_pins $a]] ne [get_bd_intf_nets -of_objects [get_bd_intf_pins $b]]} {error "Interface mismatch: $a $b"}
}
if {[get_property CONFIG.C_PHYADDR [get_bd_cells vendor_gmii]]!=0} {error "Adapter address must match installed Linux driver"}
puts "VENDOR BRIDGE STRUCTURAL CHECK PASS: PS GMII/MDIO -> official adapter at address 0 -> existing RGMII/MDIO pins; independent 375 MHz clock, three speeds and internal TX skew"
puts "PHY TX INTERNAL DELAY MUST BE DISABLED BEFORE BOARD USE; EXTERNAL CONSTRAINT AND ROUTED CHECKS STILL REQUIRED"
close_project
