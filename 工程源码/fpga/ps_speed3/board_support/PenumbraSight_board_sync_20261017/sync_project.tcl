set work F:/fpga/PenumbraSight_hybrid_FISTA_20261030/board_support/PenumbraSight_board_sync_20261017
set board F:/fpga/PenumbraSight_hybrid_FISTA_20261030/board_support/PenumbraSight_board_synth_20261016
set local F:/fpga/PenumbraSight_hybrid_FISTA_20261030/board_support/PenumbraSight_rgmii_fix_20261016/ip_repo/gmii_calibrated
set_param general.maxThreads 2
ipx::open_core [file join $local component.xml]
set_property core_revision 2 [ipx::current_core]
ipx::update_checksums [ipx::current_core]
ipx::check_integrity [ipx::current_core]
ipx::save_core [ipx::current_core]
ipx::unload_core [ipx::current_core]
open_project [file join $board project mpsoc_p4_board_nlos.xpr]
config_ip_cache -use_cache_location [file join $board project mpsoc_p4_board_nlos.cache ip]
update_ip_catalog -rebuild
set bd [get_files */source_full/system/system.bd]
open_bd_design $bd
set bridge [get_bd_cells gmii2rgmii_calibrated_0]
if {[llength $bridge]!=1} {error "Existing calibrated bridge missing"}
upgrade_bd_cells $bridge
validate_bd_design
save_bd_design
# Nested IP generation is owned by the BD. Generate its synthesis target only;
# Vivado reuses targets of unchanged IP rather than forcing global regeneration.
set ipxci [get_files -all */system_gmii2rgmii_calibrated_0_0.xci]
if {[llength $ipxci]!=1} {error "Calibrated bridge XCI missing"}
generate_target synthesis $bd
update_compile_order -fileset sources_1
set guard F:/fpga/PenumbraSight_hybrid_FISTA_20261030/board_support/PenumbraSight_rgmii_eco_20261017/control_eco_guard_impl.xdc
if {[llength [get_files -quiet $guard]]==0} {add_files -fileset constrs_1 -norecurse $guard}
set_property USED_IN_SYNTHESIS false [get_files $guard]
set_property USED_IN_IMPLEMENTATION true [get_files $guard]
set check [file join $work check_synced_postopt.tcl]
if {[llength [get_files -quiet $check]]==0} {add_files -fileset utils_1 -norecurse $check}
report_ip_status -file [file join $work synced_ip_status.rpt]
foreach r [get_runs -filter {IS_SYNTHESIS == 1}] {puts "SYNC_RUN $r [get_property STATUS $r] refresh=[get_property NEEDS_REFRESH $r]"}
set syn synth_control_sync
if {[llength [get_runs -quiet $syn]]==0} {create_run $syn -flow {Vivado Synthesis 2020} -strategy {Vivado Synthesis Defaults} -srcset sources_1 -constrset constrs_1 -part xczu4ev-sfvc784-2-i}
set imp impl_control_sync
if {[llength [get_runs -quiet $imp]]==0} {create_run $imp -parent_run $syn -flow {Vivado Implementation 2020} -strategy {Vivado Implementation Defaults} -constrset constrs_1 -part xczu4ev-sfvc784-2-i}
set_property INCREMENTAL_CHECKPOINT F:/fpga/PenumbraSight_hybrid_FISTA_20261030/board_support/PenumbraSight_rgmii_eco_20261017/system_wrapper_control_eco_routed.dcp [get_runs $imp]
set_property STEPS.OPT_DESIGN.TCL.PRE F:/fpga/PenumbraSight_hybrid_FISTA_20261030/board_support/PenumbraSight_hdmi_fix_20261016/check_board_shared_impl_constraints.tcl [get_runs $imp]
set_property STEPS.OPT_DESIGN.TCL.POST $check [get_runs $imp]
current_run -synthesis [get_runs $syn]
current_run -implementation [get_runs $imp]
launch_runs $syn -jobs 2
wait_on_run $syn
if {![regexp {synth_design Complete} [get_property STATUS [get_runs $syn]]]} {error "Synced top synthesis failed"}
open_run $syn
source [file join $work finalize_sync.tcl]
