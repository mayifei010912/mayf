-- Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2020.2 (win64) Build 3064766 Wed Nov 18 09:12:45 MST 2020
-- Date        : Fri Oct 30 22:46:32 2026
-- Host        : mayifei running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode funcsim
--               f:/fpga/PenumbraSight_hybrid_FISTA_20261030/board_source/ip/system_hybrid_clock_1/system_hybrid_clock_1_sim_netlist.vhdl
-- Design      : system_hybrid_clock_1
-- Purpose     : This VHDL netlist is a functional simulation representation of the design and should not be modified or
--               synthesized. This netlist cannot be used for SDF annotated simulation.
-- Device      : xczu4ev-sfvc784-2-i
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity system_hybrid_clock_1_hybrid_clock_div2 is
  port (
    clk_out1 : out STD_LOGIC;
    clk_in1 : in STD_LOGIC;
    resetn : in STD_LOGIC
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of system_hybrid_clock_1_hybrid_clock_div2 : entity is "hybrid_clock_div2";
end system_hybrid_clock_1_hybrid_clock_div2;

architecture STRUCTURE of system_hybrid_clock_1_hybrid_clock_div2 is
  signal CLR0 : STD_LOGIC;
  attribute BOX_TYPE : string;
  attribute BOX_TYPE of divide_buffer : label is "PRIMITIVE";
begin
divide_buffer: unisim.vcomponents.BUFGCE_DIV
    generic map(
      BUFGCE_DIVIDE => 2,
      CE_TYPE => "SYNC",
      HARDSYNC_CLR => "FALSE",
      IS_CE_INVERTED => '0',
      IS_CLR_INVERTED => '0',
      IS_I_INVERTED => '0',
      SIM_DEVICE => "ULTRASCALE",
      STARTUP_SYNC => "FALSE"
    )
        port map (
      CE => '1',
      CLR => CLR0,
      I => clk_in1,
      O => clk_out1
    );
divide_buffer_i_1: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => resetn,
      O => CLR0
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity system_hybrid_clock_1 is
  port (
    clk_in1 : in STD_LOGIC;
    resetn : in STD_LOGIC;
    clk_out1 : out STD_LOGIC;
    locked : out STD_LOGIC
  );
  attribute NotValidForBitStream : boolean;
  attribute NotValidForBitStream of system_hybrid_clock_1 : entity is true;
  attribute CHECK_LICENSE_TYPE : string;
  attribute CHECK_LICENSE_TYPE of system_hybrid_clock_1 : entity is "system_hybrid_clock_1,hybrid_clock_div2,{}";
  attribute DowngradeIPIdentifiedWarnings : string;
  attribute DowngradeIPIdentifiedWarnings of system_hybrid_clock_1 : entity is "yes";
  attribute IP_DEFINITION_SOURCE : string;
  attribute IP_DEFINITION_SOURCE of system_hybrid_clock_1 : entity is "module_ref";
  attribute X_CORE_INFO : string;
  attribute X_CORE_INFO of system_hybrid_clock_1 : entity is "hybrid_clock_div2,Vivado 2020.2";
end system_hybrid_clock_1;

architecture STRUCTURE of system_hybrid_clock_1 is
  signal \^resetn\ : STD_LOGIC;
  attribute X_INTERFACE_INFO : string;
  attribute X_INTERFACE_INFO of clk_in1 : signal is "xilinx.com:signal:clock:1.0 clk_in1 CLK";
  attribute X_INTERFACE_PARAMETER : string;
  attribute X_INTERFACE_PARAMETER of clk_in1 : signal is "XIL_INTERFACENAME clk_in1, FREQ_HZ 99999001, ASSOCIATED_RESET resetn, FREQ_TOLERANCE_HZ 0, PHASE 0.000, CLK_DOMAIN system_zynq_ultra_ps_e_0_0_pl_clk0, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of clk_out1 : signal is "xilinx.com:signal:clock:1.0 clk_out1 CLK";
  attribute X_INTERFACE_PARAMETER of clk_out1 : signal is "XIL_INTERFACENAME clk_out1, FREQ_HZ 49999500, FREQ_TOLERANCE_HZ 0, PHASE 0.000, CLK_DOMAIN system_hybrid_clock_1_clk_out1, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of resetn : signal is "xilinx.com:signal:reset:1.0 resetn RST";
  attribute X_INTERFACE_PARAMETER of resetn : signal is "XIL_INTERFACENAME resetn, POLARITY ACTIVE_LOW, INSERT_VIP 0";
begin
  \^resetn\ <= resetn;
  locked <= \^resetn\;
inst: entity work.system_hybrid_clock_1_hybrid_clock_div2
     port map (
      clk_in1 => clk_in1,
      clk_out1 => clk_out1,
      resetn => \^resetn\
    );
end STRUCTURE;
