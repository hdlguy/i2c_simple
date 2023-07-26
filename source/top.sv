//
module arty_top (
    // oscillator 
    input   logic               clk100,  
    // console uart
    input   logic               usb_uart_rxd,
    output  logic               usb_uart_txd,
    // LEDs
    output  logic               led_blue,
    output  logic               led_green,
    output  logic               led_yellow,
    output  logic               led_red,    
    // I2C
    inout   logic               scl,        
    inout   logic               sda        
);


    logic [31:0]    M00_AXI_araddr;
    logic [2:0]     M00_AXI_arprot;
    logic [0:0]     M00_AXI_arready;
    logic [0:0]     M00_AXI_arvalid;
    logic [31:0]    M00_AXI_awaddr;
    logic [2:0]     M00_AXI_awprot;
    logic [0:0]     M00_AXI_awready;
    logic [0:0]     M00_AXI_awvalid;
    logic [0:0]     M00_AXI_bready;
    logic [1:0]     M00_AXI_bresp;
    logic [0:0]     M00_AXI_bvalid;
    logic [31:0]    M00_AXI_rdata;
    logic [0:0]     M00_AXI_rready;
    logic [1:0]     M00_AXI_rresp;
    logic [0:0]     M00_AXI_rvalid;
    logic [31:0]    M00_AXI_wdata;
    logic [0:0]     M00_AXI_wready;
    logic [3:0]     M00_AXI_wstrb;
    logic [0:0]     M00_AXI_wvalid;
    logic axi_aclk;
    logic [0:0]axi_aresetn;
    logic refclk;       
    
    logic iic_scl_i;
    logic iic_scl_o;
    logic iic_scl_t;
    logic iic_sda_i;
    logic iic_sda_o;
    logic iic_sda_t;
    logic[3:0] iic_gpo;
    logic clkout6;
    
    assign clkout100 = axi_aclk;
    
    // this is the IP Integrator block diagram.
    system system_i (                
        .reset(1'b1), // active low reset
        .clkin(clk100),
        .clkout6(clkout6),
        //
        .M00_AXI_araddr     (M00_AXI_araddr),
        .M00_AXI_arprot     (M00_AXI_arprot),
        .M00_AXI_arready    (M00_AXI_arready),
        .M00_AXI_arvalid    (M00_AXI_arvalid),
        .M00_AXI_awaddr     (M00_AXI_awaddr),
        .M00_AXI_awprot     (M00_AXI_awprot),
        .M00_AXI_awready    (M00_AXI_awready),
        .M00_AXI_awvalid    (M00_AXI_awvalid),
        .M00_AXI_bready     (M00_AXI_bready),
        .M00_AXI_bresp      (M00_AXI_bresp),
        .M00_AXI_bvalid     (M00_AXI_bvalid),
        .M00_AXI_rdata      (M00_AXI_rdata),
        .M00_AXI_rready     (M00_AXI_rready),
        .M00_AXI_rresp      (M00_AXI_rresp),
        .M00_AXI_rvalid     (M00_AXI_rvalid),
        .M00_AXI_wdata      (M00_AXI_wdata),
        .M00_AXI_wready     (M00_AXI_wready),
        .M00_AXI_wstrb      (M00_AXI_wstrb),
        .M00_AXI_wvalid     (M00_AXI_wvalid),
        .axi_aclk           (axi_aclk),
        .axi_aresetn        (axi_aresetn),  
        //
        .usb_uart_rxd       (usb_uart_rxd),
        .usb_uart_txd       (usb_uart_txd)               
    );
        
    IOBUF iic_scl_iobuf (.I(iic_scl_o), .IO(scl), .O(iic_scl_i), .T(iic_scl_t)); 
    IOBUF iic_sda_iobuf (.I(iic_sda_o), .IO(sda), .O(iic_sda_i), .T(iic_sda_t));      
    
    //iic_ila iic_ila_inst (.clk(clkout6), .probe0({iic_scl_i, iic_scl_t, iic_sda_i, iic_sda_t, iic_gpo})); // 8
    
	axi_iic axi_iic_inst (
        // iic interface
        .scl_i          (iic_scl_i),
        .scl_o          (iic_scl_o),
        .scl_t          (iic_scl_t),
        .sda_i          (iic_sda_i),
        .sda_o          (iic_sda_o),
        .sda_t          (iic_sda_t),
        .gpo            (iic_gpo),
        // axi interface
		.S_AXI_ACLK    (axi_aclk),
		.S_AXI_ARESETN (axi_aresetn),
		.S_AXI_ARADDR  (M00_AXI_araddr ),
		.S_AXI_ARPROT  (M00_AXI_arprot ),
		.S_AXI_ARREADY (M00_AXI_arready),
		.S_AXI_ARVALID (M00_AXI_arvalid),
		.S_AXI_AWADDR  (M00_AXI_awaddr ),
		.S_AXI_AWPROT  (M00_AXI_awprot ),
		.S_AXI_AWREADY (M00_AXI_awready),
		.S_AXI_AWVALID (M00_AXI_awvalid),
		.S_AXI_BREADY  (M00_AXI_bready ),
		.S_AXI_BRESP   (M00_AXI_bresp  ),
		.S_AXI_BVALID  (M00_AXI_bvalid ),
		.S_AXI_RDATA   (M00_AXI_rdata  ),
		.S_AXI_RREADY  (M00_AXI_rready ),
		.S_AXI_RRESP   (M00_AXI_rresp  ),
		.S_AXI_RVALID  (M00_AXI_rvalid ),
		.S_AXI_WDATA   (M00_AXI_wdata  ),
		.S_AXI_WREADY  (M00_AXI_wready ),
		.S_AXI_WSTRB   (M00_AXI_wstrb  ),
		.S_AXI_WVALID  (M00_AXI_wvalid )
	);
	
	assign led_blue    = iic_gpo[3];
	assign led_green   = iic_gpo[2];
	assign led_yellow  = iic_gpo[1];
	assign led_red     = iic_gpo[0];

endmodule

/*
    output  logic               led_blue,
    output  logic               led_green,
    output  logic               led_yellow,
    output  logic               led_red,    
*/



