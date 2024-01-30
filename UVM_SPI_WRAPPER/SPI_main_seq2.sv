package SPI_main_seq2;
import SPI_sequence_pkg::*;
 import uvm_pkg::*;
`include "uvm_macros.svh"

class SPI_main_seq2 extends uvm_sequence #(SPI_seq_item);

`uvm_object_utils(SPI_main_seq2)

SPI_seq_item seq_item;

function new(string name="SPI_main_sequence");
    super.new(name);
endfunction

task body;
repeat(5000)begin
seq_item=SPI_seq_item::type_id::create("seq_item");
seq_item.valid_operations=1;
seq_item.write=0;
seq_item.read=1;
start_item(seq_item);
assert (seq_item.randomize());
finish_item(seq_item);
end
endtask //body

endclass

endpackage