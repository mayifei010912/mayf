// Board-only interface metadata. Vivado clock wizard actual output is
// 50,023,974 Hz for this preserved PS clock. Core arithmetic has no fixed Hz.
`timescale 1ns/1ps
`default_nettype none
module hybrid_fista_board_bd #(parameter integer H=29,W=36)(
 (* X_INTERFACE_INFO="xilinx.com:signal:clock:1.0 aclk CLK" *)
 (* X_INTERFACE_PARAMETER="XIL_INTERFACENAME aclk, ASSOCIATED_BUSIF s_axi:m_axi, ASSOCIATED_RESET aresetn, FREQ_HZ 50023974" *)
 input wire aclk,
 (* X_INTERFACE_INFO="xilinx.com:signal:reset:1.0 aresetn RST" *)
 (* X_INTERFACE_PARAMETER="XIL_INTERFACENAME aresetn, POLARITY ACTIVE_LOW" *)
 input wire aresetn,
 input wire [7:0] s_axi_awaddr,input wire [2:0] s_axi_awprot,input wire s_axi_awvalid,output wire s_axi_awready,
 input wire [31:0] s_axi_wdata,input wire [3:0] s_axi_wstrb,input wire s_axi_wvalid,output wire s_axi_wready,
 output wire [1:0] s_axi_bresp,output wire s_axi_bvalid,input wire s_axi_bready,
 input wire [7:0] s_axi_araddr,input wire [2:0] s_axi_arprot,input wire s_axi_arvalid,output wire s_axi_arready,
 output wire [31:0] s_axi_rdata,output wire [1:0] s_axi_rresp,output wire s_axi_rvalid,input wire s_axi_rready,
 output wire [31:0] m_axi_araddr,output wire [7:0] m_axi_arlen,output wire [2:0] m_axi_arsize,
 output wire [1:0] m_axi_arburst,output wire [3:0] m_axi_arcache,output wire [2:0] m_axi_arprot,
 output wire m_axi_arvalid,input wire m_axi_arready,input wire [63:0] m_axi_rdata,
 input wire [1:0] m_axi_rresp,input wire m_axi_rlast,m_axi_rvalid,output wire m_axi_rready
);
 hybrid_fista_accel #(.H(H),.W(W)) core(
 .aclk(aclk),
 .aresetn(aresetn),
 .s_axi_awaddr(s_axi_awaddr),
 .s_axi_awprot(s_axi_awprot),
 .s_axi_awvalid(s_axi_awvalid),
 .s_axi_awready(s_axi_awready),
 .s_axi_wdata(s_axi_wdata),
 .s_axi_wstrb(s_axi_wstrb),
 .s_axi_wvalid(s_axi_wvalid),
 .s_axi_wready(s_axi_wready),
 .s_axi_bresp(s_axi_bresp),
 .s_axi_bvalid(s_axi_bvalid),
 .s_axi_bready(s_axi_bready),
 .s_axi_araddr(s_axi_araddr),
 .s_axi_arprot(s_axi_arprot),
 .s_axi_arvalid(s_axi_arvalid),
 .s_axi_arready(s_axi_arready),
 .s_axi_rdata(s_axi_rdata),
 .s_axi_rresp(s_axi_rresp),
 .s_axi_rvalid(s_axi_rvalid),
 .s_axi_rready(s_axi_rready),
 .m_axi_araddr(m_axi_araddr),
 .m_axi_arlen(m_axi_arlen),
 .m_axi_arsize(m_axi_arsize),
 .m_axi_arburst(m_axi_arburst),
 .m_axi_arcache(m_axi_arcache),
 .m_axi_arprot(m_axi_arprot),
 .m_axi_arvalid(m_axi_arvalid),
 .m_axi_arready(m_axi_arready),
 .m_axi_rdata(m_axi_rdata),
 .m_axi_rresp(m_axi_rresp),
 .m_axi_rlast(m_axi_rlast),
 .m_axi_rvalid(m_axi_rvalid),
 .m_axi_rready(m_axi_rready)
 );
endmodule
`default_nettype wire
