set_property PACKAGE_PIN AB5 [get_ports {ddr4_adr[16]}]
set_property PACKAGE_PIN AB7 [get_ports {ddr4_adr[15]}]
set_property PACKAGE_PIN AF6 [get_ports {ddr4_adr[14]}]
set_property PACKAGE_PIN AD9 [get_ports {ddr4_adr[13]}]
set_property PACKAGE_PIN AC6 [get_ports {ddr4_adr[12]}]
set_property PACKAGE_PIN AH9 [get_ports {ddr4_adr[11]}]
set_property PACKAGE_PIN AE7 [get_ports {ddr4_adr[10]}]
set_property PACKAGE_PIN AC9 [get_ports {ddr4_adr[9]}]
set_property PACKAGE_PIN AH8 [get_ports {ddr4_adr[8]}]
set_property PACKAGE_PIN AE9 [get_ports {ddr4_adr[7]}]
set_property PACKAGE_PIN AH7 [get_ports {ddr4_adr[6]}]
set_property PACKAGE_PIN AD7 [get_ports {ddr4_adr[5]}]
set_property PACKAGE_PIN AF7 [get_ports {ddr4_adr[4]}]
set_property PACKAGE_PIN AC8 [get_ports {ddr4_adr[3]}]
set_property PACKAGE_PIN AF8 [get_ports {ddr4_adr[2]}]
set_property PACKAGE_PIN AB8 [get_ports {ddr4_adr[1]}]
set_property PACKAGE_PIN AG8 [get_ports {ddr4_adr[0]}]
set_property PACKAGE_PIN AC4 [get_ports {ddr4_dq[15]}]
set_property PACKAGE_PIN AC3 [get_ports {ddr4_dq[14]}]
set_property PACKAGE_PIN AB4 [get_ports {ddr4_dq[13]}]
set_property PACKAGE_PIN AB3 [get_ports {ddr4_dq[12]}]
set_property PACKAGE_PIN AB2 [get_ports {ddr4_dq[11]}]
set_property PACKAGE_PIN AC2 [get_ports {ddr4_dq[10]}]
set_property PACKAGE_PIN AB1 [get_ports {ddr4_dq[9]}]
set_property PACKAGE_PIN AC1 [get_ports {ddr4_dq[8]}]
set_property PACKAGE_PIN AG3 [get_ports {ddr4_dq[7]}]
set_property PACKAGE_PIN AH3 [get_ports {ddr4_dq[6]}]
set_property PACKAGE_PIN AE3 [get_ports {ddr4_dq[5]}]
set_property PACKAGE_PIN AF3 [get_ports {ddr4_dq[4]}]
set_property PACKAGE_PIN AH2 [get_ports {ddr4_dq[3]}]
set_property PACKAGE_PIN AH1 [get_ports {ddr4_dq[2]}]
set_property PACKAGE_PIN AF1 [get_ports {ddr4_dq[1]}]
set_property PACKAGE_PIN AG1 [get_ports {ddr4_dq[0]}]
set_property PACKAGE_PIN AD2 [get_ports {ddr4_dqs_t[1]}]
set_property PACKAGE_PIN AE2 [get_ports {ddr4_dqs_t[0]}]
set_property PACKAGE_PIN AH4 [get_ports {ddr4_odt[0]}]
set_property PACKAGE_PIN AD4 [get_ports ddr4_act_n]
set_property PACKAGE_PIN AG9 [get_ports ddr4_reset_n]
set_property PACKAGE_PIN AC7 [get_ports {ddr4_ba[1]}]
set_property PACKAGE_PIN AH6 [get_ports {ddr4_ba[0]}]
set_property PACKAGE_PIN AE8 [get_ports {ddr4_bg[0]}]
set_property PACKAGE_PIN AG6 [get_ports {ddr4_ck_t[0]}]
set_property PACKAGE_PIN AE4 [get_ports {ddr4_cke[0]}]
set_property PACKAGE_PIN AB6 [get_ports {ddr4_cs_n[0]}]
set_property PACKAGE_PIN AD5 [get_ports {ddr4_dm_n[1]}]
set_property PACKAGE_PIN AG4 [get_ports {ddr4_dm_n[0]}]
set_property PACKAGE_PIN AE5 [get_ports C0_SYS_CLK_clk_p]

