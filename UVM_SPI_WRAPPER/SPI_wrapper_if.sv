interface SPI_wrapper_if(clk);

input logic clk;
logic MOSI , SS_n , rst_n ;
logic MISO;  

logic [7:0] tx_data ;
logic [9:0] rx_data ; 
logic rx_valid , tx_valid ;

 modport RAM (
    input clk, rst_n, rx_valid,rx_data,
	output tx_valid,tx_data
  );

  modport Slave (
   input MOSI, SS_n, clk, rst_n, tx_valid,tx_data,
   output MISO,rx_valid,rx_data
  );

endinterface //SPI_wrapper_if