module bus #(
    parameter WIDTH = 8, // bus width in bits
    parameter COUNT = 8, // number of connections (things that can assert) to the bus
    parameter DEFAULT_VALUE = ~0 // defaults to "pulled up" (8'hff for 8 width, for example)
) (
    // input clk,
    input [TOTAL_WIDTH-1:0] in,
    input [COUNT-1:0] enable,
    output [WIDTH-1:0] out
);

// verilog doesn't support an array of multi-bit values as an input, so we expect it packed
// example width=8, count=4: .in({8'hff, 8'h55, 8'h01, 8'h02})
localparam TOTAL_WIDTH = WIDTH * COUNT;
// to address an item within the array, we'll calculate the index of the item that is asserting
// this is the width required to store that.  needs to be 1 larger than COUNT
// in order to store the default value of the bus
localparam ENCODED_WIDTH = $clog2(COUNT+1);

// convert from packed data input to array of WIDTH-wide inputs
wire [WIDTH-1:0] in_array [0:COUNT];
// set the 0 entry to be the default value
assign in_array[0] = DEFAULT_VALUE;
// expands to something like:
// assign in_array[1] = in[2 * WIDTH:1 * WIDTH];
// assign in_array[2] = in[3 * WIDTH:2 * WIDTH];
// etc
generate genvar j;
    for(j = 0; j < COUNT; j = j + 1)
        assign in_array[j+1] = in[((j+1) * WIDTH)-1:(j * WIDTH)];
endgenerate

// priority encoder - finds the left-most (most significant) enable bit that is set
// and returns the index of it.
// ex {0, 1, 0, 1, 0} MSB is 3, result is b101
// this resolves potential bus conflicts silently (for better or worse)
// verilator lint_off UNOPTFLAT
wire [ENCODED_WIDTH-1:0] enable_encoded[0:COUNT];
// verilator lint_on UNOPTFLAT
// default to index 0 if nothing is asserting to bus (the default value)
assign enable_encoded[0] = 0;
// this expands to something like:
// assign enable_encoded[1] = enable[0] ? 1 : enable_encoded[0];
// assign enable_encoded[2] = enable[1] ? 2 : enable_encoded[1];
// etc
generate genvar i;
    for(i = 0; i < COUNT; i = i + 1)
        assign enable_encoded[i+1] = enable[i] ? i+1 : enable_encoded[i]; 
endgenerate
// grab the selected index (highest entry in enable_encoded[])
wire [ENCODED_WIDTH-1:0] selected;
assign selected = enable_encoded[COUNT];
// always @(posedge clk) begin
//     $display("enable_encoded: %b -> %b", enable, enable_encoded[COUNT]);
//     $display("  0: %b", enable_encoded[0]);
//     $display("  1: %b", enable_encoded[1]);
//     $display("  2: %b", enable_encoded[2]);
//     $display("  3: %b", enable_encoded[3]);
//     $display("  4: %b", enable_encoded[4]);
// end
// always @(posedge clk) begin
//     $display("in: %h", in);
//     $display("  0: %h", in_array[0]);
//     $display("  1: %h", in_array[1]);
//     $display("  2: %h", in_array[2]);
//     $display("  3: %h", in_array[3]);
//     $display("  4: %h", in_array[4]);
// end

// assign the output to be the input that corresponds to that index
assign out = in_array[selected];

endmodule
