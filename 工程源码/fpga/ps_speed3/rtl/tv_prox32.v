// Author's isotropic dual-FISTA TV equations, no positivity. Samples Q20,
// dual arrays Q28. One dual iteration per command; ARM retains the author's
// objective-tolerance stopping rule and supplies the author's momentum beta.
// Order is MATLAB column-major: vertical neighbor +/-1, horizontal +/-H.
`timescale 1ns/1ps
`default_nettype none
module tv_prox32 #(
 parameter integer H=29,W=36,P=1044,AW=$clog2(P),IW=$clog2(H),JW=$clog2(W)
)(
 input wire clk,rst_n,b_we,input wire [AW-1:0] b_addr,input wire signed [31:0] b_data,
 input wire [31:0] theta_q32,input wire [63:0] inv8theta_q32,input wire [31:0] beta_q30,
 input wire start,reset_dual,output reg busy,done,error,saturated,
 input wire [AW-1:0] rd_addr,output wire signed [31:0] rd_data
);
 localparam IDLE=0,INIT=1,SOL=2,PREP=3,NORM=4,WAIT_SQ=5,WAIT_R=6,WAIT_S=7,EXTRAP=8;
 reg [3:0] state;reg [AW-1:0] n;reg [IW-1:0] row;reg [JW-1:0] col;
 reg valid_dual;
 reg [31:0] theta,beta;reg [63:0] invtheta;
 reg signed [31:0] bmem[0:P-1],rmem[0:P-1],smem[0:P-1],pomem[0:P-1],qomem[0:P-1],solmem[0:P-1];
 assign rd_data=solmem[rd_addr];
 wire [AW-1:0] up=(row!=0)?n-1:0,left=(col!=0)?n-H:0;
 wire [AW-1:0] down=(row!=H-1)?n+1:0,right=(col!=W-1)?n+H:0;
 wire signed [33:0] lrs=$signed({{2{rmem[n][31]}},rmem[n]})+$signed({{2{smem[n][31]}},smem[n]})
  -(row!=0?$signed({{2{rmem[up][31]}},rmem[up]}):34'sd0)
  -(col!=0?$signed({{2{smem[left][31]}},smem[left]}):34'sd0);
 function signed [127:0] rounded;
  input signed [127:0] v;input integer shift;reg [127:0] magnitude;
  begin magnitude=v[127]?-$signed(v):v;magnitude=(magnitude+(128'd1<<(shift-1)))>>shift;
   rounded=v[127]?-$signed(magnitude):$signed(magnitude);end
 endfunction
 function signed [31:0] sat32;
  input signed [127:0] v;
  begin if(v>128'sd2147483647)sat32=32'sh7fffffff;
   else if(v< -128'sd2147483648)sat32=32'sh80000000;else sat32=v[31:0];end
 endfunction
 function clipped32;
  input signed [127:0] v;
  begin clipped32=(v>128'sd2147483647 || v< -128'sd2147483648);end
 endfunction
 wire signed [66:0] lprod=$signed({1'b0,theta})*lrs;
 wire signed [127:0] solwide=$signed({{96{bmem[n][31]}},bmem[n]})-rounded($signed({{61{lprod[66]}},lprod}),40);
 wire signed [32:0] dv=(row!=H-1)?$signed({solmem[n][31],solmem[n]})-$signed({solmem[down][31],solmem[down]}):33'sd0;
 wire signed [32:0] dh=(col!=W-1)?$signed({solmem[n][31],solmem[n]})-$signed({solmem[right][31],solmem[right]}):33'sd0;
 wire signed [97:0] ipr=$signed({1'b0,invtheta})*dv,ips=$signed({1'b0,invtheta})*dh;
 wire signed [127:0] trwide=$signed({{96{rmem[n][31]}},rmem[n]})+rounded($signed({{30{ipr[97]}},ipr}),24);
 wire signed [127:0] tswide=$signed({{96{smem[n][31]}},smem[n]})+rounded($signed({{30{ips[97]}},ips}),24);
 reg signed [63:0] tr,ts;
 wire signed [127:0] trsq=tr*tr,tssq=ts*ts;
 wire [63:0] abr=tr[63]?-$signed(tr):tr,abs_s=ts[63]?-$signed(ts):ts;
 reg signed [31:0] pnew,qnew;
 wire signed [32:0] pdiff=$signed({pnew[31],pnew})-$signed({pomem[n][31],pomem[n]});
 wire signed [32:0] qdiff=$signed({qnew[31],qnew})-$signed({qomem[n][31],qomem[n]});
 wire signed [65:0] ep=$signed({1'b0,beta})*pdiff,eq=$signed({1'b0,beta})*qdiff;
 wire signed [127:0] rn=$signed({{96{pnew[31]}},pnew})+rounded($signed({{62{ep[65]}},ep}),30);
 wire signed [127:0] sn=$signed({{96{qnew[31]}},qnew})+rounded($signed({{62{eq[65]}},eq}),30);
 reg sq_start;reg [127:0] sq_value;wire [63:0] sq_root;wire sq_done,sq_busy;
 reg div_start;reg [95:0] div_num;reg [63:0] div_den;wire [31:0] div_quot;wire [63:0] div_rem;wire div_done,div_busy,div0;
 isqrt_seq #(.IN_W(128),.OUT_W(64)) sqrt_unit(.clk(clk),.rst_n(rst_n),.start(sq_start),.value(sq_value),.root(sq_root),.done(sq_done),.busy(sq_busy));
 div_seq #(.NUM_W(96),.DEN_W(64),.QUOT_W(32)) div_unit(.clk(clk),.rst_n(rst_n),.start(div_start),.num(div_num),.den(div_den),.quot(div_quot),.rem(div_rem),.done(div_done),.busy(div_busy),.div0(div0));
 task advance;
  begin if(row==H-1)begin row<=0;col<=col+1'b1;end else row<=row+1'b1;n<=n+1'b1;end
 endtask
 always @(posedge clk) begin
  if(b_we&&!busy&&b_addr<P)bmem[b_addr]<=b_data;
  if(state==INIT)begin rmem[n]<=0;smem[n]<=0;pomem[n]<=0;qomem[n]<=0;end
  if(state==SOL)solmem[n]<=sat32(solwide);
  if(state==EXTRAP)begin rmem[n]<=sat32(rn);smem[n]<=sat32(sn);pomem[n]<=pnew;qomem[n]<=qnew;end
 end
 always @(posedge clk) begin
  if(!rst_n)begin
   state<=IDLE;n<=0;row<=0;col<=0;valid_dual<=0;theta<=0;invtheta<=0;beta<=0;
   busy<=0;done<=0;error<=0;saturated<=0;tr<=0;ts<=0;pnew<=0;qnew<=0;
   sq_start<=0;sq_value<=0;div_start<=0;div_num<=0;div_den<=0;
  end else begin
   done<=0;sq_start<=0;div_start<=0;
   if(b_we&&!busy)valid_dual<=0;
   case(state)
    IDLE:if(start)begin
     error<=0;saturated<=0;
     if(theta_q32<256 || inv8theta_q32==0 || beta_q30>32'h40000000 ||
        (!reset_dual&&(!valid_dual||theta!=theta_q32||invtheta!=inv8theta_q32)))begin error<=1;done<=1;end
     else begin theta<=theta_q32;invtheta<=inv8theta_q32;beta<=beta_q30;
      n<=0;row<=0;col<=0;busy<=1;valid_dual<=1;
      state<=reset_dual?INIT:SOL;end
    end
    INIT:if(n==P-1)begin n<=0;row<=0;col<=0;state<=SOL;end else advance();
    SOL:begin
     if(clipped32(solwide))saturated<=1;
     if(n==P-1)begin n<=0;row<=0;col<=0;state<=PREP;end else advance();
    end
    PREP:begin
     if(trwide>128'sd9223372036854775807 || trwide< -128'sd9223372036854775808 ||
        tswide>128'sd9223372036854775807 || tswide< -128'sd9223372036854775808)begin error<=1;busy<=0;done<=1;state<=IDLE;end
     else begin tr<=trwide[63:0];ts<=tswide[63:0];state<=NORM;end
    end
    NORM:begin sq_value<=trsq+tssq;sq_start<=1;state<=WAIT_SQ;end
    WAIT_SQ:if(sq_done)begin
     if(sq_root<=64'd268435456)begin pnew<=tr[31:0];qnew<=ts[31:0];state<=EXTRAP;end
     else begin div_den<=sq_root;div_num<={4'd0,abr,28'd0};div_start<=1;state<=WAIT_R;end
    end
    WAIT_R:if(div_done)begin
     if(div0)begin error<=1;busy<=0;done<=1;state<=IDLE;end
     else begin pnew<=tr[63]?-$signed(div_quot):$signed(div_quot);
      div_num<={4'd0,abs_s,28'd0};div_start<=1;state<=WAIT_S;end
    end
    WAIT_S:if(div_done)begin
     if(div0)begin error<=1;busy<=0;done<=1;state<=IDLE;end
     else begin qnew<=ts[63]?-$signed(div_quot):$signed(div_quot);state<=EXTRAP;end
    end
    EXTRAP:begin
     if(clipped32(rn)||clipped32(sn))saturated<=1;
     if(n==P-1)begin
      busy<=0;done<=1;state<=IDLE;
     end else begin advance();state<=PREP;end
    end
    default:begin state<=IDLE;error<=1;busy<=0;done<=1;end
   endcase
  end
 end
endmodule
`default_nettype wire
