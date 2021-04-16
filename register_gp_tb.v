`timescale 1ns/1ps 
module bus_tb();
	reg clk = 0;
    reg [7:0] bus_in_a = 8'h01;
    // reg [7:0] bus_in_b = 8'h02;
    // reg [7:0] bus_in_c = 8'h03;
    // reg [7:0] bus_in_d = 8'h04;
    reg assert_bus = 1'b0;
    reg assert_lhs = 1'b0;
    reg assert_rhs = 1'b0;

    reg load_bus = 1'b0;

    register_gp #(.WIDTH(8)) register_gp1 (
        .clk(clk),
        .bus_in(bus_in_a),
        .assert_lhs(assert_lhs),
        .assert_rhs(assert_rhs),
        .assert_bus(assert_bus),
        .load_bus(load_bus)
    );
	
    // bus #(.WIDTH(8),.COUNT(4)) top1 (.clk(clk), .in({bus_in_a,bus_in_b,bus_in_c,bus_in_d}),.enable(en_in));

	always
		#(5) clk <= !clk;

	initial
	begin
		$display("test");
		$dumpfile("register_gp_tb.vcd");
		$dumpvars(0,bus_tb);
        #5
		assert_bus = 1'b1;
        #10
		assert_rhs = 1'b1;
        #10
		assert_lhs = 1'b1;
        #10
        assert_bus = 1'b0;
        #10
		load_bus = 1'b1;
        #10
        load_bus = 1'b0;
        #10
        assert_bus = 1'b1;
        #10
		$finish;
	end
endmodule
