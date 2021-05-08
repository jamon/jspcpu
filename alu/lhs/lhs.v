module lhs #(
    parameter WIDTH = 8
) (
    input clk,
    input [1:0] operation,
    input [WIDTH-1:0] in,
    input carry_in,
    output reg [WIDTH-1:0] out,
    output reg carry_out
);
    // do everything at a clock edge to make timing more predictable
    always @(posedge clk) begin
        case (operation)
            2'b11: begin
                carry_out <= 0;
                out <= 0;
            end
            2'b10: begin
                carry_out <= in[0];
                out <= {carry_in, in[WIDTH-1:1]};
            end
            2'b01: begin
                carry_out <= in[WIDTH-1];
                out <= {in[WIDTH-2:0], carry_in};
            end
            default: begin
                carry_out <= carry_in;
                out <= in;
            end
        endcase
    end
endmodule