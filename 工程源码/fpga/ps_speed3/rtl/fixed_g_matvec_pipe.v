// Signed64 Q32 x signed32 Q20 -> signed112 Q52. One accepted term per clock.
// Same row-major integer sum as fixed_a_matvec, specialized for non-transposed Gx.
`timescale 1ns/1ps
`default_nettype none
module fixed_g_matvec_pipe #(parameter integer N=1044,AW=$clog2(N))(
 input wire clk,rst_n,x_clear,x_we,input wire [AW-1:0] x_addr,
 input wire signed [31:0] x_data,output wire x_ready,
 input wire start,output wire start_ready,output reg busy,done,error,matrix_start,
 input wire a_valid,output wire a_ready,input wire signed [63:0] a_data,
 output reg y_valid,input wire y_ready,output reg [AW-1:0] y_index,
 output reg signed [111:0] y_data
);
 (* ram_style="block" *) reg signed [31:0] xmem[0:N-1];
 reg [AW:0] loaded;reg load_bad,input_done;
 reg [AW-1:0] row,col,pipe_row,pipe_col;
 reg pipe_valid;reg signed [31:0] xr;reg signed [63:0] ar;
 reg signed [111:0] acc;
 wire signed [95:0] product=ar*xr;
 wire signed [111:0] extended={{16{product[95]}},product};
 wire signed [111:0] next_sum=(pipe_col==0 ? 112'sd0:acc)+extended;
 wire advance=!y_valid||y_ready;
 wire fire=a_valid&&a_ready;
 assign x_ready=!busy&&!load_bad;
 assign start_ready=!busy&&!load_bad&&loaded==N;
 assign a_ready=busy&&!input_done&&advance;
 // Synchronous BRAM read and matching coefficient are the pipeline's first stage.
 always @(posedge clk)begin
  if(x_we&&x_ready&&x_addr==loaded&&loaded<N)xmem[x_addr]<=x_data;
  if(fire)begin xr<=xmem[col];ar<=a_data;end
 end
 always @(posedge clk)begin
  if(!rst_n)begin
   loaded<=0;load_bad<=0;input_done<=0;row<=0;col<=0;pipe_row<=0;pipe_col<=0;
   pipe_valid<=0;acc<=0;busy<=0;done<=0;error<=0;matrix_start<=0;
   y_valid<=0;y_index<=0;y_data<=0;
  end else begin
   done<=0;matrix_start<=0;
   if(!busy)begin
    if(x_clear)begin loaded<=0;load_bad<=0;error<=0;end
    else if(x_we)begin
     if(x_ready&&x_addr==loaded&&loaded<N)loaded<=loaded+1'b1;
     else begin load_bad<=1;error<=1;end
    end
   end
   if(start)begin
    if(start_ready&&!x_we&&!x_clear)begin
     busy<=1;error<=0;row<=0;col<=0;input_done<=0;pipe_valid<=0;acc<=0;
     y_valid<=0;matrix_start<=1;
    end else error<=1;
   end
   if(busy&&advance)begin
    if(y_valid&&y_ready)begin
     y_valid<=0;
     if(y_index==N-1)begin busy<=0;done<=1;end
    end
    pipe_valid<=fire;
    if(fire)begin
     pipe_row<=row;pipe_col<=col;
     if(col==N-1)begin
      col<=0;
      if(row==N-1)input_done<=1;
      else row<=row+1'b1;
     end else col<=col+1'b1;
    end
    if(pipe_valid)begin
     acc<=next_sum;
     if(pipe_col==N-1)begin y_valid<=1;y_index<=pipe_row;y_data<=next_sum;end
    end
   end
  end
 end
endmodule
`default_nettype wire
