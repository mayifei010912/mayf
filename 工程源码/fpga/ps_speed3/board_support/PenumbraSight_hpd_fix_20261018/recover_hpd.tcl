connect -url TCP:127.0.0.1:3122
targets -set -filter {name == "PSU"}
set b 0xFF0A0000
foreach o {0x2c4 0x2c8 0x2cc 0x2d8 0x2dc 0x2e0 0x2e4} {puts [mrd [expr {$b+$o}]]}
set typ [mrd -value [expr {$b+0x2dc}]]
set pol [mrd -value [expr {$b+0x2e0}]]
set any [mrd -value [expr {$b+0x2e4}]]
mwr [expr {$b+0x2d4}] 0x100
mwr [expr {$b+0x2dc}] [expr {$typ & 0xFFFFFEFF}]
mwr [expr {$b+0x2e0}] [expr {$pol | 0x100}]
mwr [expr {$b+0x2e4}] [expr {$any & 0xFFFFFEFF}]
after 100
mwr [expr {$b+0x2d4}] 0x100
mwr [expr {$b+0x2d8}] 0x100
puts "RECOVERY_GPIO86_ONLY_ISOLATION"
foreach o {0x2c4 0x2c8 0x2cc 0x2dc 0x2e0 0x2e4} {puts [mrd [expr {$b+$o}]]}
disconnect
exit
