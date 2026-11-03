// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.2 (win64) Build 3064766 Wed Nov 18 09:12:45 MST 2020
// Date        : Sat Oct 17 21:55:57 2026
// Host        : mayifei running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               f:/fpga/PenumbraSight_board_vendor_gmii_20261017/source_full/system/ip/system_DVI_Transmitter_Safe_0_0/system_DVI_Transmitter_Safe_0_0_sim_netlist.v
// Design      : system_DVI_Transmitter_Safe_0_0
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xczu4ev-sfvc784-2-i
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "system_DVI_Transmitter_Safe_0_0,dvi_transmitter_top,{}" *) (* DowngradeIPIdentifiedWarnings = "yes" *) (* IP_DEFINITION_SOURCE = "package_project" *) 
(* X_CORE_INFO = "dvi_transmitter_top,Vivado 2020.2" *) 
(* NotValidForBitStream *)
module system_DVI_Transmitter_Safe_0_0
   (pclk,
    pixel_clk_5x,
    pixel_clk_2_5x,
    reset_n,
    video_din,
    video_hsync,
    video_vsync,
    video_de,
    tmds_clk_p,
    tmds_clk_n,
    tmds_data_p,
    tmds_data_n,
    tmds_oen);
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 pclk CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME pclk, FREQ_TOLERANCE_HZ 0, PHASE 0.000, CLK_DOMAIN system_hdmi_shared_0_pixel_clock, INSERT_VIP 0" *) input pclk;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 pclk_x5 CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME pclk_x5, FREQ_HZ 370829625, FREQ_TOLERANCE_HZ 0, PHASE 0.000, CLK_DOMAIN system_hdmi_shared_0_fast_clock, INSERT_VIP 0" *) input pixel_clk_5x;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 pclk_x2_5 CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME pclk_x2_5, FREQ_TOLERANCE_HZ 0, PHASE 0.000, CLK_DOMAIN system_hdmi_shared_0_slow_clock, INSERT_VIP 0" *) input pixel_clk_2_5x;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 reset_n RST" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME reset_n, POLARITY ACTIVE_LOW, INSERT_VIP 0" *) input reset_n;
  (* X_INTERFACE_INFO = "xilinx.com:interface:vid_io:1.0 Video_In DATA" *) input [23:0]video_din;
  (* X_INTERFACE_INFO = "xilinx.com:interface:vid_io:1.0 Video_In HSYNC" *) input video_hsync;
  (* X_INTERFACE_INFO = "xilinx.com:interface:vid_io:1.0 Video_In VSYNC" *) input video_vsync;
  (* X_INTERFACE_INFO = "xilinx.com:interface:vid_io:1.0 Video_In ACTIVE_VIDEO" *) input video_de;
  (* X_INTERFACE_INFO = "openedv.com:user:TMDS:1.0 TMDS tmds_clk_p" *) output tmds_clk_p;
  (* X_INTERFACE_INFO = "openedv.com:user:TMDS:1.0 TMDS tmds_clk_n" *) output tmds_clk_n;
  (* X_INTERFACE_INFO = "openedv.com:user:TMDS:1.0 TMDS tmds_data_p" *) output [2:0]tmds_data_p;
  (* X_INTERFACE_INFO = "openedv.com:user:TMDS:1.0 TMDS tmds_data_n" *) output [2:0]tmds_data_n;
  output tmds_oen;

  wire \<const1> ;
  wire pclk;
  wire pixel_clk_2_5x;
  wire pixel_clk_5x;
  wire reset_n;
  (* SLEW = "SLOW" *) wire tmds_clk_n;
  (* SLEW = "SLOW" *) wire tmds_clk_p;
  (* SLEW = "SLOW" *) wire [2:0]tmds_data_n;
  (* SLEW = "SLOW" *) wire [2:0]tmds_data_p;
  wire video_de;
  wire [23:0]video_din;
  wire video_hsync;
  wire video_vsync;

  assign tmds_oen = \<const1> ;
  VCC VCC
       (.P(\<const1> ));
  system_DVI_Transmitter_Safe_0_0_dvi_transmitter_top inst
       (.pclk(pclk),
        .pixel_clk_2_5x(pixel_clk_2_5x),
        .pixel_clk_5x(pixel_clk_5x),
        .reset_n(reset_n),
        .tmds_clk_n(tmds_clk_n),
        .tmds_clk_p(tmds_clk_p),
        .tmds_data_n(tmds_data_n),
        .tmds_data_p(tmds_data_p),
        .video_de(video_de),
        .video_din(video_din),
        .video_hsync(video_hsync),
        .video_vsync(video_vsync));
endmodule

