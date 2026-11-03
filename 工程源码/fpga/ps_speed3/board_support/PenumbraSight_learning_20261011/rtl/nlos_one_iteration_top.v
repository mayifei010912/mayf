// Small integrated learning design: signed data-gradient iterations and
// feedback prediction. ITERATIONS defaults to one for earlier tests. Host
// loads M_q, x_q and d_raw once; intermediate values stay inside RTL.
`timescale 1ns/1ps
`default_nettype none
module nlos_one_iteration_top #(
    parameter integer NPIX=1044,
    parameter integer NWALL=8,
    parameter integer ADDRW=11,
    parameter integer MADDRW=14,
    parameter integer ITERATIONS=1,
    parameter integer RESIDUAL_SHIFT=14,
    parameter integer UPDATE_SHIFT=22,
    parameter integer MATRIX_SYNC_READ=0,
    parameter integer MATRIX_DISTRIBUTED_WORDS=0
) (
    input wire clk, input wire rst_n,
    input wire x_load_we,
    input wire [ADDRW-1:0] x_load_addr,
    input wire signed [15:0] x_load_data,
    input wire m_load_we,
    input wire [MADDRW-1:0] m_load_addr,
    input wire signed [15:0] m_load_data,
    input wire d_load_we,
    input wire [ADDRW-1:0] d_load_addr,
    input wire signed [47:0] d_load_data,
    input wire start,
    output reg busy, output reg done,
    output wire [3:0] stage,
    output wire [15:0] iteration_index,
    output wire prediction_valid,
    output wire [ADDRW-1:0] prediction_index,
    output wire signed [47:0] prediction_data,
    output wire residual_valid,
    output wire [ADDRW-1:0] residual_index,
    output wire signed [15:0] residual_data,
    output wire residual_saturated,
    output wire gradient_valid,
    output wire [ADDRW-1:0] gradient_index,
    output wire signed [47:0] gradient_data,
    output wire update_valid,
    output wire [ADDRW-1:0] update_index,
    output wire signed [15:0] update_data,
    output wire update_saturated,
    output wire feedback_valid,
    output wire [ADDRW-1:0] feedback_index,
    output wire signed [47:0] feedback_data
);
    localparam [3:0] IDLE=0, F_LOAD=1, F_START=2, F_STREAM=3,
        F_WAIT=4, R_WAIT=5, A_START=6, A_STREAM=7, U_WAIT=8;
    reg [3:0] state;
    reg feedback_mode;
    reg [15:0] iteration_count;
    reg [ADDRW-1:0] load_index, adj_row, adj_col;
    reg [MADDRW-1:0] forward_ptr;
    reg signed [15:0] scene_mem [0:NPIX-1];
    reg signed [15:0] matrix_mem [0:NPIX*NWALL-1];
    reg signed [47:0] measurement_mem [0:NWALL-1];

    wire f_valid, f_busy, f_done;
    wire [ADDRW-1:0] f_index;
    wire signed [47:0] f_data;
    wire a_busy, a_done;
    wire [MADDRW-1:0] transpose_addr=adj_col*NPIX+adj_row;
    wire forward_matrix_valid, adjoint_matrix_valid;
    wire signed [15:0] forward_matrix_data, adjoint_matrix_data;
    generate if (MATRIX_DISTRIBUTED_WORDS > 0) begin : matrix_hybrid_read
        // Board profile: preserve all 16-bit coefficients and the one-cycle
        // read latency, but trade some LUT RAM for scarce board BRAM.
        localparam integer BLOCK_WORDS=NPIX*NWALL-MATRIX_DISTRIBUTED_WORDS;
        (* ram_style="distributed" *) reg signed [15:0] distributed_mem [0:MATRIX_DISTRIBUTED_WORDS-1];
        (* ram_style="block" *) reg signed [15:0] block_mem [0:BLOCK_WORDS-1];
        wire [MADDRW-1:0] read_addr=(state==A_STREAM) ? transpose_addr : forward_ptr;
        // Upload and computation never overlap: share the distributed RAM
        // address to infer a single-port RAM rather than duplicate LUT storage.
        wire distributed_write=!busy && m_load_we && m_load_addr<MATRIX_DISTRIBUTED_WORDS;
        wire [MADDRW-1:0] distributed_addr=distributed_write ? m_load_addr : read_addr;
        reg signed [15:0] distributed_data, block_data;
        reg distributed_select_q, forward_valid_q, adjoint_valid_q;
        initial begin
            if (MATRIX_SYNC_READ == 0 || MATRIX_DISTRIBUTED_WORDS >= NPIX*NWALL)
                $fatal(1,"Hybrid matrix storage requires synchronous reads and two nonempty banks");
        end
        always @(posedge clk) begin
            if (!busy && m_load_we) begin
                if (m_load_addr < MATRIX_DISTRIBUTED_WORDS)
                    distributed_mem[distributed_addr]<=m_load_data;
                else block_mem[m_load_addr-MATRIX_DISTRIBUTED_WORDS]<=m_load_data;
            end
            if (read_addr < MATRIX_DISTRIBUTED_WORDS)
                distributed_data<=distributed_mem[distributed_addr];
            else block_data<=block_mem[read_addr-MATRIX_DISTRIBUTED_WORDS];
            distributed_select_q<=(read_addr < MATRIX_DISTRIBUTED_WORDS);
            if (!rst_n) begin
                forward_valid_q<=0; adjoint_valid_q<=0;
            end else begin
                forward_valid_q<=(state==F_STREAM);
                adjoint_valid_q<=(state==A_STREAM);
            end
        end
        assign forward_matrix_valid=forward_valid_q;
        assign adjoint_matrix_valid=adjoint_valid_q;
        assign forward_matrix_data=distributed_select_q ? distributed_data : block_data;
        assign adjoint_matrix_data=forward_matrix_data;
    end else if (MATRIX_SYNC_READ != 0) begin : matrix_sync_read
        // One shared, registered read port allows the large matrix to be
        // inferred as block RAM. Valid follows the read by one clock. The
        // forward and adjoint streams never overlap in this controller.
        wire [MADDRW-1:0] read_addr=(state==A_STREAM) ? transpose_addr : forward_ptr;
        reg signed [15:0] read_data;
        reg forward_valid_q, adjoint_valid_q;
        always @(posedge clk) begin
            read_data<=matrix_mem[read_addr];
            if (!rst_n) begin
                forward_valid_q<=0;
                adjoint_valid_q<=0;
            end else begin
                forward_valid_q<=(state==F_STREAM);
                adjoint_valid_q<=(state==A_STREAM);
            end
        end
        assign forward_matrix_valid=forward_valid_q;
        assign adjoint_matrix_valid=adjoint_valid_q;
        assign forward_matrix_data=read_data;
        assign adjoint_matrix_data=read_data;
    end else begin : matrix_async_read
        assign forward_matrix_valid=(state==F_STREAM);
        assign adjoint_matrix_valid=(state==A_STREAM);
        assign forward_matrix_data=matrix_mem[forward_ptr];
        assign adjoint_matrix_data=matrix_mem[transpose_addr];
    end endgenerate
    assign stage=state;
    assign iteration_index=iteration_count;
    assign prediction_valid=f_valid && !feedback_mode;
    assign prediction_index=f_index;
    assign prediction_data=f_data;
    assign feedback_valid=f_valid && feedback_mode;
    assign feedback_index=f_index;
    assign feedback_data=f_data;

    // Host writes only while idle. The update stream writes the same scene
    // memory and is later reloaded into the forward engine, without files.
    always @(posedge clk) begin
        if (!busy && x_load_we) scene_mem[x_load_addr]<=x_load_data;
        else if (update_valid) scene_mem[update_index]<=update_data;
        if (MATRIX_DISTRIBUTED_WORDS==0 && !busy && m_load_we) matrix_mem[m_load_addr]<=m_load_data;
        if (!busy && d_load_we) measurement_mem[d_load_addr]<=d_load_data;
    end

    matvec_seq #(.ROWS(NWALL),.N(NPIX),.MW(16),.XW(16),.ACC_W(48),.ADDRW(ADDRW)) forward (
        .clk(clk),.rst_n(rst_n),.x_we(state==F_LOAD),.x_addr(load_index),
        .x_data(scene_mem[load_index]),.start(state==F_START),
        .busy(f_busy),.done(f_done),.m_valid(forward_matrix_valid),
        .m_data(forward_matrix_data),.y_valid(f_valid),.y_index(f_index),.y_data(f_data));

    residual_quantize_seq #(.RAW_W(48),.OUT_W(16),.ADDRW(ADDRW),.SHIFT(RESIDUAL_SHIFT)) residual (
        .clk(clk),.rst_n(rst_n),.in_valid(prediction_valid),.in_index(f_index),
        .prediction_raw(f_data),.measurement_raw(measurement_mem[f_index]),
        .out_valid(residual_valid),.out_index(residual_index),.out_data(residual_data),
        .out_saturated(residual_saturated));

    matvec_seq #(.ROWS(NPIX),.N(NWALL),.MW(16),.XW(16),.ACC_W(48),.ADDRW(ADDRW)) adjoint (
        .clk(clk),.rst_n(rst_n),.x_we(residual_valid),.x_addr(residual_index),
        .x_data(residual_data),.start(state==A_START),.busy(a_busy),.done(a_done),
        .m_valid(adjoint_matrix_valid),.m_data(adjoint_matrix_data),
        .y_valid(gradient_valid),.y_index(gradient_index),.y_data(gradient_data));

    gradient_step_seq #(.XW(16),.GW(48),.ADDRW(ADDRW),.SHIFT(UPDATE_SHIFT)) update_pixel (
        .clk(clk),.rst_n(rst_n),.in_valid(gradient_valid),.in_index(gradient_index),
        .x_data(scene_mem[gradient_index]),.gradient_raw(gradient_data),
        .out_valid(update_valid),.out_index(update_index),.out_data(update_data),
        .out_saturated(update_saturated));

    always @(posedge clk) begin
        if (!rst_n) begin
            state<=IDLE; busy<=0; done<=0; feedback_mode<=0; iteration_count<=0;
            load_index<=0; forward_ptr<=0; adj_row<=0; adj_col<=0;
        end else begin
            done<=0;
            case (state)
                IDLE: if (start) begin
                    busy<=1; feedback_mode<=0; iteration_count<=0; load_index<=0;
                    forward_ptr<=0; adj_row<=0; adj_col<=0; state<=F_LOAD;
                end
                F_LOAD: if (load_index==NPIX-1) state<=F_START;
                    else load_index<=load_index+1'b1;
                F_START: begin forward_ptr<=0; state<=F_STREAM; end
                F_STREAM: if (forward_ptr==NPIX*NWALL-1) state<=F_WAIT;
                    else forward_ptr<=forward_ptr+1'b1;
                F_WAIT: if (f_done) begin
                    if (feedback_mode) begin
                        if (iteration_count < ITERATIONS-1) begin
                            iteration_count<=iteration_count+1'b1;
                            feedback_mode<=0; load_index<=0; forward_ptr<=0;
                            state<=F_LOAD;
                        end else begin busy<=0; done<=1; state<=IDLE; end
                    end
                    else state<=R_WAIT;
                end
                R_WAIT: if (residual_valid && residual_index==NWALL-1) state<=A_START;
                A_START: begin adj_row<=0; adj_col<=0; state<=A_STREAM; end
                A_STREAM: if (adj_col==NWALL-1) begin
                    adj_col<=0;
                    if (adj_row==NPIX-1) state<=U_WAIT;
                    else adj_row<=adj_row+1'b1;
                end else adj_col<=adj_col+1'b1;
                U_WAIT: if (update_valid && update_index==NPIX-1) begin
                    feedback_mode<=1; load_index<=0; forward_ptr<=0; state<=F_LOAD;
                end
                default: begin state<=IDLE; busy<=0; end
            endcase
        end
    end
endmodule
`default_nettype wire
