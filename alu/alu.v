`include "alu_op.v"
`include "lhs/lhs.v"
`include "rhs/rhs.v"
module alu #(
    parameter WIDTH = 8
) (
    input clk,

    input [WIDTH-1:0] lhs_in,
    input [WIDTH-1:0] rhs_in,
    input [3:0] operation,
    input assert_bus,
    output [WIDTH-1:0] bus_out,
    output bus_en,

    output flag_zero, flag_acarry, flag_lcarry, flag_sign, flag_overflow
);

    wire alu_clk;
    wire [3:0] aluop_logic_op;
    wire [1:0] aluop_shift_select;
    wire [1:0] aluop_carry_select;

    alu_op alu_op1 (
        .clk(clk),
        .alu_clk(alu_clk),
        .operation(operation),
        .logic_op(aluop_logic_op),
        .shift_select(aluop_shift_select),
        .carry_select(aluop_carry_select)
	);

    reg lhs_carry_in = 0;
    wire [WIDTH-1:0] lhs_out;
    wire lhs_carry_out;

    lhs #(.WIDTH(WIDTH)) lhs1 (
        .clk(clk),
        .alu_clk(alu_clk),
        .operation(aluop_shift_select),
        .in(lhs_in),
        .carry_in(lhs_carry_in),
        .out(lhs_out),
        .carry_out(lhs_carry_out)
    );
	
    wire [WIDTH-1:0] rhs_out;
    rhs #(.WIDTH(WIDTH)) rhs1 (
        .clk(clk),
        .alu_clk(alu_clk),
        .operation(aluop_logic_op),
        .lhs_in(lhs_in),
        .rhs_in(rhs_in),
        .out(rhs_out)
    );

    wire carry = aluop_carry_select[1]
        ? (aluop_carry_select[0] ? 0 : 1)
        : (aluop_carry_select[0] ? prev_carry : 0);

    reg prev_carry = 1'b0;

    wire [WIDTH:0] result = lhs_out + rhs_out + carry;

    assign bus_out = result[WIDTH-1:0];
    assign bus_en = ~assert_bus;

    always @(posedge alu_clk) begin
        // update previous carry with carry bit of result, only after alu_clk
        prev_carry = result[WIDTH];
    end

    // flags

    // video series does this with 74ls02 (NOR) -> 74ls08 (AND), we'll just use 8-input NOR
    assign flag_zero = ~| result[WIDTH-1:0];
    assign flag_acarry = result[WIDTH];
    assign flag_lcarry = lhs_carry_out;
    assign flag_sign = result[WIDTH-1];
    assign flag_overflow = (lhs_out[WIDTH-1] ^ result[WIDTH-1]) & (rhs_out[WIDTH-1] ^ result[WIDTH-1]);
endmodule