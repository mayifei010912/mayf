open_hw_manager
connect_hw_server -url localhost:3122
refresh_hw_server
set targets [get_hw_targets -quiet]
puts "READ_ONLY_TARGET_COUNT: [llength $targets]"
foreach t $targets { puts "READ_ONLY_TARGET: $t" }
disconnect_hw_server
close_hw_manager
puts READ_ONLY_ENUMERATION_COMPLETE
