`timescale 1ns/1ps 
`include "alu.v"
module alu_tb();
    localparam WIDTH = 8;

	reg clk = 0;

	always
		#(5) clk <= !clk;

	initial
	begin
		$dumpfile("alu_tb.vcd");
		$dumpvars(0,alu_tb);
        #5

        #10 $finish;
	end
endmodule
