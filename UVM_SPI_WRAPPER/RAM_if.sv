interface ram_if(clk);
  // Define signals in the interface
  input logic clk;  
  logic rst_n, rx_valid;
  logic [9:0] din;
  logic tx_valid;
  logic [7:0] dout;
  // Specify directions for the signals
  modport RAM_DUT (
    input clk, rst_n, rx_valid,din,
	output tx_valid,dout
  );

endinterface