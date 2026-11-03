set ::penumbra_team_fpga [file normalize [file join [file dirname [info script]] ..]]
source $::penumbra_team_fpga/PenumbraSight_interface_closure_20261017/vendor_postopt.tcl
# Regeneration can restore the vendor broad CDC exception. Re-audit and
# narrow it even after an IP regeneration, preserving physical constraints.
set task_dir $::penumbra_team_fpga/PenumbraSight_mdio_timing_20261018
source [file join $task_dir narrow_mdio_cdc.tcl]
source $::penumbra_team_fpga/PenumbraSight_video_bringup_20261018/check_video_aux.tcl

source $::penumbra_team_fpga/PenumbraSight_hpd_fix_20261018/check_hpd_vref.tcl
