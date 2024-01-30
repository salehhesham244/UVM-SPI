module ram_assertions (ram_if.RAM_DUT ram_intf);
  property p3;
  @(posedge ram_intf.clk) disable iff (!ram_intf.rst_n) (ram_intf.rx_valid && (ram_intf.din[9:8]==3)) |=> ram_intf.tx_valid==1'b1 ;
  endproperty
  
  assert property (p3);
  cover property (p3);
  
endmodule