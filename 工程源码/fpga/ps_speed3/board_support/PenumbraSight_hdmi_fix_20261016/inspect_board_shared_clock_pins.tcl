set board F:/fpga/PenumbraSight_hybrid_FISTA_20261030/board_support/PenumbraSight_board_synth_20261016
set_param general.maxThreads 2
open_project [file join $board project mpsoc_p4_board_nlos.xpr]
open_run synth_1
foreach kind {fast_buffer slow_buffer pixel_buffer} {
    set pins [get_pins -hierarchical -filter "NAME =~ *hdmi_shared*/${kind}/O"]
    puts "HDMI CLOCK PIN $kind count=[llength $pins] pins=$pins"
    foreach pin $pins {puts "HDMI CLOCK NET $kind [get_nets -of_objects $pin]"}
}
close_project
