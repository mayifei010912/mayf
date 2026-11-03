set ::penumbra_team_fpga [file normalize [file join [file dirname [info script]] ..]]
set work $::penumbra_team_fpga/PenumbraSight_reset_sync_20261016
report_route_status -file [file join $work board_reset_sync_route_status.rpt]
report_cdc -from [get_clocks clk_pl_0] -to [get_clocks hdmi_shared_pixel_clock] -details -file [file join $work board_reset_sync_ps_to_pixel_cdc.rpt]
report_clocks -file [file join $work board_reset_sync_clocks.rpt]
