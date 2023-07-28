//
module iic_core (
    input   logic           clk,
    input   logic           reset,
    //
    input   logic           tx_fifo_wr,
    input   logic[7:0]      tx_fifo_din,
    output  logic           tx_fifo_full,
    output  logic           tx_fifo_empty,
    input   logic           rx_fifo_rd,
    output  logic           rx_fifo_dout,
    output  logic           rx_fifo_full,
    output  logic           rx_fifo_empty,
    output  logic           idle,
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
    localparam real Fiic = 1.0e6; //100.0e3;
    localparam int Ndiv = Fclk/Fiic;
    localparam logic[3:0] Nhold = 10-1; // clocks between fall of scl and change of sda
    
    // tx fifo
    logic[7:0] tx_fifo_dout;
    logic tx_fifo_rd;
    xpm_sync_fifo #(.W(8), .D(16)) tx_fifo_inst (.clk(clk), .srst(reset), .din(tx_fifo_din), .wr_en(tx_fifo_wr), .full(tx_fifo_full), .dout(tx_fifo_dout), .rd_en(tx_fifo_rd), .empty(tx_fifo_empty)); 
    
   
    // rx fifo
    logic[7:0] rx_fifo_din;
    logic rx_fifo_wr;
    xpm_sync_fifo #(.W(8), .D(16)) rx_fifo_inst (.clk(clk), .srst(reset), .din(rx_fifo_din), .wr_en(rx_fifo_wr), .full(rx_fifo_full), .dout(rx_fifo_dout), .rd_en(rx_fifo_rd), .empty(rx_fifo_empty));
    
    
    logic[3:0] state=0, next_state;         
    logic tx_nack_term;
    logic[15:0] delcount;
    logic[3:0] bitcount;
    logic bitcount_clr, bitcount_inc;
    logic delcount_clr, delcount_inc;
    logic sda_t_pre;
    always_comb begin
    
        // defaults
        next_state = state;
        tx_fifo_rd = 0;
        tx_nack_term = 0;
        bitcount_clr = 0;
        bitcount_inc = 0;
        delcount_clr = 0;
        delcount_inc = 0;
        scl_t = 1;
        sda_t_pre = 1;
        idle = 0;
        
        // state logic
        case (state)
        
            0: begin
                next_state = 1;
            end
            
            // wait for fifo
            1: begin
                delcount_clr = 1;
                if (~tx_fifo_empty) begin
                    next_state = 2;
                end else begin
                    idle = 1;
                end
            end
            
            // simple delay
            2: begin
                delcount_inc = 1;
                bitcount_clr = 1;
                if (delcount==(Ndiv*2-1)) begin
                    delcount_clr = 1;
                    next_state = 3;
                end
            end            
            
            // start symbol
            3: begin
                sda_t_pre = 0;
                delcount_inc = 1;
                bitcount_clr = 1;
                if (delcount==(Ndiv-1)) begin
                    delcount_clr = 1;
                    next_state = 5;
                end
            end            
            
                        
            // loop over the 8 bits.                        
            5: begin
                sda_t_pre = tx_fifo_dout[7-bitcount];
                scl_t = 0;
                delcount_inc = 1;
                if (delcount==(Ndiv-1)) begin
                    delcount_clr = 1;
                    next_state = 6;
                end
            end
            
            
            6: begin
                sda_t_pre = tx_fifo_dout[7-bitcount];
                delcount_inc = 1;
                if (delcount==(Ndiv-1)) begin
                    delcount_clr = 1;
                    bitcount_inc = 1;
                    if (bitcount==7) begin
                        next_state = 8;
                    end else begin
                        next_state = 5;
                    end
                end
            end            
            
            // ack window
            8: begin
                scl_t = 0;
                delcount_inc = 1;
                if (delcount==(Ndiv-1)) begin
                    delcount_clr = 1;
                    next_state = 9;
                end
            end
            
            9: begin
                delcount_inc = 1;
                bitcount_clr = 1;
                if (delcount==(Ndiv-1)) begin
                    tx_fifo_rd = 1;
                    delcount_clr = 1;
                    next_state = 10;
                end
            end            
                     
                                             
            10:begin
                delcount_clr = 1;
                if (tx_fifo_empty) begin
                    next_state = 11;
                end else begin
                    next_state = 5;
                end
            end
            
            // stop symbol
            11: begin
                scl_t = 0;
                sda_t_pre = 0;
                delcount_inc = 1;
                if (delcount==(Ndiv-1)) begin
                    delcount_clr = 1;
                    next_state = 12;
                end
            end

            12: begin
                delcount_inc = 1;
                sda_t_pre = 0;
                if (delcount==(Ndiv-1)) begin
                    delcount_clr = 1;
                    next_state = 0;
                end
            end            
            
            default: begin
                next_state = 0;
            end
            
        endcase
    end
    
    always_ff @(posedge clk) state <= next_state;
    

    always_ff @(posedge clk) begin
        if (delcount_clr) begin
            delcount <= 0;
        end else begin
            if (delcount_inc) begin
                delcount <= delcount + 1;
            end
        end
    end
        
    always_ff @(posedge clk) begin
        if (bitcount_clr) begin
            bitcount <= 0;
        end else begin
            if (bitcount_inc) begin
                bitcount <= bitcount + 1;
            end
        end
    end
    
    // delay sda_t to give some hold time relative to scl_t
    SRL16E #(.INIT(16'hffff)) srl_inst (.D(sda_t_pre), .Q(sda_t), .A3(Nhold[3]), .A2(Nhold[2]), .A1(Nhold[1]), .A0(Nhold[0]), .CE(), .CLK(clk));
        

endmodule

/*
*/
