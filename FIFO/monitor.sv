import pack_one::*;
import pack_two::*;
import pack_three::*;
import shared_pkg::*;
module monitor (FIFO_if.MONITOR F_if);
    
    FIFO_transaction f_tr=new;
    FIFO_coverage    f_cv=new;
    FIFO_scoreboard  f_sc=new;

    initial begin
        forever  begin
            f_tr.rst_n=F_if.rst_n;
            f_tr.wr_en=F_if.wr_en;
            f_tr.rd_en=F_if.rd_en;
            f_tr.data_in=F_if.data_in;
            #3;
            f_tr.wr_ack=F_if.wr_ack;
            f_tr.data_out=F_if.data_out;
            f_tr.full=F_if.full;
            f_tr.empty=F_if.empty;
            f_tr.overflow=F_if.overflow;
            f_tr.underflow=F_if.underflow;
            f_tr.almostempty=F_if.almostempty;
            f_tr.almostfull=F_if.almostfull;
            fork
                //process-1
                begin
                    f_cv.sample_data(f_tr);
                end

                //process-2
                begin
                    f_sc.check_data(f_tr);
                end
            join
            #1;
            if (shared_pkg::test_finished==1) begin
                $display ("the correct_count =%0d",shared_pkg::correct_count);
                $display ("the error_count =%0d",shared_pkg::error_count);
                $stop;
            end
        end
    end


endmodule