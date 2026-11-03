set task_dir F:/fpga/PenumbraSight_hybrid_FISTA_20261030/board_support/PenumbraSight_mdio_timing_20261018
set task_root F:/fpga/PenumbraSight_hybrid_FISTA_20261030/board_support/PenumbraSight_board_vendor_gmii_20261017
file copy -force [file join $task_dir mdio_edge_timing.tcl] [file join $task_root source vendor_mdio_impl.xdc]
# Narrow the generated vendor CDC exception in this isolated project.
# Preserve the original vendor file for review/recovery.
set task_vendor_xdc [file join $task_root source_full system ip system_vendor_gmii_0 synth system_vendor_gmii_0.xdc]
set task_backup [file join $task_dir vendor_mdio_sync_original.xdc]
if {![file exists $task_backup]} {file copy $task_vendor_xdc $task_backup}
set task_file [open $task_vendor_xdc r]
set task_text [read $task_file]
close $task_file
if {[string first {*i_MANAGEMENT/SYNC_*/data_sync*} $task_text]>=0} {
  set task_text [string map {{*i_MANAGEMENT/SYNC_*/data_sync*} {*i_MANAGEMENT/SYNC_*/data_sync_reg1}} $task_text]
  set task_file [open $task_vendor_xdc w]
  puts -nonewline $task_file $task_text
  close $task_file
}
if {[string first {*i_MANAGEMENT/SYNC_*/data_sync_reg1} $task_text]<0} {error "Narrow CDC source constraint missing"}
open_project [file join $task_root board_vendor_gmii.xpr]
set task_xdc [file join $task_root source vendor_mdio_impl.xdc]
if {[llength [get_files -quiet $task_xdc]] == 0} {add_files -fileset constrs_1 -norecurse $task_xdc}
set_property USED_IN_SYNTHESIS false [get_files $task_xdc]
set_property USED_IN_IMPLEMENTATION true [get_files $task_xdc]
set_property PROCESSING_ORDER LATE [get_files $task_xdc]
puts "MDIO_PROJECT_CONSTRAINT [get_property USED_IN_IMPLEMENTATION [get_files $task_xdc]] [get_property PROCESSING_ORDER [get_files $task_xdc]]"
set_property STEPS.OPT_DESIGN.TCL.POST [file join $task_dir mdio_postopt.tcl] [get_runs impl_vendor_mmcm]
set_property INCREMENTAL_CHECKPOINT [file join $task_dir vendor_mdio_verified_routed.dcp] [get_runs impl_vendor_mmcm]
close_project
puts {MDIO PROJECT CONSTRAINTS SAVED; NO BUILD OR HARDWARE ACCESS}

