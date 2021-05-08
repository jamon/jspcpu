`timescale 1ns/1ps 
module register_xfer_tb();
    localparam WIDTH_AX = 16; // bus width for addr and xfer bus in bits
    localparam WIDTH_MAIN = 8; // bus width for main bus in bits

	reg clk = 0;
    reg reset = 0;
    reg [WIDTH_AX-1:0] bus_in_addr = 16'hAAAA;
    reg [WIDTH_AX-1:0] bus_in_xfer = 16'h5555;
    reg [WIDTH_MAIN-1:0] bus_in_main = 8'h33;
    reg assert_addr = 1'b1;
    reg assert_xfer = 1'b1;
    reg load_xfer = 1'b1;

    reg assertlow_main = 1'b1;
    reg asserthigh_main = 1'b1;
    reg loadlow_main = 1'b1;
    reg loadhigh_main = 1'b1;

    wire [WIDTH_AX-1:0] addr_out;
    wire [WIDTH_AX-1:0] xfer_out;
    wire [WIDTH_MAIN-1:0] main_out;

    wire addr_en, xfer_en, main_en;

    register_xfer #(.WIDTH_AX(16), .WIDTH_MAIN(8)) register_xfer1 (
        .clk(clk),

        .addr_in(bus_in_addr),
        .assert_addr(assert_addr),
        .addr_out(addr_out),
        .addr_en(addr_en),

        .xfer_in(bus_in_xfer),
        .assert_xfer(assert_xfer),
        .load_xfer(load_xfer),
        .xfer_out(xfer_out),
        .xfer_en(xfer_en),

        .main_in(bus_in_main),
        .assertlow_main(assertlow_main),
        .asserthigh_main(asserthigh_main),
        .loadlow_main(loadlow_main),
        .loadhigh_main(loadhigh_main),
        .main_out(main_out),
        .main_en(main_en)
    );
	
    // bus #(.WIDTH(8),.COUNT(4)) top1 (.clk(clk), .in({bus_in_a,bus_in_b,bus_in_c,bus_in_d}),.enable(en_in));

	always
		#(5) clk <= !clk;

	initial
	begin
		$display("test");
		$dumpfile("register_xfer_tb.vcd");
		$dumpvars(0,register_xfer_tb);
        #5


        // default to no outputs
        #0 assert (main_en == 1'b0) 
            $display ("main_en: no asserts OK");
            else $error("main_en: no asserts NOT OK");
        #0 assert (addr_en == 1'b0) 
            $display ("addr_en: no asserts OK");
            else $error("addr_en: no asserts NOT OK");
        #0 assert (xfer_en == 1'b0) 
            $display ("xfer_en: no asserts OK");
            else $error("xfer_en: no asserts NOT OK");

        // assert xfer to check initial value
        #10 assert_xfer = 1'b0;
        #0 assert (xfer_out == 16'h0000)
            $display ("init: value = 0 OK");
            else $error("init: value = 0 NOT OK");
        #0 assert (xfer_en == 1'b1) 
            $display ("xfer_en: assert_xfer OK");
            else $error("xfer_en: assert_xfer NOT OK");
        #10 assert_xfer = 1'b1;

        // load xfer
		#10 load_xfer = 1'b0;
        #10 load_xfer = 1'b1;

        // assert xfer to check value after load xfer
        #10 assert_xfer = 1'b0;
        #0 assert (xfer_out == 16'h5555)
            $display ("load_xfer: value = 16'h5555 OK");
            else $error("load_xfer: value = 16'h5555 NOT OK");
        #10 assert_xfer = 1'b1;


        // load main high
        #10 loadhigh_main = 1'b0;
        #10 loadhigh_main = 1'b1;

        // assert xfer to check value after loadhigh_main
        #10 assert_xfer = 1'b0;
        #0 assert (xfer_out == 16'h3355)
            $display ("loadhigh_main: value = 16'h3355 OK");
            else $error("loadhigh_main: value = 16'h3355 NOT OK");
        #10 assert_xfer = 1'b1;

        // assert addr
        #10 assert_addr = 1'b0;
        #0 assert (addr_out == 16'h3355)
            $display ("assert_addr: value = 16'h3355 OK");
            else $error("assert_addr: value = 16'h3355 NOT OK");
        #0 assert (addr_en == 1'b1) 
            $display ("addr_en: assert_addr OK");
            else $error("addr_en: assert_addr NOT OK");
        #10 assert_addr = 1'b1;

        // assert low to main
        #10 assertlow_main = 1'b0;
        #0 assert (main_en == 1'b1) 
            $display ("assertlow_main: main_en OK");
            else $error("assertlow_main: main_en NOT OK");
        #0 assert (main_out == 8'h55)
            $display ("assertlow_main: value = 8'h55 OK");
            else $error("assertlow_main: value = 8'h55 NOT OK");
        #10 assertlow_main = 1'b1;


        // assert high to main
        #10 asserthigh_main = 1'b0;
        #0 assert (main_en == 1'b1) 
            $display ("asserthigh_main: main_en OK");
            else $error("asserthigh_main: main_en NOT OK");
        #0 assert (main_out == 8'h33)
            $display ("asserthigh_main: value = 8'h00 OK");
            else $error("asserthigh_main: value = 8'h00 NOT OK");
        #10 asserthigh_main = 1'b1;

        #10 $finish;
	end
endmodule
