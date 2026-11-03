`timescale 1ns/1ps
// HDMI clocks share the vendor Clock Wizard's otherwise HDMI-only clk_out4.
// Preserve clk_out2 and its 148 MHz PS/AXI consumers.
(* KEEP_HIERARCHY = "yes" *)
module hdmi_clock_shared(
    (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 raw_clock CLK" *)
    input raw_clock,
    input locked,
    (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 fast_clock CLK" *)
    output fast_clock,
    (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 slow_clock CLK" *)
    output slow_clock,
    (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 pixel_clock CLK" *)
    output pixel_clock
);
    BUFGCE #(.CE_TYPE("SYNC")) fast_buffer
        (.I(raw_clock), .CE(locked), .O(fast_clock));
    BUFGCE_DIV #(.BUFGCE_DIVIDE(2)) slow_buffer
        (.I(raw_clock), .CE(1'b1), .CLR(~locked), .O(slow_clock));
    BUFGCE_DIV #(.BUFGCE_DIVIDE(5)) pixel_buffer
        (.I(raw_clock), .CE(1'b1), .CLR(~locked), .O(pixel_clock));
endmodule
