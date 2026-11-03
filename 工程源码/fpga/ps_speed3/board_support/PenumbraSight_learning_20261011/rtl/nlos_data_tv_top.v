// Learning integration: two data-gradient rounds feed the 29x36 TV unit
// directly in RTL. Optionally feed TV back for another outer cycle.
// The host loads only M, x0 and d before each color.
// Data-top pixels are MATLAB column-major Q0.15; TV consumes image rows
// in row-major order and Q3.12. No intermediate pixel file is read here.
`timescale 1ns/1ps
`default_nettype none
module nlos_data_tv_top #(
    parameter integer H=29,
    parameter integer W=36,
    parameter integer NPIX=1044,
    parameter integer NWALL=64,
    parameter integer ADDRW=11,
    parameter integer MADDRW=17,
    parameter integer OUTER_CYCLES=1,
    parameter integer MATRIX_SYNC_READ=0,
    parameter integer MATRIX_DISTRIBUTED_WORDS=0
) (
    input wire clk, rst_n,
    input wire x_load_we,
    input wire [ADDRW-1:0] x_load_addr,
    input wire signed [15:0] x_load_data,
    input wire m_load_we,
    input wire [MADDRW-1:0] m_load_addr,
    input wire signed [15:0] m_load_data,
    input wire d_load_we,
    input wire [ADDRW-1:0] d_load_addr,
    input wire signed [47:0] d_load_data,
    input wire signed [31:0] lam_q16,
    input wire signed [31:0] inv8lam_q16,
    input wire start,
    output reg busy,
    output reg done,
    output wire data_done,
    output wire tv_start,
    output wire tv_done,
    output wire [7:0] tv_iters_done,
    output reg [7:0] outer_index,
    output wire [3:0] data_stage,
    output wire [15:0] data_iteration,
    output wire data_update_valid,
    output wire [ADDRW-1:0] data_update_index,
    output wire signed [15:0] data_update_data,
    output wire data_update_saturated,
    output wire data_feedback_valid,
    output wire [ADDRW-1:0] data_feedback_index,
    output wire signed [47:0] data_feedback_data,
    output wire tv_input_valid,
    output wire [ADDRW-1:0] tv_input_index,
    output wire signed [15:0] tv_input_data,
    output wire tv_copy_valid,
    output wire [ADDRW-1:0] tv_copy_index,
    output wire signed [15:0] tv_copy_data,
    output wire tv_copy_saturated,
    input wire [ADDRW-1:0] tv_read_addr,
    output wire signed [15:0] tv_read_data
);
    localparam [2:0] IDLE=0, RUN_DATA=1, START_TV=2, RUN_TV=3,
                     COPY_TV=4, RESTART_DATA=5;
    reg [2:0] state;
    reg [5:0] tv_row, tv_col;
    reg [5:0] copy_row, copy_col;
    reg [ADDRW-1:0] copy_index;
    wire data_busy, tv_busy;
    wire [ADDRW-1:0] tv_internal_read_addr=copy_row*W+copy_col;
    wire signed [18:0] copy_wide={{3{tv_read_data[15]}},tv_read_data} <<< 3;

    // MATLAB round(x/8): halfway cases round away from zero. A 17-bit
    // temporary handles -32768 safely before taking the absolute value.
    function signed [15:0] q15_to_q12;
        input signed [15:0] value;
        reg signed [16:0] wide;
        reg signed [16:0] magnitude;
        begin
            wide={{1{value[15]}},value};
            magnitude=(wide<0) ? -wide : wide;
            q15_to_q12=(wide<0) ? -((magnitude+17'sd4)>>>3) :
                                    ((magnitude+17'sd4)>>>3);
        end
    endfunction

    assign tv_input_valid=data_update_valid && data_iteration==16'd1;
    assign tv_input_index=tv_row*W+tv_col;
    assign tv_input_data=q15_to_q12(data_update_data);
    assign tv_start=(state==START_TV);
    assign tv_copy_valid=(state==COPY_TV);
    assign tv_copy_index=copy_index;
    assign tv_copy_saturated=(copy_wide>19'sd32767 || copy_wide< -19'sd32768);
    assign tv_copy_data=(copy_wide>19'sd32767) ? 16'sd32767 :
                        (copy_wide< -19'sd32768) ? -16'sd32768 : copy_wide[15:0];

    nlos_one_iteration_top #(.NPIX(NPIX),.NWALL(NWALL),.ADDRW(ADDRW),
        .MADDRW(MADDRW),.ITERATIONS(2),.RESIDUAL_SHIFT(16),.UPDATE_SHIFT(18),
        .MATRIX_SYNC_READ(MATRIX_SYNC_READ),
        .MATRIX_DISTRIBUTED_WORDS(MATRIX_DISTRIBUTED_WORDS)) data_path (
        .clk(clk),.rst_n(rst_n),
        .x_load_we((x_load_we && state==IDLE) || tv_copy_valid),
        .x_load_addr(tv_copy_valid ? tv_copy_index : x_load_addr),
        .x_load_data(tv_copy_valid ? tv_copy_data : x_load_data),
        .m_load_we(m_load_we && state==IDLE),.m_load_addr(m_load_addr),.m_load_data(m_load_data),
        .d_load_we(d_load_we && state==IDLE),.d_load_addr(d_load_addr),.d_load_data(d_load_data),
        .start((start && state==IDLE) || state==RESTART_DATA),
        .busy(data_busy),.done(data_done),
        .stage(data_stage),.iteration_index(data_iteration),
        .prediction_valid(),.prediction_index(),.prediction_data(),
        .residual_valid(),.residual_index(),.residual_data(),.residual_saturated(),
        .gradient_valid(),.gradient_index(),.gradient_data(),
        .update_valid(data_update_valid),.update_index(data_update_index),
        .update_data(data_update_data),.update_saturated(data_update_saturated),
        .feedback_valid(data_feedback_valid),.feedback_index(data_feedback_index),
        .feedback_data(data_feedback_data));

    tv_prox #(.H(H),.W(W),.P(NPIX),.AW(ADDRW),.IW(5),.JW(6)) tv (
        .clk(clk),.rst_n(rst_n),
        .b_we(tv_input_valid),.b_addr(tv_input_index),.b_data(tv_input_data),
        .lam_q16(lam_q16),.inv8lam_q16(inv8lam_q16),
        .iters(8'd4),.nonneg(1'b0),
        .start(tv_start),.busy(tv_busy),.done(tv_done),.iters_done(tv_iters_done),
        .rd_addr(tv_copy_valid ? tv_internal_read_addr : tv_read_addr),
        .rd_data(tv_read_data));

    always @(posedge clk) begin
        if (!rst_n) begin
            state<=IDLE; busy<=0; done<=0; tv_row<=0; tv_col<=0;
            copy_row<=0; copy_col<=0; copy_index<=0; outer_index<=0;
        end else begin
            done<=0;
            if (start && state==IDLE) begin tv_row<=0; tv_col<=0; end
            else if (tv_input_valid) begin
                if (tv_row==H-1) begin
                    tv_row<=0;
                    tv_col<=tv_col+1'b1;
                end else tv_row<=tv_row+1'b1;
            end
            if (tv_copy_valid) begin
                copy_index<=copy_index+1'b1;
                if (copy_row==H-1) begin
                    copy_row<=0;
                    copy_col<=copy_col+1'b1;
                end else copy_row<=copy_row+1'b1;
            end
            case (state)
                IDLE: if (start) begin busy<=1; outer_index<=0; state<=RUN_DATA; end
                RUN_DATA: if (data_done) state<=START_TV;
                START_TV: state<=RUN_TV;
                RUN_TV: if (tv_done) begin
                    if (outer_index<OUTER_CYCLES-1) begin
                        copy_row<=0; copy_col<=0; copy_index<=0;
                        state<=COPY_TV;
                    end else begin busy<=0; done<=1; state<=IDLE; end
                end
                COPY_TV: if (copy_index==NPIX-1) state<=RESTART_DATA;
                RESTART_DATA: begin
                    outer_index<=outer_index+1'b1;
                    tv_row<=0; tv_col<=0;
                    state<=RUN_DATA;
                end
                default: begin busy<=0; state<=IDLE; end
            endcase
        end
    end
endmodule
`default_nettype wire
