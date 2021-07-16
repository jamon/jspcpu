MODULE=cpu
VERILATOR_BIN=verilator_bin
IVERILOG_CELLS=C:/Users/ms/.apio/packages/toolchain-yosys/share/yosys/ecp5/cells_sim.v
TRELLIS_DB=C:/Users/ms/.apio/packages/toolchain-ecp5/share/trellis/database
LPF_PATH="./ulx3s.lpf"
TOP_MODULE=top

.PHONY:sim
sim: ${MODULE}_tb.vcd
	@./obj_dir/V$(MODULE)
	
.PHONY:verilate
verilate: .stamp.verilate

.PHONY:build
build: obj_dir/V${MODULE}

.PHONY:waves
waves: ${MODULE}_tb.gtkw
	@echo
	@echo "### WAVES ###"
	gtkwave ${MODULE}_tb.gtkw

${MODULE}_tb.vcd: ./obj_dir/V$(MODULE)
	@echo
	@echo "### SIMULATING ###"


./obj_dir/V$(MODULE): .stamp.verilate
	@echo
	@echo "### BUILDING SIM ###"
	make -C obj_dir -f V$(MODULE).mk V$(MODULE)

.stamp.verilate: $(MODULE).v $(MODULE)_tb.cpp
	@echo
	@echo "### VERILATING ###"
	$(VERILATOR_BIN) -Wall -Wno-DECLFILENAME --relative-includes --trace -cc $(MODULE).v --exe $(MODULE)_tb.cpp
	@touch .stamp.verilate

.PHONY:lint
lint: $(MODULE).v
	$(VERILATOR_BIN) --relative-includes --lint-only $(MODULE).v

.PHONY: clean
clean:
	rm -rf .stamp.*;
	rm -rf ./obj_dir
	rm -rf ${MODULE}_tb.vcd
	rm -f ${MODULE}.out
	rm -f .stamp.pnr hardware.json hardware.bit hardware.config

.PHONY: iverilog
iverilog:
	iverilog -grelative-include -g2012 -o ${MODULE}.out -D VCD_OUTPUT=${MODULE} ${MODULE}_tb.sv
	vvp ${MODULE}.out

hardware.json: ${TOP_MODULE}.v
	@echo synthesize
	yosys -q -p "synth_ecp5 -json hardware.json" ${TOP_MODULE}.v

.PHONY: synthesize
synthesize: hardware.json

hardware.config: hardware.json
	@echo place-n-route
	nextpnr-ecp5 -v --85k --package CABGA381 --lpf ${LPF_PATH} --timing-allow-fail --json hardware.json --textcfg hardware.config
#	@touch .stamp.pnr

.PHONY: pnr
pnr: hardware.config

hardware.bit: hardware.config
	@echo packing
	ecppack --compress --db ${TRELLIS_DB} hardware.config hardware.bit

.PHONY: ecppack
ecppack: hardware.bit

.PHONY: flash
flash: hardware.bit
	@echo flashing...
	fujprog hardware.bit
	
# yosys -q -p "synth_ecp5 -json hardware.json" top.v
# nextpnr-ecp5 --85k --package CABGA381 --lpf ${LPF_PATH} --timing-allow-fail
# ecppack --compress --db ${TRELLIS_DB} hardware.config hardware.bit
