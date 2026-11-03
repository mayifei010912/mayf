-- Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2020.2 (win64) Build 3064766 Wed Nov 18 09:12:45 MST 2020
-- Date        : Thu Dec 19 15:15:01 2024
-- Host        : DESKTOP-2P288OB running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub
--               g:/mpsoc_p4/v20_20241219/4ev/base_vcu/base_vcu.srcs/sources_1/bd/system/ip/system_v_proc_ss_1_0/system_v_proc_ss_1_0_stub.vhdl
-- Design      : system_v_proc_ss_1_0
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xczu4ev-sfvc784-2-i
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity system_v_proc_ss_1_0 is
  Port ( 
    aclk_axis : in STD_LOGIC;
    aclk_ctrl : in STD_LOGIC;
    aresetn_ctrl : in STD_LOGIC;
    aresetn_io_axis : out STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_ctrl_awaddr : in STD_LOGIC_VECTOR ( 17 downto 0 );
    s_axi_ctrl_awprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s_axi_ctrl_awvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_ctrl_awready : out STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_ctrl_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_ctrl_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_ctrl_wvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_ctrl_wready : out STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_ctrl_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_ctrl_bvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_ctrl_bready : in STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_ctrl_araddr : in STD_LOGIC_VECTOR ( 17 downto 0 );
    s_axi_ctrl_arprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s_axi_ctrl_arvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_ctrl_arready : out STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_ctrl_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_ctrl_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_ctrl_rvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_ctrl_rready : in STD_LOGIC_VECTOR ( 0 to 0 );
    s_axis_tdata : in STD_LOGIC_VECTOR ( 47 downto 0 );
    s_axis_tdest : in STD_LOGIC_VECTOR ( 0 to 0 );
    s_axis_tid : in STD_LOGIC_VECTOR ( 0 to 0 );
    s_axis_tkeep : in STD_LOGIC_VECTOR ( 5 downto 0 );
    s_axis_tlast : in STD_LOGIC;
    s_axis_tready : out STD_LOGIC;
    s_axis_tstrb : in STD_LOGIC_VECTOR ( 5 downto 0 );
    s_axis_tuser : in STD_LOGIC_VECTOR ( 0 to 0 );
    s_axis_tvalid : in STD_LOGIC;
    m_axis_tdata : out STD_LOGIC_VECTOR ( 47 downto 0 );
    m_axis_tdest : out STD_LOGIC_VECTOR ( 0 to 0 );
    m_axis_tid : out STD_LOGIC_VECTOR ( 0 to 0 );
    m_axis_tkeep : out STD_LOGIC_VECTOR ( 5 downto 0 );
    m_axis_tlast : out STD_LOGIC_VECTOR ( 0 to 0 );
    m_axis_tready : in STD_LOGIC;
    m_axis_tstrb : out STD_LOGIC_VECTOR ( 5 downto 0 );
    m_axis_tuser : out STD_LOGIC_VECTOR ( 0 to 0 );
    m_axis_tvalid : out STD_LOGIC
  );

end system_v_proc_ss_1_0;

architecture stub of system_v_proc_ss_1_0 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "aclk_axis,aclk_ctrl,aresetn_ctrl,aresetn_io_axis[0:0],s_axi_ctrl_awaddr[17:0],s_axi_ctrl_awprot[2:0],s_axi_ctrl_awvalid[0:0],s_axi_ctrl_awready[0:0],s_axi_ctrl_wdata[31:0],s_axi_ctrl_wstrb[3:0],s_axi_ctrl_wvalid[0:0],s_axi_ctrl_wready[0:0],s_axi_ctrl_bresp[1:0],s_axi_ctrl_bvalid[0:0],s_axi_ctrl_bready[0:0],s_axi_ctrl_araddr[17:0],s_axi_ctrl_arprot[2:0],s_axi_ctrl_arvalid[0:0],s_axi_ctrl_arready[0:0],s_axi_ctrl_rdata[31:0],s_axi_ctrl_rresp[1:0],s_axi_ctrl_rvalid[0:0],s_axi_ctrl_rready[0:0],s_axis_tdata[47:0],s_axis_tdest[0:0],s_axis_tid[0:0],s_axis_tkeep[5:0],s_axis_tlast,s_axis_tready,s_axis_tstrb[5:0],s_axis_tuser[0:0],s_axis_tvalid,m_axis_tdata[47:0],m_axis_tdest[0:0],m_axis_tid[0:0],m_axis_tkeep[5:0],m_axis_tlast[0:0],m_axis_tready,m_axis_tstrb[5:0],m_axis_tuser[0:0],m_axis_tvalid";
attribute X_CORE_INFO : string;
attribute X_CORE_INFO of stub : architecture is "bd_ed01,Vivado 2020.2";
begin
end;
