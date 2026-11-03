`timescale 1ns/1ps
// Preserve the software reset request: assert immediately; release on pixel edges.
module hdmi_frame_reset_sync (
    (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 clk CLK" *)
    input wire clk,
    (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 global_resetn RST" *)
    (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME global_resetn, POLARITY ACTIVE_LOW" *)
    input wire global_resetn,
    (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 software_resetn RST" *)
    (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME software_resetn, POLARITY ACTIVE_LOW" *)
    input wire software_resetn,
    (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 resetn RST" *)
    (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME resetn, POLARITY ACTIVE_LOW" *)
    output wire resetn
);
    wire request_resetn = global_resetn & software_resetn;
    (* ASYNC_REG = "TRUE", SHREG_EXTRACT = "NO" *)
    reg [2:0] release_pipe = 3'b000;
    always @(posedge clk or negedge request_resetn) begin
        if (!request_resetn) release_pipe <= 3'b000;
        else release_pipe <= {release_pipe[1:0], 1'b1};
    end
    assign resetn = release_pipe[2];
endmodule
