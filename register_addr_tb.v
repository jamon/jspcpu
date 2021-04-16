`timescale 1ns/1ps 
module bus_tb();
	reg clk = 0;
    reg reset = 0;
    reg [15:0] bus_in_a = 16'h01;
    reg [15:0] bus_in_b = 16'h02;
    // reg [7:0] bus_in_c = 8'h03;
    // reg [7:0] bus_in_d = 8'h04;
    reg assert_addr = 1'b0;
    reg assert_xfer = 1'b0;

    reg load_xfer = 1'b0;
    reg inc = 1'b0;
    reg dec = 1'b0;



    register_addr #(.WIDTH(16)) register_addr1 (
        .clk(clk),
        .reset(reset),
        .addr_in(bus_in_a),
        .xfer_in(bus_in_b),
        .assert_addr(assert_lhs),
        .assert_xfer(assert_rhs),
        .load_xfer(load_xfer),
        .inc(inc),
        .dec(dec)
    );
	
    // bus #(.WIDTH(8),.COUNT(4)) top1 (.clk(clk), .in({bus_in_a,bus_in_b,bus_in_c,bus_in_d}),.enable(en_in));

	always
		#(5) clk <= !clk;

	initial
	begin
		$display("test");
		$dumpfile("register_addr_tb.vcd");
		$dumpvars(0,bus_tb);
        #5
		assert_addr = 1'b1;
		#10
		assert_xfer = 1'b1;
		#10
		load_xfer = 1'b1;
        #10
        load_xfer = 1'b0;
        #10
        assert_addr = 1'b1;
        #10
        inc = 1'b1;
        #10
        inc = 1'b0;
        #10
        dec = 1'b1;
        #10
        dec = 1'b0;
        #10
        reset = 1'b1;
        #10
        reset = 1'b0;
        #10
		$finish;
	end
endmodule
