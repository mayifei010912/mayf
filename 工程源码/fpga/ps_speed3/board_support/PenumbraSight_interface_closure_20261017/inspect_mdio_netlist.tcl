set_param general.maxThreads 2
open_checkpoint F:/fpga/PenumbraSight_hybrid_FISTA_20261030/board_support/PenumbraSight_interface_closure_20261017/vendor_rgmii_verified_routed.dcp
puts "DEBUG_CORES: [get_debug_cores -quiet]"
puts "MDIO_NETS: [get_nets -hier -filter {NAME =~ *MDIO* || NAME =~ *mdio*}]"
puts "PS_MDIO_PINS: [get_pins -hier -filter {NAME =~ *PS8_i/EMIOENET0MDIO*}]"
puts "CLOCK0_NET: [get_nets -of_objects [get_pins {system_i/zynq_ultra_ps_e_0/inst/PS8_i/PLCLK[0]}]]"
help create_debug_core
help implement_debug_core
puts LOCAL_INSPECTION_COMPLETE
