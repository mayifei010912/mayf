set_property -dict {SLEW FAST DRIVE 12} $txall
# Apply receiver requirements before routing, so the router can optimize the
# six local output connections against both setup and hold constraints.
set f [open [file join $work constrained_route_before.tsv] w]
puts $f "case\tphy_delay_ns\ttx_setup_ns\ttx_hold_ns"
io_probe before_reroute 1.95
close $f
set outputs [get_cells -hier -filter {REF_NAME == OBUF && (NAME == RGMII_txc_OBUF_inst || NAME == RGMII_tx_ctl_OBUF_inst || NAME =~ RGMII_td_OBUF*)}]
if {[llength $outputs]!=6} {error "Expected exactly six TX output buffers: $outputs"}
set localnets [get_nets -of_objects [get_pins -of_objects $outputs -filter {REF_PIN_NAME == I}]]
set before_cells [get_cells -hier -filter {IS_PRIMITIVE == 1}]
set before_locs [get_property LOC $before_cells]
set before_bels [get_property BEL $before_cells]
puts "CONSTRAINED_LOCAL_NETS $localnets"
route_design -unroute -nets $localnets
route_design -auto_delay -nets $localnets
route_design -finalize
if {[get_property LOC $before_cells] ne $before_locs || [get_property BEL $before_cells] ne $before_bels} {error "Placement unexpectedly changed"}
set f [open [file join $work constrained_route_after.tsv] w]
puts $f "case\tphy_delay_ns\ttx_setup_ns\ttx_hold_ns"
io_probe after_reroute 1.95
close $f
report_route_status -file [file join $work constrained_route_status.rpt]
report_timing_summary -max_paths 5 -file [file join $work constrained_timing.rpt]
write_checkpoint -force [file join $work system_wrapper_tx_constrained_route.dcp]
puts "CONSTRAINED LOCAL OUTPUT ROUTE COMPLETE"
