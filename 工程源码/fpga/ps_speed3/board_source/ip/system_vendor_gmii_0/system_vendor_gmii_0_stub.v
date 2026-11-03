// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.2 (win64) Build 3064766 Wed Nov 18 09:12:45 MST 2020
// Date        : Sun Oct 18 00:11:28 2026
// Host        : mayifei running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               f:/fpga/PenumbraSight_board_vendor_gmii_20261017/source_full/system/ip/system_vendor_gmii_0/system_vendor_gmii_0_stub.v
// Design      : system_vendor_gmii_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xczu4ev-sfvc784-2-i
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "gmii_to_rgmii_v4_1_0,Vivado 2020.2" *)
module system_vendor_gmii_0(tx_reset, rx_reset, clkin, ref_clk_out, 
  mmcm_locked_out, gmii_clk_125m_out, gmii_clk_25m_out, gmii_clk_2_5m_out, 
  gmii_clk_125m_90_out, gmii_clk_25m_90_out, gmii_clk_2_5m_90_out, speed_mode, gmii_tx_clk, 
  gmii_tx_en, gmii_txd, gmii_tx_er, gmii_crs, gmii_col, gmii_rx_clk, gmii_rx_dv, gmii_rxd, 
  gmii_rx_er, mdio_gem_mdc, mdio_gem_i, mdio_gem_o, mdio_gem_t, link_status, clock_speed, 
  duplex_status, rgmii_txd, rgmii_tx_ctl, rgmii_txc, rgmii_rxd, rgmii_rx_ctl, rgmii_rxc, 
  mdio_phy_mdc, mdio_phy_i, mdio_phy_o, mdio_phy_t)
/* synthesis syn_black_box black_box_pad_pin="tx_reset,rx_reset,clkin,ref_clk_out,mmcm_locked_out,gmii_clk_125m_out,gmii_clk_25m_out,gmii_clk_2_5m_out,gmii_clk_125m_90_out,gmii_clk_25m_90_out,gmii_clk_2_5m_90_out,speed_mode[1:0],gmii_tx_clk,gmii_tx_en,gmii_txd[7:0],gmii_tx_er,gmii_crs,gmii_col,gmii_rx_clk,gmii_rx_dv,gmii_rxd[7:0],gmii_rx_er,mdio_gem_mdc,mdio_gem_i,mdio_gem_o,mdio_gem_t,link_status,clock_speed[1:0],duplex_status,rgmii_txd[3:0],rgmii_tx_ctl,rgmii_txc,rgmii_rxd[3:0],rgmii_rx_ctl,rgmii_rxc,mdio_phy_mdc,mdio_phy_i,mdio_phy_o,mdio_phy_t" */;
  input tx_reset;
  input rx_reset;
  input clkin;
  output ref_clk_out;
  output mmcm_locked_out;
  output gmii_clk_125m_out;
  output gmii_clk_25m_out;
  output gmii_clk_2_5m_out;
  output gmii_clk_125m_90_out;
  output gmii_clk_25m_90_out;
  output gmii_clk_2_5m_90_out;
  output [1:0]speed_mode;
  output gmii_tx_clk;
  input gmii_tx_en;
  input [7:0]gmii_txd;
  input gmii_tx_er;
  output gmii_crs;
  output gmii_col;
  output gmii_rx_clk;
  output gmii_rx_dv;
  output [7:0]gmii_rxd;
  output gmii_rx_er;
  input mdio_gem_mdc;
  output mdio_gem_i;
  input mdio_gem_o;
  input mdio_gem_t;
  output link_status;
  output [1:0]clock_speed;
  output duplex_status;
  output [3:0]rgmii_txd;
  output rgmii_tx_ctl;
  output rgmii_txc;
  input [3:0]rgmii_rxd;
  input rgmii_rx_ctl;
  input rgmii_rxc;
  output mdio_phy_mdc;
  input mdio_phy_i;
  output mdio_phy_o;
  output mdio_phy_t;
endmodule
