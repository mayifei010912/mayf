# Keep TX_CTL low until every replicated RX IDELAY controller is ready.
# Asynchronous assertion, three TX-clock edges before reset is released.
if {[llength [get_cells -quiet nlos_vendor_cal_guard_clear]]} {error "Guard already exists"}
set ctrls [get_cells -hier -filter {NAME =~ *vendor_gmii* && REF_NAME == IDELAYCTRL}]
set n [llength $ctrls]
if {$n<1 || $n>6} {error "Unexpected IDELAYCTRL count: $n"}
set ctl [get_cells -hier -filter {NAME =~ *vendor_gmii*rgmii_tx_ctl_out && REF_NAME == OSERDESE3}]
if {[llength $ctl]!=1} {error "Expected one TX_CTL serializer"}
set clocknet [get_nets -of [get_pins $ctl/CLK]]
set oldreset [get_nets -of [get_pins $ctl/RST]]
create_cell -reference LUT$n nlos_vendor_cal_guard_clear
set bits [expr {1<<$n}]
set init [expr {(1<<($bits-1))-1}]
set_property INIT [format "%d'h%X" $bits $init] [get_cells nlos_vendor_cal_guard_clear]
set i 0
foreach controller $ctrls {
  set net [get_nets -quiet -of [get_pins $controller/RDY]]
  if {![llength $net]} {create_net nlos_vendor_cal_guard_rdy_$i; set net [get_nets nlos_vendor_cal_guard_rdy_$i]; connect_net -hier -net $net -objects [get_pins $controller/RDY]}
  connect_net -hier -net $net -objects [get_pins nlos_vendor_cal_guard_clear/I$i]
  incr i
}
create_cell -reference VCC nlos_vendor_cal_guard_vcc
create_net nlos_vendor_cal_guard_one
connect_net -hier -net nlos_vendor_cal_guard_one -objects [get_pins nlos_vendor_cal_guard_vcc/P]
create_net nlos_vendor_cal_guard_notready
connect_net -hier -net nlos_vendor_cal_guard_notready -objects [get_pins nlos_vendor_cal_guard_clear/O]
set previous [get_nets nlos_vendor_cal_guard_one]
for {set i 0} {$i<3} {incr i} {
  set name nlos_vendor_cal_guard_sync_$i
  create_cell -reference FDCE $name
  set_property -dict {INIT 1'b0 ASYNC_REG TRUE DONT_TOUCH TRUE} [get_cells $name]
  connect_net -hier -net $clocknet -objects [get_pins $name/C]
  connect_net -hier -net nlos_vendor_cal_guard_one -objects [get_pins $name/CE]
  connect_net -hier -net $previous -objects [get_pins $name/D]
  connect_net -hier -net nlos_vendor_cal_guard_notready -objects [get_pins $name/CLR]
  create_net ${name}_q
  connect_net -hier -net ${name}_q -objects [get_pins $name/Q]
  set previous [get_nets ${name}_q]
}
create_cell -reference LUT2 nlos_vendor_cal_guard_reset
set_property INIT 4'hD [get_cells nlos_vendor_cal_guard_reset]
connect_net -hier -net $previous -objects [get_pins nlos_vendor_cal_guard_reset/I0]
connect_net -hier -net $oldreset -objects [get_pins nlos_vendor_cal_guard_reset/I1]
create_net nlos_vendor_cal_guard_tx_reset
connect_net -hier -net nlos_vendor_cal_guard_tx_reset -objects [get_pins nlos_vendor_cal_guard_reset/O]
disconnect_net -net $oldreset -objects [get_pins $ctl/RST]
connect_net -hier -net nlos_vendor_cal_guard_tx_reset -objects [get_pins $ctl/RST]
# These are asynchronous assertion pins; release is synchronized by 3 stages.
set_false_path -to [get_pins nlos_vendor_cal_guard_sync_*/CLR]
set_max_delay -datapath_only 2.0 -from [get_pins nlos_vendor_cal_guard_sync_2/C] -to [get_pins $ctl/RST]
set_min_delay 0.0 -from [get_pins nlos_vendor_cal_guard_sync_2/C] -to [get_pins $ctl/RST]
set_property UNAVAILABLE_DURING_CALIBRATION TRUE [get_ports {RGMII_td[0]}]
# Assert the cross-hierarchy connections actually exist before acknowledging BISC.
if {[get_nets -segments -of [get_pins $ctl/RST]] eq "" || [llength [all_fanin -flat -startpoints_only -only_cells -to [get_pins $ctl/RST]]]<1} {error "Guard reset is disconnected"}
puts "VENDOR CALIBRATION GUARD CONNECTED: $n controllers, 3 TX-clock release stages, TX_CTL reset and narrow TD0 calibration acknowledgement"
