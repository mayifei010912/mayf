-- Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2020.2 (win64) Build 3064766 Wed Nov 18 09:12:45 MST 2020
-- Date        : Sat Oct 17 21:50:09 2026
-- Host        : mayifei running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode funcsim
--               f:/fpga/PenumbraSight_board_vendor_gmii_20261017/source_full/system/ip/system_hdmi_shared_0/system_hdmi_shared_0_sim_netlist.vhdl
-- Design      : system_hdmi_shared_0
-- Purpose     : This VHDL netlist is a functional simulation representation of the design and should not be modified or
--               synthesized. This netlist cannot be used for SDF annotated simulation.
-- Device      : xczu4ev-sfvc784-2-i
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity system_hdmi_shared_0_hdmi_clock_shared is
  port (
    raw_clock : in STD_LOGIC;
    locked : in STD_LOGIC;
    fast_clock : out STD_LOGIC;
    slow_clock : out STD_LOGIC;
    pixel_clock : out STD_LOGIC
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of system_hdmi_shared_0_hdmi_clock_shared : entity is "hdmi_clock_shared";
  attribute keep_hierarchy : string;
  attribute keep_hierarchy of system_hdmi_shared_0_hdmi_clock_shared : entity is "yes";
end system_hdmi_shared_0_hdmi_clock_shared;

architecture STRUCTURE of system_hdmi_shared_0_hdmi_clock_shared is
  signal CLR0 : STD_LOGIC;
  attribute BOX_TYPE : string;
  attribute BOX_TYPE of fast_buffer : label is "PRIMITIVE";
  attribute BOX_TYPE of pixel_buffer : label is "PRIMITIVE";
  attribute BOX_TYPE of slow_buffer : label is "PRIMITIVE";
  attribute X_INTERFACE_INFO : string;
  attribute X_INTERFACE_INFO of fast_clock : signal is "xilinx.com:signal:clock:1.0 fast_clock CLK";
  attribute X_INTERFACE_INFO of pixel_clock : signal is "xilinx.com:signal:clock:1.0 pixel_clock CLK";
  attribute X_INTERFACE_INFO of raw_clock : signal is "xilinx.com:signal:clock:1.0 raw_clock CLK";
  attribute X_INTERFACE_INFO of slow_clock : signal is "xilinx.com:signal:clock:1.0 slow_clock CLK";
begin
fast_buffer: unisim.vcomponents.BUFGCE
    generic map(
      CE_TYPE => "SYNC",
      IS_CE_INVERTED => '0',
      IS_I_INVERTED => '0',
      SIM_DEVICE => "ULTRASCALE",
      STARTUP_SYNC => "FALSE"
    )
        port map (
      CE => locked,
      I => raw_clock,
      O => fast_clock
    );
pixel_buffer: unisim.vcomponents.BUFGCE_DIV
    generic map(
      BUFGCE_DIVIDE => 5,
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
      I => raw_clock,
      O => pixel_clock
    );
slow_buffer: unisim.vcomponents.BUFGCE_DIV
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
      I => raw_clock,
      O => slow_clock
    );
slow_buffer_i_1: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => locked,
      O => CLR0
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity system_hdmi_shared_0 is
  port (
    raw_clock : in STD_LOGIC;
    locked : in STD_LOGIC;
    fast_clock : out STD_LOGIC;
    slow_clock : out STD_LOGIC;
    pixel_clock : out STD_LOGIC
  );
  attribute NotValidForBitStream : boolean;
  attribute NotValidForBitStream of system_hdmi_shared_0 : entity is true;
  attribute CHECK_LICENSE_TYPE : string;
  attribute CHECK_LICENSE_TYPE of system_hdmi_shared_0 : entity is "system_hdmi_shared_0,hdmi_clock_shared,{}";
  attribute DowngradeIPIdentifiedWarnings : string;
  attribute DowngradeIPIdentifiedWarnings of system_hdmi_shared_0 : entity is "yes";
  attribute IP_DEFINITION_SOURCE : string;
  attribute IP_DEFINITION_SOURCE of system_hdmi_shared_0 : entity is "module_ref";
  attribute X_CORE_INFO : string;
  attribute X_CORE_INFO of system_hdmi_shared_0 : entity is "hdmi_clock_shared,Vivado 2020.2";
end system_hdmi_shared_0;

architecture STRUCTURE of system_hdmi_shared_0 is
  attribute KEEP_HIERARCHY : string;
  attribute KEEP_HIERARCHY of inst : label is "yes";
  attribute X_INTERFACE_INFO : string;
  attribute X_INTERFACE_INFO of fast_clock : signal is "xilinx.com:signal:clock:1.0 fast_clock CLK";
  attribute X_INTERFACE_PARAMETER : string;
  attribute X_INTERFACE_PARAMETER of fast_clock : signal is "XIL_INTERFACENAME fast_clock, FREQ_HZ 370829625, FREQ_TOLERANCE_HZ 0, PHASE 0.000, CLK_DOMAIN system_hdmi_shared_0_fast_clock, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of pixel_clock : signal is "xilinx.com:signal:clock:1.0 pixel_clock CLK";
  attribute X_INTERFACE_PARAMETER of pixel_clock : signal is "XIL_INTERFACENAME pixel_clock, FREQ_HZ 74165925, FREQ_TOLERANCE_HZ 0, PHASE 0.000, CLK_DOMAIN system_hdmi_shared_0_pixel_clock, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of raw_clock : signal is "xilinx.com:signal:clock:1.0 raw_clock CLK";
  attribute X_INTERFACE_PARAMETER of raw_clock : signal is "XIL_INTERFACENAME raw_clock, FREQ_HZ 370829625, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN system_clk_wiz_0_1_clk_out1, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of slow_clock : signal is "xilinx.com:signal:clock:1.0 slow_clock CLK";
  attribute X_INTERFACE_PARAMETER of slow_clock : signal is "XIL_INTERFACENAME slow_clock, FREQ_HZ 185414813, FREQ_TOLERANCE_HZ 0, PHASE 0.000, CLK_DOMAIN system_hdmi_shared_0_slow_clock, INSERT_VIP 0";
begin
inst: entity work.system_hdmi_shared_0_hdmi_clock_shared
     port map (
      fast_clock => fast_clock,
      locked => locked,
      pixel_clock => pixel_clock,
      raw_clock => raw_clock,
      slow_clock => slow_clock
    );
end STRUCTURE;
