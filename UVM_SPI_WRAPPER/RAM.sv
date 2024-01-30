module Dp_Sync_RAM(SPI_wrapper_if.RAM ram_intf);
	parameter MEM_DEPTH = 256;
	parameter ADDR_SIZE = 8;

	reg [7:0] mem [MEM_DEPTH-1:0];
	reg [ADDR_SIZE-1:0] addr_rd;
	reg [ADDR_SIZE-1:0] addr_wr;

	logic [9:0] din;
	logic [7:0] dout;

	assign din=ram_intf.rx_data;
	assign ram_intf.tx_data=dout;

	integer i;
	always @(posedge ram_intf.clk or negedge ram_intf.rst_n) begin
		if (!ram_intf.rst_n) begin
		   dout <= 0;
		   addr_rd<=0;
		   addr_wr<=0;
		   ram_intf.tx_valid<=0;
		   for(i=0; i<MEM_DEPTH; i=i+1)
			mem[i] <= 0;
		end
		else if (ram_intf.rx_valid) begin
		   ram_intf.tx_valid <= 1'b0;
		   case (din[9:8])
			2'b00: addr_wr <= din[7:0];
			2'b01: mem[addr_wr] <= din[7:0];
			2'b10: addr_rd <= din[7:0];
			2'b11: {dout, ram_intf.tx_valid} <= {mem[addr_rd], 1'b1};
		   endcase
		end
	end
`ifdef SIM_PARAM
 
  //sequential
  property p1;
  @(posedge ram_intf.clk) disable iff (!ram_intf.rst_n) (ram_intf.tx_valid && (ram_intf.rx_data[9:8]==3)) |=> ram_intf.tx_data==(mem[$past(addr_rd)]) ;
  endproperty

  property p2;
  @(posedge ram_intf.clk) disable iff (!ram_intf.rst_n) (ram_intf.rx_valid && (ram_intf.rx_data[9:8]==1)) |=>mem[addr_wr]==$past(ram_intf.rx_data[7:0]);
  endproperty



  assert property (p1);
  cover property (p1);

  assert property (p2);
  cover property (p2);
`endif

endmodule