#***************************PL ETH********************************
set_property -dict {PACKAGE_PIN E7 IOSTANDARD LVCMOS18} [get_ports MDIO_mdc]
set_property -dict {PACKAGE_PIN C7 IOSTANDARD LVCMOS18} [get_ports MDIO_mdio_io]

set_property -dict {PACKAGE_PIN F7 IOSTANDARD LVCMOS18} [get_ports {RGMII_rd[3]}]
set_property -dict {PACKAGE_PIN G8 IOSTANDARD LVCMOS18} [get_ports {RGMII_rd[2]}]
set_property -dict {PACKAGE_PIN F6 IOSTANDARD LVCMOS18} [get_ports {RGMII_rd[1]}]
set_property -dict {PACKAGE_PIN G6 IOSTANDARD LVCMOS18} [get_ports {RGMII_rd[0]}]
set_property -dict {PACKAGE_PIN D9 IOSTANDARD LVCMOS18} [get_ports {RGMII_td[3]}]
set_property -dict {PACKAGE_PIN E9 IOSTANDARD LVCMOS18} [get_ports {RGMII_td[2]}]
set_property -dict {PACKAGE_PIN E8 IOSTANDARD LVCMOS18} [get_ports {RGMII_td[1]}]
set_property -dict {PACKAGE_PIN D7 IOSTANDARD LVCMOS18} [get_ports {RGMII_td[0]}]
set_property -dict {PACKAGE_PIN E5 IOSTANDARD LVCMOS18} [get_ports RGMII_rxc]
set_property -dict {PACKAGE_PIN D5 IOSTANDARD LVCMOS18} [get_ports RGMII_rx_ctl]
set_property -dict {PACKAGE_PIN F8 IOSTANDARD LVCMOS18} [get_ports RGMII_tx_ctl]
set_property -dict {PACKAGE_PIN D6 IOSTANDARD LVCMOS18} [get_ports RGMII_txc]

#*************************** PL UART ********************************
set_property -dict {PACKAGE_PIN AB9 IOSTANDARD LVCMOS33} [get_ports UART_rxd]
set_property -dict {PACKAGE_PIN AB10 IOSTANDARD LVCMOS33} [get_ports UART_txd]

#*************************** PL led ********************************
set_property -dict {PACKAGE_PIN AF10 IOSTANDARD LVCMOS33} [get_ports {led_tri_o[1]}]
set_property -dict {PACKAGE_PIN AE10 IOSTANDARD LVCMOS33} [get_ports {led_tri_o[0]}]

#*************************** hdmi & cam iic ********************************
set_property -dict {PACKAGE_PIN G5 IOSTANDARD LVCMOS18} [get_ports mipi_hdmi_scl_io]
set_property -dict {PACKAGE_PIN F5 IOSTANDARD LVCMOS18} [get_ports mipi_hdmi_sda_io]

#CAM_clk
set_property -dict {PACKAGE_PIN E4 IOSTANDARD LVCMOS18} [get_ports cam_clk]
#CAM RST 84
set_property -dict {PACKAGE_PIN E3 IOSTANDARD LVCMOS18} [get_ports {GPIO_tri_io[6]}]
#CAM PWDN 85
set_property -dict {PACKAGE_PIN D2 IOSTANDARD LVCMOS18} [get_ports {GPIO_tri_io[7]}]

#*************************** GPIO ********************************
#KEY 78-79
set_property -dict {PACKAGE_PIN AD11 IOSTANDARD LVCMOS33} [get_ports {GPIO_tri_io[0]}]
set_property -dict {PACKAGE_PIN AD10 IOSTANDARD LVCMOS33} [get_ports {GPIO_tri_io[1]}]

#FAN PWM 80
set_property -dict {PACKAGE_PIN AC12 IOSTANDARD LVCMOS33} [get_ports {GPIO_tri_io[2]}]
#PL rst 81
set_property -dict {PACKAGE_PIN AH11 IOSTANDARD LVCMOS33} [get_ports {GPIO_tri_io[3]}]
#hdmi hpd 86
set_property -dict {PACKAGE_PIN T6 IOSTANDARD SSTL12} [get_ports {GPIO_tri_io[8]}]
# HPD SSTL12 needs an internal reference; external Bank65 VREF is grounded via 1k.
set_property INTERNAL_VREF 0.6 [get_iobanks 65]
#PCIe rst 87
set_property -dict {PACKAGE_PIN AH12 IOSTANDARD LVCMOS33} [get_ports {GPIO_tri_io[9]}]

