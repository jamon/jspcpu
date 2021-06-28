module lhs #(
    parameter WIDTH = 8
) (
    input alu_clk,
    input [1:0] operation,
    input [WIDTH-1:0] in,
    input carry_in,
    output reg [WIDTH-1:0] out,
    output reg carry_out
);
    initial begin
        out = 0;
        carry_out = 0;
    end

    // missing ALU clock functionality (separate from regular clock)

    // do everything at a clock edge to make timing more predictable
    always @(posedge alu_clk) begin
        // if (alu_clk) begin
            case (operation)
                // Zero
                2'b11: begin
                    carry_out <= 0;
                    out <= 0;
                end
                // Shift Right
                2'b10: begin
                    carry_out <= in[0];
                    out <= {carry_in, in[WIDTH-1:1]};
                end
                // Shift Left
                2'b01: begin
                    carry_out <= in[WIDTH-1];
                    out <= {in[WIDTH-2:0], carry_in};
                end
                // Pass Through
                default: begin
                    carry_out <= carry_in;
                    out <= in;
                end
            endcase
        // end else begin
        //     carry_out <= carry_out;
        //     out <= out;
        // end
    end
endmodule
