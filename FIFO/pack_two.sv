package pack_two;
import pack_one::*;
     localparam WIDTH=16;

    class FIFO_coverage;

        FIFO_transaction F_cvg_txn=new();

        covergroup cvg;
            cp1:coverpoint F_cvg_txn.wr_en
            {
                bins wr_en0={0};
                bins wr_en1={1};
            }
            cp2:coverpoint F_cvg_txn.rd_en
            {
                bins rd_en0={0};
                bins rd_en1={1};
            }
            cp3:coverpoint F_cvg_txn.full
            {
                bins full0={0};
                bins full1={1};
            }
            cp4:coverpoint F_cvg_txn.empty
            {
                bins empty0={0};
                bins empty1={1};
            }
            cp5:coverpoint F_cvg_txn.almostfull
            {
                bins almostfull0={0};
                bins almostfull1={1};
            }
            cp6:coverpoint F_cvg_txn.almostempty
            {
                bins almostempty0={0};
                bins almostempty1={1};
            }
            cp7:coverpoint F_cvg_txn.wr_ack
            {
                bins wr_ack0={0};
                bins wr_ack1={1};
            }
            cp8:coverpoint F_cvg_txn.overflow
            {
                bins overflow0={0};
                bins overflow1={1};
            }
            cp9:coverpoint F_cvg_txn.underflow
            {
                bins underflow0={0};
                bins underflow1={1};
            }
            cv1:cross cp2,cp1,cp3
            {
                ignore_bins ig0 =binsof(cp1.wr_en1)&&binsof(cp2.rd_en1)&&binsof(cp3.full1);
                ignore_bins ig1 =binsof(cp1.wr_en0)&&binsof(cp2.rd_en1)&&binsof(cp3.full1);
                ignore_bins ig2 =binsof(cp1.wr_en0)&&binsof(cp2.rd_en0)&&binsof(cp3.full1);
            }
            cv2:cross cp2,cp1,cp4
            {
                ignore_bins ig0 =binsof(cp1.wr_en1)&&binsof(cp2.rd_en1)&&binsof(cp4.empty1);
                ignore_bins ig1 =binsof(cp1.wr_en1)&&binsof(cp2.rd_en0)&&binsof(cp4.empty1);
                ignore_bins ig2 =binsof(cp1.wr_en0)&&binsof(cp2.rd_en0)&&binsof(cp4.empty1); 
            }
            cv3:cross cp2,cp1,cp5
            {
                ignore_bins ig0 =binsof(cp1.wr_en0)&&binsof(cp2.rd_en0)&&binsof(cp5.almostfull1);
            }
            cv4:cross cp2,cp1,cp6;
            cv5:cross cp2,cp1,cp7
            {
                ignore_bins ig0 =binsof(cp1.wr_en0)&&binsof(cp2.rd_en1)&&binsof(cp7.wr_ack1);
                ignore_bins ig1 =binsof(cp1.wr_en0)&&binsof(cp2.rd_en0)&&binsof(cp7.wr_ack1);
            }
            cv6:cross cp2,cp1,cp8
            {
                ignore_bins ig0 =binsof(cp1.wr_en0)&&binsof(cp2.rd_en1)&&binsof(cp8.overflow1);
                ignore_bins ig1 =binsof(cp1.wr_en0)&&binsof(cp2.rd_en0)&&binsof(cp8.overflow1);
            }
            cv7:cross cp2,cp1,cp9
            {
                ignore_bins ig0 =binsof(cp1.wr_en1)&&binsof(cp2.rd_en0)&&binsof(cp9.underflow1);
                ignore_bins ig1 =binsof(cp1.wr_en0)&&binsof(cp2.rd_en0)&&binsof(cp9.underflow1);
            }
        endgroup
       
        function sample_data (input FIFO_transaction F_txn);
            F_cvg_txn=F_txn;
            cvg.sample();
        endfunction
        
        function new();
            cvg=new;
        endfunction

    endclass //FIFO_coverage
    
endpackage