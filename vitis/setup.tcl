# run at linux command line 
#       xsct setup.tcl
#       vitis --workspace ./workspace
#
file delete -force ./workspace

set hw ../implement/results/top.xsa
set proc "microblaze_0"

setws ./workspace

platform create -name "standalone_plat" -hw $hw -proc $proc -os standalone
bsp config stdout "usb_uartlite"
bsp config stdin  "usb_uartlite"

app create -name hello1 -platform standalone_plat -domain standalone_domain -template "Empty Application(C)"
file link -symbolic ./workspace/hello1/src/test.c               ../../../src/hello1/test.c
file link -symbolic ./workspace/hello1/src/platform.c           ../../../src/hello1/platform.c
file link -symbolic ./workspace/hello1/src/platform.h           ../../../src/hello1/platform.h
file link -symbolic ./workspace/hello1/src/platform_config.h    ../../../src/hello1/platform_config.h
file link -symbolic ./workspace/hello1/src/axi_iic.h               ../../../src/axi_iic.h

app build all

