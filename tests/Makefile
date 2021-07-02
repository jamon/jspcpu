MODULE=tests
VERILATOR_BIN=verilator_bin

.PHONY:sim
sim: ${MODULE}_tb.vcd
	@./obj_dir/V$(MODULE)
	
.PHONY:verilate
verilate: .stamp.verilate

.PHONY:build
build: obj_dir/Valu

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
	$(VERILATOR_BIN) -Wall --trace -cc $(MODULE).v --exe $(MODULE)_tb.cpp
	@touch .stamp.verilate

.PHONY:lint
lint: $(MODULE).v
	$(VERILATOR_BIN) --lint-only $(MODULE).v

.PHONY: clean
clean:
	rm -rf .stamp.*;
	rm -rf ./obj_dir
	rm -rf ${MODULE}_tb.vcd
	rm -f ${MODULE}.out

.PHONY: iverilog
iverilog:
	iverilog -grelative-include -g2012 -o ${MODULE}.out -D VCD_OUTPUT=${MODULE} ${MODULE}_tb.sv
	vvp ${MODULE}.out
