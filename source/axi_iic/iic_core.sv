
module iic_core (
    input   logic           clk,
    input   logic           reset,
    input   logic[31:0]     control,
    output  logic[31:0]     status,
    input   logic           tx_fifo_wr,
    input   logic[7:0]      tx_fifo_din,
    input   logic           rx_fifo_rd,
    output  logic           rx_fifo_dout
);

endmodule

/*
	iic_core iic_core_inst (
	   .clk(S_AXI_ACLK),
	   .reset(iic_reset),
	   .control(iic_control),
	   .status(iic_status),
	   .tx_fifo_wr(tx_fifo_wr),
	   .tx_fifo_din(tx_fifo_din),
	   .rx_fifo_rd(rx_fifo_rd),
	   .rx_fifo_dout(rx_fifo_dout)
	);
*/
