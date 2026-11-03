# YT8521 Table 138, RX internal delay enabled. +/-200 ps PCB allowance assumed.
# Gigabit RX budget only; TX/MDIO and other interfaces are reviewed separately.
set nlos_rx_ports [get_ports {RGMII_rd[*] RGMII_rx_ctl}]
set nlos_rx_clock [get_clocks RGMII_rxc]
set_input_delay -clock $nlos_rx_clock -min 0.8 $nlos_rx_ports
set_input_delay -clock $nlos_rx_clock -max 3.2 $nlos_rx_ports
set_input_delay -clock $nlos_rx_clock -clock_fall -add_delay -min 0.8 $nlos_rx_ports
set_input_delay -clock $nlos_rx_clock -clock_fall -add_delay -max 3.2 $nlos_rx_ports
# Scope exceptions to the asynchronous reset pins of the two marked chains.
set nlos_rx_sync_reset [get_pins -hier -filter {REF_PIN_NAME == CLR && (NAME =~ *gmii2rgmii_calibrated_0*reference_release_reg* || NAME =~ *gmii2rgmii_calibrated_0*ready_pipe_reg*)}]
set_false_path -to $nlos_rx_sync_reset
