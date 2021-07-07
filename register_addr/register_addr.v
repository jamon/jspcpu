module register_addr #(
    parameter WIDTH = 16, // bus width in bits
    parameter DEFAULT_VALUE = 0 // defaults to zero
) (
    input clk, inc, dec, reset,
    // input [WIDTH-1:0] addr_in,
    input [WIDTH-1:0] xfer_in,
    input assert_addr, assert_xfer, load_xfer,
    output [WIDTH-1:0] addr_out,
    output [WIDTH-1:0] xfer_out,
    output addr_en, xfer_en
);
    reg [WIDTH-1:0] value = DEFAULT_VALUE;

    // do everything at a clock edge to make timing more predictable
    always @(negedge clk) begin
        // $display("  r: %b l: %b, inc: %b, dec: %b", reset, load_xfer, inc, dec);

        value <= reset ? 0 :            // reset
                !load_xfer ? xfer_in :   // load
                !inc ? value + 1 :       // inc
                !dec ? value - 1 :       // dec
                value;                  // no change
    end
    

    // note that the bus takes care enable behavior, so we just output the data at all times
    assign addr_out = value;
    assign addr_en = ~assert_addr;

    assign xfer_out = value;
    assign xfer_en = ~assert_xfer;

endmodule
