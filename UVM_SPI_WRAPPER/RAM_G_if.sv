interface ram_G_if(clk);
  // Define signals in the interface
  input logic clk;  
  logic rst_n, rx_valid;
  logic [9:0] din;
  logic tx_valid_G;
  logic [7:0] dout_G;
  // Specify directions for the signals
  modport GOLD_DUT (
    input clk, rst_n, rx_valid,din,
	output tx_valid_G,dout_G
  );

endinterface