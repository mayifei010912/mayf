// Complete-matrix MAC engine. Coefficients are supplied row-major from DDR.
// No constant 64-row projection, no source clipping or positivity constraint.
`timescale 1ns/1ps
`default_nettype none
module fixed_a_matvec #(
    parameter integer ROWS=16384, COLS=1044,
    parameter integer MW=32, XW=32, ACCW=80,
    parameter integer VW=$clog2((ROWS>COLS)?ROWS:COLS),
    parameter integer CW=$clog2(COLS)
) (
    input wire clk, rst_n,
    input wire x_clear, x_we,
    input wire [VW-1:0] x_addr,
    input wire signed [XW-1:0] x_data,
    output wire x_ready,
    input wire start, transpose,
    output wire start_ready,
    output reg busy, done, error, matrix_start,
    input wire a_valid,
    output wire a_ready,
    input wire signed [MW-1:0] a_data,
    output reg y_valid,
    input wire y_ready,
    output reg [VW-1:0] y_index,
    output reg signed [ACCW-1:0] y_data
);
    localparam IDLE=0, CLEAR_ACC=1, ACCEPT=2, MAC=3, OUTPUT=4;
    localparam integer PW=MW+XW;
    reg [2:0] state;
    reg mode;
    reg [VW:0] loaded;
    reg load_bad;
    reg [VW-1:0] row;
    reg [CW-1:0] col, clear_index;
    (* ram_style="block" *) reg signed [XW-1:0] xmem [0:((ROWS>COLS)?ROWS:COLS)-1];
    (* ram_style="block" *) reg signed [ACCW-1:0] sums [0:COLS-1];
    reg signed [XW-1:0] xr;
    reg signed [MW-1:0] ar;
    reg signed [ACCW-1:0] sr, scalar_acc;
    wire signed [PW-1:0] product=ar*xr;
    wire signed [ACCW-1:0] extended={{(ACCW-PW){product[PW-1]}},product};
    wire signed [ACCW-1:0] next_sum=(mode ? sr : scalar_acc)+extended;
    assign x_ready=(state==IDLE && !load_bad);
    assign start_ready=(state==IDLE && !load_bad && loaded==(transpose ? ROWS : COLS));
    assign a_ready=(state==ACCEPT);

    // Synchronous block-RAM reads, one coefficient MAC per two clocks.
    always @(posedge clk) begin
        if(x_we && x_ready && x_addr==loaded && loaded<((ROWS>COLS)?ROWS:COLS))
            xmem[x_addr]<=x_data;
        if(state==ACCEPT && a_valid) begin
            xr<=xmem[mode ? row : col];
            sr<=sums[col];
        end
        if(state==CLEAR_ACC) sums[clear_index]<=0;
        else if(state==MAC && mode) sums[col]<=next_sum;
    end

    always @(posedge clk) begin
        if(!rst_n) begin
            state<=IDLE; mode<=0; loaded<=0;load_bad<=0;
            busy<=0;done<=0;error<=0;matrix_start<=0;
            row<=0;col<=0;clear_index<=0;ar<=0;scalar_acc<=0;
            y_valid<=0;y_index<=0;y_data<=0;
        end else begin
            done<=0;matrix_start<=0;
            if(x_clear && state==IDLE) begin loaded<=0;load_bad<=0;error<=0; end
            else if(x_we && state==IDLE) begin
                if(x_ready && x_addr==loaded && loaded<((ROWS>COLS)?ROWS:COLS)) loaded<=loaded+1'b1;
                else begin load_bad<=1;error<=1; end
            end
            case(state)
                IDLE: if(start) begin
                    if(start_ready && !x_we && !x_clear) begin
                        mode<=transpose;busy<=1;error<=0;row<=0;col<=0;
                        scalar_acc<=0;clear_index<=0;
                        if(transpose) state<=CLEAR_ACC;
                        else begin state<=ACCEPT;matrix_start<=1; end
                    end else error<=1;
                end
                CLEAR_ACC: begin
                    if(clear_index==COLS-1) begin state<=ACCEPT;matrix_start<=1; end
                    else clear_index<=clear_index+1'b1;
                end
                ACCEPT: if(a_valid) begin ar<=a_data;state<=MAC;end
                MAC: begin
                    if((!mode && col==COLS-1) || (mode && row==ROWS-1)) begin
                        y_data<=next_sum;y_index<=mode ? col : row;y_valid<=1;state<=OUTPUT;
                    end else begin
                        if(!mode) scalar_acc<=next_sum;
                        if(col==COLS-1) begin col<=0;row<=row+1'b1; end
                        else col<=col+1'b1;
                        state<=ACCEPT;
                    end
                end
                OUTPUT: if(y_ready) begin
                    y_valid<=0;
                    if(row==ROWS-1 && col==COLS-1) begin busy<=0;done<=1;state<=IDLE;end
                    else begin
                        if(col==COLS-1) begin col<=0;row<=row+1'b1;scalar_acc<=0;end
                        else col<=col+1'b1;
                        state<=ACCEPT;
                    end
                end
                default: begin state<=IDLE;busy<=0;error<=1;end
            endcase
        end
    end
endmodule
`default_nettype wire
