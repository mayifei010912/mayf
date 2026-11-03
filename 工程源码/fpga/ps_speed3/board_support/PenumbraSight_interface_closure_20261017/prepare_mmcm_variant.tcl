set root F:/fpga/PenumbraSight_hybrid_FISTA_20261030/board_support/PenumbraSight_board_vendor_gmii_20261017
open_project [file join $root board_vendor_gmii.xpr]
set bd [get_files -all */system.bd]
if {[llength $bd]!=1 || [string first $root [get_property NAME $bd]]!=0} {error "Wrong BD location"}
open_bd_design $bd
puts "PL_CLK1_HZ=[get_property CONFIG.FREQ_HZ [get_bd_pins zynq_ultra_ps_e_0/pl_clk1]]"
set_property CONFIG.RGMII_TXC_SKEW 2 [get_bd_cells vendor_gmii]
validate_bd_design
save_bd_design
generate_target synthesis $bd
update_compile_order -fileset sources_1
puts "MMCM_TX_VARIANT_GENERATED"
close_project
