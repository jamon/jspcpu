#include <stdlib.h>
#include <bitset>
#include <iostream>
#include <verilated.h>
#include <verilated_vcd_c.h>
#include "Vcore.h"

#define FLAG_OVERFLOW 1
#define FLAG_SIGN 1<<1
#define FLAG_ZERO 1<<2
#define FLAG_CARRYA 1<<3
#define FLAG_CARRYL 1<<4
#define FLAG_PCRAFLIP 1<<5


#define ALU_OP_NOOP 0x0
#define ALU_OP_SHL  0x1
#define ALU_OP_SHR  0x2
#define ALU_OP_ADD  0x3
#define ALU_OP_ADDC 0x4
#define ALU_OP_INC  0x5
#define ALU_OP_INCC 0x6
#define ALU_OP_SUB  0x7
#define ALU_OP_SUBB 0x8
#define ALU_OP_DEC  0x9
#define ALU_OP_AND  0xA
#define ALU_OP_OR   0xB
#define ALU_OP_XOR  0xC
#define ALU_OP_NOT  0xD
#define ALU_OP_CLC  0xE
#define ALU_OP_UNUSED 0xF


// #define MAX_SIM_TIME 20
vluint64_t sim_time = 0;
Vcore *dut = new Vcore;
VerilatedVcdC *m_trace = new VerilatedVcdC;


void test_step() {
    // dut->clk ^= 1;
    dut->eval();
    m_trace->dump(sim_time);
    sim_time++;
}

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

    dut->const_assert_main = 1;
    dut->const_load_mem = 1;

    dut->mem_assert_main = 1;
    dut->mem_load_main = 1;

    dut->alu_assert_main = 1;

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
            << " simtime: " << std::dec << sim_time << std::endl;
    dut->clk = 0;
    test_step();
    dut->test_xfer_en = 0;
    dut->xfer_load_xfer = 1;



    // xfer [0x5555] -> pcra0 
    dut->xfer_assert_xfer = 0;
    dut->pcra0_load_xfer = 0;
    dut->clk = 1;
    test_step();
    if(dut->core__DOT__pcra0__DOT__value != 0x5555) std::cerr << "ERROR: " << test_name
            << " xfer -> pcra0"
            << " expected pcra0 value = 0x5555 actual: " << std::hex << dut->core__DOT__pcra0__DOT__value
            << " simtime: " << std::dec << sim_time << std::endl;
    dut->clk = 0;
    test_step();        
    dut->xfer_assert_xfer = 1;
    dut->pcra0_load_xfer = 1;


    // pcra0 [0x5555]++
    dut->pcra0_inc = 0;
    dut->clk = 1;
    test_step();
    if(dut->core__DOT__pcra0__DOT__value != 0x5556) std::cerr << "ERROR: " << test_name
            << " pcra0++ "
            << " expected pcra0 value = 0x5556 actual: " << std::hex << dut->core__DOT__pcra0__DOT__value
            << " simtime: " << std::dec << sim_time << std::endl;
    dut->clk = 0;
    test_step();
    dut->pcra0_inc = 1;


    // check_result(test_name, expected, calc_flags, flags_expected_on, flags_expected_off);
}

void test_basic_alu() {
    const char* test_name = "test_basic_alu";
    test_init();

    // test [0x55] -> a
    dut->test_main_out = 0x55;
    dut->test_main_en = 1;
    dut->a_load_main = 0;
    test_step_clk(1);
    if(dut->core__DOT__a__DOT__value != 0x55) std::cerr << "ERROR: " << test_name
            << " a <= 0x55"
            << " expected a = 0x55 actual: " << std::hex << dut->core__DOT__a__DOT__value
            << " simtime: " << std::dec << sim_time << std::endl;
    test_step_clk(0);
    dut->test_main_en = 0;
    dut->a_load_main = 1;

    // test [0x06] -> b
    dut->test_main_out = 0x06;
    dut->test_main_en = 1;
    dut->b_load_main = 0;
    test_step_clk(1);
    if(dut->core__DOT__b__DOT__value != 0x06) std::cerr << "ERROR: " << test_name
            << " a <= 0x06"
            << " expected a = 0x06 actual: " << std::hex << dut->core__DOT__b__DOT__value
            << " simtime: " << std::dec << sim_time << std::endl;
    test_step_clk(0);
    dut->test_main_en = 0;
    dut->b_load_main = 1;

    dut->alu_operation = ALU_OP_ADD;
    dut->a_assert_lhs = 0;
    dut->b_assert_rhs = 0;
    test_step_clk(1);
    if(dut->core__DOT__alu__DOT__result != 0x05B) std::cerr << "ERROR: " << test_name
            << " a + b (alu.result)"
            << " expected a = 0x05B actual: " << std::hex << dut->core__DOT__alu__DOT__result
            << " simtime: " << std::dec << sim_time << std::endl;
    test_step_clk(0);
    dut->alu_operation = ALU_OP_NOOP;
    dut->alu_assert_main = 1;
    dut->b_assert_rhs = 0;

    dut->alu_assert_main = 0;
    dut->c_load_main = 0;
    test_step_clk(1);
    if(dut->core__DOT__c__DOT__value != 0x5B) std::cerr << "ERROR: " << test_name
            << " c <= a + b"
            << " expected a = 0x5B actual: " << std::hex << dut->core__DOT__c__DOT__value
            << " simtime: " << std::dec << sim_time << std::endl;
    test_step_clk(0);
    dut->c_load_main = 1;
    dut->a_assert_lhs = 0;

}


