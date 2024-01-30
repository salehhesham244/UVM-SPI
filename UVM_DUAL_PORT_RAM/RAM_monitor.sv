package ram_monitor;
import ram_sequence_pkg::*;

import uvm_pkg::*;
`include "uvm_macros.svh"

class ram_monitor extends uvm_monitor;
    `uvm_component_utils(ram_monitor)
    virtual ram_if ram_vif;
    virtual ram_G_if ram_G_vif;
    ram_seq_item rsp_seq_item;
    uvm_analysis_port #(ram_seq_item) mon_ap;

    function new(string name="ram_monitor",uvm_component parent=null);
        super.new(name,parent);
    endfunction //new()

    function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    mon_ap=new("mon_ap",this);
    endfunction

     task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                rsp_seq_item = ram_seq_item::type_id::create("rsp_seq_item");
                    rsp_seq_item.rst_n=ram_vif.rst_n;
                    rsp_seq_item.din=ram_vif.din;
                    rsp_seq_item.rx_valid=ram_vif.rx_valid;
                    rsp_seq_item.dout=ram_vif.dout;
                    rsp_seq_item.tx_valid=ram_vif.tx_valid;
                    rsp_seq_item.dout_G=ram_G_vif.dout_G;
                    rsp_seq_item.tx_valid_G=ram_G_vif.tx_valid_G;
                    @(negedge ram_vif.clk);
                mon_ap.write(rsp_seq_item);
                `uvm_info("run_phase",rsp_seq_item.convert2string(),UVM_HIGH)
            end
        endtask //run_phase
endclass //ram_monitor extends uvm_monitor

endpackage