`include "pipeline_stage0.v"
`include "pipeline_stage1.v"
`include "pipeline_stage2.v"
module control #(
    parameter WIDTH = 8
) (
    input clk,
    
    input [WIDTH-1:0] bus_in,
    input  flag_reset, /* flag_pcraflip, */ flag_lcarry, flag_acarry, flag_zero, flag_sign, flag_overflow,

    output pcra0_inc, pcra1_inc,


    // stage 1 - grouped
    output [15:0] control_stage1,

    output [1:0] lhs_select,
    output [1:0] rhs_select,
    output [3:0] aluop_select,
    output [3:0] xferload_select,
    output [2:0] xferassert_select,

    // stage 1 - individual
    output a_assert_lhs, b_assert_lhs, c_assert_lhs, d_assert_lhs,
    output a_assert_rhs, b_assert_rhs, c_assert_rhs, d_assert_rhs,
    output pcra0_load_xfer, pcra1_load_xfer, sp_load_xfer, si_load_xfer, di_load_xfer, xfer_load_xfer, const_load_mem, pcra0_dec, pcra1_dec, sp_dec, si_dec, di_dec,
    output pcra0_assert_xfer, pcra1_assert_xfer, sp_assert_xfer, si_assert_xfer, di_assert_xfer, xfer_assert_xfer, xfer_assert_mode,
    output fetch_suppress_out,

    // stage 2 - grouped
    output [15:0] control_stage2,

    output [3:0] mainbus_assert_select,
    output [3:0] mainbus_load_select,
    output [1:0] spsidi_inc_select,
    output [2:0] addr_select,

    // stage 2 - individual
    output a_assert_main, b_assert_main, c_assert_main, d_assert_main, const_assert_main, xfer_assertlow_main, xfer_asserthigh_main, alu_assert_main, dev9_assert_main, dev10_assert_main, dev11_assert_main, dev12_assert_main, dev13_assert_main, dev14_assert_main, mem_assert_main,
    output a_load_main, b_load_main, c_load_main, d_load_main, const_load_main, xfer_loadlow_main, xfer_loadhigh_main, alu_load_main, dev9_load_main, dev10_load_main, dev11_load_main, dev12_load_main, dev13_load_main, dev14_load_main, mem_load_main, mem_dir,
    output sp_inc, si_inc, di_inc,
    output mem_ack, pcra0_assert_addr, pcra1_assert_addr, sp_assert_addr, si_assert_addr, di_assert_addr, xfer_assert_addr,
    output bus_request_out,
    output pcra_flip_out,
    output break_out
);


    wire [7:0] stage0_instruction_out;
    // wire stage0_inc_pcra0, stage0_inc_pcra1;

    pipeline_stage0 pipeline_stage0 (
        .clk(clk),
        
        .bus_request(bus_request),
        .fetch_suppress(fetch_suppress),
        .flag_pcraflip(flag_pcraflip),

        .bus_in(bus_in),
        .instruction_out(stage0_instruction_out),
        .inc_pcra0(pcra0_inc),
        .inc_pcra1(pcra1_inc)    
    );


    wire [7:0] stage1_instruction_out;

    pipeline_stage1 pipeline_stage1 (
        .clk(clk),

        .bus_request(bus_request),
        .fetch_suppress(fetch_suppress),

        .flag_reset(flag_reset),
        .flag_pcraflip(flag_pcraflip),
        .flag_lcarry(flag_lcarry),
        .flag_acarry(flag_acarry),
        .flag_zero(flag_zero),
        .flag_sign(flag_sign),
        .flag_overflow(flag_overflow),

        .instruction(stage0_instruction_out),
        .instruction_out(stage1_instruction_out),
        .controls_out(control_stage1),

        // controls - grouped
        .lhs_select(lhs_select),
        .rhs_select(rhs_select),
        .aluop_select(aluop_select),
        .xferload_select(xferload_select),
        .xferassert_select(xferassert_select),


        // controls - individual
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
        .tx_load_xfer(xfer_load_xfer),
        
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
        .tx_assert_xfer(xfer_assert_xfer),
        .tx_assert_mode(xfer_assert_mode),
        
        .fetch_suppress_out(fetch_suppress_out)


    );

    // verilator lint_off UNUSED
    wire [7:0] stage2_instruction_out;
    // verilator lint_on UNUSED

    pipeline_stage2 pipeline_stage2 (
        .clk(clk),

        .flag_reset(flag_reset),
        .flag_pcraflip(flag_pcraflip),
        .flag_lcarry(flag_lcarry),
        .flag_acarry(flag_acarry),
        .flag_zero(flag_zero),
        .flag_sign(flag_sign),
        .flag_overflow(flag_overflow),

        .instruction(stage1_instruction_out),
        .instruction_out(stage2_instruction_out),

        .controls_out(control_stage2),

        // grouped control outputs
        .mainbus_assert_select(mainbus_assert_select),
        .mainbus_load_select(mainbus_load_select),
        .spsidi_inc_select(spsidi_inc_select),
        .addr_select(addr_select),
        .bus_request_out(bus_request_out),
        .pcra_flip_out(pcra_flip_out),
        .break_out(break_out),

        // individual control outputs
        .a_assert_main(a_assert_main),
        .b_assert_main(b_assert_main),
        .c_assert_main(c_assert_main),
        .d_assert_main(d_assert_main),
        .const_assert_main(const_assert_main),
        .tl_assert_main(xfer_assertlow_main),
        .th_assert_main(xfer_asserthigh_main),
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
        .tl_load_main(xfer_loadlow_main),
        .th_load_main(xfer_loadhigh_main),
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
        .tx_assert_addr(xfer_assert_addr)
    );

    wire bus_request = control_stage2[13];
    wire flag_pcraflip = control_stage2[14];
    wire fetch_suppress = control_stage1[15];
endmodule
