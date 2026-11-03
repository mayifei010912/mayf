# Integrate the independently routed HDMI clock/serializer into a COPY of the board project.
# Source and block-design validation only: no full-board synthesis, bitstream, or hardware access.
set work F:/fpga/PenumbraSight_hybrid_FISTA_20261030/board_support/PenumbraSight_hdmi_fix_20261016
set board F:/fpga/PenumbraSight_hybrid_FISTA_20261030/board_support/PenumbraSight_board_hdmi_shared_20261016
set_param general.maxThreads 2

set fid [open [file join $work hdmi_shared_timing.rpt] r]
set probe_timing [read $fid]
close $fid
if {[string first {All user specified timing constraints are met.} $probe_timing] < 0} {
    error "Independent HDMI shared-clock route/timing must pass first"
}

open_project [file join $board project mpsoc_p4_board_nlos.xpr]
if {[get_property PART [current_project]] ne {xczu4ev-sfvc784-2-i}} {error "Wrong FPGA part"}
add_files -norecurse [file join $work hdmi_clock_shared.v]
update_compile_order -fileset sources_1
set repos [get_property ip_repo_paths [current_project]]
set local [file join $work ip_repo]
if {[lsearch -exact $repos $local] < 0} {
    set_property ip_repo_paths [linsert $repos 0 $local] [current_project]
}
update_ip_catalog
if {[llength [get_ipdefs -quiet nlos.local:user:DVI_Transmitter_Safe:1.0]] != 1} {
    error "Local repaired HDMI IP unavailable"
}

set bd [get_files */source_full/system/system.bd]
if {[llength $bd] != 1} {error "Board block design not found"}
open_bd_design $bd
set ps [get_bd_cells zynq_ultra_ps_e_0]
set ps_config [dict create]
foreach key [list_property $ps] {
    if {[string match CONFIG.* $key]} {dict set ps_config $key [get_property $key $ps]}
}
set addr [dict create]
foreach seg [get_bd_addr_segs -of_objects [get_bd_addr_spaces zynq_ultra_ps_e_0/Data]] {
    dict set addr $seg [list [get_property OFFSET $seg] [get_property RANGE $seg]]
}
if {[dict size $addr] != 18} {error "Expected 18 PS address segments"}

proc other_endpoint {net old_pin interface} {
    if {$interface} {
        set peers [concat [get_bd_intf_pins -quiet -of_objects $net] [get_bd_intf_ports -quiet -of_objects $net]]
    } else {
        set peers [concat [get_bd_pins -quiet -of_objects $net] [get_bd_ports -quiet -of_objects $net]]
    }
    foreach peer $peers {if {$peer ne $old_pin} {return $peer}}
    error "Peer missing for $old_pin"
}

# Preserve the original vendor source in the separate baseline project.
set old hdmi_out/DVI_Transmitter_0
set new hdmi_out/DVI_Transmitter_Safe_0
if {[llength [get_bd_cells -quiet $old]] != 1} {error "Expected original HDMI transmitter"}
create_bd_cell -type ip -vlnv nlos.local:user:DVI_Transmitter_Safe:1.0 $new
foreach pin [get_bd_intf_pins -of_objects [get_bd_cells $old]] {
    set net [get_bd_intf_nets -quiet -of_objects $pin]
    if {[llength $net] == 1} {
        set peer [other_endpoint $net $pin 1]
        disconnect_bd_intf_net $net $pin
        connect_bd_intf_net -intf_net $net $peer [get_bd_intf_pins $new/[file tail $pin]]
    }
}
foreach pin [get_bd_pins -of_objects [get_bd_cells $old]] {
    set net [get_bd_nets -quiet -of_objects $pin]
    if {[llength $net] == 1} {
        set peer [other_endpoint $net $pin 0]
        disconnect_bd_net $net $pin
        connect_bd_net -net $net $peer [get_bd_pins $new/[file tail $pin]]
    }
}
delete_bd_objs [get_bd_cells $old]

# clk_out2 stays at the vendor ~148 MHz setting for PS HP0/M00 and AXI control.
# clk_out4 is the HDMI-only ~371 MHz raw source; all video clocks share it.
set_property CONFIG.CLKOUT4_DRIVES No_buffer [get_bd_cells clk_wiz_0]
create_bd_cell -type module -reference hdmi_clock_shared hdmi_shared
connect_bd_net [get_bd_pins clk_wiz_0/clk_out4] [get_bd_pins hdmi_shared/raw_clock]
connect_bd_net [get_bd_pins clk_wiz_0/locked] [get_bd_pins hdmi_shared/locked]

foreach {sink driver} {
    hdmi_out/pixel_clk_5x    hdmi_shared/fast_clock
    hdmi_out/pixel_clk_2_5x  hdmi_shared/slow_clock
    hdmi_out/pclk            hdmi_shared/pixel_clock
    axi_interconnect_0/M06_ACLK hdmi_shared/pixel_clock
    axi_interconnect_hp0/S00_ACLK hdmi_shared/pixel_clock
} {
    set pin [get_bd_pins $sink]
    set net [get_bd_nets -quiet -of_objects $pin]
    if {[llength $net] != 1} {error "Original clock missing on $sink"}
    disconnect_bd_net $net $pin
    connect_bd_net [get_bd_pins $driver] $pin
}

