`timescale 1ns/1ps 
`include "alu.v"
module TOP();
    localparam WIDTH = 8;

	reg clk = 0;
	reg [3:0] operation = 0;
	reg [WIDTH-1:0] lhs_in = 0;
	reg [WIDTH-1:0] rhs_in = 0;

	reg assert_bus;
	wire [WIDTH-1:0] bus_out;
	wire bus_en;
	wire flag_zero, flag_acarry, flag_lcarry, flag_sign, flag_overflow;

	alu #(.WIDTH(WIDTH)) alu (
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
  
	always
		#(1) clk <= !clk;
	initial
	begin
		$dumpfile("alu_tb.vcd");
		$dumpvars(0,TOP);
		#1
		#2
		lhs_in = 8'h55;
		rhs_in = 8'hAA;
		operation = 4'hA; // AND

		#2 operation = 0;

		#2
		operation = 4'hB; // OR
		#2 operation = 0;
		

		#2
		operation = 4'h3; // add
		lhs_in = 200;
		rhs_in = 64;
		#2 operation = 0;

		#2
		operation = 4'h4; // addc
		lhs_in = 0;
		rhs_in = 0;
		#2 operation = 0;

		#2
		operation = 4'h4; // addc
		lhs_in = 0;
		rhs_in = 0;
		#2 operation = 0;


		#2
		operation = 4'h7; // sub
		lhs_in = 8'b00000001;
		rhs_in = 8'b10000001;
		#2 operation = 0;
        #10 $finish;
	end
endmodule
