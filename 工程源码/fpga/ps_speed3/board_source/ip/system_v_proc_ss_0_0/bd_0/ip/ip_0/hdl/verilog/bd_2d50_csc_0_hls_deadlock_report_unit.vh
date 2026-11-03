   
    parameter PROC_NUM = 4;
    parameter ST_IDLE = 2'b0;
    parameter ST_DL_DETECTED = 2'b1;
    parameter ST_DL_REPORT = 2'b10;
   

    reg find_df_deadlock = 0;
    reg [1:0] CS_fsm;
    reg [1:0] NS_fsm;
    reg [PROC_NUM - 1:0] dl_detect_reg;
    reg [PROC_NUM - 1:0] dl_done_reg;
    reg [PROC_NUM - 1:0] origin_reg;
    reg [PROC_NUM - 1:0] dl_in_vec_reg;
    integer i;
    integer fp;

    // FSM State machine
    always @ (negedge reset or posedge clock) begin
        if (~reset) begin
            CS_fsm <= ST_IDLE;
        end
        else begin
            CS_fsm <= NS_fsm;
        end
    end
    always @ (CS_fsm or dl_in_vec or dl_detect_reg or dl_done_reg or dl_in_vec or origin_reg) begin
        NS_fsm = CS_fsm;
        case (CS_fsm)
            ST_IDLE : begin
                if (|dl_in_vec) begin
                    NS_fsm = ST_DL_DETECTED;
                end
            end
            ST_DL_DETECTED: begin
                // has unreported deadlock cycle
                if (dl_detect_reg != dl_done_reg) begin
                    NS_fsm = ST_DL_REPORT;
                end
            end
            ST_DL_REPORT: begin
                if (|(dl_in_vec & origin_reg)) begin
                    NS_fsm = ST_DL_DETECTED;
                end
            end
        endcase
    end

    // dl_detect_reg record the procs that first detect deadlock
    always @ (negedge reset or posedge clock) begin
        if (~reset) begin
            dl_detect_reg <= 'b0;
        end
        else begin
            if (CS_fsm == ST_IDLE) begin
                dl_detect_reg <= dl_in_vec;
            end
        end
    end

    // dl_detect_out keeps in high after deadlock detected
    assign dl_detect_out = |dl_detect_reg;

    // dl_done_reg record the cycles has been reported
    always @ (negedge reset or posedge clock) begin
        if (~reset) begin
            dl_done_reg <= 'b0;
        end
        else begin
            if ((CS_fsm == ST_DL_REPORT) && (|(dl_in_vec & dl_detect_reg) == 'b1)) begin
                dl_done_reg <= dl_done_reg | dl_in_vec;
            end
        end
    end

    // clear token once a cycle is done
    assign token_clear = (CS_fsm == ST_DL_REPORT) ? ((|(dl_in_vec & origin_reg)) ? 'b1 : 'b0) : 'b0;

    // origin_reg record the current cycle start id
    always @ (negedge reset or posedge clock) begin
        if (~reset) begin
            origin_reg <= 'b0;
        end
        else begin
            if (CS_fsm == ST_DL_DETECTED) begin
                origin_reg <= origin;
            end
        end
    end
   
    // origin will be valid for only one cycle
    always @ (CS_fsm or dl_detect_reg or dl_done_reg) begin
        if (CS_fsm == ST_DL_DETECTED) begin
            for (i = 0; i < PROC_NUM; i = i + 1) begin
                if (dl_detect_reg[i] & ~dl_done_reg[i] & ~(|origin)) begin
                    origin = 'b1 << i;
                end
            end
        end
        else begin
            origin = 'b0;
        end
    end
    
    // dl_in_vec_reg record the current cycle dl_in_vec
    always @ (negedge reset or posedge clock) begin
        if (~reset) begin
            dl_in_vec_reg <= 'b0;
        end
        else begin
            if (CS_fsm == ST_DL_DETECTED) begin
                dl_in_vec_reg <= origin;
            end
            else if (CS_fsm == ST_DL_REPORT) begin
                dl_in_vec_reg <= dl_in_vec;
            end
        end
    end
    
    // get the first valid proc index in dl vector
    function integer proc_index(input [PROC_NUM - 1:0] dl_vec);
        begin
            proc_index = 0;
            for (i = 0; i < PROC_NUM; i = i + 1) begin
                if (dl_vec[i]) begin
                    proc_index = i;
                end
            end
        end
    endfunction

    // get the proc path based on dl vector
    function [408:0] proc_path(input [PROC_NUM - 1:0] dl_vec);
        integer index;
        begin
            index = proc_index(dl_vec);
            case (index)
                0 : begin
                    proc_path = "bd_2d50_csc_0_v_csc.Block_split3_proc_U0";
                end
                1 : begin
                    proc_path = "bd_2d50_csc_0_v_csc.AXIvideo2MultiPixStream_U0";
                end
                2 : begin
                    proc_path = "bd_2d50_csc_0_v_csc.v_csc_core_U0";
                end
                3 : begin
                    proc_path = "bd_2d50_csc_0_v_csc.MultiPixStream2AXIvideo_U0";
                end
                default : begin
                    proc_path = "unknown";
                end
            endcase
        end
    endfunction

    // print the headlines of deadlock detection
    task print_dl_head;
        begin
            $display("\n//////////////////////////////////////////////////////////////////////////////");
            $display("// ERROR!!! DEADLOCK DETECTED at %0t ns! SIMULATION WILL BE STOPPED! //", $time);
            $display("//////////////////////////////////////////////////////////////////////////////");
            fp = $fopen("deadlock_db.dat", "w");
        end
    endtask

    // print the start of a cycle
    task print_cycle_start(input reg [408:0] proc_path, input integer cycle_id);
        begin
            $display("/////////////////////////");
            $display("// Dependence cycle %0d:", cycle_id);
            $display("// (1): Process: %0s", proc_path);
            $fdisplay(fp, "Dependence_Cycle_ID %0d", cycle_id);
            $fdisplay(fp, "Dependence_Process_ID 1");
            $fdisplay(fp, "Dependence_Process_path %0s", proc_path);
        end
    endtask

    // print the end of deadlock detection
    task print_dl_end(input integer num, input integer record_time);
        begin
            $display("////////////////////////////////////////////////////////////////////////");
            $display("// Totally %0d cycles detected!", num);
            $display("////////////////////////////////////////////////////////////////////////");
            $display("// ERROR!!! DEADLOCK DETECTED at %0t ns! SIMULATION WILL BE STOPPED! //", record_time);
            $display("//////////////////////////////////////////////////////////////////////////////");
            $fdisplay(fp, "Dependence_Cycle_Number %0d", num);
            $fclose(fp);
        end
    endtask

    // print one proc component in the cycle
    task print_cycle_proc_comp(input reg [408:0] proc_path, input integer cycle_comp_id);
        begin
            $display("// (%0d): Process: %0s", cycle_comp_id, proc_path);
            $fdisplay(fp, "Dependence_Process_ID %0d", cycle_comp_id);
            $fdisplay(fp, "Dependence_Process_path %0s", proc_path);
        end
    endtask

    // print one channel component in the cycle
    task print_cycle_chan_comp(input [PROC_NUM - 1:0] dl_vec1, input [PROC_NUM - 1:0] dl_vec2);
        reg [504:0] chan_path;
        integer index1;
        integer index2;
        begin
            index1 = proc_index(dl_vec1);
            index2 = proc_index(dl_vec2);
            case (index1)
                0 : begin
                    case(index2)
                    3: begin
                        if (~Block_split3_proc_U0.HwReg_OutVideoFormat_out_blk_n) begin
                            if (~HwReg_OutVideoFormat_c_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bd_2d50_csc_0_v_csc.HwReg_OutVideoFormat_c_U' written by process 'bd_2d50_csc_0_v_csc.MultiPixStream2AXIvideo_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bd_2d50_csc_0_v_csc.HwReg_OutVideoFormat_c_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~HwReg_OutVideoFormat_c_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bd_2d50_csc_0_v_csc.HwReg_OutVideoFormat_c_U' read by process 'bd_2d50_csc_0_v_csc.MultiPixStream2AXIvideo_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bd_2d50_csc_0_v_csc.HwReg_OutVideoFormat_c_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~start_for_MultiPixStream2AXIvideo_U0_U.if_full_n & Block_split3_proc_U0.ap_start & ~Block_split3_proc_U0.real_start & (trans_in_cnt_0 == trans_out_cnt_0) & ~start_for_MultiPixStream2AXIvideo_U0_U.if_read) begin
                            $display("//      Blocked by full output start propagation FIFO 'bd_2d50_csc_0_v_csc.start_for_MultiPixStream2AXIvideo_U0_U' read by process 'bd_2d50_csc_0_v_csc.MultiPixStream2AXIvideo_U0',");
                        end
                    end
                    1: begin
                        if (~Block_split3_proc_U0.HwReg_width_out_blk_n) begin
                            if (~HwReg_width_c_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bd_2d50_csc_0_v_csc.HwReg_width_c_U' written by process 'bd_2d50_csc_0_v_csc.AXIvideo2MultiPixStream_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bd_2d50_csc_0_v_csc.HwReg_width_c_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~HwReg_width_c_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bd_2d50_csc_0_v_csc.HwReg_width_c_U' read by process 'bd_2d50_csc_0_v_csc.AXIvideo2MultiPixStream_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bd_2d50_csc_0_v_csc.HwReg_width_c_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~Block_split3_proc_U0.HwReg_height_out_blk_n) begin
                            if (~HwReg_height_c_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bd_2d50_csc_0_v_csc.HwReg_height_c_U' written by process 'bd_2d50_csc_0_v_csc.AXIvideo2MultiPixStream_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bd_2d50_csc_0_v_csc.HwReg_height_c_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~HwReg_height_c_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bd_2d50_csc_0_v_csc.HwReg_height_c_U' read by process 'bd_2d50_csc_0_v_csc.AXIvideo2MultiPixStream_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bd_2d50_csc_0_v_csc.HwReg_height_c_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    2: begin
                        if (~Block_split3_proc_U0.HwReg_K11_out_blk_n) begin
                            if (~HwReg_K11_c_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bd_2d50_csc_0_v_csc.HwReg_K11_c_U' written by process 'bd_2d50_csc_0_v_csc.v_csc_core_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bd_2d50_csc_0_v_csc.HwReg_K11_c_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~HwReg_K11_c_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bd_2d50_csc_0_v_csc.HwReg_K11_c_U' read by process 'bd_2d50_csc_0_v_csc.v_csc_core_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bd_2d50_csc_0_v_csc.HwReg_K11_c_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~Block_split3_proc_U0.HwReg_K12_out_blk_n) begin
                            if (~HwReg_K12_c_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bd_2d50_csc_0_v_csc.HwReg_K12_c_U' written by process 'bd_2d50_csc_0_v_csc.v_csc_core_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bd_2d50_csc_0_v_csc.HwReg_K12_c_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~HwReg_K12_c_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bd_2d50_csc_0_v_csc.HwReg_K12_c_U' read by process 'bd_2d50_csc_0_v_csc.v_csc_core_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bd_2d50_csc_0_v_csc.HwReg_K12_c_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~Block_split3_proc_U0.HwReg_K13_out_blk_n) begin
                            if (~HwReg_K13_c_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bd_2d50_csc_0_v_csc.HwReg_K13_c_U' written by process 'bd_2d50_csc_0_v_csc.v_csc_core_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bd_2d50_csc_0_v_csc.HwReg_K13_c_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~HwReg_K13_c_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bd_2d50_csc_0_v_csc.HwReg_K13_c_U' read by process 'bd_2d50_csc_0_v_csc.v_csc_core_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bd_2d50_csc_0_v_csc.HwReg_K13_c_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~Block_split3_proc_U0.HwReg_K21_out_blk_n) begin
                            if (~HwReg_K21_c_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bd_2d50_csc_0_v_csc.HwReg_K21_c_U' written by process 'bd_2d50_csc_0_v_csc.v_csc_core_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bd_2d50_csc_0_v_csc.HwReg_K21_c_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~HwReg_K21_c_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bd_2d50_csc_0_v_csc.HwReg_K21_c_U' read by process 'bd_2d50_csc_0_v_csc.v_csc_core_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bd_2d50_csc_0_v_csc.HwReg_K21_c_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~Block_split3_proc_U0.HwReg_K22_out_blk_n) begin
                            if (~HwReg_K22_c_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bd_2d50_csc_0_v_csc.HwReg_K22_c_U' written by process 'bd_2d50_csc_0_v_csc.v_csc_core_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bd_2d50_csc_0_v_csc.HwReg_K22_c_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~HwReg_K22_c_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bd_2d50_csc_0_v_csc.HwReg_K22_c_U' read by process 'bd_2d50_csc_0_v_csc.v_csc_core_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bd_2d50_csc_0_v_csc.HwReg_K22_c_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~Block_split3_proc_U0.HwReg_K23_out_blk_n) begin
                            if (~HwReg_K23_c_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bd_2d50_csc_0_v_csc.HwReg_K23_c_U' written by process 'bd_2d50_csc_0_v_csc.v_csc_core_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bd_2d50_csc_0_v_csc.HwReg_K23_c_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~HwReg_K23_c_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bd_2d50_csc_0_v_csc.HwReg_K23_c_U' read by process 'bd_2d50_csc_0_v_csc.v_csc_core_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bd_2d50_csc_0_v_csc.HwReg_K23_c_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~Block_split3_proc_U0.HwReg_K31_out_blk_n) begin
                            if (~HwReg_K31_c_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bd_2d50_csc_0_v_csc.HwReg_K31_c_U' written by process 'bd_2d50_csc_0_v_csc.v_csc_core_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bd_2d50_csc_0_v_csc.HwReg_K31_c_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~HwReg_K31_c_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bd_2d50_csc_0_v_csc.HwReg_K31_c_U' read by process 'bd_2d50_csc_0_v_csc.v_csc_core_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bd_2d50_csc_0_v_csc.HwReg_K31_c_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~Block_split3_proc_U0.HwReg_K32_out_blk_n) begin
                            if (~HwReg_K32_c_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bd_2d50_csc_0_v_csc.HwReg_K32_c_U' written by process 'bd_2d50_csc_0_v_csc.v_csc_core_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bd_2d50_csc_0_v_csc.HwReg_K32_c_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~HwReg_K32_c_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bd_2d50_csc_0_v_csc.HwReg_K32_c_U' read by process 'bd_2d50_csc_0_v_csc.v_csc_core_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bd_2d50_csc_0_v_csc.HwReg_K32_c_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~Block_split3_proc_U0.HwReg_K33_out_blk_n) begin
                            if (~HwReg_K33_c_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bd_2d50_csc_0_v_csc.HwReg_K33_c_U' written by process 'bd_2d50_csc_0_v_csc.v_csc_core_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bd_2d50_csc_0_v_csc.HwReg_K33_c_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~HwReg_K33_c_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bd_2d50_csc_0_v_csc.HwReg_K33_c_U' read by process 'bd_2d50_csc_0_v_csc.v_csc_core_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bd_2d50_csc_0_v_csc.HwReg_K33_c_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~Block_split3_proc_U0.HwReg_ROffset_V_out_blk_n) begin
                            if (~HwReg_ROffset_V_c_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bd_2d50_csc_0_v_csc.HwReg_ROffset_V_c_U' written by process 'bd_2d50_csc_0_v_csc.v_csc_core_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bd_2d50_csc_0_v_csc.HwReg_ROffset_V_c_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~HwReg_ROffset_V_c_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bd_2d50_csc_0_v_csc.HwReg_ROffset_V_c_U' read by process 'bd_2d50_csc_0_v_csc.v_csc_core_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bd_2d50_csc_0_v_csc.HwReg_ROffset_V_c_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~Block_split3_proc_U0.HwReg_GOffset_V_out_blk_n) begin
                            if (~HwReg_GOffset_V_c_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bd_2d50_csc_0_v_csc.HwReg_GOffset_V_c_U' written by process 'bd_2d50_csc_0_v_csc.v_csc_core_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bd_2d50_csc_0_v_csc.HwReg_GOffset_V_c_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~HwReg_GOffset_V_c_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bd_2d50_csc_0_v_csc.HwReg_GOffset_V_c_U' read by process 'bd_2d50_csc_0_v_csc.v_csc_core_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bd_2d50_csc_0_v_csc.HwReg_GOffset_V_c_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~Block_split3_proc_U0.HwReg_BOffset_V_out_blk_n) begin
                            if (~HwReg_BOffset_V_c_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bd_2d50_csc_0_v_csc.HwReg_BOffset_V_c_U' written by process 'bd_2d50_csc_0_v_csc.v_csc_core_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bd_2d50_csc_0_v_csc.HwReg_BOffset_V_c_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~HwReg_BOffset_V_c_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bd_2d50_csc_0_v_csc.HwReg_BOffset_V_c_U' read by process 'bd_2d50_csc_0_v_csc.v_csc_core_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bd_2d50_csc_0_v_csc.HwReg_BOffset_V_c_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~Block_split3_proc_U0.HwReg_ClampMin_V_out_blk_n) begin
                            if (~HwReg_ClampMin_V_c_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bd_2d50_csc_0_v_csc.HwReg_ClampMin_V_c_U' written by process 'bd_2d50_csc_0_v_csc.v_csc_core_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bd_2d50_csc_0_v_csc.HwReg_ClampMin_V_c_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~HwReg_ClampMin_V_c_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bd_2d50_csc_0_v_csc.HwReg_ClampMin_V_c_U' read by process 'bd_2d50_csc_0_v_csc.v_csc_core_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bd_2d50_csc_0_v_csc.HwReg_ClampMin_V_c_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~Block_split3_proc_U0.HwReg_ClipMax_V_out_blk_n) begin
                            if (~HwReg_ClipMax_V_c_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bd_2d50_csc_0_v_csc.HwReg_ClipMax_V_c_U' written by process 'bd_2d50_csc_0_v_csc.v_csc_core_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bd_2d50_csc_0_v_csc.HwReg_ClipMax_V_c_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~HwReg_ClipMax_V_c_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bd_2d50_csc_0_v_csc.HwReg_ClipMax_V_c_U' read by process 'bd_2d50_csc_0_v_csc.v_csc_core_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bd_2d50_csc_0_v_csc.HwReg_ClipMax_V_c_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~start_for_v_csc_core_U0_U.if_full_n & Block_split3_proc_U0.ap_start & ~Block_split3_proc_U0.real_start & (trans_in_cnt_0 == trans_out_cnt_0) & ~start_for_v_csc_core_U0_U.if_read) begin
                            $display("//      Blocked by full output start propagation FIFO 'bd_2d50_csc_0_v_csc.start_for_v_csc_core_U0_U' read by process 'bd_2d50_csc_0_v_csc.v_csc_core_U0',");
                        end
                    end
                    endcase
                end
                1 : begin
                    case(index2)
                    2: begin
                        if (~AXIvideo2MultiPixStream_U0.stream_in_blk_n) begin
                            if (~stream_in_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bd_2d50_csc_0_v_csc.stream_in_U' written by process 'bd_2d50_csc_0_v_csc.v_csc_core_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bd_2d50_csc_0_v_csc.stream_in_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~stream_in_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bd_2d50_csc_0_v_csc.stream_in_U' read by process 'bd_2d50_csc_0_v_csc.v_csc_core_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bd_2d50_csc_0_v_csc.stream_in_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~AXIvideo2MultiPixStream_U0.Height_out_blk_n) begin
                            if (~HwReg_height_c11_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bd_2d50_csc_0_v_csc.HwReg_height_c11_U' written by process 'bd_2d50_csc_0_v_csc.v_csc_core_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bd_2d50_csc_0_v_csc.HwReg_height_c11_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~HwReg_height_c11_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bd_2d50_csc_0_v_csc.HwReg_height_c11_U' read by process 'bd_2d50_csc_0_v_csc.v_csc_core_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bd_2d50_csc_0_v_csc.HwReg_height_c11_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~AXIvideo2MultiPixStream_U0.WidthIn_out_blk_n) begin
                            if (~HwReg_width_c12_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bd_2d50_csc_0_v_csc.HwReg_width_c12_U' written by process 'bd_2d50_csc_0_v_csc.v_csc_core_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bd_2d50_csc_0_v_csc.HwReg_width_c12_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~HwReg_width_c12_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bd_2d50_csc_0_v_csc.HwReg_width_c12_U' read by process 'bd_2d50_csc_0_v_csc.v_csc_core_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bd_2d50_csc_0_v_csc.HwReg_width_c12_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    0: begin
                        if (~AXIvideo2MultiPixStream_U0.Height_blk_n) begin
                            if (~HwReg_height_c_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bd_2d50_csc_0_v_csc.HwReg_height_c_U' written by process 'bd_2d50_csc_0_v_csc.Block_split3_proc_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bd_2d50_csc_0_v_csc.HwReg_height_c_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~HwReg_height_c_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bd_2d50_csc_0_v_csc.HwReg_height_c_U' read by process 'bd_2d50_csc_0_v_csc.Block_split3_proc_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bd_2d50_csc_0_v_csc.HwReg_height_c_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~AXIvideo2MultiPixStream_U0.WidthIn_blk_n) begin
                            if (~HwReg_width_c_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bd_2d50_csc_0_v_csc.HwReg_width_c_U' written by process 'bd_2d50_csc_0_v_csc.Block_split3_proc_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bd_2d50_csc_0_v_csc.HwReg_width_c_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~HwReg_width_c_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bd_2d50_csc_0_v_csc.HwReg_width_c_U' read by process 'bd_2d50_csc_0_v_csc.Block_split3_proc_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bd_2d50_csc_0_v_csc.HwReg_width_c_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~HwReg_InVideoFormat_channel_U.if_empty_n & AXIvideo2MultiPixStream_U0.ap_idle & ~HwReg_InVideoFormat_channel_U.if_write) begin
                            if (~HwReg_InVideoFormat_channel_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bd_2d50_csc_0_v_csc.HwReg_InVideoFormat_channel_U' written by process 'bd_2d50_csc_0_v_csc.Block_split3_proc_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bd_2d50_csc_0_v_csc.HwReg_InVideoFormat_channel_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~HwReg_InVideoFormat_channel_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bd_2d50_csc_0_v_csc.HwReg_InVideoFormat_channel_U' read by process 'bd_2d50_csc_0_v_csc.Block_split3_proc_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bd_2d50_csc_0_v_csc.HwReg_InVideoFormat_channel_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    endcase
                end
                2 : begin
                    case(index2)
                    1: begin
                        if (~v_csc_core_U0.stream_in_blk_n) begin
                            if (~stream_in_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bd_2d50_csc_0_v_csc.stream_in_U' written by process 'bd_2d50_csc_0_v_csc.AXIvideo2MultiPixStream_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bd_2d50_csc_0_v_csc.stream_in_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~stream_in_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bd_2d50_csc_0_v_csc.stream_in_U' read by process 'bd_2d50_csc_0_v_csc.AXIvideo2MultiPixStream_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bd_2d50_csc_0_v_csc.stream_in_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~v_csc_core_U0.height_blk_n) begin
                            if (~HwReg_height_c11_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bd_2d50_csc_0_v_csc.HwReg_height_c11_U' written by process 'bd_2d50_csc_0_v_csc.AXIvideo2MultiPixStream_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bd_2d50_csc_0_v_csc.HwReg_height_c11_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~HwReg_height_c11_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bd_2d50_csc_0_v_csc.HwReg_height_c11_U' read by process 'bd_2d50_csc_0_v_csc.AXIvideo2MultiPixStream_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bd_2d50_csc_0_v_csc.HwReg_height_c11_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~v_csc_core_U0.width_blk_n) begin
                            if (~HwReg_width_c12_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bd_2d50_csc_0_v_csc.HwReg_width_c12_U' written by process 'bd_2d50_csc_0_v_csc.AXIvideo2MultiPixStream_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bd_2d50_csc_0_v_csc.HwReg_width_c12_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~HwReg_width_c12_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bd_2d50_csc_0_v_csc.HwReg_width_c12_U' read by process 'bd_2d50_csc_0_v_csc.AXIvideo2MultiPixStream_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bd_2d50_csc_0_v_csc.HwReg_width_c12_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    3: begin
                        if (~v_csc_core_U0.stream_csc_blk_n) begin
                            if (~stream_csc_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bd_2d50_csc_0_v_csc.stream_csc_U' written by process 'bd_2d50_csc_0_v_csc.MultiPixStream2AXIvideo_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bd_2d50_csc_0_v_csc.stream_csc_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~stream_csc_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bd_2d50_csc_0_v_csc.stream_csc_U' read by process 'bd_2d50_csc_0_v_csc.MultiPixStream2AXIvideo_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bd_2d50_csc_0_v_csc.stream_csc_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~v_csc_core_U0.height_out_blk_n) begin
                            if (~HwReg_height_c13_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bd_2d50_csc_0_v_csc.HwReg_height_c13_U' written by process 'bd_2d50_csc_0_v_csc.MultiPixStream2AXIvideo_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bd_2d50_csc_0_v_csc.HwReg_height_c13_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~HwReg_height_c13_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bd_2d50_csc_0_v_csc.HwReg_height_c13_U' read by process 'bd_2d50_csc_0_v_csc.MultiPixStream2AXIvideo_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bd_2d50_csc_0_v_csc.HwReg_height_c13_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~v_csc_core_U0.width_out_blk_n) begin
                            if (~HwReg_width_c14_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bd_2d50_csc_0_v_csc.HwReg_width_c14_U' written by process 'bd_2d50_csc_0_v_csc.MultiPixStream2AXIvideo_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bd_2d50_csc_0_v_csc.HwReg_width_c14_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~HwReg_width_c14_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bd_2d50_csc_0_v_csc.HwReg_width_c14_U' read by process 'bd_2d50_csc_0_v_csc.MultiPixStream2AXIvideo_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bd_2d50_csc_0_v_csc.HwReg_width_c14_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    0: begin
                        if (~v_csc_core_U0.K11_blk_n) begin
                            if (~HwReg_K11_c_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bd_2d50_csc_0_v_csc.HwReg_K11_c_U' written by process 'bd_2d50_csc_0_v_csc.Block_split3_proc_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bd_2d50_csc_0_v_csc.HwReg_K11_c_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~HwReg_K11_c_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bd_2d50_csc_0_v_csc.HwReg_K11_c_U' read by process 'bd_2d50_csc_0_v_csc.Block_split3_proc_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bd_2d50_csc_0_v_csc.HwReg_K11_c_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~v_csc_core_U0.K12_blk_n) begin
                            if (~HwReg_K12_c_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bd_2d50_csc_0_v_csc.HwReg_K12_c_U' written by process 'bd_2d50_csc_0_v_csc.Block_split3_proc_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bd_2d50_csc_0_v_csc.HwReg_K12_c_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~HwReg_K12_c_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bd_2d50_csc_0_v_csc.HwReg_K12_c_U' read by process 'bd_2d50_csc_0_v_csc.Block_split3_proc_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bd_2d50_csc_0_v_csc.HwReg_K12_c_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~v_csc_core_U0.K13_blk_n) begin
                            if (~HwReg_K13_c_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bd_2d50_csc_0_v_csc.HwReg_K13_c_U' written by process 'bd_2d50_csc_0_v_csc.Block_split3_proc_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bd_2d50_csc_0_v_csc.HwReg_K13_c_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~HwReg_K13_c_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bd_2d50_csc_0_v_csc.HwReg_K13_c_U' read by process 'bd_2d50_csc_0_v_csc.Block_split3_proc_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bd_2d50_csc_0_v_csc.HwReg_K13_c_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~v_csc_core_U0.K21_blk_n) begin
                            if (~HwReg_K21_c_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bd_2d50_csc_0_v_csc.HwReg_K21_c_U' written by process 'bd_2d50_csc_0_v_csc.Block_split3_proc_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bd_2d50_csc_0_v_csc.HwReg_K21_c_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~HwReg_K21_c_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bd_2d50_csc_0_v_csc.HwReg_K21_c_U' read by process 'bd_2d50_csc_0_v_csc.Block_split3_proc_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bd_2d50_csc_0_v_csc.HwReg_K21_c_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~v_csc_core_U0.K22_blk_n) begin
                            if (~HwReg_K22_c_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bd_2d50_csc_0_v_csc.HwReg_K22_c_U' written by process 'bd_2d50_csc_0_v_csc.Block_split3_proc_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bd_2d50_csc_0_v_csc.HwReg_K22_c_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~HwReg_K22_c_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bd_2d50_csc_0_v_csc.HwReg_K22_c_U' read by process 'bd_2d50_csc_0_v_csc.Block_split3_proc_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bd_2d50_csc_0_v_csc.HwReg_K22_c_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~v_csc_core_U0.K23_blk_n) begin
                            if (~HwReg_K23_c_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bd_2d50_csc_0_v_csc.HwReg_K23_c_U' written by process 'bd_2d50_csc_0_v_csc.Block_split3_proc_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bd_2d50_csc_0_v_csc.HwReg_K23_c_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~HwReg_K23_c_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bd_2d50_csc_0_v_csc.HwReg_K23_c_U' read by process 'bd_2d50_csc_0_v_csc.Block_split3_proc_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bd_2d50_csc_0_v_csc.HwReg_K23_c_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~v_csc_core_U0.K31_blk_n) begin
                            if (~HwReg_K31_c_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bd_2d50_csc_0_v_csc.HwReg_K31_c_U' written by process 'bd_2d50_csc_0_v_csc.Block_split3_proc_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bd_2d50_csc_0_v_csc.HwReg_K31_c_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~HwReg_K31_c_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bd_2d50_csc_0_v_csc.HwReg_K31_c_U' read by process 'bd_2d50_csc_0_v_csc.Block_split3_proc_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bd_2d50_csc_0_v_csc.HwReg_K31_c_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~v_csc_core_U0.K32_blk_n) begin
                            if (~HwReg_K32_c_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bd_2d50_csc_0_v_csc.HwReg_K32_c_U' written by process 'bd_2d50_csc_0_v_csc.Block_split3_proc_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bd_2d50_csc_0_v_csc.HwReg_K32_c_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~HwReg_K32_c_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bd_2d50_csc_0_v_csc.HwReg_K32_c_U' read by process 'bd_2d50_csc_0_v_csc.Block_split3_proc_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bd_2d50_csc_0_v_csc.HwReg_K32_c_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~v_csc_core_U0.K33_blk_n) begin
                            if (~HwReg_K33_c_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bd_2d50_csc_0_v_csc.HwReg_K33_c_U' written by process 'bd_2d50_csc_0_v_csc.Block_split3_proc_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bd_2d50_csc_0_v_csc.HwReg_K33_c_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~HwReg_K33_c_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bd_2d50_csc_0_v_csc.HwReg_K33_c_U' read by process 'bd_2d50_csc_0_v_csc.Block_split3_proc_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bd_2d50_csc_0_v_csc.HwReg_K33_c_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~v_csc_core_U0.ROffset_blk_n) begin
                            if (~HwReg_ROffset_V_c_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bd_2d50_csc_0_v_csc.HwReg_ROffset_V_c_U' written by process 'bd_2d50_csc_0_v_csc.Block_split3_proc_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bd_2d50_csc_0_v_csc.HwReg_ROffset_V_c_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~HwReg_ROffset_V_c_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bd_2d50_csc_0_v_csc.HwReg_ROffset_V_c_U' read by process 'bd_2d50_csc_0_v_csc.Block_split3_proc_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bd_2d50_csc_0_v_csc.HwReg_ROffset_V_c_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~v_csc_core_U0.GOffset_blk_n) begin
                            if (~HwReg_GOffset_V_c_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bd_2d50_csc_0_v_csc.HwReg_GOffset_V_c_U' written by process 'bd_2d50_csc_0_v_csc.Block_split3_proc_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bd_2d50_csc_0_v_csc.HwReg_GOffset_V_c_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~HwReg_GOffset_V_c_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bd_2d50_csc_0_v_csc.HwReg_GOffset_V_c_U' read by process 'bd_2d50_csc_0_v_csc.Block_split3_proc_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bd_2d50_csc_0_v_csc.HwReg_GOffset_V_c_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~v_csc_core_U0.BOffset_blk_n) begin
                            if (~HwReg_BOffset_V_c_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bd_2d50_csc_0_v_csc.HwReg_BOffset_V_c_U' written by process 'bd_2d50_csc_0_v_csc.Block_split3_proc_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bd_2d50_csc_0_v_csc.HwReg_BOffset_V_c_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~HwReg_BOffset_V_c_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bd_2d50_csc_0_v_csc.HwReg_BOffset_V_c_U' read by process 'bd_2d50_csc_0_v_csc.Block_split3_proc_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bd_2d50_csc_0_v_csc.HwReg_BOffset_V_c_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~v_csc_core_U0.ClampMin_blk_n) begin
                            if (~HwReg_ClampMin_V_c_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bd_2d50_csc_0_v_csc.HwReg_ClampMin_V_c_U' written by process 'bd_2d50_csc_0_v_csc.Block_split3_proc_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bd_2d50_csc_0_v_csc.HwReg_ClampMin_V_c_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~HwReg_ClampMin_V_c_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bd_2d50_csc_0_v_csc.HwReg_ClampMin_V_c_U' read by process 'bd_2d50_csc_0_v_csc.Block_split3_proc_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bd_2d50_csc_0_v_csc.HwReg_ClampMin_V_c_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~v_csc_core_U0.ClipMax_blk_n) begin
                            if (~HwReg_ClipMax_V_c_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bd_2d50_csc_0_v_csc.HwReg_ClipMax_V_c_U' written by process 'bd_2d50_csc_0_v_csc.Block_split3_proc_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bd_2d50_csc_0_v_csc.HwReg_ClipMax_V_c_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~HwReg_ClipMax_V_c_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bd_2d50_csc_0_v_csc.HwReg_ClipMax_V_c_U' read by process 'bd_2d50_csc_0_v_csc.Block_split3_proc_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bd_2d50_csc_0_v_csc.HwReg_ClipMax_V_c_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~start_for_v_csc_core_U0_U.if_empty_n & v_csc_core_U0.ap_idle & ~start_for_v_csc_core_U0_U.if_write) begin
                            $display("//      Blocked by missing 'ap_start' from start propagation FIFO 'bd_2d50_csc_0_v_csc.start_for_v_csc_core_U0_U' written by process 'bd_2d50_csc_0_v_csc.Block_split3_proc_U0',");
                        end
                    end
                    endcase
                end
                3 : begin
                    case(index2)
                    2: begin
                        if (~MultiPixStream2AXIvideo_U0.stream_csc_blk_n) begin
                            if (~stream_csc_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bd_2d50_csc_0_v_csc.stream_csc_U' written by process 'bd_2d50_csc_0_v_csc.v_csc_core_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bd_2d50_csc_0_v_csc.stream_csc_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~stream_csc_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bd_2d50_csc_0_v_csc.stream_csc_U' read by process 'bd_2d50_csc_0_v_csc.v_csc_core_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bd_2d50_csc_0_v_csc.stream_csc_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~MultiPixStream2AXIvideo_U0.Height_blk_n) begin
                            if (~HwReg_height_c13_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bd_2d50_csc_0_v_csc.HwReg_height_c13_U' written by process 'bd_2d50_csc_0_v_csc.v_csc_core_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bd_2d50_csc_0_v_csc.HwReg_height_c13_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~HwReg_height_c13_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bd_2d50_csc_0_v_csc.HwReg_height_c13_U' read by process 'bd_2d50_csc_0_v_csc.v_csc_core_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bd_2d50_csc_0_v_csc.HwReg_height_c13_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~MultiPixStream2AXIvideo_U0.WidthOut_blk_n) begin
                            if (~HwReg_width_c14_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bd_2d50_csc_0_v_csc.HwReg_width_c14_U' written by process 'bd_2d50_csc_0_v_csc.v_csc_core_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bd_2d50_csc_0_v_csc.HwReg_width_c14_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~HwReg_width_c14_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bd_2d50_csc_0_v_csc.HwReg_width_c14_U' read by process 'bd_2d50_csc_0_v_csc.v_csc_core_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bd_2d50_csc_0_v_csc.HwReg_width_c14_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    0: begin
                        if (~MultiPixStream2AXIvideo_U0.colorFormat_blk_n) begin
                            if (~HwReg_OutVideoFormat_c_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bd_2d50_csc_0_v_csc.HwReg_OutVideoFormat_c_U' written by process 'bd_2d50_csc_0_v_csc.Block_split3_proc_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bd_2d50_csc_0_v_csc.HwReg_OutVideoFormat_c_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~HwReg_OutVideoFormat_c_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bd_2d50_csc_0_v_csc.HwReg_OutVideoFormat_c_U' read by process 'bd_2d50_csc_0_v_csc.Block_split3_proc_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bd_2d50_csc_0_v_csc.HwReg_OutVideoFormat_c_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~start_for_MultiPixStream2AXIvideo_U0_U.if_empty_n & MultiPixStream2AXIvideo_U0.ap_idle & ~start_for_MultiPixStream2AXIvideo_U0_U.if_write) begin
                            $display("//      Blocked by missing 'ap_start' from start propagation FIFO 'bd_2d50_csc_0_v_csc.start_for_MultiPixStream2AXIvideo_U0_U' written by process 'bd_2d50_csc_0_v_csc.Block_split3_proc_U0',");
                        end
                    end
                    endcase
                end
            endcase
        end
    endtask

    // report
    initial begin : report_deadlock
        integer cycle_id;
        integer cycle_comp_id;
        integer record_time;
        wait (reset == 1);
        cycle_id = 1;
        record_time = 0;
        while (1) begin
            @ (negedge clock);
            case (CS_fsm)
                ST_DL_DETECTED: begin
                    cycle_comp_id = 2;
                    if (dl_detect_reg != dl_done_reg) begin
                        if (dl_done_reg == 'b0) begin
                            print_dl_head;
                            record_time = $time;
                        end
                        print_cycle_start(proc_path(origin), cycle_id);
                        cycle_id = cycle_id + 1;
                    end
                    else begin
                        print_dl_end((cycle_id - 1),record_time);
                        find_df_deadlock = 1;
                        @(negedge clock);
                        $finish;
                    end
                end
                ST_DL_REPORT: begin
                    if ((|(dl_in_vec)) & ~(|(dl_in_vec & origin_reg))) begin
                        print_cycle_chan_comp(dl_in_vec_reg, dl_in_vec);
                        print_cycle_proc_comp(proc_path(dl_in_vec), cycle_comp_id);
                        cycle_comp_id = cycle_comp_id + 1;
                    end
                    else begin
                        print_cycle_chan_comp(dl_in_vec_reg, dl_in_vec);
                    end
                end
            endcase
        end
    end
 
