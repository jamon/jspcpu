source ../build.env
source ./module.env

# build/flash
#rm hardware.config hardware.json hardware.bit
# yosys ${YOSYS_OPT} -p "synth_ecp5 -json hardware.json" ${TOP_PATH} ${FILES_PATHS}
yosys ${YOSYS_OPT} -p "synth_ecp5 -json hardware.json" ${TOP_PATH}
nextpnr-ecp5 ${NEXTPNR_OPT} --json hardware.json --textcfg hardware.config
ecppack ${ECPPACK_OPT} hardware.config hardware.bit
fujprog ${FUJPROG_OPT} hardware.bit