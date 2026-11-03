-- Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2020.2 (win64) Build 3064766 Wed Nov 18 09:12:45 MST 2020
-- Date        : Sat Oct 17 21:56:38 2026
-- Host        : mayifei running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub
--               f:/fpga/PenumbraSight_board_vendor_gmii_20261017/source_full/system/ip/system_frame_reset_sync_0/system_frame_reset_sync_0_stub.vhdl
-- Design      : system_frame_reset_sync_0
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xczu4ev-sfvc784-2-i
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity system_frame_reset_sync_0 is
  Port ( 
    clk : in STD_LOGIC;
    global_resetn : in STD_LOGIC;
    software_resetn : in STD_LOGIC;
    resetn : out STD_LOGIC
  );

end system_frame_reset_sync_0;

architecture stub of system_frame_reset_sync_0 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clk,global_resetn,software_resetn,resetn";
attribute X_CORE_INFO : string;
attribute X_CORE_INFO of stub : architecture is "hdmi_frame_reset_sync,Vivado 2020.2";
begin
end;
