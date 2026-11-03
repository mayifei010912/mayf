// ARM-scheduled Gram/TV accelerator. No FISTA algorithm is hidden in this slave.
// AXI Lite accepts AW and W independently, one outstanding write/read each.
// Config/data writes require all byte strobes; invalid commands return SLVERR.
`timescale 1ns/1ps
`default_nettype none
module hybrid_fista_accel #(
 parameter integer H=29,W=36,N=H*W,AW=$clog2(N)
)(
 (* X_INTERFACE_INFO="xilinx.com:signal:clock:1.0 aclk CLK" *)
 (* X_INTERFACE_PARAMETER="XIL_INTERFACENAME aclk, ASSOCIATED_BUSIF s_axi:m_axi, ASSOCIATED_RESET aresetn" *)
 input wire aclk,
 (* X_INTERFACE_INFO="xilinx.com:signal:reset:1.0 aresetn RST" *)
 (* X_INTERFACE_PARAMETER="XIL_INTERFACENAME aresetn, POLARITY ACTIVE_LOW" *)
 input wire aresetn,
 input wire [7:0] s_axi_awaddr,input wire [2:0] s_axi_awprot,input wire s_axi_awvalid,output wire s_axi_awready,
 input wire [31:0] s_axi_wdata,input wire [3:0] s_axi_wstrb,input wire s_axi_wvalid,output wire s_axi_wready,
 output reg [1:0] s_axi_bresp,output reg s_axi_bvalid,input wire s_axi_bready,
 input wire [7:0] s_axi_araddr,input wire [2:0] s_axi_arprot,input wire s_axi_arvalid,output wire s_axi_arready,
 output reg [31:0] s_axi_rdata,output reg [1:0] s_axi_rresp,output reg s_axi_rvalid,input wire s_axi_rready,
 output wire [31:0] m_axi_araddr,output wire [7:0] m_axi_arlen,output wire [2:0] m_axi_arsize,
 output wire [1:0] m_axi_arburst,output wire [3:0] m_axi_arcache,output wire [2:0] m_axi_arprot,
 output wire m_axi_arvalid,input wire m_axi_arready,input wire [63:0] m_axi_rdata,
 input wire [1:0] m_axi_rresp,input wire m_axi_rlast,m_axi_rvalid,output wire m_axi_rready
);
 reg awheld,wheld;reg [7:0] wa;reg [31:0] wd;reg [3:0] ws;
 reg [31:0] index_reg,input_reg,base_reg,theta_reg,inv_lo,inv_hi,beta_reg;
 reg [AW:0] loaded;reg running,done_sticky,command_error,result_tv;
 reg clear_pulse,load_pulse,gstart,tstart,treset,softreset;
 reg [AW-1:0] load_addr;reg signed [31:0] load_value;
 reg [63:0] cycles;reg [111:0] result_mem[0:N-1];
 wire grdy,gxready,gbusy,gdone,gerr,gyvalid;
 wire [AW-1:0] gyindex;wire signed [111:0] gydata;
 wire tbusy,tdone,terr,tsat;wire signed [31:0] tvdata;
 wire core_reset=aresetn&&!softreset;
 wire all_error=command_error||gerr||terr;
 wire [111:0] selected=result_tv?{{80{tvdata[31]}},tvdata}:result_mem[index_reg[AW-1:0]];
 wire [31:0] status={24'd0,grdy,(loaded==N),result_tv,tsat,all_error,done_sticky,running,1'b0};
 assign s_axi_awready=!awheld&&!s_axi_bvalid;
 assign s_axi_wready=!wheld&&!s_axi_bvalid;
 assign s_axi_arready=!s_axi_rvalid;
 gram64_ddr_top #(.N(N),.AW(AW)) gram(
  .clk(aclk),.rst_n(core_reset),.x_clear(clear_pulse),.x_we(load_pulse),.x_addr(load_addr),.x_data(load_value),.x_ready(gxready),
  .start(gstart),.matrix_base_addr(base_reg),.start_ready(grdy),.busy(gbusy),.done(gdone),.error(gerr),
  .y_valid(gyvalid),.y_ready(1'b1),.y_index(gyindex),.y_data(gydata),
  .m_axi_araddr(m_axi_araddr),.m_axi_arlen(m_axi_arlen),.m_axi_arsize(m_axi_arsize),.m_axi_arburst(m_axi_arburst),
  .m_axi_arcache(m_axi_arcache),.m_axi_arprot(m_axi_arprot),.m_axi_arvalid(m_axi_arvalid),.m_axi_arready(m_axi_arready),
  .m_axi_rdata(m_axi_rdata),.m_axi_rresp(m_axi_rresp),.m_axi_rlast(m_axi_rlast),.m_axi_rvalid(m_axi_rvalid),.m_axi_rready(m_axi_rready));
 tv_prox32 #(.H(H),.W(W),.P(N),.AW(AW)) tv(
  .clk(aclk),.rst_n(core_reset),.b_we(load_pulse),.b_addr(load_addr),.b_data(load_value),
  .theta_q32(theta_reg),.inv8theta_q32({inv_hi,inv_lo}),.beta_q30(beta_reg),
  .start(tstart),.reset_dual(treset),.busy(tbusy),.done(tdone),.error(terr),.saturated(tsat),
  .rd_addr(index_reg[AW-1:0]),.rd_data(tvdata));
 always @(posedge aclk)if(gyvalid)result_mem[gyindex]<=gydata;
 always @(posedge aclk)begin
  if(!aresetn)begin
   awheld<=0;wheld<=0;wa<=0;wd<=0;ws<=0;s_axi_bvalid<=0;s_axi_bresp<=0;
   s_axi_rvalid<=0;s_axi_rresp<=0;s_axi_rdata<=0;
   index_reg<=0;input_reg<=0;base_reg<=0;theta_reg<=0;inv_lo<=0;inv_hi<=0;beta_reg<=0;
   loaded<=0;running<=0;done_sticky<=0;command_error<=0;result_tv<=0;cycles<=0;
   clear_pulse<=0;load_pulse<=0;gstart<=0;tstart<=0;treset<=0;softreset<=0;load_addr<=0;load_value<=0;
  end else begin
   clear_pulse<=0;load_pulse<=0;gstart<=0;tstart<=0;softreset<=0;
   if(running)cycles<=cycles+1'b1;
   if(gdone||tdone)begin running<=0;done_sticky<=1;end
   if(s_axi_bvalid&&s_axi_bready)s_axi_bvalid<=0;
   if(s_axi_rvalid&&s_axi_rready)s_axi_rvalid<=0;
   if(s_axi_awvalid&&s_axi_awready)begin awheld<=1;wa<=s_axi_awaddr;end
   if(s_axi_wvalid&&s_axi_wready)begin wheld<=1;wd<=s_axi_wdata;ws<=s_axi_wstrb;end
   if(awheld&&wheld&&!s_axi_bvalid)begin
    awheld<=0;wheld<=0;s_axi_bvalid<=1;s_axi_bresp<=0;
    if(ws!=4'b1111 || wa[1:0]!=0)begin s_axi_bresp<=2;command_error<=1;end
    else case(wa)
     8'h04:begin
      if(running||load_pulse||clear_pulse||softreset)begin s_axi_bresp<=2;command_error<=1;end
      else case(wd)
       1:begin clear_pulse<=1;loaded<=0;done_sticky<=0;command_error<=0;end
       2:if(loaded<N&&index_reg==loaded&&gxready)begin
        load_pulse<=1;load_addr<=index_reg[AW-1:0];load_value<=input_reg;loaded<=loaded+1'b1;done_sticky<=0;
       end else begin s_axi_bresp<=2;command_error<=1;end
       3:if(grdy&&loaded==N&&!all_error)begin gstart<=1;running<=1;done_sticky<=0;result_tv<=0;cycles<=0;end
        else begin s_axi_bresp<=2;command_error<=1;end
       4,5:if(loaded==N&&!all_error)begin
        tstart<=1;treset<=(wd==4);running<=1;done_sticky<=0;result_tv<=1;cycles<=0;
       end else begin s_axi_bresp<=2;command_error<=1;end
       7:begin softreset<=1;loaded<=0;done_sticky<=0;command_error<=0;result_tv<=0;end
       default:begin s_axi_bresp<=2;command_error<=1;end
      endcase
     end
     8'h0c:if(wd<N)index_reg<=wd;else begin s_axi_bresp<=2;command_error<=1;end
     8'h10:if(!running)input_reg<=wd;else begin s_axi_bresp<=2;command_error<=1;end
     8'h14,8'h18,8'h1c,8'h20,8'h24:begin
      if(running)begin s_axi_bresp<=2;command_error<=1;end
      else case(wa)
       8'h14:base_reg<=wd;8'h18:theta_reg<=wd;8'h1c:inv_lo<=wd;8'h20:inv_hi<=wd;8'h24:beta_reg<=wd;
      endcase
     end
     default:begin s_axi_bresp<=2;command_error<=1;end
    endcase
   end
   if(s_axi_arvalid&&s_axi_arready)begin
    s_axi_rvalid<=1;s_axi_rresp<=0;s_axi_rdata<=0;
    if(s_axi_araddr[1:0]!=0)s_axi_rresp<=2;
    else case(s_axi_araddr)
     8'h00:s_axi_rdata<=32'h48594631; // "HYF1"
     8'h08:s_axi_rdata<=status;
     8'h0c:s_axi_rdata<=index_reg;8'h10:s_axi_rdata<=input_reg;8'h14:s_axi_rdata<=base_reg;
     8'h18:s_axi_rdata<=theta_reg;8'h1c:s_axi_rdata<=inv_lo;8'h20:s_axi_rdata<=inv_hi;8'h24:s_axi_rdata<=beta_reg;
     8'h28,8'h2c,8'h30,8'h34:begin
      if(!done_sticky||running||all_error)s_axi_rresp<=2;
      else case(s_axi_araddr)
       8'h28:s_axi_rdata<=selected[31:0];8'h2c:s_axi_rdata<=selected[63:32];
       8'h30:s_axi_rdata<=selected[95:64];8'h34:s_axi_rdata<={{16{selected[111]}},selected[111:96]};
      endcase
     end
     8'h38:s_axi_rdata<=loaded;8'h3c:s_axi_rdata<=N;
     8'h40:s_axi_rdata<=cycles[31:0];8'h44:s_axi_rdata<=cycles[63:32];
     default:s_axi_rresp<=2;
    endcase
   end
  end
 end
endmodule
`default_nettype wire
