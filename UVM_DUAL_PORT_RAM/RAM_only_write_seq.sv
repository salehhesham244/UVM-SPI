package main_seq1;
import ram_sequence_pkg::*;
 import uvm_pkg::*;
`include "uvm_macros.svh"

class ram_main_seq1 extends uvm_sequence #(ram_seq_item);

`uvm_object_utils(ram_main_seq1)

ram_seq_item seq_item;


function new(string name="ram_main_sequence");
    super.new(name);
endfunction

task body;
repeat(5000)begin
seq_item=ram_seq_item::type_id::create("seq_item");
seq_item.write=1;
seq_item.read=0;
start_item(seq_item);
assert (seq_item.randomize()); 
finish_item(seq_item);
end
endtask //body

endclass

endpackage