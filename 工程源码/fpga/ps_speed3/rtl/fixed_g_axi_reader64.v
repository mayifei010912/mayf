// Full signed64 Gram coefficient per AXI beat; elastic one-entry output.
// Single outstanding 16-beat INCR bursts, with 4-KiB boundary enforcement.
`timescale 1ns/1ps
`default_nettype none
module fixed_g_axi_reader64 #(parameter integer BEATS=1089936,ADDRW=32)(
 input wire clk,rst_n,start,input wire [ADDRW-1:0] base_addr,
 output reg busy,done,error,output wire coeff_valid,input wire coeff_ready,
 output wire signed [63:0] coeff_data,
 output reg [ADDRW-1:0] m_axi_araddr,output reg [7:0] m_axi_arlen,
 output wire [2:0] m_axi_arsize,output wire [1:0] m_axi_arburst,
 output wire [3:0] m_axi_arcache,output wire [2:0] m_axi_arprot,
 output reg m_axi_arvalid,input wire m_axi_arready,
 input wire [63:0] m_axi_rdata,input wire [1:0] m_axi_rresp,
 input wire m_axi_rlast,m_axi_rvalid,output wire m_axi_rready
);
 localparam IDLE=0,ISSUE=1,ADDRESS=2,RECEIVE=3,DRAIN=4;
 reg [2:0] state;reg [31:0] beats_left,sent;
 reg [4:0] receive_left,burst_beats;
 reg [ADDRW-1:0] address;reg [63:0] hold_data;reg hold_valid;
 wire [12:0] boundary_bytes=13'd4096-{1'b0,address[11:0]};
 wire [9:0] boundary_beats=boundary_bytes[12:3];
 always @* begin
  burst_beats=16;
  if(beats_left<16)burst_beats=beats_left[4:0];
  if(boundary_beats<burst_beats)burst_beats=boundary_beats[4:0];
 end
 assign m_axi_arsize=3'd3;assign m_axi_arburst=2'b01;
 assign m_axi_arcache=4'b0011;assign m_axi_arprot=3'b000;
 assign coeff_valid=hold_valid&&busy;assign coeff_data=$signed(hold_data);
 assign m_axi_rready=(state==RECEIVE)&&(!hold_valid||coeff_ready);
 always @(posedge clk)begin
  if(!rst_n)begin
   state<=IDLE;busy<=0;done<=0;error<=0;beats_left<=0;sent<=0;
   receive_left<=0;address<=0;hold_data<=0;hold_valid<=0;
   m_axi_araddr<=0;m_axi_arlen<=0;m_axi_arvalid<=0;
  end else begin
   done<=0;error<=0;
   if(coeff_valid&&coeff_ready)begin
    hold_valid<=0;sent<=sent+1'b1;
    if(sent==BEATS-1)begin busy<=0;done<=1;state<=IDLE;end
   end
   case(state)
    IDLE:if(start)begin
     if(base_addr[2:0]!=0)begin error<=1;done<=1;end
     else begin address<=base_addr;beats_left<=BEATS;sent<=0;
      hold_valid<=0;busy<=1;state<=ISSUE;end
    end
    ISSUE:begin m_axi_araddr<=address;m_axi_arlen<=burst_beats-1'b1;
     receive_left<=burst_beats;m_axi_arvalid<=1;state<=ADDRESS;end
    ADDRESS:if(m_axi_arready)begin m_axi_arvalid<=0;state<=RECEIVE;end
    RECEIVE:if(m_axi_rvalid&&m_axi_rready)begin
     if(m_axi_rresp!=0||m_axi_rlast!=(receive_left==1))begin
      error<=1;done<=1;busy<=0;hold_valid<=0;state<=IDLE;
     end else begin
      hold_data<=m_axi_rdata;hold_valid<=1;
      receive_left<=receive_left-1'b1;beats_left<=beats_left-1'b1;address<=address+8;
      if(receive_left==1)state<=beats_left==1?DRAIN:ISSUE;
     end
    end
    DRAIN:begin end
    default:begin state<=IDLE;error<=1;busy<=0;end
   endcase
  end
 end
endmodule
`default_nettype wire
