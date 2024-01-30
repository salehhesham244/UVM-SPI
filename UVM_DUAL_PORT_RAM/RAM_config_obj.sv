package ram_config_pkg;

 import uvm_pkg::*;
`include "uvm_macros.svh"

class ram_config_obj extends uvm_object;
    `uvm_object_utils(ram_config_obj)

    virtual ram_if ram_config_vif;
    
    uvm_active_passive_enum ram_active;

    virtual ram_G_if ram_G_config_vif;

    function new(string name ="ram_config");
        super.new(name);
    endfunction //new()
endclass //ram_config_pkg

endpackage
