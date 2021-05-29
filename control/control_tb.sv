`timescale 1ns/1ps
`include "./pipeline_stage1.v"
`include "./pipeline_stage2.v"

module control_tb();
    localparam WIDTH_AX = 16; // bus width for addr and xfer bus in bits
    localparam WIDTH_MAIN = 8; // bus width for main bus in bits

    reg clk = 0;

    reg bus_request = 1;
    reg fetch_suppress = 1;

    reg flag_overflow = 0;
    reg flag_sign = 0;
    reg flag_zero = 0;
    reg flag_acarry = 0;
    reg flag_lcarry = 0;
    reg flag_pcraflip = 0;
    reg flag_reset = 0;
    reg [7:0] instruction = 0;
    wire [7:0] stage1_instruction_out;
    wire [15:0] stage1_controls_out;

    pipeline_stage1 pipeline_stage1_1 (
        .clk(clk),
        .bus_request(bus_request),
        .fetch_suppress(fetch_suppress),
        .flag_overflow(flag_overflow),
        .flag_sign(flag_sign),
        .flag_zero(flag_zero),
        .flag_acarry(flag_acarry),
        .flag_lcarry(flag_lcarry),
        .flag_pcraflip(flag_pcraflip),
        .flag_reset(flag_reset),
        .instruction(instruction),
        .instruction_out(stage1_instruction_out),
        .controls_out(stage1_controls_out)
    );

    wire [7:0] stage2_instruction_out;
    wire [15:0] stage2_controls_out;

    pipeline_stage2 pipeline_stage2_1 (
        .clk(clk),
        .flag_overflow(flag_overflow),
        .flag_sign(flag_sign),
        .flag_zero(flag_zero),
        .flag_acarry(flag_acarry),
        .flag_lcarry(flag_lcarry),
        .flag_pcraflip(flag_pcraflip),
        .flag_reset(flag_reset),
        .instruction(stage1_instruction_out),
        .instruction_out(stage2_instruction_out),
        .controls_out(stage2_controls_out)
    );


	always
		#(1) clk <= !clk;

	initial
	begin
		$dumpfile("control_tb.vcd");
		$dumpvars(0,control_tb);

        #10
        instruction = 8'h69;

        #2 instruction = 0;

        #2 instruction = 8'h88;
        #2 instruction = 8'h88;
        #2 instruction = 0;

        #2 instruction = 8'h26;
        #2 instruction = 0;
        // test_xfer_out = 16'h5555;
        // test_xfer_en = 1'b1;
        // #0 assert (xfer_out == 16'h5555)
        //     $display   ("xfer manual test value (5555) OK");
        //     else $error("xfer manual test value (expected: 5555, actual: %h) NOT OK", xfer_out);
        // #10 test_xfer_en = 1'b0;


        #10 $finish;
	end
endmodule
