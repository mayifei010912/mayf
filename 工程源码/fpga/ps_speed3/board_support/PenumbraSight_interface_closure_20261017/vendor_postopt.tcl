set ::penumbra_team_fpga [file normalize [file join [file dirname [info script]] ..]]
source $::penumbra_team_fpga/PenumbraSight_reset_sync_20261016/check_reset_postopt.tcl
source $::penumbra_team_fpga/PenumbraSight_interface_closure_20261017/add_vendor_cal_guard.tcl
