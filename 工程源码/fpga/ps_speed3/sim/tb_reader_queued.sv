`timescale 1ns/1ps
module tb_reader_queued;
 localparam N=259;localparam [31:0] BASE=32'h32000ff8;
 reg clk=0;always #5 clk=~clk;
 reg rst=0,start=0,ready=0;reg [31:0] base=BASE;
 wire busy,done,error,cv;wire signed [63:0] data;
 wire [31:0] addr;wire [7:0] len;wire [2:0] size,prot;wire [1:0] burst;wire [3:0] cache;
 wire av,rr;reg ar=0,rv=0,last=0;reg [63:0] rd=0;reg [1:0] resp=0;
 fixed_g_axi_reader_queued #(.BEATS(N)) dut(
 .clk(clk),.rst_n(rst),.start(start),.base_addr(base),.busy(busy),.done(done),.error(error),
 .coeff_valid(cv),.coeff_ready(ready),.coeff_data(data),.m_axi_araddr(addr),.m_axi_arlen(len),
 .m_axi_arsize(size),.m_axi_arburst(burst),.m_axi_arcache(cache),.m_axi_arprot(prot),
 .m_axi_arvalid(av),.m_axi_arready(ar),.m_axi_rdata(rd),.m_axi_rresp(resp),.m_axi_rlast(last),.m_axi_rvalid(rv),.m_axi_rready(rr));
 integer cy=0,wp=0,rp=0,count=0,beat=0,out=0,requests=0,returned=0,maxq=0;
 integer qa[0:63],ql[0:63],qt[0:63];
 integer mode=0,run=0;reg [31:0] nextaddr=BASE;
 reg held_ar=0,held_r=0,held_cv=0;reg [39:0] oldar;reg [66:0] oldr;reg [63:0] oldc;
 function [63:0] value_at(input integer index);
  value_at=64'h8123456700000000 ^ (64'h102030405060708*index);
 endfunction
 always @(negedge clk)begin
  ar=rst&&count<32&&(cy%7!=0);
  ready=rst&&(cy%13!=0)&&!(cy%173>=30&&cy%173<=95);
 end
 always @(posedge clk)begin
  cy=cy+1;
  if(!rst)begin
   wp=0;rp=0;count=0;beat=0;out=0;requests=0;returned=0;maxq=0;nextaddr=BASE;
   rv<=0;rd<=0;last<=0;resp<=0;held_ar=0;held_r=0;held_cv=0;
  end else begin
   if(held_ar&&(!av||{addr,len}!==oldar))$fatal(1,"AR changed while blocked");
   if(held_r&&(!rv||{rd,resp,last}!==oldr))$fatal(1,"Memory R changed while blocked");
   if(held_cv&&mode==0&&(!cv||data!==oldc))$fatal(1,"Coefficient changed while blocked");
   held_ar=av&&!ar;oldar={addr,len};held_r=rv&&!rr;oldr={rd,resp,last};held_cv=cv&&!ready;oldc=data;
   if(av&&ar)begin
    if(addr!==nextaddr||len>15||size!=3||burst!=1)$fatal(1,"Bad AR payload");
    if(({1'b0,addr[11:0]}+(len+1)*8)>4096)$fatal(1,"Crossed 4KB");
    qa[wp]=(addr-BASE)/8;ql[wp]=len+1;qt[wp]=cy+37;wp=(wp+1)%64;count=count+1;requests=requests+1;
    nextaddr=addr+(len+1)*8;
    if(count>maxq)maxq=count;
    if(count>8)$fatal(1,"Exceeded configured credit limit");
   end
   if(rv&&rr)begin
    returned=returned+1;
    if(beat==ql[rp]-1)begin rp=(rp+1)%64;count=count-1;beat=0;end
    else beat=beat+1;
   end
   if(!rv||rr)begin
    if(count>0&&cy>=qt[rp]&&cy%11!=0)begin
     rd<=value_at(qa[rp]+beat);last<=beat==ql[rp]-1;rv<=1;
     resp<=(mode==1&&qa[rp]+beat==23)?2:0;
     if(mode==2&&qa[rp]+beat==23)last<=!(beat==ql[rp]-1);
    end else rv<=0;
   end
   if(cv&&ready)begin
    if(data!==value_at(out))$fatal(1,"Lost/reordered coefficient %0d",out);
    out=out+1;
   end
  end
 end
 task reset_case;
  begin @(negedge clk);rst=0;start=0;base=BASE;repeat(4)@(negedge clk);rst=1;end
 endtask
 task launch;
  begin @(negedge clk);start=1;@(negedge clk);start=0;end
 endtask
 initial begin
  for(run=0;run<6;run=run+1)begin
   mode=0;reset_case();launch();wait(done);#1;
   if(error||out!=N||count!=0||returned!=N||maxq<4)$fatal(1,"Normal completion failed out=%0d returned=%0d q=%0d max=%0d",out,returned,count,maxq);
  end
  for(mode=1;mode<=2;mode=mode+1)begin
   reset_case();launch();wait(done);#1;
   if(!error||busy||count!=0||rv||av)$fatal(1,"Fault did not drain accepted traffic");
  end
  mode=0;reset_case();base=BASE+1;launch();wait(done);#1;
  if(!error||requests!=0)$fatal(1,"Unaligned base accepted");
  reset_case();launch();repeat(100)@(negedge clk);reset_case();launch();wait(done);#1;
  if(error||out!=N)$fatal(1,"Reset recovery failed");
  $display("PASS QUEUED_READER: 8 credits, delayed memory, 4KB, tails, output stalls, RRESP/RLAST fault drain, reset");$finish;
 end
 initial begin repeat(100000)@(posedge clk);$fatal(1,"Timeout");end
endmodule
