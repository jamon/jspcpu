#include <stdlib.h>
#include <bitset>
#include <iostream>
#include <verilated.h>
#include <verilated_vcd_c.h>
#include "Vcpu.h"


// #define MAX_SIM_TIME 20
vluint64_t sim_time = 0;
Vcpu *dut = new Vcpu;
VerilatedVcdC *m_trace = new VerilatedVcdC;

void test_step_clk(unsigned int clk) {
    dut->eval();
    dut->clk = clk;

    dut->eval();
    m_trace->dump(sim_time);
    sim_time++;
    dut->eval();
}

void test_init() {
    dut->clk = 0;
    dut->reset = 0;
}



// void lda_imm(unsigned char imm) {
//     dut->test_main_out = imm;
//     dut->test_main_en = 1;
//     dut->a_load_main = 0;
//     test_step_clk(0);
//     test_step_clk(1);
//     dut->test_main_en = 0;
//     dut->a_load_main = 1;
//     std::cout << " lda_imm(" << std::hex << (int)imm << ") simtime: " << std::dec << sim_time << std::endl;
// } 

// void test_control(unsigned char instruction) {
//     const char* test_name = "test_control";
//     test_init();

//     std::cout << test_name << " instruction: 0x" << std::hex << (int)instruction << std::endl;
//     dut->bus_in = instruction;
//     test_step_clk(0);
//     test_step_clk(1);

// }
void load_program() {
    dut->cpu__DOT__core__DOT__mem__DOT__memory[0] = 0x02;
    dut->cpu__DOT__core__DOT__mem__DOT__memory[1] = 2;
    dut->cpu__DOT__core__DOT__mem__DOT__memory[2] = 0xff;
    dut->cpu__DOT__core__DOT__mem__DOT__memory[3] = 0x07;
    dut->cpu__DOT__core__DOT__pcra0__DOT__value = 0;
}
int main(int argc, char** argv, char** env) {
    Verilated::commandArgs(argc, argv);
    Verilated::traceEverOn(true);
    dut->trace(m_trace, 5);
    m_trace->open("cpu_tb.vcd");

    test_init();
    test_step_clk(0);

    load_program();

    // test_control(0x00);
    // test_control(0x01);

    for (int i = 0; i < 20; i++) {
        test_step_clk(0);
        test_step_clk(1);
    }

    m_trace->close();
    delete dut;
    exit(EXIT_SUCCESS);
}

int WinMain(int argc, char** argv, char** env) {
    return main(argc, argv, env);
}

