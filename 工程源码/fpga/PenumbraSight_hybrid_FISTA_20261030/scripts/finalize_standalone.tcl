set root [file normalize [file join [file dirname [info script]] ..]]
open_project [file join $root vivado hybrid_fista_zu4ev hybrid_fista_zu4ev.xpr]
foreach f [glob [file join $root rtl *.v]] {if {![llength [get_files -quiet $f]]} {add_files $f}}
set_property top tb_hybrid_axil [get_filesets sim_1]
update_compile_order -fileset sources_1
close_project
puts "PASS STANDALONE GUI SIMULATION SOURCES READY"
