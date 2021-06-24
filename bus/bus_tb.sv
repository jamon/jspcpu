`timescale 1ns/1ps 
`include "./bus.v"
module bus_tb();
	reg clk = 0;
    reg [7:0] bus_in_a = 8'h01;
    reg [7:0] bus_in_b = 8'h02;
    reg [7:0] bus_in_c = 8'h03;
    reg [7:0] bus_in_d = 8'h04;
	reg [3:0] en_in = 4'b0000;

	bus #(.WIDTH(8),.COUNT(4)) top1 (.clk(clk), .in({bus_in_a,bus_in_b,bus_in_c,bus_in_d}),.enable(en_in));

	always
		#(5) clk <= !clk;

	initial
	begin
		$display("test");
		$dumpfile("bus_tb.vcd");
		$dumpvars(0,bus_tb);
        #10
		en_in = 4'b0001;
		#15
		en_in = 4'b0010;
		#20
		en_in = 4'b0100;
		#25
		en_in = 4'b1000;
		#30
		$finish;
	end
endmodule
