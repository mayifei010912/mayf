open_hw_manager
connect_hw_server -url localhost:3121
puts "READ_ONLY_TARGETS: [get_hw_targets]"
foreach target [get_hw_targets] {
  current_hw_target $target
  open_hw_target
  foreach device [get_hw_devices] {
    puts "READ_ONLY_DEVICE: $device PART=[get_property PART $device]"
  }
  close_hw_target
}
disconnect_hw_server
close_hw_manager
puts "READ_ONLY_JTAG_CHECK_COMPLETE"
