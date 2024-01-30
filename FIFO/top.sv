module top ();
    
     bit clk;

    initial begin
        clk=0;
        forever begin
           #2 clk=~clk;
        end
    end

                        /*Instantiation*/
    FIFO_if F_if (clk);
    FIFO fifo_dut (F_if);
    tb   testb    (F_if);
    monitor mon   (F_if);

endmodule