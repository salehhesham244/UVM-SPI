package SPI_coverage_pkg ; 
import uvm_pkg::*;
`include "uvm_macros.svh"
import SPI_sequence_pkg::*;
    parameter WRITE_ADD=0;
    parameter WRITE_DATA=1;
    parameter READ_ADD=2;
    parameter READ_DATA=3; 
class SPI_coverage extends uvm_component ; 
`uvm_component_utils(SPI_coverage);
uvm_analysis_export #(SPI_seq_item) cov_export; 
uvm_tlm_analysis_fifo #(SPI_seq_item) cov_fifo ; 
SPI_seq_item seq_item_cov ; 

covergroup cvr ;
        // Define the coverage points for cross coverage
        rst_n_cp:coverpoint seq_item_cov.rst_n;
        SS_n_cp:coverpoint seq_item_cov.SS_n;
        MOSI_cp:coverpoint seq_item_cov.MOSI;
        rx_valid_cp:coverpoint seq_item_cov.rx_valid;
        tx_valid_cp:coverpoint seq_item_cov.tx_valid;
        rx_data_cp:coverpoint seq_item_cov.rx_data;
        tx_data_cp:coverpoint seq_item_cov.tx_data;
        MISO_cp:coverpoint seq_item_cov.MISO;
        
    endgroup

function new( string name = "SPI_coverage" , uvm_component parent = null);
super.new(name , parent);
cvr = new();
endfunction

function void build_phase(uvm_phase phase);
super.build_phase(phase);
cov_export = new("cov_export" , this);
cov_fifo = new("cov_fifo" , this);
endfunction

function void connect_phase(uvm_phase phase);
super.connect_phase(phase);
cov_export.connect(cov_fifo.analysis_export);
endfunction

task run_phase (uvm_phase phase);
super.run_phase(phase);
forever
begin 
cov_fifo.get(seq_item_cov);
cvr.sample();
end
endtask
endclass
endpackage