module register_xfer #(
    parameter WIDTH = 8
) (
    input clk
);
    // do everything at a clock edge to make timing more predictable
    always @(posedge clk) begin
    end

endmodule