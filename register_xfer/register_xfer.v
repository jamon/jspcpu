// WIDTH_AX must be 2x WIDTH_MAIN
module register_xfer #(
    parameter DEFAULT_VALUE = 0, // defaults to zero
    parameter WIDTH_AX = 16, // bus width for addr and xfer bus in bits
    parameter WIDTH_MAIN = 8 // bus width for main bus in bits
) (
    input clk,

    // address bus
    // input [WIDTH_AX-1:0] addr_in,
    input assert_addr,
    output [WIDTH_AX-1:0] addr_out,
    output addr_en,

    // xfer bus
    input [WIDTH_AX-1:0] xfer_in,
    input assert_xfer, load_xfer,
    output [WIDTH_AX-1:0] xfer_out,
    output xfer_en,

    // main bus
    input [WIDTH_MAIN-1:0] main_in,
    input assertlow_main, asserthigh_main, loadlow_main, loadhigh_main,
    output [WIDTH_MAIN-1:0] main_out,
    output main_en
);
    reg [WIDTH_AX-1:0] value = DEFAULT_VALUE;

    // do everything at a clock edge to make timing more predictable
    always @(posedge clk) begin
        value <= !load_xfer ? xfer_in :   // load xfer
                !loadlow_main ? {value[WIDTH_AX-1:WIDTH_AX-WIDTH_MAIN], main_in[WIDTH_MAIN-1:0]} : // load main to low
                !loadhigh_main ? {main_in[WIDTH_MAIN-1:0], value[WIDTH_MAIN-1:0]} : // load main to high
                value;                  // no change
    end

    // note that the bus takes care enable behavior, so we just output the data at all times
    assign addr_out = value;
    assign addr_en = ~assert_addr;

    assign xfer_out = value;
    assign xfer_en = ~assert_xfer;

    // slightly weird to only use the assertlow to determine which output goes to main, but the bus handles the rest
    assign main_out = assertlow_main ? value[WIDTH_AX-1:WIDTH_AX-WIDTH_MAIN] : value[WIDTH_MAIN-1:0];
    // bus enable is active high, asserts are active low
    assign main_en = ~(assertlow_main & asserthigh_main);

endmodule
