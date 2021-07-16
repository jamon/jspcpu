`include "cpu.v"
module top(
    input clk_25mhz,
    output wifi_gpio0,
    output reg [7:0] led,
    // output [5:4] gp,
    // output [5:4] gn,
    inout [5:0] gp,
    inout [5:0] gn,
    input [6:0] btn
);
    localparam WIDTH_MAIN = 8;
    localparam WIDTH_AX = 16;
    localparam CLK_DIVISOR = 24;

    reg [CLK_DIVISOR-1:0] clk_divider = 0;
    reg prev_btn = 0;
    reg prev_btn2 = 0;

    reg [7:0] clk_cnt = 0;
    reg btn_db = 0;

    always @(posedge clk_25mhz)
    begin
        clk_divider <= clk_divider + 1;
    end
    always @(posedge clk_divider[20])
    begin
        prev_btn <= btn[1];
        if(prev_btn == 1'b0 && btn[1] == 1'b1)
            clk_cnt <= clk_cnt + 1;
    end
    always @(posedge clk_divider[20])
    begin
        prev_btn2 <= btn[2];
        if(prev_btn2 == 1'b0 && btn[2] == 1'b1)
            btn_db <= 1'b1;            
        else if(prev_btn2 == 1'b1 && btn[2] == 1'b0)
            btn_db <= 1'b0;
        else
            btn_db <= btn_db;
        
    end
    // assign led[7:0] = clk_cnt[7:0];

    // dont use test inputs
    reg [WIDTH_MAIN-1:0] test_main_out = 0;
    reg [WIDTH_AX-1:0] test_addr_out = 0;
    reg [WIDTH_AX-1:0] test_xfer_out = 0;
    reg test_main_en = 0;
    reg test_addr_en = 0;
    reg test_xfer_en = 0;


    wire dev13_load_main;
    wire dev13_assert_main;
    wire dev14_load_main;
    wire dev14_assert_main;

    wire [WIDTH_MAIN-1:0] main_out;
    cpu cpu (
        .clk(btn_db ? clk_divider[20] : clk_cnt[0]),
        // (clk_divider[CLK_DIVISOR-1] || !btn[2]) ^ 
        // .clk(btn[1]),
        .reset(~btn[0]),

        // test inputs
        .test_main_out(test_main_out), .test_main_en(test_main_en),
        .test_addr_out(test_addr_out), .test_addr_en(test_addr_en),
        .test_xfer_out(test_xfer_out), .test_xfer_en(test_xfer_en),


        .dev13_load_main(dev13_load_main),
        .dev13_assert_main(dev13_assert_main),
        .dev14_load_main(dev14_load_main),
        .dev14_assert_main(dev14_assert_main),

        .mem_out(led),
        .main_out(main_out)
    );
    // assign gp[3:0] = 4'bz;
    // assign gn[3:0] = 4'bz;
    // assign {gp[0], gn[0], gp[1], gn[1], gp[2], gn[2], gp[3], gn[3]} = main_out;
    // rw is low when any external device is writing to main bus
    wire rw = dev13_assert_main & dev14_assert_main;

    assign gp[0] = rw ? main_out[0] : 1'bz;
    assign gn[0] = rw ? main_out[1] : 1'bz;
    assign gp[1] = rw ? main_out[2] : 1'bz;
    assign gn[1] = rw ? main_out[3] : 1'bz;
    assign gp[2] = rw ? main_out[4] : 1'bz;
    assign gn[2] = rw ? main_out[5] : 1'bz;
    assign gp[3] = rw ? main_out[6] : 1'bz;
    assign gn[3] = rw ? main_out[7] : 1'bz;
    assign gn[4] = dev13_load_main;
    assign gp[4] = dev13_assert_main;
    assign gn[5] = dev14_load_main;
    assign gp[5] = dev14_assert_main;

    assign wifi_gpio0 = 1'b1;

endmodule