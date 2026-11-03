set_param general.maxThreads 2
set newroot F:/fpga/PenumbraSight_hybrid_FISTA_20261030/board_support/PenumbraSight_board_vendor_gmii_20261017
if {[file exists $newroot]} {error "Vendor bridge checkout already exists; inspect it before reuse"}
open_project F:/fpga/PenumbraSight_hybrid_FISTA_20261030/board_support/PenumbraSight_board_synth_20261016/project/mpsoc_p4_board_nlos.xpr
save_project_as -exclude_run_results -include_local_ip_cache board_vendor_gmii $newroot
puts "CLONE_CURRENT_PROJECT [get_property DIRECTORY [current_project]]"
puts "CLONE_BD [get_files -all */system.bd]"
puts "CLONE_TOP [get_property TOP [get_filesets sources_1]]"
close_project