# The HDMI framebuffer AXI master and its S00 coupler now use pixel-clock
# reset. The HP0 M00/PS side retains the vendor 148 MHz clock and reset.
create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 hdmi_pixel_reset
create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 hdmi_reset_zero
set_property CONFIG.CONST_VAL 0 [get_bd_cells hdmi_reset_zero]
connect_bd_net [get_bd_pins hdmi_shared/pixel_clock] [get_bd_pins hdmi_pixel_reset/slowest_sync_clk]
connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_resetn0] [get_bd_pins hdmi_pixel_reset/ext_reset_in]
connect_bd_net [get_bd_pins clk_wiz_0/locked] [get_bd_pins hdmi_pixel_reset/dcm_locked]
connect_bd_net [get_bd_pins hdmi_reset_zero/dout] [get_bd_pins hdmi_pixel_reset/aux_reset_in] [get_bd_pins hdmi_pixel_reset/mb_debug_sys_rst]
foreach sink {hdmi_out/aresetn axi_interconnect_0/M06_ARESETN axi_interconnect_hp0/S00_ARESETN} {
    set pin [get_bd_pins $sink]
    set net [get_bd_nets -quiet -of_objects $pin]
    if {[llength $net] != 1} {error "Original reset missing on $sink"}
    disconnect_bd_net $net $pin
    connect_bd_net [get_bd_pins hdmi_pixel_reset/peripheral_aresetn] $pin
}

set raw_hz [get_property CONFIG.FREQ_HZ [get_bd_pins clk_wiz_0/clk_out4]]
if {$raw_hz <= 0} {error "HDMI raw clock frequency missing"}
set_property CONFIG.FREQ_HZ $raw_hz [get_bd_pins hdmi_shared/raw_clock]
set_property CONFIG.FREQ_HZ $raw_hz [get_bd_pins hdmi_shared/fast_clock]
set_property CONFIG.FREQ_HZ [expr {($raw_hz+1)/2}] [get_bd_pins hdmi_shared/slow_clock]
set_property CONFIG.FREQ_HZ [expr {($raw_hz+2)/5}] [get_bd_pins hdmi_shared/pixel_clock]

validate_bd_design
if {[get_property CONFIG.C_EXT_RESET_HIGH [get_bd_cells hdmi_pixel_reset]] != 0} {
    error "New pixel reset input must be active-low for PS pl_resetn0"
}
foreach key [dict keys $ps_config] {
    if {[get_property $key $ps] ne [dict get $ps_config $key]} {error "PS configuration changed: $key"}
}
set after_addr [get_bd_addr_segs -of_objects [get_bd_addr_spaces zynq_ultra_ps_e_0/Data]]
if {[llength $after_addr] != [dict size $addr]} {error "PS address count changed"}
foreach seg [dict keys $addr] {
    if {[list [get_property OFFSET [get_bd_addr_segs $seg]] [get_property RANGE [get_bd_addr_segs $seg]]] ne [dict get $addr $seg]} {
        error "Address changed: $seg"
    }
}
foreach sink {hdmi_out/pclk axi_interconnect_0/M06_ACLK axi_interconnect_hp0/S00_ACLK} {
    if {[get_bd_nets -of_objects [get_bd_pins $sink]] ne [get_bd_nets -of_objects [get_bd_pins hdmi_shared/pixel_clock]]} {
        error "Pixel clock mismatch: $sink"
    }
}
if {[get_bd_nets -of_objects [get_bd_pins axi_interconnect_hp0/M00_ACLK]] ne [get_bd_nets -of_objects [get_bd_pins clk_wiz_0/clk_out2]]} {
    error "PS HP0 M00 clock changed"
}
foreach sink {hdmi_out/aresetn axi_interconnect_0/M06_ARESETN axi_interconnect_hp0/S00_ARESETN} {
    if {[get_bd_nets -of_objects [get_bd_pins $sink]] ne [get_bd_nets -of_objects [get_bd_pins hdmi_pixel_reset/peripheral_aresetn]]} {
        error "Pixel reset mismatch: $sink"
    }
}

save_bd_design
generate_target all $bd
update_compile_order -fileset sources_1
set xdc [file join $work board_shared_clock_impl.xdc]
add_files -fileset constrs_1 -norecurse $xdc
set_property USED_IN_SYNTHESIS false [get_files $xdc]
set_property USED_IN_IMPLEMENTATION true [get_files $xdc]
puts "BOARD HDMI SHARED CLOCK BD CHECK PASS: raw=$raw_hz Hz; PS configuration and 18 address segments preserved"
puts "Scope: source/BD validation only; full-board synthesis, routing, timing and hardware remain untested"
close_project