void test_basic_mem() {
    const char* test_name = "test_basic_mem";
    test_init();

    // [0x5555] <= 0x55
    dut->test_addr_out = 0x5555;
    dut->test_addr_en = 1;
    dut->test_main_out = 0x55;
    dut->test_main_en = 1;
    dut->mem_dir = 0;
    dut->mem_load_main = 0;
    test_step_clk(0);

    test_step_clk(1);
    // if(dut->xfer_out != 0x5555) std::cerr << "ERROR: " << test_name
    //         << " expected xfer_out = 0x5555 actual: " << std::hex << dut->xfer_out
    //         << " simtime: " << std::dec << sim_time << std::endl;
    dut->mem_dir = 1;
    dut->mem_load_main = 1;
    // dut->test_addr_en = 0;
    dut->test_main_en = 0;

    dut->mem_assert_main = 0;
    test_step_clk(0);

    test_step_clk(1);
    if(dut->main_out != 0x55) std::cerr << "ERROR: " << test_name
            << " [0x5555] == 0x55"
            << " expected main_out = 0x55 actual: 0x" << std::hex << (int)(dut->main_out)
            << " simtime: " << std::dec << sim_time << std::endl;
    // std::cout << "[0x5555] = " << std::hex << (int)(dut->core__DOT__mem__DOT__memory[0x5555]) << std::endl;
    dut->mem_assert_main = 1;
    test_step_clk(0);
}

void lda_imm(unsigned char imm) {
    dut->test_main_out = imm;
    dut->test_main_en = 1;
    dut->a_load_main = 0;
    test_step_clk(0);
    test_step_clk(1);
    dut->test_main_en = 0;
    dut->a_load_main = 1;
    std::cout << " lda_imm(" << std::hex << (int)imm << ") simtime: " << std::dec << sim_time << std::endl;
} 
void ldb_imm(unsigned char imm) {
    dut->test_main_out = imm;
    dut->test_main_en = 1;
    dut->b_load_main = 0;
    test_step_clk(0);
    test_step_clk(1);
    dut->test_main_en = 0;
    dut->b_load_main = 1;
    std::cout << " ldb_imm(" << std::hex << (int)imm << ") simtime: " << std::dec << sim_time << std::endl;
} 

void mov_xferlow_a() {
    dut->xfer_loadlow_main = 0;
    dut->a_assert_main = 0;
    test_step_clk(0);
    test_step_clk(1);
    dut->xfer_loadlow_main = 1;
    dut->a_assert_main = 1;
    std::cout << " mov_xferlow_a() simtime: " << std::dec << sim_time << std::endl;
}
void mov_xferhigh_a() {
    dut->xfer_loadhigh_main = 0;
    dut->a_assert_main = 0;
    test_step_clk(0);
    test_step_clk(1);
    dut->xfer_loadhigh_main = 1;
    dut->a_assert_main = 1;
    std::cout << " mov_xferhigh_a() simtime: " << std::dec << sim_time << std::endl;
}
void mov_xferlow_b() {
    dut->xfer_loadlow_main = 0;
    dut->b_assert_main = 0;
    test_step_clk(0);
    test_step_clk(1);
    dut->xfer_loadlow_main = 1;
    dut->b_assert_main = 1;
    std::cout << " mov_xferlow_b() simtime: " << std::dec << sim_time << std::endl;
}
void mov_xferhigh_b() {
    dut->xfer_loadhigh_main = 0;
    dut->b_assert_main = 0;
    test_step_clk(0);
    test_step_clk(1);
    dut->xfer_loadhigh_main = 1;
    dut->b_assert_main = 1;
    std::cout << " mov_xferhigh_b() simtime: " << std::dec << sim_time << std::endl;
}

