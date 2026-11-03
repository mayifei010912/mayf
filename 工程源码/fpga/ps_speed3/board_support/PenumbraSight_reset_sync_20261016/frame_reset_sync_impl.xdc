# Only the three asynchronous-clear pins in the reset synchronizer are exempt.
# Its output and all framebuffer payload/control paths remain timed.
set_false_path -to [get_pins -hierarchical -filter {NAME =~ *frame_reset_sync*/release_pipe_reg*/CLR}]
