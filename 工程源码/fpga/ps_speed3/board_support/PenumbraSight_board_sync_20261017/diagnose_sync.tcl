set work F:/fpga/PenumbraSight_hybrid_FISTA_20261030/board_support/PenumbraSight_board_sync_20261017
open_project F:/fpga/PenumbraSight_hybrid_FISTA_20261030/board_support/PenumbraSight_board_synth_20261016/project/mpsoc_p4_board_nlos.xpr
open_run synth_control_sync
set reset [get_pins -hier -filter {NAME =~ *gmii2rgmii_calibrated_0*ODDRE1_tx_ctl/* && (REF_PIN_NAME == RST || REF_PIN_NAME == SR)}]
puts "DIAG_RESET $reset"
set src [all_fanin -flat -startpoints_only -only_cells -to $reset]
puts "DIAG_STARTPOINTS $src"
foreach c $src {report_property $c}
set cone [all_fanin -flat -only_cells -to $reset]
puts "DIAG_CONE $cone"
foreach c [filter $cone {REF_NAME == LUT1}] {puts "DIAG_INV $c [get_property INIT $c]"}
foreach r {system_v_frmbuf_rd_0_3_synth_1 synth_control_sync impl_control_sync synth_1} {puts "DIAG_RUN $r [get_property STATUS [get_runs $r]] refresh=[get_property NEEDS_REFRESH [get_runs $r]]"}
# Keep the session open for a corrected checker, if required.
