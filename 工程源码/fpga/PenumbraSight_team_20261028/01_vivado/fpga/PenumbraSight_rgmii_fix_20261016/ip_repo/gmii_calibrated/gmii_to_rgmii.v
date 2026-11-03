`timescale 1ns/1ps
module gmii_to_rgmii(
    input wire refclk, cal_resetn,
    output wire rx_ready,
    output wire gmii_rx_clk,gmii_rx_dv,gmii_rx_er,gmii_tx_clk,
    output wire [7:0] gmii_rxd,
    input wire gmii_tx_en,
    input wire [7:0] gmii_txd,
    input wire rgmii_rxc,rgmii_rx_ctl,
    input wire [3:0] rgmii_rxd,
    output wire rgmii_txc,rgmii_tx_ctl,
    output wire [3:0] rgmii_txd
);
    assign gmii_tx_clk=gmii_rx_clk;
    assign gmii_rx_er=1'b0;
    rgmii_rx_calibrated #(.RX_DELAY_PS(550),.REFCLK_MHZ(399.996004)) u_rgmii_rx(
        .refclk(refclk),.cal_resetn(cal_resetn),.rx_ready(rx_ready),
        .rgmii_rxc(rgmii_rxc),.rgmii_rx_ctl(rgmii_rx_ctl),.rgmii_rxd(rgmii_rxd),
        .gmii_rx_clk(gmii_rx_clk),.gmii_rx_dv(gmii_rx_dv),.gmii_rxd(gmii_rxd));
    rgmii_tx u_rgmii_tx(.tx_ready(rx_ready),.gmii_tx_clk(gmii_tx_clk),.gmii_tx_en(gmii_tx_en),
        .gmii_txd(gmii_txd),.rgmii_txc(rgmii_txc),.rgmii_tx_ctl(rgmii_tx_ctl),
        .rgmii_txd(rgmii_txd));
endmodule
