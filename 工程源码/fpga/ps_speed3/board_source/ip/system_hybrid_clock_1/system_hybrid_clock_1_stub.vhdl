-- Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2020.2 (win64) Build 3064766 Wed Nov 18 09:12:45 MST 2020
-- Date        : Fri Oct 30 22:46:32 2026
-- Host        : mayifei running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub
--               f:/fpga/PenumbraSight_hybrid_FISTA_20261030/board_source/ip/system_hybrid_clock_1/system_hybrid_clock_1_stub.vhdl
-- Design      : system_hybrid_clock_1
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xczu4ev-sfvc784-2-i
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity system_hybrid_clock_1 is
  Port ( 
    clk_in1 : in STD_LOGIC;
    resetn : in STD_LOGIC;
    clk_out1 : out STD_LOGIC;
    locked : out STD_LOGIC
  );

end system_hybrid_clock_1;

architecture stub of system_hybrid_clock_1 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clk_in1,resetn,clk_out1,locked";
attribute X_CORE_INFO : string;
attribute X_CORE_INFO of stub : architecture is "hybrid_clock_div2,Vivado 2020.2";
begin
end;
