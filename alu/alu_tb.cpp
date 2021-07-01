#include <stdlib.h>
#include <bitset>
#include <iostream>
#include <verilated.h>
#include <verilated_vcd_c.h>
#include "Valu.h"

#define FLAG_OVERFLOW 1
#define FLAG_SIGN 1<<1
#define FLAG_ZERO 1<<2
#define FLAG_CARRYA 1<<3
#define FLAG_CARRYL 1<<4
#define FLAG_PCRAFLIP 1<<5
#define OP_NOOP 0x0
#define OP_SHL  0x1
#define OP_SHR  0x2
#define OP_ADD  0x3
#define OP_ADDC 0x4
#define OP_INC  0x5
#define OP_INCC 0x6
#define OP_SUB  0x7
#define OP_SUBB 0x8
#define OP_DEC  0x9
#define OP_AND  0xA
#define OP_OR   0xB
#define OP_XOR  0xC
#define OP_NOT  0xD
#define OP_CLC  0xE
#define OP_UNUSED 0xF
// #define MAX_SIM_TIME 20
vluint64_t sim_time = 0;
Valu *dut = new Valu;
VerilatedVcdC *m_trace = new VerilatedVcdC;

void check_result(const char* test_name, const unsigned char expected, bool calc_flags = true, const unsigned char flags_expected_on_manual = 0, const unsigned char flags_expected_off_manual = 0) {
    // probably should add a "trace" option that outputs all the meaningful fields
    // (lhs_out[WIDTH-1] ^ result[WIDTH-1]) & (rhs_out[WIDTH-1] ^ result[WIDTH-1]);
    // probably bad form to read lhs_out/rhs_out to determine signs
    unsigned char lhs_sign = dut->alu__DOT__lhs_out >> 7;
    unsigned char rhs_sign = dut->alu__DOT__rhs_out >> 7;
    unsigned char res_sign = expected >> 7;
    // logic carry flag calculation doesn't work, so we'll ignore it
    // unsigned char carryl = 
    //     dut->operation == OP_SHL ? expected >> 7 :
    //     dut->operation == OP_SHR ? expected & 1 :
    //     dut->operation >= OP_AND ? 0 :
    //     dut->operation == dut->alu__DOT__lhs1__DOT__carry; // probably bad form to reference the internal state

    unsigned char flags_expected_on_calc = 0
        | ((lhs_sign ^ res_sign) & (rhs_sign ^ res_sign) ? FLAG_OVERFLOW : 0)
        | (res_sign ? FLAG_SIGN : 0)
        | (expected == 0 ? FLAG_ZERO : 0)
        | (
            (int)dut->operation >= 3 
            && (int)dut->operation <= 9
            && (int)dut->rhs_in + (int)dut->lhs_in > 255 
            ? FLAG_CARRYA : 0
        );
        // | (carryl ? FLAG_CARRYL : 0);
    unsigned char flags_expected_off_calc = ~(flags_expected_on_calc | FLAG_CARRYL) ;

    unsigned char flags_expected_on = !calc_flags ? flags_expected_on_manual : flags_expected_on_calc;
    unsigned char flags_expected_off = !calc_flags ? flags_expected_off_manual : flags_expected_off_calc;

    unsigned char expected_on_result = ~flags_expected_on | dut->flags;
    unsigned char expected_off_result = flags_expected_off & (~flags_expected_off | dut->flags);

    if(dut->bus_out != expected || expected_on_result != 0xFF || expected_off_result != 0x00)
        std::cerr << "ERROR: " << test_name
            << " simtime: " << sim_time << std::endl
            << " exp: " << (int)expected
            << " actual: " << (int)(dut->bus_out)
            << " calc_flags: " << (calc_flags ? "true" : "false")
            << " flags: "
                << ((dut->flags & FLAG_CARRYL) ? "CARRYL " : "")
                << ((dut->flags & FLAG_CARRYA) ? "CARRYA " : "")
                << ((dut->flags & FLAG_ZERO) ? "ZERO " : "")
                << ((dut->flags & FLAG_SIGN) ? "SIGN " : "")
                << ((dut->flags & FLAG_OVERFLOW) ? "OVERFLOW " : "")
            << std::endl
            << " expected flags: "
                << ((flags_expected_on & FLAG_CARRYL) ? "CARRYL " : "")
                << ((flags_expected_on & FLAG_CARRYA) ? "CARRYA " : "")
                << ((flags_expected_on & FLAG_ZERO) ? "ZERO " : "")
                << ((flags_expected_on & FLAG_SIGN) ? "SIGN " : "")
                << ((flags_expected_on & FLAG_OVERFLOW) ? "OVERFLOW " : "")
            << std::endl
             << " unexpected flags: "
                << ((flags_expected_off & FLAG_CARRYL) ? "CARRYL " : "")
                << ((flags_expected_off & FLAG_CARRYA) ? "CARRYA " : "")
                << ((flags_expected_off & FLAG_ZERO) ? "ZERO " : "")
                << ((flags_expected_off & FLAG_SIGN) ? "SIGN " : "")
                << ((flags_expected_off & FLAG_OVERFLOW) ? "OVERFLOW " : "")
            << std::endl

            // << "\tres_sign: " << (int)res_sign << std::endl
            // << "\t flags: " << std::bitset<8>((int)(dut->flags)) << std::endl
            // << "\t exp_1: " << std::bitset<8>((int)(flags_expected_on)) << std::endl
            // << "\t exp_0: " << std::bitset<8>((int)(flags_expected_off)) << std::endl
            // << "\t ~exp1: " << std::bitset<8>((int)(~flags_expected_on)) << std::endl
            // << "\t eonr : " << std::bitset<8>((int)(expected_on_result)) << std::endl
            // << "\t eoffr: " << std::bitset<8>((int)(expected_off_result)) << std::endl
            << "\tlhs_in = " << (int)(dut->lhs_in) << std::endl
            << "\trhs_in = " << (int)(dut->rhs_in) << std::endl
            << "\toperation = " << (int)(dut->operation) << std::endl;
    
}
void test_step() {
    // dut->clk ^= 1;
    dut->eval();
    m_trace->dump(sim_time);
    sim_time++;
}

