# jspcpu
This is a Verilog implementation of the 8-bit Pipeline CPU designed by James Sharman ([see youtube series](https://www.youtube.com/playlist?list=PLFhc0MFC8MiCDOh3cGFji3qQfXziB9yOw)).

** Work in Progress **
Most of the base modules are completed, and have been tested indinvidually to various degrees (some have automated tests, some have just been manually verified).  The tests directory has the beginnings of an integrated test of a few components.

Pipeline Stage 0 and the Bus Control logic are not yet built, and the modules have not yet been all connected together for a full test.

## instructions

### iverilog / gtkw - simulation
* run "test.sh" in any module directory to simulate and launch gtkw.

### hardware FPGA - for ecp5 (ulx3s fpga)
* update build.env to provide the correct path to trellis/yosys to build hardware
* run "flash.sh" to build and flash a particular module  (note that currently only a small bus test in the bus directory is flashable)

