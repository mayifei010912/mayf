-- Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2020.2 (win64) Build 3064766 Wed Nov 18 09:12:45 MST 2020
-- Date        : Sat Oct 17 21:55:57 2026
-- Host        : mayifei running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub
--               f:/fpga/PenumbraSight_board_vendor_gmii_20261017/source_full/system/ip/system_DVI_Transmitter_Safe_0_0/system_DVI_Transmitter_Safe_0_0_stub.vhdl
-- Design      : system_DVI_Transmitter_Safe_0_0
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xczu4ev-sfvc784-2-i
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity system_DVI_Transmitter_Safe_0_0 is
  Port ( 
    pclk : in STD_LOGIC;
    pixel_clk_5x : in STD_LOGIC;
    pixel_clk_2_5x : in STD_LOGIC;
    reset_n : in STD_LOGIC;
    video_din : in STD_LOGIC_VECTOR ( 23 downto 0 );
    video_hsync : in STD_LOGIC;
    video_vsync : in STD_LOGIC;
    video_de : in STD_LOGIC;
    tmds_clk_p : out STD_LOGIC;
    tmds_clk_n : out STD_LOGIC;
    tmds_data_p : out STD_LOGIC_VECTOR ( 2 downto 0 );
    tmds_data_n : out STD_LOGIC_VECTOR ( 2 downto 0 );
    tmds_oen : out STD_LOGIC
  );

end system_DVI_Transmitter_Safe_0_0;

architecture stub of system_DVI_Transmitter_Safe_0_0 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "pclk,pixel_clk_5x,pixel_clk_2_5x,reset_n,video_din[23:0],video_hsync,video_vsync,video_de,tmds_clk_p,tmds_clk_n,tmds_data_p[2:0],tmds_data_n[2:0],tmds_oen";
attribute X_CORE_INFO : string;
attribute X_CORE_INFO of stub : architecture is "dvi_transmitter_top,Vivado 2020.2";
begin
end;
