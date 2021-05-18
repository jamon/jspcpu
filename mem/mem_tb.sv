`timescale 1ns/1ps 
`include "mem.v"
module mem_tb();
	localparam WIDTH_ADDR = 16;
    localparam WIDTH = 8;

	reg clk = 0;

	reg [WIDTH_ADDR-1:0] addr_in = 16'h0000;
	reg mem_busdir = 1;
	reg [WIDTH-1:0] main_in = ~0;
	reg mem_assert_main = 1;
	reg mem_load_main = 1;

	wire [WIDTH-1:0] main_out;
	wire main_en;

	wire [WIDTH-1:0] mem_out;

	mem #(.WIDTH(WIDTH)) mem1 (
		.clk(clk),

		.addr_in(addr_in),

		.bus_dir(mem_busdir), // low = main->mem ; high = mem->main

		// main bus
		.main_in(main_in),
		.assert_main(mem_assert_main),
		.load_main(mem_load_main),
		.main_out(main_out),
		.main_en(main_en),

		// mem bus
		// .bus_in(mem_in),
		.bus_out(mem_out)
	);
	
	always
		#(1) clk <= !clk;
	initial
	begin
		$dumpfile("mem_tb.vcd");
		$dumpvars(0,mem_tb);


		#2 // 8000 = AA
		mem_busdir = 0; // main->mem
		addr_in = 16'h8000;
		main_in = 8'hAA;
		mem_load_main = 0;
		#1 mem_load_main = 1;

		#2 // output current mem value to main bus
		// main_en should be high (asserting to main)
		// both bus_out and main_out should be AA
		mem_busdir = 1;
		mem_assert_main = 0;
		#2

		#2 // 8001 = 55
		mem_busdir = 0; // main->mem
		addr_in = 16'h8001;
		main_in = 8'h55;
		#1 mem_load_main = 0;
		#1 mem_load_main = 1;

		#2 // output current mem value to main bus
		// main_en should be high (asserting to main)
		// both bus_out and main_out should be 55
		mem_busdir = 1;
		mem_assert_main = 0;
		#2

		#2 // read 8000 again
		// main_en should still be high (asserting to main)
		// both bus_out and main_out should be 55
		addr_in = 16'h8000;
		#2

		#2 // make sure mem bus outputs the value even if we're not asserting to main bus
		// main_en should be low, main_out is irrelevant, bus_out should still be AA
		mem_assert_main = 1;
		#2


        #10 $finish;
	end
endmodule
