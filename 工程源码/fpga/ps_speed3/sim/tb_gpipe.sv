`timescale 1ns/1ps
module tb_gpipe;
 localparam N=7,AW=$clog2(N);
 reg clk=0;always #5 clk=~clk;
 reg rst=0,xc=0,xw=0,start=0,av=0,yr=0;
 reg [AW-1:0] xa=0;reg signed [31:0] xd=0;reg signed [63:0] ad=0;
 wire xr,sr,busy,done,error,ms,ar,yv;wire [AW-1:0] yi;wire signed [111:0] yd;
 reg signed [31:0] x[0:N-1];reg signed [63:0] g[0:N*N-1];
 reg signed [111:0] expected[0:N-1],prod;integer trial,i,j,k,cycle=0,received=0;
 fixed_g_matvec_pipe #(.N(N),.AW(AW)) dut(clk,rst,xc,xw,xa,xd,xr,start,sr,busy,done,error,ms,av,ar,ad,yv,yr,yi,yd);
 always @(posedge clk)begin
  cycle<=cycle+1;
  if(rst&&yv&&yr)begin
   if(yi!==received||yd!==expected[received])$fatal(1,"Gpipe output trial=%0d row=%0d got=%h expected=%h",trial,received,yd,expected[received]);
   received=received+1;
  end
 end
 always @(negedge clk)yr=(cycle%17>8); // long output stalls, including an in-flight next-row term
 initial begin
  repeat(4)@(negedge clk);rst=1;
  for(trial=0;trial<12;trial=trial+1)begin
   received=0;
   @(negedge clk);xc=1;@(negedge clk);xc=0;
   for(i=0;i<N;i=i+1)begin
    x[i]=$random;xa=i;xd=x[i];xw=1;@(negedge clk);xw=0;
   end
   for(i=0;i<N;i=i+1)begin
    expected[i]=0;
    for(j=0;j<N;j=j+1)begin
     g[i*N+j]={$random,$random};prod=$signed(g[i*N+j])*$signed(x[j]);expected[i]=expected[i]+prod;
    end
   end
   if(!sr)$fatal(1,"not ready after complete load");
   start=1;@(negedge clk);start=0;
   for(k=0;k<N*N;k=k+1)begin
    if((k+trial)%3==0)begin av=0;repeat(2)@(negedge clk);end
    av=1;ad=g[k];do @(posedge clk);while(!ar);@(negedge clk);av=0;
   end
   wait(done);@(negedge clk);
   if(received!=N||error)$fatal(1,"bad final status");
  end
  // Wrong loading order must be rejected; reset restores operation.
  xc=1;@(negedge clk);xc=0;xa=1;xd=7;xw=1;@(negedge clk);xw=0;
  if(!error||sr)$fatal(1,"invalid load order not rejected");
  rst=0;repeat(3)@(negedge clk);rst=1;@(negedge clk);
  if(error||busy||sr)$fatal(1,"reset recovery");
  $display("PASS GPIPE: signed96 products / signed112 sums; 12 randomized matrices; input gaps; output stalls; invalid load; reset");$finish;
 end
 initial begin #1000000;$fatal(1,"GPIPE timeout");end
endmodule