(* ORIG_REF_NAME = "asyn_rst_syn" *) 
module system_DVI_Transmitter_Safe_0_0_asyn_rst_syn
   (reset,
    SR,
    reset_2_reg_0,
    reset_2_reg_1,
    reset_2_reg_2,
    WE0,
    pclk,
    \tx_data_reg[0] ,
    \tx_data_reg[0]_0 ,
    \tx_data_reg[0]_1 ,
    \tx_data_reg[0]_2 ,
    reset_n);
  output reset;
  output [0:0]SR;
  output [0:0]reset_2_reg_0;
  output [0:0]reset_2_reg_1;
  output [0:0]reset_2_reg_2;
  output WE0;
  input pclk;
  input \tx_data_reg[0] ;
  input \tx_data_reg[0]_0 ;
  input \tx_data_reg[0]_1 ;
  input \tx_data_reg[0]_2 ;
  input reset_n;

  wire [0:0]SR;
  wire WE0;
  wire pclk;
  wire reset;
  wire reset_1;
  wire reset_1_i_1_n_0;
  wire [0:0]reset_2_reg_0;
  wire [0:0]reset_2_reg_1;
  wire [0:0]reset_2_reg_2;
  wire reset_n;
  wire \tx_data_reg[0] ;
  wire \tx_data_reg[0]_0 ;
  wire \tx_data_reg[0]_1 ;
  wire \tx_data_reg[0]_2 ;

  LUT1 #(
    .INIT(2'h1)) 
    \bit[0].mem_i_1 
       (.I0(reset),
        .O(WE0));
  LUT1 #(
    .INIT(2'h1)) 
    reset_1_i_1
       (.I0(reset_n),
        .O(reset_1_i_1_n_0));
  FDPE reset_1_reg
       (.C(pclk),
        .CE(1'b1),
        .D(1'b0),
        .PRE(reset_1_i_1_n_0),
        .Q(reset_1));
  FDPE reset_2_reg
       (.C(pclk),
        .CE(1'b1),
        .D(reset_1),
        .PRE(reset_1_i_1_n_0),
        .Q(reset));
  (* SOFT_HLUTNM = "soft_lutpair83" *) 
  LUT2 #(
    .INIT(4'hB)) 
    \tx_data[3]_i_1 
       (.I0(reset),
        .I1(\tx_data_reg[0] ),
        .O(SR));
  (* SOFT_HLUTNM = "soft_lutpair83" *) 
  LUT2 #(
    .INIT(4'hB)) 
    \tx_data[3]_i_1__0 
       (.I0(reset),
        .I1(\tx_data_reg[0]_0 ),
        .O(reset_2_reg_0));
  (* SOFT_HLUTNM = "soft_lutpair84" *) 
  LUT2 #(
    .INIT(4'hB)) 
    \tx_data[3]_i_1__1 
       (.I0(reset),
        .I1(\tx_data_reg[0]_1 ),
        .O(reset_2_reg_1));
  (* SOFT_HLUTNM = "soft_lutpair84" *) 
  LUT2 #(
    .INIT(4'hB)) 
    \tx_data[3]_i_1__2 
       (.I0(reset),
        .I1(\tx_data_reg[0]_2 ),
        .O(reset_2_reg_2));
endmodule

(* ORIG_REF_NAME = "dvi_encoder" *) 
module system_DVI_Transmitter_Safe_0_0_dvi_encoder
   (de_reg,
    Q,
    pclk,
    video_de,
    video_hsync,
    video_vsync,
    video_din,
    reset);
  output de_reg;
  output [9:0]Q;
  input pclk;
  input video_de;
  input video_hsync;
  input video_vsync;
  input [7:0]video_din;
  input reset;

  wire [9:0]Q;
  wire c0_q;
  wire c0_reg;
  wire c1_q;
  wire c1_reg;
  wire [4:1]cnt;
  wire \cnt[1]_i_1_n_0 ;
  wire \cnt[1]_i_2_n_0 ;
  wire \cnt[1]_i_3_n_0 ;
  wire \cnt[2]_i_1_n_0 ;
  wire \cnt[2]_i_2_n_0 ;
  wire \cnt[2]_i_3_n_0 ;
  wire \cnt[2]_i_4_n_0 ;
  wire \cnt[3]_i_1_n_0 ;
  wire \cnt[3]_i_2_n_0 ;
  wire \cnt[3]_i_3_n_0 ;
  wire \cnt[3]_i_4_n_0 ;
  wire \cnt[3]_i_5_n_0 ;
  wire \cnt[3]_i_6_n_0 ;
  wire \cnt[3]_i_7_n_0 ;
  wire \cnt[4]_i_10__1_n_0 ;
  wire \cnt[4]_i_11_n_0 ;
  wire \cnt[4]_i_12_n_0 ;
  wire \cnt[4]_i_13_n_0 ;
  wire \cnt[4]_i_14_n_0 ;
  wire \cnt[4]_i_15_n_0 ;
  wire \cnt[4]_i_16_n_0 ;
  wire \cnt[4]_i_17__1_n_0 ;
  wire \cnt[4]_i_18_n_0 ;
  wire \cnt[4]_i_19_n_0 ;
  wire \cnt[4]_i_1_n_0 ;
  wire \cnt[4]_i_20_n_0 ;
  wire \cnt[4]_i_21_n_0 ;
  wire \cnt[4]_i_22_n_0 ;
  wire \cnt[4]_i_23_n_0 ;
  wire \cnt[4]_i_24_n_0 ;
  wire \cnt[4]_i_25_n_0 ;
  wire \cnt[4]_i_2_n_0 ;
  wire \cnt[4]_i_3_n_0 ;
  wire \cnt[4]_i_4_n_0 ;
  wire \cnt[4]_i_5_n_0 ;
  wire \cnt[4]_i_6_n_0 ;
  wire \cnt[4]_i_7_n_0 ;
  wire \cnt[4]_i_8_n_0 ;
  wire \cnt[4]_i_9_n_0 ;
  wire de_q;
  wire de_reg;
  wire \din_q_reg_n_0_[0] ;
  wire [9:0]dout;
  wire [3:1]n0q_m;
  wire [3:1]n0q_m0;
  wire [3:0]n1d;
  wire [3:0]n1d0;
  wire \n1d[0]_i_2_n_0 ;
  wire \n1d[1]_i_2_n_0 ;
  wire \n1d[2]_i_2_n_0 ;
  wire \n1d[3]_i_2_n_0 ;
  wire \n1d[3]_i_3_n_0 ;
  wire \n1d[3]_i_4_n_0 ;
  wire [3:1]n1q_m;
  wire [3:1]n1q_m0;
  wire \n1q_m[2]_i_1_n_0 ;
  wire \n1q_m[3]_i_2_n_0 ;
  wire \n1q_m[3]_i_3_n_0 ;
  wire \n1q_m[3]_i_4_n_0 ;
  wire \n1q_m[3]_i_5_n_0 ;
  wire \n1q_m[3]_i_6_n_0 ;
  wire \n1q_m[3]_i_7_n_0 ;
  wire p_0_in;
  wire p_0_in0_in;
  wire p_0_in1_in;
  wire p_0_in2_in;
  wire p_0_in3_in;
  wire p_0_in4_in;
  wire p_0_in5_in;
  wire pclk;
  wire q_m_1;
  wire q_m_2;
  wire q_m_3;
  wire q_m_4;
  wire q_m_6;
  wire q_m_7;
  wire [8:0]q_m_reg;
  wire \q_m_reg[5]_i_1_n_0 ;
  wire \q_m_reg[7]_i_2_n_0 ;
  wire \q_m_reg[7]_i_3_n_0 ;
  wire \q_m_reg[8]_i_1_n_0 ;
  wire reset;
  wire video_de;
  wire [7:0]video_din;
  wire video_hsync;
  wire video_vsync;

  FDRE c0_q_reg
       (.C(pclk),
        .CE(1'b1),
        .D(video_hsync),
        .Q(c0_q),
        .R(1'b0));
  FDRE c0_reg_reg
       (.C(pclk),
        .CE(1'b1),
        .D(c0_q),
        .Q(c0_reg),
        .R(1'b0));
  FDRE c1_q_reg
       (.C(pclk),
        .CE(1'b1),
        .D(video_vsync),
        .Q(c1_q),
        .R(1'b0));
  FDRE c1_reg_reg
       (.C(pclk),
        .CE(1'b1),
        .D(c1_q),
        .Q(c1_reg),
        .R(1'b0));
  LUT6 #(
    .INIT(64'h0A0A8228A0A08228)) 
    \cnt[1]_i_1 
       (.I0(de_reg),
        .I1(\cnt[4]_i_3_n_0 ),
        .I2(cnt[1]),
        .I3(\cnt[1]_i_2_n_0 ),
        .I4(\cnt[4]_i_5_n_0 ),
        .I5(\cnt[1]_i_3_n_0 ),
        .O(\cnt[1]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair14" *) 
  LUT3 #(
    .INIT(8'h69)) 
    \cnt[1]_i_2 
       (.I0(n1q_m[1]),
        .I1(n0q_m[1]),
        .I2(q_m_reg[8]),
        .O(\cnt[1]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair14" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \cnt[1]_i_3 
       (.I0(n1q_m[1]),
        .I1(n0q_m[1]),
        .O(\cnt[1]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'h000002A2AAAA02A2)) 
    \cnt[2]_i_1 
       (.I0(de_reg),
        .I1(\cnt[2]_i_2_n_0 ),
        .I2(\cnt[4]_i_3_n_0 ),
        .I3(\cnt[2]_i_3_n_0 ),
        .I4(\cnt[4]_i_5_n_0 ),
        .I5(\cnt[2]_i_4_n_0 ),
        .O(\cnt[2]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT5 #(
    .INIT(32'h596565A6)) 
    \cnt[2]_i_2 
       (.I0(\cnt[4]_i_15_n_0 ),
        .I1(cnt[1]),
        .I2(n0q_m[1]),
        .I3(q_m_reg[8]),
        .I4(n1q_m[1]),
        .O(\cnt[2]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT5 #(
    .INIT(32'h8E1871E7)) 
    \cnt[2]_i_3 
       (.I0(cnt[1]),
        .I1(q_m_reg[8]),
        .I2(n1q_m[1]),
        .I3(n0q_m[1]),
        .I4(\cnt[4]_i_15_n_0 ),
        .O(\cnt[2]_i_3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT5 #(
    .INIT(32'h59655695)) 
    \cnt[2]_i_4 
       (.I0(\cnt[4]_i_15_n_0 ),
        .I1(cnt[1]),
        .I2(n0q_m[1]),
        .I3(n1q_m[1]),
        .I4(q_m_reg[8]),
        .O(\cnt[2]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'h000002A2AAAA02A2)) 
    \cnt[3]_i_1 
       (.I0(de_reg),
        .I1(\cnt[3]_i_2_n_0 ),
        .I2(\cnt[4]_i_3_n_0 ),
        .I3(\cnt[3]_i_3_n_0 ),
        .I4(\cnt[4]_i_5_n_0 ),
        .I5(\cnt[3]_i_4_n_0 ),
        .O(\cnt[3]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h7F0180FE80FE7F01)) 
    \cnt[3]_i_2 
       (.I0(\cnt[3]_i_5_n_0 ),
        .I1(cnt[1]),
        .I2(n1q_m[1]),
        .I3(\cnt[4]_i_10__1_n_0 ),
        .I4(\cnt[4]_i_8_n_0 ),
        .I5(\cnt[4]_i_7_n_0 ),
        .O(\cnt[3]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h6A56AA6A55555655)) 
    \cnt[3]_i_3 
       (.I0(\cnt[3]_i_6_n_0 ),
        .I1(cnt[1]),
        .I2(q_m_reg[8]),
        .I3(n1q_m[1]),
        .I4(n0q_m[1]),
        .I5(\cnt[4]_i_15_n_0 ),
        .O(\cnt[3]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'h71758E8A8E8A7175)) 
    \cnt[3]_i_4 
       (.I0(\cnt[4]_i_15_n_0 ),
        .I1(\cnt[3]_i_7_n_0 ),
        .I2(cnt[1]),
        .I3(\cnt[1]_i_3_n_0 ),
        .I4(\cnt[4]_i_25_n_0 ),
        .I5(\cnt[4]_i_19_n_0 ),
        .O(\cnt[3]_i_4_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair15" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \cnt[3]_i_5 
       (.I0(n0q_m[1]),
        .I1(q_m_reg[8]),
        .O(\cnt[3]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'h6969966996699696)) 
    \cnt[3]_i_6 
       (.I0(n1q_m[3]),
        .I1(n0q_m[3]),
        .I2(cnt[3]),
        .I3(n1q_m[2]),
        .I4(n0q_m[2]),
        .I5(cnt[2]),
        .O(\cnt[3]_i_6_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair13" *) 
  LUT3 #(
    .INIT(8'hE7)) 
    \cnt[3]_i_7 
       (.I0(q_m_reg[8]),
        .I1(n1q_m[1]),
        .I2(n0q_m[1]),
        .O(\cnt[3]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'h000002A2AAAA02A2)) 
    \cnt[4]_i_1 
       (.I0(de_reg),
        .I1(\cnt[4]_i_2_n_0 ),
        .I2(\cnt[4]_i_3_n_0 ),
        .I3(\cnt[4]_i_4_n_0 ),
        .I4(\cnt[4]_i_5_n_0 ),
        .I5(\cnt[4]_i_6_n_0 ),
        .O(\cnt[4]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT5 #(
    .INIT(32'hD22D2DD2)) 
    \cnt[4]_i_10__1 
       (.I0(n0q_m[1]),
        .I1(q_m_reg[8]),
        .I2(n1q_m[2]),
        .I3(n0q_m[2]),
        .I4(cnt[2]),
        .O(\cnt[4]_i_10__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair12" *) 
  LUT4 #(
    .INIT(16'h2800)) 
    \cnt[4]_i_11 
       (.I0(cnt[1]),
        .I1(n0q_m[1]),
        .I2(q_m_reg[8]),
        .I3(n1q_m[1]),
        .O(\cnt[4]_i_11_n_0 ));
  LUT6 #(
    .INIT(64'h65AA5565AA9A65AA)) 
    \cnt[4]_i_12 
       (.I0(cnt[4]),
        .I1(n1q_m[2]),
        .I2(n0q_m[2]),
        .I3(n1q_m[3]),
        .I4(n0q_m[3]),
        .I5(cnt[3]),
        .O(\cnt[4]_i_12_n_0 ));
  LUT6 #(
    .INIT(64'h00D00000DDDD00D0)) 
    \cnt[4]_i_13 
       (.I0(n1q_m[3]),
        .I1(n0q_m[3]),
        .I2(n0q_m[1]),
        .I3(n1q_m[1]),
        .I4(n0q_m[2]),
        .I5(n1q_m[2]),
        .O(\cnt[4]_i_13_n_0 ));
  LUT6 #(
    .INIT(64'hFF2F2F22FF2FFF2F)) 
    \cnt[4]_i_14 
       (.I0(n0q_m[3]),
        .I1(n1q_m[3]),
        .I2(n1q_m[2]),
        .I3(n0q_m[2]),
        .I4(n0q_m[1]),
        .I5(n1q_m[1]),
        .O(\cnt[4]_i_14_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair10" *) 
  LUT3 #(
    .INIT(8'h96)) 
    \cnt[4]_i_15 
       (.I0(cnt[2]),
        .I1(n0q_m[2]),
        .I2(n1q_m[2]),
        .O(\cnt[4]_i_15_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair13" *) 
  LUT3 #(
    .INIT(8'h4D)) 
    \cnt[4]_i_16 
       (.I0(q_m_reg[8]),
        .I1(n1q_m[1]),
        .I2(n0q_m[1]),
        .O(\cnt[4]_i_16_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT4 #(
    .INIT(16'h4114)) 
    \cnt[4]_i_17__1 
       (.I0(cnt[1]),
        .I1(q_m_reg[8]),
        .I2(n0q_m[1]),
        .I3(n1q_m[1]),
        .O(\cnt[4]_i_17__1_n_0 ));
  LUT3 #(
    .INIT(8'h8E)) 
    \cnt[4]_i_18 
       (.I0(cnt[2]),
        .I1(n0q_m[2]),
        .I2(n1q_m[2]),
        .O(\cnt[4]_i_18_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT3 #(
    .INIT(8'h96)) 
    \cnt[4]_i_19 
       (.I0(cnt[3]),
        .I1(n0q_m[3]),
        .I2(n1q_m[3]),
        .O(\cnt[4]_i_19_n_0 ));
  LUT6 #(
    .INIT(64'h8E8EEE8E71711171)) 
    \cnt[4]_i_2 
       (.I0(\cnt[4]_i_7_n_0 ),
        .I1(\cnt[4]_i_8_n_0 ),
        .I2(\cnt[4]_i_9_n_0 ),
        .I3(\cnt[4]_i_10__1_n_0 ),
        .I4(\cnt[4]_i_11_n_0 ),
        .I5(\cnt[4]_i_12_n_0 ),
        .O(\cnt[4]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT4 #(
    .INIT(16'h599A)) 
    \cnt[4]_i_20 
       (.I0(cnt[4]),
        .I1(n1q_m[3]),
        .I2(n0q_m[3]),
        .I3(cnt[3]),
        .O(\cnt[4]_i_20_n_0 ));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    \cnt[4]_i_21 
       (.I0(n0q_m[3]),
        .I1(n1q_m[3]),
        .I2(n1q_m[2]),
        .I3(n0q_m[2]),
        .I4(n1q_m[1]),
        .I5(n0q_m[1]),
        .O(\cnt[4]_i_21_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT5 #(
    .INIT(32'h5965A96A)) 
    \cnt[4]_i_22 
       (.I0(cnt[4]),
        .I1(q_m_reg[8]),
        .I2(n1q_m[3]),
        .I3(n0q_m[3]),
        .I4(cnt[3]),
        .O(\cnt[4]_i_22_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair11" *) 
  LUT4 #(
    .INIT(16'hFBEF)) 
    \cnt[4]_i_23 
       (.I0(cnt[1]),
        .I1(n0q_m[1]),
        .I2(n1q_m[1]),
        .I3(q_m_reg[8]),
        .O(\cnt[4]_i_23_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair11" *) 
  LUT4 #(
    .INIT(16'h2008)) 
    \cnt[4]_i_24 
       (.I0(cnt[1]),
        .I1(n0q_m[1]),
        .I2(n1q_m[1]),
        .I3(q_m_reg[8]),
        .O(\cnt[4]_i_24_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair10" *) 
  LUT4 #(
    .INIT(16'hB28E)) 
    \cnt[4]_i_25 
       (.I0(cnt[2]),
        .I1(n0q_m[2]),
        .I2(n1q_m[2]),
        .I3(q_m_reg[8]),
        .O(\cnt[4]_i_25_n_0 ));
  LUT5 #(
    .INIT(32'h8BC8BBFB)) 
    \cnt[4]_i_3 
       (.I0(\cnt[4]_i_13_n_0 ),
        .I1(cnt[4]),
        .I2(n0q_m[3]),
        .I3(n1q_m[3]),
        .I4(\cnt[4]_i_14_n_0 ),
        .O(\cnt[4]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hE8FF00E81700FF17)) 
    \cnt[4]_i_4 
       (.I0(\cnt[4]_i_15_n_0 ),
        .I1(\cnt[4]_i_16_n_0 ),
        .I2(\cnt[4]_i_17__1_n_0 ),
        .I3(\cnt[4]_i_18_n_0 ),
        .I4(\cnt[4]_i_19_n_0 ),
        .I5(\cnt[4]_i_20_n_0 ),
        .O(\cnt[4]_i_4_n_0 ));
  LUT5 #(
    .INIT(32'hAAAAAAAB)) 
    \cnt[4]_i_5 
       (.I0(\cnt[4]_i_21_n_0 ),
        .I1(cnt[2]),
        .I2(cnt[4]),
        .I3(cnt[1]),
        .I4(cnt[3]),
        .O(\cnt[4]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'h599959599AAA9A9A)) 
    \cnt[4]_i_6 
       (.I0(\cnt[4]_i_22_n_0 ),
        .I1(\cnt[4]_i_19_n_0 ),
        .I2(\cnt[4]_i_23_n_0 ),
        .I3(\cnt[4]_i_24_n_0 ),
        .I4(\cnt[4]_i_15_n_0 ),
        .I5(\cnt[4]_i_25_n_0 ),
        .O(\cnt[4]_i_6_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT5 #(
    .INIT(32'h41D74141)) 
    \cnt[4]_i_7 
       (.I0(cnt[2]),
        .I1(n0q_m[2]),
        .I2(n1q_m[2]),
        .I3(q_m_reg[8]),
        .I4(n0q_m[1]),
        .O(\cnt[4]_i_7_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT5 #(
    .INIT(32'hB44B4BB4)) 
    \cnt[4]_i_8 
       (.I0(n1q_m[2]),
        .I1(n0q_m[2]),
        .I2(n1q_m[3]),
        .I3(n0q_m[3]),
        .I4(cnt[3]),
        .O(\cnt[4]_i_8_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair12" *) 
  LUT4 #(
    .INIT(16'hFFF6)) 
    \cnt[4]_i_9 
       (.I0(q_m_reg[8]),
        .I1(n0q_m[1]),
        .I2(cnt[1]),
        .I3(n1q_m[1]),
        .O(\cnt[4]_i_9_n_0 ));
  FDCE \cnt_reg[1] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(reset),
        .D(\cnt[1]_i_1_n_0 ),
        .Q(cnt[1]));
  FDCE \cnt_reg[2] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(reset),
        .D(\cnt[2]_i_1_n_0 ),
        .Q(cnt[2]));
  FDCE \cnt_reg[3] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(reset),
        .D(\cnt[3]_i_1_n_0 ),
        .Q(cnt[3]));
  FDCE \cnt_reg[4] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(reset),
        .D(\cnt[4]_i_1_n_0 ),
        .Q(cnt[4]));
  FDRE de_q_reg
       (.C(pclk),
        .CE(1'b1),
        .D(video_de),
        .Q(de_q),
        .R(1'b0));
  FDRE de_reg_reg
       (.C(pclk),
        .CE(1'b1),
        .D(de_q),
        .Q(de_reg),
        .R(1'b0));
  FDRE \din_q_reg[0] 
       (.C(pclk),
        .CE(1'b1),
        .D(video_din[0]),
        .Q(\din_q_reg_n_0_[0] ),
        .R(1'b0));
  FDRE \din_q_reg[1] 
       (.C(pclk),
        .CE(1'b1),
        .D(video_din[1]),
        .Q(p_0_in5_in),
        .R(1'b0));
  FDRE \din_q_reg[2] 
       (.C(pclk),
        .CE(1'b1),
        .D(video_din[2]),
        .Q(p_0_in4_in),
        .R(1'b0));
  FDRE \din_q_reg[3] 
       (.C(pclk),
        .CE(1'b1),
        .D(video_din[3]),
        .Q(p_0_in3_in),
        .R(1'b0));
  FDRE \din_q_reg[4] 
       (.C(pclk),
        .CE(1'b1),
        .D(video_din[4]),
        .Q(p_0_in2_in),
        .R(1'b0));
  FDRE \din_q_reg[5] 
       (.C(pclk),
        .CE(1'b1),
        .D(video_din[5]),
        .Q(p_0_in1_in),
        .R(1'b0));
  FDRE \din_q_reg[6] 
       (.C(pclk),
        .CE(1'b1),
        .D(video_din[6]),
        .Q(p_0_in0_in),
        .R(1'b0));
  FDRE \din_q_reg[7] 
       (.C(pclk),
        .CE(1'b1),
        .D(video_din[7]),
        .Q(p_0_in),
        .R(1'b0));
  LUT6 #(
    .INIT(64'hA656FFFFA6560000)) 
    \dout[0]_i_1 
       (.I0(q_m_reg[0]),
        .I1(\cnt[4]_i_3_n_0 ),
        .I2(\cnt[4]_i_5_n_0 ),
        .I3(q_m_reg[8]),
        .I4(de_reg),
        .I5(c0_reg),
        .O(dout[0]));
  LUT6 #(
    .INIT(64'hA656FFFFA6560000)) 
    \dout[1]_i_1 
       (.I0(q_m_reg[1]),
        .I1(\cnt[4]_i_3_n_0 ),
        .I2(\cnt[4]_i_5_n_0 ),
        .I3(q_m_reg[8]),
        .I4(de_reg),
        .I5(c0_reg),
        .O(dout[1]));
  LUT6 #(
    .INIT(64'hA202F75708A85DFD)) 
    \dout[2]_i_1 
       (.I0(de_reg),
        .I1(\cnt[4]_i_3_n_0 ),
        .I2(\cnt[4]_i_5_n_0 ),
        .I3(q_m_reg[8]),
        .I4(c0_reg),
        .I5(q_m_reg[2]),
        .O(dout[2]));
  LUT6 #(
    .INIT(64'hA656FFFFA6560000)) 
    \dout[3]_i_1 
       (.I0(q_m_reg[3]),
        .I1(\cnt[4]_i_3_n_0 ),
        .I2(\cnt[4]_i_5_n_0 ),
        .I3(q_m_reg[8]),
        .I4(de_reg),
        .I5(c0_reg),
        .O(dout[3]));
  LUT6 #(
    .INIT(64'hA202F75708A85DFD)) 
    \dout[4]_i_1 
       (.I0(de_reg),
        .I1(\cnt[4]_i_3_n_0 ),
        .I2(\cnt[4]_i_5_n_0 ),
        .I3(q_m_reg[8]),
        .I4(c0_reg),
        .I5(q_m_reg[4]),
        .O(dout[4]));
  LUT6 #(
    .INIT(64'hA656FFFFA6560000)) 
    \dout[5]_i_1 
       (.I0(q_m_reg[5]),
        .I1(\cnt[4]_i_3_n_0 ),
        .I2(\cnt[4]_i_5_n_0 ),
        .I3(q_m_reg[8]),
        .I4(de_reg),
        .I5(c0_reg),
        .O(dout[5]));
  LUT6 #(
    .INIT(64'hA202F75708A85DFD)) 
    \dout[6]_i_1 
       (.I0(de_reg),
        .I1(\cnt[4]_i_3_n_0 ),
        .I2(\cnt[4]_i_5_n_0 ),
        .I3(q_m_reg[8]),
        .I4(c0_reg),
        .I5(q_m_reg[6]),
        .O(dout[6]));
  LUT6 #(
    .INIT(64'hA656FFFFA6560000)) 
    \dout[7]_i_1 
       (.I0(q_m_reg[7]),
        .I1(\cnt[4]_i_3_n_0 ),
        .I2(\cnt[4]_i_5_n_0 ),
        .I3(q_m_reg[8]),
        .I4(de_reg),
        .I5(c0_reg),
        .O(dout[7]));
  (* SOFT_HLUTNM = "soft_lutpair15" *) 
  LUT3 #(
    .INIT(8'hC5)) 
    \dout[8]_i_1 
       (.I0(c0_reg),
        .I1(q_m_reg[8]),
        .I2(de_reg),
        .O(dout[8]));
  LUT6 #(
    .INIT(64'h74FF7400740074FF)) 
    \dout[9]_i_1 
       (.I0(q_m_reg[8]),
        .I1(\cnt[4]_i_5_n_0 ),
        .I2(\cnt[4]_i_3_n_0 ),
        .I3(de_reg),
        .I4(c0_reg),
        .I5(c1_reg),
        .O(dout[9]));
  FDCE \dout_reg[0] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(reset),
        .D(dout[0]),
        .Q(Q[0]));
  FDCE \dout_reg[1] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(reset),
        .D(dout[1]),
        .Q(Q[1]));
  FDCE \dout_reg[2] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(reset),
        .D(dout[2]),
        .Q(Q[2]));
  FDCE \dout_reg[3] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(reset),
        .D(dout[3]),
        .Q(Q[3]));
  FDCE \dout_reg[4] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(reset),
        .D(dout[4]),
        .Q(Q[4]));
  FDCE \dout_reg[5] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(reset),
        .D(dout[5]),
        .Q(Q[5]));
  FDCE \dout_reg[6] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(reset),
        .D(dout[6]),
        .Q(Q[6]));
  FDCE \dout_reg[7] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(reset),
        .D(dout[7]),
        .Q(Q[7]));
  FDCE \dout_reg[8] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(reset),
        .D(dout[8]),
        .Q(Q[8]));
  FDCE \dout_reg[9] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(reset),
        .D(dout[9]),
        .Q(Q[9]));
  LUT6 #(
    .INIT(64'h9996699996669996)) 
    \n0q_m[1]_i_1 
       (.I0(\n1q_m[3]_i_3_n_0 ),
        .I1(\n1q_m[3]_i_2_n_0 ),
        .I2(\n1q_m[3]_i_5_n_0 ),
        .I3(\n1q_m[3]_i_4_n_0 ),
        .I4(\din_q_reg_n_0_[0] ),
        .I5(\n1q_m[3]_i_6_n_0 ),
        .O(n0q_m0[1]));
  LUT6 #(
    .INIT(64'h2000FBB2FBB2DFFF)) 
    \n0q_m[2]_i_1 
       (.I0(\n1q_m[3]_i_6_n_0 ),
        .I1(\din_q_reg_n_0_[0] ),
        .I2(\n1q_m[3]_i_4_n_0 ),
        .I3(\n1q_m[3]_i_5_n_0 ),
        .I4(\n1q_m[3]_i_2_n_0 ),
        .I5(\n1q_m[3]_i_3_n_0 ),
        .O(n0q_m0[2]));
  LUT6 #(
    .INIT(64'h0100000000000000)) 
    \n0q_m[3]_i_1 
       (.I0(\n1q_m[3]_i_2_n_0 ),
        .I1(\n1q_m[3]_i_3_n_0 ),
        .I2(\din_q_reg_n_0_[0] ),
        .I3(\n1q_m[3]_i_4_n_0 ),
        .I4(\n1q_m[3]_i_5_n_0 ),
        .I5(\n1q_m[3]_i_6_n_0 ),
        .O(n0q_m0[3]));
  FDRE \n0q_m_reg[1] 
       (.C(pclk),
        .CE(1'b1),
        .D(n0q_m0[1]),
        .Q(n0q_m[1]),
        .R(1'b0));
  FDRE \n0q_m_reg[2] 
       (.C(pclk),
        .CE(1'b1),
        .D(n0q_m0[2]),
        .Q(n0q_m[2]),
        .R(1'b0));
  FDRE \n0q_m_reg[3] 
       (.C(pclk),
        .CE(1'b1),
        .D(n0q_m0[3]),
        .Q(n0q_m[3]),
        .R(1'b0));
  LUT6 #(
    .INIT(64'h6996966996696996)) 
    \n1d[0]_i_1 
       (.I0(video_din[0]),
        .I1(video_din[7]),
        .I2(\n1d[0]_i_2_n_0 ),
        .I3(video_din[2]),
        .I4(video_din[1]),
        .I5(video_din[3]),
        .O(n1d0[0]));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT3 #(
    .INIT(8'h96)) 
    \n1d[0]_i_2 
       (.I0(video_din[6]),
        .I1(video_din[4]),
        .I2(video_din[5]),
        .O(\n1d[0]_i_2_n_0 ));
  LUT3 #(
    .INIT(8'h96)) 
    \n1d[1]_i_1 
       (.I0(\n1d[3]_i_2_n_0 ),
        .I1(\n1d[1]_i_2_n_0 ),
        .I2(\n1d[3]_i_3_n_0 ),
        .O(n1d0[1]));
  LUT6 #(
    .INIT(64'h171717E817E8E8E8)) 
    \n1d[1]_i_2 
       (.I0(video_din[3]),
        .I1(video_din[2]),
        .I2(video_din[1]),
        .I3(video_din[6]),
        .I4(video_din[5]),
        .I5(video_din[4]),
        .O(\n1d[1]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h7E7E7EE87EE8E8E8)) 
    \n1d[2]_i_1 
       (.I0(\n1d[3]_i_2_n_0 ),
        .I1(\n1d[3]_i_3_n_0 ),
        .I2(\n1d[2]_i_2_n_0 ),
        .I3(video_din[4]),
        .I4(video_din[5]),
        .I5(video_din[6]),
        .O(n1d0[2]));
  LUT3 #(
    .INIT(8'hE8)) 
    \n1d[2]_i_2 
       (.I0(video_din[1]),
        .I1(video_din[2]),
        .I2(video_din[3]),
        .O(\n1d[2]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h8880800000000000)) 
    \n1d[3]_i_1 
       (.I0(\n1d[3]_i_2_n_0 ),
        .I1(\n1d[3]_i_3_n_0 ),
        .I2(video_din[3]),
        .I3(video_din[2]),
        .I4(video_din[1]),
        .I5(\n1d[3]_i_4_n_0 ),
        .O(n1d0[3]));
  LUT6 #(
    .INIT(64'h9600009600969600)) 
    \n1d[3]_i_2 
       (.I0(video_din[2]),
        .I1(video_din[1]),
        .I2(video_din[3]),
        .I3(video_din[0]),
        .I4(video_din[7]),
        .I5(\n1d[0]_i_2_n_0 ),
        .O(\n1d[3]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT5 #(
    .INIT(32'hE88E8EE8)) 
    \n1d[3]_i_3 
       (.I0(video_din[7]),
        .I1(video_din[0]),
        .I2(video_din[5]),
        .I3(video_din[4]),
        .I4(video_din[6]),
        .O(\n1d[3]_i_3_n_0 ));
  LUT3 #(
    .INIT(8'hE8)) 
    \n1d[3]_i_4 
       (.I0(video_din[4]),
        .I1(video_din[5]),
        .I2(video_din[6]),
        .O(\n1d[3]_i_4_n_0 ));
  FDRE \n1d_reg[0] 
       (.C(pclk),
        .CE(1'b1),
        .D(n1d0[0]),
        .Q(n1d[0]),
        .R(1'b0));
  FDRE \n1d_reg[1] 
       (.C(pclk),
        .CE(1'b1),
        .D(n1d0[1]),
        .Q(n1d[1]),
        .R(1'b0));
  FDRE \n1d_reg[2] 
       (.C(pclk),
        .CE(1'b1),
        .D(n1d0[2]),
        .Q(n1d[2]),
        .R(1'b0));
  FDRE \n1d_reg[3] 
       (.C(pclk),
        .CE(1'b1),
        .D(n1d0[3]),
        .Q(n1d[3]),
        .R(1'b0));
  LUT6 #(
    .INIT(64'h6696969996999969)) 
    \n1q_m[1]_i_1 
       (.I0(\n1q_m[3]_i_2_n_0 ),
        .I1(\n1q_m[3]_i_3_n_0 ),
        .I2(\din_q_reg_n_0_[0] ),
        .I3(\n1q_m[3]_i_4_n_0 ),
        .I4(\n1q_m[3]_i_5_n_0 ),
        .I5(\n1q_m[3]_i_6_n_0 ),
        .O(n1q_m0[1]));
  LUT6 #(
    .INIT(64'hFFEF71F771F70010)) 
    \n1q_m[2]_i_1 
       (.I0(\n1q_m[3]_i_5_n_0 ),
        .I1(\n1q_m[3]_i_4_n_0 ),
        .I2(\din_q_reg_n_0_[0] ),
        .I3(\n1q_m[3]_i_6_n_0 ),
        .I4(\n1q_m[3]_i_3_n_0 ),
        .I5(\n1q_m[3]_i_2_n_0 ),
        .O(\n1q_m[2]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000000080)) 
    \n1q_m[3]_i_1 
       (.I0(\n1q_m[3]_i_2_n_0 ),
        .I1(\n1q_m[3]_i_3_n_0 ),
        .I2(\din_q_reg_n_0_[0] ),
        .I3(\n1q_m[3]_i_4_n_0 ),
        .I4(\n1q_m[3]_i_5_n_0 ),
        .I5(\n1q_m[3]_i_6_n_0 ),
        .O(n1q_m0[3]));
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
  LUT5 #(
    .INIT(32'hB42D4BD2)) 
    \n1q_m[3]_i_2 
       (.I0(\q_m_reg[7]_i_2_n_0 ),
        .I1(p_0_in3_in),
        .I2(\din_q_reg_n_0_[0] ),
        .I3(p_0_in4_in),
        .I4(p_0_in5_in),
        .O(\n1q_m[3]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hE11E1EE178878778)) 
    \n1q_m[3]_i_3 
       (.I0(p_0_in0_in),
        .I1(\q_m_reg[7]_i_2_n_0 ),
        .I2(q_m_2),
        .I3(p_0_in2_in),
        .I4(p_0_in3_in),
        .I5(p_0_in1_in),
        .O(\n1q_m[3]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'h9669699669969669)) 
    \n1q_m[3]_i_4 
       (.I0(p_0_in3_in),
        .I1(p_0_in2_in),
        .I2(\din_q_reg_n_0_[0] ),
        .I3(p_0_in4_in),
        .I4(p_0_in5_in),
        .I5(\n1q_m[3]_i_7_n_0 ),
        .O(\n1q_m[3]_i_4_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair7" *) 
  LUT5 #(
    .INIT(32'h96696996)) 
    \n1q_m[3]_i_5 
       (.I0(p_0_in0_in),
        .I1(\q_m_reg[7]_i_3_n_0 ),
        .I2(p_0_in1_in),
        .I3(\q_m_reg[7]_i_2_n_0 ),
        .I4(p_0_in),
        .O(\n1q_m[3]_i_5_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair16" *) 
  LUT3 #(
    .INIT(8'h69)) 
    \n1q_m[3]_i_6 
       (.I0(\din_q_reg_n_0_[0] ),
        .I1(p_0_in5_in),
        .I2(p_0_in3_in),
        .O(\n1q_m[3]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'h5555555566666A66)) 
    \n1q_m[3]_i_7 
       (.I0(p_0_in0_in),
        .I1(n1d[2]),
        .I2(n1d[0]),
        .I3(\din_q_reg_n_0_[0] ),
        .I4(n1d[1]),
        .I5(n1d[3]),
        .O(\n1q_m[3]_i_7_n_0 ));
  FDRE \n1q_m_reg[1] 
       (.C(pclk),
        .CE(1'b1),
        .D(n1q_m0[1]),
        .Q(n1q_m[1]),
        .R(1'b0));
  FDRE \n1q_m_reg[2] 
       (.C(pclk),
        .CE(1'b1),
        .D(\n1q_m[2]_i_1_n_0 ),
        .Q(n1q_m[2]),
        .R(1'b0));
  FDRE \n1q_m_reg[3] 
       (.C(pclk),
        .CE(1'b1),
        .D(n1q_m0[3]),
        .Q(n1q_m[3]),
        .R(1'b0));
  LUT6 #(
    .INIT(64'hFFA800570055FFAA)) 
    \q_m_reg[1]_i_1 
       (.I0(n1d[2]),
        .I1(n1d[0]),
        .I2(n1d[1]),
        .I3(n1d[3]),
        .I4(p_0_in5_in),
        .I5(\din_q_reg_n_0_[0] ),
        .O(q_m_1));
  (* SOFT_HLUTNM = "soft_lutpair16" *) 
  LUT3 #(
    .INIT(8'h96)) 
    \q_m_reg[2]_i_1 
       (.I0(\din_q_reg_n_0_[0] ),
        .I1(p_0_in4_in),
        .I2(p_0_in5_in),
        .O(q_m_2));
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
  LUT5 #(
    .INIT(32'h96696996)) 
    \q_m_reg[3]_i_1 
       (.I0(p_0_in5_in),
        .I1(p_0_in4_in),
        .I2(\din_q_reg_n_0_[0] ),
        .I3(p_0_in3_in),
        .I4(\q_m_reg[7]_i_2_n_0 ),
        .O(q_m_3));
  (* SOFT_HLUTNM = "soft_lutpair9" *) 
  LUT5 #(
    .INIT(32'h96696996)) 
    \q_m_reg[4]_i_1 
       (.I0(p_0_in3_in),
        .I1(p_0_in2_in),
        .I2(\din_q_reg_n_0_[0] ),
        .I3(p_0_in4_in),
        .I4(p_0_in5_in),
        .O(q_m_4));
  LUT5 #(
    .INIT(32'h96696996)) 
    \q_m_reg[5]_i_1 
       (.I0(\q_m_reg[7]_i_2_n_0 ),
        .I1(q_m_2),
        .I2(p_0_in2_in),
        .I3(p_0_in3_in),
        .I4(p_0_in1_in),
        .O(\q_m_reg[5]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'h96696996)) 
    \q_m_reg[6]_i_1 
       (.I0(p_0_in1_in),
        .I1(p_0_in3_in),
        .I2(p_0_in2_in),
        .I3(q_m_2),
        .I4(p_0_in0_in),
        .O(q_m_6));
  (* SOFT_HLUTNM = "soft_lutpair7" *) 
  LUT5 #(
    .INIT(32'h69969669)) 
    \q_m_reg[7]_i_1 
       (.I0(p_0_in),
        .I1(\q_m_reg[7]_i_2_n_0 ),
        .I2(p_0_in1_in),
        .I3(\q_m_reg[7]_i_3_n_0 ),
        .I4(p_0_in0_in),
        .O(q_m_7));
  (* SOFT_HLUTNM = "soft_lutpair8" *) 
  LUT5 #(
    .INIT(32'hFFEFAAAA)) 
    \q_m_reg[7]_i_2 
       (.I0(n1d[3]),
        .I1(n1d[1]),
        .I2(\din_q_reg_n_0_[0] ),
        .I3(n1d[0]),
        .I4(n1d[2]),
        .O(\q_m_reg[7]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair9" *) 
  LUT5 #(
    .INIT(32'h69969669)) 
    \q_m_reg[7]_i_3 
       (.I0(p_0_in5_in),
        .I1(p_0_in4_in),
        .I2(\din_q_reg_n_0_[0] ),
        .I3(p_0_in2_in),
        .I4(p_0_in3_in),
        .O(\q_m_reg[7]_i_3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair8" *) 
  LUT5 #(
    .INIT(32'h00005575)) 
    \q_m_reg[8]_i_1 
       (.I0(n1d[2]),
        .I1(n1d[0]),
        .I2(\din_q_reg_n_0_[0] ),
        .I3(n1d[1]),
        .I4(n1d[3]),
        .O(\q_m_reg[8]_i_1_n_0 ));
  FDRE \q_m_reg_reg[0] 
       (.C(pclk),
        .CE(1'b1),
        .D(\din_q_reg_n_0_[0] ),
        .Q(q_m_reg[0]),
        .R(1'b0));
  FDRE \q_m_reg_reg[1] 
       (.C(pclk),
        .CE(1'b1),
        .D(q_m_1),
        .Q(q_m_reg[1]),
        .R(1'b0));
  FDRE \q_m_reg_reg[2] 
       (.C(pclk),
        .CE(1'b1),
        .D(q_m_2),
        .Q(q_m_reg[2]),
        .R(1'b0));
  FDRE \q_m_reg_reg[3] 
       (.C(pclk),
        .CE(1'b1),
        .D(q_m_3),
        .Q(q_m_reg[3]),
        .R(1'b0));
  FDRE \q_m_reg_reg[4] 
       (.C(pclk),
        .CE(1'b1),
        .D(q_m_4),
        .Q(q_m_reg[4]),
        .R(1'b0));
  FDRE \q_m_reg_reg[5] 
       (.C(pclk),
        .CE(1'b1),
        .D(\q_m_reg[5]_i_1_n_0 ),
        .Q(q_m_reg[5]),
        .R(1'b0));
  FDRE \q_m_reg_reg[6] 
       (.C(pclk),
        .CE(1'b1),
        .D(q_m_6),
        .Q(q_m_reg[6]),
        .R(1'b0));
  FDRE \q_m_reg_reg[7] 
       (.C(pclk),
        .CE(1'b1),
        .D(q_m_7),
        .Q(q_m_reg[7]),
        .R(1'b0));
  FDRE \q_m_reg_reg[8] 
       (.C(pclk),
        .CE(1'b1),
        .D(\q_m_reg[8]_i_1_n_0 ),
        .Q(q_m_reg[8]),
        .R(1'b0));
endmodule

(* ORIG_REF_NAME = "dvi_encoder" *) 
module system_DVI_Transmitter_Safe_0_0_dvi_encoder_0
   (Q,
    pclk,
    de_reg,
    video_din,
    reset);
  output [9:0]Q;
  input pclk;
  input de_reg;
  input [7:0]video_din;
  input reset;

  wire [9:0]Q;
  wire [4:1]cnt;
  wire \cnt[1]_i_1__0_n_0 ;
  wire \cnt[1]_i_2__0_n_0 ;
  wire \cnt[1]_i_3__0_n_0 ;
  wire \cnt[2]_i_1__0_n_0 ;
  wire \cnt[2]_i_2__0_n_0 ;
  wire \cnt[2]_i_3__0_n_0 ;
  wire \cnt[2]_i_4__0_n_0 ;
  wire \cnt[3]_i_1__0_n_0 ;
  wire \cnt[3]_i_2__0_n_0 ;
  wire \cnt[3]_i_3__0_n_0 ;
  wire \cnt[3]_i_4__0_n_0 ;
  wire \cnt[3]_i_5__0_n_0 ;
  wire \cnt[3]_i_6__0_n_0 ;
  wire \cnt[3]_i_7__0_n_0 ;
  wire \cnt[4]_i_10_n_0 ;
  wire \cnt[4]_i_11__1_n_0 ;
  wire \cnt[4]_i_12__0_n_0 ;
  wire \cnt[4]_i_13__0_n_0 ;
  wire \cnt[4]_i_14__0_n_0 ;
  wire \cnt[4]_i_15__0_n_0 ;
  wire \cnt[4]_i_16__1_n_0 ;
  wire \cnt[4]_i_17_n_0 ;
  wire \cnt[4]_i_18__0_n_0 ;
  wire \cnt[4]_i_19__0_n_0 ;
  wire \cnt[4]_i_1__0_n_0 ;
  wire \cnt[4]_i_20__0_n_0 ;
  wire \cnt[4]_i_21__0_n_0 ;
  wire \cnt[4]_i_22__1_n_0 ;
  wire \cnt[4]_i_23__0_n_0 ;
  wire \cnt[4]_i_24__0_n_0 ;
  wire \cnt[4]_i_25__0_n_0 ;
  wire \cnt[4]_i_2__0_n_0 ;
  wire \cnt[4]_i_3__0_n_0 ;
  wire \cnt[4]_i_4__0_n_0 ;
  wire \cnt[4]_i_5__0_n_0 ;
  wire \cnt[4]_i_6__0_n_0 ;
  wire \cnt[4]_i_7__0_n_0 ;
  wire \cnt[4]_i_8__0_n_0 ;
  wire \cnt[4]_i_9__0_n_0 ;
  wire de_reg;
  wire \din_q_reg_n_0_[0] ;
  wire \dout[0]_i_1__0_n_0 ;
  wire \dout[1]_i_1__0_n_0 ;
  wire \dout[2]_i_1__0_n_0 ;
  wire \dout[3]_i_1__0_n_0 ;
  wire \dout[4]_i_1__0_n_0 ;
  wire \dout[5]_i_1__0_n_0 ;
  wire \dout[6]_i_1__0_n_0 ;
  wire \dout[7]_i_1__0_n_0 ;
  wire \dout[8]_i_1__0_n_0 ;
  wire \dout[9]_i_1__0_n_0 ;
  wire \n0q_m[1]_i_1__0_n_0 ;
  wire \n0q_m[2]_i_1__0_n_0 ;
  wire \n0q_m[3]_i_1__0_n_0 ;
  wire \n0q_m_reg_n_0_[1] ;
  wire \n0q_m_reg_n_0_[2] ;
  wire \n0q_m_reg_n_0_[3] ;
  wire [3:0]n1d;
  wire \n1d[0]_i_1_n_0 ;
  wire \n1d[0]_i_2_n_0 ;
  wire \n1d[1]_i_1_n_0 ;
  wire \n1d[1]_i_2_n_0 ;
  wire \n1d[2]_i_1_n_0 ;
  wire \n1d[2]_i_2_n_0 ;
  wire \n1d[3]_i_1_n_0 ;
  wire \n1d[3]_i_2_n_0 ;
  wire \n1d[3]_i_3_n_0 ;
  wire \n1d[3]_i_4_n_0 ;
  wire \n1q_m[1]_i_1__0_n_0 ;
  wire \n1q_m[2]_i_1__0_n_0 ;
  wire \n1q_m[3]_i_1__0_n_0 ;
  wire \n1q_m[3]_i_2__0_n_0 ;
  wire \n1q_m[3]_i_3__0_n_0 ;
  wire \n1q_m[3]_i_4__0_n_0 ;
  wire \n1q_m[3]_i_5__0_n_0 ;
  wire \n1q_m[3]_i_6__0_n_0 ;
  wire \n1q_m[3]_i_7__0_n_0 ;
  wire \n1q_m_reg_n_0_[1] ;
  wire \n1q_m_reg_n_0_[2] ;
  wire \n1q_m_reg_n_0_[3] ;
  wire p_0_in;
  wire p_0_in0_in;
  wire p_0_in1_in;
  wire p_0_in2_in;
  wire p_0_in3_in;
  wire p_0_in4_in;
  wire p_0_in5_in;
  wire pclk;
  wire q_m_1;
  wire q_m_2;
  wire q_m_3;
  wire q_m_4;
  wire q_m_6;
  wire \q_m_reg[5]_i_1__0_n_0 ;
  wire \q_m_reg[7]_i_1__0_n_0 ;
  wire \q_m_reg[7]_i_2__0_n_0 ;
  wire \q_m_reg[7]_i_3__0_n_0 ;
  wire \q_m_reg[8]_i_1__0_n_0 ;
  wire \q_m_reg_reg_n_0_[0] ;
  wire \q_m_reg_reg_n_0_[1] ;
  wire \q_m_reg_reg_n_0_[2] ;
  wire \q_m_reg_reg_n_0_[3] ;
  wire \q_m_reg_reg_n_0_[4] ;
  wire \q_m_reg_reg_n_0_[5] ;
  wire \q_m_reg_reg_n_0_[6] ;
  wire \q_m_reg_reg_n_0_[7] ;
  wire \q_m_reg_reg_n_0_[8] ;
  wire reset;
  wire [7:0]video_din;

  LUT6 #(
    .INIT(64'h0A0A8228A0A08228)) 
    \cnt[1]_i_1__0 
       (.I0(de_reg),
        .I1(\cnt[4]_i_3__0_n_0 ),
        .I2(cnt[1]),
        .I3(\cnt[1]_i_2__0_n_0 ),
        .I4(\cnt[4]_i_5__0_n_0 ),
        .I5(\cnt[1]_i_3__0_n_0 ),
        .O(\cnt[1]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair33" *) 
  LUT3 #(
    .INIT(8'h69)) 
    \cnt[1]_i_2__0 
       (.I0(\n1q_m_reg_n_0_[1] ),
        .I1(\n0q_m_reg_n_0_[1] ),
        .I2(\q_m_reg_reg_n_0_[8] ),
        .O(\cnt[1]_i_2__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair33" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \cnt[1]_i_3__0 
       (.I0(\n1q_m_reg_n_0_[1] ),
        .I1(\n0q_m_reg_n_0_[1] ),
        .O(\cnt[1]_i_3__0_n_0 ));
  LUT6 #(
    .INIT(64'h000002A2AAAA02A2)) 
    \cnt[2]_i_1__0 
       (.I0(de_reg),
        .I1(\cnt[2]_i_2__0_n_0 ),
        .I2(\cnt[4]_i_3__0_n_0 ),
        .I3(\cnt[2]_i_3__0_n_0 ),
        .I4(\cnt[4]_i_5__0_n_0 ),
        .I5(\cnt[2]_i_4__0_n_0 ),
        .O(\cnt[2]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair22" *) 
  LUT5 #(
    .INIT(32'hA69A9A59)) 
    \cnt[2]_i_2__0 
       (.I0(\cnt[4]_i_18__0_n_0 ),
        .I1(cnt[1]),
        .I2(\n0q_m_reg_n_0_[1] ),
        .I3(\q_m_reg_reg_n_0_[8] ),
        .I4(\n1q_m_reg_n_0_[1] ),
        .O(\cnt[2]_i_2__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair19" *) 
  LUT5 #(
    .INIT(32'h71E78E18)) 
    \cnt[2]_i_3__0 
       (.I0(cnt[1]),
        .I1(\n0q_m_reg_n_0_[1] ),
        .I2(\n1q_m_reg_n_0_[1] ),
        .I3(\q_m_reg_reg_n_0_[8] ),
        .I4(\cnt[4]_i_18__0_n_0 ),
        .O(\cnt[2]_i_3__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair19" *) 
  LUT5 #(
    .INIT(32'hA69AA96A)) 
    \cnt[2]_i_4__0 
       (.I0(\cnt[4]_i_18__0_n_0 ),
        .I1(cnt[1]),
        .I2(\n0q_m_reg_n_0_[1] ),
        .I3(\n1q_m_reg_n_0_[1] ),
        .I4(\q_m_reg_reg_n_0_[8] ),
        .O(\cnt[2]_i_4__0_n_0 ));
  LUT6 #(
    .INIT(64'h000002A2AAAA02A2)) 
    \cnt[3]_i_1__0 
       (.I0(de_reg),
        .I1(\cnt[3]_i_2__0_n_0 ),
        .I2(\cnt[4]_i_3__0_n_0 ),
        .I3(\cnt[3]_i_3__0_n_0 ),
        .I4(\cnt[4]_i_5__0_n_0 ),
        .I5(\cnt[3]_i_4__0_n_0 ),
        .O(\cnt[3]_i_1__0_n_0 ));
  LUT6 #(
    .INIT(64'h7F0180FE80FE7F01)) 
    \cnt[3]_i_2__0 
       (.I0(\cnt[3]_i_5__0_n_0 ),
        .I1(cnt[1]),
        .I2(\n1q_m_reg_n_0_[1] ),
        .I3(\cnt[4]_i_9__0_n_0 ),
        .I4(\cnt[4]_i_11__1_n_0 ),
        .I5(\cnt[4]_i_12__0_n_0 ),
        .O(\cnt[3]_i_2__0_n_0 ));
  LUT6 #(
    .INIT(64'h10515175EFAEAE8A)) 
    \cnt[3]_i_3__0 
       (.I0(\cnt[4]_i_18__0_n_0 ),
        .I1(\q_m_reg_reg_n_0_[8] ),
        .I2(\n1q_m_reg_n_0_[1] ),
        .I3(\n0q_m_reg_n_0_[1] ),
        .I4(cnt[1]),
        .I5(\cnt[3]_i_6__0_n_0 ),
        .O(\cnt[3]_i_3__0_n_0 ));
  LUT6 #(
    .INIT(64'hB2BA4D454D45B2BA)) 
    \cnt[3]_i_4__0 
       (.I0(\cnt[4]_i_18__0_n_0 ),
        .I1(\cnt[3]_i_7__0_n_0 ),
        .I2(cnt[1]),
        .I3(\cnt[1]_i_3__0_n_0 ),
        .I4(\cnt[4]_i_25__0_n_0 ),
        .I5(\cnt[4]_i_19__0_n_0 ),
        .O(\cnt[3]_i_4__0_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \cnt[3]_i_5__0 
       (.I0(\n0q_m_reg_n_0_[1] ),
        .I1(\q_m_reg_reg_n_0_[8] ),
        .O(\cnt[3]_i_5__0_n_0 ));
  LUT6 #(
    .INIT(64'h6996696996966996)) 
    \cnt[3]_i_6__0 
       (.I0(\n1q_m_reg_n_0_[3] ),
        .I1(\n0q_m_reg_n_0_[3] ),
        .I2(cnt[3]),
        .I3(cnt[2]),
        .I4(\n1q_m_reg_n_0_[2] ),
        .I5(\n0q_m_reg_n_0_[2] ),
        .O(\cnt[3]_i_6__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair32" *) 
  LUT3 #(
    .INIT(8'hE7)) 
    \cnt[3]_i_7__0 
       (.I0(\q_m_reg_reg_n_0_[8] ),
        .I1(\n1q_m_reg_n_0_[1] ),
        .I2(\n0q_m_reg_n_0_[1] ),
        .O(\cnt[3]_i_7__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair31" *) 
  LUT4 #(
    .INIT(16'h2800)) 
    \cnt[4]_i_10 
       (.I0(cnt[1]),
        .I1(\n0q_m_reg_n_0_[1] ),
        .I2(\q_m_reg_reg_n_0_[8] ),
        .I3(\n1q_m_reg_n_0_[1] ),
        .O(\cnt[4]_i_10_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair18" *) 
  LUT5 #(
    .INIT(32'h4BB4B44B)) 
    \cnt[4]_i_11__1 
       (.I0(\n1q_m_reg_n_0_[2] ),
        .I1(\n0q_m_reg_n_0_[2] ),
        .I2(\n1q_m_reg_n_0_[3] ),
        .I3(\n0q_m_reg_n_0_[3] ),
        .I4(cnt[3]),
        .O(\cnt[4]_i_11__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair23" *) 
  LUT5 #(
    .INIT(32'hB0FBFBB0)) 
    \cnt[4]_i_12__0 
       (.I0(\q_m_reg_reg_n_0_[8] ),
        .I1(\n0q_m_reg_n_0_[1] ),
        .I2(cnt[2]),
        .I3(\n0q_m_reg_n_0_[2] ),
        .I4(\n1q_m_reg_n_0_[2] ),
        .O(\cnt[4]_i_12__0_n_0 ));
  LUT6 #(
    .INIT(64'h2202FF0F00002202)) 
    \cnt[4]_i_13__0 
       (.I0(\n0q_m_reg_n_0_[1] ),
        .I1(\n1q_m_reg_n_0_[1] ),
        .I2(\n1q_m_reg_n_0_[3] ),
        .I3(\n0q_m_reg_n_0_[3] ),
        .I4(\n1q_m_reg_n_0_[2] ),
        .I5(\n0q_m_reg_n_0_[2] ),
        .O(\cnt[4]_i_13__0_n_0 ));
  LUT6 #(
    .INIT(64'hBBFB00F0FFFFBBFB)) 
    \cnt[4]_i_14__0 
       (.I0(\n0q_m_reg_n_0_[1] ),
        .I1(\n1q_m_reg_n_0_[1] ),
        .I2(\n0q_m_reg_n_0_[3] ),
        .I3(\n1q_m_reg_n_0_[3] ),
        .I4(\n0q_m_reg_n_0_[2] ),
        .I5(\n1q_m_reg_n_0_[2] ),
        .O(\cnt[4]_i_14__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair17" *) 
  LUT4 #(
    .INIT(16'hA665)) 
    \cnt[4]_i_15__0 
       (.I0(cnt[4]),
        .I1(\n1q_m_reg_n_0_[3] ),
        .I2(\n0q_m_reg_n_0_[3] ),
        .I3(cnt[3]),
        .O(\cnt[4]_i_15__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair22" *) 
  LUT4 #(
    .INIT(16'h4114)) 
    \cnt[4]_i_16__1 
       (.I0(cnt[1]),
        .I1(\q_m_reg_reg_n_0_[8] ),
        .I2(\n0q_m_reg_n_0_[1] ),
        .I3(\n1q_m_reg_n_0_[1] ),
        .O(\cnt[4]_i_16__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair32" *) 
  LUT3 #(
    .INIT(8'hB2)) 
    \cnt[4]_i_17 
       (.I0(\n0q_m_reg_n_0_[1] ),
        .I1(\n1q_m_reg_n_0_[1] ),
        .I2(\q_m_reg_reg_n_0_[8] ),
        .O(\cnt[4]_i_17_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair29" *) 
  LUT3 #(
    .INIT(8'h69)) 
    \cnt[4]_i_18__0 
       (.I0(cnt[2]),
        .I1(\n0q_m_reg_n_0_[2] ),
        .I2(\n1q_m_reg_n_0_[2] ),
        .O(\cnt[4]_i_18__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair18" *) 
  LUT3 #(
    .INIT(8'h96)) 
    \cnt[4]_i_19__0 
       (.I0(cnt[3]),
        .I1(\n0q_m_reg_n_0_[3] ),
        .I2(\n1q_m_reg_n_0_[3] ),
        .O(\cnt[4]_i_19__0_n_0 ));
  LUT6 #(
    .INIT(64'h000002A2AAAA02A2)) 
    \cnt[4]_i_1__0 
       (.I0(de_reg),
        .I1(\cnt[4]_i_2__0_n_0 ),
        .I2(\cnt[4]_i_3__0_n_0 ),
        .I3(\cnt[4]_i_4__0_n_0 ),
        .I4(\cnt[4]_i_5__0_n_0 ),
        .I5(\cnt[4]_i_6__0_n_0 ),
        .O(\cnt[4]_i_1__0_n_0 ));
  LUT3 #(
    .INIT(8'hB2)) 
    \cnt[4]_i_20__0 
       (.I0(\n0q_m_reg_n_0_[2] ),
        .I1(\n1q_m_reg_n_0_[2] ),
        .I2(cnt[2]),
        .O(\cnt[4]_i_20__0_n_0 ));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    \cnt[4]_i_21__0 
       (.I0(\n0q_m_reg_n_0_[1] ),
        .I1(\n1q_m_reg_n_0_[1] ),
        .I2(\n1q_m_reg_n_0_[3] ),
        .I3(\n0q_m_reg_n_0_[3] ),
        .I4(\n1q_m_reg_n_0_[2] ),
        .I5(\n0q_m_reg_n_0_[2] ),
        .O(\cnt[4]_i_21__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair17" *) 
  LUT5 #(
    .INIT(32'hA69A5695)) 
    \cnt[4]_i_22__1 
       (.I0(cnt[4]),
        .I1(\q_m_reg_reg_n_0_[8] ),
        .I2(\n1q_m_reg_n_0_[3] ),
        .I3(\n0q_m_reg_n_0_[3] ),
        .I4(cnt[3]),
        .O(\cnt[4]_i_22__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair30" *) 
  LUT4 #(
    .INIT(16'hFBEF)) 
    \cnt[4]_i_23__0 
       (.I0(cnt[1]),
        .I1(\n0q_m_reg_n_0_[1] ),
        .I2(\n1q_m_reg_n_0_[1] ),
        .I3(\q_m_reg_reg_n_0_[8] ),
        .O(\cnt[4]_i_23__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair30" *) 
  LUT4 #(
    .INIT(16'h2008)) 
    \cnt[4]_i_24__0 
       (.I0(cnt[1]),
        .I1(\n0q_m_reg_n_0_[1] ),
        .I2(\n1q_m_reg_n_0_[1] ),
        .I3(\q_m_reg_reg_n_0_[8] ),
        .O(\cnt[4]_i_24__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair29" *) 
  LUT4 #(
    .INIT(16'hB28E)) 
    \cnt[4]_i_25__0 
       (.I0(cnt[2]),
        .I1(\n0q_m_reg_n_0_[2] ),
        .I2(\n1q_m_reg_n_0_[2] ),
        .I3(\q_m_reg_reg_n_0_[8] ),
        .O(\cnt[4]_i_25__0_n_0 ));
  LUT6 #(
    .INIT(64'h555566A666A6AAAA)) 
    \cnt[4]_i_2__0 
       (.I0(\cnt[4]_i_7__0_n_0 ),
        .I1(\cnt[4]_i_8__0_n_0 ),
        .I2(\cnt[4]_i_9__0_n_0 ),
        .I3(\cnt[4]_i_10_n_0 ),
        .I4(\cnt[4]_i_11__1_n_0 ),
        .I5(\cnt[4]_i_12__0_n_0 ),
        .O(\cnt[4]_i_2__0_n_0 ));
  LUT5 #(
    .INIT(32'h8BC8BBFB)) 
    \cnt[4]_i_3__0 
       (.I0(\cnt[4]_i_13__0_n_0 ),
        .I1(cnt[4]),
        .I2(\n0q_m_reg_n_0_[3] ),
        .I3(\n1q_m_reg_n_0_[3] ),
        .I4(\cnt[4]_i_14__0_n_0 ),
        .O(\cnt[4]_i_3__0_n_0 ));
  LUT6 #(
    .INIT(64'hA665AAAA5555A665)) 
    \cnt[4]_i_4__0 
       (.I0(\cnt[4]_i_15__0_n_0 ),
        .I1(\cnt[4]_i_16__1_n_0 ),
        .I2(\cnt[4]_i_17_n_0 ),
        .I3(\cnt[4]_i_18__0_n_0 ),
        .I4(\cnt[4]_i_19__0_n_0 ),
        .I5(\cnt[4]_i_20__0_n_0 ),
        .O(\cnt[4]_i_4__0_n_0 ));
  LUT5 #(
    .INIT(32'hAAAAAAAB)) 
    \cnt[4]_i_5__0 
       (.I0(\cnt[4]_i_21__0_n_0 ),
        .I1(cnt[2]),
        .I2(cnt[4]),
        .I3(cnt[1]),
        .I4(cnt[3]),
        .O(\cnt[4]_i_5__0_n_0 ));
  LUT6 #(
    .INIT(64'h99955555AAAA9995)) 
    \cnt[4]_i_6__0 
       (.I0(\cnt[4]_i_22__1_n_0 ),
        .I1(\cnt[4]_i_23__0_n_0 ),
        .I2(\cnt[4]_i_24__0_n_0 ),
        .I3(\cnt[4]_i_18__0_n_0 ),
        .I4(\cnt[4]_i_25__0_n_0 ),
        .I5(\cnt[4]_i_19__0_n_0 ),
        .O(\cnt[4]_i_6__0_n_0 ));
  LUT6 #(
    .INIT(64'h4F04FB4FB0FB04B0)) 
    \cnt[4]_i_7__0 
       (.I0(\n1q_m_reg_n_0_[2] ),
        .I1(\n0q_m_reg_n_0_[2] ),
        .I2(cnt[3]),
        .I3(\n0q_m_reg_n_0_[3] ),
        .I4(\n1q_m_reg_n_0_[3] ),
        .I5(cnt[4]),
        .O(\cnt[4]_i_7__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair31" *) 
  LUT4 #(
    .INIT(16'hFFF6)) 
    \cnt[4]_i_8__0 
       (.I0(\q_m_reg_reg_n_0_[8] ),
        .I1(\n0q_m_reg_n_0_[1] ),
        .I2(cnt[1]),
        .I3(\n1q_m_reg_n_0_[1] ),
        .O(\cnt[4]_i_8__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair23" *) 
  LUT5 #(
    .INIT(32'hD22D2DD2)) 
    \cnt[4]_i_9__0 
       (.I0(\n0q_m_reg_n_0_[1] ),
        .I1(\q_m_reg_reg_n_0_[8] ),
        .I2(\n1q_m_reg_n_0_[2] ),
        .I3(\n0q_m_reg_n_0_[2] ),
        .I4(cnt[2]),
        .O(\cnt[4]_i_9__0_n_0 ));
  FDCE \cnt_reg[1] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(reset),
        .D(\cnt[1]_i_1__0_n_0 ),
        .Q(cnt[1]));
  FDCE \cnt_reg[2] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(reset),
        .D(\cnt[2]_i_1__0_n_0 ),
        .Q(cnt[2]));
  FDCE \cnt_reg[3] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(reset),
        .D(\cnt[3]_i_1__0_n_0 ),
        .Q(cnt[3]));
  FDCE \cnt_reg[4] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(reset),
        .D(\cnt[4]_i_1__0_n_0 ),
        .Q(cnt[4]));
  FDRE \din_q_reg[0] 
       (.C(pclk),
        .CE(1'b1),
        .D(video_din[0]),
        .Q(\din_q_reg_n_0_[0] ),
        .R(1'b0));
  FDRE \din_q_reg[1] 
       (.C(pclk),
        .CE(1'b1),
        .D(video_din[1]),
        .Q(p_0_in5_in),
        .R(1'b0));
  FDRE \din_q_reg[2] 
       (.C(pclk),
        .CE(1'b1),
        .D(video_din[2]),
        .Q(p_0_in4_in),
        .R(1'b0));
  FDRE \din_q_reg[3] 
       (.C(pclk),
        .CE(1'b1),
        .D(video_din[3]),
        .Q(p_0_in3_in),
        .R(1'b0));
  FDRE \din_q_reg[4] 
       (.C(pclk),
        .CE(1'b1),
        .D(video_din[4]),
        .Q(p_0_in2_in),
        .R(1'b0));
  FDRE \din_q_reg[5] 
       (.C(pclk),
        .CE(1'b1),
        .D(video_din[5]),
        .Q(p_0_in1_in),
        .R(1'b0));
  FDRE \din_q_reg[6] 
       (.C(pclk),
        .CE(1'b1),
        .D(video_din[6]),
        .Q(p_0_in0_in),
        .R(1'b0));
  FDRE \din_q_reg[7] 
       (.C(pclk),
        .CE(1'b1),
        .D(video_din[7]),
        .Q(p_0_in),
        .R(1'b0));
  (* SOFT_HLUTNM = "soft_lutpair20" *) 
  LUT5 #(
    .INIT(32'h88282228)) 
    \dout[0]_i_1__0 
       (.I0(de_reg),
        .I1(\q_m_reg_reg_n_0_[0] ),
        .I2(\cnt[4]_i_3__0_n_0 ),
        .I3(\cnt[4]_i_5__0_n_0 ),
        .I4(\q_m_reg_reg_n_0_[8] ),
        .O(\dout[0]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair21" *) 
  LUT5 #(
    .INIT(32'h88282228)) 
    \dout[1]_i_1__0 
       (.I0(de_reg),
        .I1(\q_m_reg_reg_n_0_[1] ),
        .I2(\cnt[4]_i_3__0_n_0 ),
        .I3(\cnt[4]_i_5__0_n_0 ),
        .I4(\q_m_reg_reg_n_0_[8] ),
        .O(\dout[1]_i_1__0_n_0 ));
  LUT5 #(
    .INIT(32'hD5DF7F75)) 
    \dout[2]_i_1__0 
       (.I0(de_reg),
        .I1(\q_m_reg_reg_n_0_[8] ),
        .I2(\cnt[4]_i_5__0_n_0 ),
        .I3(\cnt[4]_i_3__0_n_0 ),
        .I4(\q_m_reg_reg_n_0_[2] ),
        .O(\dout[2]_i_1__0_n_0 ));
  LUT5 #(
    .INIT(32'h88282228)) 
    \dout[3]_i_1__0 
       (.I0(de_reg),
        .I1(\q_m_reg_reg_n_0_[3] ),
        .I2(\cnt[4]_i_3__0_n_0 ),
        .I3(\cnt[4]_i_5__0_n_0 ),
        .I4(\q_m_reg_reg_n_0_[8] ),
        .O(\dout[3]_i_1__0_n_0 ));
  LUT5 #(
    .INIT(32'hD5DF7F75)) 
    \dout[4]_i_1__0 
       (.I0(de_reg),
        .I1(\q_m_reg_reg_n_0_[8] ),
        .I2(\cnt[4]_i_5__0_n_0 ),
        .I3(\cnt[4]_i_3__0_n_0 ),
        .I4(\q_m_reg_reg_n_0_[4] ),
        .O(\dout[4]_i_1__0_n_0 ));
  LUT5 #(
    .INIT(32'h88282228)) 
    \dout[5]_i_1__0 
       (.I0(de_reg),
        .I1(\q_m_reg_reg_n_0_[5] ),
        .I2(\cnt[4]_i_3__0_n_0 ),
        .I3(\cnt[4]_i_5__0_n_0 ),
        .I4(\q_m_reg_reg_n_0_[8] ),
        .O(\dout[5]_i_1__0_n_0 ));
  LUT5 #(
    .INIT(32'hD5DF7F75)) 
    \dout[6]_i_1__0 
       (.I0(de_reg),
        .I1(\q_m_reg_reg_n_0_[8] ),
        .I2(\cnt[4]_i_5__0_n_0 ),
        .I3(\cnt[4]_i_3__0_n_0 ),
        .I4(\q_m_reg_reg_n_0_[6] ),
        .O(\dout[6]_i_1__0_n_0 ));
  LUT5 #(
    .INIT(32'h88282228)) 
    \dout[7]_i_1__0 
       (.I0(de_reg),
        .I1(\q_m_reg_reg_n_0_[7] ),
        .I2(\cnt[4]_i_3__0_n_0 ),
        .I3(\cnt[4]_i_5__0_n_0 ),
        .I4(\q_m_reg_reg_n_0_[8] ),
        .O(\dout[7]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair21" *) 
  LUT2 #(
    .INIT(4'hB)) 
    \dout[8]_i_1__0 
       (.I0(\q_m_reg_reg_n_0_[8] ),
        .I1(de_reg),
        .O(\dout[8]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair20" *) 
  LUT4 #(
    .INIT(16'h5DFD)) 
    \dout[9]_i_1__0 
       (.I0(de_reg),
        .I1(\cnt[4]_i_3__0_n_0 ),
        .I2(\cnt[4]_i_5__0_n_0 ),
        .I3(\q_m_reg_reg_n_0_[8] ),
        .O(\dout[9]_i_1__0_n_0 ));
  FDCE \dout_reg[0] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(reset),
        .D(\dout[0]_i_1__0_n_0 ),
        .Q(Q[0]));
  FDCE \dout_reg[1] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(reset),
        .D(\dout[1]_i_1__0_n_0 ),
        .Q(Q[1]));
  FDCE \dout_reg[2] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(reset),
        .D(\dout[2]_i_1__0_n_0 ),
        .Q(Q[2]));
  FDCE \dout_reg[3] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(reset),
        .D(\dout[3]_i_1__0_n_0 ),
        .Q(Q[3]));
  FDCE \dout_reg[4] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(reset),
        .D(\dout[4]_i_1__0_n_0 ),
        .Q(Q[4]));
  FDCE \dout_reg[5] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(reset),
        .D(\dout[5]_i_1__0_n_0 ),
        .Q(Q[5]));
  FDCE \dout_reg[6] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(reset),
        .D(\dout[6]_i_1__0_n_0 ),
        .Q(Q[6]));
  FDCE \dout_reg[7] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(reset),
        .D(\dout[7]_i_1__0_n_0 ),
        .Q(Q[7]));
  FDCE \dout_reg[8] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(reset),
        .D(\dout[8]_i_1__0_n_0 ),
        .Q(Q[8]));
  FDCE \dout_reg[9] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(reset),
        .D(\dout[9]_i_1__0_n_0 ),
        .Q(Q[9]));
  LUT6 #(
    .INIT(64'h9996699996669996)) 
    \n0q_m[1]_i_1__0 
       (.I0(\n1q_m[3]_i_3__0_n_0 ),
        .I1(\n1q_m[3]_i_2__0_n_0 ),
        .I2(\n1q_m[3]_i_5__0_n_0 ),
        .I3(\n1q_m[3]_i_4__0_n_0 ),
        .I4(\din_q_reg_n_0_[0] ),
        .I5(\n1q_m[3]_i_6__0_n_0 ),
        .O(\n0q_m[1]_i_1__0_n_0 ));
  LUT6 #(
    .INIT(64'h2000FBB2FBB2DFFF)) 
    \n0q_m[2]_i_1__0 
       (.I0(\n1q_m[3]_i_6__0_n_0 ),
        .I1(\din_q_reg_n_0_[0] ),
        .I2(\n1q_m[3]_i_4__0_n_0 ),
        .I3(\n1q_m[3]_i_5__0_n_0 ),
        .I4(\n1q_m[3]_i_2__0_n_0 ),
        .I5(\n1q_m[3]_i_3__0_n_0 ),
        .O(\n0q_m[2]_i_1__0_n_0 ));
  LUT6 #(
    .INIT(64'h0100000000000000)) 
    \n0q_m[3]_i_1__0 
       (.I0(\n1q_m[3]_i_2__0_n_0 ),
        .I1(\n1q_m[3]_i_3__0_n_0 ),
        .I2(\din_q_reg_n_0_[0] ),
        .I3(\n1q_m[3]_i_4__0_n_0 ),
        .I4(\n1q_m[3]_i_5__0_n_0 ),
        .I5(\n1q_m[3]_i_6__0_n_0 ),
        .O(\n0q_m[3]_i_1__0_n_0 ));
  FDRE \n0q_m_reg[1] 
       (.C(pclk),
        .CE(1'b1),
        .D(\n0q_m[1]_i_1__0_n_0 ),
        .Q(\n0q_m_reg_n_0_[1] ),
        .R(1'b0));
  FDRE \n0q_m_reg[2] 
       (.C(pclk),
        .CE(1'b1),
        .D(\n0q_m[2]_i_1__0_n_0 ),
        .Q(\n0q_m_reg_n_0_[2] ),
        .R(1'b0));
  FDRE \n0q_m_reg[3] 
       (.C(pclk),
        .CE(1'b1),
        .D(\n0q_m[3]_i_1__0_n_0 ),
        .Q(\n0q_m_reg_n_0_[3] ),
        .R(1'b0));
  LUT6 #(
    .INIT(64'h6996966996696996)) 
    \n1d[0]_i_1 
       (.I0(video_din[0]),
        .I1(video_din[7]),
        .I2(\n1d[0]_i_2_n_0 ),
        .I3(video_din[2]),
        .I4(video_din[1]),
        .I5(video_din[3]),
        .O(\n1d[0]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair24" *) 
  LUT3 #(
    .INIT(8'h96)) 
    \n1d[0]_i_2 
       (.I0(video_din[6]),
        .I1(video_din[4]),
        .I2(video_din[5]),
        .O(\n1d[0]_i_2_n_0 ));
  LUT3 #(
    .INIT(8'h96)) 
    \n1d[1]_i_1 
       (.I0(\n1d[3]_i_2_n_0 ),
        .I1(\n1d[1]_i_2_n_0 ),
        .I2(\n1d[3]_i_3_n_0 ),
        .O(\n1d[1]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h171717E817E8E8E8)) 
    \n1d[1]_i_2 
       (.I0(video_din[3]),
        .I1(video_din[2]),
        .I2(video_din[1]),
        .I3(video_din[6]),
        .I4(video_din[5]),
        .I5(video_din[4]),
        .O(\n1d[1]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h7E7E7EE87EE8E8E8)) 
    \n1d[2]_i_1 
       (.I0(\n1d[3]_i_2_n_0 ),
        .I1(\n1d[3]_i_3_n_0 ),
        .I2(\n1d[2]_i_2_n_0 ),
        .I3(video_din[4]),
        .I4(video_din[5]),
        .I5(video_din[6]),
        .O(\n1d[2]_i_1_n_0 ));
  LUT3 #(
    .INIT(8'hE8)) 
    \n1d[2]_i_2 
       (.I0(video_din[1]),
        .I1(video_din[2]),
        .I2(video_din[3]),
        .O(\n1d[2]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h8880800000000000)) 
    \n1d[3]_i_1 
       (.I0(\n1d[3]_i_2_n_0 ),
        .I1(\n1d[3]_i_3_n_0 ),
        .I2(video_din[3]),
        .I3(video_din[2]),
        .I4(video_din[1]),
        .I5(\n1d[3]_i_4_n_0 ),
        .O(\n1d[3]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h9600009600969600)) 
    \n1d[3]_i_2 
       (.I0(video_din[2]),
        .I1(video_din[1]),
        .I2(video_din[3]),
        .I3(video_din[0]),
        .I4(video_din[7]),
        .I5(\n1d[0]_i_2_n_0 ),
        .O(\n1d[3]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair24" *) 
  LUT5 #(
    .INIT(32'hE88E8EE8)) 
    \n1d[3]_i_3 
       (.I0(video_din[7]),
        .I1(video_din[0]),
        .I2(video_din[5]),
        .I3(video_din[4]),
        .I4(video_din[6]),
        .O(\n1d[3]_i_3_n_0 ));
  LUT3 #(
    .INIT(8'hE8)) 
    \n1d[3]_i_4 
       (.I0(video_din[4]),
        .I1(video_din[5]),
        .I2(video_din[6]),
        .O(\n1d[3]_i_4_n_0 ));
  FDRE \n1d_reg[0] 
       (.C(pclk),
        .CE(1'b1),
        .D(\n1d[0]_i_1_n_0 ),
        .Q(n1d[0]),
        .R(1'b0));
  FDRE \n1d_reg[1] 
       (.C(pclk),
        .CE(1'b1),
        .D(\n1d[1]_i_1_n_0 ),
        .Q(n1d[1]),
        .R(1'b0));
  FDRE \n1d_reg[2] 
       (.C(pclk),
        .CE(1'b1),
        .D(\n1d[2]_i_1_n_0 ),
        .Q(n1d[2]),
        .R(1'b0));
  FDRE \n1d_reg[3] 
       (.C(pclk),
        .CE(1'b1),
        .D(\n1d[3]_i_1_n_0 ),
        .Q(n1d[3]),
        .R(1'b0));
  LUT6 #(
    .INIT(64'h6696969996999969)) 
    \n1q_m[1]_i_1__0 
       (.I0(\n1q_m[3]_i_2__0_n_0 ),
        .I1(\n1q_m[3]_i_3__0_n_0 ),
        .I2(\din_q_reg_n_0_[0] ),
        .I3(\n1q_m[3]_i_4__0_n_0 ),
        .I4(\n1q_m[3]_i_5__0_n_0 ),
        .I5(\n1q_m[3]_i_6__0_n_0 ),
        .O(\n1q_m[1]_i_1__0_n_0 ));
  LUT6 #(
    .INIT(64'hFFEF71F771F70010)) 
    \n1q_m[2]_i_1__0 
       (.I0(\n1q_m[3]_i_5__0_n_0 ),
        .I1(\n1q_m[3]_i_4__0_n_0 ),
        .I2(\din_q_reg_n_0_[0] ),
        .I3(\n1q_m[3]_i_6__0_n_0 ),
        .I4(\n1q_m[3]_i_3__0_n_0 ),
        .I5(\n1q_m[3]_i_2__0_n_0 ),
        .O(\n1q_m[2]_i_1__0_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000000080)) 
    \n1q_m[3]_i_1__0 
       (.I0(\n1q_m[3]_i_2__0_n_0 ),
        .I1(\n1q_m[3]_i_3__0_n_0 ),
        .I2(\din_q_reg_n_0_[0] ),
        .I3(\n1q_m[3]_i_4__0_n_0 ),
        .I4(\n1q_m[3]_i_5__0_n_0 ),
        .I5(\n1q_m[3]_i_6__0_n_0 ),
        .O(\n1q_m[3]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair25" *) 
  LUT5 #(
    .INIT(32'hB42D4BD2)) 
    \n1q_m[3]_i_2__0 
       (.I0(\q_m_reg[7]_i_2__0_n_0 ),
        .I1(p_0_in3_in),
        .I2(\din_q_reg_n_0_[0] ),
        .I3(p_0_in4_in),
        .I4(p_0_in5_in),
        .O(\n1q_m[3]_i_2__0_n_0 ));
  LUT6 #(
    .INIT(64'hE11E1EE178878778)) 
    \n1q_m[3]_i_3__0 
       (.I0(p_0_in0_in),
        .I1(\q_m_reg[7]_i_2__0_n_0 ),
        .I2(q_m_2),
        .I3(p_0_in2_in),
        .I4(p_0_in3_in),
        .I5(p_0_in1_in),
        .O(\n1q_m[3]_i_3__0_n_0 ));
  LUT6 #(
    .INIT(64'h9669699669969669)) 
    \n1q_m[3]_i_4__0 
       (.I0(p_0_in3_in),
        .I1(p_0_in2_in),
        .I2(\din_q_reg_n_0_[0] ),
        .I3(p_0_in4_in),
        .I4(p_0_in5_in),
        .I5(\n1q_m[3]_i_7__0_n_0 ),
        .O(\n1q_m[3]_i_4__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair26" *) 
  LUT5 #(
    .INIT(32'h96696996)) 
    \n1q_m[3]_i_5__0 
       (.I0(p_0_in0_in),
        .I1(\q_m_reg[7]_i_3__0_n_0 ),
        .I2(p_0_in1_in),
        .I3(\q_m_reg[7]_i_2__0_n_0 ),
        .I4(p_0_in),
        .O(\n1q_m[3]_i_5__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair34" *) 
  LUT3 #(
    .INIT(8'h69)) 
    \n1q_m[3]_i_6__0 
       (.I0(\din_q_reg_n_0_[0] ),
        .I1(p_0_in5_in),
        .I2(p_0_in3_in),
        .O(\n1q_m[3]_i_6__0_n_0 ));
  LUT6 #(
    .INIT(64'h5555555566666A66)) 
    \n1q_m[3]_i_7__0 
       (.I0(p_0_in0_in),
        .I1(n1d[2]),
        .I2(n1d[0]),
        .I3(\din_q_reg_n_0_[0] ),
        .I4(n1d[1]),
        .I5(n1d[3]),
        .O(\n1q_m[3]_i_7__0_n_0 ));
  FDRE \n1q_m_reg[1] 
       (.C(pclk),
        .CE(1'b1),
        .D(\n1q_m[1]_i_1__0_n_0 ),
        .Q(\n1q_m_reg_n_0_[1] ),
        .R(1'b0));
  FDRE \n1q_m_reg[2] 
       (.C(pclk),
        .CE(1'b1),
        .D(\n1q_m[2]_i_1__0_n_0 ),
        .Q(\n1q_m_reg_n_0_[2] ),
        .R(1'b0));
  FDRE \n1q_m_reg[3] 
       (.C(pclk),
        .CE(1'b1),
        .D(\n1q_m[3]_i_1__0_n_0 ),
        .Q(\n1q_m_reg_n_0_[3] ),
        .R(1'b0));
  LUT6 #(
    .INIT(64'hFFA800570055FFAA)) 
    \q_m_reg[1]_i_1__0 
       (.I0(n1d[2]),
        .I1(n1d[0]),
        .I2(n1d[1]),
        .I3(n1d[3]),
        .I4(p_0_in5_in),
        .I5(\din_q_reg_n_0_[0] ),
        .O(q_m_1));
  (* SOFT_HLUTNM = "soft_lutpair34" *) 
  LUT3 #(
    .INIT(8'h96)) 
    \q_m_reg[2]_i_1__0 
       (.I0(\din_q_reg_n_0_[0] ),
        .I1(p_0_in4_in),
        .I2(p_0_in5_in),
        .O(q_m_2));
  (* SOFT_HLUTNM = "soft_lutpair25" *) 
  LUT5 #(
    .INIT(32'h96696996)) 
    \q_m_reg[3]_i_1__0 
       (.I0(p_0_in5_in),
        .I1(p_0_in4_in),
        .I2(\din_q_reg_n_0_[0] ),
        .I3(p_0_in3_in),
        .I4(\q_m_reg[7]_i_2__0_n_0 ),
        .O(q_m_3));
  (* SOFT_HLUTNM = "soft_lutpair28" *) 
  LUT5 #(
    .INIT(32'h96696996)) 
    \q_m_reg[4]_i_1__0 
       (.I0(p_0_in3_in),
        .I1(p_0_in2_in),
        .I2(\din_q_reg_n_0_[0] ),
        .I3(p_0_in4_in),
        .I4(p_0_in5_in),
        .O(q_m_4));
  LUT5 #(
    .INIT(32'h96696996)) 
    \q_m_reg[5]_i_1__0 
       (.I0(\q_m_reg[7]_i_2__0_n_0 ),
        .I1(q_m_2),
        .I2(p_0_in2_in),
        .I3(p_0_in3_in),
        .I4(p_0_in1_in),
        .O(\q_m_reg[5]_i_1__0_n_0 ));
  LUT5 #(
    .INIT(32'h96696996)) 
    \q_m_reg[6]_i_1__0 
       (.I0(p_0_in1_in),
        .I1(p_0_in3_in),
        .I2(p_0_in2_in),
        .I3(q_m_2),
        .I4(p_0_in0_in),
        .O(q_m_6));
  (* SOFT_HLUTNM = "soft_lutpair26" *) 
  LUT5 #(
    .INIT(32'h69969669)) 
    \q_m_reg[7]_i_1__0 
       (.I0(p_0_in),
        .I1(\q_m_reg[7]_i_2__0_n_0 ),
        .I2(p_0_in1_in),
        .I3(\q_m_reg[7]_i_3__0_n_0 ),
        .I4(p_0_in0_in),
        .O(\q_m_reg[7]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair27" *) 
  LUT5 #(
    .INIT(32'hFFEFAAAA)) 
    \q_m_reg[7]_i_2__0 
       (.I0(n1d[3]),
        .I1(n1d[1]),
        .I2(\din_q_reg_n_0_[0] ),
        .I3(n1d[0]),
        .I4(n1d[2]),
        .O(\q_m_reg[7]_i_2__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair28" *) 
  LUT5 #(
    .INIT(32'h69969669)) 
    \q_m_reg[7]_i_3__0 
       (.I0(p_0_in5_in),
        .I1(p_0_in4_in),
        .I2(\din_q_reg_n_0_[0] ),
        .I3(p_0_in2_in),
        .I4(p_0_in3_in),
        .O(\q_m_reg[7]_i_3__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair27" *) 
  LUT5 #(
    .INIT(32'h00005575)) 
    \q_m_reg[8]_i_1__0 
       (.I0(n1d[2]),
        .I1(n1d[0]),
        .I2(\din_q_reg_n_0_[0] ),
        .I3(n1d[1]),
        .I4(n1d[3]),
        .O(\q_m_reg[8]_i_1__0_n_0 ));
  FDRE \q_m_reg_reg[0] 
       (.C(pclk),
        .CE(1'b1),
        .D(\din_q_reg_n_0_[0] ),
        .Q(\q_m_reg_reg_n_0_[0] ),
        .R(1'b0));
  FDRE \q_m_reg_reg[1] 
       (.C(pclk),
        .CE(1'b1),
        .D(q_m_1),
        .Q(\q_m_reg_reg_n_0_[1] ),
        .R(1'b0));
  FDRE \q_m_reg_reg[2] 
       (.C(pclk),
        .CE(1'b1),
        .D(q_m_2),
        .Q(\q_m_reg_reg_n_0_[2] ),
        .R(1'b0));
  FDRE \q_m_reg_reg[3] 
       (.C(pclk),
        .CE(1'b1),
        .D(q_m_3),
        .Q(\q_m_reg_reg_n_0_[3] ),
        .R(1'b0));
  FDRE \q_m_reg_reg[4] 
       (.C(pclk),
        .CE(1'b1),
        .D(q_m_4),
        .Q(\q_m_reg_reg_n_0_[4] ),
        .R(1'b0));
  FDRE \q_m_reg_reg[5] 
       (.C(pclk),
        .CE(1'b1),
        .D(\q_m_reg[5]_i_1__0_n_0 ),
        .Q(\q_m_reg_reg_n_0_[5] ),
        .R(1'b0));
  FDRE \q_m_reg_reg[6] 
       (.C(pclk),
        .CE(1'b1),
        .D(q_m_6),
        .Q(\q_m_reg_reg_n_0_[6] ),
        .R(1'b0));
  FDRE \q_m_reg_reg[7] 
       (.C(pclk),
        .CE(1'b1),
        .D(\q_m_reg[7]_i_1__0_n_0 ),
        .Q(\q_m_reg_reg_n_0_[7] ),
        .R(1'b0));
  FDRE \q_m_reg_reg[8] 
       (.C(pclk),
        .CE(1'b1),
        .D(\q_m_reg[8]_i_1__0_n_0 ),
        .Q(\q_m_reg_reg_n_0_[8] ),
        .R(1'b0));
endmodule

(* ORIG_REF_NAME = "dvi_encoder" *) 
module system_DVI_Transmitter_Safe_0_0_dvi_encoder_1
   (Q,
    pclk,
    de_reg,
    video_din,
    reset);
  output [9:0]Q;
  input pclk;
  input de_reg;
  input [7:0]video_din;
  input reset;

  wire [9:0]Q;
  wire [4:1]cnt;
  wire \cnt[1]_i_1__1_n_0 ;
  wire \cnt[1]_i_2__1_n_0 ;
  wire \cnt[1]_i_3__1_n_0 ;
  wire \cnt[2]_i_1__1_n_0 ;
  wire \cnt[2]_i_2__1_n_0 ;
  wire \cnt[2]_i_3__1_n_0 ;
  wire \cnt[2]_i_4__1_n_0 ;
  wire \cnt[3]_i_1__1_n_0 ;
  wire \cnt[3]_i_2__1_n_0 ;
  wire \cnt[3]_i_3__1_n_0 ;
  wire \cnt[3]_i_4__1_n_0 ;
  wire \cnt[3]_i_5__1_n_0 ;
  wire \cnt[3]_i_6__1_n_0 ;
  wire \cnt[3]_i_7__1_n_0 ;
  wire \cnt[4]_i_10__0_n_0 ;
  wire \cnt[4]_i_11__0_n_0 ;
  wire \cnt[4]_i_12__1_n_0 ;
  wire \cnt[4]_i_13__1_n_0 ;
  wire \cnt[4]_i_14__1_n_0 ;
  wire \cnt[4]_i_15__1_n_0 ;
  wire \cnt[4]_i_16__0_n_0 ;
  wire \cnt[4]_i_17__0_n_0 ;
  wire \cnt[4]_i_18__1_n_0 ;
  wire \cnt[4]_i_19__1_n_0 ;
  wire \cnt[4]_i_1__1_n_0 ;
  wire \cnt[4]_i_20__1_n_0 ;
  wire \cnt[4]_i_21__1_n_0 ;
  wire \cnt[4]_i_22__0_n_0 ;
  wire \cnt[4]_i_23__1_n_0 ;
  wire \cnt[4]_i_24__1_n_0 ;
  wire \cnt[4]_i_25__1_n_0 ;
  wire \cnt[4]_i_2__1_n_0 ;
  wire \cnt[4]_i_3__1_n_0 ;
  wire \cnt[4]_i_4__1_n_0 ;
  wire \cnt[4]_i_5__1_n_0 ;
  wire \cnt[4]_i_6__1_n_0 ;
  wire \cnt[4]_i_7__1_n_0 ;
  wire \cnt[4]_i_8__1_n_0 ;
  wire \cnt[4]_i_9__1_n_0 ;
  wire de_reg;
  wire \din_q_reg_n_0_[0] ;
  wire \dout[0]_i_1__1_n_0 ;
  wire \dout[1]_i_1__1_n_0 ;
  wire \dout[2]_i_1__1_n_0 ;
  wire \dout[3]_i_1__1_n_0 ;
  wire \dout[4]_i_1__1_n_0 ;
  wire \dout[5]_i_1__1_n_0 ;
  wire \dout[6]_i_1__1_n_0 ;
  wire \dout[7]_i_1__1_n_0 ;
  wire \dout[8]_i_1__1_n_0 ;
  wire \dout[9]_i_1__1_n_0 ;
  wire \n0q_m[1]_i_1__1_n_0 ;
  wire \n0q_m[2]_i_1__1_n_0 ;
  wire \n0q_m[3]_i_1__1_n_0 ;
  wire \n0q_m_reg_n_0_[1] ;
  wire \n0q_m_reg_n_0_[2] ;
  wire \n0q_m_reg_n_0_[3] ;
  wire [3:0]n1d;
  wire \n1d[0]_i_1_n_0 ;
  wire \n1d[0]_i_2_n_0 ;
  wire \n1d[1]_i_1_n_0 ;
  wire \n1d[1]_i_2_n_0 ;
  wire \n1d[2]_i_1_n_0 ;
  wire \n1d[2]_i_2_n_0 ;
  wire \n1d[3]_i_1_n_0 ;
  wire \n1d[3]_i_2_n_0 ;
  wire \n1d[3]_i_3_n_0 ;
  wire \n1d[3]_i_4_n_0 ;
  wire \n1q_m[1]_i_1__1_n_0 ;
  wire \n1q_m[2]_i_1__1_n_0 ;
  wire \n1q_m[3]_i_1__1_n_0 ;
  wire \n1q_m[3]_i_2__1_n_0 ;
  wire \n1q_m[3]_i_3__1_n_0 ;
  wire \n1q_m[3]_i_4__1_n_0 ;
  wire \n1q_m[3]_i_5__1_n_0 ;
  wire \n1q_m[3]_i_6__1_n_0 ;
  wire \n1q_m[3]_i_7__1_n_0 ;
  wire \n1q_m_reg_n_0_[1] ;
  wire \n1q_m_reg_n_0_[2] ;
  wire \n1q_m_reg_n_0_[3] ;
  wire p_0_in;
  wire p_0_in0_in;
  wire p_0_in1_in;
  wire p_0_in2_in;
  wire p_0_in3_in;
  wire p_0_in4_in;
  wire p_0_in5_in;
  wire pclk;
  wire q_m_1;
  wire q_m_2;
  wire q_m_3;
  wire q_m_4;
  wire q_m_6;
  wire \q_m_reg[5]_i_1__1_n_0 ;
  wire \q_m_reg[7]_i_1__1_n_0 ;
  wire \q_m_reg[7]_i_2__1_n_0 ;
  wire \q_m_reg[7]_i_3__1_n_0 ;
  wire \q_m_reg[8]_i_1__1_n_0 ;
  wire \q_m_reg_reg_n_0_[0] ;
  wire \q_m_reg_reg_n_0_[1] ;
  wire \q_m_reg_reg_n_0_[2] ;
  wire \q_m_reg_reg_n_0_[3] ;
  wire \q_m_reg_reg_n_0_[4] ;
  wire \q_m_reg_reg_n_0_[5] ;
  wire \q_m_reg_reg_n_0_[6] ;
  wire \q_m_reg_reg_n_0_[7] ;
  wire \q_m_reg_reg_n_0_[8] ;
  wire reset;
  wire [7:0]video_din;

  LUT6 #(
    .INIT(64'h0A0A8228A0A08228)) 
    \cnt[1]_i_1__1 
       (.I0(de_reg),
        .I1(\cnt[4]_i_3__1_n_0 ),
        .I2(cnt[1]),
        .I3(\cnt[1]_i_2__1_n_0 ),
        .I4(\cnt[4]_i_5__1_n_0 ),
        .I5(\cnt[1]_i_3__1_n_0 ),
        .O(\cnt[1]_i_1__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair51" *) 
  LUT3 #(
    .INIT(8'h69)) 
    \cnt[1]_i_2__1 
       (.I0(\n1q_m_reg_n_0_[1] ),
        .I1(\n0q_m_reg_n_0_[1] ),
        .I2(\q_m_reg_reg_n_0_[8] ),
        .O(\cnt[1]_i_2__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair51" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \cnt[1]_i_3__1 
       (.I0(\n1q_m_reg_n_0_[1] ),
        .I1(\n0q_m_reg_n_0_[1] ),
        .O(\cnt[1]_i_3__1_n_0 ));
  LUT6 #(
    .INIT(64'h000002A2AAAA02A2)) 
    \cnt[2]_i_1__1 
       (.I0(de_reg),
        .I1(\cnt[2]_i_2__1_n_0 ),
        .I2(\cnt[4]_i_3__1_n_0 ),
        .I3(\cnt[2]_i_3__1_n_0 ),
        .I4(\cnt[4]_i_5__1_n_0 ),
        .I5(\cnt[2]_i_4__1_n_0 ),
        .O(\cnt[2]_i_1__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair39" *) 
  LUT5 #(
    .INIT(32'hA69A9A59)) 
    \cnt[2]_i_2__1 
       (.I0(\cnt[4]_i_19__1_n_0 ),
        .I1(cnt[1]),
        .I2(\n0q_m_reg_n_0_[1] ),
        .I3(\q_m_reg_reg_n_0_[8] ),
        .I4(\n1q_m_reg_n_0_[1] ),
        .O(\cnt[2]_i_2__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair35" *) 
  LUT5 #(
    .INIT(32'h71E78E18)) 
    \cnt[2]_i_3__1 
       (.I0(cnt[1]),
        .I1(\n0q_m_reg_n_0_[1] ),
        .I2(\n1q_m_reg_n_0_[1] ),
        .I3(\q_m_reg_reg_n_0_[8] ),
        .I4(\cnt[4]_i_19__1_n_0 ),
        .O(\cnt[2]_i_3__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair35" *) 
  LUT5 #(
    .INIT(32'hA69AA96A)) 
    \cnt[2]_i_4__1 
       (.I0(\cnt[4]_i_19__1_n_0 ),
        .I1(cnt[1]),
        .I2(\n0q_m_reg_n_0_[1] ),
        .I3(\n1q_m_reg_n_0_[1] ),
        .I4(\q_m_reg_reg_n_0_[8] ),
        .O(\cnt[2]_i_4__1_n_0 ));
  LUT6 #(
    .INIT(64'h000002A2AAAA02A2)) 
    \cnt[3]_i_1__1 
       (.I0(de_reg),
        .I1(\cnt[3]_i_2__1_n_0 ),
        .I2(\cnt[4]_i_3__1_n_0 ),
        .I3(\cnt[3]_i_3__1_n_0 ),
        .I4(\cnt[4]_i_5__1_n_0 ),
        .I5(\cnt[3]_i_4__1_n_0 ),
        .O(\cnt[3]_i_1__1_n_0 ));
  LUT6 #(
    .INIT(64'h7F0180FE80FE7F01)) 
    \cnt[3]_i_2__1 
       (.I0(\cnt[3]_i_5__1_n_0 ),
        .I1(cnt[1]),
        .I2(\n1q_m_reg_n_0_[1] ),
        .I3(\cnt[4]_i_10__0_n_0 ),
        .I4(\cnt[4]_i_7__1_n_0 ),
        .I5(\cnt[4]_i_8__1_n_0 ),
        .O(\cnt[3]_i_2__1_n_0 ));
  LUT6 #(
    .INIT(64'h333336336C36CC6C)) 
    \cnt[3]_i_3__1 
       (.I0(cnt[1]),
        .I1(\cnt[3]_i_6__1_n_0 ),
        .I2(\q_m_reg_reg_n_0_[8] ),
        .I3(\n1q_m_reg_n_0_[1] ),
        .I4(\n0q_m_reg_n_0_[1] ),
        .I5(\cnt[4]_i_19__1_n_0 ),
        .O(\cnt[3]_i_3__1_n_0 ));
  LUT6 #(
    .INIT(64'hB2BA4D454D45B2BA)) 
    \cnt[3]_i_4__1 
       (.I0(\cnt[4]_i_19__1_n_0 ),
        .I1(\cnt[3]_i_7__1_n_0 ),
        .I2(cnt[1]),
        .I3(\cnt[1]_i_3__1_n_0 ),
        .I4(\cnt[4]_i_25__1_n_0 ),
        .I5(\cnt[4]_i_16__0_n_0 ),
        .O(\cnt[3]_i_4__1_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \cnt[3]_i_5__1 
       (.I0(\n0q_m_reg_n_0_[1] ),
        .I1(\q_m_reg_reg_n_0_[8] ),
        .O(\cnt[3]_i_5__1_n_0 ));
  LUT6 #(
    .INIT(64'h6969966996699696)) 
    \cnt[3]_i_6__1 
       (.I0(\n1q_m_reg_n_0_[3] ),
        .I1(\n0q_m_reg_n_0_[3] ),
        .I2(cnt[3]),
        .I3(\n1q_m_reg_n_0_[2] ),
        .I4(\n0q_m_reg_n_0_[2] ),
        .I5(cnt[2]),
        .O(\cnt[3]_i_6__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair50" *) 
  LUT3 #(
    .INIT(8'hE7)) 
    \cnt[3]_i_7__1 
       (.I0(\q_m_reg_reg_n_0_[8] ),
        .I1(\n1q_m_reg_n_0_[1] ),
        .I2(\n0q_m_reg_n_0_[1] ),
        .O(\cnt[3]_i_7__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair40" *) 
  LUT5 #(
    .INIT(32'hD22D2DD2)) 
    \cnt[4]_i_10__0 
       (.I0(\n0q_m_reg_n_0_[1] ),
        .I1(\q_m_reg_reg_n_0_[8] ),
        .I2(\n1q_m_reg_n_0_[2] ),
        .I3(\n0q_m_reg_n_0_[2] ),
        .I4(cnt[2]),
        .O(\cnt[4]_i_10__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair49" *) 
  LUT4 #(
    .INIT(16'h2800)) 
    \cnt[4]_i_11__0 
       (.I0(cnt[1]),
        .I1(\n0q_m_reg_n_0_[1] ),
        .I2(\q_m_reg_reg_n_0_[8] ),
        .I3(\n1q_m_reg_n_0_[1] ),
        .O(\cnt[4]_i_11__0_n_0 ));
  LUT6 #(
    .INIT(64'hB0FB04B04F04FB4F)) 
    \cnt[4]_i_12__1 
       (.I0(\n1q_m_reg_n_0_[2] ),
        .I1(\n0q_m_reg_n_0_[2] ),
        .I2(cnt[3]),
        .I3(\n0q_m_reg_n_0_[3] ),
        .I4(\n1q_m_reg_n_0_[3] ),
        .I5(cnt[4]),
        .O(\cnt[4]_i_12__1_n_0 ));
  LUT6 #(
    .INIT(64'h2F022F0200002F02)) 
    \cnt[4]_i_13__1 
       (.I0(\n0q_m_reg_n_0_[1] ),
        .I1(\n1q_m_reg_n_0_[1] ),
        .I2(\n1q_m_reg_n_0_[2] ),
        .I3(\n0q_m_reg_n_0_[2] ),
        .I4(\n1q_m_reg_n_0_[3] ),
        .I5(\n0q_m_reg_n_0_[3] ),
        .O(\cnt[4]_i_13__1_n_0 ));
  LUT6 #(
    .INIT(64'hD0FDD0FDFFFFD0FD)) 
    \cnt[4]_i_14__1 
       (.I0(\n1q_m_reg_n_0_[1] ),
        .I1(\n0q_m_reg_n_0_[1] ),
        .I2(\n0q_m_reg_n_0_[2] ),
        .I3(\n1q_m_reg_n_0_[2] ),
        .I4(\n0q_m_reg_n_0_[3] ),
        .I5(\n1q_m_reg_n_0_[3] ),
        .O(\cnt[4]_i_14__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair41" *) 
  LUT4 #(
    .INIT(16'hA665)) 
    \cnt[4]_i_15__1 
       (.I0(cnt[4]),
        .I1(\n1q_m_reg_n_0_[3] ),
        .I2(\n0q_m_reg_n_0_[3] ),
        .I3(cnt[3]),
        .O(\cnt[4]_i_15__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair36" *) 
  LUT3 #(
    .INIT(8'h96)) 
    \cnt[4]_i_16__0 
       (.I0(cnt[3]),
        .I1(\n0q_m_reg_n_0_[3] ),
        .I2(\n1q_m_reg_n_0_[3] ),
        .O(\cnt[4]_i_16__0_n_0 ));
  LUT3 #(
    .INIT(8'h8E)) 
    \cnt[4]_i_17__0 
       (.I0(cnt[2]),
        .I1(\n0q_m_reg_n_0_[2] ),
        .I2(\n1q_m_reg_n_0_[2] ),
        .O(\cnt[4]_i_17__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair39" *) 
  LUT4 #(
    .INIT(16'h4114)) 
    \cnt[4]_i_18__1 
       (.I0(cnt[1]),
        .I1(\q_m_reg_reg_n_0_[8] ),
        .I2(\n0q_m_reg_n_0_[1] ),
        .I3(\n1q_m_reg_n_0_[1] ),
        .O(\cnt[4]_i_18__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair48" *) 
  LUT3 #(
    .INIT(8'h69)) 
    \cnt[4]_i_19__1 
       (.I0(cnt[2]),
        .I1(\n0q_m_reg_n_0_[2] ),
        .I2(\n1q_m_reg_n_0_[2] ),
        .O(\cnt[4]_i_19__1_n_0 ));
  LUT6 #(
    .INIT(64'h000002A2AAAA02A2)) 
    \cnt[4]_i_1__1 
       (.I0(de_reg),
        .I1(\cnt[4]_i_2__1_n_0 ),
        .I2(\cnt[4]_i_3__1_n_0 ),
        .I3(\cnt[4]_i_4__1_n_0 ),
        .I4(\cnt[4]_i_5__1_n_0 ),
        .I5(\cnt[4]_i_6__1_n_0 ),
        .O(\cnt[4]_i_1__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair50" *) 
  LUT3 #(
    .INIT(8'hB2)) 
    \cnt[4]_i_20__1 
       (.I0(\n0q_m_reg_n_0_[1] ),
        .I1(\n1q_m_reg_n_0_[1] ),
        .I2(\q_m_reg_reg_n_0_[8] ),
        .O(\cnt[4]_i_20__1_n_0 ));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    \cnt[4]_i_21__1 
       (.I0(\n0q_m_reg_n_0_[3] ),
        .I1(\n1q_m_reg_n_0_[3] ),
        .I2(\n1q_m_reg_n_0_[1] ),
        .I3(\n0q_m_reg_n_0_[1] ),
        .I4(\n1q_m_reg_n_0_[2] ),
        .I5(\n0q_m_reg_n_0_[2] ),
        .O(\cnt[4]_i_21__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair41" *) 
  LUT5 #(
    .INIT(32'h5965A96A)) 
    \cnt[4]_i_22__0 
       (.I0(cnt[4]),
        .I1(\q_m_reg_reg_n_0_[8] ),
        .I2(\n1q_m_reg_n_0_[3] ),
        .I3(\n0q_m_reg_n_0_[3] ),
        .I4(cnt[3]),
        .O(\cnt[4]_i_22__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair47" *) 
  LUT4 #(
    .INIT(16'hFBEF)) 
    \cnt[4]_i_23__1 
       (.I0(cnt[1]),
        .I1(\n0q_m_reg_n_0_[1] ),
        .I2(\n1q_m_reg_n_0_[1] ),
        .I3(\q_m_reg_reg_n_0_[8] ),
        .O(\cnt[4]_i_23__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair47" *) 
  LUT4 #(
    .INIT(16'h2008)) 
    \cnt[4]_i_24__1 
       (.I0(cnt[1]),
        .I1(\n0q_m_reg_n_0_[1] ),
        .I2(\n1q_m_reg_n_0_[1] ),
        .I3(\q_m_reg_reg_n_0_[8] ),
        .O(\cnt[4]_i_24__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair48" *) 
  LUT4 #(
    .INIT(16'hB28E)) 
    \cnt[4]_i_25__1 
       (.I0(cnt[2]),
        .I1(\n0q_m_reg_n_0_[2] ),
        .I2(\n1q_m_reg_n_0_[2] ),
        .I3(\q_m_reg_reg_n_0_[8] ),
        .O(\cnt[4]_i_25__1_n_0 ));
  LUT6 #(
    .INIT(64'hE8E888E817177717)) 
    \cnt[4]_i_2__1 
       (.I0(\cnt[4]_i_7__1_n_0 ),
        .I1(\cnt[4]_i_8__1_n_0 ),
        .I2(\cnt[4]_i_9__1_n_0 ),
        .I3(\cnt[4]_i_10__0_n_0 ),
        .I4(\cnt[4]_i_11__0_n_0 ),
        .I5(\cnt[4]_i_12__1_n_0 ),
        .O(\cnt[4]_i_2__1_n_0 ));
  LUT5 #(
    .INIT(32'h8BC8BBFB)) 
    \cnt[4]_i_3__1 
       (.I0(\cnt[4]_i_13__1_n_0 ),
        .I1(cnt[4]),
        .I2(\n0q_m_reg_n_0_[3] ),
        .I3(\n1q_m_reg_n_0_[3] ),
        .I4(\cnt[4]_i_14__1_n_0 ),
        .O(\cnt[4]_i_3__1_n_0 ));
  LUT6 #(
    .INIT(64'hA6A665A665A66565)) 
    \cnt[4]_i_4__1 
       (.I0(\cnt[4]_i_15__1_n_0 ),
        .I1(\cnt[4]_i_16__0_n_0 ),
        .I2(\cnt[4]_i_17__0_n_0 ),
        .I3(\cnt[4]_i_18__1_n_0 ),
        .I4(\cnt[4]_i_19__1_n_0 ),
        .I5(\cnt[4]_i_20__1_n_0 ),
        .O(\cnt[4]_i_4__1_n_0 ));
  LUT5 #(
    .INIT(32'hAAAAAAAB)) 
    \cnt[4]_i_5__1 
       (.I0(\cnt[4]_i_21__1_n_0 ),
        .I1(cnt[2]),
        .I2(cnt[4]),
        .I3(cnt[1]),
        .I4(cnt[3]),
        .O(\cnt[4]_i_5__1_n_0 ));
  LUT6 #(
    .INIT(64'h595959999A9A9AAA)) 
    \cnt[4]_i_6__1 
       (.I0(\cnt[4]_i_22__0_n_0 ),
        .I1(\cnt[4]_i_16__0_n_0 ),
        .I2(\cnt[4]_i_23__1_n_0 ),
        .I3(\cnt[4]_i_24__1_n_0 ),
        .I4(\cnt[4]_i_19__1_n_0 ),
        .I5(\cnt[4]_i_25__1_n_0 ),
        .O(\cnt[4]_i_6__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair36" *) 
  LUT5 #(
    .INIT(32'h4BB4B44B)) 
    \cnt[4]_i_7__1 
       (.I0(\n1q_m_reg_n_0_[2] ),
        .I1(\n0q_m_reg_n_0_[2] ),
        .I2(\n1q_m_reg_n_0_[3] ),
        .I3(\n0q_m_reg_n_0_[3] ),
        .I4(cnt[3]),
        .O(\cnt[4]_i_7__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair40" *) 
  LUT5 #(
    .INIT(32'hB0FBFBB0)) 
    \cnt[4]_i_8__1 
       (.I0(\q_m_reg_reg_n_0_[8] ),
        .I1(\n0q_m_reg_n_0_[1] ),
        .I2(cnt[2]),
        .I3(\n0q_m_reg_n_0_[2] ),
        .I4(\n1q_m_reg_n_0_[2] ),
        .O(\cnt[4]_i_8__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair49" *) 
  LUT4 #(
    .INIT(16'hFFF6)) 
    \cnt[4]_i_9__1 
       (.I0(\q_m_reg_reg_n_0_[8] ),
        .I1(\n0q_m_reg_n_0_[1] ),
        .I2(cnt[1]),
        .I3(\n1q_m_reg_n_0_[1] ),
        .O(\cnt[4]_i_9__1_n_0 ));
  FDCE \cnt_reg[1] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(reset),
        .D(\cnt[1]_i_1__1_n_0 ),
        .Q(cnt[1]));
  FDCE \cnt_reg[2] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(reset),
        .D(\cnt[2]_i_1__1_n_0 ),
        .Q(cnt[2]));
  FDCE \cnt_reg[3] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(reset),
        .D(\cnt[3]_i_1__1_n_0 ),
        .Q(cnt[3]));
  FDCE \cnt_reg[4] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(reset),
        .D(\cnt[4]_i_1__1_n_0 ),
        .Q(cnt[4]));
  FDRE \din_q_reg[0] 
       (.C(pclk),
        .CE(1'b1),
        .D(video_din[0]),
        .Q(\din_q_reg_n_0_[0] ),
        .R(1'b0));
  FDRE \din_q_reg[1] 
       (.C(pclk),
        .CE(1'b1),
        .D(video_din[1]),
        .Q(p_0_in5_in),
        .R(1'b0));
  FDRE \din_q_reg[2] 
       (.C(pclk),
        .CE(1'b1),
        .D(video_din[2]),
        .Q(p_0_in4_in),
        .R(1'b0));
  FDRE \din_q_reg[3] 
       (.C(pclk),
        .CE(1'b1),
        .D(video_din[3]),
        .Q(p_0_in3_in),
        .R(1'b0));
  FDRE \din_q_reg[4] 
       (.C(pclk),
        .CE(1'b1),
        .D(video_din[4]),
        .Q(p_0_in2_in),
        .R(1'b0));
  FDRE \din_q_reg[5] 
       (.C(pclk),
        .CE(1'b1),
        .D(video_din[5]),
        .Q(p_0_in1_in),
        .R(1'b0));
  FDRE \din_q_reg[6] 
       (.C(pclk),
        .CE(1'b1),
        .D(video_din[6]),
        .Q(p_0_in0_in),
        .R(1'b0));
  FDRE \din_q_reg[7] 
       (.C(pclk),
        .CE(1'b1),
        .D(video_din[7]),
        .Q(p_0_in),
        .R(1'b0));
  (* SOFT_HLUTNM = "soft_lutpair37" *) 
  LUT5 #(
    .INIT(32'h88282228)) 
    \dout[0]_i_1__1 
       (.I0(de_reg),
        .I1(\q_m_reg_reg_n_0_[0] ),
        .I2(\cnt[4]_i_3__1_n_0 ),
        .I3(\cnt[4]_i_5__1_n_0 ),
        .I4(\q_m_reg_reg_n_0_[8] ),
        .O(\dout[0]_i_1__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair38" *) 
  LUT5 #(
    .INIT(32'h88282228)) 
    \dout[1]_i_1__1 
       (.I0(de_reg),
        .I1(\q_m_reg_reg_n_0_[1] ),
        .I2(\cnt[4]_i_3__1_n_0 ),
        .I3(\cnt[4]_i_5__1_n_0 ),
        .I4(\q_m_reg_reg_n_0_[8] ),
        .O(\dout[1]_i_1__1_n_0 ));
  LUT5 #(
    .INIT(32'hD5DF7F75)) 
    \dout[2]_i_1__1 
       (.I0(de_reg),
        .I1(\q_m_reg_reg_n_0_[8] ),
        .I2(\cnt[4]_i_5__1_n_0 ),
        .I3(\cnt[4]_i_3__1_n_0 ),
        .I4(\q_m_reg_reg_n_0_[2] ),
        .O(\dout[2]_i_1__1_n_0 ));
  LUT5 #(
    .INIT(32'h88282228)) 
    \dout[3]_i_1__1 
       (.I0(de_reg),
        .I1(\q_m_reg_reg_n_0_[3] ),
        .I2(\cnt[4]_i_3__1_n_0 ),
        .I3(\cnt[4]_i_5__1_n_0 ),
        .I4(\q_m_reg_reg_n_0_[8] ),
        .O(\dout[3]_i_1__1_n_0 ));
  LUT5 #(
    .INIT(32'hD5DF7F75)) 
    \dout[4]_i_1__1 
       (.I0(de_reg),
        .I1(\q_m_reg_reg_n_0_[8] ),
        .I2(\cnt[4]_i_5__1_n_0 ),
        .I3(\cnt[4]_i_3__1_n_0 ),
        .I4(\q_m_reg_reg_n_0_[4] ),
        .O(\dout[4]_i_1__1_n_0 ));
  LUT5 #(
    .INIT(32'h88282228)) 
    \dout[5]_i_1__1 
       (.I0(de_reg),
        .I1(\q_m_reg_reg_n_0_[5] ),
        .I2(\cnt[4]_i_3__1_n_0 ),
        .I3(\cnt[4]_i_5__1_n_0 ),
        .I4(\q_m_reg_reg_n_0_[8] ),
        .O(\dout[5]_i_1__1_n_0 ));
  LUT5 #(
    .INIT(32'hD5DF7F75)) 
    \dout[6]_i_1__1 
       (.I0(de_reg),
        .I1(\q_m_reg_reg_n_0_[8] ),
        .I2(\cnt[4]_i_5__1_n_0 ),
        .I3(\cnt[4]_i_3__1_n_0 ),
        .I4(\q_m_reg_reg_n_0_[6] ),
        .O(\dout[6]_i_1__1_n_0 ));
  LUT5 #(
    .INIT(32'h88282228)) 
    \dout[7]_i_1__1 
       (.I0(de_reg),
        .I1(\q_m_reg_reg_n_0_[7] ),
        .I2(\cnt[4]_i_3__1_n_0 ),
        .I3(\cnt[4]_i_5__1_n_0 ),
        .I4(\q_m_reg_reg_n_0_[8] ),
        .O(\dout[7]_i_1__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair38" *) 
  LUT2 #(
    .INIT(4'hB)) 
    \dout[8]_i_1__1 
       (.I0(\q_m_reg_reg_n_0_[8] ),
        .I1(de_reg),
        .O(\dout[8]_i_1__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair37" *) 
  LUT4 #(
    .INIT(16'h5DFD)) 
    \dout[9]_i_1__1 
       (.I0(de_reg),
        .I1(\cnt[4]_i_3__1_n_0 ),
        .I2(\cnt[4]_i_5__1_n_0 ),
        .I3(\q_m_reg_reg_n_0_[8] ),
        .O(\dout[9]_i_1__1_n_0 ));
  FDCE \dout_reg[0] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(reset),
        .D(\dout[0]_i_1__1_n_0 ),
        .Q(Q[0]));
  FDCE \dout_reg[1] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(reset),
        .D(\dout[1]_i_1__1_n_0 ),
        .Q(Q[1]));
  FDCE \dout_reg[2] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(reset),
        .D(\dout[2]_i_1__1_n_0 ),
        .Q(Q[2]));
  FDCE \dout_reg[3] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(reset),
        .D(\dout[3]_i_1__1_n_0 ),
        .Q(Q[3]));
  FDCE \dout_reg[4] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(reset),
        .D(\dout[4]_i_1__1_n_0 ),
        .Q(Q[4]));
  FDCE \dout_reg[5] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(reset),
        .D(\dout[5]_i_1__1_n_0 ),
        .Q(Q[5]));
  FDCE \dout_reg[6] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(reset),
        .D(\dout[6]_i_1__1_n_0 ),
        .Q(Q[6]));
  FDCE \dout_reg[7] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(reset),
        .D(\dout[7]_i_1__1_n_0 ),
        .Q(Q[7]));
  FDCE \dout_reg[8] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(reset),
        .D(\dout[8]_i_1__1_n_0 ),
        .Q(Q[8]));
  FDCE \dout_reg[9] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(reset),
        .D(\dout[9]_i_1__1_n_0 ),
        .Q(Q[9]));
  LUT6 #(
    .INIT(64'h9996699996669996)) 
    \n0q_m[1]_i_1__1 
       (.I0(\n1q_m[3]_i_3__1_n_0 ),
        .I1(\n1q_m[3]_i_2__1_n_0 ),
        .I2(\n1q_m[3]_i_5__1_n_0 ),
        .I3(\n1q_m[3]_i_4__1_n_0 ),
        .I4(\din_q_reg_n_0_[0] ),
        .I5(\n1q_m[3]_i_6__1_n_0 ),
        .O(\n0q_m[1]_i_1__1_n_0 ));
  LUT6 #(
    .INIT(64'h2000FBB2FBB2DFFF)) 
    \n0q_m[2]_i_1__1 
       (.I0(\n1q_m[3]_i_6__1_n_0 ),
        .I1(\din_q_reg_n_0_[0] ),
        .I2(\n1q_m[3]_i_4__1_n_0 ),
        .I3(\n1q_m[3]_i_5__1_n_0 ),
        .I4(\n1q_m[3]_i_2__1_n_0 ),
        .I5(\n1q_m[3]_i_3__1_n_0 ),
        .O(\n0q_m[2]_i_1__1_n_0 ));
  LUT6 #(
    .INIT(64'h0100000000000000)) 
    \n0q_m[3]_i_1__1 
       (.I0(\n1q_m[3]_i_2__1_n_0 ),
        .I1(\n1q_m[3]_i_3__1_n_0 ),
        .I2(\din_q_reg_n_0_[0] ),
        .I3(\n1q_m[3]_i_4__1_n_0 ),
        .I4(\n1q_m[3]_i_5__1_n_0 ),
        .I5(\n1q_m[3]_i_6__1_n_0 ),
        .O(\n0q_m[3]_i_1__1_n_0 ));
  FDRE \n0q_m_reg[1] 
       (.C(pclk),
        .CE(1'b1),
        .D(\n0q_m[1]_i_1__1_n_0 ),
        .Q(\n0q_m_reg_n_0_[1] ),
        .R(1'b0));
  FDRE \n0q_m_reg[2] 
       (.C(pclk),
        .CE(1'b1),
        .D(\n0q_m[2]_i_1__1_n_0 ),
        .Q(\n0q_m_reg_n_0_[2] ),
        .R(1'b0));
  FDRE \n0q_m_reg[3] 
       (.C(pclk),
        .CE(1'b1),
        .D(\n0q_m[3]_i_1__1_n_0 ),
        .Q(\n0q_m_reg_n_0_[3] ),
        .R(1'b0));
  LUT6 #(
    .INIT(64'h6996966996696996)) 
    \n1d[0]_i_1 
       (.I0(video_din[0]),
        .I1(video_din[7]),
        .I2(\n1d[0]_i_2_n_0 ),
        .I3(video_din[2]),
        .I4(video_din[1]),
        .I5(video_din[3]),
        .O(\n1d[0]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair42" *) 
  LUT3 #(
    .INIT(8'h96)) 
    \n1d[0]_i_2 
       (.I0(video_din[6]),
        .I1(video_din[4]),
        .I2(video_din[5]),
        .O(\n1d[0]_i_2_n_0 ));
  LUT3 #(
    .INIT(8'h96)) 
    \n1d[1]_i_1 
       (.I0(\n1d[3]_i_2_n_0 ),
        .I1(\n1d[1]_i_2_n_0 ),
        .I2(\n1d[3]_i_3_n_0 ),
        .O(\n1d[1]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h171717E817E8E8E8)) 
    \n1d[1]_i_2 
       (.I0(video_din[3]),
        .I1(video_din[2]),
        .I2(video_din[1]),
        .I3(video_din[6]),
        .I4(video_din[5]),
        .I5(video_din[4]),
        .O(\n1d[1]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h7E7E7EE87EE8E8E8)) 
    \n1d[2]_i_1 
       (.I0(\n1d[3]_i_2_n_0 ),
        .I1(\n1d[3]_i_3_n_0 ),
        .I2(\n1d[2]_i_2_n_0 ),
        .I3(video_din[4]),
        .I4(video_din[5]),
        .I5(video_din[6]),
        .O(\n1d[2]_i_1_n_0 ));
  LUT3 #(
    .INIT(8'hE8)) 
    \n1d[2]_i_2 
       (.I0(video_din[1]),
        .I1(video_din[2]),
        .I2(video_din[3]),
        .O(\n1d[2]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h8880800000000000)) 
    \n1d[3]_i_1 
       (.I0(\n1d[3]_i_2_n_0 ),
        .I1(\n1d[3]_i_3_n_0 ),
        .I2(video_din[3]),
        .I3(video_din[2]),
        .I4(video_din[1]),
        .I5(\n1d[3]_i_4_n_0 ),
        .O(\n1d[3]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h9600009600969600)) 
    \n1d[3]_i_2 
       (.I0(video_din[2]),
        .I1(video_din[1]),
        .I2(video_din[3]),
        .I3(video_din[0]),
        .I4(video_din[7]),
        .I5(\n1d[0]_i_2_n_0 ),
        .O(\n1d[3]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair42" *) 
  LUT5 #(
    .INIT(32'hE88E8EE8)) 
    \n1d[3]_i_3 
       (.I0(video_din[7]),
        .I1(video_din[0]),
        .I2(video_din[5]),
        .I3(video_din[4]),
        .I4(video_din[6]),
        .O(\n1d[3]_i_3_n_0 ));
  LUT3 #(
    .INIT(8'hE8)) 
    \n1d[3]_i_4 
       (.I0(video_din[4]),
        .I1(video_din[5]),
        .I2(video_din[6]),
        .O(\n1d[3]_i_4_n_0 ));
  FDRE \n1d_reg[0] 
       (.C(pclk),
        .CE(1'b1),
        .D(\n1d[0]_i_1_n_0 ),
        .Q(n1d[0]),
        .R(1'b0));
  FDRE \n1d_reg[1] 
       (.C(pclk),
        .CE(1'b1),
        .D(\n1d[1]_i_1_n_0 ),
        .Q(n1d[1]),
        .R(1'b0));
  FDRE \n1d_reg[2] 
       (.C(pclk),
        .CE(1'b1),
        .D(\n1d[2]_i_1_n_0 ),
        .Q(n1d[2]),
        .R(1'b0));
  FDRE \n1d_reg[3] 
       (.C(pclk),
        .CE(1'b1),
        .D(\n1d[3]_i_1_n_0 ),
        .Q(n1d[3]),
        .R(1'b0));
  LUT6 #(
    .INIT(64'h6696969996999969)) 
    \n1q_m[1]_i_1__1 
       (.I0(\n1q_m[3]_i_2__1_n_0 ),
        .I1(\n1q_m[3]_i_3__1_n_0 ),
        .I2(\din_q_reg_n_0_[0] ),
        .I3(\n1q_m[3]_i_4__1_n_0 ),
        .I4(\n1q_m[3]_i_5__1_n_0 ),
        .I5(\n1q_m[3]_i_6__1_n_0 ),
        .O(\n1q_m[1]_i_1__1_n_0 ));
  LUT6 #(
    .INIT(64'hFFEF71F771F70010)) 
    \n1q_m[2]_i_1__1 
       (.I0(\n1q_m[3]_i_5__1_n_0 ),
        .I1(\n1q_m[3]_i_4__1_n_0 ),
        .I2(\din_q_reg_n_0_[0] ),
        .I3(\n1q_m[3]_i_6__1_n_0 ),
        .I4(\n1q_m[3]_i_3__1_n_0 ),
        .I5(\n1q_m[3]_i_2__1_n_0 ),
        .O(\n1q_m[2]_i_1__1_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000000080)) 
    \n1q_m[3]_i_1__1 
       (.I0(\n1q_m[3]_i_2__1_n_0 ),
        .I1(\n1q_m[3]_i_3__1_n_0 ),
        .I2(\din_q_reg_n_0_[0] ),
        .I3(\n1q_m[3]_i_4__1_n_0 ),
        .I4(\n1q_m[3]_i_5__1_n_0 ),
        .I5(\n1q_m[3]_i_6__1_n_0 ),
        .O(\n1q_m[3]_i_1__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair43" *) 
  LUT5 #(
    .INIT(32'hB42D4BD2)) 
    \n1q_m[3]_i_2__1 
       (.I0(\q_m_reg[7]_i_2__1_n_0 ),
        .I1(p_0_in3_in),
        .I2(\din_q_reg_n_0_[0] ),
        .I3(p_0_in4_in),
        .I4(p_0_in5_in),
        .O(\n1q_m[3]_i_2__1_n_0 ));
  LUT6 #(
    .INIT(64'hE11E1EE178878778)) 
    \n1q_m[3]_i_3__1 
       (.I0(p_0_in0_in),
        .I1(\q_m_reg[7]_i_2__1_n_0 ),
        .I2(q_m_2),
        .I3(p_0_in2_in),
        .I4(p_0_in3_in),
        .I5(p_0_in1_in),
        .O(\n1q_m[3]_i_3__1_n_0 ));
  LUT6 #(
    .INIT(64'h9669699669969669)) 
    \n1q_m[3]_i_4__1 
       (.I0(p_0_in3_in),
        .I1(p_0_in2_in),
        .I2(\din_q_reg_n_0_[0] ),
        .I3(p_0_in4_in),
        .I4(p_0_in5_in),
        .I5(\n1q_m[3]_i_7__1_n_0 ),
        .O(\n1q_m[3]_i_4__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair44" *) 
  LUT5 #(
    .INIT(32'h96696996)) 
    \n1q_m[3]_i_5__1 
       (.I0(p_0_in0_in),
        .I1(\q_m_reg[7]_i_3__1_n_0 ),
        .I2(p_0_in1_in),
        .I3(\q_m_reg[7]_i_2__1_n_0 ),
        .I4(p_0_in),
        .O(\n1q_m[3]_i_5__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair52" *) 
  LUT3 #(
    .INIT(8'h69)) 
    \n1q_m[3]_i_6__1 
       (.I0(\din_q_reg_n_0_[0] ),
        .I1(p_0_in5_in),
        .I2(p_0_in3_in),
        .O(\n1q_m[3]_i_6__1_n_0 ));
  LUT6 #(
    .INIT(64'h5555555566666A66)) 
    \n1q_m[3]_i_7__1 
       (.I0(p_0_in0_in),
        .I1(n1d[2]),
        .I2(n1d[0]),
        .I3(\din_q_reg_n_0_[0] ),
        .I4(n1d[1]),
        .I5(n1d[3]),
        .O(\n1q_m[3]_i_7__1_n_0 ));
  FDRE \n1q_m_reg[1] 
       (.C(pclk),
        .CE(1'b1),
        .D(\n1q_m[1]_i_1__1_n_0 ),
        .Q(\n1q_m_reg_n_0_[1] ),
        .R(1'b0));
  FDRE \n1q_m_reg[2] 
       (.C(pclk),
        .CE(1'b1),
        .D(\n1q_m[2]_i_1__1_n_0 ),
        .Q(\n1q_m_reg_n_0_[2] ),
        .R(1'b0));
  FDRE \n1q_m_reg[3] 
       (.C(pclk),
        .CE(1'b1),
        .D(\n1q_m[3]_i_1__1_n_0 ),
        .Q(\n1q_m_reg_n_0_[3] ),
        .R(1'b0));
  LUT6 #(
    .INIT(64'hFFA800570055FFAA)) 
    \q_m_reg[1]_i_1__1 
       (.I0(n1d[2]),
        .I1(n1d[0]),
        .I2(n1d[1]),
        .I3(n1d[3]),
        .I4(p_0_in5_in),
        .I5(\din_q_reg_n_0_[0] ),
        .O(q_m_1));
  (* SOFT_HLUTNM = "soft_lutpair52" *) 
  LUT3 #(
    .INIT(8'h96)) 
    \q_m_reg[2]_i_1__1 
       (.I0(\din_q_reg_n_0_[0] ),
        .I1(p_0_in4_in),
        .I2(p_0_in5_in),
        .O(q_m_2));
  (* SOFT_HLUTNM = "soft_lutpair43" *) 
  LUT5 #(
    .INIT(32'h96696996)) 
    \q_m_reg[3]_i_1__1 
       (.I0(p_0_in5_in),
        .I1(p_0_in4_in),
        .I2(\din_q_reg_n_0_[0] ),
        .I3(p_0_in3_in),
        .I4(\q_m_reg[7]_i_2__1_n_0 ),
        .O(q_m_3));
  (* SOFT_HLUTNM = "soft_lutpair46" *) 
  LUT5 #(
    .INIT(32'h96696996)) 
    \q_m_reg[4]_i_1__1 
       (.I0(p_0_in3_in),
        .I1(p_0_in2_in),
        .I2(\din_q_reg_n_0_[0] ),
        .I3(p_0_in4_in),
        .I4(p_0_in5_in),
        .O(q_m_4));
  LUT5 #(
    .INIT(32'h96696996)) 
    \q_m_reg[5]_i_1__1 
       (.I0(\q_m_reg[7]_i_2__1_n_0 ),
        .I1(q_m_2),
        .I2(p_0_in2_in),
        .I3(p_0_in3_in),
        .I4(p_0_in1_in),
        .O(\q_m_reg[5]_i_1__1_n_0 ));
  LUT5 #(
    .INIT(32'h96696996)) 
    \q_m_reg[6]_i_1__1 
       (.I0(p_0_in1_in),
        .I1(p_0_in3_in),
        .I2(p_0_in2_in),
        .I3(q_m_2),
        .I4(p_0_in0_in),
        .O(q_m_6));
  (* SOFT_HLUTNM = "soft_lutpair44" *) 
  LUT5 #(
    .INIT(32'h69969669)) 
    \q_m_reg[7]_i_1__1 
       (.I0(p_0_in),
        .I1(\q_m_reg[7]_i_2__1_n_0 ),
        .I2(p_0_in1_in),
        .I3(\q_m_reg[7]_i_3__1_n_0 ),
        .I4(p_0_in0_in),
        .O(\q_m_reg[7]_i_1__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair45" *) 
  LUT5 #(
    .INIT(32'hFFEFAAAA)) 
    \q_m_reg[7]_i_2__1 
       (.I0(n1d[3]),
        .I1(n1d[1]),
        .I2(\din_q_reg_n_0_[0] ),
        .I3(n1d[0]),
        .I4(n1d[2]),
        .O(\q_m_reg[7]_i_2__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair46" *) 
  LUT5 #(
    .INIT(32'h69969669)) 
    \q_m_reg[7]_i_3__1 
       (.I0(p_0_in5_in),
        .I1(p_0_in4_in),
        .I2(\din_q_reg_n_0_[0] ),
        .I3(p_0_in2_in),
        .I4(p_0_in3_in),
        .O(\q_m_reg[7]_i_3__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair45" *) 
  LUT5 #(
    .INIT(32'h00005575)) 
    \q_m_reg[8]_i_1__1 
       (.I0(n1d[2]),
        .I1(n1d[0]),
        .I2(\din_q_reg_n_0_[0] ),
        .I3(n1d[1]),
        .I4(n1d[3]),
        .O(\q_m_reg[8]_i_1__1_n_0 ));
  FDRE \q_m_reg_reg[0] 
       (.C(pclk),
        .CE(1'b1),
        .D(\din_q_reg_n_0_[0] ),
        .Q(\q_m_reg_reg_n_0_[0] ),
        .R(1'b0));
  FDRE \q_m_reg_reg[1] 
       (.C(pclk),
        .CE(1'b1),
        .D(q_m_1),
        .Q(\q_m_reg_reg_n_0_[1] ),
        .R(1'b0));
  FDRE \q_m_reg_reg[2] 
       (.C(pclk),
        .CE(1'b1),
        .D(q_m_2),
        .Q(\q_m_reg_reg_n_0_[2] ),
        .R(1'b0));
  FDRE \q_m_reg_reg[3] 
       (.C(pclk),
        .CE(1'b1),
        .D(q_m_3),
        .Q(\q_m_reg_reg_n_0_[3] ),
        .R(1'b0));
  FDRE \q_m_reg_reg[4] 
       (.C(pclk),
        .CE(1'b1),
        .D(q_m_4),
        .Q(\q_m_reg_reg_n_0_[4] ),
        .R(1'b0));
  FDRE \q_m_reg_reg[5] 
       (.C(pclk),
        .CE(1'b1),
        .D(\q_m_reg[5]_i_1__1_n_0 ),
        .Q(\q_m_reg_reg_n_0_[5] ),
        .R(1'b0));
  FDRE \q_m_reg_reg[6] 
       (.C(pclk),
        .CE(1'b1),
        .D(q_m_6),
        .Q(\q_m_reg_reg_n_0_[6] ),
        .R(1'b0));
  FDRE \q_m_reg_reg[7] 
       (.C(pclk),
        .CE(1'b1),
        .D(\q_m_reg[7]_i_1__1_n_0 ),
        .Q(\q_m_reg_reg_n_0_[7] ),
        .R(1'b0));
  FDRE \q_m_reg_reg[8] 
       (.C(pclk),
        .CE(1'b1),
        .D(\q_m_reg[8]_i_1__1_n_0 ),
        .Q(\q_m_reg_reg_n_0_[8] ),
        .R(1'b0));
endmodule

(* ORIG_REF_NAME = "dvi_transmitter_top" *) 
module system_DVI_Transmitter_Safe_0_0_dvi_transmitter_top
   (tmds_data_p,
    tmds_data_n,
    tmds_clk_p,
    tmds_clk_n,
    pclk,
    pixel_clk_5x,
    pixel_clk_2_5x,
    video_din,
    video_de,
    video_hsync,
    video_vsync,
    reset_n);
  output [2:0]tmds_data_p;
  output [2:0]tmds_data_n;
  output tmds_clk_p;
  output tmds_clk_n;
  input pclk;
  input pixel_clk_5x;
  input pixel_clk_2_5x;
  input [23:0]video_din;
  input video_de;
  input video_hsync;
  input video_vsync;
  input reset_n;

  wire WE0;
  wire [9:0]blue_10bit;
  wire de_reg;
  wire [9:0]green_10bit;
  wire pclk;
  wire pixel_clk_2_5x;
  wire pixel_clk_5x;
  wire [9:0]red_10bit;
  wire reset;
  wire reset_n;
  wire serializer_b_n_5;
  wire serializer_clk_n_1;
  wire serializer_g_n_1;
  wire serializer_r_n_1;
  wire tmds_clk_n;
  wire tmds_clk_p;
  wire tmds_clk_serial;
  wire [2:0]tmds_data_n;
  wire [2:0]tmds_data_p;
  wire tmds_data_serial_0;
  wire tmds_data_serial_1;
  wire tmds_data_serial_2;
  wire u_asyn_rst_syn_n_1;
  wire u_asyn_rst_syn_n_2;
  wire u_asyn_rst_syn_n_3;
  wire u_asyn_rst_syn_n_4;
  wire video_de;
  wire [23:0]video_din;
  wire video_hsync;
  wire video_vsync;
  wire [3:0]wr_addr_reg;

  system_DVI_Transmitter_Safe_0_0_dvi_encoder encoder_b
       (.Q(blue_10bit),
        .de_reg(de_reg),
        .pclk(pclk),
        .reset(reset),
        .video_de(video_de),
        .video_din(video_din[7:0]),
        .video_hsync(video_hsync),
        .video_vsync(video_vsync));
  system_DVI_Transmitter_Safe_0_0_dvi_encoder_0 encoder_g
       (.Q(green_10bit),
        .de_reg(de_reg),
        .pclk(pclk),
        .reset(reset),
        .video_din(video_din[15:8]));
  system_DVI_Transmitter_Safe_0_0_dvi_encoder_1 encoder_r
       (.Q(red_10bit),
        .de_reg(de_reg),
        .pclk(pclk),
        .reset(reset),
        .video_din(video_din[23:16]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* CAPACITANCE = "DONT_CARE" *) 
  (* XILINX_LEGACY_PRIM = "OBUFDS" *) 
  OBUFDS #(
    .IOSTANDARD("DEFAULT")) 
    io_clk_out
       (.I(tmds_clk_serial),
        .O(tmds_clk_p),
        .OB(tmds_clk_n));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* CAPACITANCE = "DONT_CARE" *) 
  (* XILINX_LEGACY_PRIM = "OBUFDS" *) 
  OBUFDS #(
    .IOSTANDARD("DEFAULT")) 
    io_clk_out0
       (.I(tmds_data_serial_0),
        .O(tmds_data_p[0]),
        .OB(tmds_data_n[0]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* CAPACITANCE = "DONT_CARE" *) 
  (* XILINX_LEGACY_PRIM = "OBUFDS" *) 
  OBUFDS #(
    .IOSTANDARD("DEFAULT")) 
    io_clk_out1
       (.I(tmds_data_serial_1),
        .O(tmds_data_p[1]),
        .OB(tmds_data_n[1]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* CAPACITANCE = "DONT_CARE" *) 
  (* XILINX_LEGACY_PRIM = "OBUFDS" *) 
  OBUFDS #(
    .IOSTANDARD("DEFAULT")) 
    io_clk_out2
       (.I(tmds_data_serial_2),
        .O(tmds_data_p[2]),
        .OB(tmds_data_n[2]));
  system_DVI_Transmitter_Safe_0_0_serializer_10_to_1 serializer_b
       (.Q(blue_10bit),
        .SR(u_asyn_rst_syn_n_1),
        .WE0(WE0),
        .pclk(pclk),
        .pixel_clk_2_5x(pixel_clk_2_5x),
        .pixel_clk_5x(pixel_clk_5x),
        .prime_done_reg_0(serializer_b_n_5),
        .reset(reset),
        .tmds_data_serial_0(tmds_data_serial_0),
        .\wr_addr_reg[3]_0 (wr_addr_reg));
  system_DVI_Transmitter_Safe_0_0_serializer_10_to_1_2 serializer_clk
       (.SR(u_asyn_rst_syn_n_4),
        .WE0(WE0),
        .pclk(pclk),
        .pixel_clk_2_5x(pixel_clk_2_5x),
        .pixel_clk_5x(pixel_clk_5x),
        .prime_done_reg_0(serializer_clk_n_1),
        .\rd_last_reg[6]_0 (wr_addr_reg),
        .reset(reset),
        .tmds_clk_serial(tmds_clk_serial));
  system_DVI_Transmitter_Safe_0_0_serializer_10_to_1_3 serializer_g
       (.Q(green_10bit),
        .SR(u_asyn_rst_syn_n_2),
        .WE0(WE0),
        .pclk(pclk),
        .pixel_clk_2_5x(pixel_clk_2_5x),
        .pixel_clk_5x(pixel_clk_5x),
        .prime_done_reg_0(serializer_g_n_1),
        .\rd_last_reg[6]_0 (wr_addr_reg),
        .reset(reset),
        .tmds_data_serial_1(tmds_data_serial_1));
  system_DVI_Transmitter_Safe_0_0_serializer_10_to_1_4 serializer_r
       (.Q(red_10bit),
        .SR(u_asyn_rst_syn_n_3),
        .WE0(WE0),
        .pclk(pclk),
        .pixel_clk_2_5x(pixel_clk_2_5x),
        .pixel_clk_5x(pixel_clk_5x),
        .prime_done_reg_0(serializer_r_n_1),
        .\rd_last_reg[9]_0 (wr_addr_reg),
        .reset(reset),
        .tmds_data_serial_2(tmds_data_serial_2));
  system_DVI_Transmitter_Safe_0_0_asyn_rst_syn u_asyn_rst_syn
       (.SR(u_asyn_rst_syn_n_1),
        .WE0(WE0),
        .pclk(pclk),
        .reset(reset),
        .reset_2_reg_0(u_asyn_rst_syn_n_2),
        .reset_2_reg_1(u_asyn_rst_syn_n_3),
        .reset_2_reg_2(u_asyn_rst_syn_n_4),
        .reset_n(reset_n),
        .\tx_data_reg[0] (serializer_b_n_5),
        .\tx_data_reg[0]_0 (serializer_g_n_1),
        .\tx_data_reg[0]_1 (serializer_r_n_1),
        .\tx_data_reg[0]_2 (serializer_clk_n_1));
endmodule

(* ORIG_REF_NAME = "serializer_10_to_1" *) 
module system_DVI_Transmitter_Safe_0_0_serializer_10_to_1
   (\wr_addr_reg[3]_0 ,
    tmds_data_serial_0,
    prime_done_reg_0,
    pclk,
    Q,
    WE0,
    pixel_clk_5x,
    pixel_clk_2_5x,
    reset,
    SR);
  output [3:0]\wr_addr_reg[3]_0 ;
  output tmds_data_serial_0;
  output prime_done_reg_0;
  input pclk;
  input [9:0]Q;
  input WE0;
  input pixel_clk_5x;
  input pixel_clk_2_5x;
  input reset;
  input [0:0]SR;

  wire \FSM_sequential_rd_ctrl_cnt[1]_i_1_n_0 ;
  wire [9:0]Q;
  wire [0:0]SR;
  wire WE0;
  wire [3:1]p_0_in;
  wire [3:0]p_0_in__0;
  wire pclk;
  wire pixel_clk_2_5x;
  wire pixel_clk_5x;
  wire \prime_count[0]_i_1__2_n_0 ;
  wire \prime_count[3]_i_1_n_0 ;
  wire [3:0]prime_count_reg;
  wire prime_done_i_1_n_0;
  wire prime_done_reg_0;
  wire \rd_addr[0]_i_1_n_0 ;
  wire \rd_addr[1]_i_1_n_0 ;
  wire \rd_addr[2]_i_1_n_0 ;
  wire \rd_addr[3]_i_1_n_0 ;
  wire \rd_addr[3]_i_2_n_0 ;
  wire \rd_addr_reg_n_0_[0] ;
  wire \rd_addr_reg_n_0_[1] ;
  wire \rd_addr_reg_n_0_[2] ;
  wire \rd_addr_reg_n_0_[3] ;
  wire [2:0]rd_ctrl_cnt;
  wire [2:0]rd_ctrl_cnt__0;
  wire [9:0]rd_curr;
  wire [7:4]rd_last;
  wire reset;
  wire tmds_data_serial_0;
  wire tx_data;
  wire \tx_data[0]_i_1_n_0 ;
  wire \tx_data[0]_i_2_n_0 ;
  wire \tx_data[1]_i_1_n_0 ;
  wire \tx_data[1]_i_2_n_0 ;
  wire \tx_data[2]_i_1_n_0 ;
  wire \tx_data[2]_i_2_n_0 ;
  wire \tx_data[3]_i_3_n_0 ;
  wire \tx_data[3]_i_4_n_0 ;
  wire \tx_data_reg_n_0_[0] ;
  wire \tx_data_reg_n_0_[1] ;
  wire \tx_data_reg_n_0_[2] ;
  wire \tx_data_reg_n_0_[3] ;
  wire [3:0]\wr_addr_reg[3]_0 ;
  wire NLW_OSERDESE3_inst_T_OUT_UNCONNECTED;
  wire \NLW_bit[0].mem_SPO_UNCONNECTED ;
  wire \NLW_bit[1].mem_SPO_UNCONNECTED ;
  wire \NLW_bit[2].mem_SPO_UNCONNECTED ;
  wire \NLW_bit[3].mem_SPO_UNCONNECTED ;
  wire \NLW_bit[4].mem_SPO_UNCONNECTED ;
  wire \NLW_bit[5].mem_SPO_UNCONNECTED ;
  wire \NLW_bit[6].mem_SPO_UNCONNECTED ;
  wire \NLW_bit[7].mem_SPO_UNCONNECTED ;
  wire \NLW_bit[8].mem_SPO_UNCONNECTED ;
  wire \NLW_bit[9].mem_SPO_UNCONNECTED ;

  LUT2 #(
    .INIT(4'h1)) 
    \FSM_sequential_rd_ctrl_cnt[0]_i_1 
       (.I0(rd_ctrl_cnt[0]),
        .I1(rd_ctrl_cnt[2]),
        .O(rd_ctrl_cnt__0[0]));
  (* SOFT_HLUTNM = "soft_lutpair56" *) 
  LUT3 #(
    .INIT(8'h06)) 
    \FSM_sequential_rd_ctrl_cnt[1]_i_1 
       (.I0(rd_ctrl_cnt[1]),
        .I1(rd_ctrl_cnt[0]),
        .I2(rd_ctrl_cnt[2]),
        .O(\FSM_sequential_rd_ctrl_cnt[1]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair56" *) 
  LUT3 #(
    .INIT(8'h40)) 
    \FSM_sequential_rd_ctrl_cnt[2]_i_1 
       (.I0(rd_ctrl_cnt[2]),
        .I1(rd_ctrl_cnt[0]),
        .I2(rd_ctrl_cnt[1]),
        .O(rd_ctrl_cnt__0[2]));
  (* FSM_ENCODED_STATES = "iSTATE:000,iSTATE0:001,iSTATE1:010,iSTATE2:011,iSTATE3:100," *) 
  FDRE \FSM_sequential_rd_ctrl_cnt_reg[0] 
       (.C(pixel_clk_2_5x),
        .CE(prime_done_reg_0),
        .D(rd_ctrl_cnt__0[0]),
        .Q(rd_ctrl_cnt[0]),
        .R(reset));
  (* FSM_ENCODED_STATES = "iSTATE:000,iSTATE0:001,iSTATE1:010,iSTATE2:011,iSTATE3:100," *) 
  FDRE \FSM_sequential_rd_ctrl_cnt_reg[1] 
       (.C(pixel_clk_2_5x),
        .CE(prime_done_reg_0),
        .D(\FSM_sequential_rd_ctrl_cnt[1]_i_1_n_0 ),
        .Q(rd_ctrl_cnt[1]),
        .R(reset));
  (* FSM_ENCODED_STATES = "iSTATE:000,iSTATE0:001,iSTATE1:010,iSTATE2:011,iSTATE3:100," *) 
  FDRE \FSM_sequential_rd_ctrl_cnt_reg[2] 
       (.C(pixel_clk_2_5x),
        .CE(prime_done_reg_0),
        .D(rd_ctrl_cnt__0[2]),
        .Q(rd_ctrl_cnt[2]),
        .R(reset));
  (* BOX_TYPE = "PRIMITIVE" *) 
  OSERDESE3 #(
    .DATA_WIDTH(4),
    .INIT(1'b0),
    .IS_CLKDIV_INVERTED(1'b0),
    .IS_CLK_INVERTED(1'b0),
    .IS_RST_INVERTED(1'b0),
    .ODDR_MODE("FALSE"),
    .OSERDES_D_BYPASS("FALSE"),
    .OSERDES_T_BYPASS("FALSE"),
    .SIM_DEVICE("ULTRASCALE_PLUS"),
    .SIM_VERSION(2.000000)) 
    OSERDESE3_inst
       (.CLK(pixel_clk_5x),
        .CLKDIV(pixel_clk_2_5x),
        .D({1'b0,1'b0,1'b0,1'b0,\tx_data_reg_n_0_[3] ,\tx_data_reg_n_0_[2] ,\tx_data_reg_n_0_[1] ,\tx_data_reg_n_0_[0] }),
        .OQ(tmds_data_serial_0),
        .RST(reset),
        .T(1'b0),
        .T_OUT(NLW_OSERDESE3_inst_T_OUT_UNCONNECTED));
  (* BOX_TYPE = "PRIMITIVE" *) 
  RAM32X1D #(
    .INIT(32'h00000000),
    .IS_WCLK_INVERTED(1'b0)) 
    \bit[0].mem 
       (.A0(\wr_addr_reg[3]_0 [0]),
        .A1(\wr_addr_reg[3]_0 [1]),
        .A2(\wr_addr_reg[3]_0 [2]),
        .A3(\wr_addr_reg[3]_0 [3]),
        .A4(1'b0),
        .D(Q[0]),
        .DPO(rd_curr[0]),
        .DPRA0(\rd_addr_reg_n_0_[0] ),
        .DPRA1(\rd_addr_reg_n_0_[1] ),
        .DPRA2(\rd_addr_reg_n_0_[2] ),
        .DPRA3(\rd_addr_reg_n_0_[3] ),
        .DPRA4(1'b0),
        .SPO(\NLW_bit[0].mem_SPO_UNCONNECTED ),
        .WCLK(pclk),
        .WE(WE0));
  (* BOX_TYPE = "PRIMITIVE" *) 
  RAM32X1D #(
    .INIT(32'h00000000),
    .IS_WCLK_INVERTED(1'b0)) 
    \bit[1].mem 
       (.A0(\wr_addr_reg[3]_0 [0]),
        .A1(\wr_addr_reg[3]_0 [1]),
        .A2(\wr_addr_reg[3]_0 [2]),
        .A3(\wr_addr_reg[3]_0 [3]),
        .A4(1'b0),
        .D(Q[1]),
        .DPO(rd_curr[1]),
        .DPRA0(\rd_addr_reg_n_0_[0] ),
        .DPRA1(\rd_addr_reg_n_0_[1] ),
        .DPRA2(\rd_addr_reg_n_0_[2] ),
        .DPRA3(\rd_addr_reg_n_0_[3] ),
        .DPRA4(1'b0),
        .SPO(\NLW_bit[1].mem_SPO_UNCONNECTED ),
        .WCLK(pclk),
        .WE(WE0));
  (* BOX_TYPE = "PRIMITIVE" *) 
  RAM32X1D #(
    .INIT(32'h00000000),
    .IS_WCLK_INVERTED(1'b0)) 
    \bit[2].mem 
       (.A0(\wr_addr_reg[3]_0 [0]),
        .A1(\wr_addr_reg[3]_0 [1]),
        .A2(\wr_addr_reg[3]_0 [2]),
        .A3(\wr_addr_reg[3]_0 [3]),
        .A4(1'b0),
        .D(Q[2]),
        .DPO(rd_curr[2]),
        .DPRA0(\rd_addr_reg_n_0_[0] ),
        .DPRA1(\rd_addr_reg_n_0_[1] ),
        .DPRA2(\rd_addr_reg_n_0_[2] ),
        .DPRA3(\rd_addr_reg_n_0_[3] ),
        .DPRA4(1'b0),
        .SPO(\NLW_bit[2].mem_SPO_UNCONNECTED ),
        .WCLK(pclk),
        .WE(WE0));
  (* BOX_TYPE = "PRIMITIVE" *) 
  RAM32X1D #(
    .INIT(32'h00000000),
    .IS_WCLK_INVERTED(1'b0)) 
    \bit[3].mem 
       (.A0(\wr_addr_reg[3]_0 [0]),
        .A1(\wr_addr_reg[3]_0 [1]),
        .A2(\wr_addr_reg[3]_0 [2]),
        .A3(\wr_addr_reg[3]_0 [3]),
        .A4(1'b0),
        .D(Q[3]),
        .DPO(rd_curr[3]),
        .DPRA0(\rd_addr_reg_n_0_[0] ),
        .DPRA1(\rd_addr_reg_n_0_[1] ),
        .DPRA2(\rd_addr_reg_n_0_[2] ),
        .DPRA3(\rd_addr_reg_n_0_[3] ),
        .DPRA4(1'b0),
        .SPO(\NLW_bit[3].mem_SPO_UNCONNECTED ),
        .WCLK(pclk),
        .WE(WE0));
  (* BOX_TYPE = "PRIMITIVE" *) 
  RAM32X1D #(
    .INIT(32'h00000000),
    .IS_WCLK_INVERTED(1'b0)) 
    \bit[4].mem 
       (.A0(\wr_addr_reg[3]_0 [0]),
        .A1(\wr_addr_reg[3]_0 [1]),
        .A2(\wr_addr_reg[3]_0 [2]),
        .A3(\wr_addr_reg[3]_0 [3]),
        .A4(1'b0),
        .D(Q[4]),
        .DPO(rd_curr[4]),
        .DPRA0(\rd_addr_reg_n_0_[0] ),
        .DPRA1(\rd_addr_reg_n_0_[1] ),
        .DPRA2(\rd_addr_reg_n_0_[2] ),
        .DPRA3(\rd_addr_reg_n_0_[3] ),
        .DPRA4(1'b0),
        .SPO(\NLW_bit[4].mem_SPO_UNCONNECTED ),
        .WCLK(pclk),
        .WE(WE0));
  (* BOX_TYPE = "PRIMITIVE" *) 
  RAM32X1D #(
    .INIT(32'h00000000),
    .IS_WCLK_INVERTED(1'b0)) 
    \bit[5].mem 
       (.A0(\wr_addr_reg[3]_0 [0]),
        .A1(\wr_addr_reg[3]_0 [1]),
        .A2(\wr_addr_reg[3]_0 [2]),
        .A3(\wr_addr_reg[3]_0 [3]),
        .A4(1'b0),
        .D(Q[5]),
        .DPO(rd_curr[5]),
        .DPRA0(\rd_addr_reg_n_0_[0] ),
        .DPRA1(\rd_addr_reg_n_0_[1] ),
        .DPRA2(\rd_addr_reg_n_0_[2] ),
        .DPRA3(\rd_addr_reg_n_0_[3] ),
        .DPRA4(1'b0),
        .SPO(\NLW_bit[5].mem_SPO_UNCONNECTED ),
        .WCLK(pclk),
        .WE(WE0));
  (* BOX_TYPE = "PRIMITIVE" *) 
  RAM32X1D #(
    .INIT(32'h00000000),
    .IS_WCLK_INVERTED(1'b0)) 
    \bit[6].mem 
       (.A0(\wr_addr_reg[3]_0 [0]),
        .A1(\wr_addr_reg[3]_0 [1]),
        .A2(\wr_addr_reg[3]_0 [2]),
        .A3(\wr_addr_reg[3]_0 [3]),
        .A4(1'b0),
        .D(Q[6]),
        .DPO(rd_curr[6]),
        .DPRA0(\rd_addr_reg_n_0_[0] ),
        .DPRA1(\rd_addr_reg_n_0_[1] ),
        .DPRA2(\rd_addr_reg_n_0_[2] ),
        .DPRA3(\rd_addr_reg_n_0_[3] ),
        .DPRA4(1'b0),
        .SPO(\NLW_bit[6].mem_SPO_UNCONNECTED ),
        .WCLK(pclk),
        .WE(WE0));
  (* BOX_TYPE = "PRIMITIVE" *) 
  RAM32X1D #(
    .INIT(32'h00000000),
    .IS_WCLK_INVERTED(1'b0)) 
    \bit[7].mem 
       (.A0(\wr_addr_reg[3]_0 [0]),
        .A1(\wr_addr_reg[3]_0 [1]),
        .A2(\wr_addr_reg[3]_0 [2]),
        .A3(\wr_addr_reg[3]_0 [3]),
        .A4(1'b0),
        .D(Q[7]),
        .DPO(rd_curr[7]),
        .DPRA0(\rd_addr_reg_n_0_[0] ),
        .DPRA1(\rd_addr_reg_n_0_[1] ),
        .DPRA2(\rd_addr_reg_n_0_[2] ),
        .DPRA3(\rd_addr_reg_n_0_[3] ),
        .DPRA4(1'b0),
        .SPO(\NLW_bit[7].mem_SPO_UNCONNECTED ),
        .WCLK(pclk),
        .WE(WE0));
  (* BOX_TYPE = "PRIMITIVE" *) 
  RAM32X1D #(
    .INIT(32'h00000000),
    .IS_WCLK_INVERTED(1'b0)) 
    \bit[8].mem 
       (.A0(\wr_addr_reg[3]_0 [0]),
        .A1(\wr_addr_reg[3]_0 [1]),
        .A2(\wr_addr_reg[3]_0 [2]),
        .A3(\wr_addr_reg[3]_0 [3]),
        .A4(1'b0),
        .D(Q[8]),
        .DPO(rd_curr[8]),
        .DPRA0(\rd_addr_reg_n_0_[0] ),
        .DPRA1(\rd_addr_reg_n_0_[1] ),
        .DPRA2(\rd_addr_reg_n_0_[2] ),
        .DPRA3(\rd_addr_reg_n_0_[3] ),
        .DPRA4(1'b0),
        .SPO(\NLW_bit[8].mem_SPO_UNCONNECTED ),
        .WCLK(pclk),
        .WE(WE0));
  (* BOX_TYPE = "PRIMITIVE" *) 
  RAM32X1D #(
    .INIT(32'h00000000),
    .IS_WCLK_INVERTED(1'b0)) 
    \bit[9].mem 
       (.A0(\wr_addr_reg[3]_0 [0]),
        .A1(\wr_addr_reg[3]_0 [1]),
        .A2(\wr_addr_reg[3]_0 [2]),
        .A3(\wr_addr_reg[3]_0 [3]),
        .A4(1'b0),
        .D(Q[9]),
        .DPO(rd_curr[9]),
        .DPRA0(\rd_addr_reg_n_0_[0] ),
        .DPRA1(\rd_addr_reg_n_0_[1] ),
        .DPRA2(\rd_addr_reg_n_0_[2] ),
        .DPRA3(\rd_addr_reg_n_0_[3] ),
        .DPRA4(1'b0),
        .SPO(\NLW_bit[9].mem_SPO_UNCONNECTED ),
        .WCLK(pclk),
        .WE(WE0));
  (* SOFT_HLUTNM = "soft_lutpair60" *) 
  LUT1 #(
    .INIT(2'h1)) 
    \prime_count[0]_i_1__2 
       (.I0(prime_count_reg[0]),
        .O(\prime_count[0]_i_1__2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair60" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \prime_count[1]_i_1 
       (.I0(prime_count_reg[0]),
        .I1(prime_count_reg[1]),
        .O(p_0_in[1]));
  (* SOFT_HLUTNM = "soft_lutpair54" *) 
  LUT3 #(
    .INIT(8'h78)) 
    \prime_count[2]_i_1 
       (.I0(prime_count_reg[0]),
        .I1(prime_count_reg[1]),
        .I2(prime_count_reg[2]),
        .O(p_0_in[2]));
  LUT5 #(
    .INIT(32'h0000EFFF)) 
    \prime_count[3]_i_1 
       (.I0(prime_count_reg[2]),
        .I1(prime_count_reg[1]),
        .I2(prime_count_reg[0]),
        .I3(prime_count_reg[3]),
        .I4(prime_done_reg_0),
        .O(\prime_count[3]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair54" *) 
  LUT4 #(
    .INIT(16'h7F80)) 
    \prime_count[3]_i_2 
       (.I0(prime_count_reg[1]),
        .I1(prime_count_reg[0]),
        .I2(prime_count_reg[2]),
        .I3(prime_count_reg[3]),
        .O(p_0_in[3]));
  FDRE \prime_count_reg[0] 
       (.C(pixel_clk_2_5x),
        .CE(\prime_count[3]_i_1_n_0 ),
        .D(\prime_count[0]_i_1__2_n_0 ),
        .Q(prime_count_reg[0]),
        .R(reset));
  FDRE \prime_count_reg[1] 
       (.C(pixel_clk_2_5x),
        .CE(\prime_count[3]_i_1_n_0 ),
        .D(p_0_in[1]),
        .Q(prime_count_reg[1]),
        .R(reset));
  FDRE \prime_count_reg[2] 
       (.C(pixel_clk_2_5x),
        .CE(\prime_count[3]_i_1_n_0 ),
        .D(p_0_in[2]),
        .Q(prime_count_reg[2]),
        .R(reset));
  FDRE \prime_count_reg[3] 
       (.C(pixel_clk_2_5x),
        .CE(\prime_count[3]_i_1_n_0 ),
        .D(p_0_in[3]),
        .Q(prime_count_reg[3]),
        .R(reset));
  LUT5 #(
    .INIT(32'hFFFF1000)) 
    prime_done_i_1
       (.I0(prime_count_reg[1]),
        .I1(prime_count_reg[2]),
        .I2(prime_count_reg[0]),
        .I3(prime_count_reg[3]),
        .I4(prime_done_reg_0),
        .O(prime_done_i_1_n_0));
  FDRE prime_done_reg
       (.C(pixel_clk_2_5x),
        .CE(1'b1),
        .D(prime_done_i_1_n_0),
        .Q(prime_done_reg_0),
        .R(reset));
  (* SOFT_HLUTNM = "soft_lutpair59" *) 
  LUT1 #(
    .INIT(2'h1)) 
    \rd_addr[0]_i_1 
       (.I0(\rd_addr_reg_n_0_[0] ),
        .O(\rd_addr[0]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair59" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \rd_addr[1]_i_1 
       (.I0(\rd_addr_reg_n_0_[1] ),
        .I1(\rd_addr_reg_n_0_[0] ),
        .O(\rd_addr[1]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair53" *) 
  LUT3 #(
    .INIT(8'h6A)) 
    \rd_addr[2]_i_1 
       (.I0(\rd_addr_reg_n_0_[2] ),
        .I1(\rd_addr_reg_n_0_[1] ),
        .I2(\rd_addr_reg_n_0_[0] ),
        .O(\rd_addr[2]_i_1_n_0 ));
  LUT3 #(
    .INIT(8'h20)) 
    \rd_addr[3]_i_1 
       (.I0(prime_done_reg_0),
        .I1(rd_ctrl_cnt[2]),
        .I2(rd_ctrl_cnt[0]),
        .O(\rd_addr[3]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair53" *) 
  LUT4 #(
    .INIT(16'h6AAA)) 
    \rd_addr[3]_i_2 
       (.I0(\rd_addr_reg_n_0_[3] ),
        .I1(\rd_addr_reg_n_0_[2] ),
        .I2(\rd_addr_reg_n_0_[0] ),
        .I3(\rd_addr_reg_n_0_[1] ),
        .O(\rd_addr[3]_i_2_n_0 ));
  FDRE \rd_addr_reg[0] 
       (.C(pixel_clk_2_5x),
        .CE(\rd_addr[3]_i_1_n_0 ),
        .D(\rd_addr[0]_i_1_n_0 ),
        .Q(\rd_addr_reg_n_0_[0] ),
        .R(reset));
  FDRE \rd_addr_reg[1] 
       (.C(pixel_clk_2_5x),
        .CE(\rd_addr[3]_i_1_n_0 ),
        .D(\rd_addr[1]_i_1_n_0 ),
        .Q(\rd_addr_reg_n_0_[1] ),
        .R(reset));
  FDRE \rd_addr_reg[2] 
       (.C(pixel_clk_2_5x),
        .CE(\rd_addr[3]_i_1_n_0 ),
        .D(\rd_addr[2]_i_1_n_0 ),
        .Q(\rd_addr_reg_n_0_[2] ),
        .R(reset));
  FDRE \rd_addr_reg[3] 
       (.C(pixel_clk_2_5x),
        .CE(\rd_addr[3]_i_1_n_0 ),
        .D(\rd_addr[3]_i_2_n_0 ),
        .Q(\rd_addr_reg_n_0_[3] ),
        .R(reset));
  FDRE \rd_last_reg[6] 
       (.C(pixel_clk_2_5x),
        .CE(1'b1),
        .D(rd_curr[6]),
        .Q(rd_last[4]),
        .R(1'b0));
  FDRE \rd_last_reg[7] 
       (.C(pixel_clk_2_5x),
        .CE(1'b1),
        .D(rd_curr[7]),
        .Q(rd_last[5]),
        .R(1'b0));
  FDRE \rd_last_reg[8] 
       (.C(pixel_clk_2_5x),
        .CE(1'b1),
        .D(rd_curr[8]),
        .Q(rd_last[6]),
        .R(1'b0));
  FDRE \rd_last_reg[9] 
       (.C(pixel_clk_2_5x),
        .CE(1'b1),
        .D(rd_curr[9]),
        .Q(rd_last[7]),
        .R(1'b0));
  (* SOFT_HLUTNM = "soft_lutpair57" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \tx_data[0]_i_1 
       (.I0(rd_last[4]),
        .I1(rd_ctrl_cnt[2]),
        .I2(\tx_data[0]_i_2_n_0 ),
        .O(\tx_data[0]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \tx_data[0]_i_2 
       (.I0(rd_curr[2]),
        .I1(rd_last[6]),
        .I2(rd_ctrl_cnt[1]),
        .I3(rd_curr[4]),
        .I4(rd_ctrl_cnt[0]),
        .I5(rd_curr[0]),
        .O(\tx_data[0]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair57" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \tx_data[1]_i_1 
       (.I0(rd_last[5]),
        .I1(rd_ctrl_cnt[2]),
        .I2(\tx_data[1]_i_2_n_0 ),
        .O(\tx_data[1]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \tx_data[1]_i_2 
       (.I0(rd_curr[3]),
        .I1(rd_last[7]),
        .I2(rd_ctrl_cnt[1]),
        .I3(rd_curr[5]),
        .I4(rd_ctrl_cnt[0]),
        .I5(rd_curr[1]),
        .O(\tx_data[1]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair58" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \tx_data[2]_i_1 
       (.I0(rd_last[6]),
        .I1(rd_ctrl_cnt[2]),
        .I2(\tx_data[2]_i_2_n_0 ),
        .O(\tx_data[2]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \tx_data[2]_i_2 
       (.I0(rd_curr[4]),
        .I1(rd_curr[0]),
        .I2(rd_ctrl_cnt[1]),
        .I3(rd_curr[6]),
        .I4(rd_ctrl_cnt[0]),
        .I5(rd_curr[2]),
        .O(\tx_data[2]_i_2_n_0 ));
  LUT3 #(
    .INIT(8'h57)) 
    \tx_data[3]_i_2 
       (.I0(rd_ctrl_cnt[2]),
        .I1(rd_ctrl_cnt[1]),
        .I2(rd_ctrl_cnt[0]),
        .O(tx_data));
  (* SOFT_HLUTNM = "soft_lutpair58" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \tx_data[3]_i_3 
       (.I0(rd_last[7]),
        .I1(rd_ctrl_cnt[2]),
        .I2(\tx_data[3]_i_4_n_0 ),
        .O(\tx_data[3]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \tx_data[3]_i_4 
       (.I0(rd_curr[5]),
        .I1(rd_curr[1]),
        .I2(rd_ctrl_cnt[1]),
        .I3(rd_curr[7]),
        .I4(rd_ctrl_cnt[0]),
        .I5(rd_curr[3]),
        .O(\tx_data[3]_i_4_n_0 ));
  FDRE \tx_data_reg[0] 
       (.C(pixel_clk_2_5x),
        .CE(tx_data),
        .D(\tx_data[0]_i_1_n_0 ),
        .Q(\tx_data_reg_n_0_[0] ),
        .R(SR));
  FDRE \tx_data_reg[1] 
       (.C(pixel_clk_2_5x),
        .CE(tx_data),
        .D(\tx_data[1]_i_1_n_0 ),
        .Q(\tx_data_reg_n_0_[1] ),
        .R(SR));
  FDRE \tx_data_reg[2] 
       (.C(pixel_clk_2_5x),
        .CE(tx_data),
        .D(\tx_data[2]_i_1_n_0 ),
        .Q(\tx_data_reg_n_0_[2] ),
        .R(SR));
  FDRE \tx_data_reg[3] 
       (.C(pixel_clk_2_5x),
        .CE(tx_data),
        .D(\tx_data[3]_i_3_n_0 ),
        .Q(\tx_data_reg_n_0_[3] ),
        .R(SR));
  (* SOFT_HLUTNM = "soft_lutpair61" *) 
  LUT1 #(
    .INIT(2'h1)) 
    \wr_addr[0]_i_1 
       (.I0(\wr_addr_reg[3]_0 [0]),
        .O(p_0_in__0[0]));
  (* SOFT_HLUTNM = "soft_lutpair61" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \wr_addr[1]_i_1 
       (.I0(\wr_addr_reg[3]_0 [0]),
        .I1(\wr_addr_reg[3]_0 [1]),
        .O(p_0_in__0[1]));
  (* SOFT_HLUTNM = "soft_lutpair55" *) 
  LUT3 #(
    .INIT(8'h78)) 
    \wr_addr[2]_i_1 
       (.I0(\wr_addr_reg[3]_0 [0]),
        .I1(\wr_addr_reg[3]_0 [1]),
        .I2(\wr_addr_reg[3]_0 [2]),
        .O(p_0_in__0[2]));
  (* SOFT_HLUTNM = "soft_lutpair55" *) 
  LUT4 #(
    .INIT(16'h7F80)) 
    \wr_addr[3]_i_1 
       (.I0(\wr_addr_reg[3]_0 [1]),
        .I1(\wr_addr_reg[3]_0 [0]),
        .I2(\wr_addr_reg[3]_0 [2]),
        .I3(\wr_addr_reg[3]_0 [3]),
        .O(p_0_in__0[3]));
  FDRE \wr_addr_reg[0] 
       (.C(pclk),
        .CE(1'b1),
        .D(p_0_in__0[0]),
        .Q(\wr_addr_reg[3]_0 [0]),
        .R(reset));
  FDRE \wr_addr_reg[1] 
       (.C(pclk),
        .CE(1'b1),
        .D(p_0_in__0[1]),
        .Q(\wr_addr_reg[3]_0 [1]),
        .R(reset));
  FDRE \wr_addr_reg[2] 
       (.C(pclk),
        .CE(1'b1),
        .D(p_0_in__0[2]),
        .Q(\wr_addr_reg[3]_0 [2]),
        .R(reset));
  FDRE \wr_addr_reg[3] 
       (.C(pclk),
        .CE(1'b1),
        .D(p_0_in__0[3]),
        .Q(\wr_addr_reg[3]_0 [3]),
        .R(reset));
endmodule

(* ORIG_REF_NAME = "serializer_10_to_1" *) 
module system_DVI_Transmitter_Safe_0_0_serializer_10_to_1_2
   (tmds_clk_serial,
    prime_done_reg_0,
    pclk,
    WE0,
    \rd_last_reg[6]_0 ,
    pixel_clk_5x,
    pixel_clk_2_5x,
    reset,
    SR);
  output tmds_clk_serial;
  output prime_done_reg_0;
  input pclk;
  input WE0;
  input [3:0]\rd_last_reg[6]_0 ;
  input pixel_clk_5x;
  input pixel_clk_2_5x;
  input reset;
  input [0:0]SR;

  wire \FSM_sequential_rd_ctrl_cnt[1]_i_1__2_n_0 ;
  wire [0:0]SR;
  wire WE0;
  wire [3:1]p_0_in__3;
  wire pclk;
  wire pixel_clk_2_5x;
  wire pixel_clk_5x;
  wire \prime_count[0]_i_1_n_0 ;
  wire \prime_count[3]_i_1__2_n_0 ;
  wire [3:0]prime_count_reg;
  wire prime_done_i_1__2_n_0;
  wire prime_done_reg_0;
  wire \rd_addr[0]_i_1__2_n_0 ;
  wire \rd_addr[1]_i_1__2_n_0 ;
  wire \rd_addr[2]_i_1__2_n_0 ;
  wire \rd_addr[3]_i_1__2_n_0 ;
  wire \rd_addr[3]_i_2__2_n_0 ;
  wire \rd_addr_reg_n_0_[0] ;
  wire \rd_addr_reg_n_0_[1] ;
  wire \rd_addr_reg_n_0_[2] ;
  wire \rd_addr_reg_n_0_[3] ;
  wire [2:0]rd_ctrl_cnt;
  wire [2:0]rd_ctrl_cnt__0;
  wire [9:0]rd_curr;
  wire [7:4]rd_last;
  wire [3:0]\rd_last_reg[6]_0 ;
  wire reset;
  wire tmds_clk_serial;
  wire tx_data;
  wire \tx_data[0]_i_1__2_n_0 ;
  wire \tx_data[0]_i_2__2_n_0 ;
  wire \tx_data[1]_i_1__2_n_0 ;
  wire \tx_data[1]_i_2__2_n_0 ;
  wire \tx_data[2]_i_1__2_n_0 ;
  wire \tx_data[2]_i_2__2_n_0 ;
  wire \tx_data[3]_i_3__2_n_0 ;
  wire \tx_data[3]_i_4__2_n_0 ;
  wire \tx_data_reg_n_0_[0] ;
  wire \tx_data_reg_n_0_[1] ;
  wire \tx_data_reg_n_0_[2] ;
  wire \tx_data_reg_n_0_[3] ;
  wire NLW_OSERDESE3_inst_T_OUT_UNCONNECTED;
  wire \NLW_bit[0].mem_SPO_UNCONNECTED ;
  wire \NLW_bit[1].mem_SPO_UNCONNECTED ;
  wire \NLW_bit[2].mem_SPO_UNCONNECTED ;
  wire \NLW_bit[3].mem_SPO_UNCONNECTED ;
  wire \NLW_bit[4].mem_SPO_UNCONNECTED ;
  wire \NLW_bit[5].mem_SPO_UNCONNECTED ;
  wire \NLW_bit[6].mem_SPO_UNCONNECTED ;
  wire \NLW_bit[7].mem_SPO_UNCONNECTED ;
  wire \NLW_bit[8].mem_SPO_UNCONNECTED ;
  wire \NLW_bit[9].mem_SPO_UNCONNECTED ;

  LUT2 #(
    .INIT(4'h1)) 
    \FSM_sequential_rd_ctrl_cnt[0]_i_1__2 
       (.I0(rd_ctrl_cnt[0]),
        .I1(rd_ctrl_cnt[2]),
        .O(rd_ctrl_cnt__0[0]));
  (* SOFT_HLUTNM = "soft_lutpair64" *) 
  LUT3 #(
    .INIT(8'h06)) 
    \FSM_sequential_rd_ctrl_cnt[1]_i_1__2 
       (.I0(rd_ctrl_cnt[1]),
        .I1(rd_ctrl_cnt[0]),
        .I2(rd_ctrl_cnt[2]),
        .O(\FSM_sequential_rd_ctrl_cnt[1]_i_1__2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair64" *) 
  LUT3 #(
    .INIT(8'h40)) 
    \FSM_sequential_rd_ctrl_cnt[2]_i_1__2 
       (.I0(rd_ctrl_cnt[2]),
        .I1(rd_ctrl_cnt[0]),
        .I2(rd_ctrl_cnt[1]),
        .O(rd_ctrl_cnt__0[2]));
  (* FSM_ENCODED_STATES = "iSTATE:000,iSTATE0:001,iSTATE1:010,iSTATE2:011,iSTATE3:100," *) 
  FDRE \FSM_sequential_rd_ctrl_cnt_reg[0] 
       (.C(pixel_clk_2_5x),
        .CE(prime_done_reg_0),
        .D(rd_ctrl_cnt__0[0]),
        .Q(rd_ctrl_cnt[0]),
        .R(reset));
  (* FSM_ENCODED_STATES = "iSTATE:000,iSTATE0:001,iSTATE1:010,iSTATE2:011,iSTATE3:100," *) 
  FDRE \FSM_sequential_rd_ctrl_cnt_reg[1] 
       (.C(pixel_clk_2_5x),
        .CE(prime_done_reg_0),
        .D(\FSM_sequential_rd_ctrl_cnt[1]_i_1__2_n_0 ),
        .Q(rd_ctrl_cnt[1]),
        .R(reset));
  (* FSM_ENCODED_STATES = "iSTATE:000,iSTATE0:001,iSTATE1:010,iSTATE2:011,iSTATE3:100," *) 
  FDRE \FSM_sequential_rd_ctrl_cnt_reg[2] 
       (.C(pixel_clk_2_5x),
        .CE(prime_done_reg_0),
        .D(rd_ctrl_cnt__0[2]),
        .Q(rd_ctrl_cnt[2]),
        .R(reset));
  (* BOX_TYPE = "PRIMITIVE" *) 
  OSERDESE3 #(
    .DATA_WIDTH(4),
    .INIT(1'b0),
    .IS_CLKDIV_INVERTED(1'b0),
    .IS_CLK_INVERTED(1'b0),
    .IS_RST_INVERTED(1'b0),
    .ODDR_MODE("FALSE"),
    .OSERDES_D_BYPASS("FALSE"),
    .OSERDES_T_BYPASS("FALSE"),
    .SIM_DEVICE("ULTRASCALE_PLUS"),
    .SIM_VERSION(2.000000)) 
    OSERDESE3_inst
       (.CLK(pixel_clk_5x),
        .CLKDIV(pixel_clk_2_5x),
        .D({1'b0,1'b0,1'b0,1'b0,\tx_data_reg_n_0_[3] ,\tx_data_reg_n_0_[2] ,\tx_data_reg_n_0_[1] ,\tx_data_reg_n_0_[0] }),
        .OQ(tmds_clk_serial),
        .RST(reset),
        .T(1'b0),
        .T_OUT(NLW_OSERDESE3_inst_T_OUT_UNCONNECTED));
  (* BOX_TYPE = "PRIMITIVE" *) 
  RAM32X1D #(
    .INIT(32'h00000000),
    .IS_WCLK_INVERTED(1'b0)) 
    \bit[0].mem 
       (.A0(\rd_last_reg[6]_0 [0]),
        .A1(\rd_last_reg[6]_0 [1]),
        .A2(\rd_last_reg[6]_0 [2]),
        .A3(\rd_last_reg[6]_0 [3]),
        .A4(1'b0),
        .D(1'b0),
        .DPO(rd_curr[0]),
        .DPRA0(\rd_addr_reg_n_0_[0] ),
        .DPRA1(\rd_addr_reg_n_0_[1] ),
        .DPRA2(\rd_addr_reg_n_0_[2] ),
        .DPRA3(\rd_addr_reg_n_0_[3] ),
        .DPRA4(1'b0),
        .SPO(\NLW_bit[0].mem_SPO_UNCONNECTED ),
        .WCLK(pclk),
        .WE(WE0));
  (* BOX_TYPE = "PRIMITIVE" *) 
  RAM32X1D #(
    .INIT(32'h00000000),
    .IS_WCLK_INVERTED(1'b0)) 
    \bit[1].mem 
       (.A0(\rd_last_reg[6]_0 [0]),
        .A1(\rd_last_reg[6]_0 [1]),
        .A2(\rd_last_reg[6]_0 [2]),
        .A3(\rd_last_reg[6]_0 [3]),
        .A4(1'b0),
        .D(1'b0),
        .DPO(rd_curr[1]),
        .DPRA0(\rd_addr_reg_n_0_[0] ),
        .DPRA1(\rd_addr_reg_n_0_[1] ),
        .DPRA2(\rd_addr_reg_n_0_[2] ),
        .DPRA3(\rd_addr_reg_n_0_[3] ),
        .DPRA4(1'b0),
        .SPO(\NLW_bit[1].mem_SPO_UNCONNECTED ),
        .WCLK(pclk),
        .WE(WE0));
  (* BOX_TYPE = "PRIMITIVE" *) 
  RAM32X1D #(
    .INIT(32'h00000000),
    .IS_WCLK_INVERTED(1'b0)) 
    \bit[2].mem 
       (.A0(\rd_last_reg[6]_0 [0]),
        .A1(\rd_last_reg[6]_0 [1]),
        .A2(\rd_last_reg[6]_0 [2]),
        .A3(\rd_last_reg[6]_0 [3]),
        .A4(1'b0),
        .D(1'b0),
        .DPO(rd_curr[2]),
        .DPRA0(\rd_addr_reg_n_0_[0] ),
        .DPRA1(\rd_addr_reg_n_0_[1] ),
        .DPRA2(\rd_addr_reg_n_0_[2] ),
        .DPRA3(\rd_addr_reg_n_0_[3] ),
        .DPRA4(1'b0),
        .SPO(\NLW_bit[2].mem_SPO_UNCONNECTED ),
        .WCLK(pclk),
        .WE(WE0));
  (* BOX_TYPE = "PRIMITIVE" *) 
  RAM32X1D #(
    .INIT(32'h00000000),
    .IS_WCLK_INVERTED(1'b0)) 
    \bit[3].mem 
       (.A0(\rd_last_reg[6]_0 [0]),
        .A1(\rd_last_reg[6]_0 [1]),
        .A2(\rd_last_reg[6]_0 [2]),
        .A3(\rd_last_reg[6]_0 [3]),
        .A4(1'b0),
        .D(1'b0),
        .DPO(rd_curr[3]),
        .DPRA0(\rd_addr_reg_n_0_[0] ),
        .DPRA1(\rd_addr_reg_n_0_[1] ),
        .DPRA2(\rd_addr_reg_n_0_[2] ),
        .DPRA3(\rd_addr_reg_n_0_[3] ),
        .DPRA4(1'b0),
        .SPO(\NLW_bit[3].mem_SPO_UNCONNECTED ),
        .WCLK(pclk),
        .WE(WE0));
  (* BOX_TYPE = "PRIMITIVE" *) 
  RAM32X1D #(
    .INIT(32'h00000000),
    .IS_WCLK_INVERTED(1'b0)) 
    \bit[4].mem 
       (.A0(\rd_last_reg[6]_0 [0]),
        .A1(\rd_last_reg[6]_0 [1]),
        .A2(\rd_last_reg[6]_0 [2]),
        .A3(\rd_last_reg[6]_0 [3]),
        .A4(1'b0),
        .D(1'b0),
        .DPO(rd_curr[4]),
        .DPRA0(\rd_addr_reg_n_0_[0] ),
        .DPRA1(\rd_addr_reg_n_0_[1] ),
        .DPRA2(\rd_addr_reg_n_0_[2] ),
        .DPRA3(\rd_addr_reg_n_0_[3] ),
        .DPRA4(1'b0),
        .SPO(\NLW_bit[4].mem_SPO_UNCONNECTED ),
        .WCLK(pclk),
        .WE(WE0));
  (* BOX_TYPE = "PRIMITIVE" *) 
  RAM32X1D #(
    .INIT(32'h00000000),
    .IS_WCLK_INVERTED(1'b0)) 
    \bit[5].mem 
       (.A0(\rd_last_reg[6]_0 [0]),
        .A1(\rd_last_reg[6]_0 [1]),
        .A2(\rd_last_reg[6]_0 [2]),
        .A3(\rd_last_reg[6]_0 [3]),
        .A4(1'b0),
        .D(1'b1),
        .DPO(rd_curr[5]),
        .DPRA0(\rd_addr_reg_n_0_[0] ),
        .DPRA1(\rd_addr_reg_n_0_[1] ),
        .DPRA2(\rd_addr_reg_n_0_[2] ),
        .DPRA3(\rd_addr_reg_n_0_[3] ),
        .DPRA4(1'b0),
        .SPO(\NLW_bit[5].mem_SPO_UNCONNECTED ),
        .WCLK(pclk),
        .WE(WE0));
  (* BOX_TYPE = "PRIMITIVE" *) 
  RAM32X1D #(
    .INIT(32'h00000000),
    .IS_WCLK_INVERTED(1'b0)) 
    \bit[6].mem 
       (.A0(\rd_last_reg[6]_0 [0]),
        .A1(\rd_last_reg[6]_0 [1]),
        .A2(\rd_last_reg[6]_0 [2]),
        .A3(\rd_last_reg[6]_0 [3]),
        .A4(1'b0),
        .D(1'b1),
        .DPO(rd_curr[6]),
        .DPRA0(\rd_addr_reg_n_0_[0] ),
        .DPRA1(\rd_addr_reg_n_0_[1] ),
        .DPRA2(\rd_addr_reg_n_0_[2] ),
        .DPRA3(\rd_addr_reg_n_0_[3] ),
        .DPRA4(1'b0),
        .SPO(\NLW_bit[6].mem_SPO_UNCONNECTED ),
        .WCLK(pclk),
        .WE(WE0));
  (* BOX_TYPE = "PRIMITIVE" *) 
  RAM32X1D #(
    .INIT(32'h00000000),
    .IS_WCLK_INVERTED(1'b0)) 
    \bit[7].mem 
       (.A0(\rd_last_reg[6]_0 [0]),
        .A1(\rd_last_reg[6]_0 [1]),
        .A2(\rd_last_reg[6]_0 [2]),
        .A3(\rd_last_reg[6]_0 [3]),
        .A4(1'b0),
        .D(1'b1),
        .DPO(rd_curr[7]),
        .DPRA0(\rd_addr_reg_n_0_[0] ),
        .DPRA1(\rd_addr_reg_n_0_[1] ),
        .DPRA2(\rd_addr_reg_n_0_[2] ),
        .DPRA3(\rd_addr_reg_n_0_[3] ),
        .DPRA4(1'b0),
        .SPO(\NLW_bit[7].mem_SPO_UNCONNECTED ),
        .WCLK(pclk),
        .WE(WE0));
  (* BOX_TYPE = "PRIMITIVE" *) 
  RAM32X1D #(
    .INIT(32'h00000000),
    .IS_WCLK_INVERTED(1'b0)) 
    \bit[8].mem 
       (.A0(\rd_last_reg[6]_0 [0]),
        .A1(\rd_last_reg[6]_0 [1]),
        .A2(\rd_last_reg[6]_0 [2]),
        .A3(\rd_last_reg[6]_0 [3]),
        .A4(1'b0),
        .D(1'b1),
        .DPO(rd_curr[8]),
        .DPRA0(\rd_addr_reg_n_0_[0] ),
        .DPRA1(\rd_addr_reg_n_0_[1] ),
        .DPRA2(\rd_addr_reg_n_0_[2] ),
        .DPRA3(\rd_addr_reg_n_0_[3] ),
        .DPRA4(1'b0),
        .SPO(\NLW_bit[8].mem_SPO_UNCONNECTED ),
        .WCLK(pclk),
        .WE(WE0));
  (* BOX_TYPE = "PRIMITIVE" *) 
  RAM32X1D #(
    .INIT(32'h00000000),
    .IS_WCLK_INVERTED(1'b0)) 
    \bit[9].mem 
       (.A0(\rd_last_reg[6]_0 [0]),
        .A1(\rd_last_reg[6]_0 [1]),
        .A2(\rd_last_reg[6]_0 [2]),
        .A3(\rd_last_reg[6]_0 [3]),
        .A4(1'b0),
        .D(1'b1),
        .DPO(rd_curr[9]),
        .DPRA0(\rd_addr_reg_n_0_[0] ),
        .DPRA1(\rd_addr_reg_n_0_[1] ),
        .DPRA2(\rd_addr_reg_n_0_[2] ),
        .DPRA3(\rd_addr_reg_n_0_[3] ),
        .DPRA4(1'b0),
        .SPO(\NLW_bit[9].mem_SPO_UNCONNECTED ),
        .WCLK(pclk),
        .WE(WE0));
  (* SOFT_HLUTNM = "soft_lutpair68" *) 
  LUT1 #(
    .INIT(2'h1)) 
    \prime_count[0]_i_1 
       (.I0(prime_count_reg[0]),
        .O(\prime_count[0]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair68" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \prime_count[1]_i_1__2 
       (.I0(prime_count_reg[0]),
        .I1(prime_count_reg[1]),
        .O(p_0_in__3[1]));
  (* SOFT_HLUTNM = "soft_lutpair63" *) 
  LUT3 #(
    .INIT(8'h78)) 
    \prime_count[2]_i_1__2 
       (.I0(prime_count_reg[0]),
        .I1(prime_count_reg[1]),
        .I2(prime_count_reg[2]),
        .O(p_0_in__3[2]));
  LUT5 #(
    .INIT(32'h0000EFFF)) 
    \prime_count[3]_i_1__2 
       (.I0(prime_count_reg[2]),
        .I1(prime_count_reg[1]),
        .I2(prime_count_reg[0]),
        .I3(prime_count_reg[3]),
        .I4(prime_done_reg_0),
        .O(\prime_count[3]_i_1__2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair63" *) 
  LUT4 #(
    .INIT(16'h7F80)) 
    \prime_count[3]_i_2__2 
       (.I0(prime_count_reg[1]),
        .I1(prime_count_reg[0]),
        .I2(prime_count_reg[2]),
        .I3(prime_count_reg[3]),
        .O(p_0_in__3[3]));
  FDRE \prime_count_reg[0] 
       (.C(pixel_clk_2_5x),
        .CE(\prime_count[3]_i_1__2_n_0 ),
        .D(\prime_count[0]_i_1_n_0 ),
        .Q(prime_count_reg[0]),
        .R(reset));
  FDRE \prime_count_reg[1] 
       (.C(pixel_clk_2_5x),
        .CE(\prime_count[3]_i_1__2_n_0 ),
        .D(p_0_in__3[1]),
        .Q(prime_count_reg[1]),
        .R(reset));
  FDRE \prime_count_reg[2] 
       (.C(pixel_clk_2_5x),
        .CE(\prime_count[3]_i_1__2_n_0 ),
        .D(p_0_in__3[2]),
        .Q(prime_count_reg[2]),
        .R(reset));
  FDRE \prime_count_reg[3] 
       (.C(pixel_clk_2_5x),
        .CE(\prime_count[3]_i_1__2_n_0 ),
        .D(p_0_in__3[3]),
        .Q(prime_count_reg[3]),
        .R(reset));
  LUT5 #(
    .INIT(32'hFFFF1000)) 
    prime_done_i_1__2
       (.I0(prime_count_reg[1]),
        .I1(prime_count_reg[2]),
        .I2(prime_count_reg[0]),
        .I3(prime_count_reg[3]),
        .I4(prime_done_reg_0),
        .O(prime_done_i_1__2_n_0));
  FDRE prime_done_reg
       (.C(pixel_clk_2_5x),
        .CE(1'b1),
        .D(prime_done_i_1__2_n_0),
        .Q(prime_done_reg_0),
        .R(reset));
  (* SOFT_HLUTNM = "soft_lutpair67" *) 
  LUT1 #(
    .INIT(2'h1)) 
    \rd_addr[0]_i_1__2 
       (.I0(\rd_addr_reg_n_0_[0] ),
        .O(\rd_addr[0]_i_1__2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair67" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \rd_addr[1]_i_1__2 
       (.I0(\rd_addr_reg_n_0_[1] ),
        .I1(\rd_addr_reg_n_0_[0] ),
        .O(\rd_addr[1]_i_1__2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair62" *) 
  LUT3 #(
    .INIT(8'h6A)) 
    \rd_addr[2]_i_1__2 
       (.I0(\rd_addr_reg_n_0_[2] ),
        .I1(\rd_addr_reg_n_0_[1] ),
        .I2(\rd_addr_reg_n_0_[0] ),
        .O(\rd_addr[2]_i_1__2_n_0 ));
  LUT3 #(
    .INIT(8'h20)) 
    \rd_addr[3]_i_1__2 
       (.I0(prime_done_reg_0),
        .I1(rd_ctrl_cnt[2]),
        .I2(rd_ctrl_cnt[0]),
        .O(\rd_addr[3]_i_1__2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair62" *) 
  LUT4 #(
    .INIT(16'h6AAA)) 
    \rd_addr[3]_i_2__2 
       (.I0(\rd_addr_reg_n_0_[3] ),
        .I1(\rd_addr_reg_n_0_[2] ),
        .I2(\rd_addr_reg_n_0_[0] ),
        .I3(\rd_addr_reg_n_0_[1] ),
        .O(\rd_addr[3]_i_2__2_n_0 ));
  FDRE \rd_addr_reg[0] 
       (.C(pixel_clk_2_5x),
        .CE(\rd_addr[3]_i_1__2_n_0 ),
        .D(\rd_addr[0]_i_1__2_n_0 ),
        .Q(\rd_addr_reg_n_0_[0] ),
        .R(reset));
  FDRE \rd_addr_reg[1] 
       (.C(pixel_clk_2_5x),
        .CE(\rd_addr[3]_i_1__2_n_0 ),
        .D(\rd_addr[1]_i_1__2_n_0 ),
        .Q(\rd_addr_reg_n_0_[1] ),
        .R(reset));
  FDRE \rd_addr_reg[2] 
       (.C(pixel_clk_2_5x),
        .CE(\rd_addr[3]_i_1__2_n_0 ),
        .D(\rd_addr[2]_i_1__2_n_0 ),
        .Q(\rd_addr_reg_n_0_[2] ),
        .R(reset));
  FDRE \rd_addr_reg[3] 
       (.C(pixel_clk_2_5x),
        .CE(\rd_addr[3]_i_1__2_n_0 ),
        .D(\rd_addr[3]_i_2__2_n_0 ),
        .Q(\rd_addr_reg_n_0_[3] ),
        .R(reset));
  FDRE \rd_last_reg[6] 
       (.C(pixel_clk_2_5x),
        .CE(1'b1),
        .D(rd_curr[6]),
        .Q(rd_last[4]),
        .R(1'b0));
  FDRE \rd_last_reg[7] 
       (.C(pixel_clk_2_5x),
        .CE(1'b1),
        .D(rd_curr[7]),
        .Q(rd_last[5]),
        .R(1'b0));
  FDRE \rd_last_reg[8] 
       (.C(pixel_clk_2_5x),
        .CE(1'b1),
        .D(rd_curr[8]),
        .Q(rd_last[6]),
        .R(1'b0));
  FDRE \rd_last_reg[9] 
       (.C(pixel_clk_2_5x),
        .CE(1'b1),
        .D(rd_curr[9]),
        .Q(rd_last[7]),
        .R(1'b0));
  (* SOFT_HLUTNM = "soft_lutpair65" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \tx_data[0]_i_1__2 
       (.I0(rd_last[4]),
        .I1(rd_ctrl_cnt[2]),
        .I2(\tx_data[0]_i_2__2_n_0 ),
        .O(\tx_data[0]_i_1__2_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \tx_data[0]_i_2__2 
       (.I0(rd_curr[2]),
        .I1(rd_last[6]),
        .I2(rd_ctrl_cnt[1]),
        .I3(rd_curr[4]),
        .I4(rd_ctrl_cnt[0]),
        .I5(rd_curr[0]),
        .O(\tx_data[0]_i_2__2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair65" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \tx_data[1]_i_1__2 
       (.I0(rd_last[5]),
        .I1(rd_ctrl_cnt[2]),
        .I2(\tx_data[1]_i_2__2_n_0 ),
        .O(\tx_data[1]_i_1__2_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \tx_data[1]_i_2__2 
       (.I0(rd_curr[3]),
        .I1(rd_last[7]),
        .I2(rd_ctrl_cnt[1]),
        .I3(rd_curr[5]),
        .I4(rd_ctrl_cnt[0]),
        .I5(rd_curr[1]),
        .O(\tx_data[1]_i_2__2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair66" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \tx_data[2]_i_1__2 
       (.I0(rd_last[6]),
        .I1(rd_ctrl_cnt[2]),
        .I2(\tx_data[2]_i_2__2_n_0 ),
        .O(\tx_data[2]_i_1__2_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \tx_data[2]_i_2__2 
       (.I0(rd_curr[4]),
        .I1(rd_curr[0]),
        .I2(rd_ctrl_cnt[1]),
        .I3(rd_curr[6]),
        .I4(rd_ctrl_cnt[0]),
        .I5(rd_curr[2]),
        .O(\tx_data[2]_i_2__2_n_0 ));
  LUT3 #(
    .INIT(8'h57)) 
    \tx_data[3]_i_2__2 
       (.I0(rd_ctrl_cnt[2]),
        .I1(rd_ctrl_cnt[1]),
        .I2(rd_ctrl_cnt[0]),
        .O(tx_data));
  (* SOFT_HLUTNM = "soft_lutpair66" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \tx_data[3]_i_3__2 
       (.I0(rd_last[7]),
        .I1(rd_ctrl_cnt[2]),
        .I2(\tx_data[3]_i_4__2_n_0 ),
        .O(\tx_data[3]_i_3__2_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \tx_data[3]_i_4__2 
       (.I0(rd_curr[5]),
        .I1(rd_curr[1]),
        .I2(rd_ctrl_cnt[1]),
        .I3(rd_curr[7]),
        .I4(rd_ctrl_cnt[0]),
        .I5(rd_curr[3]),
        .O(\tx_data[3]_i_4__2_n_0 ));
  FDRE \tx_data_reg[0] 
       (.C(pixel_clk_2_5x),
        .CE(tx_data),
        .D(\tx_data[0]_i_1__2_n_0 ),
        .Q(\tx_data_reg_n_0_[0] ),
        .R(SR));
  FDRE \tx_data_reg[1] 
       (.C(pixel_clk_2_5x),
        .CE(tx_data),
        .D(\tx_data[1]_i_1__2_n_0 ),
        .Q(\tx_data_reg_n_0_[1] ),
        .R(SR));
  FDRE \tx_data_reg[2] 
       (.C(pixel_clk_2_5x),
        .CE(tx_data),
        .D(\tx_data[2]_i_1__2_n_0 ),
        .Q(\tx_data_reg_n_0_[2] ),
        .R(SR));
  FDRE \tx_data_reg[3] 
       (.C(pixel_clk_2_5x),
        .CE(tx_data),
        .D(\tx_data[3]_i_3__2_n_0 ),
        .Q(\tx_data_reg_n_0_[3] ),
        .R(SR));
endmodule

(* ORIG_REF_NAME = "serializer_10_to_1" *) 
module system_DVI_Transmitter_Safe_0_0_serializer_10_to_1_3
   (tmds_data_serial_1,
    prime_done_reg_0,
    pclk,
    Q,
    WE0,
    \rd_last_reg[6]_0 ,
    pixel_clk_5x,
    pixel_clk_2_5x,
    reset,
    SR);
  output tmds_data_serial_1;
  output prime_done_reg_0;
  input pclk;
  input [9:0]Q;
  input WE0;
  input [3:0]\rd_last_reg[6]_0 ;
  input pixel_clk_5x;
  input pixel_clk_2_5x;
  input reset;
  input [0:0]SR;

  wire \FSM_sequential_rd_ctrl_cnt[1]_i_1__0_n_0 ;
  wire [9:0]Q;
  wire [0:0]SR;
  wire WE0;
  wire [3:1]p_0_in__1;
  wire pclk;
  wire pixel_clk_2_5x;
  wire pixel_clk_5x;
  wire \prime_count[0]_i_1__1_n_0 ;
  wire \prime_count[3]_i_1__0_n_0 ;
  wire [3:0]prime_count_reg;
  wire prime_done_i_1__0_n_0;
  wire prime_done_reg_0;
  wire \rd_addr[0]_i_1__0_n_0 ;
  wire \rd_addr[1]_i_1__0_n_0 ;
  wire \rd_addr[2]_i_1__0_n_0 ;
  wire \rd_addr[3]_i_1__0_n_0 ;
  wire \rd_addr[3]_i_2__0_n_0 ;
  wire \rd_addr_reg_n_0_[0] ;
  wire \rd_addr_reg_n_0_[1] ;
  wire \rd_addr_reg_n_0_[2] ;
  wire \rd_addr_reg_n_0_[3] ;
  wire [2:0]rd_ctrl_cnt;
  wire [2:0]rd_ctrl_cnt__0;
  wire [9:0]rd_curr;
  wire [7:4]rd_last;
  wire [3:0]\rd_last_reg[6]_0 ;
  wire reset;
  wire tmds_data_serial_1;
  wire tx_data;
  wire \tx_data[0]_i_1__0_n_0 ;
  wire \tx_data[0]_i_2__0_n_0 ;
  wire \tx_data[1]_i_1__0_n_0 ;
  wire \tx_data[1]_i_2__0_n_0 ;
  wire \tx_data[2]_i_1__0_n_0 ;
  wire \tx_data[2]_i_2__0_n_0 ;
  wire \tx_data[3]_i_3__0_n_0 ;
  wire \tx_data[3]_i_4__0_n_0 ;
  wire \tx_data_reg_n_0_[0] ;
  wire \tx_data_reg_n_0_[1] ;
  wire \tx_data_reg_n_0_[2] ;
  wire \tx_data_reg_n_0_[3] ;
  wire NLW_OSERDESE3_inst_T_OUT_UNCONNECTED;
  wire \NLW_bit[0].mem_SPO_UNCONNECTED ;
  wire \NLW_bit[1].mem_SPO_UNCONNECTED ;
  wire \NLW_bit[2].mem_SPO_UNCONNECTED ;
  wire \NLW_bit[3].mem_SPO_UNCONNECTED ;
  wire \NLW_bit[4].mem_SPO_UNCONNECTED ;
  wire \NLW_bit[5].mem_SPO_UNCONNECTED ;
  wire \NLW_bit[6].mem_SPO_UNCONNECTED ;
  wire \NLW_bit[7].mem_SPO_UNCONNECTED ;
  wire \NLW_bit[8].mem_SPO_UNCONNECTED ;
  wire \NLW_bit[9].mem_SPO_UNCONNECTED ;

  LUT2 #(
    .INIT(4'h1)) 
    \FSM_sequential_rd_ctrl_cnt[0]_i_1__0 
       (.I0(rd_ctrl_cnt[0]),
        .I1(rd_ctrl_cnt[2]),
        .O(rd_ctrl_cnt__0[0]));
  (* SOFT_HLUTNM = "soft_lutpair71" *) 
  LUT3 #(
    .INIT(8'h06)) 
    \FSM_sequential_rd_ctrl_cnt[1]_i_1__0 
       (.I0(rd_ctrl_cnt[1]),
        .I1(rd_ctrl_cnt[0]),
        .I2(rd_ctrl_cnt[2]),
        .O(\FSM_sequential_rd_ctrl_cnt[1]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair71" *) 
  LUT3 #(
    .INIT(8'h40)) 
    \FSM_sequential_rd_ctrl_cnt[2]_i_1__0 
       (.I0(rd_ctrl_cnt[2]),
        .I1(rd_ctrl_cnt[0]),
        .I2(rd_ctrl_cnt[1]),
        .O(rd_ctrl_cnt__0[2]));
  (* FSM_ENCODED_STATES = "iSTATE:000,iSTATE0:001,iSTATE1:010,iSTATE2:011,iSTATE3:100," *) 
  FDRE \FSM_sequential_rd_ctrl_cnt_reg[0] 
       (.C(pixel_clk_2_5x),
        .CE(prime_done_reg_0),
        .D(rd_ctrl_cnt__0[0]),
        .Q(rd_ctrl_cnt[0]),
        .R(reset));
  (* FSM_ENCODED_STATES = "iSTATE:000,iSTATE0:001,iSTATE1:010,iSTATE2:011,iSTATE3:100," *) 
  FDRE \FSM_sequential_rd_ctrl_cnt_reg[1] 
       (.C(pixel_clk_2_5x),
        .CE(prime_done_reg_0),
        .D(\FSM_sequential_rd_ctrl_cnt[1]_i_1__0_n_0 ),
        .Q(rd_ctrl_cnt[1]),
        .R(reset));
  (* FSM_ENCODED_STATES = "iSTATE:000,iSTATE0:001,iSTATE1:010,iSTATE2:011,iSTATE3:100," *) 
  FDRE \FSM_sequential_rd_ctrl_cnt_reg[2] 
       (.C(pixel_clk_2_5x),
        .CE(prime_done_reg_0),
        .D(rd_ctrl_cnt__0[2]),
        .Q(rd_ctrl_cnt[2]),
        .R(reset));
  (* BOX_TYPE = "PRIMITIVE" *) 
  OSERDESE3 #(
    .DATA_WIDTH(4),
    .INIT(1'b0),
    .IS_CLKDIV_INVERTED(1'b0),
    .IS_CLK_INVERTED(1'b0),
    .IS_RST_INVERTED(1'b0),
    .ODDR_MODE("FALSE"),
    .OSERDES_D_BYPASS("FALSE"),
    .OSERDES_T_BYPASS("FALSE"),
    .SIM_DEVICE("ULTRASCALE_PLUS"),
    .SIM_VERSION(2.000000)) 
    OSERDESE3_inst
       (.CLK(pixel_clk_5x),
        .CLKDIV(pixel_clk_2_5x),
        .D({1'b0,1'b0,1'b0,1'b0,\tx_data_reg_n_0_[3] ,\tx_data_reg_n_0_[2] ,\tx_data_reg_n_0_[1] ,\tx_data_reg_n_0_[0] }),
        .OQ(tmds_data_serial_1),
        .RST(reset),
        .T(1'b0),
        .T_OUT(NLW_OSERDESE3_inst_T_OUT_UNCONNECTED));
  (* BOX_TYPE = "PRIMITIVE" *) 
  RAM32X1D #(
    .INIT(32'h00000000),
    .IS_WCLK_INVERTED(1'b0)) 
    \bit[0].mem 
       (.A0(\rd_last_reg[6]_0 [0]),
        .A1(\rd_last_reg[6]_0 [1]),
        .A2(\rd_last_reg[6]_0 [2]),
        .A3(\rd_last_reg[6]_0 [3]),
        .A4(1'b0),
        .D(Q[0]),
        .DPO(rd_curr[0]),
        .DPRA0(\rd_addr_reg_n_0_[0] ),
        .DPRA1(\rd_addr_reg_n_0_[1] ),
        .DPRA2(\rd_addr_reg_n_0_[2] ),
        .DPRA3(\rd_addr_reg_n_0_[3] ),
        .DPRA4(1'b0),
        .SPO(\NLW_bit[0].mem_SPO_UNCONNECTED ),
        .WCLK(pclk),
        .WE(WE0));
  (* BOX_TYPE = "PRIMITIVE" *) 
  RAM32X1D #(
    .INIT(32'h00000000),
    .IS_WCLK_INVERTED(1'b0)) 
    \bit[1].mem 
       (.A0(\rd_last_reg[6]_0 [0]),
        .A1(\rd_last_reg[6]_0 [1]),
        .A2(\rd_last_reg[6]_0 [2]),
        .A3(\rd_last_reg[6]_0 [3]),
        .A4(1'b0),
        .D(Q[1]),
        .DPO(rd_curr[1]),
        .DPRA0(\rd_addr_reg_n_0_[0] ),
        .DPRA1(\rd_addr_reg_n_0_[1] ),
        .DPRA2(\rd_addr_reg_n_0_[2] ),
        .DPRA3(\rd_addr_reg_n_0_[3] ),
        .DPRA4(1'b0),
        .SPO(\NLW_bit[1].mem_SPO_UNCONNECTED ),
        .WCLK(pclk),
        .WE(WE0));
  (* BOX_TYPE = "PRIMITIVE" *) 
  RAM32X1D #(
    .INIT(32'h00000000),
    .IS_WCLK_INVERTED(1'b0)) 
    \bit[2].mem 
       (.A0(\rd_last_reg[6]_0 [0]),
        .A1(\rd_last_reg[6]_0 [1]),
        .A2(\rd_last_reg[6]_0 [2]),
        .A3(\rd_last_reg[6]_0 [3]),
        .A4(1'b0),
        .D(Q[2]),
        .DPO(rd_curr[2]),
        .DPRA0(\rd_addr_reg_n_0_[0] ),
        .DPRA1(\rd_addr_reg_n_0_[1] ),
        .DPRA2(\rd_addr_reg_n_0_[2] ),
        .DPRA3(\rd_addr_reg_n_0_[3] ),
        .DPRA4(1'b0),
        .SPO(\NLW_bit[2].mem_SPO_UNCONNECTED ),
        .WCLK(pclk),
        .WE(WE0));
  (* BOX_TYPE = "PRIMITIVE" *) 
  RAM32X1D #(
    .INIT(32'h00000000),
    .IS_WCLK_INVERTED(1'b0)) 
    \bit[3].mem 
       (.A0(\rd_last_reg[6]_0 [0]),
        .A1(\rd_last_reg[6]_0 [1]),
        .A2(\rd_last_reg[6]_0 [2]),
        .A3(\rd_last_reg[6]_0 [3]),
        .A4(1'b0),
        .D(Q[3]),
        .DPO(rd_curr[3]),
        .DPRA0(\rd_addr_reg_n_0_[0] ),
        .DPRA1(\rd_addr_reg_n_0_[1] ),
        .DPRA2(\rd_addr_reg_n_0_[2] ),
        .DPRA3(\rd_addr_reg_n_0_[3] ),
        .DPRA4(1'b0),
        .SPO(\NLW_bit[3].mem_SPO_UNCONNECTED ),
        .WCLK(pclk),
        .WE(WE0));
  (* BOX_TYPE = "PRIMITIVE" *) 
  RAM32X1D #(
    .INIT(32'h00000000),
    .IS_WCLK_INVERTED(1'b0)) 
    \bit[4].mem 
       (.A0(\rd_last_reg[6]_0 [0]),
        .A1(\rd_last_reg[6]_0 [1]),
        .A2(\rd_last_reg[6]_0 [2]),
        .A3(\rd_last_reg[6]_0 [3]),
        .A4(1'b0),
        .D(Q[4]),
        .DPO(rd_curr[4]),
        .DPRA0(\rd_addr_reg_n_0_[0] ),
        .DPRA1(\rd_addr_reg_n_0_[1] ),
        .DPRA2(\rd_addr_reg_n_0_[2] ),
        .DPRA3(\rd_addr_reg_n_0_[3] ),
        .DPRA4(1'b0),
        .SPO(\NLW_bit[4].mem_SPO_UNCONNECTED ),
        .WCLK(pclk),
        .WE(WE0));
  (* BOX_TYPE = "PRIMITIVE" *) 
  RAM32X1D #(
    .INIT(32'h00000000),
    .IS_WCLK_INVERTED(1'b0)) 
    \bit[5].mem 
       (.A0(\rd_last_reg[6]_0 [0]),
        .A1(\rd_last_reg[6]_0 [1]),
        .A2(\rd_last_reg[6]_0 [2]),
        .A3(\rd_last_reg[6]_0 [3]),
        .A4(1'b0),
        .D(Q[5]),
        .DPO(rd_curr[5]),
        .DPRA0(\rd_addr_reg_n_0_[0] ),
        .DPRA1(\rd_addr_reg_n_0_[1] ),
        .DPRA2(\rd_addr_reg_n_0_[2] ),
        .DPRA3(\rd_addr_reg_n_0_[3] ),
        .DPRA4(1'b0),
        .SPO(\NLW_bit[5].mem_SPO_UNCONNECTED ),
        .WCLK(pclk),
        .WE(WE0));
  (* BOX_TYPE = "PRIMITIVE" *) 
  RAM32X1D #(
    .INIT(32'h00000000),
    .IS_WCLK_INVERTED(1'b0)) 
    \bit[6].mem 
       (.A0(\rd_last_reg[6]_0 [0]),
        .A1(\rd_last_reg[6]_0 [1]),
        .A2(\rd_last_reg[6]_0 [2]),
        .A3(\rd_last_reg[6]_0 [3]),
        .A4(1'b0),
        .D(Q[6]),
        .DPO(rd_curr[6]),
        .DPRA0(\rd_addr_reg_n_0_[0] ),
        .DPRA1(\rd_addr_reg_n_0_[1] ),
        .DPRA2(\rd_addr_reg_n_0_[2] ),
        .DPRA3(\rd_addr_reg_n_0_[3] ),
        .DPRA4(1'b0),
        .SPO(\NLW_bit[6].mem_SPO_UNCONNECTED ),
        .WCLK(pclk),
        .WE(WE0));
  (* BOX_TYPE = "PRIMITIVE" *) 
  RAM32X1D #(
    .INIT(32'h00000000),
    .IS_WCLK_INVERTED(1'b0)) 
    \bit[7].mem 
       (.A0(\rd_last_reg[6]_0 [0]),
        .A1(\rd_last_reg[6]_0 [1]),
        .A2(\rd_last_reg[6]_0 [2]),
        .A3(\rd_last_reg[6]_0 [3]),
        .A4(1'b0),
        .D(Q[7]),
        .DPO(rd_curr[7]),
        .DPRA0(\rd_addr_reg_n_0_[0] ),
        .DPRA1(\rd_addr_reg_n_0_[1] ),
        .DPRA2(\rd_addr_reg_n_0_[2] ),
        .DPRA3(\rd_addr_reg_n_0_[3] ),
        .DPRA4(1'b0),
        .SPO(\NLW_bit[7].mem_SPO_UNCONNECTED ),
        .WCLK(pclk),
        .WE(WE0));
  (* BOX_TYPE = "PRIMITIVE" *) 
  RAM32X1D #(
    .INIT(32'h00000000),
    .IS_WCLK_INVERTED(1'b0)) 
    \bit[8].mem 
       (.A0(\rd_last_reg[6]_0 [0]),
        .A1(\rd_last_reg[6]_0 [1]),
        .A2(\rd_last_reg[6]_0 [2]),
        .A3(\rd_last_reg[6]_0 [3]),
        .A4(1'b0),
        .D(Q[8]),
        .DPO(rd_curr[8]),
        .DPRA0(\rd_addr_reg_n_0_[0] ),
        .DPRA1(\rd_addr_reg_n_0_[1] ),
        .DPRA2(\rd_addr_reg_n_0_[2] ),
        .DPRA3(\rd_addr_reg_n_0_[3] ),
        .DPRA4(1'b0),
        .SPO(\NLW_bit[8].mem_SPO_UNCONNECTED ),
        .WCLK(pclk),
        .WE(WE0));
  (* BOX_TYPE = "PRIMITIVE" *) 
  RAM32X1D #(
    .INIT(32'h00000000),
    .IS_WCLK_INVERTED(1'b0)) 
    \bit[9].mem 
       (.A0(\rd_last_reg[6]_0 [0]),
        .A1(\rd_last_reg[6]_0 [1]),
        .A2(\rd_last_reg[6]_0 [2]),
        .A3(\rd_last_reg[6]_0 [3]),
        .A4(1'b0),
        .D(Q[9]),
        .DPO(rd_curr[9]),
        .DPRA0(\rd_addr_reg_n_0_[0] ),
        .DPRA1(\rd_addr_reg_n_0_[1] ),
        .DPRA2(\rd_addr_reg_n_0_[2] ),
        .DPRA3(\rd_addr_reg_n_0_[3] ),
        .DPRA4(1'b0),
        .SPO(\NLW_bit[9].mem_SPO_UNCONNECTED ),
        .WCLK(pclk),
        .WE(WE0));
  (* SOFT_HLUTNM = "soft_lutpair75" *) 
  LUT1 #(
    .INIT(2'h1)) 
    \prime_count[0]_i_1__1 
       (.I0(prime_count_reg[0]),
        .O(\prime_count[0]_i_1__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair75" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \prime_count[1]_i_1__0 
       (.I0(prime_count_reg[0]),
        .I1(prime_count_reg[1]),
        .O(p_0_in__1[1]));
  (* SOFT_HLUTNM = "soft_lutpair70" *) 
  LUT3 #(
    .INIT(8'h78)) 
    \prime_count[2]_i_1__0 
       (.I0(prime_count_reg[0]),
        .I1(prime_count_reg[1]),
        .I2(prime_count_reg[2]),
        .O(p_0_in__1[2]));
  LUT5 #(
    .INIT(32'h0000EFFF)) 
    \prime_count[3]_i_1__0 
       (.I0(prime_count_reg[2]),
        .I1(prime_count_reg[1]),
        .I2(prime_count_reg[0]),
        .I3(prime_count_reg[3]),
        .I4(prime_done_reg_0),
        .O(\prime_count[3]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair70" *) 
  LUT4 #(
    .INIT(16'h7F80)) 
    \prime_count[3]_i_2__0 
       (.I0(prime_count_reg[1]),
        .I1(prime_count_reg[0]),
        .I2(prime_count_reg[2]),
        .I3(prime_count_reg[3]),
        .O(p_0_in__1[3]));
  FDRE \prime_count_reg[0] 
       (.C(pixel_clk_2_5x),
        .CE(\prime_count[3]_i_1__0_n_0 ),
        .D(\prime_count[0]_i_1__1_n_0 ),
        .Q(prime_count_reg[0]),
        .R(reset));
  FDRE \prime_count_reg[1] 
       (.C(pixel_clk_2_5x),
        .CE(\prime_count[3]_i_1__0_n_0 ),
        .D(p_0_in__1[1]),
        .Q(prime_count_reg[1]),
        .R(reset));
  FDRE \prime_count_reg[2] 
       (.C(pixel_clk_2_5x),
        .CE(\prime_count[3]_i_1__0_n_0 ),
        .D(p_0_in__1[2]),
        .Q(prime_count_reg[2]),
        .R(reset));
  FDRE \prime_count_reg[3] 
       (.C(pixel_clk_2_5x),
        .CE(\prime_count[3]_i_1__0_n_0 ),
        .D(p_0_in__1[3]),
        .Q(prime_count_reg[3]),
        .R(reset));
  LUT5 #(
    .INIT(32'hFFFF1000)) 
    prime_done_i_1__0
       (.I0(prime_count_reg[1]),
        .I1(prime_count_reg[2]),
        .I2(prime_count_reg[0]),
        .I3(prime_count_reg[3]),
        .I4(prime_done_reg_0),
        .O(prime_done_i_1__0_n_0));
  FDRE prime_done_reg
       (.C(pixel_clk_2_5x),
        .CE(1'b1),
        .D(prime_done_i_1__0_n_0),
        .Q(prime_done_reg_0),
        .R(reset));
  (* SOFT_HLUTNM = "soft_lutpair74" *) 
  LUT1 #(
    .INIT(2'h1)) 
    \rd_addr[0]_i_1__0 
       (.I0(\rd_addr_reg_n_0_[0] ),
        .O(\rd_addr[0]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair74" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \rd_addr[1]_i_1__0 
       (.I0(\rd_addr_reg_n_0_[1] ),
        .I1(\rd_addr_reg_n_0_[0] ),
        .O(\rd_addr[1]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair69" *) 
  LUT3 #(
    .INIT(8'h6A)) 
    \rd_addr[2]_i_1__0 
       (.I0(\rd_addr_reg_n_0_[2] ),
        .I1(\rd_addr_reg_n_0_[1] ),
        .I2(\rd_addr_reg_n_0_[0] ),
        .O(\rd_addr[2]_i_1__0_n_0 ));
  LUT3 #(
    .INIT(8'h20)) 
    \rd_addr[3]_i_1__0 
       (.I0(prime_done_reg_0),
        .I1(rd_ctrl_cnt[2]),
        .I2(rd_ctrl_cnt[0]),
        .O(\rd_addr[3]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair69" *) 
  LUT4 #(
    .INIT(16'h6AAA)) 
    \rd_addr[3]_i_2__0 
       (.I0(\rd_addr_reg_n_0_[3] ),
        .I1(\rd_addr_reg_n_0_[2] ),
        .I2(\rd_addr_reg_n_0_[0] ),
        .I3(\rd_addr_reg_n_0_[1] ),
        .O(\rd_addr[3]_i_2__0_n_0 ));
  FDRE \rd_addr_reg[0] 
       (.C(pixel_clk_2_5x),
        .CE(\rd_addr[3]_i_1__0_n_0 ),
        .D(\rd_addr[0]_i_1__0_n_0 ),
        .Q(\rd_addr_reg_n_0_[0] ),
        .R(reset));
  FDRE \rd_addr_reg[1] 
       (.C(pixel_clk_2_5x),
        .CE(\rd_addr[3]_i_1__0_n_0 ),
        .D(\rd_addr[1]_i_1__0_n_0 ),
        .Q(\rd_addr_reg_n_0_[1] ),
        .R(reset));
  FDRE \rd_addr_reg[2] 
       (.C(pixel_clk_2_5x),
        .CE(\rd_addr[3]_i_1__0_n_0 ),
        .D(\rd_addr[2]_i_1__0_n_0 ),
        .Q(\rd_addr_reg_n_0_[2] ),
        .R(reset));
  FDRE \rd_addr_reg[3] 
       (.C(pixel_clk_2_5x),
        .CE(\rd_addr[3]_i_1__0_n_0 ),
        .D(\rd_addr[3]_i_2__0_n_0 ),
        .Q(\rd_addr_reg_n_0_[3] ),
        .R(reset));
  FDRE \rd_last_reg[6] 
       (.C(pixel_clk_2_5x),
        .CE(1'b1),
        .D(rd_curr[6]),
        .Q(rd_last[4]),
        .R(1'b0));
  FDRE \rd_last_reg[7] 
       (.C(pixel_clk_2_5x),
        .CE(1'b1),
        .D(rd_curr[7]),
        .Q(rd_last[5]),
        .R(1'b0));
  FDRE \rd_last_reg[8] 
       (.C(pixel_clk_2_5x),
        .CE(1'b1),
        .D(rd_curr[8]),
        .Q(rd_last[6]),
        .R(1'b0));
  FDRE \rd_last_reg[9] 
       (.C(pixel_clk_2_5x),
        .CE(1'b1),
        .D(rd_curr[9]),
        .Q(rd_last[7]),
        .R(1'b0));
  (* SOFT_HLUTNM = "soft_lutpair72" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \tx_data[0]_i_1__0 
       (.I0(rd_last[4]),
        .I1(rd_ctrl_cnt[2]),
        .I2(\tx_data[0]_i_2__0_n_0 ),
        .O(\tx_data[0]_i_1__0_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \tx_data[0]_i_2__0 
       (.I0(rd_curr[2]),
        .I1(rd_last[6]),
        .I2(rd_ctrl_cnt[1]),
        .I3(rd_curr[4]),
        .I4(rd_ctrl_cnt[0]),
        .I5(rd_curr[0]),
        .O(\tx_data[0]_i_2__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair72" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \tx_data[1]_i_1__0 
       (.I0(rd_last[5]),
        .I1(rd_ctrl_cnt[2]),
        .I2(\tx_data[1]_i_2__0_n_0 ),
        .O(\tx_data[1]_i_1__0_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \tx_data[1]_i_2__0 
       (.I0(rd_curr[3]),
        .I1(rd_last[7]),
        .I2(rd_ctrl_cnt[1]),
        .I3(rd_curr[5]),
        .I4(rd_ctrl_cnt[0]),
        .I5(rd_curr[1]),
        .O(\tx_data[1]_i_2__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair73" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \tx_data[2]_i_1__0 
       (.I0(rd_last[6]),
        .I1(rd_ctrl_cnt[2]),
        .I2(\tx_data[2]_i_2__0_n_0 ),
        .O(\tx_data[2]_i_1__0_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \tx_data[2]_i_2__0 
       (.I0(rd_curr[4]),
        .I1(rd_curr[0]),
        .I2(rd_ctrl_cnt[1]),
        .I3(rd_curr[6]),
        .I4(rd_ctrl_cnt[0]),
        .I5(rd_curr[2]),
        .O(\tx_data[2]_i_2__0_n_0 ));
  LUT3 #(
    .INIT(8'h57)) 
    \tx_data[3]_i_2__0 
       (.I0(rd_ctrl_cnt[2]),
        .I1(rd_ctrl_cnt[1]),
        .I2(rd_ctrl_cnt[0]),
        .O(tx_data));
  (* SOFT_HLUTNM = "soft_lutpair73" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \tx_data[3]_i_3__0 
       (.I0(rd_last[7]),
        .I1(rd_ctrl_cnt[2]),
        .I2(\tx_data[3]_i_4__0_n_0 ),
        .O(\tx_data[3]_i_3__0_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \tx_data[3]_i_4__0 
       (.I0(rd_curr[5]),
        .I1(rd_curr[1]),
        .I2(rd_ctrl_cnt[1]),
        .I3(rd_curr[7]),
        .I4(rd_ctrl_cnt[0]),
        .I5(rd_curr[3]),
        .O(\tx_data[3]_i_4__0_n_0 ));
  FDRE \tx_data_reg[0] 
       (.C(pixel_clk_2_5x),
        .CE(tx_data),
        .D(\tx_data[0]_i_1__0_n_0 ),
        .Q(\tx_data_reg_n_0_[0] ),
        .R(SR));
  FDRE \tx_data_reg[1] 
       (.C(pixel_clk_2_5x),
        .CE(tx_data),
        .D(\tx_data[1]_i_1__0_n_0 ),
        .Q(\tx_data_reg_n_0_[1] ),
        .R(SR));
  FDRE \tx_data_reg[2] 
       (.C(pixel_clk_2_5x),
        .CE(tx_data),
        .D(\tx_data[2]_i_1__0_n_0 ),
        .Q(\tx_data_reg_n_0_[2] ),
        .R(SR));
  FDRE \tx_data_reg[3] 
       (.C(pixel_clk_2_5x),
        .CE(tx_data),
        .D(\tx_data[3]_i_3__0_n_0 ),
        .Q(\tx_data_reg_n_0_[3] ),
        .R(SR));
endmodule

(* ORIG_REF_NAME = "serializer_10_to_1" *) 
module system_DVI_Transmitter_Safe_0_0_serializer_10_to_1_4
   (tmds_data_serial_2,
    prime_done_reg_0,
    pclk,
    Q,
    WE0,
    \rd_last_reg[9]_0 ,
    pixel_clk_5x,
    pixel_clk_2_5x,
    reset,
    SR);
  output tmds_data_serial_2;
  output prime_done_reg_0;
  input pclk;
  input [9:0]Q;
  input WE0;
  input [3:0]\rd_last_reg[9]_0 ;
  input pixel_clk_5x;
  input pixel_clk_2_5x;
  input reset;
  input [0:0]SR;

  wire \FSM_sequential_rd_ctrl_cnt[1]_i_1__1_n_0 ;
  wire [9:0]Q;
  wire [0:0]SR;
  wire WE0;
  wire [3:1]p_0_in__2;
  wire pclk;
  wire pixel_clk_2_5x;
  wire pixel_clk_5x;
  wire \prime_count[0]_i_1__0_n_0 ;
  wire \prime_count[3]_i_1__1_n_0 ;
  wire [3:0]prime_count_reg;
  wire prime_done_i_1__1_n_0;
  wire prime_done_reg_0;
  wire \rd_addr[0]_i_1__1_n_0 ;
  wire \rd_addr[1]_i_1__1_n_0 ;
  wire \rd_addr[2]_i_1__1_n_0 ;
  wire \rd_addr[3]_i_1__1_n_0 ;
  wire \rd_addr[3]_i_2__1_n_0 ;
  wire \rd_addr_reg_n_0_[0] ;
  wire \rd_addr_reg_n_0_[1] ;
  wire \rd_addr_reg_n_0_[2] ;
  wire \rd_addr_reg_n_0_[3] ;
  wire [2:0]rd_ctrl_cnt;
  wire [2:0]rd_ctrl_cnt__0;
  wire [9:0]rd_curr;
  wire [7:4]rd_last;
  wire [3:0]\rd_last_reg[9]_0 ;
  wire reset;
  wire tmds_data_serial_2;
  wire tx_data;
  wire \tx_data[0]_i_1__1_n_0 ;
  wire \tx_data[0]_i_2__1_n_0 ;
  wire \tx_data[1]_i_1__1_n_0 ;
  wire \tx_data[1]_i_2__1_n_0 ;
  wire \tx_data[2]_i_1__1_n_0 ;
  wire \tx_data[2]_i_2__1_n_0 ;
  wire \tx_data[3]_i_3__1_n_0 ;
  wire \tx_data[3]_i_4__1_n_0 ;
  wire \tx_data_reg_n_0_[0] ;
  wire \tx_data_reg_n_0_[1] ;
  wire \tx_data_reg_n_0_[2] ;
  wire \tx_data_reg_n_0_[3] ;
  wire NLW_OSERDESE3_inst_T_OUT_UNCONNECTED;
  wire \NLW_bit[0].mem_SPO_UNCONNECTED ;
  wire \NLW_bit[1].mem_SPO_UNCONNECTED ;
  wire \NLW_bit[2].mem_SPO_UNCONNECTED ;
  wire \NLW_bit[3].mem_SPO_UNCONNECTED ;
  wire \NLW_bit[4].mem_SPO_UNCONNECTED ;
  wire \NLW_bit[5].mem_SPO_UNCONNECTED ;
  wire \NLW_bit[6].mem_SPO_UNCONNECTED ;
  wire \NLW_bit[7].mem_SPO_UNCONNECTED ;
  wire \NLW_bit[8].mem_SPO_UNCONNECTED ;
  wire \NLW_bit[9].mem_SPO_UNCONNECTED ;

  LUT2 #(
    .INIT(4'h1)) 
    \FSM_sequential_rd_ctrl_cnt[0]_i_1__1 
       (.I0(rd_ctrl_cnt[0]),
        .I1(rd_ctrl_cnt[2]),
        .O(rd_ctrl_cnt__0[0]));
  (* SOFT_HLUTNM = "soft_lutpair78" *) 
  LUT3 #(
    .INIT(8'h06)) 
    \FSM_sequential_rd_ctrl_cnt[1]_i_1__1 
       (.I0(rd_ctrl_cnt[1]),
        .I1(rd_ctrl_cnt[0]),
        .I2(rd_ctrl_cnt[2]),
        .O(\FSM_sequential_rd_ctrl_cnt[1]_i_1__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair78" *) 
  LUT3 #(
    .INIT(8'h40)) 
    \FSM_sequential_rd_ctrl_cnt[2]_i_1__1 
       (.I0(rd_ctrl_cnt[2]),
        .I1(rd_ctrl_cnt[0]),
        .I2(rd_ctrl_cnt[1]),
        .O(rd_ctrl_cnt__0[2]));
  (* FSM_ENCODED_STATES = "iSTATE:000,iSTATE0:001,iSTATE1:010,iSTATE2:011,iSTATE3:100," *) 
  FDRE \FSM_sequential_rd_ctrl_cnt_reg[0] 
       (.C(pixel_clk_2_5x),
        .CE(prime_done_reg_0),
        .D(rd_ctrl_cnt__0[0]),
        .Q(rd_ctrl_cnt[0]),
        .R(reset));
  (* FSM_ENCODED_STATES = "iSTATE:000,iSTATE0:001,iSTATE1:010,iSTATE2:011,iSTATE3:100," *) 
  FDRE \FSM_sequential_rd_ctrl_cnt_reg[1] 
       (.C(pixel_clk_2_5x),
        .CE(prime_done_reg_0),
        .D(\FSM_sequential_rd_ctrl_cnt[1]_i_1__1_n_0 ),
        .Q(rd_ctrl_cnt[1]),
        .R(reset));
  (* FSM_ENCODED_STATES = "iSTATE:000,iSTATE0:001,iSTATE1:010,iSTATE2:011,iSTATE3:100," *) 
  FDRE \FSM_sequential_rd_ctrl_cnt_reg[2] 
       (.C(pixel_clk_2_5x),
        .CE(prime_done_reg_0),
        .D(rd_ctrl_cnt__0[2]),
        .Q(rd_ctrl_cnt[2]),
        .R(reset));
  (* BOX_TYPE = "PRIMITIVE" *) 
  OSERDESE3 #(
    .DATA_WIDTH(4),
    .INIT(1'b0),
    .IS_CLKDIV_INVERTED(1'b0),
    .IS_CLK_INVERTED(1'b0),
    .IS_RST_INVERTED(1'b0),
    .ODDR_MODE("FALSE"),
    .OSERDES_D_BYPASS("FALSE"),
    .OSERDES_T_BYPASS("FALSE"),
    .SIM_DEVICE("ULTRASCALE_PLUS"),
    .SIM_VERSION(2.000000)) 
    OSERDESE3_inst
       (.CLK(pixel_clk_5x),
        .CLKDIV(pixel_clk_2_5x),
        .D({1'b0,1'b0,1'b0,1'b0,\tx_data_reg_n_0_[3] ,\tx_data_reg_n_0_[2] ,\tx_data_reg_n_0_[1] ,\tx_data_reg_n_0_[0] }),
        .OQ(tmds_data_serial_2),
        .RST(reset),
        .T(1'b0),
        .T_OUT(NLW_OSERDESE3_inst_T_OUT_UNCONNECTED));
  (* BOX_TYPE = "PRIMITIVE" *) 
  RAM32X1D #(
    .INIT(32'h00000000),
    .IS_WCLK_INVERTED(1'b0)) 
    \bit[0].mem 
       (.A0(\rd_last_reg[9]_0 [0]),
        .A1(\rd_last_reg[9]_0 [1]),
        .A2(\rd_last_reg[9]_0 [2]),
        .A3(\rd_last_reg[9]_0 [3]),
        .A4(1'b0),
        .D(Q[0]),
        .DPO(rd_curr[0]),
        .DPRA0(\rd_addr_reg_n_0_[0] ),
        .DPRA1(\rd_addr_reg_n_0_[1] ),
        .DPRA2(\rd_addr_reg_n_0_[2] ),
        .DPRA3(\rd_addr_reg_n_0_[3] ),
        .DPRA4(1'b0),
        .SPO(\NLW_bit[0].mem_SPO_UNCONNECTED ),
        .WCLK(pclk),
        .WE(WE0));
  (* BOX_TYPE = "PRIMITIVE" *) 
  RAM32X1D #(
    .INIT(32'h00000000),
    .IS_WCLK_INVERTED(1'b0)) 
    \bit[1].mem 
       (.A0(\rd_last_reg[9]_0 [0]),
        .A1(\rd_last_reg[9]_0 [1]),
        .A2(\rd_last_reg[9]_0 [2]),
        .A3(\rd_last_reg[9]_0 [3]),
        .A4(1'b0),
        .D(Q[1]),
        .DPO(rd_curr[1]),
        .DPRA0(\rd_addr_reg_n_0_[0] ),
        .DPRA1(\rd_addr_reg_n_0_[1] ),
        .DPRA2(\rd_addr_reg_n_0_[2] ),
        .DPRA3(\rd_addr_reg_n_0_[3] ),
        .DPRA4(1'b0),
        .SPO(\NLW_bit[1].mem_SPO_UNCONNECTED ),
        .WCLK(pclk),
        .WE(WE0));
  (* BOX_TYPE = "PRIMITIVE" *) 
  RAM32X1D #(
    .INIT(32'h00000000),
    .IS_WCLK_INVERTED(1'b0)) 
    \bit[2].mem 
       (.A0(\rd_last_reg[9]_0 [0]),
        .A1(\rd_last_reg[9]_0 [1]),
        .A2(\rd_last_reg[9]_0 [2]),
        .A3(\rd_last_reg[9]_0 [3]),
        .A4(1'b0),
        .D(Q[2]),
        .DPO(rd_curr[2]),
        .DPRA0(\rd_addr_reg_n_0_[0] ),
        .DPRA1(\rd_addr_reg_n_0_[1] ),
        .DPRA2(\rd_addr_reg_n_0_[2] ),
        .DPRA3(\rd_addr_reg_n_0_[3] ),
        .DPRA4(1'b0),
        .SPO(\NLW_bit[2].mem_SPO_UNCONNECTED ),
        .WCLK(pclk),
        .WE(WE0));
  (* BOX_TYPE = "PRIMITIVE" *) 
  RAM32X1D #(
    .INIT(32'h00000000),
    .IS_WCLK_INVERTED(1'b0)) 
    \bit[3].mem 
       (.A0(\rd_last_reg[9]_0 [0]),
        .A1(\rd_last_reg[9]_0 [1]),
        .A2(\rd_last_reg[9]_0 [2]),
        .A3(\rd_last_reg[9]_0 [3]),
        .A4(1'b0),
        .D(Q[3]),
        .DPO(rd_curr[3]),
        .DPRA0(\rd_addr_reg_n_0_[0] ),
        .DPRA1(\rd_addr_reg_n_0_[1] ),
        .DPRA2(\rd_addr_reg_n_0_[2] ),
        .DPRA3(\rd_addr_reg_n_0_[3] ),
        .DPRA4(1'b0),
        .SPO(\NLW_bit[3].mem_SPO_UNCONNECTED ),
        .WCLK(pclk),
        .WE(WE0));
  (* BOX_TYPE = "PRIMITIVE" *) 
  RAM32X1D #(
    .INIT(32'h00000000),
    .IS_WCLK_INVERTED(1'b0)) 
    \bit[4].mem 
       (.A0(\rd_last_reg[9]_0 [0]),
        .A1(\rd_last_reg[9]_0 [1]),
        .A2(\rd_last_reg[9]_0 [2]),
        .A3(\rd_last_reg[9]_0 [3]),
        .A4(1'b0),
        .D(Q[4]),
        .DPO(rd_curr[4]),
        .DPRA0(\rd_addr_reg_n_0_[0] ),
        .DPRA1(\rd_addr_reg_n_0_[1] ),
        .DPRA2(\rd_addr_reg_n_0_[2] ),
        .DPRA3(\rd_addr_reg_n_0_[3] ),
        .DPRA4(1'b0),
        .SPO(\NLW_bit[4].mem_SPO_UNCONNECTED ),
        .WCLK(pclk),
        .WE(WE0));
  (* BOX_TYPE = "PRIMITIVE" *) 
  RAM32X1D #(
    .INIT(32'h00000000),
    .IS_WCLK_INVERTED(1'b0)) 
    \bit[5].mem 
       (.A0(\rd_last_reg[9]_0 [0]),
        .A1(\rd_last_reg[9]_0 [1]),
        .A2(\rd_last_reg[9]_0 [2]),
        .A3(\rd_last_reg[9]_0 [3]),
        .A4(1'b0),
        .D(Q[5]),
        .DPO(rd_curr[5]),
        .DPRA0(\rd_addr_reg_n_0_[0] ),
        .DPRA1(\rd_addr_reg_n_0_[1] ),
        .DPRA2(\rd_addr_reg_n_0_[2] ),
        .DPRA3(\rd_addr_reg_n_0_[3] ),
        .DPRA4(1'b0),
        .SPO(\NLW_bit[5].mem_SPO_UNCONNECTED ),
        .WCLK(pclk),
        .WE(WE0));
  (* BOX_TYPE = "PRIMITIVE" *) 
  RAM32X1D #(
    .INIT(32'h00000000),
    .IS_WCLK_INVERTED(1'b0)) 
    \bit[6].mem 
       (.A0(\rd_last_reg[9]_0 [0]),
        .A1(\rd_last_reg[9]_0 [1]),
        .A2(\rd_last_reg[9]_0 [2]),
        .A3(\rd_last_reg[9]_0 [3]),
        .A4(1'b0),
        .D(Q[6]),
        .DPO(rd_curr[6]),
        .DPRA0(\rd_addr_reg_n_0_[0] ),
        .DPRA1(\rd_addr_reg_n_0_[1] ),
        .DPRA2(\rd_addr_reg_n_0_[2] ),
        .DPRA3(\rd_addr_reg_n_0_[3] ),
        .DPRA4(1'b0),
        .SPO(\NLW_bit[6].mem_SPO_UNCONNECTED ),
        .WCLK(pclk),
        .WE(WE0));
  (* BOX_TYPE = "PRIMITIVE" *) 
  RAM32X1D #(
    .INIT(32'h00000000),
    .IS_WCLK_INVERTED(1'b0)) 
    \bit[7].mem 
       (.A0(\rd_last_reg[9]_0 [0]),
        .A1(\rd_last_reg[9]_0 [1]),
        .A2(\rd_last_reg[9]_0 [2]),
        .A3(\rd_last_reg[9]_0 [3]),
        .A4(1'b0),
        .D(Q[7]),
        .DPO(rd_curr[7]),
        .DPRA0(\rd_addr_reg_n_0_[0] ),
        .DPRA1(\rd_addr_reg_n_0_[1] ),
        .DPRA2(\rd_addr_reg_n_0_[2] ),
        .DPRA3(\rd_addr_reg_n_0_[3] ),
        .DPRA4(1'b0),
        .SPO(\NLW_bit[7].mem_SPO_UNCONNECTED ),
        .WCLK(pclk),
        .WE(WE0));
  (* BOX_TYPE = "PRIMITIVE" *) 
  RAM32X1D #(
    .INIT(32'h00000000),
    .IS_WCLK_INVERTED(1'b0)) 
    \bit[8].mem 
       (.A0(\rd_last_reg[9]_0 [0]),
        .A1(\rd_last_reg[9]_0 [1]),
        .A2(\rd_last_reg[9]_0 [2]),
        .A3(\rd_last_reg[9]_0 [3]),
        .A4(1'b0),
        .D(Q[8]),
        .DPO(rd_curr[8]),
        .DPRA0(\rd_addr_reg_n_0_[0] ),
        .DPRA1(\rd_addr_reg_n_0_[1] ),
        .DPRA2(\rd_addr_reg_n_0_[2] ),
        .DPRA3(\rd_addr_reg_n_0_[3] ),
        .DPRA4(1'b0),
        .SPO(\NLW_bit[8].mem_SPO_UNCONNECTED ),
        .WCLK(pclk),
        .WE(WE0));
  (* BOX_TYPE = "PRIMITIVE" *) 
  RAM32X1D #(
    .INIT(32'h00000000),
    .IS_WCLK_INVERTED(1'b0)) 
    \bit[9].mem 
       (.A0(\rd_last_reg[9]_0 [0]),
        .A1(\rd_last_reg[9]_0 [1]),
        .A2(\rd_last_reg[9]_0 [2]),
        .A3(\rd_last_reg[9]_0 [3]),
        .A4(1'b0),
        .D(Q[9]),
        .DPO(rd_curr[9]),
        .DPRA0(\rd_addr_reg_n_0_[0] ),
        .DPRA1(\rd_addr_reg_n_0_[1] ),
        .DPRA2(\rd_addr_reg_n_0_[2] ),
        .DPRA3(\rd_addr_reg_n_0_[3] ),
        .DPRA4(1'b0),
        .SPO(\NLW_bit[9].mem_SPO_UNCONNECTED ),
        .WCLK(pclk),
        .WE(WE0));
  (* SOFT_HLUTNM = "soft_lutpair82" *) 
  LUT1 #(
    .INIT(2'h1)) 
    \prime_count[0]_i_1__0 
       (.I0(prime_count_reg[0]),
        .O(\prime_count[0]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair82" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \prime_count[1]_i_1__1 
       (.I0(prime_count_reg[0]),
        .I1(prime_count_reg[1]),
        .O(p_0_in__2[1]));
  (* SOFT_HLUTNM = "soft_lutpair77" *) 
  LUT3 #(
    .INIT(8'h78)) 
    \prime_count[2]_i_1__1 
       (.I0(prime_count_reg[0]),
        .I1(prime_count_reg[1]),
        .I2(prime_count_reg[2]),
        .O(p_0_in__2[2]));
  LUT5 #(
    .INIT(32'h0000EFFF)) 
    \prime_count[3]_i_1__1 
       (.I0(prime_count_reg[2]),
        .I1(prime_count_reg[1]),
        .I2(prime_count_reg[0]),
        .I3(prime_count_reg[3]),
        .I4(prime_done_reg_0),
        .O(\prime_count[3]_i_1__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair77" *) 
  LUT4 #(
    .INIT(16'h7F80)) 
    \prime_count[3]_i_2__1 
       (.I0(prime_count_reg[1]),
        .I1(prime_count_reg[0]),
        .I2(prime_count_reg[2]),
        .I3(prime_count_reg[3]),
        .O(p_0_in__2[3]));
  FDRE \prime_count_reg[0] 
       (.C(pixel_clk_2_5x),
        .CE(\prime_count[3]_i_1__1_n_0 ),
        .D(\prime_count[0]_i_1__0_n_0 ),
        .Q(prime_count_reg[0]),
        .R(reset));
  FDRE \prime_count_reg[1] 
       (.C(pixel_clk_2_5x),
        .CE(\prime_count[3]_i_1__1_n_0 ),
        .D(p_0_in__2[1]),
        .Q(prime_count_reg[1]),
        .R(reset));
  FDRE \prime_count_reg[2] 
       (.C(pixel_clk_2_5x),
        .CE(\prime_count[3]_i_1__1_n_0 ),
        .D(p_0_in__2[2]),
        .Q(prime_count_reg[2]),
        .R(reset));
  FDRE \prime_count_reg[3] 
       (.C(pixel_clk_2_5x),
        .CE(\prime_count[3]_i_1__1_n_0 ),
        .D(p_0_in__2[3]),
        .Q(prime_count_reg[3]),
        .R(reset));
  LUT5 #(
    .INIT(32'hFFFF1000)) 
    prime_done_i_1__1
       (.I0(prime_count_reg[1]),
        .I1(prime_count_reg[2]),
        .I2(prime_count_reg[0]),
        .I3(prime_count_reg[3]),
        .I4(prime_done_reg_0),
        .O(prime_done_i_1__1_n_0));
  FDRE prime_done_reg
       (.C(pixel_clk_2_5x),
        .CE(1'b1),
        .D(prime_done_i_1__1_n_0),
        .Q(prime_done_reg_0),
        .R(reset));
  (* SOFT_HLUTNM = "soft_lutpair81" *) 
  LUT1 #(
    .INIT(2'h1)) 
    \rd_addr[0]_i_1__1 
       (.I0(\rd_addr_reg_n_0_[0] ),
        .O(\rd_addr[0]_i_1__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair81" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \rd_addr[1]_i_1__1 
       (.I0(\rd_addr_reg_n_0_[1] ),
        .I1(\rd_addr_reg_n_0_[0] ),
        .O(\rd_addr[1]_i_1__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair76" *) 
  LUT3 #(
    .INIT(8'h6A)) 
    \rd_addr[2]_i_1__1 
       (.I0(\rd_addr_reg_n_0_[2] ),
        .I1(\rd_addr_reg_n_0_[1] ),
        .I2(\rd_addr_reg_n_0_[0] ),
        .O(\rd_addr[2]_i_1__1_n_0 ));
  LUT3 #(
    .INIT(8'h20)) 
    \rd_addr[3]_i_1__1 
       (.I0(prime_done_reg_0),
        .I1(rd_ctrl_cnt[2]),
        .I2(rd_ctrl_cnt[0]),
        .O(\rd_addr[3]_i_1__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair76" *) 
  LUT4 #(
    .INIT(16'h6AAA)) 
    \rd_addr[3]_i_2__1 
       (.I0(\rd_addr_reg_n_0_[3] ),
        .I1(\rd_addr_reg_n_0_[2] ),
        .I2(\rd_addr_reg_n_0_[0] ),
        .I3(\rd_addr_reg_n_0_[1] ),
        .O(\rd_addr[3]_i_2__1_n_0 ));
  FDRE \rd_addr_reg[0] 
       (.C(pixel_clk_2_5x),
        .CE(\rd_addr[3]_i_1__1_n_0 ),
        .D(\rd_addr[0]_i_1__1_n_0 ),
        .Q(\rd_addr_reg_n_0_[0] ),
        .R(reset));
  FDRE \rd_addr_reg[1] 
       (.C(pixel_clk_2_5x),
        .CE(\rd_addr[3]_i_1__1_n_0 ),
        .D(\rd_addr[1]_i_1__1_n_0 ),
        .Q(\rd_addr_reg_n_0_[1] ),
        .R(reset));
  FDRE \rd_addr_reg[2] 
       (.C(pixel_clk_2_5x),
        .CE(\rd_addr[3]_i_1__1_n_0 ),
        .D(\rd_addr[2]_i_1__1_n_0 ),
        .Q(\rd_addr_reg_n_0_[2] ),
        .R(reset));
  FDRE \rd_addr_reg[3] 
       (.C(pixel_clk_2_5x),
        .CE(\rd_addr[3]_i_1__1_n_0 ),
        .D(\rd_addr[3]_i_2__1_n_0 ),
        .Q(\rd_addr_reg_n_0_[3] ),
        .R(reset));
  FDRE \rd_last_reg[6] 
       (.C(pixel_clk_2_5x),
        .CE(1'b1),
        .D(rd_curr[6]),
        .Q(rd_last[4]),
        .R(1'b0));
  FDRE \rd_last_reg[7] 
       (.C(pixel_clk_2_5x),
        .CE(1'b1),
        .D(rd_curr[7]),
        .Q(rd_last[5]),
        .R(1'b0));
  FDRE \rd_last_reg[8] 
       (.C(pixel_clk_2_5x),
        .CE(1'b1),
        .D(rd_curr[8]),
        .Q(rd_last[6]),
        .R(1'b0));
  FDRE \rd_last_reg[9] 
       (.C(pixel_clk_2_5x),
        .CE(1'b1),
        .D(rd_curr[9]),
        .Q(rd_last[7]),
        .R(1'b0));
  (* SOFT_HLUTNM = "soft_lutpair79" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \tx_data[0]_i_1__1 
       (.I0(rd_last[4]),
        .I1(rd_ctrl_cnt[2]),
        .I2(\tx_data[0]_i_2__1_n_0 ),
        .O(\tx_data[0]_i_1__1_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \tx_data[0]_i_2__1 
       (.I0(rd_curr[2]),
        .I1(rd_last[6]),
        .I2(rd_ctrl_cnt[1]),
        .I3(rd_curr[4]),
        .I4(rd_ctrl_cnt[0]),
        .I5(rd_curr[0]),
        .O(\tx_data[0]_i_2__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair79" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \tx_data[1]_i_1__1 
       (.I0(rd_last[5]),
        .I1(rd_ctrl_cnt[2]),
        .I2(\tx_data[1]_i_2__1_n_0 ),
        .O(\tx_data[1]_i_1__1_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \tx_data[1]_i_2__1 
       (.I0(rd_curr[3]),
        .I1(rd_last[7]),
        .I2(rd_ctrl_cnt[1]),
        .I3(rd_curr[5]),
        .I4(rd_ctrl_cnt[0]),
        .I5(rd_curr[1]),
        .O(\tx_data[1]_i_2__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair80" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \tx_data[2]_i_1__1 
       (.I0(rd_last[6]),
        .I1(rd_ctrl_cnt[2]),
        .I2(\tx_data[2]_i_2__1_n_0 ),
        .O(\tx_data[2]_i_1__1_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \tx_data[2]_i_2__1 
       (.I0(rd_curr[4]),
        .I1(rd_curr[0]),
        .I2(rd_ctrl_cnt[1]),
        .I3(rd_curr[6]),
        .I4(rd_ctrl_cnt[0]),
        .I5(rd_curr[2]),
        .O(\tx_data[2]_i_2__1_n_0 ));
  LUT3 #(
    .INIT(8'h57)) 
    \tx_data[3]_i_2__1 
       (.I0(rd_ctrl_cnt[2]),
        .I1(rd_ctrl_cnt[1]),
        .I2(rd_ctrl_cnt[0]),
        .O(tx_data));
  (* SOFT_HLUTNM = "soft_lutpair80" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \tx_data[3]_i_3__1 
       (.I0(rd_last[7]),
        .I1(rd_ctrl_cnt[2]),
        .I2(\tx_data[3]_i_4__1_n_0 ),
        .O(\tx_data[3]_i_3__1_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \tx_data[3]_i_4__1 
       (.I0(rd_curr[5]),
        .I1(rd_curr[1]),
        .I2(rd_ctrl_cnt[1]),
        .I3(rd_curr[7]),
        .I4(rd_ctrl_cnt[0]),
        .I5(rd_curr[3]),
        .O(\tx_data[3]_i_4__1_n_0 ));
  FDRE \tx_data_reg[0] 
       (.C(pixel_clk_2_5x),
        .CE(tx_data),
        .D(\tx_data[0]_i_1__1_n_0 ),
        .Q(\tx_data_reg_n_0_[0] ),
        .R(SR));
  FDRE \tx_data_reg[1] 
       (.C(pixel_clk_2_5x),
        .CE(tx_data),
        .D(\tx_data[1]_i_1__1_n_0 ),
        .Q(\tx_data_reg_n_0_[1] ),
        .R(SR));
  FDRE \tx_data_reg[2] 
       (.C(pixel_clk_2_5x),
        .CE(tx_data),
        .D(\tx_data[2]_i_1__1_n_0 ),
        .Q(\tx_data_reg_n_0_[2] ),
        .R(SR));
  FDRE \tx_data_reg[3] 
       (.C(pixel_clk_2_5x),
        .CE(tx_data),
        .D(\tx_data[3]_i_3__1_n_0 ),
        .Q(\tx_data_reg_n_0_[3] ),
        .R(SR));
endmodule
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;
    parameter GRES_WIDTH = 10000;
    parameter GRES_START = 10000;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    wire GRESTORE;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;
    reg GRESTORE_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;
    assign (strong1, weak0) GRESTORE = GRESTORE_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

    initial begin 
	GRESTORE_int = 1'b0;
	#(GRES_START);
	GRESTORE_int = 1'b1;
	#(GRES_WIDTH);
	GRESTORE_int = 1'b0;
    end

endmodule
`endif
