// (c) Copyright 1995-2026 Xilinx, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
// 
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
// 
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
// 
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
// 
// DO NOT MODIFY THIS FILE.


// IP VLNV: xilinx.com:module_ref:hdmi_clock_shared:1.0
// IP Revision: 1

(* X_CORE_INFO = "hdmi_clock_shared,Vivado 2020.2" *)
(* CHECK_LICENSE_TYPE = "system_hdmi_shared_0,hdmi_clock_shared,{}" *)
(* CORE_GENERATION_INFO = "system_hdmi_shared_0,hdmi_clock_shared,{x_ipProduct=Vivado 2020.2,x_ipVendor=xilinx.com,x_ipLibrary=module_ref,x_ipName=hdmi_clock_shared,x_ipVersion=1.0,x_ipCoreRevision=1,x_ipLanguage=VERILOG,x_ipSimLanguage=MIXED}" *)
(* IP_DEFINITION_SOURCE = "module_ref" *)
(* DowngradeIPIdentifiedWarnings = "yes" *)
module system_hdmi_shared_0 (
  raw_clock,
  locked,
  fast_clock,
  slow_clock,
  pixel_clock
);

(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME raw_clock, FREQ_HZ 370829625, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN system_clk_wiz_0_1_clk_out1, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 raw_clock CLK" *)
input wire raw_clock;
input wire locked;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME fast_clock, FREQ_HZ 370829625, FREQ_TOLERANCE_HZ 0, PHASE 0.000, CLK_DOMAIN system_hdmi_shared_0_fast_clock, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 fast_clock CLK" *)
output wire fast_clock;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME slow_clock, FREQ_HZ 185414813, FREQ_TOLERANCE_HZ 0, PHASE 0.000, CLK_DOMAIN system_hdmi_shared_0_slow_clock, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 slow_clock CLK" *)
output wire slow_clock;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME pixel_clock, FREQ_HZ 74165925, FREQ_TOLERANCE_HZ 0, PHASE 0.000, CLK_DOMAIN system_hdmi_shared_0_pixel_clock, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 pixel_clock CLK" *)
output wire pixel_clock;

  hdmi_clock_shared inst (
    .raw_clock(raw_clock),
    .locked(locked),
    .fast_clock(fast_clock),
    .slow_clock(slow_clock),
    .pixel_clock(pixel_clock)
  );
endmodule
