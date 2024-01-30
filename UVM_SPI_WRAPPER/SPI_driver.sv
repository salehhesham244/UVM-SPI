package SPI_driver_pkg;
    import uvm_pkg::*;

`include "uvm_macros.svh"
    import SPI_sequence_pkg::*;
    class SPI_driver extends uvm_driver #(SPI_seq_item);
        `uvm_component_utils(SPI_driver)

         virtual SPI_wrapper_if SPI_driver_vif;
         SPI_seq_item stim_seq_item;

        function new(string name="SPI_driver",uvm_component parent=null);
            super.new(name,parent);            
        endfunction //new()

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                stim_seq_item = SPI_seq_item::type_id::create("stim_seq_item");
                seq_item_port.get_next_item(stim_seq_item);
                SPI_driver_vif.rst_n=stim_seq_item.rst_n;
                @(negedge SPI_driver_vif.clk);
                SPI_driver_vif.SS_n=0;
                stim_seq_item.SS_n=SPI_driver_vif.SS_n;
                for(int j=10;j>=0;j--)begin
                @(negedge SPI_driver_vif.clk);
                SPI_driver_vif.MOSI=stim_seq_item.random_MOSI_seq[j];
                end
                @(negedge SPI_driver_vif.clk);
                SPI_driver_vif.SS_n=1;
                stim_seq_item.SS_n=SPI_driver_vif.SS_n;
                seq_item_port.item_done();
                `uvm_info("run_pahse",stim_seq_item.convert2string_stimulus(),UVM_HIGH)
            end
        endtask //run_phase
    endclass //SPI_driver extends uvem_driver
endpackage