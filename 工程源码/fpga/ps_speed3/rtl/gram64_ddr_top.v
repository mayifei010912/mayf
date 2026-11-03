// G is signed64 Q32, x is signed32 Q20. Output is signed112 with 52 fraction bits.
`timescale 1ns/1ps
`default_nettype none
module gram64_ddr_top #(
 parameter integer N=1044,AW=$clog2(N),ADDRW=32
)(
 input wire clk,rst_n,x_clear,x_we,input wire [AW-1:0] x_addr,input wire signed [31:0] x_data,
 output wire x_ready,input wire start,input wire [ADDRW-1:0] matrix_base_addr,
 output wire start_ready,busy,done,output reg error,
 output wire y_valid,input wire y_ready,output wire [AW-1:0] y_index,output wire signed [111:0] y_data,
 output wire [ADDRW-1:0] m_axi_araddr,output wire [7:0] m_axi_arlen,
 output wire [2:0] m_axi_arsize,output wire [1:0] m_axi_arburst,
 output wire [3:0] m_axi_arcache,output wire [2:0] m_axi_arprot,
 output wire m_axi_arvalid,input wire m_axi_arready,
 input wire [63:0] m_axi_rdata,input wire [1:0] m_axi_rresp,
 input wire m_axi_rlast,m_axi_rvalid,output wire m_axi_rready
);
 wire cb,cd,ce,cr,ms,rb,rd,re,wvalid,wready,cv,ca;
 wire signed [63:0] coefficient;
 reg [ADDRW-1:0] base;
 assign wready=ca;
 assign start_ready=cr&&!rb&&!error;
 assign busy=cb||rb;assign done=cd||re;assign y_valid=cv&&!error&&!re;
 always @(posedge clk) begin
  if(!rst_n) begin error<=0;base<=0;end
  else begin
   if(start&&start_ready) base<=matrix_base_addr;
   if(ce||re) error<=1;
  end
 end
 fixed_g_matvec_pipe #(.N(N),.AW(AW)) mac(
  .clk(clk),.rst_n(rst_n&&!re),.x_clear(x_clear),.x_we(x_we),.x_addr(x_addr),.x_data(x_data),.x_ready(x_ready),
  .start(start&&start_ready),.start_ready(cr),.busy(cb),.done(cd),.error(ce),.matrix_start(ms),
  .a_valid(wvalid),.a_ready(ca),.a_data(coefficient),
  .y_valid(cv),.y_ready(y_ready&&!error),.y_index(y_index),.y_data(y_data));
 fixed_g_axi_reader_queued #(.BEATS(N*N),.ADDRW(ADDRW)) reader(
  .clk(clk),.rst_n(rst_n),.start(ms),.base_addr(base),.busy(rb),.done(rd),.error(re),
  .coeff_valid(wvalid),.coeff_ready(wready),.coeff_data(coefficient),
  .m_axi_araddr(m_axi_araddr),.m_axi_arlen(m_axi_arlen),.m_axi_arsize(m_axi_arsize),
  .m_axi_arburst(m_axi_arburst),.m_axi_arcache(m_axi_arcache),.m_axi_arprot(m_axi_arprot),
  .m_axi_arvalid(m_axi_arvalid),.m_axi_arready(m_axi_arready),.m_axi_rdata(m_axi_rdata),
  .m_axi_rresp(m_axi_rresp),.m_axi_rlast(m_axi_rlast),.m_axi_rvalid(m_axi_rvalid),.m_axi_rready(m_axi_rready));
endmodule
`default_nettype wire
