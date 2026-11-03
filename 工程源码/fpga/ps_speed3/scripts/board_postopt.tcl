set hybrid_root [file normalize [file join [file dirname [info script]] ..]]
source [file join $hybrid_root board_support PenumbraSight_mdio_timing_20261018 mdio_postopt.tcl]
set_param general.maxThreads 4
