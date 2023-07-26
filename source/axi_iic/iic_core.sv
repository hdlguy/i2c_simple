//
module iic_core (
    input   logic           clk,
    input   logic           reset,
    input   logic[31:0]     control,
    output  logic[31:0]     status,
    //
    input   logic           tx_fifo_wr,
    input   logic[7:0]      tx_fifo_din,
    output  logic           tx_fifo_full,
    output  logic           tx_fifo_empty,
    input   logic           rx_fifo_rd,
    output  logic           rx_fifo_dout,
    output  logic           rx_fifo_full,
    output  logic           rx_fifo_empty,
    //
    input   logic           scl_i,
    output  logic           scl_o,
    output  logic           scl_t,
    input   logic           sda_i,
    output  logic           sda_o,
    output  logic           sda_t    
);

    assign scl_o = 0;
    assign sda_o = 0;
    
    localparam real Fclk = 100.0e6;
    localparam real Fiic = 100.0e3;
    localparam int Ndiv = Fclk/Fiic;
    
    // tx fifo
    logic[7:0] tx_fifo_dout;
    logic tx_fifo_rd;
    xpm_sync_fifo #(.W(8), .D(16)) tx_fifo_inst (
        .clk(clk), .srst(reset), 
        .din(tx_fifo_din), .wr_en(tx_fifo_wr), .full(tx_fifo_full),
        .dout(tx_fifo_dout), .rd_en(tx_fifo_rd), .empty(tx_fifo_empty)
    ); 
   
    // rx fifo
    logic[7:0] rx_fifo_din;
    logic rx_fifo_wr;
    xpm_sync_fifo #(.W(8), .D(16)) rx_fifo_inst (
        .clk(clk), .srst(reset), 
        .din(rx_fifo_din), .wr_en(rx_fifo_wr), .full(rx_fifo_full),
        .dout(rx_fifo_dout), .rd_en(rx_fifo_rd), .empty(rx_fifo_empty)
    );         

endmodule

/*
module xpm_sync_fifo #(
    parameter int W = 16,  // width
    parameter int D = 64   // depth
) (
    input   logic           clk,
    input   logic           srst,
    input   logic[W-1:0]    din,
    input   logic           wr_en,
    output  logic           full,
        
    input   logic           rd_en,
    output  logic[W-1:0]    dout,
    output  logic           empty
);
*/
