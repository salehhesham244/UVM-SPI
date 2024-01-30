module RAM_GOLD #(
    parameter MEM_WIDTH = 8,
    parameter MEM_DEPTH = 256,
    parameter ADDR_SIZE = 8
  )
  (
   SPI_wrapper_G_if.RAM_G ram_intf
  );

  reg [MEM_WIDTH-1:0] mem [MEM_DEPTH-1 : 0];
  reg [MEM_WIDTH-1:0] write_addr, read_addr;
  wire read_en, write_en, blk_select;

  always@(posedge ram_intf.clk) begin
    if(~ram_intf.rst_n) begin
      write_addr <=0;
      read_addr <=0;
      ram_intf.tx_valid_G <=0;
        for(int i=0; i<MEM_DEPTH; i=i+1)begin
			mem[i] <= 0;
		end
    end
    else if(ram_intf.rx_valid)begin
        ram_intf.tx_valid_G <=0;
        case (ram_intf.rx_data[9:8])
          2'b00 : begin
            write_addr <= ram_intf.rx_data[7:0];
          end
          2'b10 :  begin 
            read_addr <= ram_intf.rx_data[7:0];
          end
          2'b11 : ram_intf.tx_valid_G <=1;
        endcase
    end
  end

  always@(posedge ram_intf.clk) begin
    if(~ram_intf.rst_n) 
      ram_intf.tx_data_G <= 0;
    else if(blk_select) begin
      if(write_en) begin
        mem[write_addr] <= ram_intf.rx_data[7:0];  
      end
      if(read_en) begin
        ram_intf.tx_data_G <= mem[read_addr];
      end
        
    end
  end

/* Memory Signals */
assign blk_select = (ram_intf.rx_valid == 1 && (read_en || write_en)) ? 1 : 0;
assign read_en = (ram_intf.rx_data[9:8] == 2'b11) ? 1 : 0;
assign write_en = (ram_intf.rx_data[9:8] == 2'b01) ? 1 : 0;

endmodule 