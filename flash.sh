cd build
yosys -p "synth_ecp5 -json hardware.json" -q ../top.v ../bus.v
nextpnr-ecp5 --85k --package CABGA381 --json hardware.json --textcfg hardware.config --lpf ../ulx3s.lpf --timing-allow-fail
ecppack --compress --db /home/jamon/.apio/packages/toolchain-ecp5/share/trellis/database hardware.config hardware.bit
fujprog hardware.bit