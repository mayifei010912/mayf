// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.2 (win64) Build 3064766 Wed Nov 18 09:12:45 MST 2020
// Date        : Sat Oct 17 21:56:38 2026
// Host        : mayifei running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               f:/fpga/PenumbraSight_board_vendor_gmii_20261017/source_full/system/ip/system_frame_reset_sync_0/system_frame_reset_sync_0_stub.v
// Design      : system_frame_reset_sync_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xczu4ev-sfvc784-2-i
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "hdmi_frame_reset_sync,Vivado 2020.2" *)
module system_frame_reset_sync_0(clk, global_resetn, software_resetn, resetn)
/* synthesis syn_black_box black_box_pad_pin="clk,global_resetn,software_resetn,resetn" */;
  input clk;
  input global_resetn;
  input software_resetn;
  output resetn;
endmodule
