connect -url TCP:127.0.0.1:3121
puts "TARGETS [targets]"
targets -set -filter {name =~ "PSU"}
puts "PS_PL_REF_CLOCK_REGISTERS"
mrd -force 0xFF5E00C0 4
puts "PS_PL_RESET_REGISTER"
mrd -force 0xFF0A0054 1
disconnect
exit
