//=============================================================================
// div_seq.v -- sequential unsigned restoring divider
//
//   quot = num / den   (truncated toward zero),  rem = num % den
//
// One quotient bit per clock (NUM_W cycles).  Used by tv_prox.v for
//   * p = (r << 12) / |(r,s)|        (unit-ball projection)
//   * coef = ((t-1) << 16) / t       (scalar FISTA momentum)
// and by any host logic that needs the localization margin.
//
// Division by zero is flagged, not trapped: quot saturates and div0 is raised.
//=============================================================================
`timescale 1ns/1ps
`default_nettype none

module div_seq #(
    parameter integer NUM_W  = 48,
    parameter integer DEN_W  = 32,
    parameter integer QUOT_W = 32
) (
    input  wire                clk,
    input  wire                rst_n,
    input  wire                start,
    input  wire [NUM_W-1:0]    num,
    input  wire [DEN_W-1:0]    den,
    output reg  [QUOT_W-1:0]   quot,
    output reg  [DEN_W-1:0]    rem,
    output reg                 done,
    output reg                 busy,
    output reg                 div0
);

    localparam integer RW = DEN_W + 1;

    reg [NUM_W-1:0]   num_r;
    reg [DEN_W-1:0]   den_r;
    reg [NUM_W-1:0]   qacc;
    reg [RW-1:0]      racc;
    reg [15:0]        k;

    wire [RW-1:0] racc_shift = {racc[DEN_W-1:0], num_r[k]};
    wire          ge         = (racc_shift >= {1'b0, den_r});
    wire [RW-1:0] racc_next  = ge ? (racc_shift - {1'b0, den_r}) : racc_shift;
    wire [NUM_W-1:0] q_next  = {qacc[NUM_W-2:0], ge};
    wire          last_it    = (k == 16'd0);

    always @(posedge clk) begin
        if (!rst_n) begin
            num_r <= {NUM_W{1'b0}};
            den_r <= {DEN_W{1'b0}};
            qacc  <= {NUM_W{1'b0}};
            racc  <= {RW{1'b0}};
            k     <= 16'd0;
            quot  <= {QUOT_W{1'b0}};
            rem   <= {DEN_W{1'b0}};
            done  <= 1'b0;
            busy  <= 1'b0;
            div0  <= 1'b0;
        end else begin
            done <= 1'b0;
            if (start && !busy) begin
                num_r <= num;
                den_r <= den;
                qacc  <= {NUM_W{1'b0}};
                racc  <= {RW{1'b0}};
                k     <= NUM_W[15:0] - 16'd1;
                busy  <= 1'b1;
                div0  <= (den == {DEN_W{1'b0}});
            end else if (busy) begin
                racc <= racc_next;
                qacc <= q_next;
                if (last_it) begin
                    // saturate into QUOT_W
                    if (|q_next[NUM_W-1:QUOT_W])
                        quot <= {QUOT_W{1'b1}};
                    else
                        quot <= q_next[QUOT_W-1:0];
                    rem  <= racc_next[DEN_W-1:0];
                    busy <= 1'b0;
                    done <= 1'b1;
                end else begin
                    k <= k - 16'd1;
                end
            end
        end
    end

endmodule

`default_nettype wire
