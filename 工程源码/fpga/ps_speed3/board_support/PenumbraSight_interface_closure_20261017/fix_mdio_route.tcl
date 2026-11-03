set mdio [get_ports MDIO_mdio_io]
set mdcsrc [get_pins -hier -filter {NAME =~ */PS8_i/EMIOENET0MDIOMDC}]
if {[llength $mdcsrc]!=1} {error "PS MDC clock source missing"}
create_generated_clock -name nlos_mdio_pad_clock -source $mdcsrc -divide_by 1 [get_ports MDIO_mdc]
set_input_delay -clock nlos_mdio_pad_clock -min -0.2 $mdio
set_input_delay -clock nlos_mdio_pad_clock -max 20.2 $mdio
set_output_delay -clock nlos_mdio_pad_clock -min -10.2 $mdio
set_output_delay -clock nlos_mdio_pad_clock -max 10.2 $mdio
report_timing -to $mdio -delay_type min -max_paths 5 -file [file join $work mdio_before_hold.rpt]
# Add bounded physical propagation to the two slow management output nets.
# 15 ns minimum net delay covers the PHY's 10 ns hold requirement;
# 100 ns maximum is below the specified 160 ns minimum MDC half-cycle.
foreach pin {MDIO_mdio_iobuf/OBUFT/I MDIO_mdio_iobuf/OBUFT/T} {
 set p [get_pins $pin]
 if {[llength $p]!=1} {error "MDIO output/enable pin missing: $pin"}
 route_design -unroute -pins $p
 route_design -pins $p -min_delay 15000 -max_delay 100000
}
route_design -finalize
foreach mode {max min} {
 report_timing -to $mdio -delay_type $mode -max_paths 10 -file [file join $work mdio_after_output_${mode}.rpt]
 report_timing -from $mdio -delay_type $mode -max_paths 5 -file [file join $work mdio_after_input_${mode}.rpt]
}
report_route_status -file [file join $work mdio_route_status.rpt]
write_checkpoint -force [file join $work system_wrapper_mdio_delay_trial.dcp]
puts "MDIO BOUNDED ROUTING TRIAL COMPLETE; CHECK FINAL DELAYS BEFORE ACCEPTANCE"
