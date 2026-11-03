set work F:/fpga/PenumbraSight_hybrid_FISTA_20261030/board_support/PenumbraSight_interface_closure_20261017
set_param general.maxThreads 2
create_project -force official_bridge [file join $work official_ip_project] -part xczu4ev-sfvc784-2-i
create_ip -name gmii_to_rgmii -vendor xilinx.com -library ip -version 4.1 -module_name nlos_vendor_gmii
set ip [get_ips nlos_vendor_gmii]
report_property $ip
set_property -dict {CONFIG.C_PHYADDR 0 CONFIG.C_EXTERNAL_CLOCK false CONFIG.C_USE_IDELAY_CTRL true CONFIG.RGMII_TXC_SKEW 1 CONFIG.SupportLevel Include_Shared_Logic_in_Core} $ip
generate_target all $ip
report_ip_status -file [file join $work official_bridge_ip_status.rpt]
synth_ip $ip
puts "OFFICIAL GMII/RGMII IP GENERATION AND SYNTHESIS COMPLETE"
close_project
