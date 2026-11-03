set work F:/fpga/PenumbraSight_hybrid_FISTA_20261030/board_support/PenumbraSight_rgmii_fix_20261016
set_param general.maxThreads 2
create_project -force rx_probe [file join $work probe_project] -part xczu4ev-sfvc784-2-i
add_files -norecurse [list [file join $work rgmii_rx_calibrated.v] [file join $work rgmii_rx_probe.v]]
add_files -fileset sim_1 -norecurse [file join $work tb_rgmii_rx_calibrated.sv]
add_files -fileset constrs_1 -norecurse [file join $work rx_probe.xdc]
set_property top rgmii_rx_probe [get_filesets sources_1]
set_property top tb_rgmii_rx_calibrated [get_filesets sim_1]
set_property xsim.simulate.runtime all [get_filesets sim_1]
launch_simulation
close_sim
set f [open [file join $work probe_project rx_probe.sim sim_1 behav xsim simulate.log] r]
set sim [read $f]; close $f
if {[string first {[PASS] CALIBRATED RGMII RX} $sim]<0 || [string first {Fatal:} $sim]>=0} {error "Receiver simulation failed"}
puts "CALIBRATED RGMII RX SIMULATION CHECK PASS"
synth_design -top rgmii_rx_probe -part xczu4ev-sfvc784-2-i
opt_design
place_design
route_design
write_checkpoint -force [file join $work rx_probe_routed.dcp]
report_drc -file [file join $work rx_probe_drc.rpt]
report_route_status -file [file join $work rx_probe_route_status.rpt]
set delays [get_cells -hier -filter {REF_NAME == IDELAYE3}]
if {[llength $delays]!=5} {error "Expected five input delay elements"}
set ports [get_ports {RGMII_rd[*] RGMII_rx_ctl}]
set clock [get_clocks RGMII_rxc]
set f [open [file join $work rx_delay_sweep.tsv] w]
puts $f "delay_ps\tpcb_allowance_ns\tperiod_ns\tduty_fraction\tsetup_ns\thold_ns"
# +/-200 ps is a design allowance, not a measured PCB skew.
foreach delay {0 250 500 550 750 1000} {
    set_property DELAY_VALUE $delay $delays
    foreach period {7.2 8.0 8.8} {
      foreach duty {0.45 0.50 0.55} {
        set high [expr {$period*$duty}]
        create_clock -name RGMII_rxc -period $period -waveform [list 0 $high] [get_ports RGMII_rxc]
        set clock [get_clocks RGMII_rxc]
        set_input_delay -clock $clock -min 0.8 $ports
        set_input_delay -clock $clock -max [expr {$high-0.8}] $ports
        set_input_delay -clock $clock -clock_fall -add_delay -min 0.8 $ports
        set_input_delay -clock $clock -clock_fall -add_delay -max [expr {$period-$high-0.8}] $ports
        set a [get_timing_paths -from $ports -delay_type max -max_paths 1]
        set b [get_timing_paths -from $ports -delay_type min -max_paths 1]
        if {[llength $a]!=1 || [llength $b]!=1} {error "Missing RX timing paths"}
        set ss [get_property SLACK $a]; set hs [get_property SLACK $b]
        puts $f "$delay\t0.2\t$period\t$duty\t$ss\t$hs"
        puts "RX DELAY SWEEP: delay=$delay ps period=$period ns duty=$duty setup=$ss ns hold=$hs ns (200 ps assumed PCB allowance)"
      }
    }
}
close $f
set_property DELAY_VALUE 550 $delays
create_clock -name RGMII_rxc -period 8.0 -waveform {0 4} [get_ports RGMII_rxc]
set clock [get_clocks RGMII_rxc]
set_input_delay -clock $clock -min 0.8 $ports
set_input_delay -clock $clock -max 3.2 $ports
set_input_delay -clock $clock -clock_fall -add_delay -min 0.8 $ports
set_input_delay -clock $clock -clock_fall -add_delay -max 3.2 $ports
report_timing -from $ports -delay_type max -max_paths 5 -file [file join $work rx_candidate_setup.rpt]
report_timing -from $ports -delay_type min -max_paths 5 -file [file join $work rx_candidate_hold.rpt]
write_checkpoint -force [file join $work rx_candidate_550ps_routed.dcp]
puts "CALIBRATED RGMII RX ISOLATED PHYSICAL PROBE COMPLETE; NO BOARD SIGNOFF OR BITSTREAM"
close_project
