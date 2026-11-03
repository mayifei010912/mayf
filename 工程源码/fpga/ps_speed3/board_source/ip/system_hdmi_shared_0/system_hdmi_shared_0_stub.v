// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.2 (win64) Build 3064766 Wed Nov 18 09:12:45 MST 2020
// Date        : Sat Oct 17 21:50:09 2026
// Host        : mayifei running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               f:/fpga/PenumbraSight_board_vendor_gmii_20261017/source_full/system/ip/system_hdmi_shared_0/system_hdmi_shared_0_stub.v
// Design      : system_hdmi_shared_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xczu4ev-sfvc784-2-i
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "hdmi_clock_shared,Vivado 2020.2" *)
module system_hdmi_shared_0(raw_clock, locked, fast_clock, slow_clock, 
  pixel_clock)
/* synthesis syn_black_box black_box_pad_pin="raw_clock,locked,fast_clock,slow_clock,pixel_clock" */;
  input raw_clock;
  input locked;
  output fast_clock;
  output slow_clock;
  output pixel_clock;
endmodule
