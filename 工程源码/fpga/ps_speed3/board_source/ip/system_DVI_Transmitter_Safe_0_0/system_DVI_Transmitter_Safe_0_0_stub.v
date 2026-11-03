// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.2 (win64) Build 3064766 Wed Nov 18 09:12:45 MST 2020
// Date        : Sat Oct 17 21:55:57 2026
// Host        : mayifei running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               f:/fpga/PenumbraSight_board_vendor_gmii_20261017/source_full/system/ip/system_DVI_Transmitter_Safe_0_0/system_DVI_Transmitter_Safe_0_0_stub.v
// Design      : system_DVI_Transmitter_Safe_0_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xczu4ev-sfvc784-2-i
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "dvi_transmitter_top,Vivado 2020.2" *)
module system_DVI_Transmitter_Safe_0_0(pclk, pixel_clk_5x, pixel_clk_2_5x, reset_n, 
  video_din, video_hsync, video_vsync, video_de, tmds_clk_p, tmds_clk_n, tmds_data_p, 
  tmds_data_n, tmds_oen)
/* synthesis syn_black_box black_box_pad_pin="pclk,pixel_clk_5x,pixel_clk_2_5x,reset_n,video_din[23:0],video_hsync,video_vsync,video_de,tmds_clk_p,tmds_clk_n,tmds_data_p[2:0],tmds_data_n[2:0],tmds_oen" */;
  input pclk;
  input pixel_clk_5x;
  input pixel_clk_2_5x;
  input reset_n;
  input [23:0]video_din;
  input video_hsync;
  input video_vsync;
  input video_de;
  output tmds_clk_p;
  output tmds_clk_n;
  output [2:0]tmds_data_p;
  output [2:0]tmds_data_n;
  output tmds_oen;
endmodule
