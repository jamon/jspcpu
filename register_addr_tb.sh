# test bus
cd build
iverilog -o register_addr_tb.out -D VCD_OUTPUT=bus_tb -D NO_INCLUDES /home/jamon/.apio/packages/toolchain-yosys/share/yosys/ecp5/cells_sim.v ../register_addr.v ../register_addr_tb.v
vvp register_addr_tb.out
gtkwave register_addr_tb.vcd register_addr_tb.gtkw
