`default_nettype none
module register_const #(
    parameter WIDTH = 8, // bus width in bits
    parameter DEFAULT_VALUE = 0 // defaults to "pulled up" (8'hff for 8 width, for example)
) (
    input clk,

    input [WIDTH-1:0] bus_in,
    input assert_bus,
    input load_bus,
    output [WIDTH-1:0] bus_out,
    output bus_en
);
    reg [WIDTH-1:0] value = DEFAULT_VALUE;

    // do everything at a clock edge to make timing more predictable
    always @(posedge clk) begin
        value <= !load_bus ? bus_in : value;
    end

    // note that the bus takes care enable behavior, so we just output the data at all times
    assign bus_out = value;
    assign bus_en = ~assert_bus;

endmodule
