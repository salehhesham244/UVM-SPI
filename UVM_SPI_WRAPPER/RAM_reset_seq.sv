package ram_reset_seq;
import ram_sequence_pkg::*;
 import uvm_pkg::*;
`include "uvm_macros.svh"

class ram_reset_seq extends uvm_sequence #(ram_seq_item);

`uvm_object_utils(ram_reset_seq)

ram_seq_item seq_item;

function new(string name="ram_reset_sequence");
    super.new(name);
endfunction

task body;
seq_item=ram_seq_item::type_id::create("seq_item");
start_item(seq_item);
seq_item.rst_n=0;
finish_item(seq_item);
endtask //body

endclass

endpackage