#NRF
set_property -dict {PACKAGE_PIN AB11 IOSTANDARD LVCMOS33} [get_ports {GPIO_tri_io[48]}]
set_property -dict {PACKAGE_PIN AC11 IOSTANDARD LVCMOS33} [get_ports {GPIO_tri_io[10]}]
set_property -dict {PACKAGE_PIN AA11 IOSTANDARD LVCMOS33} [get_ports {GPIO_tri_io[11]}]
set_property -dict {PACKAGE_PIN AA10 IOSTANDARD LVCMOS33} [get_ports {GPIO_tri_io[12]}]
set_property -dict {PACKAGE_PIN W10 IOSTANDARD LVCMOS33} [get_ports {GPIO_tri_io[13]}]
set_property -dict {PACKAGE_PIN Y10 IOSTANDARD LVCMOS33} [get_ports {GPIO_tri_io[14]}]
#atk module
set_property -dict {PACKAGE_PIN AG10 IOSTANDARD LVCMOS33} [get_ports {GPIO_tri_io[15]}]
set_property -dict {PACKAGE_PIN AH10 IOSTANDARD LVCMOS33} [get_ports {GPIO_tri_io[16]}]
set_property -dict {PACKAGE_PIN AF11 IOSTANDARD LVCMOS33} [get_ports {GPIO_tri_io[17]}]
set_property -dict {PACKAGE_PIN AG11 IOSTANDARD LVCMOS33} [get_ports {GPIO_tri_io[18]}]
#ext io 1.8V
set_property -dict {PACKAGE_PIN B1 IOSTANDARD LVCMOS18} [get_ports {GPIO_tri_io[21]}]
set_property -dict {PACKAGE_PIN A2 IOSTANDARD LVCMOS18} [get_ports {GPIO_tri_io[22]}]
set_property -dict {PACKAGE_PIN A1 IOSTANDARD LVCMOS18} [get_ports {GPIO_tri_io[23]}]
set_property -dict {PACKAGE_PIN B3 IOSTANDARD LVCMOS18} [get_ports {GPIO_tri_io[24]}]
set_property -dict {PACKAGE_PIN A3 IOSTANDARD LVCMOS18} [get_ports {GPIO_tri_io[25]}]
set_property -dict {PACKAGE_PIN B4 IOSTANDARD LVCMOS18} [get_ports {GPIO_tri_io[26]}]
set_property -dict {PACKAGE_PIN A4 IOSTANDARD LVCMOS18} [get_ports {GPIO_tri_io[27]}]
set_property -dict {PACKAGE_PIN D4 IOSTANDARD LVCMOS18} [get_ports {GPIO_tri_io[28]}]
set_property -dict {PACKAGE_PIN C4 IOSTANDARD LVCMOS18} [get_ports {GPIO_tri_io[29]}]
set_property -dict {PACKAGE_PIN C3 IOSTANDARD LVCMOS18} [get_ports {GPIO_tri_io[30]}]
set_property -dict {PACKAGE_PIN C2 IOSTANDARD LVCMOS18} [get_ports {GPIO_tri_io[31]}]
set_property -dict {PACKAGE_PIN B5 IOSTANDARD LVCMOS18} [get_ports {GPIO_tri_io[32]}]
set_property -dict {PACKAGE_PIN A5 IOSTANDARD LVCMOS18} [get_ports {GPIO_tri_io[33]}]
set_property -dict {PACKAGE_PIN C6 IOSTANDARD LVCMOS18} [get_ports {GPIO_tri_io[34]}]
set_property -dict {PACKAGE_PIN B6 IOSTANDARD LVCMOS18} [get_ports {GPIO_tri_io[35]}]
set_property -dict {PACKAGE_PIN A7 IOSTANDARD LVCMOS18} [get_ports {GPIO_tri_io[36]}]
set_property -dict {PACKAGE_PIN A6 IOSTANDARD LVCMOS18} [get_ports {GPIO_tri_io[37]}]
set_property -dict {PACKAGE_PIN C8 IOSTANDARD LVCMOS18} [get_ports {GPIO_tri_io[38]}]
set_property -dict {PACKAGE_PIN B8 IOSTANDARD LVCMOS18} [get_ports {GPIO_tri_io[39]}]
set_property -dict {PACKAGE_PIN A9 IOSTANDARD LVCMOS18} [get_ports {GPIO_tri_io[40]}]
set_property -dict {PACKAGE_PIN A8 IOSTANDARD LVCMOS18} [get_ports {GPIO_tri_io[41]}]
set_property -dict {PACKAGE_PIN C9 IOSTANDARD LVCMOS18} [get_ports {GPIO_tri_io[42]}]
set_property -dict {PACKAGE_PIN B9 IOSTANDARD LVCMOS18} [get_ports {GPIO_tri_io[43]}]
set_property -dict {PACKAGE_PIN C1 IOSTANDARD LVCMOS18} [get_ports {GPIO_tri_io[44]}]
#ext io 3.3V
set_property -dict {PACKAGE_PIN L14 IOSTANDARD LVCMOS33} [get_ports {GPIO_tri_io[45]}]
set_property -dict {PACKAGE_PIN L13 IOSTANDARD LVCMOS33} [get_ports {GPIO_tri_io[46]}]
set_property -dict {PACKAGE_PIN K14 IOSTANDARD LVCMOS33} [get_ports {GPIO_tri_io[47]}]
set_property -dict {PACKAGE_PIN H14 IOSTANDARD LVCMOS33} [get_ports {GPIO_tri_io[19]}]
set_property -dict {PACKAGE_PIN G15 IOSTANDARD LVCMOS33} [get_ports {GPIO_tri_io[20]}]

