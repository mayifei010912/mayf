#
#Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
#
set_param power.BramSDPPropagationFix 1
set_param project.singleFileAddWarning.threshold 0
set_param general.maxThreads 2
set_param chipscope.maxJobs 1
set_param power.enableUnconnectedCarry8PinPower 1
set_param synth.enableIncremental 0
set_param power.enableCarry8RouteBelPower 1
set_param power.enableLutRouteBelPower 1
set_param chipscope.flow 0
set_param synth.rodin.xdcFlow false
set part xczu4ev-sfvc784-2-i
set board_part_repo_paths {}
set board_part {}
set board_connections {}
set tool_flow Vivado
set ip_vlnv xilinx.com:ip:ddr4_phy:2.2
set ip_module_name system_ddr4_0_0_phy
set params {{{PARAM_VALUE.C0.ControllerType} {DDR4_SDRAM} {PARAM_VALUE.C0.DDR4_CLAMSHELL} {false} {PARAM_VALUE.C0.DDR4_CLKFBOUT_MULT} {16} {PARAM_VALUE.C0.DDR4_CLKOUT0_DIVIDE} {6} {PARAM_VALUE.C0.DDR4_CLKOUTPHY_MODE} {VCO_2X} {PARAM_VALUE.C0.DDR4_CasLatency} {15} {PARAM_VALUE.C0.DDR4_CasWriteLatency} {11} {PARAM_VALUE.C0.DDR4_ChipSelect} {true} {PARAM_VALUE.C0.DDR4_DIVCLK_DIVIDE} {1} {PARAM_VALUE.C0.DDR4_DataMask} {DM_NO_DBI} {PARAM_VALUE.C0.DDR4_DataWidth} {16} {PARAM_VALUE.C0.DDR4_ECC} {false} {PARAM_VALUE.C0.DDR4_EN_PARITY} {false} {PARAM_VALUE.C0.DDR4_Enable_LVAUX} {false} {PARAM_VALUE.C0.DDR4_HR_MIN_FREQ} {0} {PARAM_VALUE.C0.DDR4_InputClockPeriod} {10005} {PARAM_VALUE.C0.DDR4_MemoryPart} {MT40A256M16GE-083E} {PARAM_VALUE.C0.DDR4_MemoryType} {Components} {PARAM_VALUE.C0.DDR4_MemoryVoltage} {1.2V} {PARAM_VALUE.C0.DDR4_PhyClockRatio} {4:1} {PARAM_VALUE.C0.DDR4_SAVE_RESTORE} {false} {PARAM_VALUE.C0.DDR4_SELF_REFRESH} {false} {PARAM_VALUE.C0.DDR4_Slot} {Single} {PARAM_VALUE.C0.DDR4_StackHeight} {1} {PARAM_VALUE.C0.DDR4_TimePeriod} {938} {PARAM_VALUE.C0.DDR4_VrefVoltage} {0.84} {PARAM_VALUE.C0.DDR4_isCKEShared} {false} {PARAM_VALUE.CLKOUT1_DIVIDE} {8} {PARAM_VALUE.CLKOUT2_DIVIDE} {0} {PARAM_VALUE.CLKOUT3_DIVIDE} {0} {PARAM_VALUE.CLKOUT4_DIVIDE} {0} {PARAM_VALUE.CUSTOM_PART_ATTRIBUTES} {NONE} {PARAM_VALUE.DEBUG_SIGNAL} {Disable} {PARAM_VALUE.DIFF_TERM_SYSCLK} {false} {PARAM_VALUE.PARTIAL_RECONFIG_FLOW_MIG} {false} {PARAM_VALUE.Phy_Only} {Complete_Memory_Controller} {PARAM_VALUE.Simulation_Mode} {BFM} {PARAM_VALUE.System_Clock} {Differential} {PARAM_VALUE.c0_act_n} {bank64.byte2.pin1} {PARAM_VALUE.c0_adr_0} {bank64.byte1.pin3} {PARAM_VALUE.c0_adr_1} {bank64.byte0.pin4} {PARAM_VALUE.c0_adr_10} {bank64.byte0.pin7} {PARAM_VALUE.c0_adr_11} {bank64.byte1.pin1} {PARAM_VALUE.c0_adr_12} {bank64.byte0.pin11} {PARAM_VALUE.c0_adr_13} {bank64.byte0.pin1} {PARAM_VALUE.c0_adr_14} {bank64.byte1.pin9} {PARAM_VALUE.c0_adr_15} {bank64.byte0.pin8} {PARAM_VALUE.c0_adr_16} {bank64.byte2.pin12} {PARAM_VALUE.c0_adr_2} {bank64.byte1.pin2} {PARAM_VALUE.c0_adr_3} {bank64.byte0.pin5} {PARAM_VALUE.c0_adr_4} {bank64.byte1.pin8} {PARAM_VALUE.c0_adr_5} {bank64.byte0.pin6} {PARAM_VALUE.c0_adr_6} {bank64.byte1.pin5} {PARAM_VALUE.c0_adr_7} {bank64.byte0.pin2} {PARAM_VALUE.c0_adr_8} {bank64.byte1.pin4} {PARAM_VALUE.c0_adr_9} {bank64.byte0.pin0} {PARAM_VALUE.c0_ba_0} {bank64.byte1.pin12} {PARAM_VALUE.c0_ba_1} {bank64.byte0.pin9} {PARAM_VALUE.c0_bg_0} {bank64.byte0.pin3} {PARAM_VALUE.c0_ck_c_0} {bank64.byte1.pin7} {PARAM_VALUE.c0_ck_t_0} {bank64.byte1.pin6} {PARAM_VALUE.c0_cke_0} {bank64.byte3.pin12} {PARAM_VALUE.c0_cs_n_0} {bank64.byte0.pin10} {PARAM_VALUE.c0_dm_dbi_n_0} {bank64.byte3.pin0} {PARAM_VALUE.c0_dm_dbi_n_1} {bank64.byte2.pin0} {PARAM_VALUE.c0_dq_0} {bank64.byte3.pin11} {PARAM_VALUE.c0_dq_1} {bank64.byte3.pin10} {PARAM_VALUE.c0_dq_10} {bank64.byte2.pin9} {PARAM_VALUE.c0_dq_11} {bank64.byte2.pin8} {PARAM_VALUE.c0_dq_12} {bank64.byte2.pin5} {PARAM_VALUE.c0_dq_13} {bank64.byte2.pin4} {PARAM_VALUE.c0_dq_14} {bank64.byte2.pin3} {PARAM_VALUE.c0_dq_15} {bank64.byte2.pin2} {PARAM_VALUE.c0_dq_2} {bank64.byte3.pin9} {PARAM_VALUE.c0_dq_3} {bank64.byte3.pin8} {PARAM_VALUE.c0_dq_4} {bank64.byte3.pin5} {PARAM_VALUE.c0_dq_5} {bank64.byte3.pin4} {PARAM_VALUE.c0_dq_6} {bank64.byte3.pin3} {PARAM_VALUE.c0_dq_7} {bank64.byte3.pin2} {PARAM_VALUE.c0_dq_8} {bank64.byte2.pin11} {PARAM_VALUE.c0_dq_9} {bank64.byte2.pin10} {PARAM_VALUE.c0_dqs_c_0} {bank64.byte3.pin7} {PARAM_VALUE.c0_dqs_c_1} {bank64.byte2.pin7} {PARAM_VALUE.c0_dqs_t_0} {bank64.byte3.pin6} {PARAM_VALUE.c0_dqs_t_1} {bank64.byte2.pin6} {PARAM_VALUE.c0_odt_0} {bank64.byte3.pin1} {PARAM_VALUE.c0_reset_n} {bank64.byte1.pin0} {PARAM_VALUE.c0_sys_clk_n} {bank64.byte1.pin11} {PARAM_VALUE.c0_sys_clk_p} {bank64.byte1.pin10}}}
set output_xci f:/fpga/PenumbraSight_vivado_temp_20261016/46224/out/system_ddr4_0_0_phy.0/result.xci
set output_dcp f:/fpga/PenumbraSight_vivado_temp_20261016/46224/out/system_ddr4_0_0_phy.0/result.dcp
set output_dir f:/fpga/PenumbraSight_vivado_temp_20261016/46224/out
set ip_repo_paths {
  F:/fpga/PenumbraSight_hybrid_FISTA_20261030/board_support/PenumbraSight_hdmi_fix_20261016/ip_repo
  F:/fpga/PenumbraSight_hybrid_FISTA_20261030/board_support/PenumbraSight_board_base_20261015/4ev/ip_repo
}
set ip_output_repo F:/fpga/PenumbraSight_hybrid_FISTA_20261030/board_support/PenumbraSight_board_synth_20261016/project/mpsoc_p4_board_nlos.cache/ip
set ip_cache_permissions {read write}

set oopbus_ip_repo_paths [get_param chipscope.oopbus_ip_repo_paths]

set synth_opts {{-bufg 0 -no_iobuf}}
set ordering_constrs 1
set bGenNoOOC 0
set xdc_files F:/fpga/PenumbraSight_hybrid_FISTA_20261030/board_support/PenumbraSight_vivado_temp_20261016/46224/system_ddr4_0_0_phy_0/u_mig_ddr4_phy_phy.xdc
source {F:/Xilinx/Vivado/2020.2/scripts/ip/ipxchipscope.tcl}

set failed [catch {ipx::chipscope::gen_and_synth_ip $part $board_part $board_connections $board_part_repo_paths $tool_flow $ip_vlnv $ip_module_name $params $output_xci $output_dcp $output_dir $ip_repo_paths $ip_output_repo $ip_cache_permissions $oopbus_ip_repo_paths $synth_opts $xdc_files $ordering_constrs $bGenNoOOC} errMessage]

if { $failed } {
send_msg_id {IP_Flow 19-3805} ERROR "Failed to generate and synthesize debug IP $ip_vlnv. \n $errMessage"
  exit 1
}
