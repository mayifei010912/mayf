##############################PS XDC#########################################
############################################################################
##
##  Xilinx, Inc. 2006            www.xilinx.com
############################################################################
##  File name :       psu_constraints.xdc
##
##  Details :     Constraints file
##                    FPGA family:       zynq
##                    FPGA:              PROD-2
##                    Device Size:       xczu4ev
##                    Package:           sfvc784
##                    Speedgrade:        -2
##
##
############################################################################
############################################################################
############################################################################
# Clock constraints                                                        #
############################################################################
create_clock -name clk_pl_0 -period "10" [get_pins "PS8_i/PLCLK[0]"]
create_clock -name clk_pl_1 -period "2.666" [get_pins "PS8_i/PLCLK[1]"]
create_clock -name clk_pl_2 -period "27.333" [get_pins "PS8_i/PLCLK[2]"]
create_clock -name clk_pl_3 -period "3.333" [get_pins "PS8_i/PLCLK[3]"]
create_clock -name mdio0_mdc_clock -period "480.004" [get_pins "PS8_i/EMIOENET0MDIOMDC"]



set_property DONT_TOUCH true [get_cells "PS8_i"]
