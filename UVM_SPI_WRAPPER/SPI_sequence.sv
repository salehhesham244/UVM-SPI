package SPI_sequence_pkg;

    import uvm_pkg::*;
`include "uvm_macros.svh"

class SPI_seq_item extends uvm_sequence_item;
    `uvm_object_utils(SPI_seq_item)
    logic SS_n,MOSI;
    logic MISO,MISO_G;
    logic rx_valid, tx_valid_G,tx_valid;
    logic [9:0] rx_data;
    logic [7:0] tx_data_G,tx_data;
    rand logic rst_n;


    rand logic [10:0] random_MOSI_seq;
    static bit [1:0] old_operation;
    logic valid_operations,write,read;
    // constrain the reset to be dis_activated mostly
    constraint var_const{
        rst_n dist{1:=99}; //we will not randomize the reset as it causes hanging in simulation but we made sure it works perfect at the begining of the sim

        if(valid_operations){

        if(write==1 && read==0){
            random_MOSI_seq[10]==0;
            random_MOSI_seq[9:8] dist{0:=90,1:=1};
            random_MOSI_seq[9:8]!=old_operation;
        }
        else if (write==0 && read==1){
            random_MOSI_seq[10]==1;
            random_MOSI_seq[9:8] dist{2:=50,3:=50};
            random_MOSI_seq[9:8]!=old_operation;
        }
        else{
            random_MOSI_seq[9:8] dist{0:=25,1:=25,2:=25,3:=25};
            if(old_operation==0)
            {
                random_MOSI_seq[9:8]==1;
            }

            if(old_operation==2)
            {
                random_MOSI_seq[9:8]==3;
            }
        }
      }
    }

    function void post_randomize();
      old_operation=random_MOSI_seq[9:8];
    endfunction
    
    function new(string name="SPI_seq_item");
    super.new(name);
    endfunction //new()

    function string convert2string();
    return $sformatf("%s rst_n=%d , SS_n=%d , MISO=%d",super.convert2string(),rst_n,SS_n,MISO);
    endfunction

    function string convert2string_stimulus();
    return $sformatf("rst_n=%d , ss_n=%d , MOSI=%d",rst_n,SS_n,MOSI);
    endfunction

endclass //SPI_sesq_item

endpackage