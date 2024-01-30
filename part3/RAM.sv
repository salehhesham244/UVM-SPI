module Dp_Sync_RAM(rst_n,din,rx_valid,dout,tx_valid);
	parameter MEM_DEPTH = 256;
	parameter ADDR_SIZE = 8;

	reg [7:0] mem [MEM_DEPTH-1:0];
	reg [ADDR_SIZE-1:0] addr_rd;
	reg [ADDR_SIZE-1:0] addr_wr;

	input  logic [9:0] din;
	input  logic rx_valid ,rst_n;
	output logic [7:0] dout;
	output logic tx_valid;

	

	integer i;
	always @(*) begin
		if (!rst_n) begin
		   dout <= 0;
		   addr_rd<=0;
		   addr_wr<=0;
		   tx_valid<=0;
		   for(i=0; i<MEM_DEPTH; i=i+1)
			mem[i] <= 0;
		end
		else if (rx_valid) begin
		   tx_valid <= 1'b0;
		   case (din[9:8])
			2'b00: addr_wr <= din[7:0];
			2'b01: mem[addr_wr] <= din[7:0];
			2'b10: addr_rd <= din[7:0];
			2'b11: {dout,tx_valid} <= {mem[addr_rd], 1'b1};
		   endcase
		end
	end


endmodule
