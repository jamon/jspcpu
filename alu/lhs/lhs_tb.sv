`timescale 1ns/1ps
`include "lhs.v"
module lhs_tb();
    localparam WIDTH = 8; // bus width for main bus in bits

	reg clk = 0;
    reg reset = 0;

    reg [1:0] lhs_op = 2'b00;
    reg [WIDTH-1:0] lhs_in = 8'hFF;
    reg lhs_carry_in = 1'b0;
    wire [WIDTH-1:0] lhs_out;
    wire lhs_carry_out;

    lhs #(.WIDTH(WIDTH)) lhs1 (
        .clk(clk),
        .operation(lhs_op),
        .in(lhs_in),
        .carry_in(lhs_carry_in),
        .out(lhs_out),
        .carry_out(lhs_carry_out)
    );
	
	always
		#(5) clk <= !clk;

	initial
	begin
		$dumpfile("lhs_tb.vcd");
		$dumpvars(0,lhs_tb);
        #5
        // lhs_op = 2'b00;
        // lhs_in = 8'hFF;
        // lhs_carry_in = 1'b0;

        // default to no outputs
        #10
        #0 assert (lhs_carry_in == lhs_carry_out) 
            $display   ("default: lhs_carry_in = lhs_carry_out OK");
            else $error("default: lhs_carry_in = lhs_carry_out (in: %h, out: %h) NOT OK", lhs_carry_in, lhs_carry_out);
        #0 assert (lhs_in == lhs_out) 
            $display   ("default: lhs_in = lhs_out OK");
            else $error("default: lhs_in = lhs_out (in: %h, out: %h) NOT OK", lhs_in, lhs_out);
        
        #10
        lhs_in = 8'b10101010;
        lhs_carry_in = 1'b0;
        lhs_op = 2'b10;
        #10
        #0 assert (lhs_out == 8'b01010101) 
            $display   ("shift right no carry OK");
            else $error("shift right no carry (in: %h (%h), out: %h (%h)) NOT OK", lhs_in, lhs_carry_in, lhs_out, lhs_carry_out);
        #0 assert (lhs_carry_out == 1'b0) 
            $display   ("shift right no carry (carry) OK");
            else $error("shift right no carry (carry) (in: %h (%h), out: %h (%h)) NOT OK", lhs_in, lhs_carry_in, lhs_out, lhs_carry_out);

        #10
        lhs_in = 8'b10101010;
        lhs_carry_in = 1'b0;
        lhs_op = 2'b01;
        #10
        #0 assert (lhs_out == 8'b01010100) 
            $display   ("shift left no carry OK");
            else $error("shift left no carry (in: %h (%h), out: %h (%h)) NOT OK", lhs_in, lhs_carry_in, lhs_out, lhs_carry_out);
        #0 assert (lhs_carry_out == 1'b1) 
            $display   ("shift left no carry (carry) OK");
            else $error("shift left no carry (carry) (in: %h (%h), out: %h (%h)) NOT OK", lhs_in, lhs_carry_in, lhs_out, lhs_carry_out);

#10
        lhs_in = 8'b01010101;
        lhs_carry_in = 1'b1;
        lhs_op = 2'b10;
        #10
        #0 assert (lhs_out == 8'b10101010) 
            $display   ("shift right with carry OK");
            else $error("shift right with carry (in: %h (%h), out: %h (%h)) NOT OK", lhs_in, lhs_carry_in, lhs_out, lhs_carry_out);
        #0 assert (lhs_carry_out == 1'b1) 
            $display   ("shift right with carry (carry) OK");
            else $error("shift right with carry (carry) (in: %h (%h), out: %h (%h)) NOT OK", lhs_in, lhs_carry_in, lhs_out, lhs_carry_out);

        #10
        lhs_in = 8'b01010101;
        lhs_carry_in = 1'b1;
        lhs_op = 2'b01;
        #10
        #0 assert (lhs_out == 8'b10101011) 
            $display   ("shift left with carry OK");
            else $error("shift left with carry (in: %h (%h), out: %h (%h)) NOT OK", lhs_in, lhs_carry_in, lhs_out, lhs_carry_out);
        #0 assert (lhs_carry_out == 1'b0) 
            $display   ("shift left with carry (carry) OK");
            else $error("shift left with carry (carry) (in: %h (%h), out: %h (%h)) NOT OK", lhs_in, lhs_carry_in, lhs_out, lhs_carry_out);

        #10
        lhs_in = 8'b01010101;
        lhs_carry_in = 1'b1;
        lhs_op = 2'b11;
        #10
        #0 assert (lhs_out == 8'b00000000) 
            $display   ("zero with carry OK");
            else $error("zero with carry (in: %h (%h), out: %h (%h)) NOT OK", lhs_in, lhs_carry_in, lhs_out, lhs_carry_out);
        #0 assert (lhs_carry_out == 1'b0) 
            $display   ("zero with carry (carry) OK");
            else $error("zero with carry (carry) (in: %h (%h), out: %h (%h)) NOT OK", lhs_in, lhs_carry_in, lhs_out, lhs_carry_out);

        #10 $finish;        
	end
endmodule
