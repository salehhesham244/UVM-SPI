interface FIFO_if (clk);
    
    parameter WIDTH=16;
    
    input bit clk;
    bit [WIDTH-1:0] data_in,data_out;
    bit rst_n,wr_en,rd_en,wr_ack,overflow,
            underflow,full,empty,almostempty
            ,almostfull;

    modport DUT (
    input clk,data_in,rst_n,wr_en,rd_en,
    output data_out,wr_ack,overflow,
            underflow,full,empty,almostempty
            ,almostfull
    );        

    modport test (
    input data_out,wr_ack,overflow,
            underflow,full,empty,almostempty
            ,almostfull,
    output clk,data_in,rst_n,wr_en,rd_en
    );

    modport MONITOR (
    input clk,data_in,rst_n,wr_en,rd_en,data_out,wr_ack,overflow,
            underflow,full,empty,almostempty
            ,almostfull
    );

endinterface //FIFO_if

