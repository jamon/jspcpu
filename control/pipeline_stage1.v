module pipeline_stage1 #(
    parameter WIDTH = 8
) (
    input clk,
    // verilator lint_off UNUSED
    input bus_request, fetch_suppress,
    // verilator lint_on UNUSED
    input flag_overflow, flag_sign, flag_zero, flag_acarry, flag_lcarry, flag_pcraflip, flag_reset,
    input [7:0] instruction,
    output [7:0] instruction_out,
    output [15:0] controls_out,

    // grouped controls
    output [1:0] lhs_select,
    output [1:0] rhs_select,
    output [3:0] aluop_select,
    output [3:0] xferload_select,
    output [2:0] xferassert_select,

    // individual controls
    output a_assert_lhs, b_assert_lhs, c_assert_lhs, d_assert_lhs,
    output a_assert_rhs, b_assert_rhs, c_assert_rhs, d_assert_rhs,
    output pcra0_load_xfer, pcra1_load_xfer, sp_load_xfer, si_load_xfer, di_load_xfer, tx_load_xfer, const_load_mem, pcra0_dec, pcra1_dec, sp_dec, si_dec, di_dec,
    output pcra0_assert_xfer, pcra1_assert_xfer, sp_assert_xfer, si_assert_xfer, di_assert_xfer, tx_assert_xfer, tx_assert_mode,
    output fetch_suppress_out
);
    reg [WIDTH-1:0] rom1 [0:32767];
    reg [WIDTH-1:0] rom2 [0:32767];

    // verilator lint_off UNUSED
    reg [7:0] prev_instruction = 0;
    // verilator lint_on UNUSED
    reg [15:0] controls = 0;

    initial begin
        // controls = 0;
        //$readmemh("/home/jamon/code/ecp5/jspcpu/control/pipeline-stage1-rom1.mem", rom1);
        //$readmemh("/home/jamon/code/ecp5/jspcpu/control/pipeline-stage1-rom2.mem", rom2);
        $readmemh("C:/users/ms/Documents/code/jspcpu/control/pipeline-stage1-rom1.mem", rom1);
        $readmemh("C:/users/ms/Documents/code/jspcpu/control/pipeline-stage1-rom2.mem", rom2);
        
    end
  
    wire [14:0] addr = {flag_reset, flag_pcraflip, flag_lcarry, flag_acarry, flag_zero, flag_sign, flag_overflow, instruction};
    always @(negedge clk) begin
        prev_instruction <= instruction;
        controls <= {rom2[addr], rom1[addr]};
    end

    // assign instruction_out = (bus_request == 1 || fetch_suppress == 1) ? 0 : prev_instruction;
    assign instruction_out = prev_instruction;

    assign controls_out = controls;
    
    // verilator lint_off UNUSED
    assign lhs_select = controls[1:0];
    assign rhs_select = controls[3:2];
    assign aluop_select = controls[7:4];
    assign xferload_select = controls[11:8];
    assign xferassert_select = controls[14:12];

    assign a_assert_lhs = lhs_select == 2'h0 ? 0 : 1;
    assign b_assert_lhs = lhs_select == 2'h1 ? 0 : 1;
    assign c_assert_lhs = lhs_select == 2'h2 ? 0 : 1;
    assign d_assert_lhs = lhs_select == 2'h3 ? 0 : 1;

    assign a_assert_rhs = rhs_select == 2'h0 ? 0 : 1;
    assign b_assert_rhs = rhs_select == 2'h1 ? 0 : 1;
    assign c_assert_rhs = rhs_select == 2'h2 ? 0 : 1;
    assign d_assert_rhs = rhs_select == 2'h3 ? 0 : 1;

    assign pcra0_load_xfer  = xferload_select == 4'h1 ? 0 : 1;
    assign pcra1_load_xfer  = xferload_select == 4'h2 ? 0 : 1;
    assign sp_load_xfer     = xferload_select == 4'h3 ? 0 : 1;
    assign si_load_xfer     = xferload_select == 4'h4 ? 0 : 1;
    assign di_load_xfer     = xferload_select == 4'h5 ? 0 : 1;
    assign tx_load_xfer     = xferload_select == 4'h6 ? 0 : 1;

    assign const_load_mem   = xferload_select == 4'h8 ? 0 : 1;

    assign pcra0_dec        = xferload_select == 4'h9 ? 0 : 1;
    assign pcra1_dec        = xferload_select == 4'hA ? 0 : 1;
    assign sp_dec           = xferload_select == 4'hB ? 0 : 1;
    assign si_dec           = xferload_select == 4'hC ? 0 : 1;
    assign di_dec           = xferload_select == 4'hD ? 0 : 1;

    assign pcra0_assert_xfer    = xferassert_select == 3'h1 ? 0 : 1;
    assign pcra1_assert_xfer    = xferassert_select == 3'h2 ? 0 : 1;
    assign sp_assert_xfer       = xferassert_select == 3'h3 ? 0 : 1;
    assign si_assert_xfer       = xferassert_select == 3'h4 ? 0 : 1;
    assign di_assert_xfer       = xferassert_select == 3'h5 ? 0 : 1;
    assign tx_assert_xfer       = xferassert_select == 3'h6 ? 0 : 1;
    assign tx_assert_mode       = xferassert_select == 3'h7 ? 0 : 1;

    assign fetch_suppress_out = controls[15];

    // verilator lint_on UNUSED


endmodule
