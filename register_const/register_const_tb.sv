`timescale 1ns/1ps 
`include "register_const.v"
module register_const_tb();
	reg clk = 0;
    reg [7:0] bus_in_a = 8'h01;
    // reg [7:0] bus_in_b = 8'h02;
    // reg [7:0] bus_in_c = 8'h03;
    // reg [7:0] bus_in_d = 8'h04;
    reg assert_bus = 1'b1;

    reg load_bus = 1'b1;

    register_const #(.WIDTH(8)) register_const1 (
        .clk(clk),
        .bus_in(bus_in_a),
        .assert_bus(assert_bus),
        .load_bus(load_bus)
    );
	
	always
		#(1) clk <= !clk;

	initial
	begin
		$dumpfile("register_const_tb.vcd");
		$dumpvars(0,register_const_tb);
        #2 assert_bus = 1'b0;
		#2 load_bus = 1'b0;
        #2 load_bus = 1'b1;
        #10
		$finish;
	end
endmodule
