 ////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: FIFO Design 
// 
////////////////////////////////////////////////////////////////////////////////
module FIFO(FIFO_if.DUT F_if);

parameter FIFO_WIDTH = 16;
parameter FIFO_DEPTH = 8;

 
localparam max_fifo_addr = $clog2(FIFO_DEPTH);

reg [FIFO_WIDTH-1:0] mem [FIFO_DEPTH-1:0];

reg [max_fifo_addr-1:0] wr_ptr, rd_ptr;
reg [max_fifo_addr:0] count;

always @(posedge F_if.clk or negedge F_if.rst_n) begin
	if (!F_if.rst_n) begin
		wr_ptr <= 0;
		F_if.overflow<=0;
		F_if.wr_ack<=0;
	end
	else if (F_if.wr_en && !F_if.full) begin
		mem[wr_ptr] <= F_if.data_in;
		F_if.wr_ack <= 1;
		wr_ptr <= wr_ptr + 1;
	end
	else begin 
		F_if.wr_ack <= 0; 
		if (F_if.full && F_if.wr_en)
			F_if.overflow <= 1;
		else
			F_if.overflow <= 0;
	end
end

always @(posedge F_if.clk or negedge F_if.rst_n) begin
	if (!F_if.rst_n) begin
		rd_ptr <= 0;
		F_if.underflow<=0;
		F_if.data_out<=0;
	end
	else if (F_if.rd_en && !F_if.empty) begin
		F_if.data_out <= mem[rd_ptr];
		rd_ptr <= rd_ptr + 1;
	end
	else if (F_if.empty && F_if.rd_en) begin
		F_if.underflow =1;
	end
	else
	F_if.underflow =0;
end

always @(posedge F_if.clk or negedge F_if.rst_n) begin
	if (!F_if.rst_n) begin
		count <= 0;
	end
	else begin
		if	( (({F_if.wr_en, F_if.rd_en} == 2'b10) && !F_if.full)||(({F_if.wr_en, F_if.rd_en} == 2'b11)&& F_if.empty)) 
			count <= count + 1;
		else if ((({F_if.wr_en, F_if.rd_en} == 2'b01) && !F_if.empty)||(({F_if.wr_en, F_if.rd_en} == 2'b11)&& F_if.full))
			count <= count - 1;
		end	
end

assign F_if.full = (count == FIFO_DEPTH)? 1 : 0;
assign F_if.empty = (count == 0)? 1 : 0;
assign F_if.almostfull = (count == FIFO_DEPTH-1)? 1 : 0; 
assign F_if.almostempty = (count == 1)? 1 : 0;

`ifdef SIM
    
	property asser1;
        @(posedge F_if.clk) disable iff (!F_if.rst_n) (count == FIFO_DEPTH) |-> (F_if.full==1)
    endproperty
 
    as1:assert property (asser1) else $display("ERROR1");
	cv1:cover property (asser1);

	property asser2;
        @(posedge F_if.clk) disable iff (!F_if.rst_n) (count == 0) |-> (F_if.empty==1)
    endproperty
 
    as2:assert property (asser2) else $display("ERROR2");
	cv2:cover property (asser2);

	property asser3;
        @(posedge F_if.clk) disable iff (!F_if.rst_n) ((F_if.empty) && (F_if.rd_en)) |=> F_if.underflow
    endproperty
 
    as3:assert property (asser3) else $display("ERROR3");
	cv3:cover property (asser3);	

	property asser4;
        @(posedge F_if.clk) disable iff (!F_if.rst_n) ((F_if.full) && (F_if.wr_en)) |=> F_if.overflow
    endproperty
 
    as4:assert property (asser4) else $display("ERROR4");
	cv4:cover property (asser4);

	property asser5;
        @(posedge F_if.clk) disable iff (!F_if.rst_n) (count == FIFO_DEPTH-1) |-> F_if.almostfull
    endproperty
 
    as5:assert property (asser5) else $display("ERROR5");
	cv5:cover property (asser5);

	property asser6;
        @(posedge F_if.clk) disable iff (!F_if.rst_n) (count == 1) |-> F_if.almostempty
    endproperty
 
    as6:assert property (asser6) else $display("ERROR6");
	cv6:cover property (asser6);	

	property asser7;
        @(posedge F_if.clk) disable iff (!F_if.rst_n) ((F_if.wr_en) && (!F_if.full)) |=> F_if.wr_ack
    endproperty
 
    as7:assert property (asser7) else $display("ERROR7");
	cv7:cover property (asser7);

	property asser8;
        @(posedge F_if.clk) disable iff (!F_if.rst_n) ((F_if.wr_en) && (!F_if.full)) |=> (wr_ptr==($past(wr_ptr)+3'b001))
    endproperty
 
    as8:assert property (asser8) else $display("ERROR8");
	cv8:cover property (asser8);	

	property asser9;
        @(posedge F_if.clk) disable iff (!F_if.rst_n) ((F_if.rd_en) && (!F_if.empty)) |=> (rd_ptr==($past(rd_ptr)+3'b001))
    endproperty
 
    as9:assert property (asser9) else $display("ERROR9");
	cv9:cover property (asser9);

	property asser10;
        @(posedge F_if.clk) disable iff (!F_if.rst_n) ((({F_if.wr_en, F_if.rd_en} == 2'b10) &&!F_if.full)||(({F_if.wr_en, F_if.rd_en} == 2'b11)&& F_if.empty)) |=> (count==(($past(count))+4'b0001))
    endproperty
 
    as10:assert property (asser10) else $display("ERROR10");
	cv10:cover property (asser10);

	property asser11;
        @(posedge F_if.clk) disable iff (!F_if.rst_n) ((({F_if.wr_en, F_if.rd_en} == 2'b01) && (!F_if.empty))||(({F_if.wr_en, F_if.rd_en} == 2'b11)&& F_if.full)) |=> (count==(($past(count))-4'b0001))
    endproperty
 
    as11:assert property (asser11) else $display("ERROR11");
	cv11:cover property (asser11);

	property asser12;
        @(posedge F_if.rst_n)  (!F_if.rst_n) |-> ((count==0) && (rd_ptr==0) && (wr_ptr==0))
    endproperty
 
    as12:assert property (asser12) else $display("ERROR12");
	cv12:cover property (asser12);	

`endif  


endmodule