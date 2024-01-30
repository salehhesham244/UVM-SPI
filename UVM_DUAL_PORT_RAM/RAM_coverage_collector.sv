package ram_coverage_pkg ; 
import uvm_pkg::*;
`include "uvm_macros.svh"
import ram_sequence_pkg::*;

class ram_coverage extends uvm_component ; 
`uvm_component_utils(ram_coverage);
uvm_analysis_export #(ram_seq_item) cov_export; 
uvm_tlm_analysis_fifo #(ram_seq_item) cov_fifo ; 
ram_seq_item seq_item_cov ; 

covergroup cvr ; 
   rx_valid_cp:coverpoint seq_item_cov.rx_valid
    {
        bins enabled={1};
        bins disabled={0};

    }
    
    operation_cov:coverpoint seq_item_cov.din[9:8]
    {
        bins write_data={1};
        bins read_data={3};
        bins write_add={0};
        bins read_add={2};
    }

    write_add_cp:coverpoint seq_item_cov.din[7:0] iff(seq_item_cov.din[9:8]==0);

    read_add_cp:coverpoint seq_item_cov.din[7:0] iff(seq_item_cov.din[9:8]==2);

    tx_valid_cv:coverpoint seq_item_cov.tx_valid
    {
        bins enabled={1};
        bins disabled={0};
    }
    dout_cv:coverpoint seq_item_cov.dout;
    
endgroup 

function new( string name = "ram_coverage" , uvm_component parent = null);
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