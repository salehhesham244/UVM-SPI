package ram_scoreboard_pak;

import ram_sequence_pkg::*;
 import uvm_pkg::*;
`include "uvm_macros.svh"

class ram_scoreboard extends uvm_scoreboard;


    `uvm_component_utils(ram_scoreboard)
    
    uvm_analysis_export #(ram_seq_item) sb_export;
    uvm_tlm_analysis_fifo #(ram_seq_item) sb_fifo;
    ram_seq_item seq_item_sb;

    int error_count=0;
    int correct_count=0;

    function new(string name="ram_scoreboard",uvm_component parent=null);
        super.new(name,parent);
    endfunction //new()
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        sb_export=new("sb_export",this);
        sb_fifo=new("sb_fifo",this);
    endfunction

    function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    sb_export.connect(sb_fifo.analysis_export);
    endfunction

    task run_phase (uvm_phase phase);
    super.run_phase(phase);
        forever begin
            sb_fifo.get(seq_item_sb);
            if(seq_item_sb.dout!=seq_item_sb.dout_G || seq_item_sb.tx_valid!=seq_item_sb.tx_valid_G )begin
                `uvm_error("run_phase",$sformatf("comparison failed,transaction recived by the DUT:%s while the dout_G=%d && tx_valid_G=%0d",seq_item_sb.convert2string(),seq_item_sb.dout_G,seq_item_sb.tx_valid_G))
                error_count++;
            end
            else begin
                correct_count++;
            end
        end
    endtask //run_pahse
        
function void report_phase(uvm_phase phase);
super.report_phase(phase);
`uvm_info("report_phase" , $sformatf("total successful transactions : %d" , correct_count), UVM_MEDIUM)
`uvm_info("report_phase" , $sformatf("total failed transactions : %d" , error_count),UVM_MEDIUM)
endfunction

endclass //ram_scoreboard extends uvm_scoreboard
endpackage