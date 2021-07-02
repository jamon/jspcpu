#include <stdlib.h>
#include <bitset>
#include <iostream>
#include <verilated.h>
#include <verilated_vcd_c.h>
#include "Vtests.h"

#define FLAG_OVERFLOW 1
#define FLAG_SIGN 1<<1
#define FLAG_ZERO 1<<2
#define FLAG_CARRYA 1<<3
#define FLAG_CARRYL 1<<4
#define FLAG_PCRAFLIP 1<<5

// #define MAX_SIM_TIME 20
vluint64_t sim_time = 0;
Vtests *dut = new Vtests;
VerilatedVcdC *m_trace = new VerilatedVcdC;


void test_step() {
    // dut->clk ^= 1;
    dut->eval();
    m_trace->dump(sim_time);
    sim_time++;
}

void test_step_clk() {
    test_step();
    dut->clk = 1;
    test_step();
    dut->clk = 0;
}

void test_init() {
    dut->clk = 0;
    dut->reset = 1;

    dut->a_assert_main = 1;
    dut->a_load_main = 1;
    dut->a_assert_lhs = 1;
    dut->a_assert_rhs = 1;

    dut->b_assert_main = 1;
    dut->b_load_main = 1;
    dut->b_assert_lhs = 1;
    dut->b_assert_rhs = 1;

    dut->c_assert_main = 1;
    dut->c_load_main = 1;
    dut->c_assert_lhs = 1;
    dut->c_assert_rhs = 1;

    dut->d_assert_main = 1;
    dut->d_load_main = 1;
    dut->d_assert_lhs = 1;
    dut->d_assert_rhs = 1;
        

    dut->pcra0_assert_addr = 1;
    dut->pcra0_assert_xfer = 1;
    dut->pcra0_load_xfer = 1;
    dut->pcra0_inc = 1;
    dut->pcra0_dec = 1;

    dut->pcra1_assert_addr = 1;
    dut->pcra1_assert_xfer = 1;
    dut->pcra1_load_xfer = 1;
    dut->pcra1_inc = 1;
    dut->pcra1_dec = 1;

    dut->sp_assert_addr = 1;
    dut->sp_assert_xfer = 1;
    dut->sp_load_xfer = 1;
    dut->sp_inc = 1;
    dut->sp_dec = 1;

    dut->si_assert_addr = 1;
    dut->si_assert_xfer = 1;
    dut->si_load_xfer = 1;
    dut->si_inc = 1;
    dut->si_dec = 1;

    dut->di_assert_addr = 1;
    dut->di_assert_xfer = 1;
    dut->di_load_xfer = 1;
    dut->di_inc = 1;
    dut->di_dec = 1;

    dut->xfer_assert_addr = 1;
    dut->xfer_assert_xfer = 1;
    dut->xfer_load_xfer = 1;
    dut->xfer_asserthigh_main = 1;
    dut->xfer_loadhigh_main = 1;
    dut->xfer_assertlow_main = 1;
    dut->xfer_loadlow_main = 1;

    dut->test_addr_en = 0;
    dut->test_xfer_en = 0;
    dut->test_main_en = 0;

    dut->test_addr_out = 0;
    dut->test_xfer_out = 0;
    dut->test_main_out = 0;
}


void test_basic_bus_register() {
    const char* test_name = "test_basic_bus_register";
    test_init();

    // test [0x5555] -> xfer
    dut->test_xfer_out = 0x5555;
    dut->test_xfer_en = 1;
    dut->xfer_load_xfer = 0;
    dut->clk = 1;
    test_step();
    if(dut->xfer_out != 0x5555) std::cerr << "ERROR: " << test_name
            << " expected xfer_out = 0x5555 actual: " << std::hex << dut->xfer_out
            << " simtime: " << sim_time << std::endl;
    dut->clk = 0;
    test_step();
    dut->test_xfer_en = 0;
    dut->xfer_load_xfer = 1;



    // xfer [0x5555] -> pcra0 
    dut->xfer_assert_xfer = 0;
    dut->pcra0_load_xfer = 0;
    dut->clk = 1;
    test_step();
    if(dut->tests__DOT__pcra0__DOT__value != 0x5555) std::cerr << "ERROR: " << test_name
            << " xfer -> pcra0"
            << " expected pcra0 value = 0x5555 actual: " << std::hex << dut->tests__DOT__pcra0__DOT__value
            << " simtime: " << sim_time << std::endl;
    dut->clk = 0;
    test_step();        
    dut->xfer_assert_xfer = 1;
    dut->pcra0_load_xfer = 1;


    // pcra0 [0x5555]++
    dut->pcra0_inc = 0;
    dut->clk = 1;
    test_step();
    if(dut->tests__DOT__pcra0__DOT__value != 0x5556) std::cerr << "ERROR: " << test_name
            << " pcra0++ "
            << " expected pcra0 value = 0x5556 actual: " << std::hex << dut->tests__DOT__pcra0__DOT__value
            << " simtime: " << sim_time << std::endl;
    dut->clk = 0;
    test_step();
    dut->pcra0_inc = 1;


    // check_result(test_name, expected, calc_flags, flags_expected_on, flags_expected_off);
}

int main(int argc, char** argv, char** env) {
    Verilated::commandArgs(argc, argv);
    Verilated::traceEverOn(true);
    dut->trace(m_trace, 5);
    m_trace->open("tests_tb.vcd");

    test_init();
    test_step();

    test_basic_bus_register(); 

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

