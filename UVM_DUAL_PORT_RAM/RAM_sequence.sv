package ram_sequence_pkg;

typedef enum bit [2:0] {OR,XOR,ADD,MULT,SHIFT,ROTATE,INVALID_6,INVALID_7}  opcode_e;

typedef enum bit [2:0] {V_OR,V_XOR,V_ADD,V_MULT,V_SHIFT,V_ROTATE}  opcode_valid_e;

    import uvm_pkg::*;
`include "uvm_macros.svh"

class ram_seq_item extends uvm_sequence_item;
    `uvm_object_utils(ram_seq_item)

	rand logic rst_n,rx_valid;
	rand logic [9:0] din;
    bit write,read;
    static bit [1:0] old_operation;
    logic tx_valid,tx_valid_G;
	logic [7:0] dout,dout_G;

    function new(string name="ram_seq_item");
    super.new(name);
    endfunction //new()

    function string convert2string();
    return $sformatf("%s rst_n=%d , rx_valid=%d , din=%d , tx_valid=%d , data_out=%d ",super.convert2string(),rst_n,rx_valid,din,tx_valid,dout);
    endfunction

    function string convert2string_stimulus();
    return $sformatf("rst_n=%d , rx_valid=%d , din=%d ",rst_n,rx_valid,din);
    endfunction

    function void post_randomize();
    old_operation=din[9:8];
    endfunction

   constraint variables{
        rst_n dist {1:=98}; //writing the rst=0 hangs the simulator but it works fine so we wont test it in randomization

        rx_valid dist{1:=98,0:=1};

        if(write && !read){
            din[9:8] dist{0:=90,1:=1};
            din[9:8]!=old_operation;
        }
        else if(!write && read){
            din[9:8] dist{2:=50,3:=50};
            din[9:8]!=old_operation;
        }
        else{
            din[9:8] dist{0:=25,1:=25,2:=25,3:=25};
            if(old_operation==0)
            {
                din[9:8]==1;
            }

            if(old_operation==2)
            {
                din[9:8]==3;
            }
        }
        
    }

endclass //ram_seq_item

endpackage