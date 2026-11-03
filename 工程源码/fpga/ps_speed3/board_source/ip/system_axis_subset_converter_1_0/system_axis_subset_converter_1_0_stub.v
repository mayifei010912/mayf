// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.2 (win64) Build 3064766 Wed Nov 18 09:12:45 MST 2020
// Date        : Thu Dec 19 15:07:15 2024
// Host        : DESKTOP-2P288OB running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               g:/mpsoc_p4/v20_20241219/4ev/base_vcu/base_vcu.srcs/sources_1/bd/system/ip/system_axis_subset_converter_1_0/system_axis_subset_converter_1_0_stub.v
// Design      : system_axis_subset_converter_1_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xczu4ev-sfvc784-2-i
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "top_system_axis_subset_converter_1_0,Vivado 2020.2" *)
module system_axis_subset_converter_1_0(aclk, aresetn, s_axis_tvalid, s_axis_tready, 
  s_axis_tdata, s_axis_tlast, s_axis_tdest, s_axis_tuser, m_axis_tvalid, m_axis_tready, 
  m_axis_tdata, m_axis_tlast, m_axis_tdest, m_axis_tuser)
/* synthesis syn_black_box black_box_pad_pin="aclk,aresetn,s_axis_tvalid,s_axis_tready,s_axis_tdata[23:0],s_axis_tlast,s_axis_tdest[9:0],s_axis_tuser[0:0],m_axis_tvalid,m_axis_tready,m_axis_tdata[15:0],m_axis_tlast,m_axis_tdest[9:0],m_axis_tuser[0:0]" */;
  input aclk;
  input aresetn;
  input s_axis_tvalid;
  output s_axis_tready;
  input [23:0]s_axis_tdata;
  input s_axis_tlast;
  input [9:0]s_axis_tdest;
  input [0:0]s_axis_tuser;
  output m_axis_tvalid;
  input m_axis_tready;
  output [15:0]m_axis_tdata;
  output m_axis_tlast;
  output [9:0]m_axis_tdest;
  output [0:0]m_axis_tuser;
endmodule
