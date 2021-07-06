`include "../register_gp/register_gp.v"
`include "../register_const/register_const.v"
`include "../register_xfer/register_xfer.v"
`include "../register_addr/register_addr.v"
`include "../bus/bus.v"
`include "../mem/mem.v"
`include "../alu/alu.v"

module core(
    input clk, reset,

    // test bus inputs
    // verilator lint_off PINMISSING
    input [WIDTH_MAIN-1:0] test_main_out,
    input [WIDTH_AX-1:0] test_addr_out, test_xfer_out,
    input test_main_en, test_addr_en, test_xfer_en,
    // verilator lint_on PINMISSING

    // 8 bit register control signals
    input   a_assert_main, a_load_main,
            a_assert_lhs,
            a_assert_rhs,
    input   b_assert_main, b_load_main,
            b_assert_lhs,
            b_assert_rhs,
    input   c_assert_main, c_load_main,
            c_assert_lhs,
            c_assert_rhs,
    input   d_assert_main, d_load_main,
            d_assert_lhs,
            d_assert_rhs,

    // constant register control signals
    input   const_assert_main,
            const_load_mem,
    
    // xfer register control signals
    input   xfer_assert_addr,
            xfer_assert_xfer, xfer_load_xfer,
            xfer_assertlow_main, xfer_loadlow_main,
            xfer_asserthigh_main, xfer_loadhigh_main,

    // 16-bit register control signals
    input   pcra0_assert_addr,
            pcra0_assert_xfer, pcra0_load_xfer,
            pcra0_inc, pcra0_dec,
    input   pcra1_assert_addr,
            pcra1_assert_xfer, pcra1_load_xfer,
            pcra1_inc, pcra1_dec,
    input   sp_assert_addr,
            sp_assert_xfer, sp_load_xfer,
            sp_inc, sp_dec,
    input   si_assert_addr,
            si_assert_xfer, si_load_xfer,
            si_inc, si_dec,
    input   di_assert_addr,
            di_assert_xfer, di_load_xfer,
            di_inc, di_dec,

    input   mem_dir,
            mem_assert_main, mem_load_main,

    // alu
    input   alu_assert_main,
    input   [3:0] alu_operation,

    // bus outputs
    // verilator lint_off PINMISSING
    output  [WIDTH_AX-1:0] addr_out, xfer_out,
    output  [WIDTH_MAIN-1:0] main_out, lhs_out, rhs_out, mem_out
    // verilator lint_off PINMISSING

);
    localparam WIDTH_AX = 16; // bus width for addr and xfer bus in bits
    localparam WIDTH_MAIN = 8; // bus width for main bus in bits

    // -----------> REGISTER A <------------
    wire [WIDTH_MAIN-1:0] a_main_out;
    wire a_main_en;

    wire [WIDTH_MAIN-1:0] a_lhs_out;
    wire a_lhs_en;

    wire [WIDTH_MAIN-1:0] a_rhs_out;
    wire a_rhs_en;
    
    register_gp #(.WIDTH(WIDTH_MAIN)) a (
        .clk(clk),

        // main bus
        .bus_in(main_out),
        .load_bus(a_load_main),
        .assert_bus(a_assert_main),
        .bus_out(a_main_out), .bus_en(a_main_en),

        // lhs bus
        .assert_lhs(a_assert_lhs), .lhs_out(a_lhs_out), .lhs_en(a_lhs_en),

        // rhs bus
        .assert_rhs(a_assert_rhs), .rhs_out(a_rhs_out), .rhs_en(a_rhs_en)
    );

    // -----------> REGISTER B <------------
    wire [WIDTH_MAIN-1:0] b_main_out;
    wire b_main_en;

    wire [WIDTH_MAIN-1:0] b_lhs_out;
    wire b_lhs_en;

    wire [WIDTH_MAIN-1:0] b_rhs_out;
    wire b_rhs_en;

    register_gp #(.WIDTH(WIDTH_MAIN)) b (
        .clk(clk),

        // main bus
        .bus_in(main_out),
        .load_bus(b_load_main),
        .assert_bus(b_assert_main),
        .bus_out(b_main_out), .bus_en(b_main_en),

        // lhs bus
        .assert_lhs(b_assert_lhs), .lhs_out(b_lhs_out), .lhs_en(b_lhs_en),

        // rhs bus
        .assert_rhs(b_assert_rhs), .rhs_out(b_rhs_out), .rhs_en(b_rhs_en)
    );

    // -----------> REGISTER C <------------
    wire [WIDTH_MAIN-1:0] c_main_out;
    wire c_main_en;

    wire [WIDTH_MAIN-1:0] c_lhs_out;
    wire c_lhs_en;

    wire [WIDTH_MAIN-1:0] c_rhs_out;
    wire c_rhs_en;
    
    register_gp #(.WIDTH(WIDTH_MAIN)) c (
        .clk(clk),

        // main bus
        .bus_in(main_out),
        .load_bus(c_load_main),
        .assert_bus(c_assert_main),
        .bus_out(c_main_out), .bus_en(c_main_en),

        // lhs bus
        .assert_lhs(c_assert_lhs), .lhs_out(c_lhs_out), .lhs_en(c_lhs_en),

        // rhs bus
        .assert_rhs(c_assert_rhs), .rhs_out(c_rhs_out), .rhs_en(c_rhs_en)
    );

    // -----------> REGISTER D <------------
    wire [WIDTH_MAIN-1:0] d_main_out;
    wire d_main_en;

    wire [WIDTH_MAIN-1:0] d_lhs_out;
    wire d_lhs_en;

    wire [WIDTH_MAIN-1:0] d_rhs_out;
    wire d_rhs_en;
    
    register_gp #(.WIDTH(WIDTH_MAIN)) d (
        .clk(clk),

        // main bus
        .bus_in(main_out),
        .load_bus(d_load_main),
        .assert_bus(d_assert_main),
        .bus_out(d_main_out), .bus_en(d_main_en),

        // lhs bus
        .assert_lhs(d_assert_lhs), .lhs_out(d_lhs_out), .lhs_en(d_lhs_en),

        // rhs bus
        .assert_rhs(d_assert_rhs), .rhs_out(d_rhs_out), .rhs_en(d_rhs_en)
    );


    // -----------> REGISTER CONST <------------
    wire [WIDTH_MAIN-1:0] const_main_out;
    wire const_main_en;

    register_const #(.WIDTH(8)) const1 (
        .clk(clk),

        // mem bus
        .bus_in(mem_out),
        .load_bus(const_load_mem),

        // main bus
        .assert_bus(const_assert_main),
        .bus_out(const_main_out),
        .bus_en(const_main_en)
    );


    // -----------> REGISTER XFER <------------

    wire [WIDTH_AX-1:0] xfer_addr_out;
    wire xfer_addr_en;

    wire [WIDTH_AX-1:0] xfer_xfer_out;
    wire xfer_xfer_en;

    wire [WIDTH_MAIN-1:0] xfer_main_out;
    wire xfer_main_en;

    register_xfer #(.WIDTH_AX(16), .WIDTH_MAIN(8)) xfer (
        .clk(clk),

        .assert_addr(xfer_assert_addr),
        .addr_out(xfer_addr_out), .addr_en(xfer_addr_en),

        // xfer bus
        .xfer_in(xfer_out),
        .load_xfer(xfer_load_xfer),
        .assert_xfer(xfer_assert_xfer),
        .xfer_out(xfer_xfer_out), .xfer_en(xfer_xfer_en),

        // main bus
        .main_in(main_out),
        .loadlow_main(xfer_loadlow_main),
        .loadhigh_main(xfer_loadhigh_main),
        .assertlow_main(xfer_assertlow_main),
        .asserthigh_main(xfer_asserthigh_main),
        .main_out(xfer_main_out), .main_en(xfer_main_en)
    );
	


    // -----------> REGISTER PCRA0 <------------
    wire [WIDTH_AX-1:0] pcra0_addr_out;
    wire pcra0_addr_en;

    wire [WIDTH_AX-1:0] pcra0_xfer_out;
    wire pcra0_xfer_en;

    register_addr #(.WIDTH(WIDTH_AX)) pcra0 (
        .clk(clk),
        .reset(reset),

        // addr bus
        .assert_addr(pcra0_assert_addr),
        .addr_out(pcra0_addr_out),
        .addr_en(pcra0_addr_en),

        // xfer bus
        .xfer_in(xfer_out),
        .assert_xfer(pcra0_assert_xfer),
        .load_xfer(pcra0_load_xfer),
        .xfer_out(pcra0_xfer_out),
        .xfer_en(pcra0_xfer_en),

        .inc(pcra0_inc),
        .dec(pcra0_dec)
    );

    // -----------> REGISTER PCRA1 <------------
    wire [WIDTH_AX-1:0] pcra1_addr_out;
    wire pcra1_addr_en;

    wire [WIDTH_AX-1:0] pcra1_xfer_out;
    wire pcra1_xfer_en;

    register_addr #(.WIDTH(WIDTH_AX)) pcra1 (
        .clk(clk),
        .reset(reset),

        // addr bus
        .assert_addr(pcra1_assert_addr),
        .addr_out(pcra1_addr_out),
        .addr_en(pcra1_addr_en),

        // xfer bus
        .xfer_in(xfer_out),
        .assert_xfer(pcra1_assert_xfer),
        .load_xfer(pcra1_load_xfer),
        .xfer_out(pcra1_xfer_out),
        .xfer_en(pcra1_xfer_en),

        .inc(pcra1_inc),
        .dec(pcra1_dec)
    );

    // -----------> REGISTER SP <------------
    wire [WIDTH_AX-1:0] sp_addr_out;
    wire sp_addr_en;

    wire [WIDTH_AX-1:0] sp_xfer_out;
    wire sp_xfer_en;

    register_addr #(.WIDTH(WIDTH_AX)) sp (
        .clk(clk),
        .reset(reset),

        // addr bus
        .assert_addr(sp_assert_addr),
        .addr_out(sp_addr_out),
        .addr_en(sp_addr_en),

        // xfer bus
        .xfer_in(xfer_out),
        .assert_xfer(sp_assert_xfer),
        .load_xfer(sp_load_xfer),
        .xfer_out(sp_xfer_out),
        .xfer_en(sp_xfer_en),

        .inc(sp_inc),
        .dec(sp_dec)
    );

    // -----------> REGISTER SI <------------
    wire [WIDTH_AX-1:0] si_addr_out;
    wire si_addr_en;

    wire [WIDTH_AX-1:0] si_xfer_out;
    wire si_xfer_en;

    register_addr #(.WIDTH(WIDTH_AX)) si (
        .clk(clk),
        .reset(reset),

        // addr bus
        .assert_addr(si_assert_addr),
        .addr_out(si_addr_out),
        .addr_en(si_addr_en),

        // xfer bus
        .xfer_in(xfer_out),
        .assert_xfer(si_assert_xfer),
        .load_xfer(si_load_xfer),
        .xfer_out(si_xfer_out),
        .xfer_en(si_xfer_en),

        .inc(si_inc),
        .dec(si_dec)
    );

    // -----------> REGISTER DI <------------
    wire [WIDTH_AX-1:0] di_addr_out;
    wire di_addr_en;

    wire [WIDTH_AX-1:0] di_xfer_out;
    wire di_xfer_en;

    register_addr #(.WIDTH(WIDTH_AX)) di (
        .clk(clk),
        .reset(reset),

        // addr bus
        .assert_addr(di_assert_addr),
        .addr_out(di_addr_out),
        .addr_en(di_addr_en),

        // xfer bus
        .xfer_in(xfer_out),
        .assert_xfer(di_assert_xfer),
        .load_xfer(di_load_xfer),
        .xfer_out(di_xfer_out),
        .xfer_en(di_xfer_en),

        .inc(di_inc),
        .dec(di_dec)
    );



  
    // -----------> ALU <------------
    wire [WIDTH_MAIN-1:0] alu_main_out;
    wire alu_main_en;

    // verilator lint_off UNUSED
    wire alu_flag_lcarry, alu_flag_acarry, alu_flag_zero, alu_flag_sign, alu_flag_overflow; 
    wire [4:0] alu_flags;
    // verilator lint_on UNUSED

    alu #(.WIDTH(WIDTH_MAIN)) alu (
        .clk(clk),

        .lhs_in(lhs_out), .rhs_in(rhs_out),

        .operation(alu_operation),

        // main bus
        .assert_bus(alu_assert_main),
        .bus_out(alu_main_out), .bus_en(alu_main_en),

        .flag_lcarry(alu_flag_lcarry), .flag_acarry(alu_flag_acarry), .flag_zero(alu_flag_zero), .flag_sign(alu_flag_sign), .flag_overflow(alu_flag_overflow),
        .flags(alu_flags)
    );

    // -----------> MEMORY <------------

    // wire [WIDTH_MAIN-1:0] mem_out;

    wire [WIDTH_MAIN-1:0] mem_main_out;
    wire mem_main_en;

	mem #(.WIDTH(WIDTH_MAIN)) mem (
		.clk(clk),

		.addr_in(addr_out),

		.bus_dir(mem_dir), // low = main->mem ; high = mem->main

		// main bus
		.main_in(main_out),
		.assert_main(mem_assert_main),
		.load_main(mem_load_main),
		.main_out(mem_main_out),
		.main_en(mem_main_en),

		// mem bus
		.bus_out(mem_out)
	);

    // -----------> BUS MAIN <------------

	bus #(.WIDTH(WIDTH_MAIN),.COUNT(9)) mainbus (
        .in({
            test_main_out,
            a_main_out,
            b_main_out,
            c_main_out,
            d_main_out,
            const_main_out,
            mem_main_out,
            alu_main_out,
            xfer_main_out
        }),
        .enable({
            test_main_en,
            a_main_en,
            b_main_en,
            c_main_en,
            d_main_en,
            const_main_en,
            mem_main_en,
            alu_main_en,
            xfer_main_en
        }),
        .out(main_out)
    );

    // -----------> BUS LHS <------------
	bus #(.WIDTH(WIDTH_MAIN),.COUNT(4)) lhsbus (
        .in({
            a_lhs_out,
            b_lhs_out,
            c_lhs_out,
            d_lhs_out
        }),
        .enable({
            a_lhs_en,
            b_lhs_en,
            c_lhs_en,
            d_lhs_en
        }),
        .out(lhs_out)
    );
    // -----------> BUS RHS <------------
	bus #(.WIDTH(WIDTH_MAIN),.COUNT(4)) rhsbus (
        .in({
            a_rhs_out,
            b_rhs_out,
            c_rhs_out,
            d_rhs_out
        }),
        .enable({
            a_rhs_en,
            b_rhs_en,
            c_rhs_en,
            d_rhs_en
        }),
        .out(rhs_out)
    );

    // -----------> BUS ADDR <------------

	bus #(.WIDTH(WIDTH_AX),.COUNT(7)) addrbus (
        .in({
            test_addr_out,
            pcra0_addr_out,
            pcra1_addr_out,
            sp_addr_out,
            si_addr_out,
            di_addr_out,
            xfer_addr_out
        }),
        .enable({
            test_addr_en,
            pcra0_addr_en,
            pcra1_addr_en,
            sp_addr_en,
            si_addr_en,
            di_addr_en,
            xfer_addr_en
        }),
        .out(addr_out)
    );

    // -----------> BUS XFER <------------

	bus #(.WIDTH(WIDTH_AX),.COUNT(7)) xferbus (
        // .clk(clk),
        .in({
            test_xfer_out,
            pcra0_xfer_out,
            pcra1_xfer_out,
            sp_xfer_out,
            si_xfer_out,
            di_xfer_out,
            xfer_xfer_out
        }),
        .enable({
            test_xfer_en,
            pcra0_xfer_en,
            pcra1_xfer_en,
            sp_xfer_en,
            si_xfer_en,
            di_xfer_en,
            xfer_xfer_en
        }),
        .out(xfer_out)
    );

endmodule
