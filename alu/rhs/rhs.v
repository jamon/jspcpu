module rhs #(
    parameter WIDTH = 8
) (
    input alu_clk,
    input [3:0] operation,
    input [WIDTH-1:0] lhs_in,
    input [WIDTH-1:0] rhs_in,
    output reg [WIDTH-1:0] out
);
    initial begin
        out = 0;
    end
    // do everything at a clock edge to make timing more predictable
    always @(posedge alu_clk) begin
        case (operation)
            4'b0000: out <= 0;                      // zero
            4'b0001: out <= ~(lhs_in | rhs_in);     // nor
            4'b0010: out <= lhs_in & ~rhs_in;       // A !B
            4'b0011: out <= ~rhs_in;                // !B Pass
            4'b0100: out <= ~lhs_in & rhs_in;       // !A B
            4'b0101: out <= ~lhs_in;                // !A Pass
            4'b0110: out <= lhs_in ^ rhs_in;        // A ^ B (XOR)
            4'b0111: out <= ~(lhs_in & rhs_in);     // NAND
            4'b1000: out <= lhs_in & rhs_in;        // AND
            4'b1001: out <= ~(lhs_in ^ rhs_in);     // XNOR
            4'b1010: out <= lhs_in;                 // A Pass
            4'b1011: out <= lhs_in | ~rhs_in;       // A+!B
            4'b1100: out <= rhs_in;                 // B Pass
            4'b1101: out <= ~lhs_in | rhs_in;       // !A + B
            4'b1110: out <= lhs_in | rhs_in;        // OR
            4'b1111: out <= ~0;                     // ~zero 
        endcase
    end
endmodule
