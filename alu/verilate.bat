verilator_bin -Wall --trace --cc alu.v --exe tb_alu.cpp
make -C obj_dir -f Valu.mk Valu
.\obj_dir\Valu.exe