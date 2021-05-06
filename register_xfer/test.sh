source ../build.env
source ./module.env

mkdir -p $MODULE_BUILD_PATH
cd $MODULE_BUILD_PATH
iverilog -g2012 -o ${OUT_NAME} -D VCD_OUTPUT=${MODULE_NAME} -D NO_INCLUDES ${IVERILOG_CELLS} ${FILES_PATHS} ${TB_PATH}
vvp ${OUT_NAME}
gtkwave ${VCD_NAME} ${GTKW_NAME}
