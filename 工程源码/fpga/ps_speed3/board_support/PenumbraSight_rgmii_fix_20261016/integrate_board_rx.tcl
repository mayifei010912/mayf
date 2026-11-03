set work F:/fpga/PenumbraSight_hybrid_FISTA_20261030/board_support/PenumbraSight_rgmii_fix_20261016
set board F:/fpga/PenumbraSight_hybrid_FISTA_20261030/board_support/PenumbraSight_board_synth_20261016
set_param general.maxThreads 2
set f [open [file join $work board_clock_sim board_clock_rx.sim sim_1 behav xsim simulate.log] r]
set s [read $f]; close $f
if {[string first {[PASS] BOARD CLOCK CALIBRATED RGMII RX: 768} $s]<0} {error "Fixed-reference receiver regression must pass first"}
# Preserve the last successful routed design before any run is reset.
set backup [file join $work backup_before_board_rx]
file mkdir $backup
foreach relative {
    project/mpsoc_p4_board_nlos.xpr source_full/system/system.bd source/pins.xdc
    project/mpsoc_p4_board_nlos.runs/impl_1/system_wrapper_routed.dcp
} {
    set dst [file join $backup [file tail $relative]]
    if {![file exists $dst]} {file copy [file join $board $relative] $dst}
}
ipx::open_core [file join $work ip_repo gmii_calibrated component.xml]
set_property supported_families {zynquplus Production} [ipx::current_core]
ipx::update_checksums [ipx::current_core]
ipx::check_integrity [ipx::current_core]
ipx::save_core [ipx::current_core]
ipx::unload_core [ipx::current_core]
open_project [file join $board project mpsoc_p4_board_nlos.xpr]
if {[get_property PART [current_project]] ne {xczu4ev-sfvc784-2-i}} {error "Unexpected FPGA part"}
config_ip_cache -use_cache_location [file join $board project mpsoc_p4_board_nlos.cache ip]
set repos [get_property ip_repo_paths [current_project]]
set local [file join $work ip_repo]
if {[lsearch -exact $repos $local]<0} {set_property ip_repo_paths [linsert $repos 0 $local] [current_project]}
update_ip_catalog
add_files -norecurse [file join $work rgmii_fixed_clock.v]
update_compile_order -fileset sources_1
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
if {[dict size $addr]!=18} {error "Expected 18 existing PS address mappings"}
set old gmii2rgmii_0
set new gmii2rgmii_calibrated_0
if {[llength [get_bd_cells -quiet $new]]==0} {
    if {[llength [get_bd_cells -quiet $old]]!=1} {error "Original GMII bridge missing"}
    create_bd_cell -type ip -vlnv nlos.local:user:gmii2rgmii_calibrated:1.0 $new
    foreach suffix {GMII RGMII} {
        set pin [get_bd_intf_pins $old/$suffix]
        set net [get_bd_intf_nets -of_objects $pin]
        if {[llength $net]!=1} {error "Missing original $suffix interface"}
        set peers [list]
        foreach peer [concat [get_bd_intf_pins -of_objects $net] [get_bd_intf_ports -quiet -of_objects $net]] {
            if {$peer ne $pin} {lappend peers $peer}
        }
        if {[llength $peers]!=1} {error "Expected one peer on original $suffix interface"}
        disconnect_bd_intf_net $net $pin
        connect_bd_intf_net -intf_net $net {*}$peers [get_bd_intf_pins $new/$suffix]
    }
    delete_bd_objs [get_bd_cells $old]
    create_bd_cell -type module -reference rgmii_fixed_clock rgmii_ref_clock
    connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_clk0] [get_bd_pins rgmii_ref_clock/clk100]
    connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_resetn0] [get_bd_pins rgmii_ref_clock/resetn]
    connect_bd_net [get_bd_pins rgmii_ref_clock/refclk] [get_bd_pins $new/refclk]
    connect_bd_net [get_bd_pins rgmii_ref_clock/cal_resetn] [get_bd_pins $new/cal_resetn]
}
# Frequency metadata comes from the fresh module reference's HDL attributes.
validate_bd_design
foreach key [dict keys $ps_config] {
    if {[get_property $key $ps] ne [dict get $ps_config $key]} {error "PS configuration changed: $key"}
}
if {[llength [get_bd_addr_segs -of_objects [get_bd_addr_spaces zynq_ultra_ps_e_0/Data]]]!=18} {error "Address count changed"}
foreach seg [dict keys $addr] {
    if {[list [get_property OFFSET [get_bd_addr_segs $seg]] [get_property RANGE [get_bd_addr_segs $seg]]] ne [dict get $addr $seg]} {error "Address mapping changed: $seg"}
}
foreach {a b} [list zynq_ultra_ps_e_0/GMII_ENET0 $new/GMII] {
    if {[get_bd_intf_nets -of_objects [get_bd_intf_pins $a]] ne [get_bd_intf_nets -of_objects [get_bd_intf_pins $b]]} {error "PS GMII connection mismatch"}
}
if {[get_bd_intf_nets -of_objects [get_bd_intf_ports RGMII]] ne [get_bd_intf_nets -of_objects [get_bd_intf_pins $new/RGMII]]} {error "External RGMII connection mismatch"}
if {[get_property CONFIG.FREQ_HZ [get_bd_pins rgmii_ref_clock/refclk]]!=399996004} {error "Wrong calibration clock metadata"}
save_bd_design
puts "BOARD RGMII INTEGRATION CHECK PASS: fixed nominal 400 MHz reference, 550 ps receiver; PS configuration and 18 address mappings preserved"
generate_target all $bd
set xdc [file join $work board_rgmii_rx_impl.xdc]
if {[llength [get_files -quiet $xdc]]==0} {add_files -fileset constrs_1 -norecurse $xdc}
set_property USED_IN_SYNTHESIS false [get_files $xdc]
set_property USED_IN_IMPLEMENTATION true [get_files $xdc]
update_compile_order -fileset sources_1
reset_run synth_1
launch_runs synth_1 -jobs 2
wait_on_run synth_1
set status [get_property STATUS [get_runs synth_1]]
if {![regexp -nocase {synth_design Complete} $status]} {error "Board calibrated RX synthesis failed: $status"}
open_run synth_1
set delays [get_cells -hier -filter {REF_NAME == IDELAYE3 && NAME =~ *gmii2rgmii_calibrated_0*}]
if {[llength $delays]!=5} {error "Expected five calibrated board RX delay elements"}
foreach cell $delays {
    if {[get_property DELAY_VALUE $cell]!=550 || abs([get_property REFCLK_FREQUENCY $cell]-399.996004)>0.001} {error "Board RX delay setting mismatch: $cell"}
}
set ctrl [get_cells -hier -filter {REF_NAME == IDELAYCTRL && NAME =~ *gmii2rgmii_calibrated_0*}]
if {[llength $ctrl]!=1} {error "Expected one RX delay controller before placement"}
set pll [get_cells -hier -filter {REF_NAME =~ PLLE4* && NAME =~ *rgmii_ref_clock*}]
if {[llength $pll]!=1 || [get_property CLKFBOUT_MULT $pll]!=12 || [get_property CLKOUT0_DIVIDE $pll]!=3} {error "Fixed nominal 400 MHz PLL missing/mismatched"}
set resets [get_pins -hier -filter {REF_PIN_NAME == CLR && (NAME =~ *gmii2rgmii_calibrated_0*reference_release_reg* || NAME =~ *gmii2rgmii_calibrated_0*ready_pipe_reg*)}]
if {[llength $resets]!=6} {error "Expected two three-stage reset synchronization chains"}
set refclock [get_clocks -of_objects [get_pins -of_objects $pll -filter {REF_PIN_NAME == CLKOUT0}]]
if {[llength $refclock]!=1 || abs([get_property PERIOD $refclock]-2.500025)>0.001} {error "Generated PLL clock is not nominal 400 MHz"}
report_utilization -file [file join $work board_rx_synth_utilization.rpt]
report_clocks -file [file join $work board_rx_synth_clocks.rpt]
report_drc -file [file join $work board_rx_synth_drc.rpt]
set f [open [file join $work board_rx_synthesis_check.txt] w]
puts $f "BOARD CALIBRATED RX SYNTHESIS CHECK PASS"
puts $f "5 IDELAYE3, 550 ps, nominal 400 MHz; 1 delay controller; 1 fixed PLL; 6 reset sync CLR pins"
puts $f "PS configuration and 18 address mappings preserved; routed timing and board test pending"
close $f
puts "BOARD CALIBRATED RX SYNTHESIS CHECK PASS: five 550 ps delays, fixed nominal 400 MHz reference, six marked reset stages; implementation pending"
close_project
