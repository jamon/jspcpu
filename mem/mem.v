`default_nettype none
`include "ram.v"
module mem #(
    parameter WIDTH_ADDR = 16,
    parameter WIDTH = 8 //,
    // parameter MEM_SIZE = 65535,
    // verilator lint_off UNUSED
    // parameter DEFAULT_VALUE = 0
    // verilator lint_on UNUSED
) (
    input clk,
    
    // addr bus
    input [WIDTH_ADDR-1:0] addr_in,
    input bus_dir, // low = main -> mem ; high = mem -> main

    input [WIDTH-1:0] main_in,
    input assert_main, load_main,
    output [WIDTH-1:0] main_out,
    output main_en,

    // mem bus
    // input [WIDTH-1:0] bus_in,
    output [WIDTH-1:0] bus_out
);
    // reg [WIDTH-1:0] memory [0:MEM_SIZE];
    // reg [WIDTH-1:0] value = 0;

    wire [WIDTH-1:0] value;

    wire write_enable = ~(load_main | bus_dir);

    ram ram (
        .clk(~clk),
        .addr(addr_in),
        .data_in(main_in),
        .we(write_enable),
        .data_out(value)
    );


    // integer i;
    // initial begin
    //     for (i = 0; i <= MEM_SIZE; i++) begin
    //         memory[i] = DEFAULT_VALUE;
    //         // memory[i] = {i[7:0]};
    //     end
    // end
    // reg [WIDTH-1:0] data;

    // always @(posedge clk) begin
    //     if(!write_enable)
    //         memory[addr_in] <= main_in;
    //     else
    //         value <= memory[addr_in];
    // end

    // always @(posedge clk) begin
    //     value <= memory[addr_in];
    // end

    // always @(posedge clk) begin
    //     if(write_enable)
    //         value <= memory[addr_in];
    // end

    // assign bus_out = memory[addr_in];
    // assign bus_out = !bus_dir ? main_in : memory[addr_in];
    assign bus_out = value;

    // assign main_out = !bus_dir ? main_in : memory[addr_in];
    assign main_out = !bus_dir ? main_in : value;

    assign main_en = bus_dir & !assert_main;

endmodule
