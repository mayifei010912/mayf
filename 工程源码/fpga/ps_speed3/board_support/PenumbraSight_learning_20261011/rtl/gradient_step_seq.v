// One signed fixed-point data-gradient step for the eight-wall-sample example.
// x_next_q = saturate16(x_q - round_away_from_zero(gradient_raw / 2^SHIFT)).
// The test uses SHIFT=22, equivalent to a real step size of 2^-30 with
// x scale 2^15, matrix scale 2^3, and residual scale 2^4.
`default_nettype none
module gradient_step_seq #(
    parameter integer XW = 16,
    parameter integer GW = 48,
    parameter integer ADDRW = 11,
    parameter integer SHIFT = 22
) (
    input wire clk,
    input wire rst_n,
    input wire in_valid,
    input wire [ADDRW-1:0] in_index,
    input wire signed [XW-1:0] x_data,
    input wire signed [GW-1:0] gradient_raw,
    output reg out_valid,
    output reg [ADDRW-1:0] out_index,
    output reg signed [XW-1:0] out_data,
    output reg out_saturated
);
    localparam integer W = GW + 1;
    localparam signed [W-1:0] MAX_X = (2 ** (XW-1)) - 1;
    localparam signed [W-1:0] MIN_X = -(2 ** (XW-1));
    wire signed [W-1:0] gradient_ext = {gradient_raw[GW-1], gradient_raw};
    wire [W-1:0] gradient_abs = gradient_ext < 0 ? -gradient_ext : gradient_ext;
    wire [W-1:0] half = {{(W-1){1'b0}},1'b1} << (SHIFT-1);
    wire [W-1:0] rounded_abs = (gradient_abs + half) >> SHIFT;
    wire signed [W-1:0] delta = gradient_ext < 0 ? -$signed(rounded_abs) : $signed(rounded_abs);
    wire signed [W-1:0] x_ext = {{(W-XW){x_data[XW-1]}},x_data};
    wire signed [W-1:0] next_wide = x_ext - delta;

    always @(posedge clk) begin
        if (!rst_n) begin
            out_valid <= 1'b0;
            out_index <= {ADDRW{1'b0}};
            out_data <= {XW{1'b0}};
            out_saturated <= 1'b0;
        end else begin
            out_valid <= in_valid;
            out_saturated <= 1'b0;
            if (in_valid) begin
                out_index <= in_index;
                if (next_wide > MAX_X) begin
                    out_data <= MAX_X[XW-1:0];
                    out_saturated <= 1'b1;
                end else if (next_wide < MIN_X) begin
                    out_data <= MIN_X[XW-1:0];
                    out_saturated <= 1'b1;
                end else begin
                    out_data <= next_wide[XW-1:0];
                end
            end
        end
    end
endmodule
`default_nettype wire
