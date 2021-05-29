module pipeline_stage2 #(
    parameter WIDTH = 8
) (
    input clk,
    input bus_request, fetch_suppress,
    input flag_overflow, flag_sign, flag_zero, flag_acarry, flag_lcarry, flag_pcraflip, flag_reset,
    input [7:0] instruction,
    output [7:0] instruction_out,
    output [15:0] controls_out
);
    reg [WIDTH-1:0] rom1 [0:32767];
    reg [WIDTH-1:0] rom2 [0:32767];

    reg [7:0] prev_instruction = 0;
    reg [15:0] controls = 0;

    initial begin
        // controls = 0;
        $readmemh("/home/jamon/code/ecp5/jspcpu/control/pipeline-stage2-rom1.mem", rom1);
        $readmemh("/home/jamon/code/ecp5/jspcpu/control/pipeline-stage2-rom2.mem", rom2);
    end

    integer i;

    wire [15:0] addr = {flag_reset, flag_pcraflip, flag_lcarry, flag_acarry, flag_zero, flag_sign, flag_overflow, instruction};
    always @(posedge clk) begin
        prev_instruction <= instruction;
        controls <= {rom2[addr], rom1[addr]};
        // for (i = 0; i < 8; i = i + 1) begin
        //     controls[i] <= rom2[addr][7-i];
        //     controls[8+i] <= rom1[addr][7-i];
        // end
    end

    assign instruction_out = prev_instruction;
    assign controls_out = controls;

    wire [3:0] mainbus_assert_select;
    wire [3:0] mainbus_load_select;
    wire [1:0] spsidi_inc_select;
    wire [2:0] addr_select;
    wire bus_request_out;
    wire pcra_flip_out;
    wire break_out;

    assign mainbus_assert_select = controls[3:0];
    assign mainbus_load_select = controls[7:4];
    assign spsidi_inc_select = controls[9:8];
    assign addr_select = controls[12:10];
    assign bus_request_out = controls[13];
    assign pcra_flip_out = controls[14];
    assign break_out = controls[15];

endmodule