# Invoked after implementation init_design has linked all out-of-context IP.
set_param general.maxThreads 2
set hdmi_pins [get_pins -hierarchical -filter {NAME =~ *hdmi_shared*/fast_buffer/O || NAME =~ *hdmi_shared*/slow_buffer/O || NAME =~ *hdmi_shared*/pixel_buffer/O}]
if {[llength $hdmi_pins] != 3} {error "Expected three linked HDMI clock-buffer outputs"}
set hdmi_nets [get_nets -of_objects $hdmi_pins]
foreach net $hdmi_nets {
    if {[get_property CLOCK_DELAY_GROUP $net] ne {hdmi_shared_clock_group}} {
        error "HDMI CLOCK_DELAY_GROUP missing on $net"
    }
}
foreach name {clk_pl_0 clk_pl_1 clk_pl_3 mdio0_mdc_clock hdmi_shared_pixel_clock hdmi_shared_slow_clock} {
    if {[llength [get_clocks -quiet $name]] != 1} {error "Implementation clock missing: $name"}
}
set blackboxes [get_cells -hierarchical -quiet -filter {IS_BLACKBOX == 1}]
foreach cell $blackboxes {
    if {$cell ne {dbg_hub}} {error "Unresolved implementation black box: $cell"}
}
puts "BOARD IMPLEMENTATION CONSTRAINT PRECHECK PASS: 3 HDMI clock nets grouped; PS/video clocks present; only automatic debug hub may await opt_design"
