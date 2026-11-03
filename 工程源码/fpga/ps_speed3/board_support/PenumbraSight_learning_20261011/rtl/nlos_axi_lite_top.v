// Board-independent 32-bit AXI4-Lite register adapter for nlos_host_port_top.
// AW and W may arrive independently. One command is outstanding at a time.
// Register offsets: DATA_LO 00, DATA_HI 04, INDEX 08, COMMAND 0c,
// RESPONSE_LO 10, RESPONSE_HI 14, RESPONSE_ERROR 18.
`timescale 1ns/1ps
`default_nettype none
module nlos_axi_lite_top #(
    parameter integer AXI_ADDR_WIDTH=8,
    parameter integer MATRIX_DISTRIBUTED_WORDS=0
) (
    input wire aclk, aresetn,
    input wire [AXI_ADDR_WIDTH-1:0] s_axi_awaddr,
    input wire s_axi_awvalid,
    output wire s_axi_awready,
    input wire [31:0] s_axi_wdata,
    input wire [3:0] s_axi_wstrb,
    input wire s_axi_wvalid,
    output wire s_axi_wready,
    output reg [1:0] s_axi_bresp,
    output reg s_axi_bvalid,
    input wire s_axi_bready,
    input wire [AXI_ADDR_WIDTH-1:0] s_axi_araddr,
    input wire s_axi_arvalid,
    output wire s_axi_arready,
    output reg [31:0] s_axi_rdata,
    output reg [1:0] s_axi_rresp,
    output reg s_axi_rvalid,
    input wire s_axi_rready
);
    localparam [1:0] OKAY=2'b00, SLVERR=2'b10;
    localparam [1:0] IDLE=0, SEND=1, WAIT_RSP=2;
    reg [1:0] state;
    reg aw_pending, w_pending;
    reg [AXI_ADDR_WIDTH-1:0] aw_address;
    reg [31:0] write_data;
    reg [3:0] write_strobe;
    reg [31:0] data_lo;
    reg [15:0] data_hi;
    reg [16:0] index_reg;
    reg [47:0] last_response;
    reg last_error;
    reg host_req_valid;
    reg [2:0] host_req_op;
    wire host_rsp_valid, host_rsp_error, host_req_ready;
    wire [47:0] host_rsp_data;

    assign s_axi_awready=(state==IDLE && !aw_pending && !s_axi_bvalid);
    assign s_axi_wready=(state==IDLE && !w_pending && !s_axi_bvalid);
    assign s_axi_arready=!s_axi_rvalid;

    nlos_host_port_top #(.MATRIX_SYNC_READ(1),
        .MATRIX_DISTRIBUTED_WORDS(MATRIX_DISTRIBUTED_WORDS)) host (
        .clk(aclk),.rst_n(aresetn),
        .req_valid(host_req_valid),.req_write(host_req_op!=3'd0 && host_req_op!=3'd7),
        .req_op(host_req_op),.req_addr(index_reg),.req_data({data_hi,data_lo}),
        .req_ready(host_req_ready),.rsp_valid(host_rsp_valid),
        .rsp_error(host_rsp_error),.rsp_data(host_rsp_data),
        .core_busy(),.core_done()
    );

    always @(posedge aclk) begin
        if (!aresetn) begin
            state<=IDLE;
            aw_pending<=0; w_pending<=0; aw_address<=0;
            write_data<=0; write_strobe<=0;
            data_lo<=0; data_hi<=0; index_reg<=0;
            last_response<=0; last_error<=0;
            host_req_valid<=0; host_req_op<=0;
            s_axi_bresp<=OKAY; s_axi_bvalid<=0;
            s_axi_rdata<=0; s_axi_rresp<=OKAY; s_axi_rvalid<=0;
        end else begin
            if (s_axi_bvalid && s_axi_bready) s_axi_bvalid<=0;
            if (s_axi_rvalid && s_axi_rready) s_axi_rvalid<=0;
            if (s_axi_arvalid && s_axi_arready) begin
                s_axi_rvalid<=1;
                s_axi_rresp<=OKAY;
                case (s_axi_araddr)
                    8'h00: s_axi_rdata<=data_lo;
                    8'h04: s_axi_rdata<={16'd0,data_hi};
                    8'h08: s_axi_rdata<={15'd0,index_reg};
                    8'h10: s_axi_rdata<=last_response[31:0];
                    8'h14: s_axi_rdata<={16'd0,last_response[47:32]};
                    8'h18: s_axi_rdata<={31'd0,last_error};
                    default: begin s_axi_rdata<=0; s_axi_rresp<=SLVERR; end
                endcase
            end
            case (state)
                IDLE: begin
                    if (s_axi_awvalid && s_axi_awready) begin
                        aw_pending<=1; aw_address<=s_axi_awaddr;
                    end
                    if (s_axi_wvalid && s_axi_wready) begin
                        w_pending<=1; write_data<=s_axi_wdata;
                        write_strobe<=s_axi_wstrb;
                    end
                    if (aw_pending && w_pending) begin
                        aw_pending<=0; w_pending<=0;
                        s_axi_bresp<=OKAY;
                        if (write_strobe!=4'hf) begin
                            s_axi_bresp<=SLVERR; s_axi_bvalid<=1;
                        end else begin
                            case (aw_address)
                                8'h00: begin data_lo<=write_data; s_axi_bvalid<=1; end
                                8'h04: if (write_data[31:16]==0) begin
                                    data_hi<=write_data[15:0]; s_axi_bvalid<=1;
                                end else begin s_axi_bresp<=SLVERR; s_axi_bvalid<=1; end
                                8'h08: if (write_data[31:17]==0) begin
                                    index_reg<=write_data[16:0]; s_axi_bvalid<=1;
                                end else begin s_axi_bresp<=SLVERR; s_axi_bvalid<=1; end
                                8'h0c: if (write_data[31:3]==0) begin
                                    host_req_op<=write_data[2:0];
                                    host_req_valid<=1;
                                    state<=SEND;
                                end else begin s_axi_bresp<=SLVERR; s_axi_bvalid<=1; end
                                default: begin s_axi_bresp<=SLVERR; s_axi_bvalid<=1; end
                            endcase
                        end
                    end
                end
                SEND: begin
                    if (host_req_ready) begin
                        host_req_valid<=0;
                        state<=WAIT_RSP;
                    end
                end
                WAIT_RSP: if (host_rsp_valid) begin
                    last_response<=host_rsp_data;
                    last_error<=host_rsp_error;
                    s_axi_bresp<=host_rsp_error ? SLVERR : OKAY;
                    s_axi_bvalid<=1;
                    state<=IDLE;
                end
                default: state<=IDLE;
            endcase
        end
    end
endmodule
`default_nettype wire
