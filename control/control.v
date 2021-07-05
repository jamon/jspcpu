`include "pipeline_stage0.v"
`include "pipeline_stage1.v"
`include "pipeline_stage2.v"
module control #(
    parameter WIDTH = 8
) (
    input clk,
    
    input [WIDTH-1:0] bus_in,
    input  flag_reset, /* flag_pcraflip, */ flag_lcarry, flag_acarry, flag_zero, flag_sign, flag_overflow,

    output control_inc_pcra0, control_inc_pcra1,

    output [15:0] control_stage1,
    output [15:0] control_stage2
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
        .inc_pcra0(control_inc_pcra0),
        .inc_pcra1(control_inc_pcra1)    
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
        .controls_out(control_stage1)
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
        .controls_out(control_stage2)
    );

    wire bus_request = control_stage2[13];
    wire flag_pcraflip = control_stage2[14];
    wire fetch_suppress = control_stage1[15];
endmodule