#*************************** HDMI ********************************
set_property PACKAGE_PIN E1 [get_ports TMDS_tmds_clk_p]
set_property PACKAGE_PIN G1 [get_ports {TMDS_tmds_data_p[0]}]
set_property PACKAGE_PIN F2 [get_ports {TMDS_tmds_data_p[1]}]
set_property PACKAGE_PIN G3 [get_ports {TMDS_tmds_data_p[2]}]

set_property IOSTANDARD LVDS [get_ports TMDS_tmds_clk_p]
set_property IOSTANDARD LVDS [get_ports {TMDS_tmds_data_p[*]}]

#********************************************* RGB LCD ****************************************
#blue
set_property -dict {PACKAGE_PIN W14 IOSTANDARD LVCMOS33} [get_ports {lcd_rgb_tri_io[0]}]
set_property -dict {PACKAGE_PIN Y14 IOSTANDARD LVCMOS33} [get_ports {lcd_rgb_tri_io[1]}]
set_property -dict {PACKAGE_PIN W13 IOSTANDARD LVCMOS33} [get_ports {lcd_rgb_tri_io[2]}]
set_property -dict {PACKAGE_PIN Y13 IOSTANDARD LVCMOS33} [get_ports {lcd_rgb_tri_io[3]}]
set_property -dict {PACKAGE_PIN W12 IOSTANDARD LVCMOS33} [get_ports {lcd_rgb_tri_io[4]}]
set_property -dict {PACKAGE_PIN Y12 IOSTANDARD LVCMOS33} [get_ports {lcd_rgb_tri_io[5]}]
set_property -dict {PACKAGE_PIN W11 IOSTANDARD LVCMOS33} [get_ports {lcd_rgb_tri_io[6]}]
set_property -dict {PACKAGE_PIN AA12 IOSTANDARD LVCMOS33} [get_ports {lcd_rgb_tri_io[7]}]
#green
set_property -dict {PACKAGE_PIN AC14 IOSTANDARD LVCMOS33} [get_ports {lcd_rgb_tri_io[8]}]
set_property -dict {PACKAGE_PIN AD15 IOSTANDARD LVCMOS33} [get_ports {lcd_rgb_tri_io[9]}]
set_property -dict {PACKAGE_PIN AC13 IOSTANDARD LVCMOS33} [get_ports {lcd_rgb_tri_io[10]}]
set_property -dict {PACKAGE_PIN AD14 IOSTANDARD LVCMOS33} [get_ports {lcd_rgb_tri_io[11]}]
set_property -dict {PACKAGE_PIN AE15 IOSTANDARD LVCMOS33} [get_ports {lcd_rgb_tri_io[12]}]
set_property -dict {PACKAGE_PIN AA13 IOSTANDARD LVCMOS33} [get_ports {lcd_rgb_tri_io[13]}]
set_property -dict {PACKAGE_PIN AE14 IOSTANDARD LVCMOS33} [get_ports {lcd_rgb_tri_io[14]}]
set_property -dict {PACKAGE_PIN AB13 IOSTANDARD LVCMOS33} [get_ports {lcd_rgb_tri_io[15]}]
#red
set_property -dict {PACKAGE_PIN AG14 IOSTANDARD LVCMOS33} [get_ports {lcd_rgb_tri_io[16]}]
set_property -dict {PACKAGE_PIN AB15 IOSTANDARD LVCMOS33} [get_ports {lcd_rgb_tri_io[17]}]
set_property -dict {PACKAGE_PIN AH14 IOSTANDARD LVCMOS33} [get_ports {lcd_rgb_tri_io[18]}]
set_property -dict {PACKAGE_PIN AB14 IOSTANDARD LVCMOS33} [get_ports {lcd_rgb_tri_io[19]}]
set_property -dict {PACKAGE_PIN AG13 IOSTANDARD LVCMOS33} [get_ports {lcd_rgb_tri_io[20]}]
set_property -dict {PACKAGE_PIN AE13 IOSTANDARD LVCMOS33} [get_ports {lcd_rgb_tri_io[21]}]
set_property -dict {PACKAGE_PIN AH13 IOSTANDARD LVCMOS33} [get_ports {lcd_rgb_tri_io[22]}]
set_property -dict {PACKAGE_PIN AF13 IOSTANDARD LVCMOS33} [get_ports {lcd_rgb_tri_io[23]}]

