set hybrid_root [file normalize [file join [file dirname [info script]] ..]]
set hybrid_support [file join $hybrid_root board_support]
source [file join $hybrid_support PenumbraSight_hdmi_fix_20261016 board_shared_clock_impl.xdc]
source [file join $hybrid_support PenumbraSight_reset_sync_20261016 frame_reset_sync_impl.xdc]
source [file join $hybrid_support project source vendor_io_impl.xdc]
source [file join $hybrid_support project source vendor_phy_impl.xdc]
source [file join $hybrid_support project source vendor_mdio_impl.xdc]
set hc [get_cells -hier -filter {NAME =~ *hybrid_clock*divide_buffer && REF_NAME == BUFGCE_DIV}]
if {[llength $hc]!=1} {error "Expected dedicated divide-by-two clock buffer"}
set hclocks [get_clocks -of_objects [get_pins $hc/O]]
if {[llength $hclocks]!=1} {error "Expected one automatically derived divide-by-two clock"}
set hp [get_property PERIOD $hclocks]
if {$hp<19.9 || $hp>20.1} {error "Wrong divided kernel clock period: $hp"}
source [file join $hybrid_support PenumbraSight_hdmi_fix_20261016 check_board_shared_impl_constraints.tcl]
# MIG PHY has been synthesized separately and is present in the project cache.
set_param general.maxThreads 4
puts "HYBRID PRE-OPT: full guarded HDMI/reset/RGMII/MDIO constraints applied"
