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

    dut->test_main_out = 0;
    dut->test_main_en = 0;

    dut->test_addr_out = 0;
    dut->test_addr_en = 0;

    dut->test_xfer_out = 0;
    dut->test_xfer_en = 0;
}
void clear_mem() {
    for(int i = 0; i <= 65535; i++) {
        dut->cpu__DOT__core__DOT__mem__DOT__ram__DOT__store[i] = 0x00;
    }
}
void reset_cpu() {
    dut->reset = 1;
    for(int i = 0; i < 5; i++) {
        test_step_clk(0);
        test_step_clk(1);
    }
    dut->reset = 0;
}
void test_simple() {
    clear_mem();
    dut->cpu__DOT__core__DOT__mem__DOT__ram__DOT__store[0] = 0x00;   // NOP
    dut->cpu__DOT__core__DOT__mem__DOT__ram__DOT__store[1] = 0x01;   // LD A, #
    dut->cpu__DOT__core__DOT__mem__DOT__ram__DOT__store[2] = 255;    // 255   
    dut->cpu__DOT__core__DOT__mem__DOT__ram__DOT__store[3] = 0x07;   // MOV A, B
    test_init();
    reset_cpu();

    for(int i = 0; i < 20; i++) {
        test_step_clk(0);
        test_step_clk(1);
    }
}
void test_mem_reg_bus_alu() {
    clear_mem();

    dut->cpu__DOT__core__DOT__mem__DOT__ram__DOT__store[0] = 0x00;
    dut->cpu__DOT__core__DOT__mem__DOT__ram__DOT__store[1] = 0x00;
    dut->cpu__DOT__core__DOT__mem__DOT__ram__DOT__store[2] = 0x00;
    dut->cpu__DOT__core__DOT__mem__DOT__ram__DOT__store[3] = 0x01;
    dut->cpu__DOT__core__DOT__mem__DOT__ram__DOT__store[4] = 0x55;
    dut->cpu__DOT__core__DOT__mem__DOT__ram__DOT__store[5] = 0x02;
    dut->cpu__DOT__core__DOT__mem__DOT__ram__DOT__store[6] = 0xAA;
    dut->cpu__DOT__core__DOT__mem__DOT__ram__DOT__store[7] = 0x13;
    dut->cpu__DOT__core__DOT__mem__DOT__ram__DOT__store[8] = 0x18;
    dut->cpu__DOT__core__DOT__mem__DOT__ram__DOT__store[9] = 0x27;
    dut->cpu__DOT__core__DOT__mem__DOT__ram__DOT__store[10] = 0x01;
    dut->cpu__DOT__core__DOT__mem__DOT__ram__DOT__store[11] = 0x13;
    dut->cpu__DOT__core__DOT__mem__DOT__ram__DOT__store[12] = 0x02;
    dut->cpu__DOT__core__DOT__mem__DOT__ram__DOT__store[13] = 0x08;
    dut->cpu__DOT__core__DOT__mem__DOT__ram__DOT__store[14] = 0x88;
    dut->cpu__DOT__core__DOT__mem__DOT__ram__DOT__store[15] = 0x4C;
    dut->cpu__DOT__core__DOT__mem__DOT__ram__DOT__store[16] = 0x45;
    dut->cpu__DOT__core__DOT__mem__DOT__ram__DOT__store[17] = 0x41;

    dut->cpu__DOT__core__DOT__mem__DOT__ram__DOT__store[18] = 0x00;
    dut->cpu__DOT__core__DOT__mem__DOT__ram__DOT__store[19] = 0x05;
    dut->cpu__DOT__core__DOT__mem__DOT__ram__DOT__store[20] = 0x03;
    dut->cpu__DOT__core__DOT__mem__DOT__ram__DOT__store[21] = 0x06;
    dut->cpu__DOT__core__DOT__mem__DOT__ram__DOT__store[22] = 0x00;
    dut->cpu__DOT__core__DOT__mem__DOT__ram__DOT__store[23] = 0x5F;
    dut->cpu__DOT__core__DOT__mem__DOT__ram__DOT__store[24] = 0x60;
    dut->cpu__DOT__core__DOT__mem__DOT__ram__DOT__store[25] = 0x00;

    test_init();
    reset_cpu();

    for(int i = 0; i < 300; i++) {
        test_step_clk(0);
        test_step_clk(1);
    }
}
int main(int argc, char** argv, char** env) {
    Verilated::commandArgs(argc, argv);
    Verilated::traceEverOn(true);
    dut->trace(m_trace, 5);
    m_trace->open("cpu_tb.vcd");

    test_init();
    test_step_clk(0);

    // test_simple();
    test_mem_reg_bus_alu();

    // test_control(0x00);
    // test_control(0x01);

    for (int i = 0; i < 5; i++) {
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