set_property -dict {PACKAGE_PIN J11 IOSTANDARD LVCMOS33} [get_ports lcd_hs]
set_property -dict {PACKAGE_PIN K12 IOSTANDARD LVCMOS33} [get_ports lcd_vs]
set_property -dict {PACKAGE_PIN J10 IOSTANDARD LVCMOS33} [get_ports lcd_de]
set_property -dict {PACKAGE_PIN J12 IOSTANDARD LVCMOS33} [get_ports lcd_bl]
set_property -dict {PACKAGE_PIN K13 IOSTANDARD LVCMOS33} [get_ports lcd_clk]
set_property -dict {PACKAGE_PIN F10 IOSTANDARD LVCMOS33} [get_ports lcd_rst]

#´¥Ãþ¿ØÖÆ
#touch_int 82
set_property -dict {PACKAGE_PIN F12 IOSTANDARD LVCMOS33} [get_ports {GPIO_tri_io[4]}]
#touch_rst 83
set_property -dict {PACKAGE_PIN H11 IOSTANDARD LVCMOS33} [get_ports {GPIO_tri_io[5]}]

set_property -dict {PACKAGE_PIN G11 IOSTANDARD LVCMOS33} [get_ports lcd_touch_e2p_scl_io]
set_property -dict {PACKAGE_PIN H12 IOSTANDARD LVCMOS33} [get_ports lcd_touch_e2p_sda_io]

#timing
create_clock -period 8.000 -name RGMII_rxc -waveform {0.000 4.000} [get_ports RGMII_rxc]

set_clock_groups -asynchronous -group [get_clocks clk_pl_0] -group [get_clocks -of_objects [get_pins system_i/clk_wiz_0/inst/CLK_CORE_DRP_I/clk_inst/mmcme4_adv_inst/CLKOUT1]]
set_clock_groups -asynchronous -group [get_clocks clk_pl_1] -group [get_clocks mdio0_mdc_clock]
set_clock_groups -asynchronous -group [get_clocks clk_pl_0] -group [get_clocks clk_pl_3]
set_clock_groups -asynchronous -group [get_clocks clk_pl_0] -group [get_clocks -of_objects [get_pins system_i/clk_wiz_0/inst/CLK_CORE_DRP_I/clk_inst/mmcme4_adv_inst/CLKOUT0]]

set_clock_groups -asynchronous -group [get_clocks -of_objects [get_pins system_i/clk_wiz_0/inst/CLK_CORE_DRP_I/clk_inst/mmcme4_adv_inst/CLKOUT1]] -group [get_clocks -of_objects [get_pins system_i/clk_wiz_0/inst/CLK_CORE_DRP_I/clk_inst/mmcme4_adv_inst/CLKOUT3]]
set_property C_CLK_INPUT_FREQ_HZ 100000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets -of_objects [get_pins system_i/zynq_ultra_ps_e_0/pl_clk0]]
