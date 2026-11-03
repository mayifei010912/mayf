// Eight overlapping ordered-ID AXI4 requests; exact original coefficient order.
// Sixteen-beat / 4-KiB-safe bursts and elastic output. Drain traffic on faults.
`timescale 1ns/1ps
`default_nettype none
module fixed_g_axi_reader_queued #(parameter integer BEATS=1089936,ADDRW=32,OUTSTANDING=8,PW=$clog2(OUTSTANDING))(
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
 reg [31:0] issue_left,sent;
 reg [ADDRW-1:0] address;
 reg [4:0] lengths[0:OUTSTANDING-1];
 reg [PW-1:0] wp,rp;
 reg [PW:0] outstanding;
 reg [4:0] rpos;
 reg [63:0] hold_data;reg hold_valid,fault;
 reg [4:0] burst_beats;
 wire [12:0] boundary_bytes=13'd4096-{1'b0,address[11:0]};
 wire [9:0] boundary_beats=boundary_bytes[12:3];
 always @* begin
  burst_beats=16;
  if(issue_left<16)burst_beats=issue_left[4:0];
  if(boundary_beats<burst_beats)burst_beats=boundary_beats[4:0];
 end
 assign m_axi_arsize=3'd3;assign m_axi_arburst=2'b01;
 assign m_axi_arcache=4'b0011;assign m_axi_arprot=3'b000;
 assign coeff_valid=hold_valid&&busy&&!fault;
 assign coeff_data=$signed(hold_data);
 assign m_axi_rready=busy&&(outstanding!=0)&&(fault||!hold_valid||coeff_ready);
 wire afire=m_axi_arvalid&&m_axi_arready;
 wire rfire=m_axi_rvalid&&m_axi_rready;
 wire expected_last=(rpos+1'b1==lengths[rp]);
 wire retire=rfire&&expected_last;
 wire bad=rfire&&(m_axi_rresp!=0||m_axi_rlast!=expected_last);
 always @(posedge clk)begin
  if(!rst_n)begin
   busy<=0;done<=0;error<=0;issue_left<=0;sent<=0;address<=0;
   wp<=0;rp<=0;outstanding<=0;rpos<=0;
   hold_data<=0;hold_valid<=0;fault<=0;
   m_axi_araddr<=0;m_axi_arlen<=0;m_axi_arvalid<=0;
  end else begin
   done<=0;error<=0;
   if(start&&!busy)begin
    if(base_addr[2:0]!=0)begin error<=1;done<=1;end
    else begin
     busy<=1;issue_left<=BEATS;sent<=0;address<=base_addr;
     wp<=0;rp<=0;outstanding<=0;rpos<=0;fault<=0;hold_valid<=0;m_axi_arvalid<=0;
    end
   end else if(busy)begin
    if(!m_axi_arvalid&&!fault&&issue_left!=0&&outstanding<OUTSTANDING)begin
     m_axi_araddr<=address;m_axi_arlen<=burst_beats-1'b1;m_axi_arvalid<=1;
    end
    if(afire)begin
     m_axi_arvalid<=0;lengths[wp]<=m_axi_arlen+1'b1;
     wp<=(wp==OUTSTANDING-1)?0:wp+1'b1;
     address<=address+((m_axi_arlen+1'b1)<<3);
     issue_left<=issue_left-(m_axi_arlen+1'b1);
    end
    case({afire,retire})
     2'b10:outstanding<=outstanding+1'b1;
     2'b01:outstanding<=outstanding-1'b1;
     default:begin end
    endcase
    if(retire)begin rp<=(rp==OUTSTANDING-1)?0:rp+1'b1;rpos<=0;end
    else if(rfire)rpos<=rpos+1'b1;
    if(coeff_valid&&coeff_ready)begin
     hold_valid<=0;sent<=sent+1'b1;
     if(sent==BEATS-1)begin busy<=0;done<=1;end
    end
    if(rfire&&!fault&&!bad)begin hold_data<=m_axi_rdata;hold_valid<=1;end
    if(bad)begin fault<=1;hold_valid<=0;end
    // Do not withdraw pending ARVALID on fault. Drain requested beat counts.
    if(fault&&outstanding==0&&!m_axi_arvalid)begin
     busy<=0;done<=1;error<=1;hold_valid<=0;
    end
   end
  end
 end
endmodule
`default_nettype wire
