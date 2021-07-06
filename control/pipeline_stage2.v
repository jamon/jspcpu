module pipeline_stage2 #(
    parameter WIDTH = 8
) (
    input clk,
    input flag_overflow, flag_sign, flag_zero, flag_acarry, flag_lcarry, flag_pcraflip, flag_reset,
    input [7:0] instruction,
    output [7:0] instruction_out,
    
    // full output
    output [15:0] controls_out,

    // grouped outputs
    output [3:0] mainbus_assert_select,
    output [3:0] mainbus_load_select,
    output [1:0] spsidi_inc_select,
    output [2:0] addr_select,
    output bus_request_out,
    output pcra_flip_out,
    output break_out,

    // individual outputs
    output a_assert_main, b_assert_main, c_assert_main, d_assert_main, const_assert_main, tl_assert_main, th_assert_main, alu_assert_main, dev9_assert_main, dev10_assert_main, dev11_assert_main, dev12_assert_main, dev13_assert_main, dev14_assert_main, mem_assert_main,
    output a_load_main, b_load_main, c_load_main, d_load_main, const_load_main, tl_load_main, th_load_main, alu_load_main, dev9_load_main, dev10_load_main, dev11_load_main, dev12_load_main, dev13_load_main, dev14_load_main, mem_load_main, mem_dir,
    output sp_inc, si_inc, di_inc,
    output mem_ack, pcra0_assert_addr, pcra1_assert_addr, sp_assert_addr, si_assert_addr, di_assert_addr, tx_assert_addr

);
    reg [WIDTH-1:0] rom1 [0:32767];
    reg [WIDTH-1:0] rom2 [0:32767];

    reg [7:0] prev_instruction = 0;
    reg [15:0] controls = 0;

    initial begin
        // controls = 0;
        $readmemh("C:/users/ms/Documents/code/jspcpu/control/pipeline-stage2-rom1.mem", rom1);
        $readmemh("C:/users/ms/Documents/code//jspcpu/control/pipeline-stage2-rom2.mem", rom2);
    end

    wire [14:0] addr = {flag_reset, flag_pcraflip, flag_lcarry, flag_acarry, flag_zero, flag_sign, flag_overflow, instruction};
    always @(negedge clk) begin
        prev_instruction <= instruction;
        controls <= {rom2[addr], rom1[addr]};
        // for (i = 0; i < 8; i = i + 1) begin
        //     controls[i] <= rom2[addr][7-i];
        //     controls[8+i] <= rom1[addr][7-i];
        // end
    end

    assign instruction_out = prev_instruction;
    assign controls_out = controls;

    // verilator lint_off UNUSED
    assign mainbus_assert_select = controls[3:0];
    assign mainbus_load_select    = controls[7:4];
    assign spsidi_inc_select      = controls[9:8];
    assign addr_select            = controls[12:10];

    assign a_assert_main       = mainbus_assert_select == 4'h1 ? 0 : 1;
    assign b_assert_main       = mainbus_assert_select == 4'h2 ? 0 : 1;
    assign c_assert_main       = mainbus_assert_select == 4'h3 ? 0 : 1;
    assign d_assert_main       = mainbus_assert_select == 4'h4 ? 0 : 1;
    assign const_assert_main   = mainbus_assert_select == 4'h5 ? 0 : 1;
    assign tl_assert_main      = mainbus_assert_select == 4'h6 ? 0 : 1;
    assign th_assert_main      = mainbus_assert_select == 4'h7 ? 0 : 1;
    assign alu_assert_main     = mainbus_assert_select == 4'h8 ? 0 : 1;
    assign dev9_assert_main    = mainbus_assert_select == 4'h9 ? 0 : 1;
    assign dev10_assert_main   = mainbus_assert_select == 4'hA ? 0 : 1;
    assign dev11_assert_main   = mainbus_assert_select == 4'hB ? 0 : 1;
    assign dev12_assert_main   = mainbus_assert_select == 4'hC ? 0 : 1;
    assign dev13_assert_main   = mainbus_assert_select == 4'hD ? 0 : 1;    
    assign dev14_assert_main   = mainbus_assert_select == 4'hE ? 0 : 1;
    assign mem_assert_main     = mainbus_assert_select == 4'hF ? 0 : 1;

    assign a_load_main         = mainbus_load_select == 4'h1 ? 0 : 1;
    assign b_load_main         = mainbus_load_select == 4'h2 ? 0 : 1;
    assign c_load_main         = mainbus_load_select == 4'h3 ? 0 : 1;
    assign d_load_main         = mainbus_load_select == 4'h4 ? 0 : 1;
    assign const_load_main     = mainbus_load_select == 4'h5 ? 0 : 1;
    assign tl_load_main        = mainbus_load_select == 4'h6 ? 0 : 1;
    assign th_load_main        = mainbus_load_select == 4'h7 ? 0 : 1;
    assign alu_load_main       = mainbus_load_select == 4'h8 ? 0 : 1;
    assign dev9_load_main      = mainbus_load_select == 4'h9 ? 0 : 1;
    assign dev10_load_main     = mainbus_load_select == 4'hA ? 0 : 1;
    assign dev11_load_main     = mainbus_load_select == 4'hB ? 0 : 1;
    assign dev12_load_main     = mainbus_load_select == 4'hC ? 0 : 1;
    assign dev13_load_main     = mainbus_load_select == 4'hD ? 0 : 1;    
    assign dev14_load_main     = mainbus_load_select == 4'hE ? 0 : 1;
    assign mem_load_main       = mainbus_load_select == 4'hF ? 0 : 1;

    assign mem_dir             = mainbus_load_select == 4'hF ? 0 : 1;

    assign sp_inc = spsidi_inc_select == 2'h1 ? 0 : 1;    
    assign si_inc = spsidi_inc_select == 2'h2 ? 0 : 1;    
    assign di_inc = spsidi_inc_select == 2'h3 ? 0 : 1;                

    assign mem_ack              = addr_select == 3'h0 ? 0 : 1;
    assign pcra0_assert_addr    = addr_select == 3'h0 ? 0 : 1;
    assign pcra1_assert_addr    = addr_select == 3'h0 ? 0 : 1;
    assign sp_assert_addr       = addr_select == 3'h0 ? 0 : 1;
    assign si_assert_addr       = addr_select == 3'h0 ? 0 : 1;
    assign di_assert_addr       = addr_select == 3'h0 ? 0 : 1;
    assign tx_assert_addr       = addr_select == 3'h0 ? 0 : 1;

    assign bus_request_out        = controls[13];
    assign pcra_flip_out          = controls[14];
    assign break_out              = controls[15];
    // verilator lint_on UNUSED

endmodule
