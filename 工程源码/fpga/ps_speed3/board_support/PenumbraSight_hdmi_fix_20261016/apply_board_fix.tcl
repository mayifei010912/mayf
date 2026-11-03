# Source-only integration after the independent HDMI probe passes.
# No full-board synthesis, implementation, bitstream or hardware access.
set work [file normalize [file dirname [info script]]]
set board F:/fpga/PenumbraSight_hybrid_FISTA_20261030/board_support/PenumbraSight_board_build_20261015
set_param general.maxThreads 1
set fid [open [file join $work hdmi_safe_routed_timing.rpt] r]
set probe_timing [read $fid]
close $fid
if {[string first {Timing constraints are met.} $probe_timing]<0 && [string first {All user specified timing constraints are met.} $probe_timing]<0} {error "Isolated HDMI timing must pass before board integration"}
file mkdir [file join $work backup_main]
foreach relative {source_full/system/system.bd project/mpsoc_p4_board_nlos.xpr source/pins.xdc} {
    set dst [file join $work backup_main [file tail $relative]]
    if {![file exists $dst]} {file copy [file join $board $relative] $dst}
}
open_project [file join $board project mpsoc_p4_board_nlos.xpr]
add_files -norecurse [file join $work hdmi_clock_pair.v]
update_compile_order -fileset sources_1
set repos [get_property ip_repo_paths [current_project]]
set local [file join $work ip_repo]
if {[lsearch -exact $repos $local]<0} {set_property ip_repo_paths [linsert $repos 0 $local] [current_project]}
update_ip_catalog
if {[llength [get_ipdefs -quiet nlos.local:user:DVI_Transmitter_Safe:1.0]]!=1} {error "Local safe HDMI IP not found"}
set bd [get_files */source_full/system/system.bd]
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
set old hdmi_out/DVI_Transmitter_0
set new hdmi_out/DVI_Transmitter_Safe_0
proc other_bd_endpoint {net old_pin interface} {
    if {$interface} {
        set peers [concat [get_bd_intf_pins -quiet -of_objects $net] [get_bd_intf_ports -quiet -of_objects $net]]
    } else {
        set peers [concat [get_bd_pins -quiet -of_objects $net] [get_bd_ports -quiet -of_objects $net]]
    }
    foreach peer $peers {
        if {$peer ne $old_pin} {return $peer}
    }
    error "No peer endpoint for $old_pin on $net"
}
if {[llength [get_bd_cells -quiet $new]]==0} {
    if {[llength [get_bd_cells -quiet $old]]!=1} {error "Expected original HDMI cell"}
    create_bd_cell -type ip -vlnv nlos.local:user:DVI_Transmitter_Safe:1.0 $new
    foreach pin [get_bd_intf_pins -of_objects [get_bd_cells $old]] {
        set net [get_bd_intf_nets -quiet -of_objects $pin]
        if {[llength $net]==1} {
            set suffix [file tail $pin]
            set peer [other_bd_endpoint $net $pin 1]
            disconnect_bd_intf_net $net $pin
            connect_bd_intf_net -intf_net $net $peer [get_bd_intf_pins $new/$suffix]
        }
    }
    foreach pin [get_bd_pins -of_objects [get_bd_cells $old]] {
        set net [get_bd_nets -quiet -of_objects $pin]
        if {[llength $net]==1} {
            set suffix [file tail $pin]
            set peer [other_bd_endpoint $net $pin 0]
            disconnect_bd_net $net $pin
            connect_bd_net -net $net $peer [get_bd_pins $new/$suffix]
        }
    }
    delete_bd_objs [get_bd_cells $old]
}
set_property -dict [list CONFIG.CLKOUT2_REQUESTED_OUT_FREQ 74.25 \
    CONFIG.CLKOUT3_REQUESTED_OUT_FREQ 371.25 CONFIG.CLKOUT4_REQUESTED_OUT_FREQ 185.625 \
    CONFIG.CLKOUT2_MATCHED_ROUTING false CONFIG.CLKOUT3_MATCHED_ROUTING false \
    CONFIG.CLKOUT4_MATCHED_ROUTING false CONFIG.CLKOUT3_DRIVES No_buffer] [get_bd_cells clk_wiz_0]
