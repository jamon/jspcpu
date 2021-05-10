`timescale 1ns/1ps 
`include "alu.v"
module alu_tb();
    localparam WIDTH = 8;

	reg clk = 0;
	reg [3:0] operation = 0;
	reg [WIDTH-1:0] lhs_in = 0;
	reg [WIDTH-1:0] rhs_in = 0;

	reg assert_bus;
	wire [WIDTH-1:0] bus_out;
	wire bus_en;
	wire flag_zero, flag_acarry, flag_lcarry, flag_sign, flag_overflow;

	alu #(.WIDTH(WIDTH)) alu1 (
		.clk(clk),

		.lhs_in(lhs_in),
		.rhs_in(rhs_in),
		.operation(operation),
		.assert_bus(assert_bus),
		.bus_out(bus_out),
		.bus_en(bus_en),
		.flag_zero(flag_zero),
		.flag_acarry(flag_acarry),
		.flag_lcarry(flag_lcarry),
		.flag_sign(flag_sign),
		.flag_overflow(flag_overflow)
	);
  
	// reg [3:0] aluop_operation = 4'b0000;
    // wire [3:0] aluop_logic_op;
    // wire [1:0] aluop_shift_select;
    // wire [1:0] aluop_carry_select;
    // alu_op alu_op1 (
    //     .clk(clk),
    //     .operation(aluop_operation),
    //     .logic_op(aluop_logic_op),
    //     .shift_select(aluop_shift_select),
    //     .carry_select(aluop_carry_select)
	// );
	always
		#(1) clk <= !clk;
	initial
	begin
		$dumpfile("alu_tb.vcd");
		$dumpvars(0,alu_tb);
		#1
		#2
		lhs_in = 8'h55;
		rhs_in = 8'hAA;
		operation = 4'hA; // AND

		#2 operation = 0;

		#2
		operation = 4'hB;
		#2 operation = 0;
		

		#2
		operation = 4'h3;
		lhs_in = 200;
		rhs_in = 64;
		#2 operation = 0;

		#2
		operation = 4'h4;
		lhs_in = 0;
		rhs_in = 0;
		#2 operation = 0;

		#2
		operation = 4'h4;
		lhs_in = 0;
		rhs_in = 0;
		#2 operation = 0;


        #10 $finish;
	end
endmodule
