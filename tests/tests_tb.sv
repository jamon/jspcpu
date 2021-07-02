`timescale 1ns/1ps
`include "../register_gp/register_gp.v"
`include "../register_xfer/register_xfer.v"
`include "../register_addr/register_addr.v"
`include "../bus/bus.v"

module tests_tb();
    localparam WIDTH_AX = 16; // bus width for addr and xfer bus in bits
    localparam WIDTH_MAIN = 8; // bus width for main bus in bits

	reg clk = 0;
    reg reset = 0;

    // a - main bus
    // reg [WIDTH_MAIN-1:0] a_bus_in =  8'h00;
    reg a_assert_main = 1'b1;
    reg a_load_main = 1'b1;
    wire [WIDTH_MAIN-1:0] a_main_out;
    wire a_main_en;

    // a - lhs bus
    reg a_assert_lhs = 1'b1;
    wire [WIDTH_MAIN-1:0] a_lhs_out;
    wire a_lhs_en;

    // a - rhs bus
    reg a_assert_rhs = 1'b1;
    wire [WIDTH_MAIN-1:0] a_rhs_out;
    wire a_rhs_en;

    
    register_gp #(.WIDTH(WIDTH_MAIN)) a (
        .clk(clk),

        // main bus
        .bus_in(main_out),
        .load_bus(a_load_main),
        .assert_bus(a_assert_main),
        .bus_out(a_main_out), .bus_en(a_main_en),

        // lhs bus
        .assert_lhs(a_assert_lhs), .lhs_out(a_lhs_out), .lhs_en(a_lhs_en),

        // rhs bus
        .assert_rhs(a_assert_rhs), .rhs_out(a_rhs_out), .rhs_en(a_rhs_en)
    );

    // xfer - addr bus
    reg xfer_assert_addr = 1'b1;
    wire [WIDTH_AX-1:0] xfer_addr_out;
    wire xfer_addr_en;

    // xfer - xfer bus
    reg xfer_assert_xfer = 1'b1;
    reg xfer_load_xfer = 1'b1;
    wire [WIDTH_AX-1:0] xfer_xfer_out;
    wire xfer_xfer_en;

    // xfer - main bus
    // reg [WIDTH_MAIN-1:0] xfer_main_in = 8'h00;
    reg xfer_assertlow_main = 1'b1;
    reg xfer_loadlow_main = 1'b1;
    reg xfer_asserthigh_main = 1'b1;
    reg xfer_loadhigh_main = 1'b1;
    wire [WIDTH_MAIN-1:0] xfer_main_out;
    wire xfer_main_en;

    register_xfer #(.WIDTH_AX(16), .WIDTH_MAIN(8)) xfer (
        // .clk(clk),

        // addr bus
        // .addr_in(addr_out),
        .assert_addr(xfer_assert_addr),
        .addr_out(xfer_addr_out), .addr_en(xfer_addr_en),

        // xfer bus
        .xfer_in(xfer_out),
        .load_xfer(xfer_load_xfer),
        .assert_xfer(xfer_assert_xfer),
        .xfer_out(xfer_xfer_out), .xfer_en(xfer_xfer_en),

        // main bus
        .main_in(main_out),
        .loadlow_main(xfer_loadlow_main),
        .loadhigh_main(xfer_loadhigh_main),
        .assertlow_main(xfer_assertlow_main),
        .asserthigh_main(xfer_asserthigh_main),
        .main_out(xfer_main_out), .main_en(xfer_main_en)
    );
	

    // pcra0 - addr bus
    reg pcra0_assert_addr = 1'b1;
    wire [WIDTH_AX-1:0] pcra0_addr_out;
    wire pcra0_addr_en;

    // pcra0 - xfer bus
    reg pcra0_assert_xfer = 1'b1;
    reg pcra0_load_xfer = 1'b1;
    wire [WIDTH_AX-1:0] pcra0_xfer_out;
    wire pcra0_xfer_en;

    reg pcra0_inc = 1'b1;
    reg pcra0_dec = 1'b1;

    register_addr #(.WIDTH(WIDTH_AX)) pcra0 (
        // .clk(clk),
        .reset(reset),

        // .addr_in(addr_out),
        .assert_addr(pcra0_assert_addr),
        .addr_out(pcra0_addr_out),
        .addr_en(pcra0_addr_en),

        .xfer_in(xfer_out),
        .assert_xfer(pcra0_assert_xfer),
        .load_xfer(pcra0_load_xfer),
        .xfer_out(pcra0_xfer_out),
        .xfer_en(pcra0_xfer_en),

        .inc(pcra0_inc),
        .dec(pcra0_dec)
    );


    // test - main bus
    reg [WIDTH_MAIN-1:0] test_main_out = 8'h0f;
    reg test_main_en = 1'b0;
    wire [WIDTH_MAIN-1:0] main_out;

	bus #(.WIDTH(WIDTH_MAIN),.COUNT(3)) mainbus (
        // .clk(clk),
        .in({
            test_main_out,
            a_main_out,
            xfer_main_out
        }),
        .enable({
            test_main_en,
            a_main_en,
            xfer_main_en
        }),
        .out(main_out)
    );

    // test - addr bus
    reg [WIDTH_AX-1:0] test_addr_out = 16'h0f;
    reg test_addr_en = 1'b0;
    wire [WIDTH_AX-1:0] addr_out;

	bus #(.WIDTH(WIDTH_AX),.COUNT(3)) addrbus (
        // .clk(clk),
        .in({
            test_addr_out,
            pcra0_addr_out,
            xfer_addr_out
        }),
        .enable({
            test_addr_en,
            pcra0_addr_en,
            xfer_addr_en
        }),
        .out(addr_out)
    );

    // test - xfer bus
    reg [WIDTH_AX-1:0] test_xfer_out = 16'h0f;
    reg test_xfer_en = 1'b0;
    wire [WIDTH_AX-1:0] xfer_out;

	bus #(.WIDTH(WIDTH_AX),.COUNT(3)) xferbus (
        // .clk(clk),
        .in({
            test_xfer_out,
            pcra0_xfer_out,
            xfer_xfer_out
        }),
        .enable({
            test_xfer_en,
            pcra0_xfer_en,
            xfer_xfer_en
        }),
        .out(xfer_out)
    );


	always
		#(5) clk <= !clk;

	initial
	begin
		$dumpfile("tests_tb.vcd");
		$dumpvars(0,tests_tb);

        #10 reset = 1'b1;

        #10
        test_xfer_out = 16'h5555;
        test_xfer_en = 1'b1;
        #0 assert (xfer_out == 16'h5555)
            $display   ("xfer manual test value (5555) OK");
            else $error("xfer manual test value (expected: 5555, actual: %h) NOT OK", xfer_out);
        #10 test_xfer_en = 1'b0;

        #10
        test_addr_out = 16'h5555;
        test_addr_en = 1'b1;
        #0 assert (addr_out == 16'h5555)
            $display   ("addr manual test value (5555) OK");
            else $error("addr manual test value (expected: 5555, actual: %h) NOT OK", xfer_out);
        #10 test_addr_en = 1'b0;

        #10
        test_xfer_out = 16'h5555;
        test_xfer_en = 1'b1;
        #10 pcra0_load_xfer = 1'b0;
        #10 
        test_xfer_en = 1'b0;
        pcra0_load_xfer = 1'b1;
        pcra0_assert_addr = 1'b0;
        #10 assert (addr_out == 16'h5555)
            $display   ("xfer assert to addr (5555) OK");
            else $error("xfer assert to addr (expected: 5555, actual: %h) NOT OK", addr_out);
        pcra0_assert_addr = 1'b1;


        // inc pcra0
        #10 pcra0_inc = 1'b0;
        #10 pcra0_inc = 1'b1;
        #10 pcra0_assert_addr = 1'b0;
        #10 assert (addr_out == 16'h5556)
            $display   ("pcra0 inc (5556) OK");
            else $error("pcra0 inc (expected: 5556, actual: %h) NOT OK", addr_out);
        pcra0_assert_addr = 1'b1;

        // dec pcra0
        #10 pcra0_dec = 1'b0;
        #10 pcra0_dec = 1'b1;
        #10 pcra0_assert_addr = 1'b0;
        #10 assert (addr_out == 16'h5555)
            $display   ("pcra0 dec (5555) OK");
            else $error("pcra0 dec (expected: 5555, actual: %h) NOT OK", addr_out);
        pcra0_assert_addr = 1'b1;


        // pcra0 -> xfer
        #10 pcra0_assert_xfer = 1'b0;
        #10 xfer_load_xfer = 1'b0;
        #10 xfer_load_xfer = 1'b1;
        #10 pcra0_assert_xfer = 1'b1;
        #10 xfer_assert_addr = 1'b0;
        #0 assert (addr_out == 16'h5555)
            $display   ("pcra0 to xfer (5555) OK");
            else $error("pcra0 to xfer (expected: 5555, actual: %h) NOT OK", addr_out);
        xfer_assert_addr = 1'b1;

        
        // load 55AA into XFER
        #10
        test_xfer_out = 16'h55AA;
        test_xfer_en = 1'b1;
        #10 xfer_load_xfer = 1'b0;
        #10 xfer_load_xfer = 1'b1;

        // assert XFER to main
        #10 xfer_assertlow_main = 1'b0;
        #0 assert (main_out == 8'hAA)
            $display   ("xfer assert main (AA) OK");
            else $error("xfer assert main (expected: AA, actual: %h) NOT OK", main_out);
        // latch to A
        #10 a_load_main = 1'b0;
        #10 a_load_main = 1'b1;
        // stop asserting to main
        #10 xfer_assertlow_main = 1'b1;
        #0 assert (main_out == 8'hFF)
            $display   ("xfer no longer asserting to main (FF) OK");
            else $error("xfer no longer asserting to main (expected: FF, actual: %h) NOT OK", main_out);
        #10 a_assert_main = 1'b0;
        #0 assert (main_out == 8'hAA)
            $display   ("a assert main (AA) OK");
            else $error("a assert main (expected: AA, actual: %h) NOT OK", main_out);
        xfer_assert_addr = 1'b1;
        #10 a_assert_main = 1'b1;

        #10 $finish;
	end
endmodule
