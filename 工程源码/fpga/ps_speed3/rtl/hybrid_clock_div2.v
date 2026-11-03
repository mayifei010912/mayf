// Integer divide of the existing PS PL clock, using a clock buffer, not an MMCM.
`timescale 1ns/1ps
module hybrid_clock_div2(
 (* X_INTERFACE_INFO="xilinx.com:signal:clock:1.0 clk_in1 CLK" *)
 (* X_INTERFACE_PARAMETER="XIL_INTERFACENAME clk_in1, FREQ_HZ 99999001, ASSOCIATED_RESET resetn" *)
 input wire clk_in1,
 (* X_INTERFACE_INFO="xilinx.com:signal:reset:1.0 resetn RST" *)
 (* X_INTERFACE_PARAMETER="XIL_INTERFACENAME resetn, POLARITY ACTIVE_LOW" *)
 input wire resetn,
 (* X_INTERFACE_INFO="xilinx.com:signal:clock:1.0 clk_out1 CLK" *)
 (* X_INTERFACE_PARAMETER="XIL_INTERFACENAME clk_out1, FREQ_HZ 49999500" *)
 output wire clk_out1,
 output wire locked
);
 BUFGCE_DIV #(.BUFGCE_DIVIDE(2)) divide_buffer(.I(clk_in1),.CE(1'b1),.CLR(!resetn),.O(clk_out1));
 // The source is the already running PS clock. No new PLL lock is required.
 assign locked=resetn;
endmodule
