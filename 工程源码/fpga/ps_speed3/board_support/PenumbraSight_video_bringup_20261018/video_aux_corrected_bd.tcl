
################################################################
# This is a generated script based on design: system
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2020.2
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_gid_msg -ssname BD::TCL -id 2041 -severity "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source system_script.tcl


# The design that will be created by this Tcl script contains the following 
# module references:
# hdmi_clock_shared, nlos_axi_lite_board_bd, hdmi_frame_reset_sync

# Please add the sources of those modules before sourcing this Tcl script.

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xczu4ev-sfvc784-2-i
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name system

# This script was generated for a remote BD. To create a non-remote design,
# change the variable <run_remote_bd_flow> to <0>.

set run_remote_bd_flow 1
if { $run_remote_bd_flow == 1 } {
  # Set the reference directory for source file relative paths (by default 
  # the value is script directory path)
  set origin_dir ./source_full

  # Use origin directory path location variable, if specified in the tcl shell
  if { [info exists ::origin_dir_loc] } {
     set origin_dir $::origin_dir_loc
  }

  set str_bd_folder [file normalize ${origin_dir}]
  set str_bd_filepath ${str_bd_folder}/${design_name}/${design_name}.bd

  # Check if remote design exists on disk
  if { [file exists $str_bd_filepath ] == 1 } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2030 -severity "ERROR" "The remote BD file path <$str_bd_filepath> already exists!"}
     common::send_gid_msg -ssname BD::TCL -id 2031 -severity "INFO" "To create a non-remote BD, change the variable <run_remote_bd_flow> to <0>."
     common::send_gid_msg -ssname BD::TCL -id 2032 -severity "INFO" "Also make sure there is no design <$design_name> existing in your current project."

     return 1
  }

  # Check if design exists in memory
  set list_existing_designs [get_bd_designs -quiet $design_name]
  if { $list_existing_designs ne "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2033 -severity "ERROR" "The design <$design_name> already exists in this project! Will not create the remote BD <$design_name> at the folder <$str_bd_folder>."}

     common::send_gid_msg -ssname BD::TCL -id 2034 -severity "INFO" "To create a non-remote BD, change the variable <run_remote_bd_flow> to <0> or please set a different value to variable <design_name>."

     return 1
  }

  # Check if design exists on disk within project
  set list_existing_designs [get_files -quiet */${design_name}.bd]
  if { $list_existing_designs ne "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2035 -severity "ERROR" "The design <$design_name> already exists in this project at location:
    $list_existing_designs"}
     catch {common::send_gid_msg -ssname BD::TCL -id 2036 -severity "ERROR" "Will not create the remote BD <$design_name> at the folder <$str_bd_folder>."}

     common::send_gid_msg -ssname BD::TCL -id 2037 -severity "INFO" "To create a non-remote BD, change the variable <run_remote_bd_flow> to <0> or please set a different value to variable <design_name>."

     return 1
  }

  # Now can create the remote BD
  # NOTE - usage of <-dir> will create <$str_bd_folder/$design_name/$design_name.bd>
  create_bd_design -dir $str_bd_folder $design_name
} else {

  # Create regular design
  if { [catch {create_bd_design $design_name} errmsg] } {
     common::send_gid_msg -ssname BD::TCL -id 2038 -severity "INFO" "Please set a different value to variable <design_name>."

     return 1
  }
}

current_bd_design $design_name

  # Add USER_COMMENTS on $design_name
  set_property USER_COMMENTS.comment_0 "rst gpio 
-------
0: lcd framebuffer
1: hdmi framebuffer
2: CSI FB WR rst
3: CSI Demosaic rst
4: CSI Gamma rst
5: CSI VPSS CSC rst
6: CSI VPSS Scaler rst
" [get_bd_designs $design_name]
set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\ 
xilinx.com:ip:axi_gpio:2.0\
xilinx.com:ip:clk_wiz:6.0\
xilinx.com:ip:ddr4:2.2\
xilinx.com:ip:proc_sys_reset:5.0\
xilinx.com:ip:xlconstant:1.1\
xilinx.com:ip:smartconnect:1.0\
xilinx.com:ip:vcu:1.2\
xilinx.com:ip:gmii_to_rgmii:4.1\
xilinx.com:ip:xlconcat:2.1\
xilinx.com:ip:xlslice:1.0\
xilinx.com:ip:zynq_ultra_ps_e:3.3\
nlos.local:user:DVI_Transmitter_Safe:1.0\
xilinx.com:ip:axis_subset_converter:1.1\
xilinx.com:ip:v_axi4s_vid_out:4.0\
xilinx.com:ip:v_tc:6.2\
xilinx.com:ip:v_frmbuf_rd:2.2\
digilentinc.com:IP:PWM:2.0\
www.alientek.com:user:rgb2lcd:1.0\
xilinx.com:ip:mipi_csi2_rx_subsystem:5.1\
xilinx.com:ip:v_demosaic:1.1\
xilinx.com:ip:v_frmbuf_wr:2.2\
xilinx.com:ip:v_gamma_lut:1.1\
xilinx.com:ip:v_proc_ss:2.3\
"

   set list_ips_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2011 -severity "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2012 -severity "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

}

##################################################################
# CHECK Modules
##################################################################
set bCheckModules 1
if { $bCheckModules == 1 } {
   set list_check_mods "\ 
hdmi_clock_shared\
nlos_axi_lite_board_bd\
hdmi_frame_reset_sync\
"

   set list_mods_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2020 -severity "INFO" "Checking if the following modules exist in the project's sources: $list_check_mods ."

   foreach mod_vlnv $list_check_mods {
      if { [can_resolve_reference $mod_vlnv] == 0 } {
         lappend list_mods_missing $mod_vlnv
      }
   }

   if { $list_mods_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2021 -severity "ERROR" "The following module(s) are not found in the project: $list_mods_missing" }
      common::send_gid_msg -ssname BD::TCL -id 2022 -severity "INFO" "Please add source files for the missing module(s) above."
      set bCheckIPsPassed 0
   }
}

if { $bCheckIPsPassed != 1 } {
  common::send_gid_msg -ssname BD::TCL -id 2023 -severity "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}

##################################################################
# DESIGN PROCs
##################################################################


# Hierarchical cell: rst_hier
proc create_hier_cell_rst_hier { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_rst_hier() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins

  # Create pins
  create_bd_pin -dir I -type rst ext_reset_in
  create_bd_pin -dir I -type rst ext_reset_in1
  create_bd_pin -dir I -type rst ext_reset_in2
  create_bd_pin -dir O -from 0 -to 0 -type rst peripheral_aresetn
  create_bd_pin -dir O -from 0 -to 0 -type rst peripheral_aresetn1
  create_bd_pin -dir O -from 0 -to 0 -type rst peripheral_aresetn2
  create_bd_pin -dir O -from 0 -to 0 -type rst peripheral_aresetn3
  create_bd_pin -dir O -from 0 -to 0 -type rst peripheral_aresetn4
  create_bd_pin -dir O -from 0 -to 0 -type rst peripheral_reset
  create_bd_pin -dir I -type clk slowest_sync_clk
  create_bd_pin -dir I -type clk slowest_sync_clk1
  create_bd_pin -dir I -type clk slowest_sync_clk2
  create_bd_pin -dir I -type clk slowest_sync_clk3
  create_bd_pin -dir I -type clk slowest_sync_clk4

  # Create instance: rst_clk_wiz_0_148M, and set properties
  set rst_clk_wiz_0_148M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_clk_wiz_0_148M ]

  # Create instance: rst_clk_wiz_0_33M, and set properties
  set rst_clk_wiz_0_33M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_clk_wiz_0_33M ]

  # Create instance: rst_ddr4_0_266M, and set properties
  set rst_ddr4_0_266M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_ddr4_0_266M ]

  # Create instance: rst_gen_reg, and set properties
  set rst_gen_reg [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_gen_reg ]

  # Create instance: rst_ps8_0_299M, and set properties
  set rst_ps8_0_299M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_ps8_0_299M ]

  # Create port connections
  connect_bd_net -net clk_wiz_0_clk_out1 [get_bd_pins slowest_sync_clk] [get_bd_pins rst_clk_wiz_0_33M/slowest_sync_clk]
  connect_bd_net -net clk_wiz_0_clk_out2 [get_bd_pins slowest_sync_clk2] [get_bd_pins rst_clk_wiz_0_148M/slowest_sync_clk]
  connect_bd_net -net clk_wiz_0_locked [get_bd_pins ext_reset_in] [get_bd_pins rst_clk_wiz_0_148M/ext_reset_in] [get_bd_pins rst_clk_wiz_0_33M/ext_reset_in]
  connect_bd_net -net ddr4_0_c0_ddr4_ui_clk [get_bd_pins slowest_sync_clk4] [get_bd_pins rst_ddr4_0_266M/slowest_sync_clk]
  connect_bd_net -net ddr4_0_c0_ddr4_ui_clk_sync_rst [get_bd_pins ext_reset_in2] [get_bd_pins rst_ddr4_0_266M/ext_reset_in]
  connect_bd_net -net rst_clk_wiz_0_148M_peripheral_aresetn [get_bd_pins peripheral_aresetn2] [get_bd_pins rst_clk_wiz_0_148M/peripheral_aresetn]
  connect_bd_net -net rst_clk_wiz_0_33M_peripheral_aresetn [get_bd_pins peripheral_aresetn] [get_bd_pins rst_clk_wiz_0_33M/peripheral_aresetn]
  connect_bd_net -net rst_ddr4_0_266M_peripheral_aresetn [get_bd_pins peripheral_aresetn4] [get_bd_pins rst_ddr4_0_266M/peripheral_aresetn]
  connect_bd_net -net rst_gen_reg_peripheral_reset [get_bd_pins peripheral_reset] [get_bd_pins rst_gen_reg/peripheral_reset]
  connect_bd_net -net rst_ps8_0_299M_peripheral_aresetn [get_bd_pins peripheral_aresetn3] [get_bd_pins rst_ps8_0_299M/peripheral_aresetn]
  connect_bd_net -net rst_ps8_0_99M_1_peripheral_aresetn [get_bd_pins peripheral_aresetn1] [get_bd_pins rst_gen_reg/peripheral_aresetn]
  connect_bd_net -net zynq_ultra_ps_e_0_pl_clk0 [get_bd_pins slowest_sync_clk1] [get_bd_pins rst_gen_reg/slowest_sync_clk]
  connect_bd_net -net zynq_ultra_ps_e_0_pl_clk3 [get_bd_pins slowest_sync_clk3] [get_bd_pins rst_ps8_0_299M/slowest_sync_clk]
  connect_bd_net -net zynq_ultra_ps_e_0_pl_resetn0 [get_bd_pins ext_reset_in1] [get_bd_pins rst_gen_reg/ext_reset_in] [get_bd_pins rst_ps8_0_299M/ext_reset_in]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: mipi_csi2_rx
