-- Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2020.2 (win64) Build 3064766 Wed Nov 18 09:12:45 MST 2020
-- Date        : Sat Oct 17 21:56:38 2026
-- Host        : mayifei running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode funcsim
--               f:/fpga/PenumbraSight_board_vendor_gmii_20261017/source_full/system/ip/system_frame_reset_sync_0/system_frame_reset_sync_0_sim_netlist.vhdl
-- Design      : system_frame_reset_sync_0
-- Purpose     : This VHDL netlist is a functional simulation representation of the design and should not be modified or
--               synthesized. This netlist cannot be used for SDF annotated simulation.
-- Device      : xczu4ev-sfvc784-2-i
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity system_frame_reset_sync_0_hdmi_frame_reset_sync is
  port (
    resetn : out STD_LOGIC;
    global_resetn : in STD_LOGIC;
    software_resetn : in STD_LOGIC;
    clk : in STD_LOGIC
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of system_frame_reset_sync_0_hdmi_frame_reset_sync : entity is "hdmi_frame_reset_sync";
end system_frame_reset_sync_0_hdmi_frame_reset_sync;

architecture STRUCTURE of system_frame_reset_sync_0_hdmi_frame_reset_sync is
  signal release_pipe : STD_LOGIC_VECTOR ( 2 downto 0 );
  attribute async_reg : string;
  attribute async_reg of release_pipe : signal is "true";
  attribute shreg_extract : string;
  attribute shreg_extract of release_pipe : signal is "no";
  signal \release_pipe[2]_i_1_n_0\ : STD_LOGIC;
  attribute ASYNC_REG_boolean : boolean;
  attribute ASYNC_REG_boolean of \release_pipe_reg[0]\ : label is std.standard.true;
  attribute KEEP : string;
  attribute KEEP of \release_pipe_reg[0]\ : label is "yes";
  attribute SHREG_EXTRACT of \release_pipe_reg[0]\ : label is "no";
  attribute ASYNC_REG_boolean of \release_pipe_reg[1]\ : label is std.standard.true;
  attribute KEEP of \release_pipe_reg[1]\ : label is "yes";
  attribute SHREG_EXTRACT of \release_pipe_reg[1]\ : label is "no";
  attribute ASYNC_REG_boolean of \release_pipe_reg[2]\ : label is std.standard.true;
  attribute KEEP of \release_pipe_reg[2]\ : label is "yes";
  attribute SHREG_EXTRACT of \release_pipe_reg[2]\ : label is "no";
begin
  resetn <= release_pipe(2);
\release_pipe[2]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"7"
    )
        port map (
      I0 => global_resetn,
      I1 => software_resetn,
      O => \release_pipe[2]_i_1_n_0\
    );
\release_pipe_reg[0]\: unisim.vcomponents.FDCE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      CLR => \release_pipe[2]_i_1_n_0\,
      D => '1',
      Q => release_pipe(0)
    );
\release_pipe_reg[1]\: unisim.vcomponents.FDCE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      CLR => \release_pipe[2]_i_1_n_0\,
      D => release_pipe(0),
      Q => release_pipe(1)
    );
\release_pipe_reg[2]\: unisim.vcomponents.FDCE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      CLR => \release_pipe[2]_i_1_n_0\,
      D => release_pipe(1),
      Q => release_pipe(2)
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity system_frame_reset_sync_0 is
  port (
    clk : in STD_LOGIC;
    global_resetn : in STD_LOGIC;
    software_resetn : in STD_LOGIC;
    resetn : out STD_LOGIC
  );
  attribute NotValidForBitStream : boolean;
  attribute NotValidForBitStream of system_frame_reset_sync_0 : entity is true;
  attribute CHECK_LICENSE_TYPE : string;
  attribute CHECK_LICENSE_TYPE of system_frame_reset_sync_0 : entity is "system_frame_reset_sync_0,hdmi_frame_reset_sync,{}";
  attribute DowngradeIPIdentifiedWarnings : string;
  attribute DowngradeIPIdentifiedWarnings of system_frame_reset_sync_0 : entity is "yes";
  attribute IP_DEFINITION_SOURCE : string;
  attribute IP_DEFINITION_SOURCE of system_frame_reset_sync_0 : entity is "module_ref";
  attribute X_CORE_INFO : string;
  attribute X_CORE_INFO of system_frame_reset_sync_0 : entity is "hdmi_frame_reset_sync,Vivado 2020.2";
end system_frame_reset_sync_0;

architecture STRUCTURE of system_frame_reset_sync_0 is
  attribute X_INTERFACE_INFO : string;
  attribute X_INTERFACE_INFO of clk : signal is "xilinx.com:signal:clock:1.0 clk CLK";
  attribute X_INTERFACE_PARAMETER : string;
  attribute X_INTERFACE_PARAMETER of clk : signal is "XIL_INTERFACENAME clk, ASSOCIATED_RESET resetn, FREQ_HZ 74165925, FREQ_TOLERANCE_HZ 0, PHASE 0.000, CLK_DOMAIN system_hdmi_shared_0_pixel_clock, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of global_resetn : signal is "xilinx.com:signal:reset:1.0 global_resetn RST";
  attribute X_INTERFACE_PARAMETER of global_resetn : signal is "XIL_INTERFACENAME global_resetn, POLARITY ACTIVE_LOW, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of resetn : signal is "xilinx.com:signal:reset:1.0 resetn RST";
  attribute X_INTERFACE_PARAMETER of resetn : signal is "XIL_INTERFACENAME resetn, POLARITY ACTIVE_LOW, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of software_resetn : signal is "xilinx.com:signal:reset:1.0 software_resetn RST";
  attribute X_INTERFACE_PARAMETER of software_resetn : signal is "XIL_INTERFACENAME software_resetn, POLARITY ACTIVE_LOW, INSERT_VIP 0";
begin
inst: entity work.system_frame_reset_sync_0_hdmi_frame_reset_sync
     port map (
      clk => clk,
      global_resetn => global_resetn,
      resetn => resetn,
      software_resetn => software_resetn
    );
end STRUCTURE;
