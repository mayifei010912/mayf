open_hw_manager
connect_hw_server -url localhost:3122
refresh_hw_server
set targets [get_hw_targets -quiet]
puts "READ_ONLY_TARGET_COUNT: [llength $targets]"
if {[llength $targets] == 0} { error "No JTAG cable detected" }
foreach target $targets {
  puts "READ_ONLY_TARGET: $target"
  current_hw_target $target
  open_hw_target
  set devices [get_hw_devices -quiet]
  puts "READ_ONLY_DEVICE_COUNT: [llength $devices]"
  foreach device $devices {
    puts "READ_ONLY_DEVICE: $device PART=[get_property PART $device]"
  }
  close_hw_target
}
disconnect_hw_server
close_hw_manager
puts READ_ONLY_JTAG_CHECK_COMPLETE
