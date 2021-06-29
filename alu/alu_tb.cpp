#include <stdlib.h>
#include <iostream>
#include <verilated.h>
#include <verilated_vcd_c.h>
#include "Valu.h"

// #define MAX_SIM_TIME 20
vluint64_t sim_time = 0;
Valu *dut = new Valu;
VerilatedVcdC *m_trace = new VerilatedVcdC;

void check_result(const char* test_name, const unsigned char expected) {
    // probably should add a "trace" option that outputs all the meaningful fields
    if(dut->alu__DOT__result != expected)
        std::cerr << "ERROR: " << test_name
            << " exp: " << (int)expected
            << " actual: " << (int)(dut->alu__DOT__result)
            << " simtime: " << sim_time << std::endl
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
    dut->flag_zero = 0;
    dut->flag_acarry = 0;
    dut->flag_lcarry = 0;
    dut->flag_sign = 0;
    dut->flag_overflow = 0;
}

void test_logic(const char* test_name, const unsigned char operation, const unsigned char lhs_in, const unsigned char rhs_in, const unsigned char expected) {
    test_init();
    dut->lhs_in = lhs_in;
    dut->rhs_in = rhs_in;
    dut->operation = operation;

    test_step();
    dut->clk = 1;
    test_step();

    check_result(test_name, expected);
}

int main(int argc, char** argv, char** env) {

    Verilated::traceEverOn(true);
    dut->trace(m_trace, 5);
    m_trace->open("alu_tb.vcd");

    test_init();
    test_step();

    for(int i = 0; i <= 255; i++) {
        for(int j = 0; j <= 255; j++) {
            test_logic("AND", 0xA, i, j, i & j);
            test_logic("OR", 0xB, i, j, i | j);
        }
    }

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

