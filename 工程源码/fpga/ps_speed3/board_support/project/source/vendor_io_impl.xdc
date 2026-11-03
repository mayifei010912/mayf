# Explicit electrical parameters for the RGMII transmitter, per PG160.
set_property -dict {SLEW FAST DRIVE 12} [get_ports {RGMII_td[*] RGMII_tx_ctl RGMII_txc}]
