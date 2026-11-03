set task_dir F:/fpga/PenumbraSight_hybrid_FISTA_20261030/board_support/PenumbraSight_video_bringup_20261018
open_project F:/fpga/PenumbraSight_hybrid_FISTA_20261030/board_support/PenumbraSight_board_vendor_gmii_20261017/board_vendor_gmii.xpr
set task_run [get_runs impl_vendor_mmcm]
if {[llength $task_run] != 1} {error {Expected existing implementation run}}
set_property INCREMENTAL_CHECKPOINT [file join $task_dir video_aux_fixed_routed.dcp] $task_run
puts "NEXT_INCREMENTAL_BASELINE [get_property INCREMENTAL_CHECKPOINT $task_run]"
close_project
puts {VIDEO_BASELINE_REFERENCE_SAVED_NO_BUILD_LAUNCHED}
exit