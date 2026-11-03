//=============================================================================
// isqrt_seq.v -- sequential restoring integer square root
//
//   root = floor(sqrt(value))     for 0 <= value < 2**IN_W
//
// Used by tv_prox.v for the isotropic TV projection (|(r,s)|) and for the
// scalar FISTA momentum recurrence.  One bit of the root is produced per
// clock; IN_W/2 cycles plus one.
//
// This is the classic "shift in two bits, compare against 4*res+1" restoring
// algorithm and it is exact for the full input range.
//=============================================================================
`timescale 1ns/1ps
`default_nettype none

module isqrt_seq #(
    parameter integer IN_W  = 32,
    parameter integer OUT_W = 16          // must equal IN_W/2
) (
    input  wire              clk,
    input  wire              rst_n,
    input  wire              start,
    input  wire [IN_W-1:0]   value,
    output reg  [OUT_W-1:0]  root,
    output reg               done,
    output reg               busy
);

    localparam integer NIT = IN_W / 2;

    reg [IN_W+1:0]   ra;      // running remainder
    reg [OUT_W-1:0]  rq;      // running root
    reg [NIT-1:0]    i;       // current bit position (NIT-1 .. 0)

    // shift the next two input bits into the remainder
    wire [IN_W+1:0] ra_shift = (ra << 2) | {{(IN_W+1-2){1'b0}}, value[2*i +: 2]};
    wire [OUT_W+1:0] trial   = {rq, 2'b01};              // 4*rq + 1
    wire             ge      = (ra_shift >= {{(IN_W+1-OUT_W-1){1'b0}}, trial});

    wire [IN_W+1:0]  ra_next  = ge ? (ra_shift - {{(IN_W+1-OUT_W-1){1'b0}}, trial})
                                   : ra_shift;
    wire [OUT_W-1:0] rq_next  = ge ? {rq[OUT_W-2:0], 1'b1} : {rq[OUT_W-2:0], 1'b0};
    wire             last_it  = (i == {NIT{1'b0}});

    always @(posedge clk) begin
        if (!rst_n) begin
            ra   <= {(IN_W+2){1'b0}};
            rq   <= {OUT_W{1'b0}};
            i    <= {NIT{1'b0}};
            root <= {OUT_W{1'b0}};
            done <= 1'b0;
            busy <= 1'b0;
        end else begin
            done <= 1'b0;
            if (start && !busy) begin
                ra   <= {(IN_W+2){1'b0}};
                rq   <= {OUT_W{1'b0}};
                i    <= NIT - 1;
                busy <= 1'b1;
            end else if (busy) begin
                ra <= ra_next;
                rq <= rq_next;
                if (last_it) begin
                    root <= rq_next;
                    busy <= 1'b0;
                    done <= 1'b1;
                end else begin
                    i <= i - 1'b1;
                end
            end
        end
    end

endmodule

`default_nettype wire
