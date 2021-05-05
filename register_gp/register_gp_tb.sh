# test bus
cd build
iverilog -o register_gp_tb.out -D VCD_OUTPUT=bus_tb -D NO_INCLUDES /home/jamon/.apio/packages/toolchain-yosys/share/yosys/ecp5/cells_sim.v ../register_gp.v ../register_gp_tb.v
vvp register_gp_tb.out
gtkwave register_gp_tb.vcd register_gp_tb.gtkw
