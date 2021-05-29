module mem #(
    parameter WIDTH_ADDR = 16,
    parameter WIDTH = 8,
    parameter MEM_SIZE = 65535,
    parameter DEFAULT_VALUE = 0
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
    reg [WIDTH-1:0] memory [0:MEM_SIZE];

    integer i;
    initial begin
        for (i = 0; i <= MEM_SIZE; i++) begin
            memory[i] = DEFAULT_VALUE;
        end
    end
    // reg [WIDTH-1:0] data;

    always @(posedge clk) begin
        if(load_main & !bus_dir)
            memory[addr_in] <= main_in;
    end

    assign bus_out = !bus_dir ? main_in : memory[addr_in];

    assign main_out = memory[addr_in];
    assign main_en = bus_dir & !assert_main;

endmodule