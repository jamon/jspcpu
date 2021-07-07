`include "cpu.v"
module top(
    input clk_25mhz,
    output wifi_gpio0,
    output reg [7:0] led,
    input [6:0] btn
);

    localparam WIDTH_MAIN = 8;
    localparam WIDTH_AX = 16;

    reg clk_divider = 25'd0;
    always @(posedge clk_25mhz)
    begin
        clk_divider <= clk_divider - 1;
    end

    // dont use test inputs
    reg [WIDTH_MAIN-1:0] test_main_out = 0;
    reg [WIDTH_AX-1:0] test_addr_out = 0;
    reg [WIDTH_AX-1:0] test_xfer_out = 0;
    reg test_main_en = 0;
    reg test_addr_en = 0;
    reg test_xfer_en = 0;

    cpu cpu (
        // .clk(clk_divider[0]),
        .clk(btn[1]),
        .reset(~btn[0]),

        // test inputs
        .test_main_out(test_main_out), .test_main_en(test_main_en),
        .test_addr_out(test_addr_out), .test_addr_en(test_addr_en),
        .test_xfer_out(test_xfer_out), .test_xfer_en(test_xfer_en),

        .mem_out(led)
    );

    

assign wifi_gpio0 = 1'b1;

endmodule