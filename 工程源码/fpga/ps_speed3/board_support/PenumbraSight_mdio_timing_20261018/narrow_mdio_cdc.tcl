# Vivado 2020.2: reapply timing XDC with the vendor MDIO CDC exception
# limited to first stages. Physical placement/routing is not reset.
set mdio_cdc_before [file join $task_dir cdc_constraints_before.xdc]
set mdio_cdc_after [file join $task_dir cdc_constraints_narrowed.xdc]
write_xdc -force -exclude_physical $mdio_cdc_before
set mdio_file [open $mdio_cdc_before r]
set mdio_lines [split [read $mdio_file] \n]
close $mdio_file
set mdio_changed 0
set mdio_narrow_existing 0
set mdio_file [open $mdio_cdc_after w]
foreach mdio_line $mdio_lines {
  if {[string match {set_false_path*} $mdio_line]} {
    if {[string first {*i_MANAGEMENT/SYNC_*/data_sync_reg1} $mdio_line]>=0} {
      incr mdio_narrow_existing
    } elseif {[string first {*i_MANAGEMENT/SYNC_*/data_sync*} $mdio_line]>=0} {
      set mdio_line [string map {{*i_MANAGEMENT/SYNC_*/data_sync*} {*i_MANAGEMENT/SYNC_*/data_sync_reg1}} $mdio_line]
      incr mdio_changed
    }
  }
  puts $mdio_file $mdio_line
}
close $mdio_file
if {$mdio_changed != 1 && !($mdio_changed == 0 && $mdio_narrow_existing == 1)} {error "Unexpected vendor CDC exception inventory"}
if {$mdio_changed == 1} {
  reset_timing
  read_xdc $mdio_cdc_after
}
puts "MDIO_CDC_NARROWED broad_replaced=$mdio_changed already_narrow=$mdio_narrow_existing"
