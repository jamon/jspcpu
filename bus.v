module bus #(
    parameter WIDTH = 8,
    parameter COUNT = 8,
    parameter TOTAL_WIDTH = WIDTH * COUNT
) (
    input clk,
    input [TOTAL_WIDTH-1:0] in,
    input [COUNT-1:0] enable,
    output [WIDTH-1:0] out
);

localparam ENCODED_WIDTH = $clog2(COUNT+1);

// convert from packed data input to array of WIDTH-wide inputs
wire [WIDTH-1:0] in_array [0:COUNT];
assign in_array[0] = ~0;
generate genvar j;
    for(j = 0; j < COUNT; j = j + 1)
        assign in_array[j+1] = in[((j+1) * WIDTH)-1:(j * WIDTH)];
endgenerate

// priority encoder
wire [ENCODED_WIDTH:0] enable_encoded[0:COUNT];
assign enable_encoded[0] = 5'b00000;
generate genvar i;
    for(i = 0; i < COUNT; i = i + 1)
        assign enable_encoded[i+1] = enable[i] ? i+1 : enable_encoded[i]; 
endgenerate

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
assign out = in_array[selected];

endmodule