set before_mdio_cells [get_cells -hier -filter {IS_PRIMITIVE == 1}]
phys_opt_design -hold_fix -path_groups nlos_mdio_pad_clock
route_design -eco
route_design -finalize
report_timing -to [get_ports MDIO_mdio_io] -delay_type min -max_paths 10 -file [file join $work mdio_physopt_hold.rpt]
report_timing -to [get_ports MDIO_mdio_io] -delay_type max -max_paths 10 -file [file join $work mdio_physopt_setup.rpt]
report_route_status -file [file join $work mdio_physopt_route.rpt]
write_checkpoint -force [file join $work system_wrapper_mdio_physopt.dcp]
puts "MDIO HOLD OPTIMIZATION TRIAL COMPLETE"
