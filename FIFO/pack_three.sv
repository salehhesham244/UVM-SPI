import shared_pkg::*;
package pack_three;
import pack_one::*;

class FIFO_scoreboard;

        localparam WIDTH = 16;
        localparam FIFO_DEPTH=8;

    logic [2:0] wr_ptr,rd_ptr;
    logic [3:0] count;
    logic [WIDTH-1:0] data_out_ref;
    logic wr_ack_ref,full_ref,empty_ref;
    logic almostempty_ref,almostfull_ref;
    logic overflow_ref,underflow_ref;


    logic [WIDTH-1:0] mem [FIFO_DEPTH-1:0];
    integer count_ref;


    function check_data (input FIFO_transaction f_in );
        reference_model(f_in);
        if ((wr_ack_ref != f_in.wr_ack)) begin
            shared_pkg::error_count++;
            $display("%t:ERROR,The value of wr_ack_ref=%0d & the value of the f_in.wr_ack=%0d",$time,wr_ack_ref,f_in.wr_ack);
            $stop;
        end
        else begin
                shared_pkg::correct_count++;

        end
        if ((data_out_ref != f_in.data_out)) begin
            shared_pkg::error_count++;
            $display("%t:ERROR,the value of the data_out_ref=%0d,the value of the f_in.data_out=%0d",$time,data_out_ref,f_in.data_out);  
            $stop; 
        end
        else begin
               shared_pkg::correct_count++;
 
        end
        if ((full_ref != f_in.full)) begin
            shared_pkg::error_count++;
            $display("%t:ERROR,the value of the full_ref=%0d,the value of the f_in.full=%0d",$time,full_ref,f_in.full);  
            $stop; 
        end
        else begin
               shared_pkg::correct_count++;
 
        end
        if ((empty_ref!=f_in.empty)) begin
            shared_pkg::error_count++;
            $display("%t:ERROR,the value of the empty_ref=%0d,the value of the f_in.empty=%0d",$time,empty_ref,f_in.empty);  
            $stop; 
        end
        else begin
               shared_pkg::correct_count++;
        end
        if ((overflow_ref != f_in.overflow)) begin
            shared_pkg::error_count++;
            $display("%t:ERROR,the value of the overflow_ref=%0d,the value of the f_in.overflow=%0d",$time,overflow_ref,f_in.overflow);   
            $stop;
        end
        else begin
               shared_pkg::correct_count++;
 
        end
        if (underflow_ref!=f_in.underflow) begin
            shared_pkg::error_count++;
            $display("%t:ERROR,the value of the underflow_ref=%0d,the value of the f_in.underflow=%0d",$time,underflow_ref,f_in.underflow); 
            $stop;  
        end
        else begin
               shared_pkg::correct_count++;

        end
        if (almostempty_ref != f_in.almostempty) begin
            shared_pkg::error_count++;
            $display("%t:ERROR,the value of the almostempty_ref=%0d,the value of the f_in.almostempty=%0d",$time,almostempty_ref,f_in.almostempty); 
            $stop;  
        end
        else begin
               shared_pkg::correct_count++;

        end
        if (almostfull_ref !=f_in.almostfull) begin
            shared_pkg::error_count++;
            $display("%t:ERROR,the value of the almostfull_ref=%0d,the value of the f_in.almostfull=%0d",$time,almostfull_ref,f_in.almostfull); 
            $stop;  
        end
        else begin
               shared_pkg::correct_count++;

        end
    endfunction

    function reference_model(input FIFO_transaction FIFO_check);
// For concurrent operations to simulate the desgin 
      fork

        // Process (1) --> Write operation
        begin

          if (!FIFO_check.rst_n) begin
            wr_ptr = 0;
            wr_ack_ref = 0;
            overflow_ref = 0;
          end
          else if (FIFO_check.wr_en && count < FIFO_DEPTH) begin
            mem[wr_ptr] = FIFO_check.data_in;
            wr_ack_ref = 1;
            wr_ptr = wr_ptr + 1;
          end
          else begin 
            wr_ack_ref = 0; 
            if (full_ref & FIFO_check.wr_en)
              overflow_ref = 1;
            else
              overflow_ref = 0;
          end
          
        end

        // Process (2) --> Read operation
        begin
          if (!FIFO_check.rst_n) begin
            rd_ptr = 0;
            underflow_ref = 0;
            data_out_ref = 0;
          end
          else if (FIFO_check.rd_en && count != 0) begin
            data_out_ref = mem[rd_ptr];
            rd_ptr = rd_ptr + 1;
          end
          else begin
            if(empty_ref && FIFO_check.rd_en)
              underflow_ref = 1;
            else
              underflow_ref = 0;
          end
        end

        // Process (3) --> Count operation
        begin
          if (!FIFO_check.rst_n) begin
            count = 0;
          end
          else begin
            if  ( ({FIFO_check.wr_en, FIFO_check.rd_en} == 2'b10) && !full_ref) 
              count = count + 1;
            else if ( ({FIFO_check.wr_en, FIFO_check.rd_en} == 2'b01) && !empty_ref)
              count = count - 1;
            else if(({FIFO_check.wr_en, FIFO_check.rd_en} == 2'b11) && full_ref)
              count = count - 1;
            else if(({FIFO_check.wr_en, FIFO_check.rd_en} == 2'b11) && empty_ref)
              count = count + 1;
          end
        end

      join

      full_ref = (count == FIFO_DEPTH)? 1 : 0;
      empty_ref = (count == 0)? 1 : 0;
      almostfull_ref = (count == FIFO_DEPTH-1)? 1 : 0; 
      almostempty_ref = (count==1)?1:0;
endfunction
endclass //FIFO_scoreboard

endpackage