`timescale 1ns/1ps
`include "rhs.v"
module rhs_tb();
    localparam WIDTH = 8; // bus width for main bus in bits
    string opname;

	reg clk = 0;
    reg reset = 0;

    reg [3:0] rhs_op = 4'b0000;
    reg [WIDTH-1:0] lhs_in = 8'hFF;
    reg [WIDTH-1:0] rhs_in = 8'hFF;
    wire [WIDTH-1:0] rhs_out;

    rhs #(.WIDTH(WIDTH)) rhs1 (
        .clk(clk),
        .operation(rhs_op),
        .lhs_in(lhs_in),
        .rhs_in(rhs_in),
        .out(rhs_out)
    );
	
    task assert_operation(reg [WIDTH-1:0] expected);
        assert (rhs_out == expected) 
            $display   ("%10s (%b), lhs: %8b, rhs: %8b, out: %8b exp: %8b OK", opname, rhs_op, lhs_in, rhs_in, rhs_out, expected);
            else $error("%10s (%b), lhs: %8b, rhs: %8b, out: %8b exp: %8b NOT OK", opname, rhs_op, lhs_in, rhs_in, rhs_out, expected);
    endtask
	always
		#(5) clk <= !clk;

	initial
	begin
		$dumpfile("rhs_tb.vcd");
		$dumpvars(0,rhs_tb);
        #5

        #10 // this combination tests all possible logic operations
        lhs_in = 8'b10101010;
        rhs_in = 8'b11001100;

        // zero
        #10
        opname = "zero";
        rhs_op = 0;
        #10 assert_operation(0);

        #10
        opname = "nor";
        rhs_op = 1;
        #10 assert_operation(8'b00010001);

        #10
        opname = "A !B";
        rhs_op = 2;
        #10 assert_operation(8'b00100010);

        #10
        opname = "!B Pass";
        rhs_op = 3;
        #10 assert_operation(8'b00110011);

        #10
        opname = "!A B";
        rhs_op = 4;
        #10 assert_operation(8'b01000100);

        #10
        opname = "!A Pass";
        rhs_op = 5;
        #10 assert_operation(8'b01010101);

        #10
        opname = "XOR";
        rhs_op = 6;
        #10 assert_operation(8'b01100110);

        #10
        opname = "NAND";
        rhs_op = 7;
        #10 assert_operation(8'b01110111);

        #10
        opname = "AND";
        rhs_op = 8;
        #10 assert_operation(8'b10001000);

        #10
        opname = "XNOR";
        rhs_op = 9;
        #10 assert_operation(8'b10011001);

        #10
        opname = "A Pass";
        rhs_op = 10;
        #10 assert_operation(8'b10101010);

        #10
        opname = "A + !B";
        rhs_op = 11;
        #10 assert_operation(8'b10111011);

        #10
        opname = "B Pass";
        rhs_op = 12;
        #10 assert_operation(8'b11001100);

        #10
        opname = "!A + B";
        rhs_op = 13;
        #10 assert_operation(8'b11011101);

        #10
        opname = "OR";
        rhs_op = 14;
        #10 assert_operation(8'b11101110);

        #10
        opname = "~zero";
        rhs_op = 15;
        #10 assert_operation(8'b11111111);

        #10 $finish;
	end
endmodule
