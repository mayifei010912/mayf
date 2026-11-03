set work [file normalize [file dirname [info script]]]
open_checkpoint [file join $work hdmi_safe_routed.dcp]
set pins [get_pins -hierarchical -filter {NAME =~ *hdmi_pair*fast_buffer/O || NAME =~ *hdmi_pair*slow_buffer/O}]
puts "PAIR_PINS=[llength $pins]"
foreach pin $pins {
    set net [get_nets -of_objects $pin]
    puts "PAIR=$pin NET=$net CDG=[get_property CLOCK_DELAY_GROUP $net]"
    if {[lsearch -exact [list_property $net] CLOCK_ROOT]>=0} {puts "ROOT=[get_property CLOCK_ROOT $net]"}
}
report_clock_utilization -file [file join $work fresh_clock_utilization.rpt]
