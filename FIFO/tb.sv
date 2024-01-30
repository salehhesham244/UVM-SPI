import pack_one::*;
import shared_pkg::*;
module tb (FIFO_if.test F_if);

    FIFO_transaction f_obj=new;

 initial begin
    F_if.rst_n=0;
    #4;
    F_if.rst_n=1;
    for (int i=0;i<10000;i++) begin
        #4; 
        assert (f_obj.randomize()); 
        F_if.rst_n=f_obj.rst_n;
        F_if.wr_en=f_obj.wr_en;
        F_if.rd_en=f_obj.rd_en;
        F_if.data_in=f_obj.data_in;
    end
    set_test_finish();
 end

endmodule