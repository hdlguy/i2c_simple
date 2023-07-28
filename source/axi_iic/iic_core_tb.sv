`timescale 1ns / 1ps

module iic_core_tb();

    logic           reset;
    logic           tx_fifo_wr;
    logic[7:0]      tx_fifo_din;
    logic           tx_fifo_full;
    logic           tx_fifo_empty;
    logic           rx_fifo_rd;
    logic           rx_fifo_dout;
    logic           rx_fifo_full;
    logic           rx_fifo_empty;
    logic           idle;
    logic           scl_i;
    logic           scl_o;
    logic           scl_t;
    logic           sda_i;
    logic           sda_o;
    logic           sda_t;
    logic clk=0; localparam clk_period=10; always #(clk_period/2) clk = ~clk;

    iic_core uut (.*);

    logic[9:0][7:0] tx_buf = {8'h0f, 8'h0e, 8'h0d, 8'h0c, 8'h0b, 8'h0a, 8'h09, 8'ha8};

    localparam int Nsend = 8;

    initial begin
        reset = 1;
        tx_fifo_wr = 0;
        tx_fifo_din = 0;
        rx_fifo_rd = 0;
        #(clk_period*10);
        reset = 0;
        #(clk_period*10);
        for(int i=0; i<Nsend; i++) begin
            tx_fifo_wr = 1;
            tx_fifo_din = tx_buf[i];
            #(clk_period*1);
            tx_fifo_wr = 0;
            #(clk_period*10);
        end
    end

    tri1 scl, sda;  
    assign scl = (scl_t) ? 1'bz : scl_o;
    assign sda = (sda_t) ? 1'bz : sda_o;
    assign scl_i = scl;
    assign sda_i = sda;


endmodule



/*

*/