void mov_si_xfer() {
    dut->xfer_assert_xfer = 0;
    dut->si_load_xfer = 0;
    test_step_clk(0);
    test_step_clk(1);
    dut->xfer_assert_xfer = 1;
    dut->si_load_xfer = 1;    
    std::cout << " mov_si_xfer() simtime: " << std::dec << sim_time << std::endl;
}
void lda_ind_si() {
    dut->si_assert_addr = 0;
    dut->mem_assert_main = 0;
    dut->mem_dir = 1;
    dut->a_load_main = 0;
    test_step_clk(0);
    test_step_clk(1);
    dut->si_assert_addr = 1;
    dut->mem_assert_main = 1;
    dut->mem_dir = 0;
    dut->a_load_main = 1;    
    std::cout << " lda_ind_si() simtime: " << std::dec << sim_time << std::endl;
}
void sta_ind_si() {
    dut->si_assert_addr = 0;
    dut->mem_load_main = 0;
    dut->mem_dir = 0;
    dut->a_assert_main = 0;
    test_step_clk(0);
    test_step_clk(1);
    dut->si_assert_addr = 1;
    dut->mem_load_main = 1;
    dut->a_assert_main = 1;    
    std::cout << " sta_ind_si() simtime: " << std::dec << sim_time << std::endl;
}
void ldb_ind_si() {
    dut->si_assert_addr = 0;
    dut->mem_assert_main = 0;
    dut->mem_dir = 1;
    dut->b_load_main = 0;
    test_step_clk(0);
    test_step_clk(1);
    dut->si_assert_addr = 1;
    dut->mem_assert_main = 1;
    dut->mem_dir = 0;
    dut->b_load_main = 1;    
    std::cout << " ldb_ind_si() simtime: " << std::dec << sim_time << std::endl;
}
void stb_ind_si() {
    dut->si_assert_addr = 0;
    dut->mem_load_main = 0;
    dut->mem_dir = 0;
    dut->b_assert_main = 0;
    test_step_clk(0);
    test_step_clk(1);
    dut->si_assert_addr = 1;
    dut->mem_load_main = 1;
    dut->b_assert_main = 1;    
    std::cout << " stb_ind_si() simtime: " << std::dec << sim_time << std::endl;
}

void ldb_ind_di() {
    dut->di_assert_addr = 0;
    dut->mem_assert_main = 0;
    dut->mem_dir = 1;
    dut->b_load_main = 0;
    test_step_clk(0);
    test_step_clk(1);
    dut->di_assert_addr = 1;
    dut->mem_assert_main = 1;
    dut->mem_dir = 0;
    dut->b_load_main = 1;    
    std::cout << " ldb_ind_di() simtime: " << std::dec << sim_time << std::endl;
}
void add_a_b() {
    dut->alu_operation = ALU_OP_ADD;
    dut->a_assert_lhs = 0;
    dut->b_assert_rhs = 0;
    test_step_clk(0);
    test_step_clk(1);
    dut->a_assert_lhs = 0;
    dut->b_assert_rhs = 0;
    std::cout << " add_a_b() [0] simtime: " << std::dec << sim_time << std::endl;

    dut->alu_assert_main = 0;
    dut->a_load_main = 0;
    test_step_clk(0);
    test_step_clk(1);
    dut->a_load_main = 1;  
    dut->alu_assert_main = 1;
    std::cout << " add_a_b() [1] simtime: " << std::dec << sim_time << std::endl;

}
void test_mem_reg_bus_alu() {
    const char* test_name = "test_mem_reg_bus_alu";
    test_init();

    lda_imm(0x55);
    ldb_imm(0xAA);

    mov_xferlow_a();
    mov_xferhigh_b();

    mov_si_xfer();

    lda_imm(0x13);
    ldb_imm(0x08);

    add_a_b();

    sta_ind_si();

    ldb_ind_di();

    ldb_ind_si();
}
int main(int argc, char** argv, char** env) {
    Verilated::commandArgs(argc, argv);
    Verilated::traceEverOn(true);
    dut->trace(m_trace, 5);
    m_trace->open("core_tb.vcd");

    test_init();
    test_step();

    // test_basic_bus_register(); 
    // test_basic_alu();
    // test_basic_mem();
    test_mem_reg_bus_alu();

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

