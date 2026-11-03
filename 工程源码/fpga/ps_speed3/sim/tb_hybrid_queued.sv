`timescale 1ns/1ps
module tb_hybrid_axil;
`ifdef SMALL
 localparam H=3,W=4,N=12;
`else
 localparam H=29,W=36,N=1044;
`endif
 reg clk=0;always #5 clk=~clk;
 reg rst=0;reg [7:0] wa=0,ra=0;reg [31:0] wd=0;reg [3:0] ws=15;
 reg av=0,wv=0,bready=0,arv=0,rrdy=0;
 wire awr,wr,bv,arr,rv;wire [1:0] br,rr;wire [31:0] rd;
 wire [31:0] addr;wire [7:0] len;wire [2:0] size,prot;wire [1:0] burst;wire [3:0] cache;
 wire valid,rready;reg [63:0] rdata=0;reg [1:0] rresp=0;reg rlast=0,rvalid=0;
 integer cycles=0,current=0,remaining=0,scans=0;reg active=0;
 integer gx_begin=0;
 always @(posedge clk)begin
  if(dut.core.gram.ms)gx_begin=cycles;
  if(dut.core.gram.cd)$display("GXTIMING N=%0d cycles=%0d",N,cycles-gx_begin);
 end
 localparam [31:0] BASE=32'h32000ff8;reg [31:0] nextaddr=BASE;
 integer qwr=0,qrd=0,qcount=0,maxq=0;
 integer qaddr[0:31],qlen[0:31],qwhen[0:31];
 wire arready=(qcount<16)&&cycles%7!=0;
 reg [63:0] gmem[0:N*N-1];reg [31:0] xv[0:N-1],tvb[0:N-1],tve[0:4*N-1],cfg[0:6];
 reg [111:0] ge[0:N-1];
 hybrid_fista_board_div2_bd #(.H(H),.W(W)) dut(
 .aclk(clk),.aresetn(rst),.s_axi_awaddr(wa),.s_axi_awprot(3'd0),.s_axi_awvalid(av),.s_axi_awready(awr),
 .s_axi_wdata(wd),.s_axi_wstrb(ws),.s_axi_wvalid(wv),.s_axi_wready(wr),.s_axi_bresp(br),.s_axi_bvalid(bv),.s_axi_bready(bready),
 .s_axi_araddr(ra),.s_axi_arprot(3'd0),.s_axi_arvalid(arv),.s_axi_arready(arr),
 .s_axi_rdata(rd),.s_axi_rresp(rr),.s_axi_rvalid(rv),.s_axi_rready(rrdy),
 .m_axi_araddr(addr),.m_axi_arlen(len),.m_axi_arsize(size),.m_axi_arburst(burst),.m_axi_arcache(cache),.m_axi_arprot(prot),
 .m_axi_arvalid(valid),.m_axi_arready(arready),.m_axi_rdata(rdata),.m_axi_rresp(rresp),.m_axi_rlast(rlast),.m_axi_rvalid(rvalid),.m_axi_rready(rready));
 always @(posedge clk)begin
  cycles<=cycles+1;
  if(rst)begin
   if(valid&&arready)begin
    if(addr!==nextaddr||size!==3||burst!==1||len>15)$fatal(1,"AXI address/length");
    if(({1'b0,addr[11:0]}+(len+1)*8)>4096)$fatal(1,"AXI 4KB boundary");
    qaddr[qwr]=(addr-BASE)/8;qlen[qwr]=len+1;qwhen[qwr]=cycles+37;
    qwr=(qwr+1)%32;qcount=qcount+1;nextaddr<=addr+(len+1)*8;
    if(qcount>maxq)maxq=qcount;
    if(qcount>8)$fatal(1,"Outstanding credit overflow");
   end
   if(rvalid&&rready)begin
    qaddr[qrd]=qaddr[qrd]+1;qlen[qrd]=qlen[qrd]-1;
    if(qlen[qrd]==0)begin qrd=(qrd+1)%32;qcount=qcount-1;end
    if(rlast&&qcount==0&&qaddr[(qrd+31)%32]>=N*N)begin scans=scans+1;nextaddr<=BASE;end
   end
   if(!rvalid||rready)begin
    if(qcount>0&&cycles>=qwhen[qrd]&&cycles%11!=0)begin
     if(qaddr[qrd]>=N*N)$fatal(1,"Read beyond G");
     rdata<=gmem[qaddr[qrd]];rvalid<=1;rlast<=qlen[qrd]==1;
    end else rvalid<=0;
   end
  end
 end
 task write_reg(input [7:0] a,input [31:0] v,input integer mode,input [1:0] expected);
  begin
   @(negedge clk);wa=a;wd=v;bready=0;
   // Alternate AW-before-W and W-before-AW, keeping accepted payloads stable.
   if(mode%2==0)begin
    av=1;do @(posedge clk);while(!awr);@(negedge clk);av=0;
    repeat(2)@(negedge clk);wv=1;do @(posedge clk);while(!wr);@(negedge clk);wv=0;
   end else begin
    wv=1;do @(posedge clk);while(!wr);@(negedge clk);wv=0;
    repeat(2)@(negedge clk);av=1;do @(posedge clk);while(!awr);@(negedge clk);av=0;
   end
   while(!bv)@(negedge clk);
   if(br!==expected)$fatal(1,"Write response a=%h got=%h expected=%h",a,br,expected);
   repeat(2)@(negedge clk);if(!bv||br!==expected)$fatal(1,"B changed under backpressure");
   bready=1;@(negedge clk);bready=0;
  end
 endtask
 reg [31:0] holdrd;reg [1:0] holdrr;
 task read_reg(input [7:0] a,output [31:0] v,input [1:0] expected);
  begin
   @(negedge clk);ra=a;arv=1;rrdy=0;do @(posedge clk);while(!arr);@(negedge clk);arv=0;
   while(!rv)@(negedge clk);holdrd=rd;holdrr=rr;
   if(rr!==expected||(^rd===1'bx))$fatal(1,"Read response or unknown a=%h rd=%h rr=%h",a,rd,rr);
   repeat(2)@(negedge clk);if(!rv||rd!==holdrd||rr!==holdrr)$fatal(1,"R changed under backpressure");
   v=rd;rrdy=1;@(negedge clk);rrdy=0;
  end
 endtask
 integer k,j,z;reg [31:0] v,part;reg [127:0] wide;
 task wait_done;
  begin
   v=0;
   while(!v[2]||v[1])begin repeat(100)@(negedge clk);read_reg(8,v,0);if(v[3]||v[4])$fatal(1,"Kernel error/saturation %h",v);end
  end
 endtask
 initial begin
`ifdef SMALL
  $readmemh("F:/fpga/PenumbraSight_hybrid_FISTA_20261030/data/small_G.mem",gmem);$readmemh("F:/fpga/PenumbraSight_hybrid_FISTA_20261030/data/small_x.mem",xv);$readmemh("F:/fpga/PenumbraSight_hybrid_FISTA_20261030/data/small_gx.mem",ge);
  $readmemh("F:/fpga/PenumbraSight_hybrid_FISTA_20261030/data/small_tv_b.mem",tvb);$readmemh("F:/fpga/PenumbraSight_hybrid_FISTA_20261030/data/small_tv_expected.mem",tve);$readmemh("F:/fpga/PenumbraSight_hybrid_FISTA_20261030/data/small_config.mem",cfg);
`else
  $readmemh("F:/fpga/PenumbraSight_hybrid_FISTA_20261030/data/full_G.mem",gmem);$readmemh("F:/fpga/PenumbraSight_hybrid_FISTA_20261030/data/full_x.mem",xv);$readmemh("F:/fpga/PenumbraSight_hybrid_FISTA_20261030/data/full_gx.mem",ge);
  $readmemh("F:/fpga/PenumbraSight_hybrid_FISTA_20261030/data/full_tv_b.mem",tvb);$readmemh("F:/fpga/PenumbraSight_hybrid_FISTA_20261030/data/full_tv_expected.mem",tve);$readmemh("F:/fpga/PenumbraSight_hybrid_FISTA_20261030/data/full_config.mem",cfg);
`endif
  if((^gmem[N*N-1]===1'bx)||(^ge[N-1]===1'bx)||(^tve[4*N-1]===1'bx))$fatal(1,"Fixtures missing");
  repeat(5)@(negedge clk);rst=1;
  read_reg(0,v,0);if(v!==32'h48594631)$fatal(1,"ID mismatch");
  read_reg(8'h28,v,2); // Cannot read uninitialized result memory.
  write_reg(4,3,0,2); // Cannot run with incomplete vector.
  write_reg(4,7,1,0); // Software reset recovers command error.
  write_reg(4,1,0,0);
  for(k=0;k<N;k=k+1)begin write_reg(12,k,k,0);write_reg(16,xv[k],k+1,0);write_reg(4,2,k,0);end
  write_reg(20,BASE,0,0);write_reg(4,3,1,0);wait_done();
  if(scans!=1)$fatal(1,"Wrong G scans");
  for(k=0;k<N;k=k+1)begin
   write_reg(12,k,k,0);wide=0;
   for(j=0;j<4;j=j+1)begin read_reg(8'h28+4*j,part,0);wide[j*32+:32]=part;end
   if((^wide===1'bx)||wide!=={{16{ge[k][111]}},ge[k]})$fatal(1,"Gx mismatch %0d got=%h expected=%h",k,wide,ge[k]);
  end
  if(maxq<4)$fatal(1,"Did not exercise overlapping reads");
  $display("QUEUE_HIGH_WATER=%0d",maxq);
  $display("[PASS GRAM64 AXIL] N=%0d coefficients=%0d",N,N*N);
  write_reg(4,1,0,0);
  for(k=0;k<N;k=k+1)begin write_reg(12,k,k,0);write_reg(16,tvb[k],k+1,0);write_reg(4,2,k,0);end
  write_reg(24,cfg[0],0,0);write_reg(28,cfg[1],1,0);write_reg(32,cfg[2],0,0);
  for(z=0;z<4;z=z+1)begin
   write_reg(36,cfg[z+3],z,0);write_reg(4,z==0?4:5,z,0);wait_done();
   for(k=0;k<N;k=k+1)begin
    write_reg(12,k,k,0);read_reg(8'h28,part,0);
    if((^part===1'bx)||part!==tve[z*N+k])$fatal(1,"TV mismatch it=%0d pixel=%0d got=%h expected=%h",z,k,part,tve[z*N+k]);
   end
  end
  $display("[PASS TV32 RESUME AXIL] H=%0d W=%0d iterations=4",H,W);
  // Loading a different b invalidates TV dual state; resume must fail closed.
  write_reg(4,1,0,0);
  for(k=0;k<N;k=k+1)begin write_reg(12,k,k,0);write_reg(16,tvb[k],k+1,0);write_reg(4,2,k,0);end
  write_reg(4,5,0,0);repeat(20)@(negedge clk);read_reg(8,v,0);if(!v[3])$fatal(1,"Bad TV resume was accepted");
  write_reg(4,7,0,0);read_reg(8,v,0);if(v[3])$fatal(1,"Soft reset did not clear error");
  $display("[PASS HYBRID AXIL] N=%0d cycles=%0d: full-width Gx, four exact TV rounds, AW/W order, stalls, invalid commands",N,cycles);$finish;
 end
 initial begin repeat(40000000)@(posedge clk);$fatal(1,"Timeout");end
endmodule

