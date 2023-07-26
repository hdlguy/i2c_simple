#include "xparameters.h"
//#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"
#include "axi_iic.h"


int main()
{
    init_platform();

    print("hello\n\r");
    
    uint32_t *ptr = (uint32_t *)XPAR_M00_AXI_BASEADDR;

    xil_printf("AXI_IIC_ID = 0x%08x, AXI_IIC_VERSION = 0x%08x\n\r", ptr[AXI_IIC_ID], ptr[AXI_IIC_VERSION]);

    uint32_t whilecount=0;
    while(1){

    	ptr[AXI_IIC_GPO] = whilecount;

    	for(int i=0; i<5000000; i++);
    	whilecount++;

    }

    cleanup_platform();
    return 0;
}
