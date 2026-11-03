set blackboxes [get_cells -hierarchical -quiet -filter {IS_BLACKBOX == 1}]
if {[llength $blackboxes] != 0} {error "Unresolved black boxes after opt_design: $blackboxes"}
puts "BOARD POST-OPT CHECK PASS: debug hub resolved; no black boxes"
