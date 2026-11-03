`timescale 1ns/1ps
// Candidate receiver. cal_resetn must include reference-clock lock/reset status.
// Preserve the vendor receiver's GMII data and control convention.
module rgmii_rx_calibrated #(
    parameter integer RX_DELAY_PS=550,
    parameter real REFCLK_MHZ=399.996004
)(
    input wire refclk, cal_resetn,
    input wire rgmii_rxc, rgmii_rx_ctl,
    input wire [3:0] rgmii_rxd,
    output wire gmii_rx_clk, gmii_rx_dv,
    output wire [7:0] gmii_rxd,
    output wire rx_ready
);
    wire rxc, delay_ready;
    (* ASYNC_REG="TRUE", SHREG_EXTRACT="NO" *) reg [2:0] reference_release=0;
    always @(posedge refclk or negedge cal_resetn)
        if(!cal_resetn) reference_release<=0;
        else reference_release<={reference_release[1:0],1'b1};
    reg [5:0] reset_count=0;
    always @(posedge refclk)
        if(!reference_release[2]) reset_count<=0;
        else if(!(&reset_count)) reset_count<=reset_count+1'b1;
    wire ctrl_reset=!(reference_release[2] & (&reset_count));
    // Keep the controller reset for 63 reference cycles (>50 ns).
    (* IODELAY_GROUP="NLOS_RGMII_RX" *)
    IDELAYCTRL #(.SIM_DEVICE("ULTRASCALE")) delay_ctrl(
        .REFCLK(refclk),.RST(ctrl_reset),.RDY(delay_ready));
    BUFG rx_clock_buffer(.I(rgmii_rxc),.O(rxc));
    (* ASYNC_REG="TRUE", SHREG_EXTRACT="NO" *) reg [2:0] ready_pipe=0;
    wire ready_request=delay_ready & cal_resetn;
    always @(posedge rxc or negedge ready_request)
        if(!ready_request) ready_pipe<=0;
        else ready_pipe<={ready_pipe[1:0],1'b1};
    assign rx_ready=ready_pipe[2];
    assign gmii_rx_clk=rxc;
    wire [4:0] raw_data={rgmii_rx_ctl,rgmii_rxd};
    wire [4:0] delayed_data, q_rise, q_fall;
    genvar i;
    generate for(i=0;i<5;i=i+1) begin: lanes
        (* IODELAY_GROUP="NLOS_RGMII_RX" *)
        IDELAYE3 #(
            .CASCADE("NONE"),.DELAY_FORMAT("TIME"),.DELAY_SRC("IDATAIN"),
            .DELAY_TYPE("FIXED"),.DELAY_VALUE(RX_DELAY_PS),
            .REFCLK_FREQUENCY(REFCLK_MHZ),.SIM_DEVICE("ULTRASCALE_PLUS"),
            .UPDATE_MODE("ASYNC")
        ) input_delay(
            .IDATAIN(raw_data[i]),.DATAOUT(delayed_data[i]),.CLK(rxc),
            .RST(1'b0),.CE(1'b0),.INC(1'b0),.LOAD(1'b0),.EN_VTC(1'b1),
            .CNTVALUEIN(9'b0),.CNTVALUEOUT(),.DATAIN(1'b0),
            .CASC_IN(1'b0),.CASC_RETURN(1'b0),.CASC_OUT());
        IDDRE1 #(.DDR_CLK_EDGE("SAME_EDGE_PIPELINED"),
                 .IS_CB_INVERTED(1'b0),.IS_C_INVERTED(1'b0)) capture(
            .D(delayed_data[i]),.C(rxc),.CB(~rxc),.R(!rx_ready),
            .Q1(q_rise[i]),.Q2(q_fall[i]));
    end endgenerate
    assign gmii_rxd={q_fall[3:0],q_rise[3:0]};
    assign gmii_rx_dv=rx_ready & q_rise[4] & q_fall[4];
endmodule
