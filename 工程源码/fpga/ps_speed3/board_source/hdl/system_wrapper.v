//Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2020.2 (win64) Build 3064766 Wed Nov 18 09:12:45 MST 2020
//Date        : Sun Nov  1 02:17:27 2026
//Host        : mayifei running 64-bit major release  (build 9200)
//Command     : generate_target system_wrapper.bd
//Design      : system_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module system_wrapper
   (C0_SYS_CLK_clk_n,
    C0_SYS_CLK_clk_p,
    GPIO_tri_io,
    MDIO_mdc,
    MDIO_mdio_io,
    RGMII_rd,
    RGMII_rx_ctl,
    RGMII_rxc,
    RGMII_td,
    RGMII_tx_ctl,
    RGMII_txc,
    TMDS_tmds_clk_n,
    TMDS_tmds_clk_p,
    TMDS_tmds_data_n,
    TMDS_tmds_data_p,
    UART_rxd,
    UART_txd,
    cam_clk,
    ddr4_act_n,
    ddr4_adr,
    ddr4_ba,
    ddr4_bg,
    ddr4_ck_c,
    ddr4_ck_t,
    ddr4_cke,
    ddr4_cs_n,
    ddr4_dm_n,
    ddr4_dq,
    ddr4_dqs_c,
    ddr4_dqs_t,
    ddr4_odt,
    ddr4_reset_n,
    lcd_bl,
    lcd_clk,
    lcd_de,
    lcd_hs,
    lcd_rgb_tri_io,
    lcd_rst,
    lcd_touch_e2p_scl_io,
    lcd_touch_e2p_sda_io,
    lcd_vs,
    led_tri_o,
    mipi_hdmi_scl_io,
    mipi_hdmi_sda_io,
    mipi_phy_if_0_clk_n,
    mipi_phy_if_0_clk_p,
    mipi_phy_if_0_data_n,
    mipi_phy_if_0_data_p);
  input C0_SYS_CLK_clk_n;
  input C0_SYS_CLK_clk_p;
  inout [48:0]GPIO_tri_io;
  output MDIO_mdc;
  inout MDIO_mdio_io;
  input [3:0]RGMII_rd;
  input RGMII_rx_ctl;
  input RGMII_rxc;
  output [3:0]RGMII_td;
  output RGMII_tx_ctl;
  output RGMII_txc;
  output TMDS_tmds_clk_n;
  output TMDS_tmds_clk_p;
  output [2:0]TMDS_tmds_data_n;
  output [2:0]TMDS_tmds_data_p;
  input UART_rxd;
  output UART_txd;
  output cam_clk;
  output ddr4_act_n;
  output [16:0]ddr4_adr;
  output [1:0]ddr4_ba;
  output [0:0]ddr4_bg;
  output [0:0]ddr4_ck_c;
  output [0:0]ddr4_ck_t;
  output [0:0]ddr4_cke;
  output [0:0]ddr4_cs_n;
  inout [1:0]ddr4_dm_n;
  inout [15:0]ddr4_dq;
  inout [1:0]ddr4_dqs_c;
  inout [1:0]ddr4_dqs_t;
  output [0:0]ddr4_odt;
  output ddr4_reset_n;
  output [0:0]lcd_bl;
  output lcd_clk;
  output lcd_de;
  output lcd_hs;
  inout [23:0]lcd_rgb_tri_io;
  output lcd_rst;
  inout lcd_touch_e2p_scl_io;
  inout lcd_touch_e2p_sda_io;
  output lcd_vs;
  output [1:0]led_tri_o;
  inout mipi_hdmi_scl_io;
  inout mipi_hdmi_sda_io;
  input mipi_phy_if_0_clk_n;
  input mipi_phy_if_0_clk_p;
  input [1:0]mipi_phy_if_0_data_n;
  input [1:0]mipi_phy_if_0_data_p;

  wire C0_SYS_CLK_clk_n;
  wire C0_SYS_CLK_clk_p;
  wire [0:0]GPIO_tri_i_0;
  wire [1:1]GPIO_tri_i_1;
  wire [10:10]GPIO_tri_i_10;
  wire [11:11]GPIO_tri_i_11;
  wire [12:12]GPIO_tri_i_12;
  wire [13:13]GPIO_tri_i_13;
  wire [14:14]GPIO_tri_i_14;
  wire [15:15]GPIO_tri_i_15;
  wire [16:16]GPIO_tri_i_16;
  wire [17:17]GPIO_tri_i_17;
  wire [18:18]GPIO_tri_i_18;
  wire [19:19]GPIO_tri_i_19;
  wire [2:2]GPIO_tri_i_2;
  wire [20:20]GPIO_tri_i_20;
  wire [21:21]GPIO_tri_i_21;
  wire [22:22]GPIO_tri_i_22;
  wire [23:23]GPIO_tri_i_23;
  wire [24:24]GPIO_tri_i_24;
  wire [25:25]GPIO_tri_i_25;
  wire [26:26]GPIO_tri_i_26;
  wire [27:27]GPIO_tri_i_27;
  wire [28:28]GPIO_tri_i_28;
  wire [29:29]GPIO_tri_i_29;
  wire [3:3]GPIO_tri_i_3;
  wire [30:30]GPIO_tri_i_30;
  wire [31:31]GPIO_tri_i_31;
  wire [32:32]GPIO_tri_i_32;
  wire [33:33]GPIO_tri_i_33;
  wire [34:34]GPIO_tri_i_34;
  wire [35:35]GPIO_tri_i_35;
  wire [36:36]GPIO_tri_i_36;
  wire [37:37]GPIO_tri_i_37;
  wire [38:38]GPIO_tri_i_38;
  wire [39:39]GPIO_tri_i_39;
  wire [4:4]GPIO_tri_i_4;
  wire [40:40]GPIO_tri_i_40;
  wire [41:41]GPIO_tri_i_41;
  wire [42:42]GPIO_tri_i_42;
  wire [43:43]GPIO_tri_i_43;
  wire [44:44]GPIO_tri_i_44;
  wire [45:45]GPIO_tri_i_45;
  wire [46:46]GPIO_tri_i_46;
  wire [47:47]GPIO_tri_i_47;
  wire [48:48]GPIO_tri_i_48;
  wire [5:5]GPIO_tri_i_5;
  wire [6:6]GPIO_tri_i_6;
  wire [7:7]GPIO_tri_i_7;
  wire [8:8]GPIO_tri_i_8;
  wire [9:9]GPIO_tri_i_9;
  wire [0:0]GPIO_tri_io_0;
  wire [1:1]GPIO_tri_io_1;
  wire [10:10]GPIO_tri_io_10;
  wire [11:11]GPIO_tri_io_11;
  wire [12:12]GPIO_tri_io_12;
  wire [13:13]GPIO_tri_io_13;
  wire [14:14]GPIO_tri_io_14;
  wire [15:15]GPIO_tri_io_15;
  wire [16:16]GPIO_tri_io_16;
  wire [17:17]GPIO_tri_io_17;
  wire [18:18]GPIO_tri_io_18;
  wire [19:19]GPIO_tri_io_19;
  wire [2:2]GPIO_tri_io_2;
  wire [20:20]GPIO_tri_io_20;
  wire [21:21]GPIO_tri_io_21;
  wire [22:22]GPIO_tri_io_22;
  wire [23:23]GPIO_tri_io_23;
  wire [24:24]GPIO_tri_io_24;
  wire [25:25]GPIO_tri_io_25;
  wire [26:26]GPIO_tri_io_26;
  wire [27:27]GPIO_tri_io_27;
  wire [28:28]GPIO_tri_io_28;
  wire [29:29]GPIO_tri_io_29;
  wire [3:3]GPIO_tri_io_3;
  wire [30:30]GPIO_tri_io_30;
  wire [31:31]GPIO_tri_io_31;
  wire [32:32]GPIO_tri_io_32;
  wire [33:33]GPIO_tri_io_33;
  wire [34:34]GPIO_tri_io_34;
  wire [35:35]GPIO_tri_io_35;
  wire [36:36]GPIO_tri_io_36;
  wire [37:37]GPIO_tri_io_37;
  wire [38:38]GPIO_tri_io_38;
  wire [39:39]GPIO_tri_io_39;
  wire [4:4]GPIO_tri_io_4;
  wire [40:40]GPIO_tri_io_40;
  wire [41:41]GPIO_tri_io_41;
  wire [42:42]GPIO_tri_io_42;
  wire [43:43]GPIO_tri_io_43;
  wire [44:44]GPIO_tri_io_44;
  wire [45:45]GPIO_tri_io_45;
  wire [46:46]GPIO_tri_io_46;
  wire [47:47]GPIO_tri_io_47;
  wire [48:48]GPIO_tri_io_48;
  wire [5:5]GPIO_tri_io_5;
  wire [6:6]GPIO_tri_io_6;
  wire [7:7]GPIO_tri_io_7;
  wire [8:8]GPIO_tri_io_8;
  wire [9:9]GPIO_tri_io_9;
  wire [0:0]GPIO_tri_o_0;
  wire [1:1]GPIO_tri_o_1;
  wire [10:10]GPIO_tri_o_10;
  wire [11:11]GPIO_tri_o_11;
  wire [12:12]GPIO_tri_o_12;
  wire [13:13]GPIO_tri_o_13;
  wire [14:14]GPIO_tri_o_14;
  wire [15:15]GPIO_tri_o_15;
  wire [16:16]GPIO_tri_o_16;
  wire [17:17]GPIO_tri_o_17;
  wire [18:18]GPIO_tri_o_18;
  wire [19:19]GPIO_tri_o_19;
  wire [2:2]GPIO_tri_o_2;
  wire [20:20]GPIO_tri_o_20;
  wire [21:21]GPIO_tri_o_21;
  wire [22:22]GPIO_tri_o_22;
  wire [23:23]GPIO_tri_o_23;
  wire [24:24]GPIO_tri_o_24;
  wire [25:25]GPIO_tri_o_25;
  wire [26:26]GPIO_tri_o_26;
  wire [27:27]GPIO_tri_o_27;
  wire [28:28]GPIO_tri_o_28;
  wire [29:29]GPIO_tri_o_29;
  wire [3:3]GPIO_tri_o_3;
  wire [30:30]GPIO_tri_o_30;
  wire [31:31]GPIO_tri_o_31;
  wire [32:32]GPIO_tri_o_32;
  wire [33:33]GPIO_tri_o_33;
  wire [34:34]GPIO_tri_o_34;
  wire [35:35]GPIO_tri_o_35;
  wire [36:36]GPIO_tri_o_36;
  wire [37:37]GPIO_tri_o_37;
  wire [38:38]GPIO_tri_o_38;
  wire [39:39]GPIO_tri_o_39;
  wire [4:4]GPIO_tri_o_4;
  wire [40:40]GPIO_tri_o_40;
  wire [41:41]GPIO_tri_o_41;
  wire [42:42]GPIO_tri_o_42;
  wire [43:43]GPIO_tri_o_43;
  wire [44:44]GPIO_tri_o_44;
  wire [45:45]GPIO_tri_o_45;
  wire [46:46]GPIO_tri_o_46;
  wire [47:47]GPIO_tri_o_47;
  wire [48:48]GPIO_tri_o_48;
  wire [5:5]GPIO_tri_o_5;
  wire [6:6]GPIO_tri_o_6;
  wire [7:7]GPIO_tri_o_7;
  wire [8:8]GPIO_tri_o_8;
  wire [9:9]GPIO_tri_o_9;
  wire [0:0]GPIO_tri_t_0;
  wire [1:1]GPIO_tri_t_1;
  wire [10:10]GPIO_tri_t_10;
  wire [11:11]GPIO_tri_t_11;
  wire [12:12]GPIO_tri_t_12;
  wire [13:13]GPIO_tri_t_13;
  wire [14:14]GPIO_tri_t_14;
  wire [15:15]GPIO_tri_t_15;
  wire [16:16]GPIO_tri_t_16;
  wire [17:17]GPIO_tri_t_17;
  wire [18:18]GPIO_tri_t_18;
  wire [19:19]GPIO_tri_t_19;
  wire [2:2]GPIO_tri_t_2;
  wire [20:20]GPIO_tri_t_20;
  wire [21:21]GPIO_tri_t_21;
  wire [22:22]GPIO_tri_t_22;
  wire [23:23]GPIO_tri_t_23;
  wire [24:24]GPIO_tri_t_24;
  wire [25:25]GPIO_tri_t_25;
  wire [26:26]GPIO_tri_t_26;
  wire [27:27]GPIO_tri_t_27;
  wire [28:28]GPIO_tri_t_28;
  wire [29:29]GPIO_tri_t_29;
  wire [3:3]GPIO_tri_t_3;
  wire [30:30]GPIO_tri_t_30;
  wire [31:31]GPIO_tri_t_31;
  wire [32:32]GPIO_tri_t_32;
  wire [33:33]GPIO_tri_t_33;
  wire [34:34]GPIO_tri_t_34;
  wire [35:35]GPIO_tri_t_35;
  wire [36:36]GPIO_tri_t_36;
  wire [37:37]GPIO_tri_t_37;
  wire [38:38]GPIO_tri_t_38;
  wire [39:39]GPIO_tri_t_39;
  wire [4:4]GPIO_tri_t_4;
  wire [40:40]GPIO_tri_t_40;
  wire [41:41]GPIO_tri_t_41;
  wire [42:42]GPIO_tri_t_42;
  wire [43:43]GPIO_tri_t_43;
  wire [44:44]GPIO_tri_t_44;
  wire [45:45]GPIO_tri_t_45;
  wire [46:46]GPIO_tri_t_46;
  wire [47:47]GPIO_tri_t_47;
  wire [48:48]GPIO_tri_t_48;
  wire [5:5]GPIO_tri_t_5;
  wire [6:6]GPIO_tri_t_6;
  wire [7:7]GPIO_tri_t_7;
  wire [8:8]GPIO_tri_t_8;
  wire [9:9]GPIO_tri_t_9;
  wire MDIO_mdc;
  wire MDIO_mdio_i;
  wire MDIO_mdio_io;
  wire MDIO_mdio_o;
  wire MDIO_mdio_t;
  wire [3:0]RGMII_rd;
  wire RGMII_rx_ctl;
  wire RGMII_rxc;
  wire [3:0]RGMII_td;
  wire RGMII_tx_ctl;
  wire RGMII_txc;
  wire TMDS_tmds_clk_n;
  wire TMDS_tmds_clk_p;
  wire [2:0]TMDS_tmds_data_n;
  wire [2:0]TMDS_tmds_data_p;
  wire UART_rxd;
  wire UART_txd;
  wire cam_clk;
  wire ddr4_act_n;
  wire [16:0]ddr4_adr;
  wire [1:0]ddr4_ba;
  wire [0:0]ddr4_bg;
  wire [0:0]ddr4_ck_c;
  wire [0:0]ddr4_ck_t;
  wire [0:0]ddr4_cke;
  wire [0:0]ddr4_cs_n;
  wire [1:0]ddr4_dm_n;
  wire [15:0]ddr4_dq;
  wire [1:0]ddr4_dqs_c;
  wire [1:0]ddr4_dqs_t;
  wire [0:0]ddr4_odt;
  wire ddr4_reset_n;
  wire [0:0]lcd_bl;
  wire lcd_clk;
  wire lcd_de;
  wire lcd_hs;
  wire [0:0]lcd_rgb_tri_i_0;
  wire [1:1]lcd_rgb_tri_i_1;
  wire [10:10]lcd_rgb_tri_i_10;
  wire [11:11]lcd_rgb_tri_i_11;
  wire [12:12]lcd_rgb_tri_i_12;
  wire [13:13]lcd_rgb_tri_i_13;
  wire [14:14]lcd_rgb_tri_i_14;
  wire [15:15]lcd_rgb_tri_i_15;
  wire [16:16]lcd_rgb_tri_i_16;
  wire [17:17]lcd_rgb_tri_i_17;
  wire [18:18]lcd_rgb_tri_i_18;
  wire [19:19]lcd_rgb_tri_i_19;
  wire [2:2]lcd_rgb_tri_i_2;
  wire [20:20]lcd_rgb_tri_i_20;
  wire [21:21]lcd_rgb_tri_i_21;
  wire [22:22]lcd_rgb_tri_i_22;
  wire [23:23]lcd_rgb_tri_i_23;
  wire [3:3]lcd_rgb_tri_i_3;
  wire [4:4]lcd_rgb_tri_i_4;
  wire [5:5]lcd_rgb_tri_i_5;
  wire [6:6]lcd_rgb_tri_i_6;
  wire [7:7]lcd_rgb_tri_i_7;
  wire [8:8]lcd_rgb_tri_i_8;
  wire [9:9]lcd_rgb_tri_i_9;
  wire [0:0]lcd_rgb_tri_io_0;
  wire [1:1]lcd_rgb_tri_io_1;
  wire [10:10]lcd_rgb_tri_io_10;
  wire [11:11]lcd_rgb_tri_io_11;
  wire [12:12]lcd_rgb_tri_io_12;
  wire [13:13]lcd_rgb_tri_io_13;
  wire [14:14]lcd_rgb_tri_io_14;
  wire [15:15]lcd_rgb_tri_io_15;
  wire [16:16]lcd_rgb_tri_io_16;
  wire [17:17]lcd_rgb_tri_io_17;
  wire [18:18]lcd_rgb_tri_io_18;
  wire [19:19]lcd_rgb_tri_io_19;
  wire [2:2]lcd_rgb_tri_io_2;
  wire [20:20]lcd_rgb_tri_io_20;
  wire [21:21]lcd_rgb_tri_io_21;
  wire [22:22]lcd_rgb_tri_io_22;
  wire [23:23]lcd_rgb_tri_io_23;
  wire [3:3]lcd_rgb_tri_io_3;
  wire [4:4]lcd_rgb_tri_io_4;
  wire [5:5]lcd_rgb_tri_io_5;
  wire [6:6]lcd_rgb_tri_io_6;
  wire [7:7]lcd_rgb_tri_io_7;
  wire [8:8]lcd_rgb_tri_io_8;
  wire [9:9]lcd_rgb_tri_io_9;
  wire [0:0]lcd_rgb_tri_o_0;
  wire [1:1]lcd_rgb_tri_o_1;
  wire [10:10]lcd_rgb_tri_o_10;
  wire [11:11]lcd_rgb_tri_o_11;
  wire [12:12]lcd_rgb_tri_o_12;
  wire [13:13]lcd_rgb_tri_o_13;
  wire [14:14]lcd_rgb_tri_o_14;
  wire [15:15]lcd_rgb_tri_o_15;
  wire [16:16]lcd_rgb_tri_o_16;
  wire [17:17]lcd_rgb_tri_o_17;
  wire [18:18]lcd_rgb_tri_o_18;
  wire [19:19]lcd_rgb_tri_o_19;
  wire [2:2]lcd_rgb_tri_o_2;
  wire [20:20]lcd_rgb_tri_o_20;
  wire [21:21]lcd_rgb_tri_o_21;
  wire [22:22]lcd_rgb_tri_o_22;
  wire [23:23]lcd_rgb_tri_o_23;
  wire [3:3]lcd_rgb_tri_o_3;
  wire [4:4]lcd_rgb_tri_o_4;
  wire [5:5]lcd_rgb_tri_o_5;
  wire [6:6]lcd_rgb_tri_o_6;
  wire [7:7]lcd_rgb_tri_o_7;
  wire [8:8]lcd_rgb_tri_o_8;
  wire [9:9]lcd_rgb_tri_o_9;
  wire [0:0]lcd_rgb_tri_t_0;
  wire [1:1]lcd_rgb_tri_t_1;
  wire [10:10]lcd_rgb_tri_t_10;
  wire [11:11]lcd_rgb_tri_t_11;
  wire [12:12]lcd_rgb_tri_t_12;
  wire [13:13]lcd_rgb_tri_t_13;
  wire [14:14]lcd_rgb_tri_t_14;
  wire [15:15]lcd_rgb_tri_t_15;
  wire [16:16]lcd_rgb_tri_t_16;
  wire [17:17]lcd_rgb_tri_t_17;
  wire [18:18]lcd_rgb_tri_t_18;
  wire [19:19]lcd_rgb_tri_t_19;
  wire [2:2]lcd_rgb_tri_t_2;
  wire [20:20]lcd_rgb_tri_t_20;
  wire [21:21]lcd_rgb_tri_t_21;
  wire [22:22]lcd_rgb_tri_t_22;
  wire [23:23]lcd_rgb_tri_t_23;
  wire [3:3]lcd_rgb_tri_t_3;
  wire [4:4]lcd_rgb_tri_t_4;
  wire [5:5]lcd_rgb_tri_t_5;
  wire [6:6]lcd_rgb_tri_t_6;
  wire [7:7]lcd_rgb_tri_t_7;
  wire [8:8]lcd_rgb_tri_t_8;
  wire [9:9]lcd_rgb_tri_t_9;
  wire lcd_rst;
  wire lcd_touch_e2p_scl_i;
  wire lcd_touch_e2p_scl_io;
  wire lcd_touch_e2p_scl_o;
  wire lcd_touch_e2p_scl_t;
  wire lcd_touch_e2p_sda_i;
  wire lcd_touch_e2p_sda_io;
  wire lcd_touch_e2p_sda_o;
  wire lcd_touch_e2p_sda_t;
  wire lcd_vs;
  wire [1:0]led_tri_o;
  wire mipi_hdmi_scl_i;
  wire mipi_hdmi_scl_io;
  wire mipi_hdmi_scl_o;
  wire mipi_hdmi_scl_t;
  wire mipi_hdmi_sda_i;
  wire mipi_hdmi_sda_io;
  wire mipi_hdmi_sda_o;
  wire mipi_hdmi_sda_t;
  wire mipi_phy_if_0_clk_n;
  wire mipi_phy_if_0_clk_p;
  wire [1:0]mipi_phy_if_0_data_n;
  wire [1:0]mipi_phy_if_0_data_p;

  IOBUF GPIO_tri_iobuf_0
       (.I(GPIO_tri_o_0),
        .IO(GPIO_tri_io[0]),
        .O(GPIO_tri_i_0),
        .T(GPIO_tri_t_0));
  IOBUF GPIO_tri_iobuf_1
       (.I(GPIO_tri_o_1),
        .IO(GPIO_tri_io[1]),
        .O(GPIO_tri_i_1),
        .T(GPIO_tri_t_1));
  IOBUF GPIO_tri_iobuf_10
       (.I(GPIO_tri_o_10),
        .IO(GPIO_tri_io[10]),
        .O(GPIO_tri_i_10),
        .T(GPIO_tri_t_10));
  IOBUF GPIO_tri_iobuf_11
       (.I(GPIO_tri_o_11),
        .IO(GPIO_tri_io[11]),
        .O(GPIO_tri_i_11),
        .T(GPIO_tri_t_11));
  IOBUF GPIO_tri_iobuf_12
       (.I(GPIO_tri_o_12),
        .IO(GPIO_tri_io[12]),
        .O(GPIO_tri_i_12),
        .T(GPIO_tri_t_12));
  IOBUF GPIO_tri_iobuf_13
       (.I(GPIO_tri_o_13),
        .IO(GPIO_tri_io[13]),
        .O(GPIO_tri_i_13),
        .T(GPIO_tri_t_13));
  IOBUF GPIO_tri_iobuf_14
       (.I(GPIO_tri_o_14),
        .IO(GPIO_tri_io[14]),
        .O(GPIO_tri_i_14),
        .T(GPIO_tri_t_14));
  IOBUF GPIO_tri_iobuf_15
       (.I(GPIO_tri_o_15),
        .IO(GPIO_tri_io[15]),
        .O(GPIO_tri_i_15),
        .T(GPIO_tri_t_15));
  IOBUF GPIO_tri_iobuf_16
       (.I(GPIO_tri_o_16),
        .IO(GPIO_tri_io[16]),
        .O(GPIO_tri_i_16),
        .T(GPIO_tri_t_16));
  IOBUF GPIO_tri_iobuf_17
       (.I(GPIO_tri_o_17),
        .IO(GPIO_tri_io[17]),
        .O(GPIO_tri_i_17),
        .T(GPIO_tri_t_17));
  IOBUF GPIO_tri_iobuf_18
       (.I(GPIO_tri_o_18),
        .IO(GPIO_tri_io[18]),
        .O(GPIO_tri_i_18),
        .T(GPIO_tri_t_18));
  IOBUF GPIO_tri_iobuf_19
       (.I(GPIO_tri_o_19),
        .IO(GPIO_tri_io[19]),
        .O(GPIO_tri_i_19),
        .T(GPIO_tri_t_19));
  IOBUF GPIO_tri_iobuf_2
       (.I(GPIO_tri_o_2),
        .IO(GPIO_tri_io[2]),
        .O(GPIO_tri_i_2),
        .T(GPIO_tri_t_2));
  IOBUF GPIO_tri_iobuf_20
       (.I(GPIO_tri_o_20),
        .IO(GPIO_tri_io[20]),
        .O(GPIO_tri_i_20),
        .T(GPIO_tri_t_20));
  IOBUF GPIO_tri_iobuf_21
       (.I(GPIO_tri_o_21),
        .IO(GPIO_tri_io[21]),
        .O(GPIO_tri_i_21),
        .T(GPIO_tri_t_21));
  IOBUF GPIO_tri_iobuf_22
       (.I(GPIO_tri_o_22),
        .IO(GPIO_tri_io[22]),
        .O(GPIO_tri_i_22),
        .T(GPIO_tri_t_22));
  IOBUF GPIO_tri_iobuf_23
       (.I(GPIO_tri_o_23),
        .IO(GPIO_tri_io[23]),
        .O(GPIO_tri_i_23),
        .T(GPIO_tri_t_23));
  IOBUF GPIO_tri_iobuf_24
       (.I(GPIO_tri_o_24),
        .IO(GPIO_tri_io[24]),
        .O(GPIO_tri_i_24),
        .T(GPIO_tri_t_24));
  IOBUF GPIO_tri_iobuf_25
       (.I(GPIO_tri_o_25),
        .IO(GPIO_tri_io[25]),
        .O(GPIO_tri_i_25),
        .T(GPIO_tri_t_25));
  IOBUF GPIO_tri_iobuf_26
       (.I(GPIO_tri_o_26),
        .IO(GPIO_tri_io[26]),
        .O(GPIO_tri_i_26),
        .T(GPIO_tri_t_26));
  IOBUF GPIO_tri_iobuf_27
       (.I(GPIO_tri_o_27),
        .IO(GPIO_tri_io[27]),
        .O(GPIO_tri_i_27),
        .T(GPIO_tri_t_27));
  IOBUF GPIO_tri_iobuf_28
       (.I(GPIO_tri_o_28),
        .IO(GPIO_tri_io[28]),
        .O(GPIO_tri_i_28),
        .T(GPIO_tri_t_28));
  IOBUF GPIO_tri_iobuf_29
       (.I(GPIO_tri_o_29),
        .IO(GPIO_tri_io[29]),
        .O(GPIO_tri_i_29),
        .T(GPIO_tri_t_29));
  IOBUF GPIO_tri_iobuf_3
       (.I(GPIO_tri_o_3),
        .IO(GPIO_tri_io[3]),
        .O(GPIO_tri_i_3),
        .T(GPIO_tri_t_3));
  IOBUF GPIO_tri_iobuf_30
       (.I(GPIO_tri_o_30),
        .IO(GPIO_tri_io[30]),
        .O(GPIO_tri_i_30),
        .T(GPIO_tri_t_30));
  IOBUF GPIO_tri_iobuf_31
       (.I(GPIO_tri_o_31),
        .IO(GPIO_tri_io[31]),
        .O(GPIO_tri_i_31),
        .T(GPIO_tri_t_31));
  IOBUF GPIO_tri_iobuf_32
       (.I(GPIO_tri_o_32),
        .IO(GPIO_tri_io[32]),
        .O(GPIO_tri_i_32),
        .T(GPIO_tri_t_32));
  IOBUF GPIO_tri_iobuf_33
       (.I(GPIO_tri_o_33),
        .IO(GPIO_tri_io[33]),
        .O(GPIO_tri_i_33),
        .T(GPIO_tri_t_33));
  IOBUF GPIO_tri_iobuf_34
       (.I(GPIO_tri_o_34),
        .IO(GPIO_tri_io[34]),
        .O(GPIO_tri_i_34),
        .T(GPIO_tri_t_34));
  IOBUF GPIO_tri_iobuf_35
       (.I(GPIO_tri_o_35),
        .IO(GPIO_tri_io[35]),
        .O(GPIO_tri_i_35),
        .T(GPIO_tri_t_35));
  IOBUF GPIO_tri_iobuf_36
       (.I(GPIO_tri_o_36),
        .IO(GPIO_tri_io[36]),
        .O(GPIO_tri_i_36),
        .T(GPIO_tri_t_36));
  IOBUF GPIO_tri_iobuf_37
       (.I(GPIO_tri_o_37),
        .IO(GPIO_tri_io[37]),
        .O(GPIO_tri_i_37),
        .T(GPIO_tri_t_37));
  IOBUF GPIO_tri_iobuf_38
       (.I(GPIO_tri_o_38),
        .IO(GPIO_tri_io[38]),
        .O(GPIO_tri_i_38),
        .T(GPIO_tri_t_38));
  IOBUF GPIO_tri_iobuf_39
       (.I(GPIO_tri_o_39),
        .IO(GPIO_tri_io[39]),
        .O(GPIO_tri_i_39),
        .T(GPIO_tri_t_39));
  IOBUF GPIO_tri_iobuf_4
       (.I(GPIO_tri_o_4),
        .IO(GPIO_tri_io[4]),
        .O(GPIO_tri_i_4),
        .T(GPIO_tri_t_4));
  IOBUF GPIO_tri_iobuf_40
       (.I(GPIO_tri_o_40),
        .IO(GPIO_tri_io[40]),
        .O(GPIO_tri_i_40),
        .T(GPIO_tri_t_40));
  IOBUF GPIO_tri_iobuf_41
       (.I(GPIO_tri_o_41),
        .IO(GPIO_tri_io[41]),
        .O(GPIO_tri_i_41),
        .T(GPIO_tri_t_41));
  IOBUF GPIO_tri_iobuf_42
       (.I(GPIO_tri_o_42),
        .IO(GPIO_tri_io[42]),
        .O(GPIO_tri_i_42),
        .T(GPIO_tri_t_42));
  IOBUF GPIO_tri_iobuf_43
       (.I(GPIO_tri_o_43),
        .IO(GPIO_tri_io[43]),
        .O(GPIO_tri_i_43),
        .T(GPIO_tri_t_43));
  IOBUF GPIO_tri_iobuf_44
       (.I(GPIO_tri_o_44),
        .IO(GPIO_tri_io[44]),
        .O(GPIO_tri_i_44),
        .T(GPIO_tri_t_44));
  IOBUF GPIO_tri_iobuf_45
       (.I(GPIO_tri_o_45),
        .IO(GPIO_tri_io[45]),
        .O(GPIO_tri_i_45),
        .T(GPIO_tri_t_45));
  IOBUF GPIO_tri_iobuf_46
       (.I(GPIO_tri_o_46),
        .IO(GPIO_tri_io[46]),
        .O(GPIO_tri_i_46),
        .T(GPIO_tri_t_46));
  IOBUF GPIO_tri_iobuf_47
       (.I(GPIO_tri_o_47),
        .IO(GPIO_tri_io[47]),
        .O(GPIO_tri_i_47),
        .T(GPIO_tri_t_47));
  IOBUF GPIO_tri_iobuf_48
       (.I(GPIO_tri_o_48),
        .IO(GPIO_tri_io[48]),
        .O(GPIO_tri_i_48),
        .T(GPIO_tri_t_48));
  IOBUF GPIO_tri_iobuf_5
       (.I(GPIO_tri_o_5),
        .IO(GPIO_tri_io[5]),
        .O(GPIO_tri_i_5),
        .T(GPIO_tri_t_5));
  IOBUF GPIO_tri_iobuf_6
       (.I(GPIO_tri_o_6),
        .IO(GPIO_tri_io[6]),
        .O(GPIO_tri_i_6),
        .T(GPIO_tri_t_6));
  IOBUF GPIO_tri_iobuf_7
       (.I(GPIO_tri_o_7),
        .IO(GPIO_tri_io[7]),
        .O(GPIO_tri_i_7),
        .T(GPIO_tri_t_7));
  IOBUF GPIO_tri_iobuf_8
       (.I(GPIO_tri_o_8),
        .IO(GPIO_tri_io[8]),
        .O(GPIO_tri_i_8),
        .T(GPIO_tri_t_8));
  IOBUF GPIO_tri_iobuf_9
       (.I(GPIO_tri_o_9),
        .IO(GPIO_tri_io[9]),
        .O(GPIO_tri_i_9),
        .T(GPIO_tri_t_9));
  IOBUF MDIO_mdio_iobuf
       (.I(MDIO_mdio_o),
        .IO(MDIO_mdio_io),
        .O(MDIO_mdio_i),
        .T(MDIO_mdio_t));
  IOBUF lcd_rgb_tri_iobuf_0
       (.I(lcd_rgb_tri_o_0),
        .IO(lcd_rgb_tri_io[0]),
        .O(lcd_rgb_tri_i_0),
        .T(lcd_rgb_tri_t_0));
  IOBUF lcd_rgb_tri_iobuf_1
       (.I(lcd_rgb_tri_o_1),
        .IO(lcd_rgb_tri_io[1]),
        .O(lcd_rgb_tri_i_1),
        .T(lcd_rgb_tri_t_1));
  IOBUF lcd_rgb_tri_iobuf_10
       (.I(lcd_rgb_tri_o_10),
        .IO(lcd_rgb_tri_io[10]),
        .O(lcd_rgb_tri_i_10),
        .T(lcd_rgb_tri_t_10));
  IOBUF lcd_rgb_tri_iobuf_11
       (.I(lcd_rgb_tri_o_11),
        .IO(lcd_rgb_tri_io[11]),
        .O(lcd_rgb_tri_i_11),
        .T(lcd_rgb_tri_t_11));
  IOBUF lcd_rgb_tri_iobuf_12
       (.I(lcd_rgb_tri_o_12),
        .IO(lcd_rgb_tri_io[12]),
        .O(lcd_rgb_tri_i_12),
        .T(lcd_rgb_tri_t_12));
  IOBUF lcd_rgb_tri_iobuf_13
       (.I(lcd_rgb_tri_o_13),
        .IO(lcd_rgb_tri_io[13]),
        .O(lcd_rgb_tri_i_13),
        .T(lcd_rgb_tri_t_13));
  IOBUF lcd_rgb_tri_iobuf_14
       (.I(lcd_rgb_tri_o_14),
        .IO(lcd_rgb_tri_io[14]),
        .O(lcd_rgb_tri_i_14),
        .T(lcd_rgb_tri_t_14));
  IOBUF lcd_rgb_tri_iobuf_15
       (.I(lcd_rgb_tri_o_15),
        .IO(lcd_rgb_tri_io[15]),
        .O(lcd_rgb_tri_i_15),
        .T(lcd_rgb_tri_t_15));
  IOBUF lcd_rgb_tri_iobuf_16
       (.I(lcd_rgb_tri_o_16),
        .IO(lcd_rgb_tri_io[16]),
        .O(lcd_rgb_tri_i_16),
        .T(lcd_rgb_tri_t_16));
  IOBUF lcd_rgb_tri_iobuf_17
       (.I(lcd_rgb_tri_o_17),
        .IO(lcd_rgb_tri_io[17]),
        .O(lcd_rgb_tri_i_17),
        .T(lcd_rgb_tri_t_17));
  IOBUF lcd_rgb_tri_iobuf_18
       (.I(lcd_rgb_tri_o_18),
        .IO(lcd_rgb_tri_io[18]),
        .O(lcd_rgb_tri_i_18),
        .T(lcd_rgb_tri_t_18));
  IOBUF lcd_rgb_tri_iobuf_19
       (.I(lcd_rgb_tri_o_19),
        .IO(lcd_rgb_tri_io[19]),
        .O(lcd_rgb_tri_i_19),
        .T(lcd_rgb_tri_t_19));
  IOBUF lcd_rgb_tri_iobuf_2
       (.I(lcd_rgb_tri_o_2),
        .IO(lcd_rgb_tri_io[2]),
        .O(lcd_rgb_tri_i_2),
        .T(lcd_rgb_tri_t_2));
  IOBUF lcd_rgb_tri_iobuf_20
       (.I(lcd_rgb_tri_o_20),
        .IO(lcd_rgb_tri_io[20]),
        .O(lcd_rgb_tri_i_20),
        .T(lcd_rgb_tri_t_20));
  IOBUF lcd_rgb_tri_iobuf_21
       (.I(lcd_rgb_tri_o_21),
        .IO(lcd_rgb_tri_io[21]),
        .O(lcd_rgb_tri_i_21),
        .T(lcd_rgb_tri_t_21));
  IOBUF lcd_rgb_tri_iobuf_22
       (.I(lcd_rgb_tri_o_22),
        .IO(lcd_rgb_tri_io[22]),
        .O(lcd_rgb_tri_i_22),
        .T(lcd_rgb_tri_t_22));
  IOBUF lcd_rgb_tri_iobuf_23
       (.I(lcd_rgb_tri_o_23),
        .IO(lcd_rgb_tri_io[23]),
        .O(lcd_rgb_tri_i_23),
        .T(lcd_rgb_tri_t_23));
  IOBUF lcd_rgb_tri_iobuf_3
       (.I(lcd_rgb_tri_o_3),
        .IO(lcd_rgb_tri_io[3]),
        .O(lcd_rgb_tri_i_3),
        .T(lcd_rgb_tri_t_3));
  IOBUF lcd_rgb_tri_iobuf_4
       (.I(lcd_rgb_tri_o_4),
        .IO(lcd_rgb_tri_io[4]),
        .O(lcd_rgb_tri_i_4),
        .T(lcd_rgb_tri_t_4));
  IOBUF lcd_rgb_tri_iobuf_5
       (.I(lcd_rgb_tri_o_5),
        .IO(lcd_rgb_tri_io[5]),
        .O(lcd_rgb_tri_i_5),
        .T(lcd_rgb_tri_t_5));
  IOBUF lcd_rgb_tri_iobuf_6
       (.I(lcd_rgb_tri_o_6),
        .IO(lcd_rgb_tri_io[6]),
        .O(lcd_rgb_tri_i_6),
        .T(lcd_rgb_tri_t_6));
  IOBUF lcd_rgb_tri_iobuf_7
       (.I(lcd_rgb_tri_o_7),
        .IO(lcd_rgb_tri_io[7]),
        .O(lcd_rgb_tri_i_7),
        .T(lcd_rgb_tri_t_7));
  IOBUF lcd_rgb_tri_iobuf_8
       (.I(lcd_rgb_tri_o_8),
        .IO(lcd_rgb_tri_io[8]),
        .O(lcd_rgb_tri_i_8),
        .T(lcd_rgb_tri_t_8));
  IOBUF lcd_rgb_tri_iobuf_9
       (.I(lcd_rgb_tri_o_9),
        .IO(lcd_rgb_tri_io[9]),
        .O(lcd_rgb_tri_i_9),
        .T(lcd_rgb_tri_t_9));
  IOBUF lcd_touch_e2p_scl_iobuf
       (.I(lcd_touch_e2p_scl_o),
        .IO(lcd_touch_e2p_scl_io),
        .O(lcd_touch_e2p_scl_i),
        .T(lcd_touch_e2p_scl_t));
  IOBUF lcd_touch_e2p_sda_iobuf
       (.I(lcd_touch_e2p_sda_o),
        .IO(lcd_touch_e2p_sda_io),
        .O(lcd_touch_e2p_sda_i),
        .T(lcd_touch_e2p_sda_t));
  IOBUF mipi_hdmi_scl_iobuf
       (.I(mipi_hdmi_scl_o),
        .IO(mipi_hdmi_scl_io),
        .O(mipi_hdmi_scl_i),
        .T(mipi_hdmi_scl_t));
  IOBUF mipi_hdmi_sda_iobuf
       (.I(mipi_hdmi_sda_o),
        .IO(mipi_hdmi_sda_io),
        .O(mipi_hdmi_sda_i),
        .T(mipi_hdmi_sda_t));
  system system_i
       (.C0_SYS_CLK_clk_n(C0_SYS_CLK_clk_n),
        .C0_SYS_CLK_clk_p(C0_SYS_CLK_clk_p),
        .GPIO_tri_i({GPIO_tri_i_48,GPIO_tri_i_47,GPIO_tri_i_46,GPIO_tri_i_45,GPIO_tri_i_44,GPIO_tri_i_43,GPIO_tri_i_42,GPIO_tri_i_41,GPIO_tri_i_40,GPIO_tri_i_39,GPIO_tri_i_38,GPIO_tri_i_37,GPIO_tri_i_36,GPIO_tri_i_35,GPIO_tri_i_34,GPIO_tri_i_33,GPIO_tri_i_32,GPIO_tri_i_31,GPIO_tri_i_30,GPIO_tri_i_29,GPIO_tri_i_28,GPIO_tri_i_27,GPIO_tri_i_26,GPIO_tri_i_25,GPIO_tri_i_24,GPIO_tri_i_23,GPIO_tri_i_22,GPIO_tri_i_21,GPIO_tri_i_20,GPIO_tri_i_19,GPIO_tri_i_18,GPIO_tri_i_17,GPIO_tri_i_16,GPIO_tri_i_15,GPIO_tri_i_14,GPIO_tri_i_13,GPIO_tri_i_12,GPIO_tri_i_11,GPIO_tri_i_10,GPIO_tri_i_9,GPIO_tri_i_8,GPIO_tri_i_7,GPIO_tri_i_6,GPIO_tri_i_5,GPIO_tri_i_4,GPIO_tri_i_3,GPIO_tri_i_2,GPIO_tri_i_1,GPIO_tri_i_0}),
        .GPIO_tri_o({GPIO_tri_o_48,GPIO_tri_o_47,GPIO_tri_o_46,GPIO_tri_o_45,GPIO_tri_o_44,GPIO_tri_o_43,GPIO_tri_o_42,GPIO_tri_o_41,GPIO_tri_o_40,GPIO_tri_o_39,GPIO_tri_o_38,GPIO_tri_o_37,GPIO_tri_o_36,GPIO_tri_o_35,GPIO_tri_o_34,GPIO_tri_o_33,GPIO_tri_o_32,GPIO_tri_o_31,GPIO_tri_o_30,GPIO_tri_o_29,GPIO_tri_o_28,GPIO_tri_o_27,GPIO_tri_o_26,GPIO_tri_o_25,GPIO_tri_o_24,GPIO_tri_o_23,GPIO_tri_o_22,GPIO_tri_o_21,GPIO_tri_o_20,GPIO_tri_o_19,GPIO_tri_o_18,GPIO_tri_o_17,GPIO_tri_o_16,GPIO_tri_o_15,GPIO_tri_o_14,GPIO_tri_o_13,GPIO_tri_o_12,GPIO_tri_o_11,GPIO_tri_o_10,GPIO_tri_o_9,GPIO_tri_o_8,GPIO_tri_o_7,GPIO_tri_o_6,GPIO_tri_o_5,GPIO_tri_o_4,GPIO_tri_o_3,GPIO_tri_o_2,GPIO_tri_o_1,GPIO_tri_o_0}),
        .GPIO_tri_t({GPIO_tri_t_48,GPIO_tri_t_47,GPIO_tri_t_46,GPIO_tri_t_45,GPIO_tri_t_44,GPIO_tri_t_43,GPIO_tri_t_42,GPIO_tri_t_41,GPIO_tri_t_40,GPIO_tri_t_39,GPIO_tri_t_38,GPIO_tri_t_37,GPIO_tri_t_36,GPIO_tri_t_35,GPIO_tri_t_34,GPIO_tri_t_33,GPIO_tri_t_32,GPIO_tri_t_31,GPIO_tri_t_30,GPIO_tri_t_29,GPIO_tri_t_28,GPIO_tri_t_27,GPIO_tri_t_26,GPIO_tri_t_25,GPIO_tri_t_24,GPIO_tri_t_23,GPIO_tri_t_22,GPIO_tri_t_21,GPIO_tri_t_20,GPIO_tri_t_19,GPIO_tri_t_18,GPIO_tri_t_17,GPIO_tri_t_16,GPIO_tri_t_15,GPIO_tri_t_14,GPIO_tri_t_13,GPIO_tri_t_12,GPIO_tri_t_11,GPIO_tri_t_10,GPIO_tri_t_9,GPIO_tri_t_8,GPIO_tri_t_7,GPIO_tri_t_6,GPIO_tri_t_5,GPIO_tri_t_4,GPIO_tri_t_3,GPIO_tri_t_2,GPIO_tri_t_1,GPIO_tri_t_0}),
        .MDIO_mdc(MDIO_mdc),
        .MDIO_mdio_i(MDIO_mdio_i),
        .MDIO_mdio_o(MDIO_mdio_o),
        .MDIO_mdio_t(MDIO_mdio_t),
        .RGMII_rd(RGMII_rd),
        .RGMII_rx_ctl(RGMII_rx_ctl),
        .RGMII_rxc(RGMII_rxc),
        .RGMII_td(RGMII_td),
        .RGMII_tx_ctl(RGMII_tx_ctl),
        .RGMII_txc(RGMII_txc),
        .TMDS_tmds_clk_n(TMDS_tmds_clk_n),
        .TMDS_tmds_clk_p(TMDS_tmds_clk_p),
        .TMDS_tmds_data_n(TMDS_tmds_data_n),
        .TMDS_tmds_data_p(TMDS_tmds_data_p),
        .UART_rxd(UART_rxd),
        .UART_txd(UART_txd),
        .cam_clk(cam_clk),
        .ddr4_act_n(ddr4_act_n),
        .ddr4_adr(ddr4_adr),
        .ddr4_ba(ddr4_ba),
        .ddr4_bg(ddr4_bg),
        .ddr4_ck_c(ddr4_ck_c),
        .ddr4_ck_t(ddr4_ck_t),
        .ddr4_cke(ddr4_cke),
        .ddr4_cs_n(ddr4_cs_n),
        .ddr4_dm_n(ddr4_dm_n),
        .ddr4_dq(ddr4_dq),
        .ddr4_dqs_c(ddr4_dqs_c),
        .ddr4_dqs_t(ddr4_dqs_t),
        .ddr4_odt(ddr4_odt),
        .ddr4_reset_n(ddr4_reset_n),
        .lcd_bl(lcd_bl),
        .lcd_clk(lcd_clk),
        .lcd_de(lcd_de),
        .lcd_hs(lcd_hs),
        .lcd_rgb_tri_i({lcd_rgb_tri_i_23,lcd_rgb_tri_i_22,lcd_rgb_tri_i_21,lcd_rgb_tri_i_20,lcd_rgb_tri_i_19,lcd_rgb_tri_i_18,lcd_rgb_tri_i_17,lcd_rgb_tri_i_16,lcd_rgb_tri_i_15,lcd_rgb_tri_i_14,lcd_rgb_tri_i_13,lcd_rgb_tri_i_12,lcd_rgb_tri_i_11,lcd_rgb_tri_i_10,lcd_rgb_tri_i_9,lcd_rgb_tri_i_8,lcd_rgb_tri_i_7,lcd_rgb_tri_i_6,lcd_rgb_tri_i_5,lcd_rgb_tri_i_4,lcd_rgb_tri_i_3,lcd_rgb_tri_i_2,lcd_rgb_tri_i_1,lcd_rgb_tri_i_0}),
        .lcd_rgb_tri_o({lcd_rgb_tri_o_23,lcd_rgb_tri_o_22,lcd_rgb_tri_o_21,lcd_rgb_tri_o_20,lcd_rgb_tri_o_19,lcd_rgb_tri_o_18,lcd_rgb_tri_o_17,lcd_rgb_tri_o_16,lcd_rgb_tri_o_15,lcd_rgb_tri_o_14,lcd_rgb_tri_o_13,lcd_rgb_tri_o_12,lcd_rgb_tri_o_11,lcd_rgb_tri_o_10,lcd_rgb_tri_o_9,lcd_rgb_tri_o_8,lcd_rgb_tri_o_7,lcd_rgb_tri_o_6,lcd_rgb_tri_o_5,lcd_rgb_tri_o_4,lcd_rgb_tri_o_3,lcd_rgb_tri_o_2,lcd_rgb_tri_o_1,lcd_rgb_tri_o_0}),
        .lcd_rgb_tri_t({lcd_rgb_tri_t_23,lcd_rgb_tri_t_22,lcd_rgb_tri_t_21,lcd_rgb_tri_t_20,lcd_rgb_tri_t_19,lcd_rgb_tri_t_18,lcd_rgb_tri_t_17,lcd_rgb_tri_t_16,lcd_rgb_tri_t_15,lcd_rgb_tri_t_14,lcd_rgb_tri_t_13,lcd_rgb_tri_t_12,lcd_rgb_tri_t_11,lcd_rgb_tri_t_10,lcd_rgb_tri_t_9,lcd_rgb_tri_t_8,lcd_rgb_tri_t_7,lcd_rgb_tri_t_6,lcd_rgb_tri_t_5,lcd_rgb_tri_t_4,lcd_rgb_tri_t_3,lcd_rgb_tri_t_2,lcd_rgb_tri_t_1,lcd_rgb_tri_t_0}),
        .lcd_rst(lcd_rst),
        .lcd_touch_e2p_scl_i(lcd_touch_e2p_scl_i),
        .lcd_touch_e2p_scl_o(lcd_touch_e2p_scl_o),
        .lcd_touch_e2p_scl_t(lcd_touch_e2p_scl_t),
        .lcd_touch_e2p_sda_i(lcd_touch_e2p_sda_i),
        .lcd_touch_e2p_sda_o(lcd_touch_e2p_sda_o),
        .lcd_touch_e2p_sda_t(lcd_touch_e2p_sda_t),
        .lcd_vs(lcd_vs),
        .led_tri_o(led_tri_o),
        .mipi_hdmi_scl_i(mipi_hdmi_scl_i),
        .mipi_hdmi_scl_o(mipi_hdmi_scl_o),
        .mipi_hdmi_scl_t(mipi_hdmi_scl_t),
        .mipi_hdmi_sda_i(mipi_hdmi_sda_i),
        .mipi_hdmi_sda_o(mipi_hdmi_sda_o),
        .mipi_hdmi_sda_t(mipi_hdmi_sda_t),
        .mipi_phy_if_0_clk_n(mipi_phy_if_0_clk_n),
        .mipi_phy_if_0_clk_p(mipi_phy_if_0_clk_p),
        .mipi_phy_if_0_data_n(mipi_phy_if_0_data_n),
        .mipi_phy_if_0_data_p(mipi_phy_if_0_data_p));
endmodule
