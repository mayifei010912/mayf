# SSTL12 HPD on T6 uses the Bank 65 VREF. This board grounds the external
# VREF pin through 1k; HPD therefore needs the internal 0.6V reference.
# No IRQ masking, GPIO direction change, or fixed hotplug value is allowed.
set hpd_guard_port [get_ports -quiet -filter {NAME == "GPIO_tri_io[8]"}]
if {[llength $hpd_guard_port] != 1} {error {HPD port missing}}
if {[get_property PACKAGE_PIN $hpd_guard_port] ne "T6" || [get_property IOSTANDARD $hpd_guard_port] ne "SSTL12"} {error {HPD pin or I/O standard changed; recheck physical schematic}}
set hpd_guard_vref [get_property INTERNAL_VREF [get_iobanks 65]]
if {![string is double -strict $hpd_guard_vref] || abs($hpd_guard_vref - 0.6) > 0.0001} {error {Bank 65 HPD requires INTERNAL_VREF 0.6; external VREF is not a supplied reference}}
puts {HPD INTERNAL VREF GUARD PASS: T6 SSTL12, Bank65 internal 0.6V}
