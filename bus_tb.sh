# test bus
cd build
iverilog -o bus_tb.out -D VCD_OUTPUT=bus_tb -D NO_INCLUDES /home/jamon/.apio/packages/toolchain-yosys/share/yosys/ecp5/cells_sim.v ../bus.v ../bus_tb.v
vvp bus_tb.out
gtkwave bus_tb.vcd bus_tb.gtkw
