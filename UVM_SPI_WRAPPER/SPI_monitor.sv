package SPI_monitor;
import SPI_sequence_pkg::*;

import uvm_pkg::*;
`include "uvm_macros.svh"

class SPI_monitor extends uvm_monitor;
    `uvm_component_utils(SPI_monitor)
    virtual SPI_wrapper_if SPI_vif;
    virtual SPI_wrapper_G_if SPI_G_vif;
    SPI_seq_item rsp_seq_item;
    uvm_analysis_port #(SPI_seq_item) mon_ap;

    function new(string name="SPI_monitor",uvm_component parent=null);
        super.new(name,parent);
    endfunction //new()

    function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    mon_ap=new("mon_ap",this);
    endfunction
    
     task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                rsp_seq_item = SPI_seq_item::type_id::create("rsp_seq_item");
                @(negedge SPI_vif.clk);    
                rsp_seq_item.rst_n=SPI_vif.rst_n;
                rsp_seq_item.SS_n=SPI_vif.SS_n;
                rsp_seq_item.MOSI=SPI_vif.MOSI;
                rsp_seq_item.rx_valid=SPI_vif.rx_valid;
                rsp_seq_item.tx_valid=SPI_vif.tx_valid;
                rsp_seq_item.rx_data=SPI_vif.rx_data;
                rsp_seq_item.tx_data=SPI_vif.tx_data;
                rsp_seq_item.MISO=SPI_vif.MISO;
                //gold model
                rsp_seq_item.MISO_G=SPI_G_vif.MISO_G;
                rsp_seq_item.tx_valid_G=SPI_G_vif.tx_valid_G;
                rsp_seq_item.tx_data_G=SPI_G_vif.tx_data_G;
                mon_ap.write(rsp_seq_item);
                `uvm_info("run_phase",rsp_seq_item.convert2string(),UVM_HIGH)
            end
        endtask //run_phase
endclass //SPI_monitor extends uvm_monitor

endpackage