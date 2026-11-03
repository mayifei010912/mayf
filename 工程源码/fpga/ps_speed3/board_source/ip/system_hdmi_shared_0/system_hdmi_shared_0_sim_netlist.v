// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.2 (win64) Build 3064766 Wed Nov 18 09:12:45 MST 2020
// Date        : Sat Oct 17 21:50:09 2026
// Host        : mayifei running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               f:/fpga/PenumbraSight_board_vendor_gmii_20261017/source_full/system/ip/system_hdmi_shared_0/system_hdmi_shared_0_sim_netlist.v
// Design      : system_hdmi_shared_0
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xczu4ev-sfvc784-2-i
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "system_hdmi_shared_0,hdmi_clock_shared,{}" *) (* DowngradeIPIdentifiedWarnings = "yes" *) (* IP_DEFINITION_SOURCE = "module_ref" *) 
(* X_CORE_INFO = "hdmi_clock_shared,Vivado 2020.2" *) 
(* NotValidForBitStream *)
module system_hdmi_shared_0
   (raw_clock,
    locked,
    fast_clock,
    slow_clock,
    pixel_clock);
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 raw_clock CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME raw_clock, FREQ_HZ 370829625, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN system_clk_wiz_0_1_clk_out1, INSERT_VIP 0" *) input raw_clock;
  input locked;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 fast_clock CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME fast_clock, FREQ_HZ 370829625, FREQ_TOLERANCE_HZ 0, PHASE 0.000, CLK_DOMAIN system_hdmi_shared_0_fast_clock, INSERT_VIP 0" *) output fast_clock;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 slow_clock CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME slow_clock, FREQ_HZ 185414813, FREQ_TOLERANCE_HZ 0, PHASE 0.000, CLK_DOMAIN system_hdmi_shared_0_slow_clock, INSERT_VIP 0" *) output slow_clock;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 pixel_clock CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME pixel_clock, FREQ_HZ 74165925, FREQ_TOLERANCE_HZ 0, PHASE 0.000, CLK_DOMAIN system_hdmi_shared_0_pixel_clock, INSERT_VIP 0" *) output pixel_clock;

  wire fast_clock;
  wire locked;
  wire pixel_clock;
  wire raw_clock;
  wire slow_clock;

  (* KEEP_HIERARCHY = "yes" *) 
  system_hdmi_shared_0_hdmi_clock_shared inst
       (.fast_clock(fast_clock),
        .locked(locked),
        .pixel_clock(pixel_clock),
        .raw_clock(raw_clock),
        .slow_clock(slow_clock));
endmodule

(* ORIG_REF_NAME = "hdmi_clock_shared" *) (* keep_hierarchy = "yes" *) 
module system_hdmi_shared_0_hdmi_clock_shared
   (raw_clock,
    locked,
    fast_clock,
    slow_clock,
    pixel_clock);
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 raw_clock CLK" *) input raw_clock;
  input locked;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 fast_clock CLK" *) output fast_clock;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 slow_clock CLK" *) output slow_clock;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 pixel_clock CLK" *) output pixel_clock;

  wire CLR0;
  wire fast_clock;
  wire locked;
  wire pixel_clock;
  wire raw_clock;
  wire slow_clock;

  (* BOX_TYPE = "PRIMITIVE" *) 
  BUFGCE #(
    .CE_TYPE("SYNC"),
    .IS_CE_INVERTED(1'b0),
    .IS_I_INVERTED(1'b0),
    .SIM_DEVICE("ULTRASCALE"),
    .STARTUP_SYNC("FALSE")) 
    fast_buffer
       (.CE(locked),
        .I(raw_clock),
        .O(fast_clock));
  (* BOX_TYPE = "PRIMITIVE" *) 
  BUFGCE_DIV #(
    .BUFGCE_DIVIDE(5),
    .CE_TYPE("SYNC"),
    .HARDSYNC_CLR("FALSE"),
    .IS_CE_INVERTED(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_I_INVERTED(1'b0),
    .SIM_DEVICE("ULTRASCALE"),
    .STARTUP_SYNC("FALSE")) 
    pixel_buffer
       (.CE(1'b1),
        .CLR(CLR0),
        .I(raw_clock),
        .O(pixel_clock));
  (* BOX_TYPE = "PRIMITIVE" *) 
  BUFGCE_DIV #(
    .BUFGCE_DIVIDE(2),
    .CE_TYPE("SYNC"),
    .HARDSYNC_CLR("FALSE"),
    .IS_CE_INVERTED(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_I_INVERTED(1'b0),
    .SIM_DEVICE("ULTRASCALE"),
    .STARTUP_SYNC("FALSE")) 
    slow_buffer
       (.CE(1'b1),
        .CLR(CLR0),
        .I(raw_clock),
        .O(slow_clock));
  LUT1 #(
    .INIT(2'h1)) 
    slow_buffer_i_1
       (.I0(locked),
        .O(CLR0));
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
