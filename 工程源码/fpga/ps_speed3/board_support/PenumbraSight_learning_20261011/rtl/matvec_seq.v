//=============================================================================
// matvec_seq.v -- streaming matrix-vector product  y = M * x
//
// One MAC per clock, matrix supplied row-major through a streaming port, the
// vector loaded into an internal RAM first.  This is the workhorse behind both
//   * the localization projection   z = U^T d                (rtl/proj_score.v)
//   * the low-rank forward/adjoint  Bf = U*(S.*(V^T f))      (see docs)
//   * the least-squares gradient    g = A^T (A x - m)
//
// Timing: 1 + ROWS*N clocks per product, II = 1 on the matrix port.
//=============================================================================
`default_nettype none

module matvec_seq #(
    parameter integer ROWS  = 8,
    parameter integer N     = 16,
    parameter integer MW    = 16,      // matrix element width (signed)
    parameter integer XW    = 16,      // vector element width (signed)
    parameter integer ACC_W = 48,
    parameter integer ADDRW = 8        // >= ceil(log2(max(ROWS,N)))
) (
    input  wire                    clk,
    input  wire                    rst_n,

    // vector load port
    input  wire                    x_we,
    input  wire [ADDRW-1:0]        x_addr,
    input  wire signed [XW-1:0]    x_data,

    // control
    input  wire                    start,
    output reg                     busy,
    output reg                     done,

    // matrix stream (row-major, ROWS*N values)
    input  wire                    m_valid,
    input  wire signed [MW-1:0]    m_data,

    // result stream
    output reg                     y_valid,
    output reg  [ADDRW-1:0]        y_index,
    output reg  signed [ACC_W-1:0] y_data
);

    localparam integer PROD_W = MW + XW;

    reg signed [XW-1:0] xmem [0:N-1];

    reg [15:0]        row;
    reg [15:0]        col;
    reg signed [ACC_W-1:0] acc;
    reg               running;

    wire signed [XW-1:0]    xv   = xmem[col[ADDRW-1:0]];
    wire signed [PROD_W-1:0] prod = m_data * xv;
    wire signed [ACC_W-1:0]  acc_next =
        acc + {{(ACC_W-PROD_W){prod[PROD_W-1]}}, prod};

    wire last_col = (col == (N - 1));
    wire last_row = (row == (ROWS - 1));

    always @(posedge clk) begin
        if (x_we) xmem[x_addr] <= x_data;
    end

    always @(posedge clk) begin
        if (!rst_n) begin
            row       <= 16'd0;
            col       <= 16'd0;
            acc       <= {ACC_W{1'b0}};
            running   <= 1'b0;
            busy      <= 1'b0;
            done      <= 1'b0;
            y_valid   <= 1'b0;
            y_index   <= {ADDRW{1'b0}};
            y_data    <= {ACC_W{1'b0}};
        end else begin
            done    <= 1'b0;
            y_valid <= 1'b0;
            if (start && !busy) begin
                row     <= 16'd0;
                col     <= 16'd0;
                acc     <= {ACC_W{1'b0}};
                running <= 1'b1;
                busy    <= 1'b1;
            end else if (running && m_valid) begin
                if (last_col) begin
                    acc       <= {ACC_W{1'b0}};
                    col       <= 16'd0;
                    y_valid   <= 1'b1;
                    y_index   <= row[ADDRW-1:0];
                    y_data    <= acc_next;
                    if (last_row) begin
                        running <= 1'b0;
                        busy    <= 1'b0;
                        done    <= 1'b1;
                    end else begin
                        row <= row + 16'd1;
                    end
                end else begin
                    acc <= acc_next;
                    col <= col + 16'd1;
                end
            end
        end
    end

endmodule

`default_nettype wire
