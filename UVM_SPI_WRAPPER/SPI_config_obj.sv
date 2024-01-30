package SPI_config_pkg;

 import uvm_pkg::*;
`include "uvm_macros.svh"

class SPI_config_obj extends uvm_object;
    `uvm_object_utils(SPI_config_obj)

    virtual SPI_wrapper_if SPI_config_vif;

    uvm_active_passive_enum SPI_active;

    virtual SPI_wrapper_G_if SPI_G_config_vif;
    function new(string name ="SPI_config");
        super.new(name);
    endfunction //new()
endclass //SPI_config_pkg

endpackage
