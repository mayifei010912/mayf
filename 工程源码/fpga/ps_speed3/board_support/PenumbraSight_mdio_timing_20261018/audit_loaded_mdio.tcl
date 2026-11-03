set results [open [file join $task_dir path_checks.tsv] w]
puts $results "check\tdelay_type\tpaths\tworst_slack_ns"
foreach entry {{output_data MDIO_mdio_iobuf/OBUFT/I} {output_enable MDIO_mdio_iobuf/OBUFT/T}} {
  lassign $entry label pin_name
  foreach delay {max min} {
    set paths [get_timing_paths -through [get_pins $pin_name] -to [get_ports MDIO_mdio_io] -delay_type $delay -max_paths 16 -nworst 16]
    if {[llength $paths] == 0} {error "Uncovered $label $delay"}
    set worst 100000
    foreach path $paths {
      set slack [get_property SLACK $path]
      set worst [expr {min($worst,$slack)}]
      if {$slack < 0} {error "MDIO violation $label $delay $slack"}
      if {[get_property STARTPOINT_PIN $path] ne $mdio_source} {error "Unexpected output launch source"}
    }
    puts $results "$label\t$delay\t[llength $paths]\t$worst"
    report_timing -through [get_pins $pin_name] -to [get_ports MDIO_mdio_io] -delay_type $delay -max_paths 16 -nworst 16 -path_type full_clock_expanded -file [file join $task_dir ${label}_${delay}.rpt]
  }
}
foreach delay {max min} {
  set paths [get_timing_paths -from [get_ports MDIO_mdio_io] -to [get_pins $mdio_ps/EMIOENET0MDIOI] -delay_type $delay -max_paths 16 -nworst 16]
  if {[llength $paths] == 0} {error "Uncovered MDIO input $delay"}
  set worst 100000
  foreach path $paths {
    set slack [get_property SLACK $path]
    set worst [expr {min($worst,$slack)}]
    if {$slack < 0} {error "Input violation $delay $slack"}
  }
  puts $results "input_to_ps\t$delay\t[llength $paths]\t$worst"
  report_timing -from [get_ports MDIO_mdio_io] -to [get_pins $mdio_ps/EMIOENET0MDIOI] -delay_type $delay -max_paths 16 -nworst 16 -path_type full_clock_expanded -file [file join $task_dir input_to_ps_${delay}.rpt]
}
# Internal bridge MDIO decoder uses the same MDC clock. Its PS8 source arc
# has the same rising/falling abstraction issue. Audit half-period-corrected
# margins explicitly; no internal path is waived or set false.
foreach name {EMIOENET0MDIOO EMIOENET0MDIOTN} {
  set endpoints [all_fanout -flat -endpoints_only -from [get_pins $mdio_ps/$name]]
  puts "FANOUT $name $endpoints"
  set internal {}
  foreach ep $endpoints {
    if {[get_property CLASS $ep] eq "pin"} {lappend internal $ep}
  }
  foreach delay {max min} {
    if {[llength $internal] == 0} {puts "NO_INTERNAL_ENDPOINTS $name"; continue}
    set paths [get_timing_paths -through [get_pins $mdio_ps/$name] -to $internal -delay_type $delay -max_paths 1000 -nworst 16]
    if {[llength $paths] == 0} {error "Internal decoder paths unexpectedly missing $name"}
    set worst 100000
    foreach path $paths {
      set sl [get_property SLACK $path]
      if {$sl eq ""} {
        # The vendor decoder samples MDIO through a multi-stage CDC chain,
        # under the EXISTING asynchronous clock group. Verify the structure
        # and the timed synchronizer-stage path rather than inventing slack.
        set ep [get_property ENDPOINT_PIN $path]
        set first [get_cells -of_objects [get_pins $ep]]
        if {[get_property REF_NAME $first] eq "IBUFCTRL" && [get_property REF_PIN_NAME [get_pins $ep]] eq "T"} {
          # Input-buffer gate is a combinational control endpoint, not a FF.
          # Its release must settle before the next PHY capture half-cycle.
          set gate_delay [get_property DATAPATH_DELAY $path]
          if {$gate_delay < 0 || $gate_delay > $mdio_half-10.2} {error "Input-buffer gate half-cycle budget fails"}
          puts $results "input_gate_propagation_delay\t$delay\t1\t$gate_delay"
          puts "INPUT_GATE_BUDGET_PASS $delay propagation=$gate_delay budget=[expr {$mdio_half-10.2}]"
          continue
        }
        if {![get_property ASYNC_REG $first]} {error "Unconstrained internal path is not a synchronizer: $ep"}
        set capture_clocks [get_clocks -of_objects [get_pins $first/C]]
        if {[llength $capture_clocks] != 1 || $capture_clocks eq $mdio_master} {error "Unexpected CDC capture clock"}
        set next_eps [all_fanout -flat -endpoints_only -from [get_pins $first/Q]]
        if {[llength $next_eps] != 1} {error "First CDC stage has unexpected fanout"}
        set second [get_cells -of_objects [get_pins $next_eps]]
        if {![get_property ASYNC_REG $second]} {error "Missing second CDC stage"}
        if {[get_clocks -of_objects [get_pins $second/C]] ne $capture_clocks} {error "CDC stages clock mismatch"}
        set stage_paths [get_timing_paths -from [get_pins $first/Q] -to [get_pins $second/D] -delay_type $delay -max_paths 1]
        if {[llength $stage_paths] != 1 || [get_property SLACK $stage_paths] eq "" || [get_property SLACK $stage_paths] < 0} {error "Synchronizer stage timing failed"}
        puts "CDC_VERIFIED first=$first second=$second clock=$capture_clocks $delay slack=[get_property SLACK $stage_paths]"
        puts $results "internal_${name}_cdc_stage\t$delay\t1\t[get_property SLACK $stage_paths]"
        continue
      }
      # Physical launch is H later: setup slack reduces H, hold gains H.
      set physical_slack [expr {$delay eq "max" ? $sl-$mdio_half : $sl+$mdio_half}]
      set worst [expr {min($worst,$physical_slack)}]
      if {$physical_slack < 0} {error "Internal half-cycle margin fails $name $delay"}
    }
    if {$worst < 100000} {puts $results "internal_${name}_edge_corrected\t$delay\t[llength $paths]\t$worst"}
    report_timing -through [get_pins $mdio_ps/$name] -to $internal -delay_type $delay -max_paths 10 -nworst 10 -path_type full_clock_expanded -file [file join $task_dir internal_${name}_${delay}.rpt]
  }
}
close $results
report_timing_summary -delay_type min_max -report_unconstrained -file [file join $task_dir final_timing_summary.rpt]
foreach dt {max min} {
  set failing [get_timing_paths -delay_type $dt -slack_lesser_than 0 -max_paths 1]
  if {[llength $failing]} {error "Global $dt timing violation"}
}
report_route_status -file [file join $task_dir final_route_status.rpt]
report_drc -file [file join $task_dir final_drc.rpt]
report_clocks -file [file join $task_dir final_clocks.rpt]
write_checkpoint -force [file join $task_dir vendor_mdio_verified_routed.dcp]
puts {MDIO TIMING AUDIT COMPLETE; NO PLACEMENT, ROUTING, OR HARDWARE PROGRAMMING}
close_design

