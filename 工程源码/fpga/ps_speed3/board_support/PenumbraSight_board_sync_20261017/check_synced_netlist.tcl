set delays [get_cells -hier -filter {REF_NAME == IDELAYE3 && NAME =~ *gmii2rgmii_calibrated_0*}]
if {[llength $delays]!=5} {error "Expected five input delay cells"}
foreach c $delays {
    set ck [get_clocks -of_objects [get_pins $c/CLK]]
    if {[llength $ck]!=1 || [get_property NAME $ck] ne {RGMII_rxc} || [get_property DELAY_VALUE $c]!=550 || abs([get_property REFCLK_FREQUENCY $c]-399.996004)>0.001} {error "Delay control clock or calibration config mismatch: $c"}
}
set reset [get_pins -hier -filter {NAME =~ *gmii2rgmii_calibrated_0*ODDRE1_tx_ctl/* && (REF_PIN_NAME == RST || REF_PIN_NAME == SR)}]
if {[llength $reset]!=1} {error "TX serializer reset pin missing"}
# OSERDESE3 RST has no timing arc in this library; verify electrical
# connectivity directly rather than relying on timing traversal.
proc nlos_leaf_driver {pin} {
    set nets [get_nets -segments -of_objects $pin]
    set drivers [get_pins -leaf -of_objects $nets -filter {DIRECTION == OUT}]
    if {[llength $drivers]!=1} {error "Expected exactly one leaf driver for $pin: $drivers"}
    return $drivers
}
set reset_driver [nlos_leaf_driver $reset]
set inv [get_cells -of_objects $reset_driver]
if {[get_property REF_NAME $inv] ne {LUT1} || [get_property INIT $inv] ne {2'h1}} {error "TX ready inversion missing/mismatched: $inv"}
set ready_driver [nlos_leaf_driver [get_pins $inv/I0]]
set src [get_cells -of_objects $ready_driver]
if {[llength $src]!=1 || [get_property NAME $src] ne {system_i/gmii2rgmii_calibrated_0/inst/u_rgmii_rx/ready_pipe_reg[2]} || ![get_property ASYNC_REG $src] || [get_property REF_PIN_NAME $ready_driver] ne {Q}} {error "TX reset not derived from final ready stage: $ready_driver"}
set ports [get_ports {RGMII_rd[*] RGMII_rx_ctl}]
if {[llength $ports]!=5 || [llength [get_clocks RGMII_rxc]]!=1} {error "RGMII input constraints objects missing"}
puts "SYNCED NETLIST CHECK PASS: five 550 ps delays clocked by RGMII RX, 400 MHz calibration preserved, TX reset = NOT final synchronized ready"