proc create_hier_cell_mipi_csi2_rx { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_mipi_csi2_rx() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 csirxss_s_axi

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 m_axi_mm_video

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:mipi_phy_rtl:1.0 mipi_phy_if_0

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi_CTRL

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi_CTRL1

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi_CTRL3

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi_ctrl2

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi_ctrl4


  # Create pins
  create_bd_pin -dir I -from 31 -to 0 Din
  create_bd_pin -dir I -type clk aclk_axis
  create_bd_pin -dir I -type rst aresetn
  create_bd_pin -dir O -type intr csirxss_csi_irq
  create_bd_pin -dir I -type clk dphy_clk_200M
  create_bd_pin -dir O -type intr interrupt
  create_bd_pin -dir I -type clk lite_aclk
  create_bd_pin -dir I -type rst lite_aresetn

  # Create instance: axis_subset_converter_0, and set properties
  set axis_subset_converter_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_subset_converter:1.1 axis_subset_converter_0 ]
  set_property -dict [ list \
   CONFIG.M_TDATA_NUM_BYTES {2} \
   CONFIG.S_TDATA_NUM_BYTES {3} \
   CONFIG.TDATA_REMAP {tdata[19:12],tdata[9:2]} \
   CONFIG.TDEST_REMAP {tdest[9:0]} \
   CONFIG.TID_REMAP {1'b0} \
   CONFIG.TKEEP_REMAP {1'b0} \
   CONFIG.TLAST_REMAP {tlast[0]} \
   CONFIG.TSTRB_REMAP {1'b0} \
   CONFIG.TUSER_REMAP {tuser[0:0]} \
 ] $axis_subset_converter_0

  # Create instance: axis_subset_converter_1, and set properties
  set axis_subset_converter_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_subset_converter:1.1 axis_subset_converter_1 ]
  set_property -dict [ list \
   CONFIG.M_TDATA_NUM_BYTES {6} \
   CONFIG.S_TDATA_NUM_BYTES {6} \
   CONFIG.TDATA_REMAP {tdata[39:32],tdata[47:40],tdata[31:24],tdata[15:8],tdata[23:16],tdata[7:0]} \
   CONFIG.TDEST_REMAP {tdest[0:0]} \
   CONFIG.TID_REMAP {tid[0:0]} \
   CONFIG.TKEEP_REMAP {tkeep[5:0]} \
   CONFIG.TLAST_REMAP {tlast[0]} \
   CONFIG.TSTRB_REMAP {tstrb[5:0]} \
   CONFIG.TUSER_REMAP {tuser[0:0]} \
 ] $axis_subset_converter_1

  # Create instance: demosaic_rst_gpio, and set properties
  set demosaic_rst_gpio [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 demosaic_rst_gpio ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {3} \
   CONFIG.DIN_TO {3} \
   CONFIG.DOUT_WIDTH {1} \
 ] $demosaic_rst_gpio

  # Create instance: frmbuf_wr_rst_gpio, and set properties
  set frmbuf_wr_rst_gpio [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 frmbuf_wr_rst_gpio ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {2} \
   CONFIG.DIN_TO {2} \
 ] $frmbuf_wr_rst_gpio

  # Create instance: gamma_rst_gpio, and set properties
  set gamma_rst_gpio [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 gamma_rst_gpio ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {4} \
   CONFIG.DIN_TO {4} \
   CONFIG.DOUT_WIDTH {1} \
 ] $gamma_rst_gpio

  # Create instance: mipi_csi2_rx_subsyst_0, and set properties
  set mipi_csi2_rx_subsyst_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:mipi_csi2_rx_subsystem:5.1 mipi_csi2_rx_subsyst_0 ]
  set_property -dict [ list \
   CONFIG.CLK_LANE_IO_LOC {W8} \
   CONFIG.CLK_LANE_IO_LOC_NAME {IO_L1P_T0L_N0_DBC_65} \
   CONFIG.CMN_NUM_LANES {2} \
   CONFIG.CMN_NUM_PIXELS {2} \
   CONFIG.CMN_PXL_FORMAT {RAW10} \
   CONFIG.CSI_BUF_DEPTH {4096} \
   CONFIG.C_CSI_EN_ACTIVELANES {false} \
   CONFIG.C_CSI_EN_CRC {false} \
   CONFIG.C_CSI_FILTER_USERDATATYPE {true} \
   CONFIG.C_DPHY_LANES {2} \
   CONFIG.C_HS_LINE_RATE {1000} \
   CONFIG.C_HS_SETTLE_NS {145} \
   CONFIG.C_STRETCH_LINE_RATE {2500} \
   CONFIG.DATA_LANE0_IO_LOC {U9} \
   CONFIG.DATA_LANE0_IO_LOC_NAME {IO_L2P_T0L_N2_65} \
   CONFIG.DATA_LANE1_IO_LOC {U8} \
   CONFIG.DATA_LANE1_IO_LOC_NAME {IO_L3P_T0L_N4_AD15P_65} \
   CONFIG.DATA_LANE2_IO_LOC {None} \
   CONFIG.DATA_LANE2_IO_LOC_NAME {IO_L4P_T0U_N6_DBC_AD7P_SMBALERT_65} \
   CONFIG.DATA_LANE3_IO_LOC {None} \
   CONFIG.DATA_LANE3_IO_LOC_NAME {IO_L5P_T0U_N8_AD14P_65} \
   CONFIG.DPY_EN_REG_IF {true} \
   CONFIG.DPY_LINE_RATE {1000} \
   CONFIG.HP_IO_BANK_SELECTION {65} \
   CONFIG.SupportLevel {1} \
 ] $mipi_csi2_rx_subsyst_0

  # Create instance: v_demosaic_0, and set properties
  set v_demosaic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_demosaic:1.1 v_demosaic_0 ]
  set_property -dict [ list \
   CONFIG.ENABLE_ZIPPER_REMOVAL {false} \
   CONFIG.MAX_COLS {4096} \
   CONFIG.MAX_DATA_WIDTH {8} \
   CONFIG.MAX_ROWS {3000} \
   CONFIG.SAMPLES_PER_CLOCK {2} \
   CONFIG.USE_URAM {0} \
 ] $v_demosaic_0

  # Create instance: v_frmbuf_wr_0, and set properties
  set v_frmbuf_wr_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_frmbuf_wr:2.2 v_frmbuf_wr_0 ]
  set_property -dict [ list \
   CONFIG.AXIMM_DATA_WIDTH {128} \
   CONFIG.C_M_AXI_MM_VIDEO_DATA_WIDTH {128} \
   CONFIG.HAS_BGR8 {1} \
   CONFIG.HAS_UYVY8 {1} \
   CONFIG.HAS_Y8 {0} \
   CONFIG.HAS_YUV8 {1} \
   CONFIG.HAS_YUVX8 {0} \
   CONFIG.HAS_YUYV8 {1} \
   CONFIG.HAS_Y_UV8 {1} \
   CONFIG.HAS_Y_UV8_420 {1} \
   CONFIG.MAX_COLS {4096} \
   CONFIG.MAX_NR_PLANES {2} \
   CONFIG.MAX_ROWS {3000} \
   CONFIG.SAMPLES_PER_CLOCK {2} \
 ] $v_frmbuf_wr_0

  # Create instance: v_gamma_lut_0, and set properties
  set v_gamma_lut_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_gamma_lut:1.1 v_gamma_lut_0 ]
  set_property -dict [ list \
   CONFIG.MAX_COLS {4096} \
   CONFIG.MAX_DATA_WIDTH {8} \
   CONFIG.MAX_ROWS {3000} \
   CONFIG.SAMPLES_PER_CLOCK {2} \
 ] $v_gamma_lut_0

  # Create instance: v_proc_ss_csc, and set properties
  set v_proc_ss_csc [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_proc_ss:2.3 v_proc_ss_csc ]
  set_property -dict [ list \
   CONFIG.C_COLORSPACE_SUPPORT {2} \
   CONFIG.C_CSC_ENABLE_WINDOW {false} \
   CONFIG.C_MAX_COLS {4096} \
   CONFIG.C_MAX_DATA_WIDTH {8} \
   CONFIG.C_MAX_ROWS {3000} \
   CONFIG.C_SAMPLES_PER_CLK {2} \
   CONFIG.C_TOPOLOGY {3} \
 ] $v_proc_ss_csc

  # Create instance: v_proc_ss_scaler, and set properties
  set v_proc_ss_scaler [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_proc_ss:2.3 v_proc_ss_scaler ]
  set_property -dict [ list \
   CONFIG.C_COLORSPACE_SUPPORT {0} \
   CONFIG.C_ENABLE_CSC {true} \
   CONFIG.C_H_SCALER_TAPS {8} \
   CONFIG.C_MAX_COLS {4096} \
   CONFIG.C_MAX_DATA_WIDTH {8} \
   CONFIG.C_MAX_ROWS {3000} \
   CONFIG.C_SAMPLES_PER_CLK {2} \
   CONFIG.C_SCALER_ALGORITHM {1} \
   CONFIG.C_TOPOLOGY {0} \
   CONFIG.C_V_SCALER_TAPS {8} \
 ] $v_proc_ss_scaler

  # Create instance: vpss_csc_rst_gpio, and set properties
  set vpss_csc_rst_gpio [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 vpss_csc_rst_gpio ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {5} \
   CONFIG.DIN_TO {5} \
   CONFIG.DOUT_WIDTH {1} \
 ] $vpss_csc_rst_gpio

  # Create instance: vpss_scaler_rst_gpio, and set properties
  set vpss_scaler_rst_gpio [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 vpss_scaler_rst_gpio ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {6} \
   CONFIG.DIN_TO {6} \
   CONFIG.DOUT_WIDTH {1} \
 ] $vpss_scaler_rst_gpio

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins m_axi_mm_video] [get_bd_intf_pins v_frmbuf_wr_0/m_axi_mm_video]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins s_axi_ctrl2] [get_bd_intf_pins v_proc_ss_csc/s_axi_ctrl]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins mipi_phy_if_0] [get_bd_intf_pins mipi_csi2_rx_subsyst_0/mipi_phy_if]
  connect_bd_intf_net -intf_net Conn4 [get_bd_intf_pins s_axi_ctrl4] [get_bd_intf_pins v_proc_ss_scaler/s_axi_ctrl]
  connect_bd_intf_net -intf_net axi_interconnect_0_M11_AXI [get_bd_intf_pins csirxss_s_axi] [get_bd_intf_pins mipi_csi2_rx_subsyst_0/csirxss_s_axi]
  connect_bd_intf_net -intf_net axi_interconnect_0_M13_AXI [get_bd_intf_pins s_axi_CTRL3] [get_bd_intf_pins v_frmbuf_wr_0/s_axi_CTRL]
  connect_bd_intf_net -intf_net axis_subset_converter_0_M_AXIS [get_bd_intf_pins axis_subset_converter_0/M_AXIS] [get_bd_intf_pins v_demosaic_0/s_axis_video]
  connect_bd_intf_net -intf_net axis_subset_converter_1_M_AXIS [get_bd_intf_pins axis_subset_converter_1/M_AXIS] [get_bd_intf_pins v_gamma_lut_0/s_axis_video]
  connect_bd_intf_net -intf_net mipi_csi2_rx_subsyst_0_video_out [get_bd_intf_pins axis_subset_converter_0/S_AXIS] [get_bd_intf_pins mipi_csi2_rx_subsyst_0/video_out]
  connect_bd_intf_net -intf_net s_axi_CTRL1_1 [get_bd_intf_pins s_axi_CTRL1] [get_bd_intf_pins v_gamma_lut_0/s_axi_CTRL]
  connect_bd_intf_net -intf_net s_axi_CTRL_1 [get_bd_intf_pins s_axi_CTRL] [get_bd_intf_pins v_demosaic_0/s_axi_CTRL]
  connect_bd_intf_net -intf_net v_demosaic_0_m_axis_video [get_bd_intf_pins axis_subset_converter_1/S_AXIS] [get_bd_intf_pins v_demosaic_0/m_axis_video]
  connect_bd_intf_net -intf_net v_gamma_lut_0_m_axis_video [get_bd_intf_pins v_gamma_lut_0/m_axis_video] [get_bd_intf_pins v_proc_ss_csc/s_axis]
  connect_bd_intf_net -intf_net v_proc_ss_csc_m_axis [get_bd_intf_pins v_proc_ss_csc/m_axis] [get_bd_intf_pins v_proc_ss_scaler/s_axis]
  connect_bd_intf_net -intf_net v_proc_ss_scaler_m_axis [get_bd_intf_pins v_frmbuf_wr_0/s_axis_video] [get_bd_intf_pins v_proc_ss_scaler/m_axis]

  # Create port connections
  connect_bd_net -net Din_1 [get_bd_pins Din] [get_bd_pins demosaic_rst_gpio/Din] [get_bd_pins frmbuf_wr_rst_gpio/Din] [get_bd_pins gamma_rst_gpio/Din] [get_bd_pins vpss_csc_rst_gpio/Din] [get_bd_pins vpss_scaler_rst_gpio/Din]
  connect_bd_net -net aclk_axis_1 [get_bd_pins aclk_axis] [get_bd_pins axis_subset_converter_0/aclk] [get_bd_pins axis_subset_converter_1/aclk] [get_bd_pins mipi_csi2_rx_subsyst_0/video_aclk] [get_bd_pins v_demosaic_0/ap_clk] [get_bd_pins v_frmbuf_wr_0/ap_clk] [get_bd_pins v_gamma_lut_0/ap_clk] [get_bd_pins v_proc_ss_csc/aclk] [get_bd_pins v_proc_ss_scaler/aclk_axis] [get_bd_pins v_proc_ss_scaler/aclk_ctrl]
  connect_bd_net -net aresetn_1 [get_bd_pins aresetn] [get_bd_pins axis_subset_converter_0/aresetn] [get_bd_pins mipi_csi2_rx_subsyst_0/video_aresetn]
  connect_bd_net -net demosaic_rst_gpio_Dout [get_bd_pins demosaic_rst_gpio/Dout] [get_bd_pins v_demosaic_0/ap_rst_n]
  connect_bd_net -net dphy_clk_200M_1 [get_bd_pins dphy_clk_200M] [get_bd_pins mipi_csi2_rx_subsyst_0/dphy_clk_200M]
  connect_bd_net -net lite_aclk_1 [get_bd_pins lite_aclk] [get_bd_pins mipi_csi2_rx_subsyst_0/lite_aclk]
  connect_bd_net -net lite_aresetn_1 [get_bd_pins lite_aresetn] [get_bd_pins mipi_csi2_rx_subsyst_0/lite_aresetn]
  connect_bd_net -net mipi_csi2_rx_subsyst_0_csirxss_csi_irq [get_bd_pins csirxss_csi_irq] [get_bd_pins mipi_csi2_rx_subsyst_0/csirxss_csi_irq]
  connect_bd_net -net v_frmbuf_wr_0_interrupt [get_bd_pins interrupt] [get_bd_pins v_frmbuf_wr_0/interrupt]
  connect_bd_net -net xlslice_0_Dout [get_bd_pins frmbuf_wr_rst_gpio/Dout] [get_bd_pins v_frmbuf_wr_0/ap_rst_n]
  connect_bd_net -net xlslice_0_Dout1 [get_bd_pins axis_subset_converter_1/aresetn] [get_bd_pins gamma_rst_gpio/Dout] [get_bd_pins v_gamma_lut_0/ap_rst_n]
  connect_bd_net -net xlslice_0_Dout3 [get_bd_pins v_proc_ss_csc/aresetn] [get_bd_pins vpss_csc_rst_gpio/Dout]
  connect_bd_net -net xlslice_1_Dout [get_bd_pins v_proc_ss_scaler/aresetn_ctrl] [get_bd_pins vpss_scaler_rst_gpio/Dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: lcd_out
proc create_hier_cell_lcd_out { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_lcd_out() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_MM2S

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 PWM_AXI

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 ctrl

  create_bd_intf_pin -mode Master -vlnv xilinx.com:user:lcd_rtl:1.0 lcd

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 lcd_rgb


  # Create pins
  create_bd_pin -dir I -from 31 -to 0 Din
  create_bd_pin -dir I -type rst aresetn
  create_bd_pin -dir O -type intr irq
  create_bd_pin -dir O -from 0 -to 0 lcd_bl
  create_bd_pin -dir O -type rst lcd_rst
  create_bd_pin -dir O -type intr mm2s_introut
  create_bd_pin -dir I -type clk pixel_clk
  create_bd_pin -dir I -type clk s_axi_aclk
  create_bd_pin -dir I -type rst s_axi_aresetn

  # Create instance: PWM_0, and set properties
  set PWM_0 [ create_bd_cell -type ip -vlnv digilentinc.com:IP:PWM:2.0 PWM_0 ]

  # Create instance: axis_subset_converter_0, and set properties
  set axis_subset_converter_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_subset_converter:1.1 axis_subset_converter_0 ]
  set_property -dict [ list \
   CONFIG.TDATA_REMAP {tdata[15:8],tdata[7:0],tdata[23:16]} \
   CONFIG.TDEST_REMAP {tdest[0:0]} \
   CONFIG.TID_REMAP {tid[0:0]} \
   CONFIG.TKEEP_REMAP {tkeep[2:0]} \
   CONFIG.TLAST_REMAP {tlast[0]} \
   CONFIG.TSTRB_REMAP {tstrb[2:0]} \
   CONFIG.TUSER_REMAP {tuser[0:0]} \
 ] $axis_subset_converter_0

  # Create instance: lcd_frmbuf_rd, and set properties
  set lcd_frmbuf_rd [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_frmbuf_rd:2.2 lcd_frmbuf_rd ]
  set_property -dict [ list \
   CONFIG.AXIMM_DATA_WIDTH {64} \
   CONFIG.C_M_AXI_MM_VIDEO_DATA_WIDTH {64} \
   CONFIG.HAS_BGR8 {1} \
   CONFIG.MAX_COLS {1280} \
   CONFIG.MAX_ROWS {800} \
   CONFIG.SAMPLES_PER_CLOCK {1} \
 ] $lcd_frmbuf_rd

  # Create instance: lcd_id, and set properties
  set lcd_id [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 lcd_id ]
  set_property -dict [ list \
   CONFIG.C_GPIO_WIDTH {3} \
 ] $lcd_id

  # Create instance: lcd_vout, and set properties
  set lcd_vout [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_axi4s_vid_out:4.0 lcd_vout ]
  set_property -dict [ list \
   CONFIG.C_HAS_ASYNC_CLK {0} \
 ] $lcd_vout

  # Create instance: lcd_vtc, and set properties
  set lcd_vtc [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_tc:6.2 lcd_vtc ]
  set_property -dict [ list \
   CONFIG.enable_detection {false} \
 ] $lcd_vtc

  # Create instance: rgb2lcd_0, and set properties
  set rgb2lcd_0 [ create_bd_cell -type ip -vlnv www.alientek.com:user:rgb2lcd:1.0 rgb2lcd_0 ]

  # Create instance: xlslice_0, and set properties
  set xlslice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_0 ]

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins PWM_AXI] [get_bd_intf_pins PWM_0/PWM_AXI]
  connect_bd_intf_net -intf_net S_AXI_LITE_1 [get_bd_intf_pins S_AXI_LITE] [get_bd_intf_pins lcd_frmbuf_rd/s_axi_CTRL]
  connect_bd_intf_net -intf_net axi_gpio_1_GPIO [get_bd_intf_pins lcd_id/GPIO] [get_bd_intf_pins rgb2lcd_0/lcd_id]
  connect_bd_intf_net -intf_net axi_interconnect_0_M02_AXI1 [get_bd_intf_pins S_AXI] [get_bd_intf_pins lcd_id/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M03_AXI [get_bd_intf_pins ctrl] [get_bd_intf_pins lcd_vtc/ctrl]
  connect_bd_intf_net -intf_net axis_subset_converter_0_M_AXIS [get_bd_intf_pins axis_subset_converter_0/M_AXIS] [get_bd_intf_pins lcd_vout/video_in]
  connect_bd_intf_net -intf_net lcd_frmbuf_rd_m_axis_video [get_bd_intf_pins axis_subset_converter_0/S_AXIS] [get_bd_intf_pins lcd_frmbuf_rd/m_axis_video]
  connect_bd_intf_net -intf_net rgb2lcd_0_lcd [get_bd_intf_pins lcd] [get_bd_intf_pins rgb2lcd_0/lcd]
  connect_bd_intf_net -intf_net rgb2lcd_0_lcd_rgb [get_bd_intf_pins lcd_rgb] [get_bd_intf_pins rgb2lcd_0/lcd_rgb]
  connect_bd_intf_net -intf_net v_axi4s_vid_out_0_vid_io_out [get_bd_intf_pins lcd_vout/vid_io_out] [get_bd_intf_pins rgb2lcd_0/vid_rgb]
  connect_bd_intf_net -intf_net v_frmbuf_rd_0_m_axi_mm_video [get_bd_intf_pins M_AXI_MM2S] [get_bd_intf_pins lcd_frmbuf_rd/m_axi_mm_video]
  connect_bd_intf_net -intf_net v_tc_0_vtiming_out [get_bd_intf_pins lcd_vout/vtiming_in] [get_bd_intf_pins lcd_vtc/vtiming_out]

  # Create port connections
  connect_bd_net -net Din_1 [get_bd_pins Din] [get_bd_pins xlslice_0/Din]
  connect_bd_net -net PWM_0_pwm [get_bd_pins lcd_bl] [get_bd_pins PWM_0/pwm]
  connect_bd_net -net aresetn_1 [get_bd_pins aresetn] [get_bd_pins lcd_rst] [get_bd_pins axis_subset_converter_0/aresetn] [get_bd_pins lcd_vout/aresetn] [get_bd_pins lcd_vtc/resetn]
  connect_bd_net -net clk_wiz_0_clk_out1 [get_bd_pins pixel_clk] [get_bd_pins axis_subset_converter_0/aclk] [get_bd_pins lcd_frmbuf_rd/ap_clk] [get_bd_pins lcd_vout/aclk] [get_bd_pins lcd_vtc/clk] [get_bd_pins rgb2lcd_0/pixel_clk]
  connect_bd_net -net lcd_vtc_irq [get_bd_pins irq] [get_bd_pins lcd_vtc/irq]
  connect_bd_net -net rst_ps8_0_99M_1_peripheral_aresetn [get_bd_pins s_axi_aresetn] [get_bd_pins PWM_0/pwm_axi_aresetn] [get_bd_pins lcd_id/s_axi_aresetn] [get_bd_pins lcd_vtc/s_axi_aresetn]
  connect_bd_net -net v_axi4s_vid_out_0_vtg_ce [get_bd_pins lcd_vout/vtg_ce] [get_bd_pins lcd_vtc/gen_clken]
  connect_bd_net -net v_frmbuf_rd_0_interrupt [get_bd_pins mm2s_introut] [get_bd_pins lcd_frmbuf_rd/interrupt]
  connect_bd_net -net xlslice_0_Dout [get_bd_pins lcd_frmbuf_rd/ap_rst_n] [get_bd_pins xlslice_0/Dout]
  connect_bd_net -net zynq_ultra_ps_e_0_pl_clk0 [get_bd_pins s_axi_aclk] [get_bd_pins PWM_0/pwm_axi_aclk] [get_bd_pins lcd_id/s_axi_aclk] [get_bd_pins lcd_vtc/s_axi_aclk]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: hdmi_out
proc create_hier_cell_hdmi_out { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_hdmi_out() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_MM2S

  create_bd_intf_pin -mode Master -vlnv openedv.com:user:TMDS_rtl:1.0 TMDS

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 ctrl

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi_CTRL


  # Create pins
  create_bd_pin -dir I -from 31 -to 0 Din
  create_bd_pin -dir I -type rst aresetn
  create_bd_pin -dir I -type rst axi_resetn
  create_bd_pin -dir O -type intr irq
  create_bd_pin -dir O -type intr mm2s_introut
  create_bd_pin -dir I -type clk pclk
  create_bd_pin -dir I -type clk pixel_clk_2_5x
  create_bd_pin -dir I -type clk pixel_clk_5x
  create_bd_pin -dir I -type clk s_axi_lite_aclk

  # Create instance: DVI_Transmitter_Safe_0, and set properties
  set DVI_Transmitter_Safe_0 [ create_bd_cell -type ip -vlnv nlos.local:user:DVI_Transmitter_Safe:1.0 DVI_Transmitter_Safe_0 ]

  # Create instance: axis_subset_converter_0, and set properties
  set axis_subset_converter_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_subset_converter:1.1 axis_subset_converter_0 ]
  set_property -dict [ list \
   CONFIG.TDATA_REMAP {tdata[15:8],tdata[7:0],tdata[23:16]} \
   CONFIG.TDEST_REMAP {tdest[0:0]} \
   CONFIG.TID_REMAP {tid[0:0]} \
   CONFIG.TKEEP_REMAP {tkeep[2:0]} \
   CONFIG.TLAST_REMAP {tlast[0]} \
   CONFIG.TSTRB_REMAP {tstrb[2:0]} \
   CONFIG.TUSER_REMAP {tuser[0:0]} \
 ] $axis_subset_converter_0

  # Create instance: frame_reset_sync, and set properties
  set block_name hdmi_frame_reset_sync
  set block_cell_name frame_reset_sync
  if { [catch {set frame_reset_sync [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $frame_reset_sync eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  set_property -dict [ list \
   CONFIG.FREQ_HZ {74165925} \
 ] [get_bd_pins /hdmi_out/frame_reset_sync/clk]

  # Create instance: hdmi_vout, and set properties
  set hdmi_vout [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_axi4s_vid_out:4.0 hdmi_vout ]
  set_property -dict [ list \
   CONFIG.C_ADDR_WIDTH {11} \
   CONFIG.C_HAS_ASYNC_CLK {0} \
 ] $hdmi_vout

  # Create instance: hdmi_vtc, and set properties
  set hdmi_vtc [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_tc:6.2 hdmi_vtc ]
  set_property -dict [ list \
   CONFIG.GEN_F0_VBLANK_HEND {960} \
   CONFIG.GEN_F0_VBLANK_HSTART {960} \
   CONFIG.GEN_F0_VFRAME_SIZE {1125} \
   CONFIG.GEN_F0_VSYNC_HEND {1004} \
   CONFIG.GEN_F0_VSYNC_HSTART {1004} \
   CONFIG.GEN_F0_VSYNC_VEND {1088} \
   CONFIG.GEN_F0_VSYNC_VSTART {1083} \
   CONFIG.GEN_F1_VBLANK_HEND {960} \
   CONFIG.GEN_F1_VBLANK_HSTART {960} \
   CONFIG.GEN_F1_VFRAME_SIZE {1125} \
   CONFIG.GEN_F1_VSYNC_HEND {1004} \
   CONFIG.GEN_F1_VSYNC_HSTART {1004} \
   CONFIG.GEN_F1_VSYNC_VEND {1088} \
   CONFIG.GEN_F1_VSYNC_VSTART {1083} \
   CONFIG.GEN_HACTIVE_SIZE {1920} \
   CONFIG.GEN_HFRAME_SIZE {2200} \
   CONFIG.GEN_HSYNC_END {2052} \
   CONFIG.GEN_HSYNC_START {2008} \
   CONFIG.GEN_VACTIVE_SIZE {1080} \
   CONFIG.HAS_AXI4_LITE {true} \
   CONFIG.VIDEO_MODE {1080p} \
   CONFIG.enable_detection {false} \
 ] $hdmi_vtc

  # Create instance: v_frmbuf_rd_0, and set properties
  set v_frmbuf_rd_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_frmbuf_rd:2.2 v_frmbuf_rd_0 ]
  set_property -dict [ list \
   CONFIG.AXIMM_DATA_WIDTH {64} \
   CONFIG.C_M_AXI_MM_VIDEO_DATA_WIDTH {64} \
   CONFIG.HAS_BGR8 {1} \
   CONFIG.HAS_BGRX8 {0} \
   CONFIG.HAS_RGBX8 {0} \
   CONFIG.HAS_UYVY8 {0} \
   CONFIG.HAS_YUV8 {0} \
   CONFIG.HAS_YUVX8 {0} \
   CONFIG.HAS_YUYV8 {0} \
   CONFIG.HAS_Y_UV8 {0} \
   CONFIG.HAS_Y_UV8_420 {0} \
   CONFIG.MAX_COLS {1920} \
   CONFIG.MAX_NR_PLANES {1} \
   CONFIG.MAX_ROWS {1080} \
   CONFIG.SAMPLES_PER_CLOCK {1} \
 ] $v_frmbuf_rd_0

  # Create instance: xlslice_0, and set properties
  set xlslice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_0 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {1} \
   CONFIG.DIN_TO {1} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_0

  # Create interface connections
  connect_bd_intf_net -intf_net DVI_Transmitter_0_TMDS [get_bd_intf_pins TMDS] [get_bd_intf_pins DVI_Transmitter_Safe_0/TMDS]
  connect_bd_intf_net -intf_net axi_interconnect_0_M06_AXI1 [get_bd_intf_pins ctrl] [get_bd_intf_pins hdmi_vtc/ctrl]
  connect_bd_intf_net -intf_net axis_subset_converter_0_M_AXIS [get_bd_intf_pins axis_subset_converter_0/M_AXIS] [get_bd_intf_pins hdmi_vout/video_in]
  connect_bd_intf_net -intf_net s_axi_CTRL_1 [get_bd_intf_pins s_axi_CTRL] [get_bd_intf_pins v_frmbuf_rd_0/s_axi_CTRL]
  connect_bd_intf_net -intf_net v_axi4s_vid_out_1_vid_io_out [get_bd_intf_pins DVI_Transmitter_Safe_0/Video_In] [get_bd_intf_pins hdmi_vout/vid_io_out]
  connect_bd_intf_net -intf_net v_frmbuf_rd_0_m_axi_mm_video [get_bd_intf_pins M_AXI_MM2S] [get_bd_intf_pins v_frmbuf_rd_0/m_axi_mm_video]
  connect_bd_intf_net -intf_net v_frmbuf_rd_0_m_axis_video [get_bd_intf_pins axis_subset_converter_0/S_AXIS] [get_bd_intf_pins v_frmbuf_rd_0/m_axis_video]
  connect_bd_intf_net -intf_net v_tc_1_vtiming_out [get_bd_intf_pins hdmi_vout/vtiming_in] [get_bd_intf_pins hdmi_vtc/vtiming_out]

  # Create port connections
  connect_bd_net -net Din_1 [get_bd_pins Din] [get_bd_pins xlslice_0/Din]
  connect_bd_net -net aresetn_1 [get_bd_pins aresetn] [get_bd_pins DVI_Transmitter_Safe_0/reset_n] [get_bd_pins axis_subset_converter_0/aresetn] [get_bd_pins frame_reset_sync/global_resetn] [get_bd_pins hdmi_vout/aresetn] [get_bd_pins hdmi_vtc/resetn]
  connect_bd_net -net clk_wiz_0_clk_out2 [get_bd_pins pclk] [get_bd_pins DVI_Transmitter_Safe_0/pclk] [get_bd_pins axis_subset_converter_0/aclk] [get_bd_pins frame_reset_sync/clk] [get_bd_pins hdmi_vout/aclk] [get_bd_pins hdmi_vtc/clk] [get_bd_pins v_frmbuf_rd_0/ap_clk]
  connect_bd_net -net clk_wiz_0_clk_out3 [get_bd_pins pixel_clk_5x] [get_bd_pins DVI_Transmitter_Safe_0/pixel_clk_5x]
  connect_bd_net -net clk_wiz_0_clk_out4 [get_bd_pins pixel_clk_2_5x] [get_bd_pins DVI_Transmitter_Safe_0/pixel_clk_2_5x]
  connect_bd_net -net frame_reset_sync_resetn [get_bd_pins frame_reset_sync/resetn] [get_bd_pins v_frmbuf_rd_0/ap_rst_n]
  connect_bd_net -net hdmi_vtc_irq [get_bd_pins irq] [get_bd_pins hdmi_vtc/irq]
  connect_bd_net -net rst_ps8_0_99M_1_peripheral_aresetn [get_bd_pins axi_resetn] [get_bd_pins hdmi_vtc/s_axi_aresetn]
  connect_bd_net -net v_axi4s_vid_out_1_vtg_ce [get_bd_pins hdmi_vout/vtg_ce] [get_bd_pins hdmi_vtc/gen_clken]
  connect_bd_net -net v_frmbuf_rd_0_interrupt [get_bd_pins mm2s_introut] [get_bd_pins v_frmbuf_rd_0/interrupt]
  connect_bd_net -net xlslice_0_Dout [get_bd_pins frame_reset_sync/software_resetn] [get_bd_pins xlslice_0/Dout]
  connect_bd_net -net zynq_ultra_ps_e_0_pl_clk0 [get_bd_pins s_axi_lite_aclk] [get_bd_pins hdmi_vtc/s_axi_aclk]

  # Restore current instance
  current_bd_instance $oldCurInst
}


# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set C0_SYS_CLK [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 C0_SYS_CLK ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {100000000} \
   ] $C0_SYS_CLK

  set GPIO [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 GPIO ]

  set MDIO [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:mdio_rtl:1.0 MDIO ]

  set RGMII [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:rgmii_rtl:1.0 RGMII ]

  set TMDS [ create_bd_intf_port -mode Master -vlnv openedv.com:user:TMDS_rtl:1.0 TMDS ]

  set UART [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:uart_rtl:1.0 UART ]

  set ddr4 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddr4_rtl:1.0 ddr4 ]

  set lcd [ create_bd_intf_port -mode Master -vlnv xilinx.com:user:lcd_rtl:1.0 lcd ]

  set lcd_rgb [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 lcd_rgb ]

  set lcd_touch_e2p [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 lcd_touch_e2p ]

  set led [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 led ]

  set mipi_hdmi [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 mipi_hdmi ]

  set mipi_phy_if_0 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:mipi_phy_rtl:1.0 mipi_phy_if_0 ]


  # Create ports
  set cam_clk [ create_bd_port -dir O -type clk cam_clk ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {36584999} \
 ] $cam_clk
  set lcd_bl [ create_bd_port -dir O -from 0 -to 0 lcd_bl ]
  set lcd_rst [ create_bd_port -dir O -type rst lcd_rst ]

  # Create instance: axi_gpio_0, and set properties
  set axi_gpio_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_0 ]
  set_property -dict [ list \
   CONFIG.C_ALL_OUTPUTS {1} \
   CONFIG.C_GPIO_WIDTH {2} \
 ] $axi_gpio_0

  # Create instance: axi_interconnect_0, and set properties
  set axi_interconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_0 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {16} \
   CONFIG.NUM_SI {1} \
   CONFIG.STRATEGY {0} \
 ] $axi_interconnect_0

  # Create instance: axi_interconnect_1, and set properties
  set axi_interconnect_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_1 ]
  set_property -dict [ list \
   CONFIG.M00_HAS_REGSLICE {4} \
   CONFIG.NUM_MI {1} \
   CONFIG.NUM_SI {2} \
   CONFIG.S00_HAS_REGSLICE {4} \
   CONFIG.S01_HAS_REGSLICE {4} \
 ] $axi_interconnect_1

  # Create instance: axi_interconnect_2, and set properties
  set axi_interconnect_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_2 ]
  set_property -dict [ list \
   CONFIG.M00_HAS_REGSLICE {4} \
   CONFIG.NUM_MI {1} \
   CONFIG.NUM_SI {2} \
   CONFIG.S00_HAS_REGSLICE {4} \
   CONFIG.S01_HAS_REGSLICE {4} \
 ] $axi_interconnect_2

  # Create instance: axi_interconnect_3, and set properties
  set axi_interconnect_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_3 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {1} \
 ] $axi_interconnect_3

  # Create instance: axi_interconnect_hp0, and set properties
  set axi_interconnect_hp0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_hp0 ]
  set_property -dict [ list \
   CONFIG.M00_HAS_DATA_FIFO {2} \
   CONFIG.M00_HAS_REGSLICE {1} \
   CONFIG.NUM_MI {1} \
   CONFIG.NUM_SI {2} \
   CONFIG.S00_HAS_DATA_FIFO {2} \
   CONFIG.S00_HAS_REGSLICE {1} \
   CONFIG.S01_HAS_DATA_FIFO {2} \
   CONFIG.S01_HAS_REGSLICE {1} \
   CONFIG.S02_HAS_DATA_FIFO {2} \
   CONFIG.STRATEGY {2} \
 ] $axi_interconnect_hp0

  # Create instance: axi_interconnect_hp1, and set properties
  set axi_interconnect_hp1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_hp1 ]
  set_property -dict [ list \
   CONFIG.ENABLE_ADVANCED_OPTIONS {0} \
   CONFIG.M00_HAS_DATA_FIFO {2} \
   CONFIG.M00_HAS_REGSLICE {1} \
   CONFIG.M01_HAS_DATA_FIFO {2} \
   CONFIG.M01_HAS_REGSLICE {1} \
   CONFIG.NUM_MI {1} \
   CONFIG.NUM_SI {1} \
   CONFIG.S00_HAS_DATA_FIFO {2} \
   CONFIG.S00_HAS_REGSLICE {1} \
   CONFIG.S01_HAS_DATA_FIFO {2} \
   CONFIG.S01_HAS_REGSLICE {1} \
   CONFIG.STRATEGY {0} \
 ] $axi_interconnect_hp1

  # Create instance: clk_wiz_0, and set properties
  set clk_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz_0 ]
  set_property -dict [ list \
   CONFIG.AXI_DRP {false} \
   CONFIG.CLKOUT1_DRIVES {Buffer} \
   CONFIG.CLKOUT1_JITTER {147.939} \
   CONFIG.CLKOUT1_PHASE_ERROR {154.789} \
   CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {33.3333} \
   CONFIG.CLKOUT2_DRIVES {Buffer} \
   CONFIG.CLKOUT2_JITTER {119.402} \
   CONFIG.CLKOUT2_PHASE_ERROR {154.789} \
   CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {148.5} \
   CONFIG.CLKOUT2_USED {true} \
   CONFIG.CLKOUT3_DRIVES {Buffer} \
   CONFIG.CLKOUT3_JITTER {95.484} \
   CONFIG.CLKOUT3_MATCHED_ROUTING {false} \
   CONFIG.CLKOUT3_PHASE_ERROR {154.789} \
   CONFIG.CLKOUT3_REQUESTED_OUT_FREQ {742.5} \
   CONFIG.CLKOUT3_USED {true} \
   CONFIG.CLKOUT4_DRIVES {No_buffer} \
   CONFIG.CLKOUT4_JITTER {105.011} \
   CONFIG.CLKOUT4_PHASE_ERROR {154.789} \
   CONFIG.CLKOUT4_REQUESTED_OUT_FREQ {371.25} \
   CONFIG.CLKOUT4_USED {true} \
   CONFIG.CLKOUT5_DRIVES {Buffer} \
   CONFIG.CLKOUT5_JITTER {155.256} \
   CONFIG.CLKOUT5_PHASE_ERROR {154.789} \
   CONFIG.CLKOUT5_REQUESTED_OUT_FREQ {100.000} \
   CONFIG.CLKOUT5_USED {false} \
   CONFIG.CLKOUT6_DRIVES {Buffer} \
   CONFIG.CLKOUT7_DRIVES {Buffer} \
   CONFIG.FEEDBACK_SOURCE {FDBK_AUTO} \
   CONFIG.MMCM_BANDWIDTH {OPTIMIZED} \
   CONFIG.MMCM_CLKFBOUT_MULT_F {44.500} \
   CONFIG.MMCM_CLKOUT0_DIVIDE_F {44.500} \
   CONFIG.MMCM_CLKOUT1_DIVIDE {10} \
   CONFIG.MMCM_CLKOUT2_DIVIDE {2} \
   CONFIG.MMCM_CLKOUT3_DIVIDE {4} \
   CONFIG.MMCM_CLKOUT4_DIVIDE {1} \
   CONFIG.MMCM_COMPENSATION {AUTO} \
   CONFIG.MMCM_DIVCLK_DIVIDE {3} \
   CONFIG.NUM_OUT_CLKS {4} \
   CONFIG.PHASE_DUTY_CONFIG {false} \
   CONFIG.PRIMITIVE {Auto} \
   CONFIG.USE_DYN_RECONFIG {true} \
   CONFIG.USE_LOCKED {true} \
   CONFIG.USE_RESET {true} \
 ] $clk_wiz_0

  # Create instance: clk_wiz_1, and set properties
  set clk_wiz_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz_1 ]
  set_property -dict [ list \
   CONFIG.CLKOUT1_JITTER {144.572} \
   CONFIG.CLKOUT1_PHASE_ERROR {87.181} \
   CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {33.333} \
   CONFIG.CLKOUT2_JITTER {155.489} \
   CONFIG.CLKOUT2_PHASE_ERROR {87.181} \
   CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {100.000} \
   CONFIG.CLKOUT2_USED {false} \
   CONFIG.MMCM_CLKFBOUT_MULT_F {12.000} \
   CONFIG.MMCM_CLKOUT0_DIVIDE_F {36.000} \
   CONFIG.MMCM_CLKOUT1_DIVIDE {1} \
   CONFIG.MMCM_DIVCLK_DIVIDE {1} \
   CONFIG.NUM_OUT_CLKS {1} \
   CONFIG.RESET_PORT {resetn} \
   CONFIG.RESET_TYPE {ACTIVE_LOW} \
   CONFIG.USE_LOCKED {false} \
 ] $clk_wiz_1

  # Create instance: ddr4_0, and set properties
  set ddr4_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:ddr4:2.2 ddr4_0 ]
  set_property -dict [ list \
   CONFIG.ADDN_UI_CLKOUT1_FREQ_HZ {200} \
   CONFIG.C0.BANK_GROUP_WIDTH {1} \
   CONFIG.C0.DDR4_AxiAddressWidth {29} \
   CONFIG.C0.DDR4_AxiDataWidth {128} \
   CONFIG.C0.DDR4_CLKFBOUT_MULT {16} \
   CONFIG.C0.DDR4_CLKOUT0_DIVIDE {6} \
   CONFIG.C0.DDR4_CasLatency {15} \
   CONFIG.C0.DDR4_CasWriteLatency {11} \
   CONFIG.C0.DDR4_DataWidth {16} \
   CONFIG.C0.DDR4_InputClockPeriod {10006} \
   CONFIG.C0.DDR4_MemoryPart {MT40A256M16GE-083E} \
   CONFIG.C0.DDR4_Specify_MandD {true} \
   CONFIG.C0.DDR4_TimePeriod {938} \
 ] $ddr4_0

  # Create instance: hdmi_out
  create_hier_cell_hdmi_out [current_bd_instance .] hdmi_out

  # Create instance: hdmi_pixel_reset, and set properties
  set hdmi_pixel_reset [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 hdmi_pixel_reset ]

  # Create instance: hdmi_reset_zero, and set properties
  set hdmi_reset_zero [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 hdmi_reset_zero ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
 ] $hdmi_reset_zero

  # Create instance: hdmi_shared, and set properties
  set block_name hdmi_clock_shared
  set block_cell_name hdmi_shared
  if { [catch {set hdmi_shared [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $hdmi_shared eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  set_property -dict [ list \
   CONFIG.FREQ_HZ {370829625} \
 ] [get_bd_pins /hdmi_shared/fast_clock]

  set_property -dict [ list \
   CONFIG.FREQ_HZ {74165925} \
 ] [get_bd_pins /hdmi_shared/pixel_clock]

  set_property -dict [ list \
   CONFIG.FREQ_HZ {370829625} \
 ] [get_bd_pins /hdmi_shared/raw_clock]

  set_property -dict [ list \
   CONFIG.FREQ_HZ {185414813} \
 ] [get_bd_pins /hdmi_shared/slow_clock]

  # Create instance: lcd_out
  create_hier_cell_lcd_out [current_bd_instance .] lcd_out

  # Create instance: mipi_csi2_rx
  create_hier_cell_mipi_csi2_rx [current_bd_instance .] mipi_csi2_rx

  # Create instance: nlos_compute, and set properties
  set block_name nlos_axi_lite_board_bd
  set block_cell_name nlos_compute
  if { [catch {set nlos_compute [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $nlos_compute eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: nlos_link, and set properties
  set nlos_link [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 nlos_link ]
  set_property -dict [ list \
   CONFIG.ADVANCED_PROPERTIES {__experimental_features__ {disable_low_area_mode 1}} \
   CONFIG.NUM_MI {2} \
   CONFIG.NUM_SI {1} \
 ] $nlos_link

  # Create instance: nlos_one, and set properties
  set nlos_one [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 nlos_one ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {1} \
   CONFIG.CONST_WIDTH {1} \
 ] $nlos_one

  # Create instance: nlos_reset, and set properties
  set nlos_reset [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 nlos_reset ]
  set_property -dict [ list \
   CONFIG.C_AUX_RESET_HIGH {0} \
 ] $nlos_reset

  # Create instance: nlos_zero, and set properties
  set nlos_zero [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 nlos_zero ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {1} \
 ] $nlos_zero

  # Create instance: rest_gpio, and set properties
  set rest_gpio [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 rest_gpio ]
  set_property -dict [ list \
   CONFIG.C_ALL_OUTPUTS {1} \
   CONFIG.C_DOUT_DEFAULT {0xFFFFFFFF} \
 ] $rest_gpio

  # Create instance: rst_hier
  create_hier_cell_rst_hier [current_bd_instance .] rst_hier

  # Create instance: vcu_0, and set properties
  set vcu_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:vcu:1.2 vcu_0 ]
  set_property -dict [ list \
   CONFIG.DEC_COLOR_DEPTH {0} \
   CONFIG.ENC_BUFFER_B_FRAME {1} \
   CONFIG.ENC_BUFFER_EN {true} \
   CONFIG.ENC_BUFFER_MOTION_VEC_RANGE {1} \
   CONFIG.ENC_BUFFER_SIZE {1285} \
   CONFIG.ENC_BUFFER_SIZE_ACTUAL {1445} \
   CONFIG.ENC_BUFFER_TYPE {0} \
   CONFIG.ENC_CODING_TYPE {1} \
   CONFIG.ENC_COLOR_DEPTH {0} \
   CONFIG.ENC_COLOR_FORMAT {0} \
   CONFIG.ENC_MEM_URAM_USED {1445} \
   CONFIG.TABLE_NO {2} \
 ] $vcu_0

  # Create instance: vendor_gmii, and set properties
  set vendor_gmii [ create_bd_cell -type ip -vlnv xilinx.com:ip:gmii_to_rgmii:4.1 vendor_gmii ]
  set_property -dict [ list \
   CONFIG.C_EXTERNAL_CLOCK {false} \
   CONFIG.C_PHYADDR {0} \
   CONFIG.C_USE_IDELAY_CTRL {true} \
   CONFIG.RGMII_TXC_SKEW {2} \
   CONFIG.SupportLevel {Include_Shared_Logic_in_Core} \
 ] $vendor_gmii

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {6} \
 ] $xlconcat_0

  # Create instance: xlconcat_1, and set properties
  set xlconcat_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_1 ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {1} \
 ] $xlconcat_1

  # Create instance: xlslice_0, and set properties
  set xlslice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_0 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {11} \
   CONFIG.DIN_TO {11} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_0

  # Create instance: zynq_ultra_ps_e_0, and set properties
  set zynq_ultra_ps_e_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:zynq_ultra_ps_e:3.3 zynq_ultra_ps_e_0 ]
  set_property -dict [ list \
   CONFIG.CAN0_BOARD_INTERFACE {custom} \
   CONFIG.CAN1_BOARD_INTERFACE {custom} \
   CONFIG.CSU_BOARD_INTERFACE {custom} \
   CONFIG.DP_BOARD_INTERFACE {custom} \
   CONFIG.GEM0_BOARD_INTERFACE {custom} \
   CONFIG.GEM1_BOARD_INTERFACE {custom} \
   CONFIG.GEM2_BOARD_INTERFACE {custom} \
   CONFIG.GEM3_BOARD_INTERFACE {custom} \
   CONFIG.GPIO_BOARD_INTERFACE {custom} \
   CONFIG.IIC0_BOARD_INTERFACE {custom} \
   CONFIG.IIC1_BOARD_INTERFACE {custom} \
   CONFIG.NAND_BOARD_INTERFACE {custom} \
   CONFIG.PCIE_BOARD_INTERFACE {custom} \
   CONFIG.PJTAG_BOARD_INTERFACE {custom} \
   CONFIG.PMU_BOARD_INTERFACE {custom} \
   CONFIG.PSU_BANK_0_IO_STANDARD {LVCMOS18} \
   CONFIG.PSU_BANK_1_IO_STANDARD {LVCMOS33} \
   CONFIG.PSU_BANK_2_IO_STANDARD {LVCMOS18} \
   CONFIG.PSU_BANK_3_IO_STANDARD {LVCMOS33} \
   CONFIG.PSU_DDR_RAM_HIGHADDR {0x7FFFFFFF} \
   CONFIG.PSU_DDR_RAM_HIGHADDR_OFFSET {0x00000002} \
   CONFIG.PSU_DDR_RAM_LOWADDR_OFFSET {0x80000000} \
   CONFIG.PSU_DYNAMIC_DDR_CONFIG_EN {0} \
   CONFIG.PSU_IMPORT_BOARD_PRESET {} \
   CONFIG.PSU_MIO_0_DIRECTION {out} \
   CONFIG.PSU_MIO_0_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_0_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_0_POLARITY {Default} \
   CONFIG.PSU_MIO_0_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_0_SLEW {fast} \
   CONFIG.PSU_MIO_10_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_10_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_10_POLARITY {Default} \
   CONFIG.PSU_MIO_10_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_10_SLEW {fast} \
   CONFIG.PSU_MIO_11_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_11_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_11_POLARITY {Default} \
   CONFIG.PSU_MIO_11_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_11_SLEW {fast} \
   CONFIG.PSU_MIO_12_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_12_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_12_POLARITY {Default} \
   CONFIG.PSU_MIO_12_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_12_SLEW {fast} \
   CONFIG.PSU_MIO_13_DIRECTION {inout} \
   CONFIG.PSU_MIO_13_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_13_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_13_POLARITY {Default} \
   CONFIG.PSU_MIO_13_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_13_SLEW {fast} \
   CONFIG.PSU_MIO_14_DIRECTION {inout} \
   CONFIG.PSU_MIO_14_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_14_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_14_POLARITY {Default} \
   CONFIG.PSU_MIO_14_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_14_SLEW {fast} \
   CONFIG.PSU_MIO_15_DIRECTION {inout} \
   CONFIG.PSU_MIO_15_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_15_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_15_POLARITY {Default} \
   CONFIG.PSU_MIO_15_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_15_SLEW {fast} \
   CONFIG.PSU_MIO_16_DIRECTION {inout} \
   CONFIG.PSU_MIO_16_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_16_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_16_POLARITY {Default} \
   CONFIG.PSU_MIO_16_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_16_SLEW {fast} \
   CONFIG.PSU_MIO_17_DIRECTION {inout} \
   CONFIG.PSU_MIO_17_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_17_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_17_POLARITY {Default} \
   CONFIG.PSU_MIO_17_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_17_SLEW {fast} \
   CONFIG.PSU_MIO_18_DIRECTION {inout} \
   CONFIG.PSU_MIO_18_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_18_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_18_POLARITY {Default} \
   CONFIG.PSU_MIO_18_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_18_SLEW {fast} \
   CONFIG.PSU_MIO_19_DIRECTION {inout} \
   CONFIG.PSU_MIO_19_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_19_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_19_POLARITY {Default} \
   CONFIG.PSU_MIO_19_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_19_SLEW {fast} \
   CONFIG.PSU_MIO_1_DIRECTION {inout} \
   CONFIG.PSU_MIO_1_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_1_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_1_POLARITY {Default} \
   CONFIG.PSU_MIO_1_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_1_SLEW {fast} \
   CONFIG.PSU_MIO_20_DIRECTION {inout} \
   CONFIG.PSU_MIO_20_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_20_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_20_POLARITY {Default} \
   CONFIG.PSU_MIO_20_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_20_SLEW {fast} \
   CONFIG.PSU_MIO_21_DIRECTION {inout} \
   CONFIG.PSU_MIO_21_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_21_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_21_POLARITY {Default} \
   CONFIG.PSU_MIO_21_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_21_SLEW {fast} \
   CONFIG.PSU_MIO_22_DIRECTION {out} \
   CONFIG.PSU_MIO_22_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_22_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_22_POLARITY {Default} \
   CONFIG.PSU_MIO_22_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_22_SLEW {fast} \
   CONFIG.PSU_MIO_23_DIRECTION {out} \
   CONFIG.PSU_MIO_23_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_23_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_23_POLARITY {Default} \
   CONFIG.PSU_MIO_23_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_23_SLEW {fast} \
   CONFIG.PSU_MIO_24_DIRECTION {out} \
   CONFIG.PSU_MIO_24_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_24_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_24_POLARITY {Default} \
   CONFIG.PSU_MIO_24_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_24_SLEW {fast} \
   CONFIG.PSU_MIO_25_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_25_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_25_POLARITY {Default} \
   CONFIG.PSU_MIO_25_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_25_SLEW {fast} \
   CONFIG.PSU_MIO_26_DIRECTION {inout} \
   CONFIG.PSU_MIO_26_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_26_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_26_POLARITY {Default} \
   CONFIG.PSU_MIO_26_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_26_SLEW {fast} \
   CONFIG.PSU_MIO_27_DIRECTION {out} \
   CONFIG.PSU_MIO_27_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_27_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_27_POLARITY {Default} \
   CONFIG.PSU_MIO_27_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_27_SLEW {fast} \
   CONFIG.PSU_MIO_28_DIRECTION {in} \
   CONFIG.PSU_MIO_28_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_28_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_28_POLARITY {Default} \
   CONFIG.PSU_MIO_28_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_28_SLEW {fast} \
   CONFIG.PSU_MIO_29_DIRECTION {out} \
   CONFIG.PSU_MIO_29_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_29_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_29_POLARITY {Default} \
   CONFIG.PSU_MIO_29_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_29_SLEW {fast} \
   CONFIG.PSU_MIO_2_DIRECTION {inout} \
   CONFIG.PSU_MIO_2_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_2_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_2_POLARITY {Default} \
   CONFIG.PSU_MIO_2_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_2_SLEW {fast} \
   CONFIG.PSU_MIO_30_DIRECTION {in} \
   CONFIG.PSU_MIO_30_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_30_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_30_POLARITY {Default} \
   CONFIG.PSU_MIO_30_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_30_SLEW {fast} \
   CONFIG.PSU_MIO_31_DIRECTION {inout} \
   CONFIG.PSU_MIO_31_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_31_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_31_POLARITY {Default} \
   CONFIG.PSU_MIO_31_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_31_SLEW {fast} \
   CONFIG.PSU_MIO_32_DIRECTION {inout} \
   CONFIG.PSU_MIO_32_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_32_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_32_POLARITY {Default} \
   CONFIG.PSU_MIO_32_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_32_SLEW {fast} \
   CONFIG.PSU_MIO_33_DIRECTION {inout} \
   CONFIG.PSU_MIO_33_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_33_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_33_POLARITY {Default} \
   CONFIG.PSU_MIO_33_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_33_SLEW {fast} \
   CONFIG.PSU_MIO_34_DIRECTION {inout} \
   CONFIG.PSU_MIO_34_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_34_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_34_POLARITY {Default} \
   CONFIG.PSU_MIO_34_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_34_SLEW {fast} \
   CONFIG.PSU_MIO_35_DIRECTION {inout} \
   CONFIG.PSU_MIO_35_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_35_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_35_POLARITY {Default} \
   CONFIG.PSU_MIO_35_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_35_SLEW {fast} \
   CONFIG.PSU_MIO_36_DIRECTION {inout} \
   CONFIG.PSU_MIO_36_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_36_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_36_POLARITY {Default} \
   CONFIG.PSU_MIO_36_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_36_SLEW {fast} \
   CONFIG.PSU_MIO_37_DIRECTION {out} \
   CONFIG.PSU_MIO_37_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_37_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_37_POLARITY {Default} \
   CONFIG.PSU_MIO_37_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_37_SLEW {fast} \
   CONFIG.PSU_MIO_38_DIRECTION {inout} \
   CONFIG.PSU_MIO_38_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_38_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_38_POLARITY {Default} \
   CONFIG.PSU_MIO_38_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_38_SLEW {fast} \
   CONFIG.PSU_MIO_39_DIRECTION {inout} \
   CONFIG.PSU_MIO_39_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_39_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_39_POLARITY {Default} \
   CONFIG.PSU_MIO_39_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_39_SLEW {fast} \
   CONFIG.PSU_MIO_3_DIRECTION {inout} \
   CONFIG.PSU_MIO_3_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_3_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_3_POLARITY {Default} \
   CONFIG.PSU_MIO_3_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_3_SLEW {fast} \
   CONFIG.PSU_MIO_40_DIRECTION {inout} \
   CONFIG.PSU_MIO_40_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_40_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_40_POLARITY {Default} \
   CONFIG.PSU_MIO_40_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_40_SLEW {fast} \
   CONFIG.PSU_MIO_41_DIRECTION {inout} \
   CONFIG.PSU_MIO_41_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_41_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_41_POLARITY {Default} \
   CONFIG.PSU_MIO_41_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_41_SLEW {fast} \
   CONFIG.PSU_MIO_42_DIRECTION {in} \
   CONFIG.PSU_MIO_42_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_42_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_42_POLARITY {Default} \
   CONFIG.PSU_MIO_42_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_42_SLEW {fast} \
   CONFIG.PSU_MIO_43_DIRECTION {out} \
   CONFIG.PSU_MIO_43_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_43_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_43_POLARITY {Default} \
   CONFIG.PSU_MIO_43_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_43_SLEW {fast} \
   CONFIG.PSU_MIO_44_DIRECTION {inout} \
   CONFIG.PSU_MIO_44_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_44_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_44_POLARITY {Default} \
   CONFIG.PSU_MIO_44_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_44_SLEW {fast} \
   CONFIG.PSU_MIO_45_DIRECTION {in} \
   CONFIG.PSU_MIO_45_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_45_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_45_POLARITY {Default} \
   CONFIG.PSU_MIO_45_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_45_SLEW {fast} \
   CONFIG.PSU_MIO_46_DIRECTION {inout} \
   CONFIG.PSU_MIO_46_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_46_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_46_POLARITY {Default} \
   CONFIG.PSU_MIO_46_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_46_SLEW {fast} \
   CONFIG.PSU_MIO_47_DIRECTION {inout} \
   CONFIG.PSU_MIO_47_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_47_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_47_POLARITY {Default} \
   CONFIG.PSU_MIO_47_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_47_SLEW {fast} \
   CONFIG.PSU_MIO_48_DIRECTION {inout} \
   CONFIG.PSU_MIO_48_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_48_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_48_POLARITY {Default} \
   CONFIG.PSU_MIO_48_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_48_SLEW {fast} \
   CONFIG.PSU_MIO_49_DIRECTION {inout} \
   CONFIG.PSU_MIO_49_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_49_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_49_POLARITY {Default} \
   CONFIG.PSU_MIO_49_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_49_SLEW {fast} \
   CONFIG.PSU_MIO_4_DIRECTION {inout} \
   CONFIG.PSU_MIO_4_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_4_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_4_POLARITY {Default} \
   CONFIG.PSU_MIO_4_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_4_SLEW {fast} \
   CONFIG.PSU_MIO_50_DIRECTION {inout} \
   CONFIG.PSU_MIO_50_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_50_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_50_POLARITY {Default} \
   CONFIG.PSU_MIO_50_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_50_SLEW {fast} \
   CONFIG.PSU_MIO_51_DIRECTION {out} \
   CONFIG.PSU_MIO_51_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_51_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_51_POLARITY {Default} \
   CONFIG.PSU_MIO_51_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_51_SLEW {fast} \
   CONFIG.PSU_MIO_52_DIRECTION {in} \
   CONFIG.PSU_MIO_52_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_52_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_52_POLARITY {Default} \
   CONFIG.PSU_MIO_52_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_52_SLEW {fast} \
   CONFIG.PSU_MIO_53_DIRECTION {in} \
   CONFIG.PSU_MIO_53_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_53_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_53_POLARITY {Default} \
   CONFIG.PSU_MIO_53_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_53_SLEW {fast} \
   CONFIG.PSU_MIO_54_DIRECTION {inout} \
   CONFIG.PSU_MIO_54_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_54_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_54_POLARITY {Default} \
   CONFIG.PSU_MIO_54_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_54_SLEW {fast} \
   CONFIG.PSU_MIO_55_DIRECTION {in} \
   CONFIG.PSU_MIO_55_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_55_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_55_POLARITY {Default} \
   CONFIG.PSU_MIO_55_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_55_SLEW {fast} \
   CONFIG.PSU_MIO_56_DIRECTION {inout} \
   CONFIG.PSU_MIO_56_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_56_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_56_POLARITY {Default} \
   CONFIG.PSU_MIO_56_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_56_SLEW {fast} \
   CONFIG.PSU_MIO_57_DIRECTION {inout} \
   CONFIG.PSU_MIO_57_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_57_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_57_POLARITY {Default} \
   CONFIG.PSU_MIO_57_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_57_SLEW {fast} \
   CONFIG.PSU_MIO_58_DIRECTION {out} \
   CONFIG.PSU_MIO_58_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_58_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_58_POLARITY {Default} \
   CONFIG.PSU_MIO_58_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_58_SLEW {fast} \
   CONFIG.PSU_MIO_59_DIRECTION {inout} \
   CONFIG.PSU_MIO_59_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_59_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_59_POLARITY {Default} \
   CONFIG.PSU_MIO_59_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_59_SLEW {fast} \
   CONFIG.PSU_MIO_5_DIRECTION {out} \
   CONFIG.PSU_MIO_5_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_5_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_5_POLARITY {Default} \
   CONFIG.PSU_MIO_5_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_5_SLEW {fast} \
   CONFIG.PSU_MIO_60_DIRECTION {inout} \
   CONFIG.PSU_MIO_60_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_60_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_60_POLARITY {Default} \
   CONFIG.PSU_MIO_60_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_60_SLEW {fast} \
   CONFIG.PSU_MIO_61_DIRECTION {inout} \
   CONFIG.PSU_MIO_61_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_61_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_61_POLARITY {Default} \
   CONFIG.PSU_MIO_61_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_61_SLEW {fast} \
   CONFIG.PSU_MIO_62_DIRECTION {inout} \
   CONFIG.PSU_MIO_62_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_62_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_62_POLARITY {Default} \
   CONFIG.PSU_MIO_62_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_62_SLEW {fast} \
   CONFIG.PSU_MIO_63_DIRECTION {inout} \
   CONFIG.PSU_MIO_63_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_63_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_63_POLARITY {Default} \
   CONFIG.PSU_MIO_63_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_63_SLEW {fast} \
   CONFIG.PSU_MIO_64_DIRECTION {out} \
   CONFIG.PSU_MIO_64_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_64_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_64_POLARITY {Default} \
   CONFIG.PSU_MIO_64_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_64_SLEW {fast} \
   CONFIG.PSU_MIO_65_DIRECTION {out} \
   CONFIG.PSU_MIO_65_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_65_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_65_POLARITY {Default} \
   CONFIG.PSU_MIO_65_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_65_SLEW {fast} \
   CONFIG.PSU_MIO_66_DIRECTION {out} \
   CONFIG.PSU_MIO_66_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_66_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_66_POLARITY {Default} \
   CONFIG.PSU_MIO_66_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_66_SLEW {fast} \
   CONFIG.PSU_MIO_67_DIRECTION {out} \
   CONFIG.PSU_MIO_67_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_67_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_67_POLARITY {Default} \
   CONFIG.PSU_MIO_67_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_67_SLEW {fast} \
   CONFIG.PSU_MIO_68_DIRECTION {out} \
   CONFIG.PSU_MIO_68_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_68_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_68_POLARITY {Default} \
   CONFIG.PSU_MIO_68_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_68_SLEW {fast} \
   CONFIG.PSU_MIO_69_DIRECTION {out} \
   CONFIG.PSU_MIO_69_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_69_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_69_POLARITY {Default} \
   CONFIG.PSU_MIO_69_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_69_SLEW {fast} \
   CONFIG.PSU_MIO_6_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_6_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_6_POLARITY {Default} \
   CONFIG.PSU_MIO_6_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_6_SLEW {fast} \
   CONFIG.PSU_MIO_70_DIRECTION {in} \
   CONFIG.PSU_MIO_70_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_70_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_70_POLARITY {Default} \
   CONFIG.PSU_MIO_70_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_70_SLEW {fast} \
   CONFIG.PSU_MIO_71_DIRECTION {in} \
   CONFIG.PSU_MIO_71_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_71_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_71_POLARITY {Default} \
   CONFIG.PSU_MIO_71_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_71_SLEW {fast} \
   CONFIG.PSU_MIO_72_DIRECTION {in} \
   CONFIG.PSU_MIO_72_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_72_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_72_POLARITY {Default} \
   CONFIG.PSU_MIO_72_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_72_SLEW {fast} \
   CONFIG.PSU_MIO_73_DIRECTION {in} \
   CONFIG.PSU_MIO_73_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_73_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_73_POLARITY {Default} \
   CONFIG.PSU_MIO_73_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_73_SLEW {fast} \
   CONFIG.PSU_MIO_74_DIRECTION {in} \
   CONFIG.PSU_MIO_74_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_74_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_74_POLARITY {Default} \
   CONFIG.PSU_MIO_74_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_74_SLEW {fast} \
   CONFIG.PSU_MIO_75_DIRECTION {in} \
   CONFIG.PSU_MIO_75_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_75_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_75_POLARITY {Default} \
   CONFIG.PSU_MIO_75_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_75_SLEW {fast} \
   CONFIG.PSU_MIO_76_DIRECTION {out} \
   CONFIG.PSU_MIO_76_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_76_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_76_POLARITY {Default} \
   CONFIG.PSU_MIO_76_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_76_SLEW {fast} \
   CONFIG.PSU_MIO_77_DIRECTION {inout} \
   CONFIG.PSU_MIO_77_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_77_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_77_POLARITY {Default} \
   CONFIG.PSU_MIO_77_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_77_SLEW {fast} \
   CONFIG.PSU_MIO_7_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_7_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_7_POLARITY {Default} \
   CONFIG.PSU_MIO_7_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_7_SLEW {fast} \
   CONFIG.PSU_MIO_8_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_8_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_8_POLARITY {Default} \
   CONFIG.PSU_MIO_8_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_8_SLEW {fast} \
   CONFIG.PSU_MIO_9_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_9_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_9_POLARITY {Default} \
   CONFIG.PSU_MIO_9_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_9_SLEW {fast} \
   CONFIG.PSU_MIO_TREE_PERIPHERALS { \
     0#SD 0#USB0 \
     0#SD 0#USB0 \
     0#SD 0#USB0 \
     0#SD 0#USB0 \
     0#SD 0#USB0 \
     0#UART 0#GPIO1 \
     0#USB 0#Gem \
     0#USB 0#Gem \
     0#USB 0#Gem \
     0#USB 0#Gem \
     0#USB 0#Gem \
     0#USB 0#Gem \
     1#SD 1#USB \
     1#SD 1#USB \
     1#SD 1#USB \
     3#Gem 3#MDIO \
     3#Gem 3#MDIO \
     3#Gem 3#MDIO \
     3#Gem 3#MDIO \
     3#Gem 3#MDIO \
     3#Gem 3#MDIO \
     3#MDIO 3 \
     Flash########SD 0#SD \
     Flash#Quad SPI \
     Flash#Quad SPI \
     Flash#Quad SPI \
     Flash#Quad SPI \
     Flash#Quad SPI \
     MIO#GPIO1 MIO#UART \
     MIO#GPIO1 MIO#UART \
     MIO#GPIO1 MIO#UART \
     MIO#GPIO1 MIO#UART \
     MIO#GPIO1 MIO#UART \
     MIO#SD 1#SD \
     Quad SPI \
     Reset##GPIO1 MIO#DPAUX#DPAUX#DPAUX#DPAUX#GPIO1 \
   } \
   CONFIG.PSU_MIO_TREE_SIGNALS {sclk_out#miso_mo1#mo2#mo3#mosi_mi0#n_ss_out########sdio0_data_out[0]#sdio0_data_out[1]#sdio0_data_out[2]#sdio0_data_out[3]#sdio0_data_out[4]#sdio0_data_out[5]#sdio0_data_out[6]#sdio0_data_out[7]#sdio0_cmd_out#sdio0_clk_out#sdio0_bus_pow#reset##gpio1[26]#dp_aux_data_out#dp_hot_plug_detect#dp_aux_data_oe#dp_aux_data_in#gpio1[31]#gpio1[32]#gpio1[33]#gpio1[34]#gpio1[35]#gpio1[36]#reset_n#gpio1[38]#gpio1[39]#gpio1[40]#gpio1[41]#rxd#txd#gpio1[44]#sdio1_cd_n#sdio1_data_out[0]#sdio1_data_out[1]#sdio1_data_out[2]#sdio1_data_out[3]#sdio1_cmd_out#sdio1_clk_out#ulpi_clk_in#ulpi_dir#ulpi_tx_data[2]#ulpi_nxt#ulpi_tx_data[0]#ulpi_tx_data[1]#ulpi_stp#ulpi_tx_data[3]#ulpi_tx_data[4]#ulpi_tx_data[5]#ulpi_tx_data[6]#ulpi_tx_data[7]#rgmii_tx_clk#rgmii_txd[0]#rgmii_txd[1]#rgmii_txd[2]#rgmii_txd[3]#rgmii_tx_ctl#rgmii_rx_clk#rgmii_rxd[0]#rgmii_rxd[1]#rgmii_rxd[2]#rgmii_rxd[3]#rgmii_rx_ctl#gem3_mdc#gem3_mdio_out} \
   CONFIG.PSU_PERIPHERAL_BOARD_PRESET {} \
   CONFIG.PSU_SD0_INTERNAL_BUS_WIDTH {8} \
   CONFIG.PSU_SD1_INTERNAL_BUS_WIDTH {4} \
   CONFIG.PSU_SMC_CYCLE_T0 {NA} \
   CONFIG.PSU_SMC_CYCLE_T1 {NA} \
   CONFIG.PSU_SMC_CYCLE_T2 {NA} \
   CONFIG.PSU_SMC_CYCLE_T3 {NA} \
   CONFIG.PSU_SMC_CYCLE_T4 {NA} \
   CONFIG.PSU_SMC_CYCLE_T5 {NA} \
   CONFIG.PSU_SMC_CYCLE_T6 {NA} \
   CONFIG.PSU_USB3__DUAL_CLOCK_ENABLE {1} \
   CONFIG.PSU_VALUE_SILVERSION {3} \
   CONFIG.PSU__ACPU0__POWER__ON {1} \
   CONFIG.PSU__ACPU1__POWER__ON {1} \
   CONFIG.PSU__ACPU2__POWER__ON {1} \
   CONFIG.PSU__ACPU3__POWER__ON {1} \
   CONFIG.PSU__ACTUAL__IP {1} \
   CONFIG.PSU__ACT_DDR_FREQ_MHZ {1199.988037} \
   CONFIG.PSU__AFI0_COHERENCY {0} \
   CONFIG.PSU__AFI1_COHERENCY {0} \
   CONFIG.PSU__AUX_REF_CLK__FREQMHZ {33.333} \
   CONFIG.PSU__CAN0_LOOP_CAN1__ENABLE {0} \
   CONFIG.PSU__CAN0__GRP_CLK__ENABLE {0} \
   CONFIG.PSU__CAN0__PERIPHERAL__ENABLE {0} \
   CONFIG.PSU__CAN1__GRP_CLK__ENABLE {0} \
   CONFIG.PSU__CAN1__PERIPHERAL__ENABLE {0} \
   CONFIG.PSU__CRF_APB__ACPU_CTRL__ACT_FREQMHZ {1199.988037} \
   CONFIG.PSU__CRF_APB__ACPU_CTRL__DIVISOR0 {1} \
   CONFIG.PSU__CRF_APB__ACPU_CTRL__FREQMHZ {1200} \
   CONFIG.PSU__CRF_APB__ACPU_CTRL__SRCSEL {APLL} \
   CONFIG.PSU__CRF_APB__ACPU__FRAC_ENABLED {0} \
   CONFIG.PSU__CRF_APB__AFI0_REF_CTRL__ACT_FREQMHZ {667} \
   CONFIG.PSU__CRF_APB__AFI0_REF_CTRL__DIVISOR0 {2} \
   CONFIG.PSU__CRF_APB__AFI0_REF_CTRL__FREQMHZ {667} \
   CONFIG.PSU__CRF_APB__AFI0_REF_CTRL__SRCSEL {DPLL} \
   CONFIG.PSU__CRF_APB__AFI0_REF__ENABLE {0} \
   CONFIG.PSU__CRF_APB__AFI1_REF_CTRL__ACT_FREQMHZ {667} \
   CONFIG.PSU__CRF_APB__AFI1_REF_CTRL__DIVISOR0 {2} \
   CONFIG.PSU__CRF_APB__AFI1_REF_CTRL__FREQMHZ {667} \
   CONFIG.PSU__CRF_APB__AFI1_REF_CTRL__SRCSEL {DPLL} \
   CONFIG.PSU__CRF_APB__AFI1_REF__ENABLE {0} \
   CONFIG.PSU__CRF_APB__AFI2_REF_CTRL__ACT_FREQMHZ {667} \
   CONFIG.PSU__CRF_APB__AFI2_REF_CTRL__DIVISOR0 {2} \
   CONFIG.PSU__CRF_APB__AFI2_REF_CTRL__FREQMHZ {667} \
   CONFIG.PSU__CRF_APB__AFI2_REF_CTRL__SRCSEL {DPLL} \
   CONFIG.PSU__CRF_APB__AFI2_REF__ENABLE {0} \
   CONFIG.PSU__CRF_APB__AFI3_REF_CTRL__ACT_FREQMHZ {667} \
   CONFIG.PSU__CRF_APB__AFI3_REF_CTRL__DIVISOR0 {2} \
   CONFIG.PSU__CRF_APB__AFI3_REF_CTRL__FREQMHZ {667} \
   CONFIG.PSU__CRF_APB__AFI3_REF_CTRL__SRCSEL {DPLL} \
   CONFIG.PSU__CRF_APB__AFI3_REF__ENABLE {0} \
   CONFIG.PSU__CRF_APB__AFI4_REF_CTRL__ACT_FREQMHZ {667} \
   CONFIG.PSU__CRF_APB__AFI4_REF_CTRL__DIVISOR0 {2} \
   CONFIG.PSU__CRF_APB__AFI4_REF_CTRL__FREQMHZ {667} \
   CONFIG.PSU__CRF_APB__AFI4_REF_CTRL__SRCSEL {DPLL} \
   CONFIG.PSU__CRF_APB__AFI4_REF__ENABLE {0} \
   CONFIG.PSU__CRF_APB__AFI5_REF_CTRL__ACT_FREQMHZ {667} \
   CONFIG.PSU__CRF_APB__AFI5_REF_CTRL__DIVISOR0 {2} \
   CONFIG.PSU__CRF_APB__AFI5_REF_CTRL__FREQMHZ {667} \
   CONFIG.PSU__CRF_APB__AFI5_REF_CTRL__SRCSEL {DPLL} \
   CONFIG.PSU__CRF_APB__AFI5_REF__ENABLE {0} \
   CONFIG.PSU__CRF_APB__APLL_CTRL__DIV2 {1} \
   CONFIG.PSU__CRF_APB__APLL_CTRL__FBDIV {72} \
   CONFIG.PSU__CRF_APB__APLL_CTRL__FRACDATA {0.000000} \
   CONFIG.PSU__CRF_APB__APLL_CTRL__FRACFREQ {27.138} \
   CONFIG.PSU__CRF_APB__APLL_CTRL__SRCSEL {PSS_REF_CLK} \
   CONFIG.PSU__CRF_APB__APLL_FRAC_CFG__ENABLED {0} \
   CONFIG.PSU__CRF_APB__APLL_TO_LPD_CTRL__DIVISOR0 {3} \
   CONFIG.PSU__CRF_APB__APM_CTRL__ACT_FREQMHZ {1} \
   CONFIG.PSU__CRF_APB__APM_CTRL__DIVISOR0 {1} \
   CONFIG.PSU__CRF_APB__APM_CTRL__FREQMHZ {1} \
   CONFIG.PSU__CRF_APB__DBG_FPD_CTRL__ACT_FREQMHZ {249.997498} \
   CONFIG.PSU__CRF_APB__DBG_FPD_CTRL__DIVISOR0 {2} \
   CONFIG.PSU__CRF_APB__DBG_FPD_CTRL__FREQMHZ {250} \
   CONFIG.PSU__CRF_APB__DBG_FPD_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRF_APB__DBG_TRACE_CTRL__ACT_FREQMHZ {250} \
   CONFIG.PSU__CRF_APB__DBG_TRACE_CTRL__DIVISOR0 {5} \
   CONFIG.PSU__CRF_APB__DBG_TRACE_CTRL__FREQMHZ {250} \
   CONFIG.PSU__CRF_APB__DBG_TRACE_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRF_APB__DBG_TSTMP_CTRL__ACT_FREQMHZ {249.997498} \
   CONFIG.PSU__CRF_APB__DBG_TSTMP_CTRL__DIVISOR0 {2} \
   CONFIG.PSU__CRF_APB__DBG_TSTMP_CTRL__FREQMHZ {250} \
   CONFIG.PSU__CRF_APB__DBG_TSTMP_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRF_APB__DDR_CTRL__ACT_FREQMHZ {599.994019} \
   CONFIG.PSU__CRF_APB__DDR_CTRL__DIVISOR0 {2} \
   CONFIG.PSU__CRF_APB__DDR_CTRL__FREQMHZ {1200} \
   CONFIG.PSU__CRF_APB__DDR_CTRL__SRCSEL {DPLL} \
   CONFIG.PSU__CRF_APB__DPDMA_REF_CTRL__ACT_FREQMHZ {599.994019} \
   CONFIG.PSU__CRF_APB__DPDMA_REF_CTRL__DIVISOR0 {2} \
   CONFIG.PSU__CRF_APB__DPDMA_REF_CTRL__FREQMHZ {600} \
   CONFIG.PSU__CRF_APB__DPDMA_REF_CTRL__SRCSEL {APLL} \
   CONFIG.PSU__CRF_APB__DPLL_CTRL__DIV2 {1} \
   CONFIG.PSU__CRF_APB__DPLL_CTRL__FBDIV {72} \
   CONFIG.PSU__CRF_APB__DPLL_CTRL__FRACDATA {0.000000} \
   CONFIG.PSU__CRF_APB__DPLL_CTRL__FRACFREQ {27.138} \
   CONFIG.PSU__CRF_APB__DPLL_CTRL__SRCSEL {PSS_REF_CLK} \
   CONFIG.PSU__CRF_APB__DPLL_FRAC_CFG__ENABLED {0} \
   CONFIG.PSU__CRF_APB__DPLL_TO_LPD_CTRL__DIVISOR0 {3} \
   CONFIG.PSU__CRF_APB__DP_AUDIO_REF_CTRL__ACT_FREQMHZ {24.999750} \
   CONFIG.PSU__CRF_APB__DP_AUDIO_REF_CTRL__DIVISOR0 {20} \
   CONFIG.PSU__CRF_APB__DP_AUDIO_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRF_APB__DP_AUDIO_REF_CTRL__FREQMHZ {25} \
   CONFIG.PSU__CRF_APB__DP_AUDIO_REF_CTRL__SRCSEL {RPLL} \
   CONFIG.PSU__CRF_APB__DP_AUDIO__FRAC_ENABLED {0} \
   CONFIG.PSU__CRF_APB__DP_STC_REF_CTRL__ACT_FREQMHZ {26.315527} \
   CONFIG.PSU__CRF_APB__DP_STC_REF_CTRL__DIVISOR0 {19} \
   CONFIG.PSU__CRF_APB__DP_STC_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRF_APB__DP_STC_REF_CTRL__FREQMHZ {27} \
   CONFIG.PSU__CRF_APB__DP_STC_REF_CTRL__SRCSEL {RPLL} \
   CONFIG.PSU__CRF_APB__DP_VIDEO_REF_CTRL__ACT_FREQMHZ {299.997009} \
   CONFIG.PSU__CRF_APB__DP_VIDEO_REF_CTRL__DIVISOR0 {5} \
   CONFIG.PSU__CRF_APB__DP_VIDEO_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRF_APB__DP_VIDEO_REF_CTRL__FREQMHZ {300} \
   CONFIG.PSU__CRF_APB__DP_VIDEO_REF_CTRL__SRCSEL {VPLL} \
   CONFIG.PSU__CRF_APB__DP_VIDEO__FRAC_ENABLED {0} \
   CONFIG.PSU__CRF_APB__GDMA_REF_CTRL__ACT_FREQMHZ {599.994019} \
   CONFIG.PSU__CRF_APB__GDMA_REF_CTRL__DIVISOR0 {2} \
   CONFIG.PSU__CRF_APB__GDMA_REF_CTRL__FREQMHZ {600} \
   CONFIG.PSU__CRF_APB__GDMA_REF_CTRL__SRCSEL {APLL} \
   CONFIG.PSU__CRF_APB__GPU_REF_CTRL__ACT_FREQMHZ {599.994019} \
   CONFIG.PSU__CRF_APB__GPU_REF_CTRL__DIVISOR0 {2} \
   CONFIG.PSU__CRF_APB__GPU_REF_CTRL__FREQMHZ {600} \
   CONFIG.PSU__CRF_APB__GPU_REF_CTRL__SRCSEL {DPLL} \
   CONFIG.PSU__CRF_APB__GTGREF0_REF_CTRL__ACT_FREQMHZ {-1} \
   CONFIG.PSU__CRF_APB__GTGREF0_REF_CTRL__DIVISOR0 {-1} \
   CONFIG.PSU__CRF_APB__GTGREF0_REF_CTRL__FREQMHZ {-1} \
   CONFIG.PSU__CRF_APB__GTGREF0_REF_CTRL__SRCSEL {NA} \
   CONFIG.PSU__CRF_APB__GTGREF0__ENABLE {NA} \
   CONFIG.PSU__CRF_APB__PCIE_REF_CTRL__ACT_FREQMHZ {249.997498} \
   CONFIG.PSU__CRF_APB__PCIE_REF_CTRL__DIVISOR0 {2} \
   CONFIG.PSU__CRF_APB__PCIE_REF_CTRL__FREQMHZ {250} \
   CONFIG.PSU__CRF_APB__PCIE_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRF_APB__SATA_REF_CTRL__ACT_FREQMHZ {250} \
   CONFIG.PSU__CRF_APB__SATA_REF_CTRL__DIVISOR0 {5} \
   CONFIG.PSU__CRF_APB__SATA_REF_CTRL__FREQMHZ {250} \
   CONFIG.PSU__CRF_APB__SATA_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRF_APB__TOPSW_LSBUS_CTRL__ACT_FREQMHZ {99.999001} \
   CONFIG.PSU__CRF_APB__TOPSW_LSBUS_CTRL__DIVISOR0 {5} \
   CONFIG.PSU__CRF_APB__TOPSW_LSBUS_CTRL__FREQMHZ {100} \
   CONFIG.PSU__CRF_APB__TOPSW_LSBUS_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRF_APB__TOPSW_MAIN_CTRL__ACT_FREQMHZ {399.996002} \
   CONFIG.PSU__CRF_APB__TOPSW_MAIN_CTRL__DIVISOR0 {3} \
   CONFIG.PSU__CRF_APB__TOPSW_MAIN_CTRL__FREQMHZ {400} \
   CONFIG.PSU__CRF_APB__TOPSW_MAIN_CTRL__SRCSEL {APLL} \
   CONFIG.PSU__CRF_APB__VPLL_CTRL__DIV2 {1} \
   CONFIG.PSU__CRF_APB__VPLL_CTRL__FBDIV {90} \
   CONFIG.PSU__CRF_APB__VPLL_CTRL__FRACDATA {0.000000} \
   CONFIG.PSU__CRF_APB__VPLL_CTRL__FRACFREQ {27.138} \
   CONFIG.PSU__CRF_APB__VPLL_CTRL__SRCSEL {PSS_REF_CLK} \
   CONFIG.PSU__CRF_APB__VPLL_FRAC_CFG__ENABLED {0} \
   CONFIG.PSU__CRF_APB__VPLL_TO_LPD_CTRL__DIVISOR0 {3} \
   CONFIG.PSU__CRL_APB__ADMA_REF_CTRL__ACT_FREQMHZ {499.994995} \
   CONFIG.PSU__CRL_APB__ADMA_REF_CTRL__DIVISOR0 {3} \
   CONFIG.PSU__CRL_APB__ADMA_REF_CTRL__FREQMHZ {500} \
   CONFIG.PSU__CRL_APB__ADMA_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__AFI6_REF_CTRL__ACT_FREQMHZ {500} \
   CONFIG.PSU__CRL_APB__AFI6_REF_CTRL__DIVISOR0 {3} \
   CONFIG.PSU__CRL_APB__AFI6_REF_CTRL__FREQMHZ {500} \
   CONFIG.PSU__CRL_APB__AFI6_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__AFI6__ENABLE {0} \
   CONFIG.PSU__CRL_APB__AMS_REF_CTRL__ACT_FREQMHZ {49.999500} \
   CONFIG.PSU__CRL_APB__AMS_REF_CTRL__DIVISOR0 {30} \
   CONFIG.PSU__CRL_APB__AMS_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__AMS_REF_CTRL__FREQMHZ {50} \
   CONFIG.PSU__CRL_APB__AMS_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__CAN0_REF_CTRL__ACT_FREQMHZ {100} \
   CONFIG.PSU__CRL_APB__CAN0_REF_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRL_APB__CAN0_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__CAN0_REF_CTRL__FREQMHZ {100} \
   CONFIG.PSU__CRL_APB__CAN0_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__CAN1_REF_CTRL__ACT_FREQMHZ {100} \
   CONFIG.PSU__CRL_APB__CAN1_REF_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRL_APB__CAN1_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__CAN1_REF_CTRL__FREQMHZ {100} \
   CONFIG.PSU__CRL_APB__CAN1_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__CPU_R5_CTRL__ACT_FREQMHZ {499.994995} \
   CONFIG.PSU__CRL_APB__CPU_R5_CTRL__DIVISOR0 {3} \
   CONFIG.PSU__CRL_APB__CPU_R5_CTRL__FREQMHZ {500} \
   CONFIG.PSU__CRL_APB__CPU_R5_CTRL__SRCSEL {RPLL} \
   CONFIG.PSU__CRL_APB__CSU_PLL_CTRL__ACT_FREQMHZ {180} \
   CONFIG.PSU__CRL_APB__CSU_PLL_CTRL__DIVISOR0 {3} \
   CONFIG.PSU__CRL_APB__CSU_PLL_CTRL__FREQMHZ {180} \
   CONFIG.PSU__CRL_APB__CSU_PLL_CTRL__SRCSEL {SysOsc} \
   CONFIG.PSU__CRL_APB__DBG_LPD_CTRL__ACT_FREQMHZ {249.997498} \
   CONFIG.PSU__CRL_APB__DBG_LPD_CTRL__DIVISOR0 {6} \
   CONFIG.PSU__CRL_APB__DBG_LPD_CTRL__FREQMHZ {250} \
   CONFIG.PSU__CRL_APB__DBG_LPD_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__DEBUG_R5_ATCLK_CTRL__ACT_FREQMHZ {1000} \
   CONFIG.PSU__CRL_APB__DEBUG_R5_ATCLK_CTRL__DIVISOR0 {6} \
   CONFIG.PSU__CRL_APB__DEBUG_R5_ATCLK_CTRL__FREQMHZ {1000} \
   CONFIG.PSU__CRL_APB__DEBUG_R5_ATCLK_CTRL__SRCSEL {RPLL} \
   CONFIG.PSU__CRL_APB__DLL_REF_CTRL__ACT_FREQMHZ {1499.984985} \
   CONFIG.PSU__CRL_APB__DLL_REF_CTRL__FREQMHZ {1500} \
   CONFIG.PSU__CRL_APB__DLL_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__GEM0_REF_CTRL__ACT_FREQMHZ {124.998749} \
   CONFIG.PSU__CRL_APB__GEM0_REF_CTRL__DIVISOR0 {12} \
   CONFIG.PSU__CRL_APB__GEM0_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__GEM0_REF_CTRL__FREQMHZ {125} \
   CONFIG.PSU__CRL_APB__GEM0_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__GEM1_REF_CTRL__ACT_FREQMHZ {125} \
   CONFIG.PSU__CRL_APB__GEM1_REF_CTRL__DIVISOR0 {12} \
   CONFIG.PSU__CRL_APB__GEM1_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__GEM1_REF_CTRL__FREQMHZ {125} \
   CONFIG.PSU__CRL_APB__GEM1_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__GEM2_REF_CTRL__ACT_FREQMHZ {124.998749} \
   CONFIG.PSU__CRL_APB__GEM2_REF_CTRL__DIVISOR0 {12} \
   CONFIG.PSU__CRL_APB__GEM2_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__GEM2_REF_CTRL__FREQMHZ {125} \
   CONFIG.PSU__CRL_APB__GEM2_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__GEM3_REF_CTRL__ACT_FREQMHZ {124.998749} \
   CONFIG.PSU__CRL_APB__GEM3_REF_CTRL__DIVISOR0 {12} \
   CONFIG.PSU__CRL_APB__GEM3_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__GEM3_REF_CTRL__FREQMHZ {125} \
   CONFIG.PSU__CRL_APB__GEM3_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__GEM_TSU_REF_CTRL__ACT_FREQMHZ {249.997498} \
   CONFIG.PSU__CRL_APB__GEM_TSU_REF_CTRL__DIVISOR0 {6} \
   CONFIG.PSU__CRL_APB__GEM_TSU_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__GEM_TSU_REF_CTRL__FREQMHZ {250} \
   CONFIG.PSU__CRL_APB__GEM_TSU_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__I2C0_REF_CTRL__ACT_FREQMHZ {99.999001} \
   CONFIG.PSU__CRL_APB__I2C0_REF_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRL_APB__I2C0_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__I2C0_REF_CTRL__FREQMHZ {100} \
   CONFIG.PSU__CRL_APB__I2C0_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__I2C1_REF_CTRL__ACT_FREQMHZ {99.999001} \
   CONFIG.PSU__CRL_APB__I2C1_REF_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRL_APB__I2C1_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__I2C1_REF_CTRL__FREQMHZ {100} \
   CONFIG.PSU__CRL_APB__I2C1_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__IOPLL_CTRL__DIV2 {1} \
   CONFIG.PSU__CRL_APB__IOPLL_CTRL__FBDIV {90} \
   CONFIG.PSU__CRL_APB__IOPLL_CTRL__FRACDATA {0.000000} \
   CONFIG.PSU__CRL_APB__IOPLL_CTRL__FRACFREQ {27.138} \
   CONFIG.PSU__CRL_APB__IOPLL_CTRL__SRCSEL {PSS_REF_CLK} \
   CONFIG.PSU__CRL_APB__IOPLL_FRAC_CFG__ENABLED {0} \
   CONFIG.PSU__CRL_APB__IOPLL_TO_FPD_CTRL__DIVISOR0 {3} \
   CONFIG.PSU__CRL_APB__IOU_SWITCH_CTRL__ACT_FREQMHZ {249.997498} \
   CONFIG.PSU__CRL_APB__IOU_SWITCH_CTRL__DIVISOR0 {6} \
   CONFIG.PSU__CRL_APB__IOU_SWITCH_CTRL__FREQMHZ {250} \
   CONFIG.PSU__CRL_APB__IOU_SWITCH_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__LPD_LSBUS_CTRL__ACT_FREQMHZ {99.999001} \
   CONFIG.PSU__CRL_APB__LPD_LSBUS_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRL_APB__LPD_LSBUS_CTRL__FREQMHZ {100} \
   CONFIG.PSU__CRL_APB__LPD_LSBUS_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__LPD_SWITCH_CTRL__ACT_FREQMHZ {499.994995} \
   CONFIG.PSU__CRL_APB__LPD_SWITCH_CTRL__DIVISOR0 {3} \
   CONFIG.PSU__CRL_APB__LPD_SWITCH_CTRL__FREQMHZ {500} \
   CONFIG.PSU__CRL_APB__LPD_SWITCH_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__NAND_REF_CTRL__ACT_FREQMHZ {100} \
   CONFIG.PSU__CRL_APB__NAND_REF_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRL_APB__NAND_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__NAND_REF_CTRL__FREQMHZ {100} \
   CONFIG.PSU__CRL_APB__NAND_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__OCM_MAIN_CTRL__ACT_FREQMHZ {500} \
   CONFIG.PSU__CRL_APB__OCM_MAIN_CTRL__DIVISOR0 {3} \
   CONFIG.PSU__CRL_APB__OCM_MAIN_CTRL__FREQMHZ {500} \
   CONFIG.PSU__CRL_APB__OCM_MAIN_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__PCAP_CTRL__ACT_FREQMHZ {187.498123} \
   CONFIG.PSU__CRL_APB__PCAP_CTRL__DIVISOR0 {8} \
   CONFIG.PSU__CRL_APB__PCAP_CTRL__FREQMHZ {200} \
   CONFIG.PSU__CRL_APB__PCAP_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__PL0_REF_CTRL__ACT_FREQMHZ {99.999001} \
   CONFIG.PSU__CRL_APB__PL0_REF_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRL_APB__PL0_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__PL0_REF_CTRL__FREQMHZ {100} \
   CONFIG.PSU__CRL_APB__PL0_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__PL1_REF_CTRL__ACT_FREQMHZ {374.996246} \
   CONFIG.PSU__CRL_APB__PL1_REF_CTRL__DIVISOR0 {4} \
   CONFIG.PSU__CRL_APB__PL1_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__PL1_REF_CTRL__FREQMHZ {375} \
   CONFIG.PSU__CRL_APB__PL1_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__PL2_REF_CTRL__ACT_FREQMHZ {36.584999} \
   CONFIG.PSU__CRL_APB__PL2_REF_CTRL__DIVISOR0 {41} \
   CONFIG.PSU__CRL_APB__PL2_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__PL2_REF_CTRL__FREQMHZ {37.125} \
   CONFIG.PSU__CRL_APB__PL2_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__PL3_REF_CTRL__ACT_FREQMHZ {299.997009} \
   CONFIG.PSU__CRL_APB__PL3_REF_CTRL__DIVISOR0 {5} \
   CONFIG.PSU__CRL_APB__PL3_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__PL3_REF_CTRL__FREQMHZ {300} \
   CONFIG.PSU__CRL_APB__PL3_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__QSPI_REF_CTRL__ACT_FREQMHZ {299.997009} \
   CONFIG.PSU__CRL_APB__QSPI_REF_CTRL__DIVISOR0 {5} \
   CONFIG.PSU__CRL_APB__QSPI_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__QSPI_REF_CTRL__FREQMHZ {300} \
   CONFIG.PSU__CRL_APB__QSPI_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__RPLL_CTRL__DIV2 {1} \
   CONFIG.PSU__CRL_APB__RPLL_CTRL__FBDIV {90} \
   CONFIG.PSU__CRL_APB__RPLL_CTRL__FRACDATA {0.000000} \
   CONFIG.PSU__CRL_APB__RPLL_CTRL__FRACFREQ {27.138} \
   CONFIG.PSU__CRL_APB__RPLL_CTRL__SRCSEL {PSS_REF_CLK} \
   CONFIG.PSU__CRL_APB__RPLL_FRAC_CFG__ENABLED {0} \
   CONFIG.PSU__CRL_APB__RPLL_TO_FPD_CTRL__DIVISOR0 {3} \
   CONFIG.PSU__CRL_APB__SDIO0_REF_CTRL__ACT_FREQMHZ {187.498123} \
   CONFIG.PSU__CRL_APB__SDIO0_REF_CTRL__DIVISOR0 {8} \
   CONFIG.PSU__CRL_APB__SDIO0_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__SDIO0_REF_CTRL__FREQMHZ {200} \
   CONFIG.PSU__CRL_APB__SDIO0_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__SDIO1_REF_CTRL__ACT_FREQMHZ {187.498123} \
   CONFIG.PSU__CRL_APB__SDIO1_REF_CTRL__DIVISOR0 {8} \
   CONFIG.PSU__CRL_APB__SDIO1_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__SDIO1_REF_CTRL__FREQMHZ {200} \
   CONFIG.PSU__CRL_APB__SDIO1_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__SPI0_REF_CTRL__ACT_FREQMHZ {214} \
   CONFIG.PSU__CRL_APB__SPI0_REF_CTRL__DIVISOR0 {7} \
   CONFIG.PSU__CRL_APB__SPI0_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__SPI0_REF_CTRL__FREQMHZ {200} \
   CONFIG.PSU__CRL_APB__SPI0_REF_CTRL__SRCSEL {RPLL} \
   CONFIG.PSU__CRL_APB__SPI1_REF_CTRL__ACT_FREQMHZ {214} \
   CONFIG.PSU__CRL_APB__SPI1_REF_CTRL__DIVISOR0 {7} \
   CONFIG.PSU__CRL_APB__SPI1_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__SPI1_REF_CTRL__FREQMHZ {200} \
   CONFIG.PSU__CRL_APB__SPI1_REF_CTRL__SRCSEL {RPLL} \
   CONFIG.PSU__CRL_APB__TIMESTAMP_REF_CTRL__ACT_FREQMHZ {99.999001} \
   CONFIG.PSU__CRL_APB__TIMESTAMP_REF_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRL_APB__TIMESTAMP_REF_CTRL__FREQMHZ {100} \
   CONFIG.PSU__CRL_APB__TIMESTAMP_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__UART0_REF_CTRL__ACT_FREQMHZ {99.999001} \
   CONFIG.PSU__CRL_APB__UART0_REF_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRL_APB__UART0_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__UART0_REF_CTRL__FREQMHZ {100} \
   CONFIG.PSU__CRL_APB__UART0_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__UART1_REF_CTRL__ACT_FREQMHZ {99.999001} \
   CONFIG.PSU__CRL_APB__UART1_REF_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRL_APB__UART1_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__UART1_REF_CTRL__FREQMHZ {100} \
   CONFIG.PSU__CRL_APB__UART1_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__USB0_BUS_REF_CTRL__ACT_FREQMHZ {249.997498} \
   CONFIG.PSU__CRL_APB__USB0_BUS_REF_CTRL__DIVISOR0 {6} \
   CONFIG.PSU__CRL_APB__USB0_BUS_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__USB0_BUS_REF_CTRL__FREQMHZ {250} \
   CONFIG.PSU__CRL_APB__USB0_BUS_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__USB1_BUS_REF_CTRL__ACT_FREQMHZ {250} \
   CONFIG.PSU__CRL_APB__USB1_BUS_REF_CTRL__DIVISOR0 {6} \
   CONFIG.PSU__CRL_APB__USB1_BUS_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__USB1_BUS_REF_CTRL__FREQMHZ {250} \
   CONFIG.PSU__CRL_APB__USB1_BUS_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__USB3_DUAL_REF_CTRL__ACT_FREQMHZ {19.999800} \
   CONFIG.PSU__CRL_APB__USB3_DUAL_REF_CTRL__DIVISOR0 {25} \
   CONFIG.PSU__CRL_APB__USB3_DUAL_REF_CTRL__DIVISOR1 {3} \
   CONFIG.PSU__CRL_APB__USB3_DUAL_REF_CTRL__FREQMHZ {20} \
   CONFIG.PSU__CRL_APB__USB3_DUAL_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__USB3__ENABLE {1} \
   CONFIG.PSU__CSUPMU__PERIPHERAL__VALID {1} \
   CONFIG.PSU__CSU_COHERENCY {0} \
   CONFIG.PSU__CSU__CSU_TAMPER_0__ENABLE {0} \
   CONFIG.PSU__CSU__CSU_TAMPER_0__ERASE_BBRAM {0} \
   CONFIG.PSU__CSU__CSU_TAMPER_10__ENABLE {0} \
   CONFIG.PSU__CSU__CSU_TAMPER_10__ERASE_BBRAM {0} \
   CONFIG.PSU__CSU__CSU_TAMPER_11__ENABLE {0} \
   CONFIG.PSU__CSU__CSU_TAMPER_11__ERASE_BBRAM {0} \
   CONFIG.PSU__CSU__CSU_TAMPER_12__ENABLE {0} \
   CONFIG.PSU__CSU__CSU_TAMPER_12__ERASE_BBRAM {0} \
   CONFIG.PSU__CSU__CSU_TAMPER_1__ENABLE {0} \
   CONFIG.PSU__CSU__CSU_TAMPER_1__ERASE_BBRAM {0} \
   CONFIG.PSU__CSU__CSU_TAMPER_2__ENABLE {0} \
   CONFIG.PSU__CSU__CSU_TAMPER_2__ERASE_BBRAM {0} \
   CONFIG.PSU__CSU__CSU_TAMPER_3__ENABLE {0} \
   CONFIG.PSU__CSU__CSU_TAMPER_3__ERASE_BBRAM {0} \
   CONFIG.PSU__CSU__CSU_TAMPER_4__ENABLE {0} \
   CONFIG.PSU__CSU__CSU_TAMPER_4__ERASE_BBRAM {0} \
   CONFIG.PSU__CSU__CSU_TAMPER_5__ENABLE {0} \
   CONFIG.PSU__CSU__CSU_TAMPER_5__ERASE_BBRAM {0} \
   CONFIG.PSU__CSU__CSU_TAMPER_6__ENABLE {0} \
   CONFIG.PSU__CSU__CSU_TAMPER_6__ERASE_BBRAM {0} \
   CONFIG.PSU__CSU__CSU_TAMPER_7__ENABLE {0} \
   CONFIG.PSU__CSU__CSU_TAMPER_7__ERASE_BBRAM {0} \
   CONFIG.PSU__CSU__CSU_TAMPER_8__ENABLE {0} \
   CONFIG.PSU__CSU__CSU_TAMPER_8__ERASE_BBRAM {0} \
   CONFIG.PSU__CSU__CSU_TAMPER_9__ENABLE {0} \
   CONFIG.PSU__CSU__CSU_TAMPER_9__ERASE_BBRAM {0} \
   CONFIG.PSU__CSU__PERIPHERAL__ENABLE {0} \
   CONFIG.PSU__DDRC__ADDR_MIRROR {0} \
   CONFIG.PSU__DDRC__AL {0} \
   CONFIG.PSU__DDRC__BANK_ADDR_COUNT {2} \
   CONFIG.PSU__DDRC__BG_ADDR_COUNT {1} \
   CONFIG.PSU__DDRC__BRC_MAPPING {ROW_BANK_COL} \
   CONFIG.PSU__DDRC__BUS_WIDTH {64 Bit} \
   CONFIG.PSU__DDRC__CL {17} \
   CONFIG.PSU__DDRC__CLOCK_STOP_EN {0} \
   CONFIG.PSU__DDRC__COL_ADDR_COUNT {10} \
   CONFIG.PSU__DDRC__COMPONENTS {Components} \
   CONFIG.PSU__DDRC__CWL {12} \
   CONFIG.PSU__DDRC__DDR3L_T_REF_RANGE {NA} \
   CONFIG.PSU__DDRC__DDR3_T_REF_RANGE {NA} \
   CONFIG.PSU__DDRC__DDR4_ADDR_MAPPING {1} \
   CONFIG.PSU__DDRC__DDR4_CAL_MODE_ENABLE {0} \
   CONFIG.PSU__DDRC__DDR4_CRC_CONTROL {0} \
   CONFIG.PSU__DDRC__DDR4_MAXPWR_SAVING_EN {0} \
   CONFIG.PSU__DDRC__DDR4_T_REF_MODE {0} \
   CONFIG.PSU__DDRC__DDR4_T_REF_RANGE {Normal (0-85)} \
   CONFIG.PSU__DDRC__DEEP_PWR_DOWN_EN {0} \
   CONFIG.PSU__DDRC__DEVICE_CAPACITY {4096 MBits} \
   CONFIG.PSU__DDRC__DIMM_ADDR_MIRROR {0} \
   CONFIG.PSU__DDRC__DM_DBI {DM_NO_DBI} \
   CONFIG.PSU__DDRC__DQMAP_0_3 {0} \
   CONFIG.PSU__DDRC__DQMAP_12_15 {0} \
   CONFIG.PSU__DDRC__DQMAP_16_19 {0} \
   CONFIG.PSU__DDRC__DQMAP_20_23 {0} \
   CONFIG.PSU__DDRC__DQMAP_24_27 {0} \
   CONFIG.PSU__DDRC__DQMAP_28_31 {0} \
   CONFIG.PSU__DDRC__DQMAP_32_35 {0} \
   CONFIG.PSU__DDRC__DQMAP_36_39 {0} \
   CONFIG.PSU__DDRC__DQMAP_40_43 {0} \
   CONFIG.PSU__DDRC__DQMAP_44_47 {0} \
   CONFIG.PSU__DDRC__DQMAP_48_51 {0} \
   CONFIG.PSU__DDRC__DQMAP_4_7 {0} \
   CONFIG.PSU__DDRC__DQMAP_52_55 {0} \
   CONFIG.PSU__DDRC__DQMAP_56_59 {0} \
   CONFIG.PSU__DDRC__DQMAP_60_63 {0} \
   CONFIG.PSU__DDRC__DQMAP_64_67 {0} \
   CONFIG.PSU__DDRC__DQMAP_68_71 {0} \
   CONFIG.PSU__DDRC__DQMAP_8_11 {0} \
   CONFIG.PSU__DDRC__DRAM_WIDTH {16 Bits} \
   CONFIG.PSU__DDRC__ECC {Disabled} \
   CONFIG.PSU__DDRC__ECC_SCRUB {0} \
   CONFIG.PSU__DDRC__ENABLE {1} \
   CONFIG.PSU__DDRC__ENABLE_2T_TIMING {0} \
   CONFIG.PSU__DDRC__ENABLE_DP_SWITCH {0} \
   CONFIG.PSU__DDRC__ENABLE_LP4_HAS_ECC_COMP {0} \
   CONFIG.PSU__DDRC__ENABLE_LP4_SLOWBOOT {0} \
   CONFIG.PSU__DDRC__EN_2ND_CLK {0} \
   CONFIG.PSU__DDRC__FGRM {1X} \
   CONFIG.PSU__DDRC__FREQ_MHZ {1} \
   CONFIG.PSU__DDRC__LPDDR3_DUALRANK_SDP {0} \
   CONFIG.PSU__DDRC__LPDDR3_T_REF_RANGE {NA} \
   CONFIG.PSU__DDRC__LPDDR4_T_REF_RANGE {NA} \
   CONFIG.PSU__DDRC__LP_ASR {manual normal} \
   CONFIG.PSU__DDRC__MEMORY_TYPE {DDR 4} \
   CONFIG.PSU__DDRC__PARITY_ENABLE {0} \
   CONFIG.PSU__DDRC__PER_BANK_REFRESH {0} \
   CONFIG.PSU__DDRC__PHY_DBI_MODE {0} \
   CONFIG.PSU__DDRC__PLL_BYPASS {0} \
   CONFIG.PSU__DDRC__PWR_DOWN_EN {0} \
   CONFIG.PSU__DDRC__RANK_ADDR_COUNT {0} \
   CONFIG.PSU__DDRC__RD_DQS_CENTER {0} \
   CONFIG.PSU__DDRC__ROW_ADDR_COUNT {15} \
   CONFIG.PSU__DDRC__SB_TARGET {15-15-15} \
   CONFIG.PSU__DDRC__SELF_REF_ABORT {0} \
   CONFIG.PSU__DDRC__SPEED_BIN {DDR4_2400P} \
   CONFIG.PSU__DDRC__STATIC_RD_MODE {0} \
   CONFIG.PSU__DDRC__TRAIN_DATA_EYE {1} \
   CONFIG.PSU__DDRC__TRAIN_READ_GATE {1} \
   CONFIG.PSU__DDRC__TRAIN_WRITE_LEVEL {1} \
   CONFIG.PSU__DDRC__T_FAW {30.0} \
   CONFIG.PSU__DDRC__T_RAS_MIN {32.0} \
   CONFIG.PSU__DDRC__T_RC {46.16} \
   CONFIG.PSU__DDRC__T_RCD {17} \
   CONFIG.PSU__DDRC__T_RP {17} \
   CONFIG.PSU__DDRC__VENDOR_PART {OTHERS} \
   CONFIG.PSU__DDRC__VIDEO_BUFFER_SIZE {0} \
   CONFIG.PSU__DDRC__VREF {1} \
   CONFIG.PSU__DDR_HIGH_ADDRESS_GUI_ENABLE {0} \
   CONFIG.PSU__DDR_QOS_ENABLE {0} \
   CONFIG.PSU__DDR_QOS_FIX_HP0_RDQOS {} \
   CONFIG.PSU__DDR_QOS_FIX_HP0_WRQOS {} \
   CONFIG.PSU__DDR_QOS_FIX_HP1_RDQOS {} \
   CONFIG.PSU__DDR_QOS_FIX_HP1_WRQOS {} \
   CONFIG.PSU__DDR_QOS_FIX_HP2_RDQOS {} \
   CONFIG.PSU__DDR_QOS_FIX_HP2_WRQOS {} \
   CONFIG.PSU__DDR_QOS_FIX_HP3_RDQOS {} \
   CONFIG.PSU__DDR_QOS_FIX_HP3_WRQOS {} \
   CONFIG.PSU__DDR_QOS_HP0_RDQOS {} \
   CONFIG.PSU__DDR_QOS_HP0_WRQOS {} \
   CONFIG.PSU__DDR_QOS_HP1_RDQOS {} \
   CONFIG.PSU__DDR_QOS_HP1_WRQOS {} \
   CONFIG.PSU__DDR_QOS_HP2_RDQOS {} \
   CONFIG.PSU__DDR_QOS_HP2_WRQOS {} \
   CONFIG.PSU__DDR_QOS_HP3_RDQOS {} \
   CONFIG.PSU__DDR_QOS_HP3_WRQOS {} \
   CONFIG.PSU__DDR_QOS_RD_HPR_THRSHLD {} \
   CONFIG.PSU__DDR_QOS_RD_LPR_THRSHLD {} \
   CONFIG.PSU__DDR_QOS_WR_THRSHLD {} \
   CONFIG.PSU__DDR_SW_REFRESH_ENABLED {1} \
   CONFIG.PSU__DDR__INTERFACE__FREQMHZ {600.000} \
   CONFIG.PSU__DEVICE_TYPE {EV} \
   CONFIG.PSU__DISPLAYPORT__LANE0__ENABLE {1} \
   CONFIG.PSU__DISPLAYPORT__LANE0__IO {GT Lane3} \
   CONFIG.PSU__DISPLAYPORT__LANE1__ENABLE {1} \
   CONFIG.PSU__DISPLAYPORT__LANE1__IO {GT Lane2} \
   CONFIG.PSU__DISPLAYPORT__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__DLL__ISUSED {1} \
   CONFIG.PSU__DPAUX__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__DPAUX__PERIPHERAL__IO {MIO 27 .. 30} \
   CONFIG.PSU__DP__LANE_SEL {Dual Higher} \
   CONFIG.PSU__DP__REF_CLK_FREQ {27} \
   CONFIG.PSU__DP__REF_CLK_SEL {Ref Clk2} \
   CONFIG.PSU__ENABLE__DDR__REFRESH__SIGNALS {0} \
   CONFIG.PSU__ENET0__FIFO__ENABLE {0} \
   CONFIG.PSU__ENET0__GRP_MDIO__ENABLE {1} \
   CONFIG.PSU__ENET0__GRP_MDIO__IO {EMIO} \
   CONFIG.PSU__ENET0__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__ENET0__PERIPHERAL__IO {EMIO} \
   CONFIG.PSU__ENET0__PTP__ENABLE {0} \
   CONFIG.PSU__ENET0__TSU__ENABLE {1} \
   CONFIG.PSU__ENET1__FIFO__ENABLE {0} \
   CONFIG.PSU__ENET1__GRP_MDIO__ENABLE {0} \
   CONFIG.PSU__ENET1__PERIPHERAL__ENABLE {0} \
   CONFIG.PSU__ENET1__PTP__ENABLE {0} \
   CONFIG.PSU__ENET1__TSU__ENABLE {0} \
   CONFIG.PSU__ENET2__FIFO__ENABLE {0} \
   CONFIG.PSU__ENET2__GRP_MDIO__ENABLE {0} \
   CONFIG.PSU__ENET2__PERIPHERAL__ENABLE {0} \
   CONFIG.PSU__ENET2__PTP__ENABLE {0} \
   CONFIG.PSU__ENET2__TSU__ENABLE {0} \
   CONFIG.PSU__ENET3__FIFO__ENABLE {0} \
   CONFIG.PSU__ENET3__GRP_MDIO__ENABLE {1} \
   CONFIG.PSU__ENET3__GRP_MDIO__IO {MIO 76 .. 77} \
   CONFIG.PSU__ENET3__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__ENET3__PERIPHERAL__IO {MIO 64 .. 75} \
   CONFIG.PSU__ENET3__PTP__ENABLE {0} \
   CONFIG.PSU__ENET3__TSU__ENABLE {0} \
   CONFIG.PSU__EN_AXI_STATUS_PORTS {0} \
   CONFIG.PSU__EN_EMIO_TRACE {0} \
   CONFIG.PSU__EP__IP {0} \
   CONFIG.PSU__EXPAND__CORESIGHT {0} \
   CONFIG.PSU__EXPAND__FPD_SLAVES {0} \
   CONFIG.PSU__EXPAND__GIC {0} \
   CONFIG.PSU__EXPAND__LOWER_LPS_SLAVES {0} \
   CONFIG.PSU__EXPAND__UPPER_LPS_SLAVES {0} \
   CONFIG.PSU__FPDMASTERS_COHERENCY {0} \
   CONFIG.PSU__FPD_SLCR__WDT1__ACT_FREQMHZ {99.999001} \
   CONFIG.PSU__FPD_SLCR__WDT1__FREQMHZ {99.999001} \
   CONFIG.PSU__FPD_SLCR__WDT_CLK_SEL__SELECT {APB} \
   CONFIG.PSU__FPGA_PL0_ENABLE {1} \
   CONFIG.PSU__FPGA_PL1_ENABLE {1} \
   CONFIG.PSU__FPGA_PL2_ENABLE {1} \
   CONFIG.PSU__FPGA_PL3_ENABLE {1} \
   CONFIG.PSU__FP__POWER__ON {1} \
   CONFIG.PSU__FTM__CTI_IN_0 {0} \
   CONFIG.PSU__FTM__CTI_IN_1 {0} \
   CONFIG.PSU__FTM__CTI_IN_2 {0} \
   CONFIG.PSU__FTM__CTI_IN_3 {0} \
   CONFIG.PSU__FTM__CTI_OUT_0 {0} \
   CONFIG.PSU__FTM__CTI_OUT_1 {0} \
   CONFIG.PSU__FTM__CTI_OUT_2 {0} \
   CONFIG.PSU__FTM__CTI_OUT_3 {0} \
   CONFIG.PSU__FTM__GPI {0} \
   CONFIG.PSU__FTM__GPO {0} \
   CONFIG.PSU__GEM0_COHERENCY {0} \
   CONFIG.PSU__GEM0_ROUTE_THROUGH_FPD {0} \
   CONFIG.PSU__GEM1_COHERENCY {0} \
   CONFIG.PSU__GEM1_ROUTE_THROUGH_FPD {0} \
   CONFIG.PSU__GEM2_COHERENCY {0} \
   CONFIG.PSU__GEM2_ROUTE_THROUGH_FPD {0} \
   CONFIG.PSU__GEM3_COHERENCY {0} \
   CONFIG.PSU__GEM3_ROUTE_THROUGH_FPD {0} \
   CONFIG.PSU__GEM__TSU__ENABLE {0} \
   CONFIG.PSU__GEN_IPI_0__MASTER {APU} \
   CONFIG.PSU__GEN_IPI_10__MASTER {NONE} \
   CONFIG.PSU__GEN_IPI_1__MASTER {RPU0} \
   CONFIG.PSU__GEN_IPI_2__MASTER {RPU1} \
   CONFIG.PSU__GEN_IPI_3__MASTER {PMU} \
   CONFIG.PSU__GEN_IPI_4__MASTER {PMU} \
   CONFIG.PSU__GEN_IPI_5__MASTER {PMU} \
   CONFIG.PSU__GEN_IPI_6__MASTER {PMU} \
   CONFIG.PSU__GEN_IPI_7__MASTER {NONE} \
   CONFIG.PSU__GEN_IPI_8__MASTER {NONE} \
   CONFIG.PSU__GEN_IPI_9__MASTER {NONE} \
   CONFIG.PSU__GPIO0_MIO__PERIPHERAL__ENABLE {0} \
   CONFIG.PSU__GPIO1_MIO__IO {MIO 26 .. 51} \
   CONFIG.PSU__GPIO1_MIO__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__GPIO2_MIO__PERIPHERAL__ENABLE {0} \
   CONFIG.PSU__GPIO_EMIO_WIDTH {49} \
   CONFIG.PSU__GPIO_EMIO__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__GPIO_EMIO__PERIPHERAL__IO {49} \
   CONFIG.PSU__GPIO_EMIO__WIDTH {[94:0]} \
   CONFIG.PSU__GPU_PP0__POWER__ON {1} \
   CONFIG.PSU__GPU_PP1__POWER__ON {1} \
   CONFIG.PSU__GT_REF_CLK__FREQMHZ {33.333} \
   CONFIG.PSU__GT__LINK_SPEED {HBR} \
   CONFIG.PSU__GT__PRE_EMPH_LVL_4 {0} \
   CONFIG.PSU__GT__VLT_SWNG_LVL_4 {0} \
   CONFIG.PSU__HIGH_ADDRESS__ENABLE {0} \
   CONFIG.PSU__HPM0_FPD__NUM_READ_THREADS {4} \
   CONFIG.PSU__HPM0_FPD__NUM_WRITE_THREADS {4} \
   CONFIG.PSU__HPM0_LPD__NUM_READ_THREADS {4} \
   CONFIG.PSU__HPM0_LPD__NUM_WRITE_THREADS {4} \
   CONFIG.PSU__HPM1_FPD__NUM_READ_THREADS {4} \
   CONFIG.PSU__HPM1_FPD__NUM_WRITE_THREADS {4} \
   CONFIG.PSU__I2C0_LOOP_I2C1__ENABLE {0} \
   CONFIG.PSU__I2C0__GRP_INT__ENABLE {0} \
   CONFIG.PSU__I2C0__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__I2C0__PERIPHERAL__IO {EMIO} \
   CONFIG.PSU__I2C1__GRP_INT__ENABLE {0} \
   CONFIG.PSU__I2C1__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__I2C1__PERIPHERAL__IO {EMIO} \
   CONFIG.PSU__IOU_SLCR__IOU_TTC_APB_CLK__TTC0_SEL {APB} \
   CONFIG.PSU__IOU_SLCR__IOU_TTC_APB_CLK__TTC1_SEL {APB} \
   CONFIG.PSU__IOU_SLCR__IOU_TTC_APB_CLK__TTC2_SEL {APB} \
   CONFIG.PSU__IOU_SLCR__IOU_TTC_APB_CLK__TTC3_SEL {APB} \
   CONFIG.PSU__IOU_SLCR__TTC0__ACT_FREQMHZ {100.000000} \
   CONFIG.PSU__IOU_SLCR__TTC0__FREQMHZ {100.000000} \
   CONFIG.PSU__IOU_SLCR__TTC1__ACT_FREQMHZ {100.000000} \
   CONFIG.PSU__IOU_SLCR__TTC1__FREQMHZ {100.000000} \
   CONFIG.PSU__IOU_SLCR__TTC2__ACT_FREQMHZ {100.000000} \
   CONFIG.PSU__IOU_SLCR__TTC2__FREQMHZ {100.000000} \
   CONFIG.PSU__IOU_SLCR__TTC3__ACT_FREQMHZ {100.000000} \
   CONFIG.PSU__IOU_SLCR__TTC3__FREQMHZ {100.000000} \
   CONFIG.PSU__IOU_SLCR__WDT0__ACT_FREQMHZ {99.999001} \
   CONFIG.PSU__IOU_SLCR__WDT0__FREQMHZ {99.999001} \
   CONFIG.PSU__IOU_SLCR__WDT_CLK_SEL__SELECT {APB} \
   CONFIG.PSU__IRQ_P2F_ADMA_CHAN__INT {0} \
   CONFIG.PSU__IRQ_P2F_AIB_AXI__INT {0} \
   CONFIG.PSU__IRQ_P2F_AMS__INT {0} \
   CONFIG.PSU__IRQ_P2F_APM_FPD__INT {0} \
   CONFIG.PSU__IRQ_P2F_APU_COMM__INT {0} \
   CONFIG.PSU__IRQ_P2F_APU_CPUMNT__INT {0} \
   CONFIG.PSU__IRQ_P2F_APU_CTI__INT {0} \
   CONFIG.PSU__IRQ_P2F_APU_EXTERR__INT {0} \
   CONFIG.PSU__IRQ_P2F_APU_IPI__INT {0} \
   CONFIG.PSU__IRQ_P2F_APU_L2ERR__INT {0} \
   CONFIG.PSU__IRQ_P2F_APU_PMU__INT {0} \
   CONFIG.PSU__IRQ_P2F_APU_REGS__INT {0} \
   CONFIG.PSU__IRQ_P2F_ATB_LPD__INT {0} \
   CONFIG.PSU__IRQ_P2F_CAN0__INT {0} \
   CONFIG.PSU__IRQ_P2F_CAN1__INT {0} \
   CONFIG.PSU__IRQ_P2F_CLKMON__INT {0} \
   CONFIG.PSU__IRQ_P2F_CSUPMU_WDT__INT {0} \
   CONFIG.PSU__IRQ_P2F_CSU_DMA__INT {0} \
   CONFIG.PSU__IRQ_P2F_CSU__INT {0} \
   CONFIG.PSU__IRQ_P2F_DDR_SS__INT {0} \
   CONFIG.PSU__IRQ_P2F_DPDMA__INT {0} \
   CONFIG.PSU__IRQ_P2F_DPORT__INT {0} \
   CONFIG.PSU__IRQ_P2F_EFUSE__INT {0} \
   CONFIG.PSU__IRQ_P2F_ENT0_WAKEUP__INT {0} \
   CONFIG.PSU__IRQ_P2F_ENT0__INT {0} \
   CONFIG.PSU__IRQ_P2F_ENT1_WAKEUP__INT {0} \
   CONFIG.PSU__IRQ_P2F_ENT1__INT {0} \
   CONFIG.PSU__IRQ_P2F_ENT2_WAKEUP__INT {0} \
   CONFIG.PSU__IRQ_P2F_ENT2__INT {0} \
   CONFIG.PSU__IRQ_P2F_ENT3_WAKEUP__INT {0} \
   CONFIG.PSU__IRQ_P2F_ENT3__INT {0} \
   CONFIG.PSU__IRQ_P2F_FPD_APB__INT {0} \
   CONFIG.PSU__IRQ_P2F_FPD_ATB_ERR__INT {0} \
   CONFIG.PSU__IRQ_P2F_FP_WDT__INT {0} \
   CONFIG.PSU__IRQ_P2F_GDMA_CHAN__INT {0} \
   CONFIG.PSU__IRQ_P2F_GPIO__INT {0} \
   CONFIG.PSU__IRQ_P2F_GPU__INT {0} \
   CONFIG.PSU__IRQ_P2F_I2C0__INT {0} \
   CONFIG.PSU__IRQ_P2F_I2C1__INT {0} \
   CONFIG.PSU__IRQ_P2F_LPD_APB__INT {0} \
   CONFIG.PSU__IRQ_P2F_LPD_APM__INT {0} \
   CONFIG.PSU__IRQ_P2F_LP_WDT__INT {0} \
   CONFIG.PSU__IRQ_P2F_NAND__INT {0} \
   CONFIG.PSU__IRQ_P2F_OCM_ERR__INT {0} \
   CONFIG.PSU__IRQ_P2F_PCIE_DMA__INT {0} \
   CONFIG.PSU__IRQ_P2F_PCIE_LEGACY__INT {0} \
   CONFIG.PSU__IRQ_P2F_PCIE_MSC__INT {0} \
   CONFIG.PSU__IRQ_P2F_PCIE_MSI__INT {0} \
   CONFIG.PSU__IRQ_P2F_PL_IPI__INT {0} \
   CONFIG.PSU__IRQ_P2F_QSPI__INT {0} \
   CONFIG.PSU__IRQ_P2F_R5_CORE0_ECC_ERR__INT {0} \
   CONFIG.PSU__IRQ_P2F_R5_CORE1_ECC_ERR__INT {0} \
   CONFIG.PSU__IRQ_P2F_RPU_IPI__INT {0} \
   CONFIG.PSU__IRQ_P2F_RPU_PERMON__INT {0} \
   CONFIG.PSU__IRQ_P2F_RTC_ALARM__INT {0} \
   CONFIG.PSU__IRQ_P2F_RTC_SECONDS__INT {0} \
   CONFIG.PSU__IRQ_P2F_SATA__INT {0} \
   CONFIG.PSU__IRQ_P2F_SDIO0_WAKE__INT {0} \
   CONFIG.PSU__IRQ_P2F_SDIO0__INT {0} \
   CONFIG.PSU__IRQ_P2F_SDIO1_WAKE__INT {0} \
   CONFIG.PSU__IRQ_P2F_SDIO1__INT {0} \
   CONFIG.PSU__IRQ_P2F_SPI0__INT {0} \
   CONFIG.PSU__IRQ_P2F_SPI1__INT {0} \
   CONFIG.PSU__IRQ_P2F_TTC0__INT0 {0} \
   CONFIG.PSU__IRQ_P2F_TTC0__INT1 {0} \
   CONFIG.PSU__IRQ_P2F_TTC0__INT2 {0} \
   CONFIG.PSU__IRQ_P2F_TTC1__INT0 {0} \
   CONFIG.PSU__IRQ_P2F_TTC1__INT1 {0} \
   CONFIG.PSU__IRQ_P2F_TTC1__INT2 {0} \
   CONFIG.PSU__IRQ_P2F_TTC2__INT0 {0} \
   CONFIG.PSU__IRQ_P2F_TTC2__INT1 {0} \
   CONFIG.PSU__IRQ_P2F_TTC2__INT2 {0} \
   CONFIG.PSU__IRQ_P2F_TTC3__INT0 {0} \
   CONFIG.PSU__IRQ_P2F_TTC3__INT1 {0} \
   CONFIG.PSU__IRQ_P2F_TTC3__INT2 {0} \
   CONFIG.PSU__IRQ_P2F_UART0__INT {0} \
   CONFIG.PSU__IRQ_P2F_UART1__INT {0} \
   CONFIG.PSU__IRQ_P2F_USB3_ENDPOINT__INT0 {0} \
   CONFIG.PSU__IRQ_P2F_USB3_ENDPOINT__INT1 {0} \
   CONFIG.PSU__IRQ_P2F_USB3_OTG__INT0 {0} \
   CONFIG.PSU__IRQ_P2F_USB3_OTG__INT1 {0} \
   CONFIG.PSU__IRQ_P2F_USB3_PMU_WAKEUP__INT {0} \
   CONFIG.PSU__IRQ_P2F_XMPU_FPD__INT {0} \
   CONFIG.PSU__IRQ_P2F_XMPU_LPD__INT {0} \
   CONFIG.PSU__IRQ_P2F__INTF_FPD_SMMU__INT {0} \
   CONFIG.PSU__IRQ_P2F__INTF_PPD_CCI__INT {0} \
   CONFIG.PSU__L2_BANK0__POWER__ON {1} \
   CONFIG.PSU__LPDMA0_COHERENCY {0} \
   CONFIG.PSU__LPDMA1_COHERENCY {0} \
   CONFIG.PSU__LPDMA2_COHERENCY {0} \
   CONFIG.PSU__LPDMA3_COHERENCY {0} \
   CONFIG.PSU__LPDMA4_COHERENCY {0} \
   CONFIG.PSU__LPDMA5_COHERENCY {0} \
   CONFIG.PSU__LPDMA6_COHERENCY {0} \
   CONFIG.PSU__LPDMA7_COHERENCY {0} \
   CONFIG.PSU__LPD_SLCR__CSUPMU_WDT_CLK_SEL__SELECT {APB} \
   CONFIG.PSU__LPD_SLCR__CSUPMU__ACT_FREQMHZ {100.000000} \
   CONFIG.PSU__LPD_SLCR__CSUPMU__FREQMHZ {100.000000} \
   CONFIG.PSU__MAXIGP0__DATA_WIDTH {128} \
   CONFIG.PSU__MAXIGP1__DATA_WIDTH {128} \
   CONFIG.PSU__MAXIGP2__DATA_WIDTH {32} \
   CONFIG.PSU__M_AXI_GP0_SUPPORTS_NARROW_BURST {1} \
   CONFIG.PSU__M_AXI_GP1_SUPPORTS_NARROW_BURST {1} \
   CONFIG.PSU__M_AXI_GP2_SUPPORTS_NARROW_BURST {1} \
   CONFIG.PSU__NAND_COHERENCY {0} \
   CONFIG.PSU__NAND_ROUTE_THROUGH_FPD {0} \
   CONFIG.PSU__NAND__CHIP_ENABLE__ENABLE {0} \
   CONFIG.PSU__NAND__DATA_STROBE__ENABLE {0} \
   CONFIG.PSU__NAND__PERIPHERAL__ENABLE {0} \
   CONFIG.PSU__NAND__READY0_BUSY__ENABLE {0} \
   CONFIG.PSU__NAND__READY1_BUSY__ENABLE {0} \
   CONFIG.PSU__NAND__READY_BUSY__ENABLE {0} \
   CONFIG.PSU__NUM_FABRIC_RESETS {1} \
   CONFIG.PSU__OCM_BANK0__POWER__ON {1} \
   CONFIG.PSU__OCM_BANK1__POWER__ON {1} \
   CONFIG.PSU__OCM_BANK2__POWER__ON {1} \
   CONFIG.PSU__OCM_BANK3__POWER__ON {1} \
   CONFIG.PSU__OVERRIDE_HPX_QOS {0} \
   CONFIG.PSU__OVERRIDE__BASIC_CLOCK {0} \
   CONFIG.PSU__PCIE__ACS_VIOLAION {0} \
   CONFIG.PSU__PCIE__ACS_VIOLATION {0} \
   CONFIG.PSU__PCIE__AER_CAPABILITY {0} \
   CONFIG.PSU__PCIE__ATOMICOP_EGRESS_BLOCKED {0} \
   CONFIG.PSU__PCIE__BAR0_64BIT {0} \
   CONFIG.PSU__PCIE__BAR0_ENABLE {1} \
   CONFIG.PSU__PCIE__BAR0_PREFETCHABLE {0} \
   CONFIG.PSU__PCIE__BAR0_SCALE {Megabytes} \
   CONFIG.PSU__PCIE__BAR0_SIZE {1} \
   CONFIG.PSU__PCIE__BAR0_TYPE {Memory} \
   CONFIG.PSU__PCIE__BAR0_VAL {0xfff00000} \
   CONFIG.PSU__PCIE__BAR1_64BIT {0} \
   CONFIG.PSU__PCIE__BAR1_ENABLE {0} \
   CONFIG.PSU__PCIE__BAR1_PREFETCHABLE {0} \
   CONFIG.PSU__PCIE__BAR1_VAL {0x0} \
   CONFIG.PSU__PCIE__BAR2_64BIT {0} \
   CONFIG.PSU__PCIE__BAR2_ENABLE {0} \
   CONFIG.PSU__PCIE__BAR2_PREFETCHABLE {0} \
   CONFIG.PSU__PCIE__BAR2_VAL {0x0} \
   CONFIG.PSU__PCIE__BAR3_64BIT {0} \
   CONFIG.PSU__PCIE__BAR3_ENABLE {0} \
   CONFIG.PSU__PCIE__BAR3_PREFETCHABLE {0} \
   CONFIG.PSU__PCIE__BAR3_VAL {0x0} \
   CONFIG.PSU__PCIE__BAR4_64BIT {0} \
   CONFIG.PSU__PCIE__BAR4_ENABLE {0} \
   CONFIG.PSU__PCIE__BAR4_PREFETCHABLE {0} \
   CONFIG.PSU__PCIE__BAR4_VAL {0x0} \
   CONFIG.PSU__PCIE__BAR5_64BIT {0} \
   CONFIG.PSU__PCIE__BAR5_ENABLE {0} \
   CONFIG.PSU__PCIE__BAR5_PREFETCHABLE {0} \
   CONFIG.PSU__PCIE__BAR5_VAL {0x0} \
   CONFIG.PSU__PCIE__CLASS_CODE_BASE {0x06} \
   CONFIG.PSU__PCIE__CLASS_CODE_INTERFACE {0x0} \
   CONFIG.PSU__PCIE__CLASS_CODE_SUB {0x04} \
   CONFIG.PSU__PCIE__CLASS_CODE_VALUE {0x60400} \
   CONFIG.PSU__PCIE__COMPLETER_ABORT {0} \
   CONFIG.PSU__PCIE__COMPLTION_TIMEOUT {0} \
   CONFIG.PSU__PCIE__CORRECTABLE_INT_ERR {0} \
   CONFIG.PSU__PCIE__CRS_SW_VISIBILITY {0} \
   CONFIG.PSU__PCIE__DEVICE_ID {0xD011} \
   CONFIG.PSU__PCIE__DEVICE_PORT_TYPE {Root Port} \
   CONFIG.PSU__PCIE__ECRC_CHECK {0} \
   CONFIG.PSU__PCIE__ECRC_ERR {0} \
   CONFIG.PSU__PCIE__ECRC_GEN {0} \
   CONFIG.PSU__PCIE__EROM_ENABLE {0} \
   CONFIG.PSU__PCIE__EROM_VAL {0x0} \
   CONFIG.PSU__PCIE__FLOW_CONTROL_ERR {0} \
   CONFIG.PSU__PCIE__FLOW_CONTROL_PROTOCOL_ERR {0} \
   CONFIG.PSU__PCIE__HEADER_LOG_OVERFLOW {0} \
   CONFIG.PSU__PCIE__INTX_GENERATION {0} \
   CONFIG.PSU__PCIE__LANE0__ENABLE {1} \
   CONFIG.PSU__PCIE__LANE0__IO {GT Lane0} \
   CONFIG.PSU__PCIE__LANE1__ENABLE {0} \
   CONFIG.PSU__PCIE__LANE2__ENABLE {0} \
   CONFIG.PSU__PCIE__LANE3__ENABLE {0} \
   CONFIG.PSU__PCIE__LINK_SPEED {5.0 Gb/s} \
   CONFIG.PSU__PCIE__MAXIMUM_LINK_WIDTH {x1} \
   CONFIG.PSU__PCIE__MAX_PAYLOAD_SIZE {256 bytes} \
   CONFIG.PSU__PCIE__MC_BLOCKED_TLP {0} \
   CONFIG.PSU__PCIE__MSIX_BAR_INDICATOR {} \
   CONFIG.PSU__PCIE__MSIX_CAPABILITY {0} \
   CONFIG.PSU__PCIE__MSIX_PBA_BAR_INDICATOR {} \
   CONFIG.PSU__PCIE__MSIX_PBA_OFFSET {0} \
   CONFIG.PSU__PCIE__MSIX_TABLE_OFFSET {0} \
   CONFIG.PSU__PCIE__MSIX_TABLE_SIZE {0} \
   CONFIG.PSU__PCIE__MSI_64BIT_ADDR_CAPABLE {0} \
   CONFIG.PSU__PCIE__MSI_CAPABILITY {0} \
   CONFIG.PSU__PCIE__MULTIHEADER {0} \
   CONFIG.PSU__PCIE__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__PCIE__PERIPHERAL__ENDPOINT_ENABLE {0} \
   CONFIG.PSU__PCIE__PERIPHERAL__ENDPOINT_IO {<Select>} \
   CONFIG.PSU__PCIE__PERIPHERAL__ROOTPORT_ENABLE {1} \
   CONFIG.PSU__PCIE__PERIPHERAL__ROOTPORT_IO {MIO 37} \
   CONFIG.PSU__PCIE__PERM_ROOT_ERR_UPDATE {0} \
   CONFIG.PSU__PCIE__RECEIVER_ERR {0} \
   CONFIG.PSU__PCIE__RECEIVER_OVERFLOW {0} \
   CONFIG.PSU__PCIE__REF_CLK_FREQ {100} \
   CONFIG.PSU__PCIE__REF_CLK_SEL {Ref Clk0} \
   CONFIG.PSU__PCIE__RESET__POLARITY {Active Low} \
   CONFIG.PSU__PCIE__REVISION_ID {0x0} \
   CONFIG.PSU__PCIE__SUBSYSTEM_ID {0x7} \
   CONFIG.PSU__PCIE__SUBSYSTEM_VENDOR_ID {0x10EE} \
   CONFIG.PSU__PCIE__SURPRISE_DOWN {0} \
   CONFIG.PSU__PCIE__TLP_PREFIX_BLOCKED {0} \
   CONFIG.PSU__PCIE__UNCORRECTABL_INT_ERR {0} \
   CONFIG.PSU__PCIE__VENDOR_ID {0x10EE} \
   CONFIG.PSU__PJTAG__PERIPHERAL__ENABLE {0} \
   CONFIG.PSU__PL_CLK0_BUF {TRUE} \
   CONFIG.PSU__PL_CLK1_BUF {TRUE} \
   CONFIG.PSU__PL_CLK2_BUF {TRUE} \
   CONFIG.PSU__PL_CLK3_BUF {TRUE} \
   CONFIG.PSU__PL__POWER__ON {1} \
   CONFIG.PSU__PMU_COHERENCY {0} \
   CONFIG.PSU__PMU__AIBACK__ENABLE {0} \
   CONFIG.PSU__PMU__EMIO_GPI__ENABLE {0} \
   CONFIG.PSU__PMU__EMIO_GPO__ENABLE {0} \
   CONFIG.PSU__PMU__GPI0__ENABLE {0} \
   CONFIG.PSU__PMU__GPI1__ENABLE {0} \
   CONFIG.PSU__PMU__GPI2__ENABLE {0} \
   CONFIG.PSU__PMU__GPI3__ENABLE {0} \
   CONFIG.PSU__PMU__GPI4__ENABLE {0} \
   CONFIG.PSU__PMU__GPI5__ENABLE {0} \
   CONFIG.PSU__PMU__GPO0__ENABLE {0} \
   CONFIG.PSU__PMU__GPO1__ENABLE {0} \
   CONFIG.PSU__PMU__GPO2__ENABLE {0} \
   CONFIG.PSU__PMU__GPO3__ENABLE {0} \
   CONFIG.PSU__PMU__GPO4__ENABLE {0} \
   CONFIG.PSU__PMU__GPO5__ENABLE {0} \
   CONFIG.PSU__PMU__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__PMU__PLERROR__ENABLE {0} \
   CONFIG.PSU__PRESET_APPLIED {0} \
   CONFIG.PSU__PROTECTION__DDR_SEGMENTS {NONE} \
   CONFIG.PSU__PROTECTION__DEBUG {0} \
   CONFIG.PSU__PROTECTION__ENABLE {0} \
   CONFIG.PSU__PROTECTION__FPD_SEGMENTS {SA:0xFD1A0000; SIZE:1280; UNIT:KB; RegionTZ:Secure; WrAllowed:Read/Write; subsystemId:PMU Firmware     |      SA:0xFD000000; SIZE:64; UNIT:KB; RegionTZ:Secure; WrAllowed:Read/Write; subsystemId:PMU Firmware     |      SA:0xFD010000; SIZE:64; UNIT:KB; RegionTZ:Secure; WrAllowed:Read/Write; subsystemId:PMU Firmware     |      SA:0xFD020000; SIZE:64; UNIT:KB; RegionTZ:Secure; WrAllowed:Read/Write; subsystemId:PMU Firmware     |      SA:0xFD030000; SIZE:64; UNIT:KB; RegionTZ:Secure; WrAllowed:Read/Write; subsystemId:PMU Firmware     |      SA:0xFD040000; SIZE:64; UNIT:KB; RegionTZ:Secure; WrAllowed:Read/Write; subsystemId:PMU Firmware     |      SA:0xFD050000; SIZE:64; UNIT:KB; RegionTZ:Secure; WrAllowed:Read/Write; subsystemId:PMU Firmware     |      SA:0xFD610000; SIZE:512; UNIT:KB; RegionTZ:Secure; WrAllowed:Read/Write; subsystemId:PMU Firmware     |      SA:0xFD5D0000; SIZE:64; UNIT:KB; RegionTZ:Secure; WrAllowed:Read/Write; subsystemId:PMU Firmware     |     SA:0xFD1A0000 ; SIZE:1280; UNIT:KB; RegionTZ:Secure ; WrAllowed:Read/Write; subsystemId:Secure Subsystem} \
   CONFIG.PSU__PROTECTION__LOCK_UNUSED_SEGMENTS {0} \
   CONFIG.PSU__PROTECTION__LPD_SEGMENTS {SA:0xFF980000; SIZE:64; UNIT:KB; RegionTZ:Secure; WrAllowed:Read/Write; subsystemId:PMU Firmware| SA:0xFF5E0000; SIZE:2560; UNIT:KB; RegionTZ:Secure; WrAllowed:Read/Write; subsystemId:PMU Firmware| SA:0xFFCC0000; SIZE:64; UNIT:KB; RegionTZ:Secure; WrAllowed:Read/Write; subsystemId:PMU Firmware| SA:0xFF180000; SIZE:768; UNIT:KB; RegionTZ:Secure; WrAllowed:Read/Write; subsystemId:PMU Firmware| SA:0xFF410000; SIZE:640; UNIT:KB; RegionTZ:Secure; WrAllowed:Read/Write; subsystemId:PMU Firmware| SA:0xFFA70000; SIZE:64; UNIT:KB; RegionTZ:Secure; WrAllowed:Read/Write; subsystemId:PMU Firmware| SA:0xFF9A0000; SIZE:64; UNIT:KB; RegionTZ:Secure; WrAllowed:Read/Write; subsystemId:PMU Firmware|SA:0xFF5E0000 ; SIZE:2560; UNIT:KB; RegionTZ:Secure ; WrAllowed:Read/Write; subsystemId:Secure Subsystem|SA:0xFFCC0000 ; SIZE:64; UNIT:KB; RegionTZ:Secure ; WrAllowed:Read/Write; subsystemId:Secure Subsystem|SA:0xFF180000 ; SIZE:768; UNIT:KB; RegionTZ:Secure ; WrAllowed:Read/Write; subsystemId:Secure Subsystem|SA:0xFF9A0000 ; SIZE:64; UNIT:KB; RegionTZ:Secure ; WrAllowed:Read/Write; subsystemId:Secure Subsystem} \
   CONFIG.PSU__PROTECTION__MASTERS {USB1:NonSecure;0|USB0:NonSecure;1|S_AXI_LPD:NA;0|S_AXI_HPC1_FPD:NA;0|S_AXI_HPC0_FPD:NA;1|S_AXI_HP3_FPD:NA;1|S_AXI_HP2_FPD:NA;1|S_AXI_HP1_FPD:NA;1|S_AXI_HP0_FPD:NA;1|S_AXI_ACP:NA;0|S_AXI_ACE:NA;0|SD1:NonSecure;1|SD0:NonSecure;1|SATA1:NonSecure;0|SATA0:NonSecure;0|RPU1:Secure;1|RPU0:Secure;1|QSPI:NonSecure;1|PMU:NA;1|PCIe:NonSecure;1|NAND:NonSecure;0|LDMA:NonSecure;1|GPU:NonSecure;1|GEM3:NonSecure;1|GEM2:NonSecure;0|GEM1:NonSecure;0|GEM0:NonSecure;1|FDMA:NonSecure;1|DP:NonSecure;1|DAP:NA;1|Coresight:NA;1|CSU:NA;1|APU:NA;1} \
   CONFIG.PSU__PROTECTION__MASTERS_TZ {GEM0:NonSecure|SD1:NonSecure|GEM2:NonSecure|GEM1:NonSecure|GEM3:NonSecure|PCIe:NonSecure|DP:NonSecure|NAND:NonSecure|GPU:NonSecure|USB1:NonSecure|USB0:NonSecure|LDMA:NonSecure|FDMA:NonSecure|QSPI:NonSecure|SD0:NonSecure} \
   CONFIG.PSU__PROTECTION__OCM_SEGMENTS {NONE} \
   CONFIG.PSU__PROTECTION__PRESUBSYSTEMS {NONE} \
   CONFIG.PSU__PROTECTION__SLAVES { \
     LPD;USB3_1_XHCI;FE300000;FE3FFFFF;0|LPD;USB3_1;FF9E0000;FF9EFFFF;0|LPD;USB3_0_XHCI;FE200000;FE2FFFFF;1|LPD;USB3_0;FF9D0000;FF9DFFFF;1|LPD;UART1;FF010000;FF01FFFF;1|LPD;UART0;FF000000;FF00FFFF;1|LPD;TTC3;FF140000;FF14FFFF;1|LPD;TTC2;FF130000;FF13FFFF;1|LPD;TTC1;FF120000;FF12FFFF;1|LPD;TTC0;FF110000;FF11FFFF;1|FPD;SWDT1;FD4D0000;FD4DFFFF;1|LPD;SWDT0;FF150000;FF15FFFF;1|LPD;SPI1;FF050000;FF05FFFF;0|LPD;SPI0;FF040000;FF04FFFF;0|FPD;SMMU_REG;FD5F0000;FD5FFFFF;1|FPD;SMMU;FD800000;FDFFFFFF;1|FPD;SIOU;FD3D0000;FD3DFFFF;1|FPD;SERDES;FD400000;FD47FFFF;1|LPD;SD1;FF170000;FF17FFFF;1|LPD;SD0;FF160000;FF16FFFF;1|FPD;SATA;FD0C0000;FD0CFFFF;0|LPD;RTC;FFA60000;FFA6FFFF;1|LPD;RSA_CORE;FFCE0000;FFCEFFFF;1|LPD;RPU;FF9A0000;FF9AFFFF;1|LPD;R5_TCM_RAM_GLOBAL;FFE00000;FFE3FFFF;1|LPD;R5_1_Instruction_Cache;FFEC0000;FFECFFFF;1|LPD;R5_1_Data_Cache;FFED0000;FFEDFFFF;1|LPD;R5_1_BTCM_GLOBAL;FFEB0000;FFEBFFFF;1|LPD;R5_1_ATCM_GLOBAL;FFE90000;FFE9FFFF;1|LPD;R5_0_Instruction_Cache;FFE40000;FFE4FFFF;1|LPD;R5_0_Data_Cache;FFE50000;FFE5FFFF;1|LPD;R5_0_BTCM_GLOBAL;FFE20000;FFE2FFFF;1|LPD;R5_0_ATCM_GLOBAL;FFE00000;FFE0FFFF;1|LPD;QSPI_Linear_Address;C0000000;DFFFFFFF;1|LPD;QSPI;FF0F0000;FF0FFFFF;1|LPD;PMU_RAM;FFDC0000;FFDDFFFF;1|LPD;PMU_GLOBAL;FFD80000;FFDBFFFF;1|FPD;PCIE_MAIN;FD0E0000;FD0EFFFF;1|FPD;PCIE_LOW;E0000000;EFFFFFFF;1|FPD;PCIE_HIGH2;8000000000;BFFFFFFFFF;1|FPD;PCIE_HIGH1;600000000;7FFFFFFFF;1|FPD;PCIE_DMA;FD0F0000;FD0FFFFF;1|FPD;PCIE_ATTRIB;FD480000;FD48FFFF;1|LPD;OCM_XMPU_CFG;FFA70000;FFA7FFFF;1|LPD;OCM_SLCR;FF960000;FF96FFFF;1|OCM;OCM;FFFC0000;FFFFFFFF;1|LPD;NAND;FF100000;FF10FFFF;0|LPD;MBISTJTAG;FFCF0000;FFCFFFFF;1|LPD;LPD_XPPU_SINK;FF9C0000;FF9CFFFF;1|LPD;LPD_XPPU;FF980000;FF98FFFF;1|LPD;LPD_SLCR_SECURE;FF4B0000;FF4DFFFF;1|LPD;LPD_SLCR;FF410000;FF4AFFFF;1|LPD;LPD_GPV;FE100000;FE1FFFFF;1|LPD;LPD_DMA_7;FFAF0000;FFAFFFFF;1|LPD;LPD_DMA_6;FFAE0000;FFAEFFFF;1|LPD;LPD_DMA_5;FFAD0000;FFADFFFF;1|LPD;LPD_DMA_4;FFAC0000;FFACFFFF;1|LPD;LPD_DMA_3;FFAB0000;FFABFFFF;1|LPD;LPD_DMA_2;FFAA0000;FFAAFFFF;1|LPD;LPD_DMA_1;FFA90000;FFA9FFFF;1|LPD;LPD_DMA_0;FFA80000;FFA8FFFF;1|LPD;IPI_CTRL;FF380000;FF3FFFFF;1|LPD;IOU_SLCR;FF180000;FF23FFFF;1|LPD;IOU_SECURE_SLCR;FF240000;FF24FFFF;1|LPD;IOU_SCNTRS;FF260000;FF26FFFF;1|LPD;IOU_SCNTR;FF250000;FF25FFFF;1|LPD;IOU_GPV;FE000000;FE0FFFFF;1|LPD;I2C1;FF030000;FF03FFFF;1|LPD;I2C0;FF020000;FF02FFFF;1|FPD;GPU;FD4B0000;FD4BFFFF;1|LPD;GPIO;FF0A0000;FF0AFFFF;1|LPD;GEM3;FF0E0000;FF0EFFFF;1|LPD;GEM2;FF0D0000;FF0DFFFF;0|LPD;GEM1;FF0C0000;FF0CFFFF;0|LPD;GEM0;FF0B0000;FF0BFFFF;1|FPD;FPD_XMPU_SINK;FD4F0000;FD4FFFFF;1|FPD;FPD_XMPU_CFG;FD5D0000;FD5DFFFF;1|FPD;FPD_SLCR_SECURE;FD690000;FD6CFFFF;1|FPD;FPD_SLCR;FD610000;FD68FFFF;1|FPD;FPD_DMA_CH7;FD570000;FD57FFFF;1|FPD;FPD_DMA_CH6;FD560000;FD56FFFF;1|FPD;FPD_DMA_CH5;FD550000;FD55FFFF;1|FPD;FPD_DMA_CH4;FD540000;FD54FFFF;1|FPD;FPD_DMA_CH3;FD530000;FD53FFFF;1|FPD;FPD_DMA_CH2;FD520000;FD52FFFF;1|FPD;FPD_DMA_CH1;FD510000;FD51FFFF;1|FPD;FPD_DMA_CH0;FD500000;FD50FFFF;1|LPD;EFUSE;FFCC0000;FFCCFFFF;1|FPD;Display Port;FD4A0000;FD4AFFFF;1|FPD;DPDMA;FD4C0000;FD4CFFFF;1|FPD;DDR_XMPU5_CFG;FD050000;FD05FFFF;1|FPD;DDR_XMPU4_CFG;FD040000;FD04FFFF;1|FPD;DDR_XMPU3_CFG;FD030000;FD03FFFF;1|FPD;DDR_XMPU2_CFG;FD020000;FD02FFFF;1|FPD;DDR_XMPU1_CFG;FD010000;FD01FFFF;1|FPD;DDR_XMPU0_CFG;FD000000;FD00FFFF;1|FPD;DDR_QOS_CTRL;FD090000;FD09FFFF;1|FPD;DDR_PHY;FD080000;FD08FFFF;1|DDR;DDR_LOW;0;7FFFFFFF;1|DDR;DDR_HIGH;800000000;800000000;0|FPD;DDDR_CTRL;FD070000;FD070FFF;1|LPD;Coresight;FE800000;FEFFFFFF;1|LPD;CSU_DMA;FFC80000;FFC9FFFF;1|LPD;CSU;FFCA0000;FFCAFFFF;1|LPD;CRL_APB;FF5E0000;FF85FFFF;1|FPD;CRF_APB;FD1A0000;FD2DFFFF;1|FPD;CCI_REG;FD5E0000;FD5EFFFF;1|LPD;CAN1;FF070000;FF07FFFF;0|LPD;CAN0;FF060000;FF06FFFF;0|FPD;APU;FD5C0000;FD5CFFFF;1|LPD;APM_INTC_IOU;FFA20000;FFA2FFFF;1|LPD;APM_FPD_LPD;FFA30000;FFA3FFFF;1|FPD;APM_5;FD490000;FD49FFFF;1|FPD;APM_0;FD0B0000;FD0BFFFF;1|LPD;APM2;FFA10000;FFA1FFFF;1|LPD;APM1;FFA00000;FFA0FFFF;1|LPD;AMS;FFA50000;FFA5FFFF;1|FPD;AFI_5;FD3B0000;FD3BFFFF;1|FPD;AFI_4;FD3A0000;FD3AFFFF;1|FPD;AFI_3;FD390000;FD39FFFF;1|FPD;AFI_2;FD380000;FD38FFFF;1|FPD;AFI_1;FD370000;FD37FFFF;1|FPD;AFI_0;FD360000;FD36FFFF;1|LPD;AFIFM6;FF9B0000;FF9BFFFF;1|FPD;ACPU_GIC;F9010000;F907FFFF;1 \
   } \
   CONFIG.PSU__PROTECTION__SUBSYSTEMS {PMU Firmware:PMU|Secure Subsystem:} \
   CONFIG.PSU__PSS_ALT_REF_CLK__ENABLE {0} \
   CONFIG.PSU__PSS_ALT_REF_CLK__FREQMHZ {33.333} \
   CONFIG.PSU__PSS_REF_CLK__FREQMHZ {33.333} \
   CONFIG.PSU__QSPI_COHERENCY {0} \
   CONFIG.PSU__QSPI_ROUTE_THROUGH_FPD {0} \
   CONFIG.PSU__QSPI__GRP_FBCLK__ENABLE {0} \
   CONFIG.PSU__QSPI__PERIPHERAL__DATA_MODE {x4} \
   CONFIG.PSU__QSPI__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__QSPI__PERIPHERAL__IO {MIO 0 .. 5} \
   CONFIG.PSU__QSPI__PERIPHERAL__MODE {Single} \
   CONFIG.PSU__REPORT__DBGLOG {0} \
   CONFIG.PSU__RPU_COHERENCY {0} \
   CONFIG.PSU__RPU__POWER__ON {1} \
   CONFIG.PSU__SATA__LANE0__ENABLE {0} \
   CONFIG.PSU__SATA__LANE1__ENABLE {0} \
   CONFIG.PSU__SATA__PERIPHERAL__ENABLE {0} \
   CONFIG.PSU__SAXIGP0__DATA_WIDTH {128} \
   CONFIG.PSU__SAXIGP1__DATA_WIDTH {128} \
   CONFIG.PSU__SAXIGP2__DATA_WIDTH {128} \
   CONFIG.PSU__SAXIGP3__DATA_WIDTH {128} \
   CONFIG.PSU__SAXIGP4__DATA_WIDTH {128} \
   CONFIG.PSU__SAXIGP5__DATA_WIDTH {128} \
   CONFIG.PSU__SAXIGP6__DATA_WIDTH {32} \
   CONFIG.PSU__SD0_COHERENCY {0} \
   CONFIG.PSU__SD0_ROUTE_THROUGH_FPD {0} \
   CONFIG.PSU__SD0__DATA_TRANSFER_MODE {8Bit} \
   CONFIG.PSU__SD0__GRP_CD__ENABLE {0} \
   CONFIG.PSU__SD0__GRP_POW__ENABLE {1} \
   CONFIG.PSU__SD0__GRP_POW__IO {MIO 23} \
   CONFIG.PSU__SD0__GRP_WP__ENABLE {0} \
   CONFIG.PSU__SD0__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__SD0__PERIPHERAL__IO {MIO 13 .. 22} \
   CONFIG.PSU__SD0__RESET__ENABLE {1} \
   CONFIG.PSU__SD0__SLOT_TYPE {eMMC} \
   CONFIG.PSU__SD1_COHERENCY {0} \
   CONFIG.PSU__SD1_ROUTE_THROUGH_FPD {0} \
   CONFIG.PSU__SD1__DATA_TRANSFER_MODE {4Bit} \
   CONFIG.PSU__SD1__GRP_CD__ENABLE {1} \
   CONFIG.PSU__SD1__GRP_CD__IO {MIO 45} \
   CONFIG.PSU__SD1__GRP_POW__ENABLE {0} \
   CONFIG.PSU__SD1__GRP_WP__ENABLE {0} \
   CONFIG.PSU__SD1__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__SD1__PERIPHERAL__IO {MIO 46 .. 51} \
   CONFIG.PSU__SD1__RESET__ENABLE {0} \
   CONFIG.PSU__SD1__SLOT_TYPE {SD 2.0} \
   CONFIG.PSU__SPI0_LOOP_SPI1__ENABLE {0} \
   CONFIG.PSU__SPI0__GRP_SS0__ENABLE {0} \
   CONFIG.PSU__SPI0__GRP_SS1__ENABLE {0} \
   CONFIG.PSU__SPI0__GRP_SS2__ENABLE {0} \
   CONFIG.PSU__SPI0__PERIPHERAL__ENABLE {0} \
   CONFIG.PSU__SPI1__GRP_SS0__ENABLE {0} \
   CONFIG.PSU__SPI1__GRP_SS1__ENABLE {0} \
   CONFIG.PSU__SPI1__GRP_SS2__ENABLE {0} \
   CONFIG.PSU__SPI1__PERIPHERAL__ENABLE {0} \
   CONFIG.PSU__SWDT0__CLOCK__ENABLE {0} \
   CONFIG.PSU__SWDT0__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__SWDT0__PERIPHERAL__IO {NA} \
   CONFIG.PSU__SWDT0__RESET__ENABLE {0} \
   CONFIG.PSU__SWDT1__CLOCK__ENABLE {0} \
   CONFIG.PSU__SWDT1__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__SWDT1__PERIPHERAL__IO {NA} \
   CONFIG.PSU__SWDT1__RESET__ENABLE {0} \
   CONFIG.PSU__TCM0A__POWER__ON {1} \
   CONFIG.PSU__TCM0B__POWER__ON {1} \
   CONFIG.PSU__TCM1A__POWER__ON {1} \
   CONFIG.PSU__TCM1B__POWER__ON {1} \
   CONFIG.PSU__TESTSCAN__PERIPHERAL__ENABLE {0} \
   CONFIG.PSU__TRACE_PIPELINE_WIDTH {8} \
   CONFIG.PSU__TRACE__INTERNAL_WIDTH {32} \
   CONFIG.PSU__TRACE__PERIPHERAL__ENABLE {0} \
   CONFIG.PSU__TRISTATE__INVERTED {1} \
   CONFIG.PSU__TSU__BUFG_PORT_PAIR {0} \
   CONFIG.PSU__TTC0__CLOCK__ENABLE {0} \
   CONFIG.PSU__TTC0__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__TTC0__PERIPHERAL__IO {NA} \
   CONFIG.PSU__TTC0__WAVEOUT__ENABLE {0} \
   CONFIG.PSU__TTC1__CLOCK__ENABLE {0} \
   CONFIG.PSU__TTC1__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__TTC1__PERIPHERAL__IO {NA} \
   CONFIG.PSU__TTC1__WAVEOUT__ENABLE {0} \
   CONFIG.PSU__TTC2__CLOCK__ENABLE {0} \
   CONFIG.PSU__TTC2__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__TTC2__PERIPHERAL__IO {NA} \
   CONFIG.PSU__TTC2__WAVEOUT__ENABLE {0} \
   CONFIG.PSU__TTC3__CLOCK__ENABLE {0} \
   CONFIG.PSU__TTC3__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__TTC3__PERIPHERAL__IO {NA} \
   CONFIG.PSU__TTC3__WAVEOUT__ENABLE {0} \
   CONFIG.PSU__UART0_LOOP_UART1__ENABLE {0} \
   CONFIG.PSU__UART0__BAUD_RATE {115200} \
   CONFIG.PSU__UART0__MODEM__ENABLE {0} \
   CONFIG.PSU__UART0__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__UART0__PERIPHERAL__IO {MIO 42 .. 43} \
   CONFIG.PSU__UART1__BAUD_RATE {115200} \
   CONFIG.PSU__UART1__MODEM__ENABLE {0} \
   CONFIG.PSU__UART1__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__UART1__PERIPHERAL__IO {EMIO} \
   CONFIG.PSU__USB0_COHERENCY {0} \
   CONFIG.PSU__USB0__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__USB0__PERIPHERAL__IO {MIO 52 .. 63} \
   CONFIG.PSU__USB0__REF_CLK_FREQ {26} \
   CONFIG.PSU__USB0__REF_CLK_SEL {Ref Clk1} \
   CONFIG.PSU__USB0__RESET__ENABLE {1} \
   CONFIG.PSU__USB0__RESET__IO {MIO 24} \
   CONFIG.PSU__USB1_COHERENCY {0} \
   CONFIG.PSU__USB1__PERIPHERAL__ENABLE {0} \
   CONFIG.PSU__USB1__RESET__ENABLE {0} \
   CONFIG.PSU__USB2_0__EMIO__ENABLE {0} \
   CONFIG.PSU__USB2_1__EMIO__ENABLE {0} \
   CONFIG.PSU__USB3_0__EMIO__ENABLE {0} \
   CONFIG.PSU__USB3_0__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__USB3_0__PERIPHERAL__IO {GT Lane1} \
   CONFIG.PSU__USB3_1__EMIO__ENABLE {0} \
   CONFIG.PSU__USB3_1__PERIPHERAL__ENABLE {0} \
   CONFIG.PSU__USB__RESET__MODE {Shared MIO Pin} \
   CONFIG.PSU__USB__RESET__POLARITY {Active Low} \
   CONFIG.PSU__USE_DIFF_RW_CLK_GP0 {0} \
   CONFIG.PSU__USE_DIFF_RW_CLK_GP1 {0} \
   CONFIG.PSU__USE_DIFF_RW_CLK_GP2 {0} \
   CONFIG.PSU__USE_DIFF_RW_CLK_GP3 {0} \
   CONFIG.PSU__USE_DIFF_RW_CLK_GP4 {0} \
   CONFIG.PSU__USE_DIFF_RW_CLK_GP5 {0} \
   CONFIG.PSU__USE_DIFF_RW_CLK_GP6 {0} \
   CONFIG.PSU__USE__ADMA {0} \
   CONFIG.PSU__USE__APU_LEGACY_INTERRUPT {0} \
   CONFIG.PSU__USE__AUDIO {0} \
   CONFIG.PSU__USE__CLK {0} \
   CONFIG.PSU__USE__CLK0 {0} \
   CONFIG.PSU__USE__CLK1 {0} \
   CONFIG.PSU__USE__CLK2 {0} \
   CONFIG.PSU__USE__CLK3 {0} \
   CONFIG.PSU__USE__CROSS_TRIGGER {0} \
   CONFIG.PSU__USE__DDR_INTF_REQUESTED {0} \
   CONFIG.PSU__USE__DEBUG__TEST {0} \
   CONFIG.PSU__USE__EVENT_RPU {0} \
   CONFIG.PSU__USE__FABRIC__RST {1} \
   CONFIG.PSU__USE__FTM {0} \
   CONFIG.PSU__USE__GDMA {0} \
   CONFIG.PSU__USE__IRQ {0} \
   CONFIG.PSU__USE__IRQ0 {1} \
   CONFIG.PSU__USE__IRQ1 {1} \
   CONFIG.PSU__USE__M_AXI_GP0 {1} \
   CONFIG.PSU__USE__M_AXI_GP1 {1} \
   CONFIG.PSU__USE__M_AXI_GP2 {0} \
   CONFIG.PSU__USE__PROC_EVENT_BUS {0} \
   CONFIG.PSU__USE__RPU_LEGACY_INTERRUPT {0} \
   CONFIG.PSU__USE__RST0 {0} \
   CONFIG.PSU__USE__RST1 {0} \
   CONFIG.PSU__USE__RST2 {0} \
   CONFIG.PSU__USE__RST3 {0} \
   CONFIG.PSU__USE__RTC {0} \
   CONFIG.PSU__USE__STM {0} \
   CONFIG.PSU__USE__S_AXI_ACE {0} \
   CONFIG.PSU__USE__S_AXI_ACP {0} \
   CONFIG.PSU__USE__S_AXI_GP0 {1} \
   CONFIG.PSU__USE__S_AXI_GP1 {0} \
   CONFIG.PSU__USE__S_AXI_GP2 {1} \
   CONFIG.PSU__USE__S_AXI_GP3 {1} \
   CONFIG.PSU__USE__S_AXI_GP4 {1} \
   CONFIG.PSU__USE__S_AXI_GP5 {1} \
   CONFIG.PSU__USE__S_AXI_GP6 {0} \
   CONFIG.PSU__USE__USB3_0_HUB {0} \
   CONFIG.PSU__USE__USB3_1_HUB {0} \
   CONFIG.PSU__USE__VIDEO {0} \
   CONFIG.PSU__VIDEO_REF_CLK__ENABLE {0} \
   CONFIG.PSU__VIDEO_REF_CLK__FREQMHZ {33.333} \
   CONFIG.QSPI_BOARD_INTERFACE {custom} \
   CONFIG.SATA_BOARD_INTERFACE {custom} \
   CONFIG.SD0_BOARD_INTERFACE {custom} \
   CONFIG.SD1_BOARD_INTERFACE {custom} \
   CONFIG.SPI0_BOARD_INTERFACE {custom} \
   CONFIG.SPI1_BOARD_INTERFACE {custom} \
   CONFIG.SUBPRESET1 {Custom} \
   CONFIG.SUBPRESET2 {Custom} \
   CONFIG.SWDT0_BOARD_INTERFACE {custom} \
   CONFIG.SWDT1_BOARD_INTERFACE {custom} \
   CONFIG.TRACE_BOARD_INTERFACE {custom} \
   CONFIG.TTC0_BOARD_INTERFACE {custom} \
   CONFIG.TTC1_BOARD_INTERFACE {custom} \
   CONFIG.TTC2_BOARD_INTERFACE {custom} \
   CONFIG.TTC3_BOARD_INTERFACE {custom} \
   CONFIG.UART0_BOARD_INTERFACE {custom} \
   CONFIG.UART1_BOARD_INTERFACE {custom} \
   CONFIG.USB0_BOARD_INTERFACE {custom} \
   CONFIG.USB1_BOARD_INTERFACE {custom} \
 ] $zynq_ultra_ps_e_0

  # Create interface connections
  connect_bd_intf_net -intf_net DVI_Transmitter_0_TMDS [get_bd_intf_ports TMDS] [get_bd_intf_pins hdmi_out/TMDS]
  connect_bd_intf_net -intf_net S00_AXI_1 [get_bd_intf_pins axi_interconnect_hp1/S00_AXI] [get_bd_intf_pins mipi_csi2_rx/m_axi_mm_video]
  connect_bd_intf_net -intf_net S01_AXI_1 [get_bd_intf_pins axi_interconnect_hp0/S01_AXI] [get_bd_intf_pins lcd_out/M_AXI_MM2S]
  connect_bd_intf_net -intf_net axi_gpio_0_GPIO [get_bd_intf_ports led] [get_bd_intf_pins axi_gpio_0/GPIO]
  connect_bd_intf_net -intf_net axi_interconnect_0_M01_AXI [get_bd_intf_pins axi_interconnect_0/M01_AXI] [get_bd_intf_pins clk_wiz_0/s_axi_lite]
  connect_bd_intf_net -intf_net axi_interconnect_0_M02_AXI [get_bd_intf_pins axi_interconnect_0/M02_AXI] [get_bd_intf_pins lcd_out/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M03_AXI [get_bd_intf_pins axi_interconnect_0/M03_AXI] [get_bd_intf_pins lcd_out/ctrl]
  connect_bd_intf_net -intf_net axi_interconnect_0_M04_AXI [get_bd_intf_pins axi_interconnect_0/M04_AXI] [get_bd_intf_pins lcd_out/S_AXI_LITE]
  connect_bd_intf_net -intf_net axi_interconnect_0_M05_AXI [get_bd_intf_pins axi_interconnect_0/M05_AXI] [get_bd_intf_pins hdmi_out/ctrl]
  connect_bd_intf_net -intf_net axi_interconnect_0_M06_AXI [get_bd_intf_pins axi_gpio_0/S_AXI] [get_bd_intf_pins axi_interconnect_0/M00_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M06_AXI1 [get_bd_intf_pins axi_interconnect_0/M06_AXI] [get_bd_intf_pins hdmi_out/s_axi_CTRL]
  connect_bd_intf_net -intf_net axi_interconnect_0_M07_AXI [get_bd_intf_pins axi_interconnect_0/M07_AXI] [get_bd_intf_pins lcd_out/PWM_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M08_AXI [get_bd_intf_pins axi_interconnect_0/M08_AXI] [get_bd_intf_pins rest_gpio/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M09_AXI [get_bd_intf_pins axi_interconnect_0/M09_AXI] [get_bd_intf_pins mipi_csi2_rx/csirxss_s_axi]
  connect_bd_intf_net -intf_net axi_interconnect_0_M10_AXI [get_bd_intf_pins axi_interconnect_0/M10_AXI] [get_bd_intf_pins mipi_csi2_rx/s_axi_CTRL]
  connect_bd_intf_net -intf_net axi_interconnect_0_M11_AXI [get_bd_intf_pins axi_interconnect_0/M11_AXI] [get_bd_intf_pins mipi_csi2_rx/s_axi_CTRL1]
  connect_bd_intf_net -intf_net axi_interconnect_0_M12_AXI [get_bd_intf_pins axi_interconnect_0/M12_AXI] [get_bd_intf_pins mipi_csi2_rx/s_axi_ctrl2]
  connect_bd_intf_net -intf_net axi_interconnect_0_M13_AXI [get_bd_intf_pins axi_interconnect_0/M13_AXI] [get_bd_intf_pins mipi_csi2_rx/s_axi_ctrl4]
  connect_bd_intf_net -intf_net axi_interconnect_0_M14_AXI [get_bd_intf_pins axi_interconnect_0/M14_AXI] [get_bd_intf_pins mipi_csi2_rx/s_axi_CTRL3]
  connect_bd_intf_net -intf_net axi_interconnect_0_M15_AXI [get_bd_intf_pins axi_interconnect_0/M15_AXI] [get_bd_intf_pins vcu_0/S_AXI_LITE]
  connect_bd_intf_net -intf_net axi_interconnect_1_M00_AXI [get_bd_intf_pins axi_interconnect_hp0/M00_AXI] [get_bd_intf_pins zynq_ultra_ps_e_0/S_AXI_HP0_FPD]
  connect_bd_intf_net -intf_net axi_interconnect_1_M00_AXI1 [get_bd_intf_pins axi_interconnect_hp1/M00_AXI] [get_bd_intf_pins zynq_ultra_ps_e_0/S_AXI_HP1_FPD]
  connect_bd_intf_net -intf_net axi_interconnect_1_M00_AXI2 [get_bd_intf_pins axi_interconnect_1/M00_AXI] [get_bd_intf_pins zynq_ultra_ps_e_0/S_AXI_HP2_FPD]
  connect_bd_intf_net -intf_net axi_interconnect_2_M00_AXI [get_bd_intf_pins axi_interconnect_2/M00_AXI] [get_bd_intf_pins zynq_ultra_ps_e_0/S_AXI_HP3_FPD]
  connect_bd_intf_net -intf_net axi_interconnect_3_M00_AXI [get_bd_intf_pins axi_interconnect_3/M00_AXI] [get_bd_intf_pins zynq_ultra_ps_e_0/S_AXI_HPC0_FPD]
  connect_bd_intf_net -intf_net ddr4_0_C0_DDR4 [get_bd_intf_ports ddr4] [get_bd_intf_pins ddr4_0/C0_DDR4]
  connect_bd_intf_net -intf_net diff_clock_rtl_0_1 [get_bd_intf_ports C0_SYS_CLK] [get_bd_intf_pins ddr4_0/C0_SYS_CLK]
  connect_bd_intf_net -intf_net gmii2rgmii_0_RGMII [get_bd_intf_ports RGMII] [get_bd_intf_pins vendor_gmii/RGMII]
  connect_bd_intf_net -intf_net hdmi_out_M_AXI_MM2S [get_bd_intf_pins axi_interconnect_hp0/S00_AXI] [get_bd_intf_pins hdmi_out/M_AXI_MM2S]
  connect_bd_intf_net -intf_net mipi_phy_if_0_1 [get_bd_intf_ports mipi_phy_if_0] [get_bd_intf_pins mipi_csi2_rx/mipi_phy_if_0]
  connect_bd_intf_net -intf_net nlos_link_M01_AXI [get_bd_intf_pins nlos_compute/S_AXI] [get_bd_intf_pins nlos_link/M01_AXI]
  connect_bd_intf_net -intf_net rgb2lcd_0_lcd [get_bd_intf_ports lcd] [get_bd_intf_pins lcd_out/lcd]
  connect_bd_intf_net -intf_net rgb2lcd_0_lcd_rgb [get_bd_intf_ports lcd_rgb] [get_bd_intf_pins lcd_out/lcd_rgb]
  connect_bd_intf_net -intf_net vcu_0_M_AXI_DEC0 [get_bd_intf_pins axi_interconnect_2/S00_AXI] [get_bd_intf_pins vcu_0/M_AXI_DEC0]
  connect_bd_intf_net -intf_net vcu_0_M_AXI_DEC1 [get_bd_intf_pins axi_interconnect_2/S01_AXI] [get_bd_intf_pins vcu_0/M_AXI_DEC1]
  connect_bd_intf_net -intf_net vcu_0_M_AXI_ENC0 [get_bd_intf_pins axi_interconnect_1/S00_AXI] [get_bd_intf_pins vcu_0/M_AXI_ENC0]
  connect_bd_intf_net -intf_net vcu_0_M_AXI_ENC1 [get_bd_intf_pins axi_interconnect_1/S01_AXI] [get_bd_intf_pins vcu_0/M_AXI_ENC1]
  connect_bd_intf_net -intf_net vcu_0_M_AXI_MCU [get_bd_intf_pins axi_interconnect_3/S00_AXI] [get_bd_intf_pins vcu_0/M_AXI_MCU]
  connect_bd_intf_net -intf_net vendor_gmii_MDIO_PHY [get_bd_intf_ports MDIO] [get_bd_intf_pins vendor_gmii/MDIO_PHY]
  connect_bd_intf_net -intf_net zynq_ultra_ps_e_0_GMII_ENET0 [get_bd_intf_pins vendor_gmii/GMII] [get_bd_intf_pins zynq_ultra_ps_e_0/GMII_ENET0]
  connect_bd_intf_net -intf_net zynq_ultra_ps_e_0_GPIO_0 [get_bd_intf_ports GPIO] [get_bd_intf_pins zynq_ultra_ps_e_0/GPIO_0]
  connect_bd_intf_net -intf_net zynq_ultra_ps_e_0_IIC_0 [get_bd_intf_ports lcd_touch_e2p] [get_bd_intf_pins zynq_ultra_ps_e_0/IIC_0]
  connect_bd_intf_net -intf_net zynq_ultra_ps_e_0_IIC_1 [get_bd_intf_ports mipi_hdmi] [get_bd_intf_pins zynq_ultra_ps_e_0/IIC_1]
  connect_bd_intf_net -intf_net zynq_ultra_ps_e_0_MDIO_ENET0 [get_bd_intf_pins vendor_gmii/MDIO_GEM] [get_bd_intf_pins zynq_ultra_ps_e_0/MDIO_ENET0]
  connect_bd_intf_net -intf_net zynq_ultra_ps_e_0_M_AXI_HPM0_FPD [get_bd_intf_pins axi_interconnect_0/S00_AXI] [get_bd_intf_pins nlos_link/M00_AXI]
  connect_bd_intf_net -intf_net zynq_ultra_ps_e_0_M_AXI_HPM0_FPD1 [get_bd_intf_pins nlos_link/S00_AXI] [get_bd_intf_pins zynq_ultra_ps_e_0/M_AXI_HPM0_FPD]
  connect_bd_intf_net -intf_net zynq_ultra_ps_e_0_M_AXI_HPM1_FPD [get_bd_intf_pins ddr4_0/C0_DDR4_S_AXI] [get_bd_intf_pins zynq_ultra_ps_e_0/M_AXI_HPM1_FPD]
  connect_bd_intf_net -intf_net zynq_ultra_ps_e_0_UART_1 [get_bd_intf_ports UART] [get_bd_intf_pins zynq_ultra_ps_e_0/UART_1]

  # Create port connections
  connect_bd_net -net axi_gpio_1_gpio_io_o [get_bd_pins hdmi_out/Din] [get_bd_pins lcd_out/Din] [get_bd_pins mipi_csi2_rx/Din] [get_bd_pins rest_gpio/gpio_io_o] [get_bd_pins xlslice_0/Din]
  connect_bd_net -net clk_wiz_0_clk_out1 [get_bd_pins axi_interconnect_0/M04_ACLK] [get_bd_pins axi_interconnect_hp0/S01_ACLK] [get_bd_pins clk_wiz_0/clk_out1] [get_bd_pins lcd_out/pixel_clk] [get_bd_pins rst_hier/slowest_sync_clk]
  connect_bd_net -net clk_wiz_0_clk_out2 [get_bd_pins axi_interconnect_hp0/M00_ACLK] [get_bd_pins clk_wiz_0/clk_out2] [get_bd_pins rst_hier/slowest_sync_clk2] [get_bd_pins zynq_ultra_ps_e_0/saxihp0_fpd_aclk]
  connect_bd_net -net clk_wiz_0_clk_out3 [get_bd_pins clk_wiz_0/clk_out3]
  connect_bd_net -net clk_wiz_0_clk_out4 [get_bd_pins clk_wiz_0/clk_out4] [get_bd_pins hdmi_shared/raw_clock]
  connect_bd_net -net clk_wiz_0_locked [get_bd_pins clk_wiz_0/locked] [get_bd_pins hdmi_pixel_reset/dcm_locked] [get_bd_pins hdmi_shared/locked] [get_bd_pins rst_hier/ext_reset_in]
  connect_bd_net -net clk_wiz_1_clk_out1 [get_bd_pins clk_wiz_1/clk_out1] [get_bd_pins vcu_0/pll_ref_clk]
  connect_bd_net -net ddr4_0_addn_ui_clkout1 [get_bd_pins ddr4_0/addn_ui_clkout1] [get_bd_pins mipi_csi2_rx/dphy_clk_200M]
  connect_bd_net -net ddr4_0_c0_ddr4_ui_clk [get_bd_pins ddr4_0/c0_ddr4_ui_clk] [get_bd_pins rst_hier/slowest_sync_clk4] [get_bd_pins zynq_ultra_ps_e_0/maxihpm1_fpd_aclk]
  connect_bd_net -net ddr4_0_c0_ddr4_ui_clk_sync_rst [get_bd_pins ddr4_0/c0_ddr4_ui_clk_sync_rst] [get_bd_pins rst_hier/ext_reset_in2]
  connect_bd_net -net hdmi_pixel_reset_peripheral_aresetn [get_bd_pins axi_interconnect_0/M06_ARESETN] [get_bd_pins axi_interconnect_hp0/S00_ARESETN] [get_bd_pins hdmi_out/aresetn] [get_bd_pins hdmi_pixel_reset/peripheral_aresetn]
  connect_bd_net -net hdmi_reset_zero_dout [get_bd_pins hdmi_pixel_reset/mb_debug_sys_rst] [get_bd_pins hdmi_reset_zero/dout]
  connect_bd_net -net hdmi_shared_fast_clock [get_bd_pins hdmi_out/pixel_clk_5x] [get_bd_pins hdmi_shared/fast_clock]
  connect_bd_net -net hdmi_shared_pixel_clock [get_bd_pins axi_interconnect_0/M06_ACLK] [get_bd_pins axi_interconnect_hp0/S00_ACLK] [get_bd_pins hdmi_out/pclk] [get_bd_pins hdmi_pixel_reset/slowest_sync_clk] [get_bd_pins hdmi_shared/pixel_clock]
  connect_bd_net -net hdmi_shared_slow_clock [get_bd_pins hdmi_out/pixel_clk_2_5x] [get_bd_pins hdmi_shared/slow_clock]
  connect_bd_net -net hdmi_vdma_mm2s_introut [get_bd_pins hdmi_out/mm2s_introut] [get_bd_pins xlconcat_0/In0]
  connect_bd_net -net hdmi_vtc_irq [get_bd_pins hdmi_out/irq] [get_bd_pins xlconcat_0/In2]
  connect_bd_net -net lcd_vdma_mm2s_introut [get_bd_pins lcd_out/mm2s_introut] [get_bd_pins xlconcat_0/In1]
  connect_bd_net -net lcd_vtc_irq [get_bd_pins lcd_out/irq] [get_bd_pins xlconcat_0/In3]
  connect_bd_net -net mipi_csi2_rx_csirxss_csi_irq [get_bd_pins mipi_csi2_rx/csirxss_csi_irq] [get_bd_pins xlconcat_0/In5]
  connect_bd_net -net mipi_csi2_rx_interrupt [get_bd_pins mipi_csi2_rx/interrupt] [get_bd_pins xlconcat_0/In4]
  connect_bd_net -net nlos_one_dout [get_bd_pins hdmi_pixel_reset/aux_reset_in] [get_bd_pins nlos_one/dout] [get_bd_pins nlos_reset/aux_reset_in] [get_bd_pins nlos_reset/dcm_locked]
  connect_bd_net -net nlos_reset_interconnect_aresetn [get_bd_pins nlos_link/aresetn] [get_bd_pins nlos_reset/interconnect_aresetn]
  connect_bd_net -net nlos_reset_peripheral_aresetn [get_bd_pins nlos_compute/aresetn] [get_bd_pins nlos_reset/peripheral_aresetn]
  connect_bd_net -net nlos_reset_peripheral_reset [get_bd_pins nlos_reset/peripheral_reset] [get_bd_pins vendor_gmii/rx_reset] [get_bd_pins vendor_gmii/tx_reset]
  connect_bd_net -net nlos_zero_dout [get_bd_pins nlos_reset/mb_debug_sys_rst] [get_bd_pins nlos_zero/dout]
  connect_bd_net -net rgb2lcd_0_lcd_bl [get_bd_ports lcd_bl] [get_bd_pins lcd_out/lcd_bl]
  connect_bd_net -net rgb2lcd_0_lcd_rst [get_bd_ports lcd_rst] [get_bd_pins lcd_out/lcd_rst]
  connect_bd_net -net rst_clk_wiz_0_148M_peripheral_aresetn [get_bd_pins axi_interconnect_hp0/M00_ARESETN] [get_bd_pins rst_hier/peripheral_aresetn2]
  connect_bd_net -net rst_clk_wiz_0_33M_peripheral_aresetn [get_bd_pins axi_interconnect_0/M04_ARESETN] [get_bd_pins axi_interconnect_hp0/S01_ARESETN] [get_bd_pins lcd_out/aresetn] [get_bd_pins rst_hier/peripheral_aresetn]
  connect_bd_net -net rst_ddr4_0_266M_peripheral_aresetn [get_bd_pins ddr4_0/c0_ddr4_aresetn] [get_bd_pins rst_hier/peripheral_aresetn4]
  connect_bd_net -net rst_gen_reg_peripheral_reset [get_bd_pins ddr4_0/sys_rst] [get_bd_pins rst_hier/peripheral_reset]
  connect_bd_net -net rst_ps8_0_299M_peripheral_aresetn [get_bd_pins axi_interconnect_0/M10_ARESETN] [get_bd_pins axi_interconnect_0/M11_ARESETN] [get_bd_pins axi_interconnect_0/M12_ARESETN] [get_bd_pins axi_interconnect_0/M13_ARESETN] [get_bd_pins axi_interconnect_0/M14_ARESETN] [get_bd_pins axi_interconnect_1/ARESETN] [get_bd_pins axi_interconnect_1/M00_ARESETN] [get_bd_pins axi_interconnect_1/S00_ARESETN] [get_bd_pins axi_interconnect_1/S01_ARESETN] [get_bd_pins axi_interconnect_2/ARESETN] [get_bd_pins axi_interconnect_2/M00_ARESETN] [get_bd_pins axi_interconnect_2/S00_ARESETN] [get_bd_pins axi_interconnect_2/S01_ARESETN] [get_bd_pins axi_interconnect_3/S00_ARESETN] [get_bd_pins axi_interconnect_hp1/M00_ARESETN] [get_bd_pins axi_interconnect_hp1/S00_ARESETN] [get_bd_pins mipi_csi2_rx/aresetn] [get_bd_pins rst_hier/peripheral_aresetn3]
  connect_bd_net -net rst_ps8_0_99M_1_peripheral_aresetn [get_bd_pins axi_gpio_0/s_axi_aresetn] [get_bd_pins axi_interconnect_0/ARESETN] [get_bd_pins axi_interconnect_0/M00_ARESETN] [get_bd_pins axi_interconnect_0/M01_ARESETN] [get_bd_pins axi_interconnect_0/M02_ARESETN] [get_bd_pins axi_interconnect_0/M03_ARESETN] [get_bd_pins axi_interconnect_0/M05_ARESETN] [get_bd_pins axi_interconnect_0/M07_ARESETN] [get_bd_pins axi_interconnect_0/M08_ARESETN] [get_bd_pins axi_interconnect_0/M09_ARESETN] [get_bd_pins axi_interconnect_0/M15_ARESETN] [get_bd_pins axi_interconnect_0/S00_ARESETN] [get_bd_pins axi_interconnect_3/ARESETN] [get_bd_pins axi_interconnect_3/M00_ARESETN] [get_bd_pins axi_interconnect_hp0/ARESETN] [get_bd_pins axi_interconnect_hp1/ARESETN] [get_bd_pins clk_wiz_0/s_axi_aresetn] [get_bd_pins hdmi_out/axi_resetn] [get_bd_pins lcd_out/s_axi_aresetn] [get_bd_pins mipi_csi2_rx/lite_aresetn] [get_bd_pins rest_gpio/s_axi_aresetn] [get_bd_pins rst_hier/peripheral_aresetn1]
  connect_bd_net -net vcu_0_vcu_host_interrupt [get_bd_pins vcu_0/vcu_host_interrupt] [get_bd_pins xlconcat_1/In0]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins xlconcat_0/dout] [get_bd_pins zynq_ultra_ps_e_0/pl_ps_irq0]
  connect_bd_net -net xlconcat_1_dout [get_bd_pins xlconcat_1/dout] [get_bd_pins zynq_ultra_ps_e_0/pl_ps_irq1]
  connect_bd_net -net xlslice_0_Dout [get_bd_pins vcu_0/vcu_resetn] [get_bd_pins xlslice_0/Dout]
  connect_bd_net -net zynq_ultra_ps_e_0_pl_clk0 [get_bd_pins axi_gpio_0/s_axi_aclk] [get_bd_pins axi_interconnect_0/ACLK] [get_bd_pins axi_interconnect_0/M00_ACLK] [get_bd_pins axi_interconnect_0/M01_ACLK] [get_bd_pins axi_interconnect_0/M02_ACLK] [get_bd_pins axi_interconnect_0/M03_ACLK] [get_bd_pins axi_interconnect_0/M05_ACLK] [get_bd_pins axi_interconnect_0/M07_ACLK] [get_bd_pins axi_interconnect_0/M08_ACLK] [get_bd_pins axi_interconnect_0/M09_ACLK] [get_bd_pins axi_interconnect_0/M15_ACLK] [get_bd_pins axi_interconnect_0/S00_ACLK] [get_bd_pins axi_interconnect_3/ACLK] [get_bd_pins axi_interconnect_3/M00_ACLK] [get_bd_pins axi_interconnect_hp0/ACLK] [get_bd_pins axi_interconnect_hp1/ACLK] [get_bd_pins clk_wiz_0/clk_in1] [get_bd_pins clk_wiz_0/s_axi_aclk] [get_bd_pins clk_wiz_1/clk_in1] [get_bd_pins hdmi_out/s_axi_lite_aclk] [get_bd_pins lcd_out/s_axi_aclk] [get_bd_pins mipi_csi2_rx/lite_aclk] [get_bd_pins nlos_compute/aclk] [get_bd_pins nlos_link/aclk] [get_bd_pins nlos_reset/slowest_sync_clk] [get_bd_pins rest_gpio/s_axi_aclk] [get_bd_pins rst_hier/slowest_sync_clk1] [get_bd_pins vcu_0/s_axi_lite_aclk] [get_bd_pins zynq_ultra_ps_e_0/maxihpm0_fpd_aclk] [get_bd_pins zynq_ultra_ps_e_0/pl_clk0] [get_bd_pins zynq_ultra_ps_e_0/saxihpc0_fpd_aclk]
  connect_bd_net -net zynq_ultra_ps_e_0_pl_clk1 [get_bd_pins vendor_gmii/clkin] [get_bd_pins zynq_ultra_ps_e_0/pl_clk1]
  connect_bd_net -net zynq_ultra_ps_e_0_pl_clk2 [get_bd_ports cam_clk] [get_bd_pins zynq_ultra_ps_e_0/pl_clk2]
  connect_bd_net -net zynq_ultra_ps_e_0_pl_clk3 [get_bd_pins axi_interconnect_0/M10_ACLK] [get_bd_pins axi_interconnect_0/M11_ACLK] [get_bd_pins axi_interconnect_0/M12_ACLK] [get_bd_pins axi_interconnect_0/M13_ACLK] [get_bd_pins axi_interconnect_0/M14_ACLK] [get_bd_pins axi_interconnect_1/ACLK] [get_bd_pins axi_interconnect_1/M00_ACLK] [get_bd_pins axi_interconnect_1/S00_ACLK] [get_bd_pins axi_interconnect_1/S01_ACLK] [get_bd_pins axi_interconnect_2/ACLK] [get_bd_pins axi_interconnect_2/M00_ACLK] [get_bd_pins axi_interconnect_2/S00_ACLK] [get_bd_pins axi_interconnect_2/S01_ACLK] [get_bd_pins axi_interconnect_3/S00_ACLK] [get_bd_pins axi_interconnect_hp1/M00_ACLK] [get_bd_pins axi_interconnect_hp1/S00_ACLK] [get_bd_pins mipi_csi2_rx/aclk_axis] [get_bd_pins rst_hier/slowest_sync_clk3] [get_bd_pins vcu_0/m_axi_dec_aclk] [get_bd_pins vcu_0/m_axi_enc_aclk] [get_bd_pins vcu_0/m_axi_mcu_aclk] [get_bd_pins zynq_ultra_ps_e_0/pl_clk3] [get_bd_pins zynq_ultra_ps_e_0/saxihp1_fpd_aclk] [get_bd_pins zynq_ultra_ps_e_0/saxihp2_fpd_aclk] [get_bd_pins zynq_ultra_ps_e_0/saxihp3_fpd_aclk]
  connect_bd_net -net zynq_ultra_ps_e_0_pl_resetn0 [get_bd_pins clk_wiz_1/resetn] [get_bd_pins hdmi_pixel_reset/ext_reset_in] [get_bd_pins nlos_reset/ext_reset_in] [get_bd_pins rst_hier/ext_reset_in1] [get_bd_pins zynq_ultra_ps_e_0/pl_resetn0]

  # Create address segments
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces vcu_0/EncData0] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_DDR_LOW] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces vcu_0/EncData1] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_DDR_LOW] -force
  assign_bd_address -offset 0xFF000000 -range 0x01000000 -target_address_space [get_bd_addr_spaces vcu_0/EncData0] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_LPS_OCM] -force
  assign_bd_address -offset 0xFF000000 -range 0x01000000 -target_address_space [get_bd_addr_spaces vcu_0/EncData1] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_LPS_OCM] -force
  assign_bd_address -offset 0xE0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces vcu_0/EncData0] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_PCIE_LOW] -force
  assign_bd_address -offset 0xE0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces vcu_0/EncData1] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_PCIE_LOW] -force
  assign_bd_address -offset 0xC0000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces vcu_0/EncData0] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_QSPI] -force
  assign_bd_address -offset 0xC0000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces vcu_0/EncData1] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_QSPI] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces vcu_0/DecData0] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_DDR_LOW] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces vcu_0/DecData1] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_DDR_LOW] -force
  assign_bd_address -offset 0xFF000000 -range 0x01000000 -target_address_space [get_bd_addr_spaces vcu_0/DecData0] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_LPS_OCM] -force
  assign_bd_address -offset 0xFF000000 -range 0x01000000 -target_address_space [get_bd_addr_spaces vcu_0/DecData1] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_LPS_OCM] -force
  assign_bd_address -offset 0xE0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces vcu_0/DecData0] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_PCIE_LOW] -force
  assign_bd_address -offset 0xE0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces vcu_0/DecData1] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_PCIE_LOW] -force
  assign_bd_address -offset 0xC0000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces vcu_0/DecData0] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_QSPI] -force
  assign_bd_address -offset 0xC0000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces vcu_0/DecData1] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_QSPI] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces vcu_0/Code] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP0/HPC0_DDR_LOW] -force
  assign_bd_address -offset 0xFF000000 -range 0x01000000 -target_address_space [get_bd_addr_spaces vcu_0/Code] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP0/HPC0_LPS_OCM] -force
  assign_bd_address -offset 0xE0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces vcu_0/Code] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP0/HPC0_PCIE_LOW] -force
  assign_bd_address -offset 0xC0000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces vcu_0/Code] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP0/HPC0_QSPI] -force
  assign_bd_address -offset 0xA0070000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs lcd_out/PWM_0/PWM_AXI/PWM_AXI_reg] -force
  assign_bd_address -offset 0xA0020000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_gpio_0/S_AXI/Reg] -force
  assign_bd_address -offset 0xA0030000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs clk_wiz_0/s_axi_lite/Reg] -force
  assign_bd_address -offset 0x000500000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs ddr4_0/C0_DDR4_MEMORY_MAP/C0_DDR4_ADDRESS_BLOCK] -force
  assign_bd_address -offset 0xA0050000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs hdmi_out/hdmi_vtc/ctrl/Reg] -force
  assign_bd_address -offset 0xA0080000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs lcd_out/lcd_frmbuf_rd/s_axi_CTRL/Reg] -force
  assign_bd_address -offset 0xA0090000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs lcd_out/lcd_id/S_AXI/Reg] -force
  assign_bd_address -offset 0xA00A0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs lcd_out/lcd_vtc/ctrl/Reg] -force
  assign_bd_address -offset 0xA0000000 -range 0x00020000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs mipi_csi2_rx/mipi_csi2_rx_subsyst_0/csirxss_s_axi/Reg] -force
  assign_bd_address -offset 0xA1000000 -range 0x00001000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs nlos_compute/S_AXI/reg0] -force
  assign_bd_address -offset 0xA00E0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs rest_gpio/S_AXI/Reg] -force
  assign_bd_address -offset 0xA00B0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs mipi_csi2_rx/v_demosaic_0/s_axi_CTRL/Reg] -force
  assign_bd_address -offset 0xA0060000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs hdmi_out/v_frmbuf_rd_0/s_axi_CTRL/Reg] -force
  assign_bd_address -offset 0xA00C0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs mipi_csi2_rx/v_frmbuf_wr_0/s_axi_CTRL/Reg] -force
  assign_bd_address -offset 0xA00D0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs mipi_csi2_rx/v_gamma_lut_0/s_axi_CTRL/Reg] -force
  assign_bd_address -offset 0xA0100000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs mipi_csi2_rx/v_proc_ss_csc/s_axi_ctrl/Reg] -force
  assign_bd_address -offset 0xA0140000 -range 0x00040000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs mipi_csi2_rx/v_proc_ss_scaler/s_axi_ctrl/Reg] -force
  assign_bd_address -offset 0xA0200000 -range 0x00100000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs vcu_0/S_AXI_LITE/Reg] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces hdmi_out/v_frmbuf_rd_0/Data_m_axi_mm_video] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_DDR_LOW] -force
  assign_bd_address -offset 0xE0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces hdmi_out/v_frmbuf_rd_0/Data_m_axi_mm_video] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_PCIE_LOW] -force
  assign_bd_address -offset 0xC0000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces hdmi_out/v_frmbuf_rd_0/Data_m_axi_mm_video] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_QSPI] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces lcd_out/lcd_frmbuf_rd/Data_m_axi_mm_video] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_DDR_LOW] -force
  assign_bd_address -offset 0xE0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces lcd_out/lcd_frmbuf_rd/Data_m_axi_mm_video] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_PCIE_LOW] -force
  assign_bd_address -offset 0xC0000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces lcd_out/lcd_frmbuf_rd/Data_m_axi_mm_video] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_QSPI] -force
  assign_bd_address -offset 0x40000000 -range 0x40000000 -target_address_space [get_bd_addr_spaces mipi_csi2_rx/v_frmbuf_wr_0/Data_m_axi_mm_video] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_DDR_LOW] -force
  assign_bd_address -offset 0xE0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces mipi_csi2_rx/v_frmbuf_wr_0/Data_m_axi_mm_video] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_PCIE_LOW] -force
  assign_bd_address -offset 0xC0000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces mipi_csi2_rx/v_frmbuf_wr_0/Data_m_axi_mm_video] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_QSPI] -force


  # Restore current instance
  current_bd_instance $oldCurInst

  validate_bd_design
  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


