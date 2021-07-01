module lhs #(
    parameter WIDTH = 8
) (
    input alu_clk,
    input [1:0] operation,
    input [WIDTH-1:0] in,
    output reg [WIDTH-1:0] out,
    output carry_out
);
    reg carry = 0;
    initial begin
        out = 0;
    end

    // do everything at a clock edge to make timing more predictable
    always @(posedge alu_clk) begin
        // if (alu_clk) begin
            case (operation)
                // Zero
                2'b11: begin
                    carry <= 0;
                    out <= 0;
                end
                // Shift Right
                2'b10: begin
                    carry <= in[0];
                    out <= {carry, in[WIDTH-1:1]};
                end
                // Shift Left
                2'b01: begin
                    carry <= in[WIDTH-1];
                    out <= {in[WIDTH-2:0], carry};
                end
                // Pass Through
                default: begin
                    carry <= carry;
                    out <= in;
                end
            endcase
        // end else begin
        //     carry_out <= carry_out;
        //     out <= out;
        // end
    end
    assign carry_out = carry;
endmodule
