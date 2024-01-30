interface SPI_wrapper_G_if(clk);
input logic clk;
logic MOSI , SS_n , rst_n ;
logic MISO_G ;  

logic [7:0] tx_data_G ;
logic [9:0] rx_data ; 
logic rx_valid , tx_valid_G ;

modport RAM_G (
    input clk, rst_n, rx_valid,rx_data,
	output tx_valid_G,tx_data_G
  );

  modport Slave_G (
   input MOSI, SS_n, clk, rst_n, tx_valid_G,tx_data_G,
   output MISO_G,rx_valid,rx_data
  );

endinterface //SPI_wrapper_G_if