-- Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2020.2 (win64) Build 3064766 Wed Nov 18 09:12:45 MST 2020
-- Date        : Sat Oct 17 21:50:09 2026
-- Host        : mayifei running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub
--               f:/fpga/PenumbraSight_board_vendor_gmii_20261017/source_full/system/ip/system_hdmi_shared_0/system_hdmi_shared_0_stub.vhdl
-- Design      : system_hdmi_shared_0
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xczu4ev-sfvc784-2-i
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity system_hdmi_shared_0 is
  Port ( 
    raw_clock : in STD_LOGIC;
    locked : in STD_LOGIC;
    fast_clock : out STD_LOGIC;
    slow_clock : out STD_LOGIC;
    pixel_clock : out STD_LOGIC
  );

end system_hdmi_shared_0;

architecture stub of system_hdmi_shared_0 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "raw_clock,locked,fast_clock,slow_clock,pixel_clock";
attribute X_CORE_INFO : string;
attribute X_CORE_INFO of stub : architecture is "hdmi_clock_shared,Vivado 2020.2";
begin
end;
