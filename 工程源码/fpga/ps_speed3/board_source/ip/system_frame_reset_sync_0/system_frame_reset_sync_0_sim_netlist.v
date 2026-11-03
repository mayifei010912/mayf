// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.2 (win64) Build 3064766 Wed Nov 18 09:12:45 MST 2020
// Date        : Sat Oct 17 21:56:38 2026
// Host        : mayifei running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               f:/fpga/PenumbraSight_board_vendor_gmii_20261017/source_full/system/ip/system_frame_reset_sync_0/system_frame_reset_sync_0_sim_netlist.v
// Design      : system_frame_reset_sync_0
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xczu4ev-sfvc784-2-i
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "system_frame_reset_sync_0,hdmi_frame_reset_sync,{}" *) (* DowngradeIPIdentifiedWarnings = "yes" *) (* IP_DEFINITION_SOURCE = "module_ref" *) 
(* X_CORE_INFO = "hdmi_frame_reset_sync,Vivado 2020.2" *) 
(* NotValidForBitStream *)
module system_frame_reset_sync_0
   (clk,
    global_resetn,
    software_resetn,
    resetn);
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 clk CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME clk, ASSOCIATED_RESET resetn, FREQ_HZ 74165925, FREQ_TOLERANCE_HZ 0, PHASE 0.000, CLK_DOMAIN system_hdmi_shared_0_pixel_clock, INSERT_VIP 0" *) input clk;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 global_resetn RST" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME global_resetn, POLARITY ACTIVE_LOW, INSERT_VIP 0" *) input global_resetn;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 software_resetn RST" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME software_resetn, POLARITY ACTIVE_LOW, INSERT_VIP 0" *) input software_resetn;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 resetn RST" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME resetn, POLARITY ACTIVE_LOW, INSERT_VIP 0" *) output resetn;

  wire clk;
  wire global_resetn;
  wire resetn;
  wire software_resetn;

  system_frame_reset_sync_0_hdmi_frame_reset_sync inst
       (.clk(clk),
        .global_resetn(global_resetn),
        .resetn(resetn),
        .software_resetn(software_resetn));
endmodule

(* ORIG_REF_NAME = "hdmi_frame_reset_sync" *) 
module system_frame_reset_sync_0_hdmi_frame_reset_sync
   (resetn,
    global_resetn,
    software_resetn,
    clk);
  output resetn;
  input global_resetn;
  input software_resetn;
  input clk;

  wire clk;
  wire global_resetn;
  (* async_reg = "true" *) (* shreg_extract = "no" *) wire [2:0]release_pipe;
  wire \release_pipe[2]_i_1_n_0 ;
  wire software_resetn;

  assign resetn = release_pipe[2];
  LUT2 #(
    .INIT(4'h7)) 
    \release_pipe[2]_i_1 
       (.I0(global_resetn),
        .I1(software_resetn),
        .O(\release_pipe[2]_i_1_n_0 ));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "no" *) 
  FDCE #(
    .INIT(1'b0)) 
    \release_pipe_reg[0] 
       (.C(clk),
        .CE(1'b1),
        .CLR(\release_pipe[2]_i_1_n_0 ),
        .D(1'b1),
        .Q(release_pipe[0]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "no" *) 
  FDCE #(
    .INIT(1'b0)) 
    \release_pipe_reg[1] 
       (.C(clk),
        .CE(1'b1),
        .CLR(\release_pipe[2]_i_1_n_0 ),
        .D(release_pipe[0]),
        .Q(release_pipe[1]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "no" *) 
  FDCE #(
    .INIT(1'b0)) 
    \release_pipe_reg[2] 
       (.C(clk),
        .CE(1'b1),
        .CLR(\release_pipe[2]_i_1_n_0 ),
        .D(release_pipe[1]),
        .Q(release_pipe[2]));
endmodule
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;
    parameter GRES_WIDTH = 10000;
    parameter GRES_START = 10000;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    wire GRESTORE;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;
    reg GRESTORE_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;
    assign (strong1, weak0) GRESTORE = GRESTORE_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

    initial begin 
	GRESTORE_int = 1'b0;
	#(GRES_START);
	GRESTORE_int = 1'b1;
	#(GRES_WIDTH);
	GRESTORE_int = 1'b0;
    end

endmodule
`endif
