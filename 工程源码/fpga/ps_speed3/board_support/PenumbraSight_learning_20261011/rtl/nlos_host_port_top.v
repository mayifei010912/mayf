// Board-independent command port around the verified compute core.
// This is a synchronous local interface for simulation, not an AXI or camera interface.
// One request is accepted per cycle; its response is registered for the next cycle.
// Each of x, M and d must be written sequentially from address zero before START.
`timescale 1ns/1ps
`default_nettype none
module nlos_host_port_top #(
    parameter integer H=29, W=36, NPIX=1044, NWALL=64,
    parameter integer ADDRW=11, MADDRW=17,
    parameter integer OUTER_CYCLES=2, MATRIX_SYNC_READ=1,
    parameter integer MATRIX_DISTRIBUTED_WORDS=0
) (
    input wire clk, rst_n,
    input wire req_valid, req_write,
    input wire [2:0] req_op,
    input wire [MADDRW-1:0] req_addr,
    input wire [47:0] req_data,
    output wire req_ready,
    output reg rsp_valid, rsp_error,
    output reg [47:0] rsp_data,
    output wire core_busy,
    output wire core_done
);
    localparam [2:0] OP_STATUS=0, OP_CLEAR=1, OP_X=2, OP_M=3,
                     OP_D=4, OP_COEFF=5, OP_START=6, OP_RESULT=7;
    reg [ADDRW:0] x_count, d_count;
    reg [MADDRW:0] m_count;
    reg lam_set, inv_set, completed;
    reg signed [31:0] lam_q16, inv8lam_q16;
    wire loaded=(x_count==NPIX && m_count==NPIX*NWALL &&
                 d_count==NWALL && lam_set && inv_set);
    wire idle=!core_busy && !completed;
    wire x_accept=req_valid && req_write && req_op==OP_X && idle &&
                  x_count<NPIX && req_addr==x_count;
    wire m_accept=req_valid && req_write && req_op==OP_M && idle &&
                  m_count<NPIX*NWALL && req_addr==m_count;
    wire d_accept=req_valid && req_write && req_op==OP_D && idle &&
                  d_count<NWALL && req_addr==d_count;
    wire start_accept=req_valid && req_write && req_op==OP_START &&
                      idle && loaded;
    wire signed [15:0] result_data;
    assign req_ready=1'b1;

    nlos_data_tv_top #(.H(H),.W(W),.NPIX(NPIX),.NWALL(NWALL),
        .ADDRW(ADDRW),.MADDRW(MADDRW),.OUTER_CYCLES(OUTER_CYCLES),
        .MATRIX_SYNC_READ(MATRIX_SYNC_READ),
        .MATRIX_DISTRIBUTED_WORDS(MATRIX_DISTRIBUTED_WORDS)) core (
        .clk(clk),.rst_n(rst_n),
        .x_load_we(x_accept),.x_load_addr(req_addr[ADDRW-1:0]),
        .x_load_data(req_data[15:0]),
        .m_load_we(m_accept),.m_load_addr(req_addr),.m_load_data(req_data[15:0]),
        .d_load_we(d_accept),.d_load_addr(req_addr[ADDRW-1:0]),
        .d_load_data(req_data),
        .lam_q16(lam_q16),.inv8lam_q16(inv8lam_q16),
        .start(start_accept),.busy(core_busy),.done(core_done),
        .data_done(),.tv_start(),.tv_done(),.tv_iters_done(),.outer_index(),
        .data_stage(),.data_iteration(),.data_update_valid(),
        .data_update_index(),.data_update_data(),.data_update_saturated(),
        .data_feedback_valid(),.data_feedback_index(),.data_feedback_data(),
        .tv_input_valid(),.tv_input_index(),.tv_input_data(),
        .tv_copy_valid(),.tv_copy_index(),.tv_copy_data(),.tv_copy_saturated(),
        .tv_read_addr(req_addr[ADDRW-1:0]),.tv_read_data(result_data));

    always @(posedge clk) begin
        if (!rst_n) begin
            x_count<=0; m_count<=0; d_count<=0;
            lam_set<=0; inv_set<=0; completed<=0;
            lam_q16<=0; inv8lam_q16<=0;
            rsp_valid<=0; rsp_error<=0; rsp_data<=0;
        end else begin
            rsp_valid<=req_valid;
            rsp_error<=0;
            rsp_data<=0;
            if (core_done) completed<=1;
            if (req_valid) begin
                case (req_op)
                    OP_STATUS: if (!req_write) begin
                        rsp_data[0]<=core_busy;
                        rsp_data[1]<=completed;
                        rsp_data[2]<=loaded;
                    end else rsp_error<=1;
                    OP_CLEAR: if (req_write && !core_busy) begin
                        x_count<=0; m_count<=0; d_count<=0;
                        lam_set<=0; inv_set<=0; completed<=0;
                        lam_q16<=0; inv8lam_q16<=0;
                    end else rsp_error<=1;
                    OP_X: if (x_accept) x_count<=x_count+1'b1;
                          else rsp_error<=1;
                    OP_M: if (m_accept) m_count<=m_count+1'b1;
                          else rsp_error<=1;
                    OP_D: if (d_accept) d_count<=d_count+1'b1;
                          else rsp_error<=1;
                    OP_COEFF: if (req_write && idle && req_addr<2) begin
                        if (req_addr==0) begin lam_q16<=req_data[31:0]; lam_set<=1; end
                        else begin inv8lam_q16<=req_data[31:0]; inv_set<=1; end
                    end else rsp_error<=1;
                    OP_START: if (!start_accept) rsp_error<=1;
                    OP_RESULT: if (!req_write && completed && !core_busy &&
                                  req_addr<NPIX) begin
                        rsp_data<={{32{result_data[15]}},result_data};
                    end else rsp_error<=1;
                    default: rsp_error<=1;
                endcase
            end
        end
    end
endmodule
`default_nettype wire
