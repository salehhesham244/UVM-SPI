package pack_one;
     
     localparam WIDTH=16;

    class FIFO_transaction;

       rand logic [WIDTH-1:0] data_in;
       rand logic rst_n;
       rand logic wr_en;
       rand logic rd_en;
       logic [WIDTH-1:0] data_out;       
       logic wr_ack;
       logic full,empty,almostempty,almostfull,underflow,overflow;
       int   WR_EN_ON_DIST =70;
       int   RD_EN_ON_DIST =30;

        constraint reset    {rst_n dist {1:=90,0:=10};}
        constraint write_en {wr_en dist {1:=WR_EN_ON_DIST,0:=100-WR_EN_ON_DIST};}
        constraint read_en  {rd_en dist {1:=RD_EN_ON_DIST,0:=100-RD_EN_ON_DIST};}

    endclass //FIFO_transaction
    
endpackage