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
        //$readmemh("/home/jamon/code/ecp5/jspcpu/control/pipeline-stage1-rom1.mem", rom1);
        //$readmemh("/home/jamon/code/ecp5/jspcpu/control/pipeline-stage1-rom2.mem", rom2);
        $readmemh("C:/users/ms/Documents/code/jspcpu/control/pipeline-stage1-rom1.mem", rom1);
        $readmemh("C:/users/ms/Documents/code/jspcpu/control/pipeline-stage1-rom2.mem", rom2);
        
    end
  
    wire [14:0] addr = {flag_reset, flag_pcraflip, flag_lcarry, flag_acarry, flag_zero, flag_sign, flag_overflow, instruction};
    always @(posedge clk) begin
        prev_instruction <= instruction;
        controls <= {rom2[addr], rom1[addr]};
    end

    assign instruction_out = (!bus_request || !fetch_suppress) ? 0 : prev_instruction;
    assign controls_out = controls;
    
    // verilator lint_off UNUSED
    wire [1:0] lhs_select = controls[1:0];
    wire [1:0] rhs_select = controls[3:2];
    wire [3:0] aluop_select = controls[7:4];
    wire [3:0] xferload_select = controls[11:8];
    wire [2:0] xferassert_select = controls[14:12];
    wire fetch_suppress_out = controls[15];
    // verilator lint_on UNUSED

endmodule
