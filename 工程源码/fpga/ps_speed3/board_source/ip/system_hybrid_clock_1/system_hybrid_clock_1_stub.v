// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.2 (win64) Build 3064766 Wed Nov 18 09:12:45 MST 2020
// Date        : Fri Oct 30 22:46:32 2026
// Host        : mayifei running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               f:/fpga/PenumbraSight_hybrid_FISTA_20261030/board_source/ip/system_hybrid_clock_1/system_hybrid_clock_1_stub.v
// Design      : system_hybrid_clock_1
// Purpose     : Stub declaration of top-level module interface
// Device      : xczu4ev-sfvc784-2-i
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "hybrid_clock_div2,Vivado 2020.2" *)
module system_hybrid_clock_1(clk_in1, resetn, clk_out1, locked)
/* synthesis syn_black_box black_box_pad_pin="clk_in1,resetn,clk_out1,locked" */;
  input clk_in1;
  input resetn;
  output clk_out1;
  output locked;
endmodule
