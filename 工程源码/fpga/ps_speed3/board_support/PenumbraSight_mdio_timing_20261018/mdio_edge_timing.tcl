# MDIO edge-normalized constraints for PS8 fixed rising-edge timing arcs.
# Evidence: real-board ILA read2/read3, 100 MHz samples, MAC data changes
# after MDC falling; PHY response changes after MDC rising. MDC=480.004 ns.
# Keep the physical rising-edge pad clock for PHY-to-MAC input timing.
# For MAC-to-PHY, the PS8 model launches on rise whereas hardware launches
# on fall. Normalize launch to time zero by subtracting H from all actual
# output events. The next PHY rise is then P-H, previous PHY rise is -H.
# Thus effective output max=SU+H+skew; min=H-HOLD-skew.
# These are phase-normalized delays, NOT raw PHY SU/HOLD specifications.
# Algebra: setup=P-H+Dclk_min-Ddata_max-SU-skew;
#          hold=H+Ddata_min-Dclk_max-HOLD-skew.
# PHY timing: YT8521S table 139 SU=10 ns, HOLD=10 ns, tCO=0..20 ns.
# PCB output relative skew +/-0.2 ns; input clock-forward + data-return
# delay <=2 ns, plus 0.2 ns uncertainty. These PCB bounds are assumptions,
# not extracted trace delays. The input bound must include BOTH routes.
# Valid only for measured nominal 50% MDC duty and configured /48 divider.
set mdio_ps [get_cells -hier -filter {REF_NAME == PS8}]
if {[llength $mdio_ps] != 1} {error "Expected exactly one PS8"}
set mdio_source [get_pins $mdio_ps/EMIOENET0MDIOMDC]
set mdio_master [get_clocks -of_objects $mdio_source]
if {[llength $mdio_master] != 1} {error "Expected one MDC master clock"}
set mdio_period [get_property PERIOD $mdio_master]
set mdio_wave [get_property WAVEFORM $mdio_master]
set mdio_half [expr {[lindex $mdio_wave 1]-[lindex $mdio_wave 0]}]
if {abs($mdio_period-480.004) > 0.1 || abs(2*$mdio_half-$mdio_period)>0.01} {error "Unverified MDC period/duty"}
if {[llength [get_clocks -quiet nlos_mdio_pad_clock]]} {delete_clocks [get_clocks nlos_mdio_pad_clock]}
create_generated_clock -name nlos_mdio_pad_clock -source $mdio_source -divide_by 1 [get_ports MDIO_mdc]
set_input_delay -clock nlos_mdio_pad_clock -min -0.2 [get_ports MDIO_mdio_io]
set_input_delay -clock nlos_mdio_pad_clock -max 22.2 [get_ports MDIO_mdio_io]
set_output_delay -clock nlos_mdio_pad_clock -max [expr {$mdio_half+10.2}] [get_ports MDIO_mdio_io]
set_output_delay -clock nlos_mdio_pad_clock -min [expr {$mdio_half-10.2}] [get_ports MDIO_mdio_io]
puts "MDIO_MODEL period=$mdio_period half=$mdio_half effective_out_max=[expr {$mdio_half+10.2}] effective_out_min=[expr {$mdio_half-10.2}]"