void test_init() {
    dut->clk = 0;
    dut->lhs_in = 0;
    dut->rhs_in = 0;
    dut->operation = 0;
    dut->assert_bus = 0;
}

void test_logic(const char* test_name, const unsigned char operation, const unsigned char lhs_in, const unsigned char rhs_in, const unsigned char expected, bool calc_flags = true, const unsigned char flags_expected_on = 0, const unsigned char flags_expected_off = 0) {
    test_init();
    dut->lhs_in = lhs_in;
    dut->rhs_in = rhs_in;
    dut->operation = operation;

    test_step();
    dut->clk = 1;
    test_step();

    check_result(test_name, expected, calc_flags, flags_expected_on, flags_expected_off);
}

int main(int argc, char** argv, char** env) {
    Verilated::commandArgs(argc, argv);
    Verilated::traceEverOn(true);
    dut->trace(m_trace, 5);
    m_trace->open("alu_tb.vcd");

    test_init();
    test_step();

    // check_result("check_result_test", 0, )
    // test_logic("ADD", 0x3, 254, 2, 0, false, FLAG_ZERO | FLAG_CARRYA, FLAG_CARRYL | FLAG_SIGN | FLAG_OVERFLOW);
    // test_logic("ADD", 0x3, 254, 1, 255, false, FLAG_SIGN, FLAG_CARRYL | FLAG_CARRYA | FLAG_ZERO | FLAG_OVERFLOW);

    test_logic("ADD", OP_ADD, 255, 0, 255);
    test_logic("OR", OP_OR, 0x1F, 0xF8, 0x1F | 0xF8, true);
    test_logic("SHL", OP_SHL, 0xFF, 0, (0xFF << 1) & 0xFF);
    test_logic("SHL", OP_SHL, 0xFF, 0, ((0xFF << 1) | 1) & 0xFF);
    test_logic("SHL", OP_SHR, 0x7F, 0, (0x7F >> 1) | (1 << 7)); 

    test_logic("CLC - prep", OP_CLC, 0, 0, 0, false, 0, FLAG_CARRYL | FLAG_CARRYA);
    test_logic("CLC - 0xff << sets FLAG_CARRYL", OP_SHL, 0xff, 0, 0xff << 1 & 0xff, false, FLAG_CARRYL);
    test_logic("CLC - CLC clears FLAG_CARRYL", OP_CLC, 0, 0, 0, false, 0, FLAG_CARRYL | FLAG_CARRYA);

    // for(int i = 0; i <= 255; i++) {
    //     test_logic("SHL", OP_SHL, i, 0, i << 1);
    //     test_logic("SHR", OP_SHR, i, 0, i >> 1);
    //     for(int j = 0; j <= 255; j++) {
    //         test_logic("ADD", OP_ADD, i, j, i + j);
    //         // test_logic("AND", OP_AND, i, j, i & j);
    //         // test_logic("OR", OP_OR, i, j, i | j);
    //     }
    // }

    for (int i = 0; i < 5; i++) {
        test_step();
    }

    m_trace->close();
    delete dut;
    exit(EXIT_SUCCESS);
}

int WinMain(int argc, char** argv, char** env) {
    return main(argc, argv, env);
}

