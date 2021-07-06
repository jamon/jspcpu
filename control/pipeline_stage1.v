module pipeline_stage1 #(
    parameter WIDTH = 8
) (
    input clk,
    // verilator lint_off UNUSED
    input bus_request, fetch_suppress,
    // verilator lint_on UNUSED
    input flag_overflow, flag_sign, flag_zero, flag_acarry, flag_lcarry, flag_pcraflip, flag_reset,
    input [7:0] instruction,
    output [7:0] instruction_out,
    output [15:0] controls_out,

    // grouped controls
    output [1:0] lhs_select,
    output [1:0] rhs_select,
    output [3:0] aluop_select,
    output [3:0] xferload_select,
    output [2:0] xferassert_select,
    output fetch_suppress_out
);
    reg [WIDTH-1:0] rom1 [0:32767];
    reg [WIDTH-1:0] rom2 [0:32767];

    // verilator lint_off UNUSED
    reg [7:0] prev_instruction = 0;
    // verilator lint_on UNUSED
    reg [15:0] controls = 0;

    initial begin
        // controls = 0;
        //$readmemh("/home/jamon/code/ecp5/jspcpu/control/pipeline-stage1-rom1.mem", rom1);
        //$readmemh("/home/jamon/code/ecp5/jspcpu/control/pipeline-stage1-rom2.mem", rom2);
        $readmemh("C:/users/ms/Documents/code/jspcpu/control/pipeline-stage1-rom1.mem", rom1);
        $readmemh("C:/users/ms/Documents/code/jspcpu/control/pipeline-stage1-rom2.mem", rom2);
        
    end
  
    wire [14:0] addr = {flag_reset, flag_pcraflip, flag_lcarry, flag_acarry, flag_zero, flag_sign, flag_overflow, instruction};
    always @(negedge clk) begin
        prev_instruction <= instruction;
        controls <= {rom2[addr], rom1[addr]};
    end

    // assign instruction_out = (bus_request == 1 || fetch_suppress == 1) ? 0 : prev_instruction;
    assign instruction_out = prev_instruction;

    assign controls_out = controls;
    
    // verilator lint_off UNUSED
    assign lhs_select = controls[1:0];
    assign rhs_select = controls[3:2];
    assign aluop_select = controls[7:4];
    assign xferload_select = controls[11:8];
    assign xferassert_select = controls[14:12];
    assign fetch_suppress_out = controls[15];
    // verilator lint_on UNUSED



endmodule
