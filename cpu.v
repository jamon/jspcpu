`include "control/control.v"
`include "core/core.v"
module cpu #(
    parameter WIDTH_MAIN = 8,
    parameter WIDTH_AX = 16
) (
    input clk,
    input reset,

    input [WIDTH_MAIN-1:0] test_main_out,
    input [WIDTH_AX-1:0] test_addr_out, test_xfer_out,
    input test_main_en, test_addr_en, test_xfer_en
);
    // stage 0 - individual
    wire pcra0_inc;
    wire pcra1_inc;

    // stage 1 - grouped
    // verilator lint_off UNUSED
    wire [15:0] control_stage1;

    wire [1:0] lhs_select;
    wire [1:0] rhs_select;
    wire [3:0] aluop_select;
    wire [3:0] xferload_select;
    wire [2:0] xferassert_select;
    // verilator lint_on UNUSED

    // stage 1 - individual
    wire a_assert_lhs, b_assert_lhs, c_assert_lhs, d_assert_lhs;
    wire a_assert_rhs, b_assert_rhs, c_assert_rhs, d_assert_rhs;
    wire pcra0_load_xfer, pcra1_load_xfer, sp_load_xfer, si_load_xfer, di_load_xfer, xfer_load_xfer, const_load_mem, pcra0_dec, pcra1_dec, sp_dec, si_dec, di_dec;
    wire pcra0_assert_xfer, pcra1_assert_xfer, sp_assert_xfer, si_assert_xfer, di_assert_xfer, xfer_assert_xfer /*, xfer_assert_mode */;
    // verilator lint_off UNUSED
    wire xfer_assert_mode;
    wire fetch_suppress_out;
    // verilator lint_on UNUSED

    // stage 2 - grouped
    // verilator lint_off UNUSED

    wire [15:0] control_stage2;

    wire [3:0] mainbus_assert_select;
    wire [3:0] mainbus_load_select;
    wire [1:0] spsidi_inc_select;
    wire [2:0] addr_select;
    // verilator lint_on UNUSED

    // stage 2 - individual
    // verilator lint_off UNUSED
    wire a_assert_main, b_assert_main, c_assert_main, d_assert_main, const_assert_main, xfer_assertlow_main, xfer_asserthigh_main, alu_assert_main, dev9_assert_main, dev10_assert_main, dev11_assert_main, dev12_assert_main, dev13_assert_main, dev14_assert_main, mem_assert_main;
    wire a_load_main, b_load_main, c_load_main, d_load_main, const_load_main, xfer_loadlow_main, xfer_loadhigh_main, alu_load_main, dev9_load_main, dev10_load_main, dev11_load_main, dev12_load_main, dev13_load_main, dev14_load_main, mem_load_main, mem_dir;
    wire sp_inc, si_inc, di_inc;
    wire mem_ack, pcra0_assert_addr, pcra1_assert_addr, sp_assert_addr, si_assert_addr, di_assert_addr, xfer_assert_addr;
    wire mem_ack;
    wire bus_request_out;
    wire pcra_flip_out;
    wire break_out;
    // verilator lint_on UNUSED

    control control (
        .clk(clk),

        .bus_in(mem_out),
        .flag_reset(flag_reset),
        .flag_lcarry(flag_lcarry),
        .flag_acarry(flag_acarry),
        .flag_zero(flag_zero),
        .flag_sign(flag_sign),
        .flag_overflow(flag_overflow),

        // control - stage 0
        // individual
        .pcra0_inc(pcra0_inc),
        .pcra1_inc(pcra1_inc),


        // control - stage 1
        // grouped
        .control_stage1(control_stage1),
        .lhs_select(lhs_select),
        .rhs_select(rhs_select),
        .aluop_select(aluop_select),
        .xferload_select(xferload_select),
        .xferassert_select(xferassert_select),

        // individual
        .a_assert_lhs(a_assert_lhs),
        .b_assert_lhs(b_assert_lhs),
        .c_assert_lhs(c_assert_lhs),
        .d_assert_lhs(d_assert_lhs),

        .a_assert_rhs(a_assert_rhs),
        .b_assert_rhs(b_assert_rhs),
        .c_assert_rhs(c_assert_rhs),
        .d_assert_rhs(d_assert_rhs),
        
        .pcra0_load_xfer(pcra0_load_xfer),
        .pcra1_load_xfer(pcra1_load_xfer),
        .sp_load_xfer(sp_load_xfer),
        .si_load_xfer(si_load_xfer),
        .di_load_xfer(di_load_xfer),
        .xfer_load_xfer(xfer_load_xfer),
        
        .const_load_mem(const_load_mem),
        
        .pcra0_dec(pcra0_dec),
        .pcra1_dec(pcra1_dec),
        .sp_dec(sp_dec),
        .si_dec(si_dec),
        .di_dec(di_dec),
        
        .pcra0_assert_xfer(pcra0_assert_xfer),
        .pcra1_assert_xfer(pcra1_assert_xfer),
        .sp_assert_xfer(sp_assert_xfer),
        .si_assert_xfer(si_assert_xfer),
        .di_assert_xfer(di_assert_xfer),
        .xfer_assert_xfer(xfer_assert_xfer),
        .xfer_assert_mode(xfer_assert_mode),
        
        .fetch_suppress_out(fetch_suppress_out),

        // control - stage 2
        // grouped
        .control_stage2(control_stage2),
        .mainbus_assert_select(mainbus_assert_select),
        .mainbus_load_select(mainbus_load_select),
        .spsidi_inc_select(spsidi_inc_select),
        .addr_select(addr_select),

        // individual
        .a_assert_main(a_assert_main),
        .b_assert_main(b_assert_main),
        .c_assert_main(c_assert_main),
        .d_assert_main(d_assert_main),
        .const_assert_main(const_assert_main),
        .xfer_assertlow_main(xfer_assertlow_main),
        .xfer_asserthigh_main(xfer_asserthigh_main),
        .alu_assert_main(alu_assert_main),
        .dev9_assert_main(dev9_assert_main),
        .dev10_assert_main(dev10_assert_main),
        .dev11_assert_main(dev11_assert_main),
        .dev12_assert_main(dev12_assert_main),
        .dev13_assert_main(dev13_assert_main),
        .dev14_assert_main(dev14_assert_main),
        .mem_assert_main(mem_assert_main),

        .a_load_main(a_load_main),
        .b_load_main(b_load_main),
        .c_load_main(c_load_main),
        .d_load_main(d_load_main),
        .const_load_main(const_load_main),
        .xfer_loadlow_main(xfer_loadlow_main),
        .xfer_loadhigh_main(xfer_loadhigh_main),
        .alu_load_main(alu_load_main),
        .dev9_load_main(dev9_load_main),
        .dev10_load_main(dev10_load_main),
        .dev11_load_main(dev11_load_main),
        .dev12_load_main(dev12_load_main),
        .dev13_load_main(dev13_load_main),
        .dev14_load_main(dev14_load_main),
        .mem_load_main(mem_load_main),
        .mem_dir(mem_dir),

        .sp_inc(sp_inc),
        .si_inc(si_inc),
        .di_inc(di_inc),

        .mem_ack(mem_ack),
        .pcra0_assert_addr(pcra0_assert_addr),
        .pcra1_assert_addr(pcra1_assert_addr),
        .sp_assert_addr(sp_assert_addr),
        .si_assert_addr(si_assert_addr),
        .di_assert_addr(di_assert_addr),
        .xfer_assert_addr(xfer_assert_addr),

        .bus_request_out(bus_request_out),
        .pcra_flip_out(pcra_flip_out),
        .break_out(break_out)
    );

    wire flag_reset = 0;
    wire flag_lcarry;
    wire flag_acarry;
    wire flag_zero;
    wire flag_sign;
    wire flag_overflow;
    wire [WIDTH_MAIN-1:0] mem_out;

    core core(
        .clk(clk),
        .reset(reset),

        // test inputs
        .test_main_out(test_main_out), .test_main_en(test_main_en),
        .test_addr_out(test_addr_out), .test_addr_en(test_addr_en),
        .test_xfer_out(test_xfer_out), .test_xfer_en(test_xfer_en),

        // A
        .a_assert_main(a_assert_main), .a_load_main(a_load_main),
        .a_assert_lhs(a_assert_lhs),
        .a_assert_rhs(a_assert_rhs),
        // B
        .b_assert_main(b_assert_main), .b_load_main(b_load_main),
        .b_assert_lhs(b_assert_lhs),
        .b_assert_rhs(b_assert_rhs),
        // C
        .c_assert_main(c_assert_main), .c_load_main(c_load_main),
        .c_assert_lhs(c_assert_lhs),
        .c_assert_rhs(c_assert_rhs),
        // D
        .d_assert_main(d_assert_main), .d_load_main(d_load_main),
        .d_assert_lhs(d_assert_lhs),
        .d_assert_rhs(d_assert_rhs),
        // CONST
        .const_load_mem(const_load_mem),
        .const_assert_main(const_assert_main),

        // XFER
        .xfer_assert_addr(xfer_assert_addr),
        .xfer_load_xfer(xfer_load_xfer),
        .xfer_assert_xfer(xfer_assert_xfer),
        .xfer_loadlow_main(xfer_loadlow_main),
        .xfer_loadhigh_main(xfer_loadhigh_main),
        .xfer_assertlow_main(xfer_assertlow_main),
        .xfer_asserthigh_main(xfer_asserthigh_main),
        // PCRA0
        .pcra0_assert_addr(pcra0_assert_addr),
        .pcra0_assert_xfer(pcra0_assert_xfer),
        .pcra0_load_xfer(pcra0_load_xfer),
        .pcra0_inc(pcra0_inc),
        .pcra0_dec(pcra0_dec),
        // PCRA1
        .pcra1_assert_addr(pcra1_assert_addr),
        .pcra1_assert_xfer(pcra1_assert_xfer),
        .pcra1_load_xfer(pcra1_load_xfer),
        .pcra1_inc(pcra1_inc),
        .pcra1_dec(pcra1_dec),
        // SP
        .sp_assert_addr(sp_assert_addr),
        .sp_assert_xfer(sp_assert_xfer),
        .sp_load_xfer(sp_load_xfer),
        .sp_inc(sp_inc),
        .sp_dec(sp_dec),
        // SI
        .si_assert_addr(si_assert_addr),
        .si_assert_xfer(si_assert_xfer),
        .si_load_xfer(si_load_xfer),
        .si_inc(si_inc),
        .si_dec(si_dec),
        // DI
        .di_assert_addr(di_assert_addr),
        .di_assert_xfer(di_assert_xfer),
        .di_load_xfer(di_load_xfer),
        .di_inc(di_inc),
        .di_dec(di_dec),

        // ALU
        .alu_assert_main(alu_assert_main),
        .alu_operation(aluop_select),
        .flag_lcarry(flag_lcarry),
        .flag_acarry(flag_acarry),
        .flag_zero(flag_zero),
        .flag_sign(flag_sign),
        .flag_overflow(flag_overflow),

        // MEM
		.mem_dir(mem_dir), // low = main->mem ; high = mem->main
		.mem_assert_main(mem_assert_main),
		.mem_load_main(mem_load_main),

		// mem bus
		.mem_out(mem_out)

    );
endmodule
