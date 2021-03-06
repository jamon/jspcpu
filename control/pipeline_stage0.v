module pipeline_stage0 #(
    parameter WIDTH = 8
) (
    input clk,
    input bus_request, fetch_suppress,

    input flag_pcraflip,

    input [WIDTH-1:0] bus_in,

    output [WIDTH-1:0] instruction_out,
    
    output inc_pcra0, inc_pcra1
);
    reg [WIDTH-1:0] prev_instruction;

    always @(negedge clk) begin
        prev_instruction <= bus_in;
    end

    // need to explain this in comments
    assign instruction_out =
        (bus_request == 1 && fetch_suppress == 1) ? prev_instruction
        : (bus_request == 0 && fetch_suppress == 0) ? bus_in
        : 0;

    // need to explain this in comments
    wire [1:0] pcra_inc_select = {bus_request, flag_pcraflip};
    assign inc_pcra0 = pcra_inc_select == 2'h0 ? 0 : 1;
    assign inc_pcra1 = pcra_inc_select == 2'h1 ? 0 : 1;

endmodule
