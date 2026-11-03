//=============================================================================
// tv_prox.v -- fixed-point, fixed-iteration TV proximal operator
//
// MATLAB source : Functions/reconstruct_tv.m  ->  co_prox_tv()
//                 (the same code is inlined at the bottom of
//                  Functions/reconstruct_tv_it_cbg.m)
//
//     sol = argmin_x  0.5*||x-b||^2 + lambda*TV_iso(x)
//
// Beck & Teboulle dual FISTA iteration, reflexive (zero) boundary conditions:
//
//     Lt(x):  p[i,j] = x[i,j]-x[i+1,j]      q[i,j] = x[i,j]-x[i,j+1]
//     L(dx,dy)[i,j] = dx[i,j]+dy[i,j]-dx[i-1,j]-dy[i,j-1]   (zero padded)
//
//   repeat:
//     sol    = Pc(b - lambda*L(r,s))
//     [tr,ts]= Lt(sol)
//     r     += (1/(8*lambda))*tr ;  s += (1/(8*lambda))*ts
//     w      = max(1, sqrt(r^2+s^2)) ;  p = r/w ; q = s/w
//     t      = (1+sqrt(1+4*t^2))/2
//     r      = p + ((t-1)/t)*(p-p_old) ; s = q + ((t-1)/t)*(q-q_old)
//     p_old  = p ; q_old = q
//
// Two deliberate hardware substitutions, both prescribed by the competition
// plan and both quantified in docs/FIXED_POINT.md:
//   * MATLAB's `while(1)` + relative-tolerance exit becomes a FIXED iteration
//     count (deterministic latency, no data-dependent loop);
//   * doubles become 16-bit Q3.12 samples with Q16.16 constants.
//
// Numerics
//   samples         signed 16-bit, Q3.12   (+-8, resolution 2^-12)
//   lam, 1/(8lam)   signed 32-bit, Q16.16  (supplied pre-scaled by the host)
//   t, coef         signed 32-bit, Q16.16
//   accumulators    48/50-bit, saturated
//
// Storage: ten P-deep sample RAMs, P = H*W.  P <= 1024 keeps it all in BRAM.
//=============================================================================
`default_nettype none

module tv_prox #(
    parameter integer H         = 12,
    parameter integer W         = 16,
    parameter integer P         = 192,      // H*W
    parameter integer AW        = 8,        // >= ceil(log2(P))
    parameter integer IW        = 4,        // >= ceil(log2(H))
    parameter integer JW        = 4,        // >= ceil(log2(W))
    parameter integer PROC_W    = 16,
    parameter integer PROC_FRAC = 12
) (
    input  wire                     clk,
    input  wire                     rst_n,

    // image load port (Q3.12)
    input  wire                     b_we,
    input  wire [AW-1:0]            b_addr,
    input  wire signed [PROC_W-1:0] b_data,

    // runtime configuration
    input  wire signed [31:0]       lam_q16,
    input  wire signed [31:0]       inv8lam_q16,
    input  wire [7:0]               iters,
    input  wire                     nonneg,   // 1: Pc(x)=max(0,x);  0: identity (MATLAB 'none')

    // control / status
    input  wire                     start,
    output reg                      busy,
    output reg                      done,
    output reg  [7:0]               iters_done,

    // result read port
    input  wire [AW-1:0]            rd_addr,
    output wire signed [PROC_W-1:0] rd_data
);

    localparam integer ONE = (1 << PROC_FRAC);

    // MATLAB initialises r, s, p_old, q_old to zero before the loop.  The RAMs
    // are deliberately NOT reset-loop cleared (that would cost P*6 flops of
    // reset); instead S_INIT walks them once per `start`, which also gives a
    // clean state for every new frame.
    localparam [3:0] S_IDLE   = 4'd0,
                     S_INIT   = 4'd1,
                     S_L      = 4'd2,
                     S_LT     = 4'd3,
                     S_UPD    = 4'd4,
                     S_PROJ   = 4'd5,
                     S_T      = 4'd6,
                     S_EXTRAP = 4'd7,
                     S_DONE   = 4'd8;

    localparam [2:0] PS_CHK    = 3'd0,
                     PS_WAITQ  = 3'd1,
                     PS_WAITR  = 3'd2,
                     PS_WAITS  = 3'd3,
                     PS_WAITQ2 = 3'd4;

    localparam [1:0] TS_SQRT = 2'd0,
                     TS_WAIT = 2'd1,
                     TS_DONE = 2'd2;

    // ---- sample storage -----------------------------------------------------
    reg signed [PROC_W-1:0] bmem  [0:P-1];
    reg signed [PROC_W-1:0] rmem  [0:P-1];
    reg signed [PROC_W-1:0] smem  [0:P-1];
    reg signed [PROC_W-1:0] pmem  [0:P-1];
    reg signed [PROC_W-1:0] qmem  [0:P-1];
    reg signed [PROC_W-1:0] pomem [0:P-1];
    reg signed [PROC_W-1:0] qomem [0:P-1];
    reg signed [PROC_W-1:0] solmem[0:P-1];
    reg signed [PROC_W-1:0] trmem [0:P-1];
    reg signed [PROC_W-1:0] tsmem [0:P-1];

    always @(posedge clk) if (b_we) bmem[b_addr] <= b_data;
    assign rd_data = solmem[rd_addr];

    // ---- control / index registers -----------------------------------------
    reg [3:0]         state;
    reg [2:0]         pstate;
    reg [1:0]         tstate;
    reg [AW-1:0]      n;
    reg [IW-1:0]      ii;
    reg [JW-1:0]      jj;
    reg [7:0]         itcnt;
    reg [7:0]         iters_r;
    reg signed [31:0] lam_r, inv8lam_r, t_r, coef_r;
    reg               nonneg_r;

    wire at_end = (n == (P - 1));

    task adv;
        begin
            if (jj == (W - 1)) begin
                jj <= {JW{1'b0}};
                ii <= (ii == (H - 1)) ? {IW{1'b0}} : (ii + 1'b1);
            end else begin
                jj <= jj + 1'b1;
            end
            n <= at_end ? {AW{1'b0}} : (n + 1'b1);
        end
    endtask

    // sub-module handshakes are declared here because the tasks below use them
    reg          isq_start;
    reg  [31:0]  isq_value;
    wire [15:0]  isq_root;
    wire         isq_done, isq_busy;

    reg          divp_start;
    reg  [31:0]  divp_num;
    reg  [15:0]  divp_den;
    wire [23:0]  divp_q;
    wire [15:0]  divp_rem;
    wire         divp_done, divp_busy, divp_div0;

    reg          divt_start;
    reg  [47:0]  divt_num;
    reg  [31:0]  divt_den;
    wire [31:0]  divt_q;
    wire [31:0]  divt_rem;
    wire         divt_done, divt_busy, divt_div0;

    task finish_pixel;
        begin
            adv;
            if (at_end) begin
                state  <= S_T;
                tstate <= TS_SQRT;
            end
        end
    endtask

    // ---- saturation helper --------------------------------------------------
    function signed [PROC_W-1:0] sat16;
        input signed [63:0] v;
        begin
            if (v > 64'sd32767)
                sat16 = 16'sd32767;
            else if (v < -64'sd32768)
                sat16 = -16'sd32768;
            else
                sat16 = v[PROC_W-1:0];
        end
    endfunction

    // ---- neighbour index computation (guarded against under/overflow) -------
    wire [AW-1:0] n_up  = (ii != 0)       ? (n - W) : {AW{1'b0}};
    wire [AW-1:0] n_dn  = (ii != (H - 1)) ? (n + W) : {AW{1'b0}};
    wire [AW-1:0] n_lft = (jj != 0)       ? (n - 1) : {AW{1'b0}};
    wire [AW-1:0] n_rgt = (jj != (W - 1)) ? (n + 1) : {AW{1'b0}};

    // ---- L(r,s) and Pc ------------------------------------------------------
    wire signed [PROC_W-1:0] r_cur = rmem[n];
    wire signed [PROC_W-1:0] s_cur = smem[n];
    wire signed [PROC_W-1:0] r_up  = (ii != 0) ? rmem[n_up]  : {PROC_W{1'b0}};
    wire signed [PROC_W-1:0] s_lft = (jj != 0) ? smem[n_lft] : {PROC_W{1'b0}};

    wire signed [17:0] lrs = {{2{r_cur[15]}}, r_cur} + {{2{s_cur[15]}}, s_cur}
                           - {{2{r_up[15]}},  r_up}  - {{2{s_lft[15]}}, s_lft};
    wire signed [49:0] lprod = lam_r * lrs;                 // Q(16+12+2) scaled
    wire signed [33:0] lsh   = lprod >>> 16;                // back to Q3.12
    wire signed [63:0] lval  = {{48{bmem[n][15]}}, bmem[n]}
                             - {{30{lsh[33]}}, lsh};
    wire signed [PROC_W-1:0] sol_new = nonneg_r
                                     ? ((lval > 0) ? sat16(lval) : {PROC_W{1'b0}})
                                     : sat16(lval);

    // ---- Lt(sol) ------------------------------------------------------------
    // MATLAB:  p[:-1,:] = x[:-1,:]-x[1:,:]   leaves p[H-1,:] = 0
    //          q[:,:-1] = x[:,:-1]-x[:,1:]   leaves q[:,W-1] = 0
    // The boundary entries are ZERO, not x -- getting this wrong only corrupts
    // the last row / last column, which is exactly how it showed up.
    wire signed [PROC_W-1:0] sol_cur = solmem[n];
    wire signed [PROC_W-1:0] sol_dn  = solmem[n_dn];
    wire signed [PROC_W-1:0] sol_rt  = solmem[n_rgt];
    wire signed [63:0]       tr_w    = {{48{sol_cur[15]}}, sol_cur}
                                     - {{48{sol_dn[15]}},  sol_dn};
    wire signed [63:0]       ts_w    = {{48{sol_cur[15]}}, sol_cur}
                                     - {{48{sol_rt[15]}},  sol_rt};

    // ---- r/s accumulation ---------------------------------------------------
    wire signed [47:0] radd = inv8lam_r * trmem[n];
    wire signed [47:0] sadd = inv8lam_r * tsmem[n];
    wire signed [63:0] rval = {{48{rmem[n][15]}}, rmem[n]} + {{32{radd[47]}}, radd[47:16]};
    wire signed [63:0] sval = {{48{smem[n][15]}}, smem[n]} + {{32{sadd[47]}}, sadd[47:16]};

    // ---- projection stage ---------------------------------------------------
    reg signed [PROC_W-1:0] rv_r, sv_r;
    reg                     r_neg, s_neg;

    wire signed [32:0] nn_sq  = rv_r * rv_r + sv_r * sv_r;   // 33-bit, non-negative
    wire [31:0]        nn     = {{11{1'b0}}, nn_sq[32:PROC_FRAC]};   // Q(12) of |(r,s)|^2
    // Sign-extend to 32 bits BEFORE negating: {16'b0, rv_r} would treat a
    // negative 16-bit sample as a large positive number.
    wire signed [31:0] rv_s   = {{16{rv_r[15]}}, rv_r};
    wire signed [31:0] sv_s   = {{16{sv_r[15]}}, sv_r};
    wire [31:0]        rv_abs = r_neg ? (~rv_s + 32'sd1) : rv_s;
    wire [31:0]        sv_abs = s_neg ? (~sv_s + 32'sd1) : sv_s;
    wire [15:0]        wq     = isq_root << (PROC_FRAC / 2);  // Q(12) of |(r,s)|
    wire signed [63:0] pmag   = {{40{1'b0}}, divp_q};

    // ---- extrapolation stage ------------------------------------------------
    wire signed [16:0] dp = {{1{pmem[n][15]}}, pmem[n]} - {{1{pomem[n][15]}}, pomem[n]};
    wire signed [16:0] dq = {{1{qmem[n][15]}}, qmem[n]} - {{1{qomem[n][15]}}, qomem[n]};
    wire signed [48:0] pdiff = coef_r * dp;                  // 32 x 17
    wire signed [48:0] qdiff = coef_r * dq;
    // Q16.16 multiply -> take bits [48:16] (a shift by 16, NOT 15)
    wire signed [63:0] rnext = {{48{pmem[n][15]}}, pmem[n]} + {{31{pdiff[48]}}, pdiff[48:16]};
    wire signed [63:0] snext = {{48{qmem[n][15]}}, qmem[n]} + {{31{qdiff[48]}}, qdiff[48:16]};

    // ---- FISTA scalar -------------------------------------------------------
    wire [63:0] t2       = {32'd0, t_r} * {32'd0, t_r};
    wire [31:0] isq_arg  = ((t2 << 2) >>> 16) + 32'd65536;   // Q16.16 of 1+4t^2
    wire [31:0] t_new_v  = 32'd32768 + ({{16{1'b0}}, isq_root} << 7);

    // ---- sub-module instances ----------------------------------------------
    isqrt_seq #(.IN_W(32), .OUT_W(16)) u_isqrt (
        .clk(clk), .rst_n(rst_n), .start(isq_start), .value(isq_value),
        .root(isq_root), .done(isq_done), .busy(isq_busy)
    );

    div_seq #(.NUM_W(32), .DEN_W(16), .QUOT_W(24)) u_divp (
        .clk(clk), .rst_n(rst_n), .start(divp_start),
        .num(divp_num), .den(divp_den),
        .quot(divp_q), .rem(divp_rem),
        .done(divp_done), .busy(divp_busy), .div0(divp_div0)
    );

    div_seq #(.NUM_W(48), .DEN_W(32), .QUOT_W(32)) u_divt (
        .clk(clk), .rst_n(rst_n), .start(divt_start),
        .num(divt_num), .den(divt_den),
        .quot(divt_q), .rem(divt_rem),
        .done(divt_done), .busy(divt_busy), .div0(divt_div0)
    );

    // ---- main FSM -----------------------------------------------------------
    always @(posedge clk) begin
        if (!rst_n) begin
            state      <= S_IDLE;
            pstate     <= PS_CHK;
            tstate     <= TS_SQRT;
            n          <= {AW{1'b0}};
            ii         <= {IW{1'b0}};
            jj         <= {JW{1'b0}};
            itcnt      <= 8'd0;
            iters_r    <= 8'd0;
            busy       <= 1'b0;
            done       <= 1'b0;
            iters_done <= 8'd0;
            coef_r     <= 32'sd0;
            t_r        <= 32'sd65536;
            isq_start  <= 1'b0;
            divp_start <= 1'b0;
            divt_start <= 1'b0;
            rv_r       <= 16'sd0;
            sv_r       <= 16'sd0;
            r_neg      <= 1'b0;
            s_neg      <= 1'b0;
            nonneg_r   <= 1'b0;
            lam_r      <= 32'sd0;
            inv8lam_r  <= 32'sd0;
        end else begin
            isq_start  <= 1'b0;
            divp_start <= 1'b0;
            divt_start <= 1'b0;
            done       <= 1'b0;

            case (state)
            // -------------------------------------------------------------
            S_IDLE: begin
                if (start) begin
                    lam_r      <= lam_q16;
                    inv8lam_r  <= inv8lam_q16;
                    iters_r    <= iters;
                    nonneg_r   <= nonneg;
                    n          <= {AW{1'b0}};
                    ii         <= {IW{1'b0}};
                    jj         <= {JW{1'b0}};
                    itcnt      <= 8'd0;
                    t_r        <= 32'sd65536;      // t_old = 1.0
                    coef_r     <= 32'sd0;
                    iters_done <= 8'd0;
                    busy       <= 1'b1;
                    state      <= (iters == 0) ? S_DONE : S_INIT;
                end
            end
            // ---- r = s = p = q = p_old = q_old = 0 -----------------------
            S_INIT: begin
                rmem[n]  <= {PROC_W{1'b0}};
                smem[n]  <= {PROC_W{1'b0}};
                pmem[n]  <= {PROC_W{1'b0}};
                qmem[n]  <= {PROC_W{1'b0}};
                pomem[n] <= {PROC_W{1'b0}};
                qomem[n] <= {PROC_W{1'b0}};
                adv;
                if (at_end) state <= S_L;
            end
            // ---- sol = Pc(b - lam*L(r,s)) --------------------------------
            S_L: begin
                solmem[n] <= sol_new;
                adv;
                if (at_end) state <= S_LT;
            end
            // ---- [tr,ts] = Lt(sol) ---------------------------------------
            S_LT: begin
                // zero the operator output on the last row / last column
                trmem[n] <= (ii == (H - 1)) ? {PROC_W{1'b0}} : sat16(tr_w);
                tsmem[n] <= (jj == (W - 1)) ? {PROC_W{1'b0}} : sat16(ts_w);
                adv;
                if (at_end) state <= S_UPD;
            end
            // ---- r += (1/(8lam))*tr ; s += (1/(8lam))*ts ------------------
            S_UPD: begin
                rmem[n] <= sat16(rval);
                smem[n] <= sat16(sval);
                adv;
                if (at_end) begin
                    state  <= S_PROJ;
                    pstate <= PS_CHK;
                end
            end
            // ---- p = r/max(1,|(r,s)|) ; q = s/max(1,|(r,s)|) -------------
            S_PROJ: begin
                case (pstate)
                PS_CHK: begin
                    rv_r   <= rmem[n];
                    sv_r   <= smem[n];
                    r_neg  <= rmem[n][15];
                    s_neg  <= smem[n][15];
                    pstate <= PS_WAITQ;
                end
                PS_WAITQ: begin
                    if (nn <= ONE) begin
                        pmem[n] <= rv_r;
                        qmem[n] <= sv_r;
                        finish_pixel;
                        pstate  <= PS_CHK;
                    end else begin
                        isq_value <= nn;
                        isq_start <= 1'b1;
                        pstate    <= PS_WAITR;
                    end
                end
                PS_WAITR: begin
                    if (isq_done) begin
                        if (wq == 16'd0) begin
                            pmem[n] <= rv_r;
                            qmem[n] <= sv_r;
                            finish_pixel;
                            pstate  <= PS_CHK;
                        end else begin
                            divp_num   <= rv_abs << PROC_FRAC;
                            divp_den   <= wq;
                            divp_start <= 1'b1;
                            pstate     <= PS_WAITS;
                        end
                    end
                end
                PS_WAITS: begin
                    if (divp_done) begin
                        pmem[n]    <= sat16(r_neg ? -pmag : pmag);
                        divp_num   <= sv_abs << PROC_FRAC;
                        divp_den   <= wq;
                        divp_start <= 1'b1;
                        pstate     <= PS_WAITQ2;
                    end
                end
                PS_WAITQ2: begin
                    if (divp_done) begin
                        qmem[n] <= sat16(s_neg ? -pmag : pmag);
                        finish_pixel;
                        pstate  <= PS_CHK;
                    end
                end
                default: pstate <= PS_CHK;
                endcase
            end
            // -------------------------------------------------------------
            S_T: begin
                case (tstate)
                TS_SQRT: begin
                    isq_value <= isq_arg;
                    isq_start <= 1'b1;
                    tstate    <= TS_WAIT;
                end
                TS_WAIT: begin
                    if (isq_done) begin
                        divt_num   <= ({32'd0, t_new_v} - 64'd65536) << 16;
                        divt_den   <= t_new_v;
                        divt_start <= 1'b1;
                        tstate     <= TS_DONE;
                    end
                end
                TS_DONE: begin
                    if (divt_done) begin
                        coef_r <= divt_q;
                        t_r    <= t_new_v;
                        n      <= {AW{1'b0}};
                        ii     <= {IW{1'b0}};
                        jj     <= {JW{1'b0}};
                        state  <= S_EXTRAP;
                    end
                end
                default: tstate <= TS_SQRT;
                endcase
            end
            // ---- r = p + coef*(p-p_old) ; p_old = p -----------------------
            S_EXTRAP: begin
                rmem[n]  <= sat16(rnext);
                smem[n]  <= sat16(snext);
                pomem[n] <= pmem[n];
                qomem[n] <= qmem[n];
                adv;
                if (at_end) begin
                    itcnt      <= itcnt + 8'd1;
                    iters_done <= itcnt + 8'd1;
                    state      <= ((itcnt + 8'd1) >= iters_r) ? S_DONE : S_L;
                end
            end
            // -------------------------------------------------------------
            S_DONE: begin
                busy  <= 1'b0;
                done  <= 1'b1;
                state <= S_IDLE;
            end
            default: state <= S_IDLE;
            endcase
        end
    end

endmodule

`default_nettype wire
