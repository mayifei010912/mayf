# aclk {FREQ_HZ 299997009 CLK_DOMAIN system_zynq_ultra_ps_e_0_0_pl_clk3 PHASE 0.000} aclk1 {FREQ_HZ 299997009 CLK_DOMAIN system_zynq_ultra_ps_e_0_0_pl_clk3 PHASE 0.000}
# Clock Domain: system_zynq_ultra_ps_e_0_0_pl_clk3
create_clock -name aclk -period 3.333 [get_ports aclk]
# Generated clocks
create_generated_clock -name aclk1 -source [get_ports aclk] -divide_by 1 [get_ports aclk1]
