// Residual in RTL: round((prediction_raw-measurement_raw)/2^SHIFT), sat16.
// Both raw inputs use matrix_scale*scene_scale=2^18 in the learning example;
// residuals use scale 2^4, hence SHIFT=14. Rounding is away from zero at ties.
`timescale 1ns/1ps
`default_nettype none
module residual_quantize_seq #(
    parameter integer RAW_W=48,
    parameter integer OUT_W=16,
    parameter integer ADDRW=11,
    parameter integer SHIFT=14
) (
    input wire clk, input wire rst_n,
    input wire in_valid,
    input wire [ADDRW-1:0] in_index,
    input wire signed [RAW_W-1:0] prediction_raw,
    input wire signed [RAW_W-1:0] measurement_raw,
    output reg out_valid,
    output reg [ADDRW-1:0] out_index,
    output reg signed [OUT_W-1:0] out_data,
    output reg out_saturated
);
    localparam integer W=RAW_W+2;
    localparam signed [W-1:0] MAX_R=(2 ** (OUT_W-1))-1;
    localparam signed [W-1:0] MIN_R=-(2 ** (OUT_W-1));
    wire signed [W-1:0] p={{(W-RAW_W){prediction_raw[RAW_W-1]}},prediction_raw};
    wire signed [W-1:0] d={{(W-RAW_W){measurement_raw[RAW_W-1]}},measurement_raw};
    wire signed [W-1:0] difference=p-d;
    wire [W-1:0] magnitude=difference<0 ? -difference : difference;
    wire [W-1:0] half={{(W-1){1'b0}},1'b1} << (SHIFT-1);
    wire [W-1:0] rounded_magnitude=(magnitude+half) >> SHIFT;
    wire signed [W-1:0] rounded=difference<0 ? -$signed(rounded_magnitude) : $signed(rounded_magnitude);
    always @(posedge clk) begin
        if (!rst_n) begin
            out_valid<=0; out_index<=0; out_data<=0; out_saturated<=0;
        end else begin
            out_valid<=in_valid;
            out_saturated<=0;
            if (in_valid) begin
                out_index<=in_index;
                if (rounded>MAX_R) begin
                    out_data<=MAX_R[OUT_W-1:0]; out_saturated<=1;
                end else if (rounded<MIN_R) begin
                    out_data<=MIN_R[OUT_W-1:0]; out_saturated<=1;
                end else out_data<=rounded[OUT_W-1:0];
            end
        end
    end
endmodule
`default_nettype wire
