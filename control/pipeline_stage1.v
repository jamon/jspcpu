module pipeline_stage1 #(
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
        $readmemh("/home/jamon/code/ecp5/jspcpu/control/pipeline-stage1-rom1.mem", rom1);
        $readmemh("/home/jamon/code/ecp5/jspcpu/control/pipeline-stage1-rom2.mem", rom2);
    end
 
    integer i;
 
    wire [15:0] addr = {flag_reset, flag_pcraflip, flag_lcarry, flag_acarry, flag_zero, flag_sign, flag_overflow, instruction};
    always @(posedge clk) begin
        prev_instruction <= instruction;
        controls <= {rom2[addr], rom1[addr]};
            // lhs_select <= controls[1:0];
            // rhs_select <= controls[3:2];
            // aluop_select <= controls[7:4];
            // xferload_select <= controls[11:8];
            // xferassert_select <= controls[14:12];
            // fetch_suppress_out <= controls[15];
        // for (i = 0; i < 8; i = i + 1) begin
        //     controls[i] <= rom2[addr][7-i];
        //     controls[8+i] <= rom1[addr][7-i];
        // end
    end

    assign instruction_out = (!bus_request || !fetch_suppress) ? 0 : prev_instruction;
    assign controls_out = controls;
    
    wire [1:0] lhs_select;
    wire [1:0] rhs_select;
    wire [3:0] aluop_select;
    wire [3:0] xferload_select;
    wire [2:0] xferassert_select;
    wire fetch_suppress_out;

    assign lhs_select = controls[1:0];
    assign rhs_select = controls[3:2];
    assign aluop_select = controls[7:4];

    assign xferload_select = controls[11:8];
    assign xferassert_select = controls[14:12];
    assign fetch_suppress_out = controls[15];

endmodule