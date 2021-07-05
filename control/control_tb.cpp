#include <stdlib.h>
#include <bitset>
#include <iostream>
#include <verilated.h>
#include <verilated_vcd_c.h>
#include "Vcontrol.h"


// #define MAX_SIM_TIME 20
vluint64_t sim_time = 0;
Vcontrol *dut = new Vcontrol;
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

void test_control() {
    const char* test_name = "test_control";
    test_init();
}

int main(int argc, char** argv, char** env) {
    Verilated::commandArgs(argc, argv);
    Verilated::traceEverOn(true);
    dut->trace(m_trace, 5);
    m_trace->open("control_tb.vcd");

    test_init();
    test_step_clk(1);

    test_control();

    for (int i = 0; i < 5; i++) {
        test_step_clk(1);
    }

    m_trace->close();
    delete dut;
    exit(EXIT_SUCCESS);
}

int WinMain(int argc, char** argv, char** env) {
    return main(argc, argv, env);
}

