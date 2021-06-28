# jspcpu
This is a Verilog implementation of the 8-bit Pipeline CPU designed by James Sharman ([see youtube series](https://www.youtube.com/playlist?list=PLFhc0MFC8MiCDOh3cGFji3qQfXziB9yOw)).

The design / layout of the modules intentionally sacrifices performance and even simplicity in some cases in order to more closely follow the modularity of the original CPU design.  This is intended as a tool to learn and play with the CPU design, and to assist with designing and building hardware and software which is compatible with the original CPU design.

**Work in Progress**

Most of the base modules are completed, and have been tested indinvidually to various degrees (some have automated tests, some have just been manually verified).  The tests directory has the beginnings of an integrated test of a few components.

Pipeline Stage 0 and the Bus Control logic are not yet built, and the modules have not yet been all connected together for a full test.

## instructions

### iverilog / gtkw - simulation
* run "test.sh" in any module directory to simulate and launch gtkw.

### hardware FPGA - for ecp5 (ulx3s fpga)
* update build.env to provide the correct path to trellis/yosys to build hardware
* run "flash.sh" to build and flash a particular module  (note that currently only a small bus test in the bus directory is flashable)

## running on windows

### Installation
* Install python3 and pip
* Install apio: `pip install -U apio`
* Install all apio tools: `apio install -a -p windows_amd64`
* Install latest icarus verilog manually from: http://bleyer.org/icarus/ (top one in the list)
* Add all apio tools' bin directories to your user's path
    * hit your windows key, search for "env", select "edit environment variables for your account"
    * double click "Path" in top list
    * repeat for each tool (except iverilog) directory: "new", paste the path tool the tool (e.g. c:\users\YOURUSERNAME\apio\tool-gtkwave\bin)
    * add the iverilog bin directory to your path (default C:\iverilog\bin)
    * hit okay (Be sure to re-launch your shell before trying to use them)

These steps will work on cygwin (or git bash) or powershell--but the scripts to automatically build/run only support cygwin/git bash/linux/wsl--and will not work for powershell.  That said, if you run a .sh file from powershell it will launch via cygwin/git bash if you have it installed, and should work fine.

## Manual steps / issues
* any verilog files that read from .mem files has to be updated manually with the correct path--I'm likely doing something stupid with how I'm including them--if you know how to fix this, please let me know
* for the prebuilt .gtkw files in the build directory you'll need to find/replace the paths to the filter files (.txt files)
* support for windows is lacking (due to using .sh files for everything)--it works, but it is a little clunkier
* some of my module.env files and test scripts are not up to date (older modules haven't been updated yet)
* it may be necessary to manually specify your PROJECT_PATH, IVERILOG_CELLS, and TRELLIS_DB in build.env
* for verilator to work, make sure to set env variable VERILATOR_ROOT to the correct value (likely c:\\msys64\\mingw64\\share\\verilator)
