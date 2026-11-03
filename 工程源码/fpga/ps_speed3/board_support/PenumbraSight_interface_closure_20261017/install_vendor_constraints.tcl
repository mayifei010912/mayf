set root F:/fpga/PenumbraSight_hybrid_FISTA_20261030/board_support/PenumbraSight_board_vendor_gmii_20261017
set work F:/fpga/PenumbraSight_hybrid_FISTA_20261030/board_support/PenumbraSight_interface_closure_20261017
file copy -force [file join $work vendor_phy_timing.tcl] [file join $root source vendor_phy_impl.xdc]
open_project [file join $root board_vendor_gmii.xpr]
set xdc [file join $root source vendor_phy_impl.xdc]
if {[llength [get_files -quiet $xdc]]==0} {add_files -fileset constrs_1 -norecurse $xdc}
set_property USED_IN_SYNTHESIS false [get_files $xdc]
set_property USED_IN_IMPLEMENTATION true [get_files $xdc]
set_property PROCESSING_ORDER LATE [get_files $xdc]
set imp impl_vendor_mmcm
if {[llength [get_runs -quiet $imp]]==0} {create_run $imp -parent_run synth_vendor_mmcm -flow {Vivado Implementation 2020} -strategy {Vivado Implementation Defaults} -constrset constrs_1 -part xczu4ev-sfvc784-2-i}
set_property INCREMENTAL_CHECKPOINT [file join $work vendor_rgmii_verified_routed.dcp] [get_runs $imp]
set_property STEPS.OPT_DESIGN.TCL.PRE F:/fpga/PenumbraSight_hybrid_FISTA_20261030/board_support/PenumbraSight_hdmi_fix_20261016/check_board_shared_impl_constraints.tcl [get_runs $imp]
set_property STEPS.OPT_DESIGN.TCL.POST [file join $work vendor_postopt.tcl] [get_runs $imp]
current_run -synthesis [get_runs synth_vendor_mmcm]
current_run -implementation [get_runs $imp]
open_bd_design [get_files -all */system.bd]
if {[get_property CONFIG.RGMII_TXC_SKEW [get_bd_cells vendor_gmii]]!=2} {error "MMCM variant expected"}
write_bd_tcl -force [file join $work vendor_bridge_bd.tcl]
close_project
puts "ISOLATED MMCM PROJECT CONSTRAINTS PERSISTED; NO HARDWARE PROGRAMMED"
