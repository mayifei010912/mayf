`timescale 1ns/1ps
// Fixed reference independent of the display clock wizard / runtime video mode.
// PS PL clock metadata is 99.999001 MHz (nominal 100); reset must accompany a change.
module rgmii_calibration_clock(
    (* X_INTERFACE_INFO="xilinx.com:signal:clock:1.0 clk100 CLK" *)
    (* X_INTERFACE_PARAMETER="XIL_INTERFACENAME clk100, FREQ_HZ 99999001, ASSOCIATED_RESET resetn" *)
    input wire clk100,
    (* X_INTERFACE_INFO="xilinx.com:signal:reset:1.0 resetn RST" *)
    (* X_INTERFACE_PARAMETER="XIL_INTERFACENAME resetn, POLARITY ACTIVE_LOW" *)
    input wire resetn,
    (* X_INTERFACE_INFO="xilinx.com:signal:clock:1.0 refclk CLK" *)
    (* X_INTERFACE_PARAMETER="XIL_INTERFACENAME refclk, FREQ_HZ 399996004, ASSOCIATED_RESET cal_resetn" *)
    output wire refclk,
    (* X_INTERFACE_INFO="xilinx.com:signal:reset:1.0 cal_resetn RST" *)
    (* X_INTERFACE_PARAMETER="XIL_INTERFACENAME cal_resetn, POLARITY ACTIVE_LOW" *)
    output wire cal_resetn
);
    wire feedback, raw_refclk, locked;
    PLLE4_BASE #(.CLKIN_PERIOD(10.0001),.CLKFBOUT_MULT(12),
        .DIVCLK_DIVIDE(1),.CLKOUT0_DIVIDE(3),.CLKOUT1_DIVIDE(3),
        .STARTUP_WAIT("FALSE")) reference_pll(
        .CLKIN(clk100),.CLKFBIN(feedback),.CLKFBOUT(feedback),
        .CLKOUT0(raw_refclk),.CLKOUT0B(),.CLKOUT1(),.CLKOUT1B(),
        .CLKOUTPHY(),.CLKOUTPHYEN(1'b0),.LOCKED(locked),
        .PWRDWN(1'b0),.RST(!resetn));
    BUFG reference_buffer(.I(raw_refclk),.O(refclk));
    assign cal_resetn=resetn & locked;
endmodule
