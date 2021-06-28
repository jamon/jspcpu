#include <stdlib.h>
#include <iostream>
#include <verilated.h>
#include <verilated_vcd_c.h>
#include "Valu.h"

#define MAX_SIM_TIME 20
vluint64_t sim_time = 0;


void test_step(Valu *dut, VerilatedVcdC *m_trace) {
    dut->clk ^= 1;
    dut->eval();
    m_trace->dump(sim_time);
    sim_time++;
}

void test_init(Valu *dut, VerilatedVcdC *m_trace) {
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

void test_and(Valu *dut, VerilatedVcdC *m_trace) {
    test_init(dut, m_trace);
    dut->lhs_in = 0x55;
    dut->rhs_in = 0xAA;
    dut->operation = 0xA;
    dut->clk = 1;
    dut->eval();
    dut->clk = 0;
    test_step(dut, m_trace);
}

void test_or(Valu *dut, VerilatedVcdC *m_trace) {
    test_init(dut, m_trace);
    dut->lhs_in = 0x55;
    dut->rhs_in = 0xAA;
    dut->operation = 0xB;
    dut->clk = 1;
    dut->eval();
    dut->clk = 0;
    test_step(dut, m_trace);
}

int main(int argc, char** argv, char** env) {
    Valu *dut = new Valu;

    Verilated::traceEverOn(true);
    VerilatedVcdC *m_trace = new VerilatedVcdC;
    dut->trace(m_trace, 5);
    m_trace->open("waveform.vcd");

    test_init(dut, m_trace);
    test_step(dut, m_trace);

    test_and(dut, m_trace);
    test_or(dut, m_trace);
    for (int i = 0; i < 5; i++) {
        test_step(dut, m_trace);
    }
    // while (sim_time < MAX_SIM_TIME) {
    //     dut->clk ^= 1;
    //     dut->eval();
    //     m_trace->dump(sim_time);
    //     sim_time++;
    // }

    m_trace->close();
    delete dut;
    exit(EXIT_SUCCESS);
}

int WinMain(int argc, char** argv, char** env) {
    return main(argc, argv, env);
}