if {[llength [get_bd_cells -quiet hdmi_out/hdmi_pair]]==0} {
    create_bd_cell -type module -reference hdmi_clock_pair hdmi_out/hdmi_pair
    set fast_pin [get_bd_pins $new/pixel_clk_5x]
    set slow_pin [get_bd_pins $new/pixel_clk_2_5x]
    set raw_net [get_bd_nets -of_objects $fast_pin]
    set old_slow [get_bd_nets -of_objects $slow_pin]
    set raw_peer [other_bd_endpoint $raw_net $fast_pin 0]
    disconnect_bd_net $raw_net $fast_pin
    connect_bd_net -net $raw_net $raw_peer [get_bd_pins hdmi_out/hdmi_pair/raw_clock]
    disconnect_bd_net $old_slow $slow_pin
    connect_bd_net [get_bd_pins hdmi_out/hdmi_pair/fast_clock] $fast_pin
    connect_bd_net [get_bd_pins hdmi_out/hdmi_pair/slow_clock] $slow_pin
    connect_bd_net [get_bd_pins clk_wiz_0/locked] [get_bd_pins hdmi_out/hdmi_pair/locked]
}
set paired_raw_hz [get_property CONFIG.FREQ_HZ [get_bd_pins clk_wiz_0/clk_out3]]
set_property CONFIG.FREQ_HZ $paired_raw_hz [get_bd_pins hdmi_out/hdmi_pair/raw_clock]
set_property CONFIG.FREQ_HZ $paired_raw_hz [get_bd_pins hdmi_out/hdmi_pair/fast_clock]
set_property CONFIG.FREQ_HZ [expr {($paired_raw_hz+1)/2}] [get_bd_pins hdmi_out/hdmi_pair/slow_clock]
set raw_freq [get_property CONFIG.FREQ_HZ [get_bd_pins hdmi_out/hdmi_pair/raw_clock]]
set wizard_freq [get_property CONFIG.FREQ_HZ [get_bd_pins clk_wiz_0/clk_out3]]
puts "HDMI module clock metadata: raw=$raw_freq, wizard=$wizard_freq"
if {$raw_freq ne "" && $wizard_freq ne "" && $raw_freq ne $wizard_freq} {error "HDMI module clock metadata is stale"}
validate_bd_design
foreach key [dict keys $ps_config] {
    if {[get_property $key $ps] ne [dict get $ps_config $key]} {error "PS configuration changed: $key"}
}
foreach seg [dict keys $addr] {
    if {[list [get_property OFFSET [get_bd_addr_segs $seg]] [get_property RANGE [get_bd_addr_segs $seg]]] ne [dict get $addr $seg]} {error "Address map changed: $seg"}
}
foreach name {pclk pixel_clk_5x pixel_clk_2_5x reset_n} {
    if {[llength [get_bd_nets -of_objects [get_bd_pins $new/$name]]]!=1} {error "HDMI pin not connected: $name"}
}
foreach name {Video_In TMDS} {
    if {[llength [get_bd_intf_nets -of_objects [get_bd_intf_pins $new/$name]]]!=1} {error "HDMI interface not connected: $name"}
}
save_bd_design
generate_target all $bd
update_compile_order -fileset sources_1
set xdc [file join $board source pins.xdc]
set fid [open $xdc r]
set existing [read $fid]
close $fid
if {[string first {nlos_hdmi_parallel_pair} $existing]<0} {
    set fid [open $xdc a]
    puts $fid {set nlos_hdmi_parallel_pins [get_pins -hierarchical -filter {NAME =~ *hdmi_pair*fast_buffer/O || NAME =~ *hdmi_pair*slow_buffer/O}]}
    puts $fid {if {[llength $nlos_hdmi_parallel_pins]!=2} {error "Expected two HDMI parallel clock buffers"}}
    puts $fid {set_property CLOCK_DELAY_GROUP nlos_hdmi_parallel_pair [get_nets -of_objects $nlos_hdmi_parallel_pins]}
    close $fid
}
puts "BOARD HDMI SOURCE FIX CHECK PASS: local primed serializer, lower default clocks, common-source parallel clock pair; PS configuration and address map preserved"
puts "Scope: source and BD validation; full-board reimplementation and runtime display-mode limits remain pending"
close_project
