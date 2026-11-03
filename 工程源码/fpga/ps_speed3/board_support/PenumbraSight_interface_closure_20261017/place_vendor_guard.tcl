set seeds [all_fanin -flat -startpoints_only -only_cells -to [get_pins nlos_vendor_cal_guard_reset/I1]]
set seedsite ""
foreach seed $seeds {if {[regexp {^SLICE_X([0-9]+)Y([0-9]+)$} [get_property LOC $seed] -> sx sy]} {set seedsite [get_property LOC $seed]; break}}
if {$seedsite eq ""} {error "Cannot locate existing reset synchronizer"}
set placed 0
for {set radius 0} {$radius<=30 && !$placed} {incr radius} {
  for {set dx [expr {-$radius}]} {$dx<=$radius && !$placed} {incr dx} {
    for {set dy [expr {-$radius}]} {$dy<=$radius && !$placed} {incr dy} {
      if {abs($dx)+abs($dy)!=$radius} {continue}
      set site [get_sites -quiet SLICE_X[expr {$sx+$dx}]Y[expr {$sy+$dy}]]
      if {[llength $site]!=1} {continue}
      set bels [get_bels -of $site]
      if {[llength [get_cells -quiet -of $bels]]} {continue}
      place_cell [get_cells nlos_vendor_cal_guard_sync_0] [get_bels $site/AFF]
      place_cell [get_cells nlos_vendor_cal_guard_sync_1] [get_bels $site/BFF]
      place_cell [get_cells nlos_vendor_cal_guard_sync_2] [get_bels $site/CFF]
      place_cell [get_cells nlos_vendor_cal_guard_clear] [get_bels $site/D6LUT]
      place_cell [get_cells nlos_vendor_cal_guard_reset] [get_bels $site/E6LUT]
      set placed 1
      puts "GUARD ECO PLACED IN EMPTY SITE $site; existing placements preserved"
    }
  }
}
if {!$placed} {error "Could not place calibration guard in an empty slice"}
