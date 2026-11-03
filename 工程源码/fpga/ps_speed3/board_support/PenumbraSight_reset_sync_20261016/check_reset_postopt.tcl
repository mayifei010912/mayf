set ::penumbra_team_fpga [file normalize [file join [file dirname [info script]] ..]]
source $::penumbra_team_fpga/PenumbraSight_hdmi_fix_20261016/check_board_shared_postopt.tcl
set pins [get_pins -hierarchical -filter {NAME =~ *frame_reset_sync*/release_pipe_reg*/CLR}]
if {[llength $pins] != 3} {error "Expected exactly three reset synchronizer clear pins, got $pins"}
foreach pin $pins {
    set cell [get_cells -of_objects $pin]
    if {![get_property ASYNC_REG $cell]} {error "ASYNC_REG missing on $cell"}
}
puts "FRAME RESET POST-OPT CHECK PASS: three ASYNC_REG stages; narrow asynchronous-clear exception"
