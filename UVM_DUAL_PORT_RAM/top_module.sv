import uvm_pkg::*;
`include "uvm_macros.svh"
import ram_test_pkg::*;
module top ();
    bit clk;

    initial begin
        forever begin
            #1 clk=!clk;
        end
    end
    //ram interface
    ram_if ramif(clk);
    Dp_Sync_RAM DUT(ramif);

    ram_G_if ramGif(clk);
    RAM_GOLD GOLD_DUT(ramGif);

    bind Dp_Sync_RAM ram_assertions DUT2(ramif.RAM_DUT);

    assign ramGif.din=ramif.din;
    assign ramGif.rst_n=ramif.rst_n;
    assign ramGif.rx_valid=ramif.rx_valid;

    initial begin
        //add ram interface to the config db
        uvm_config_db#(virtual ram_if)::set(null,"uvm_test_top","ram_IF",ramif);
        //add gold ram interface to the config db
        uvm_config_db#(virtual ram_G_if)::set(null,"uvm_test_top","ram_G_IF",ramGif);
        run_test("ram_test");
    end
endmodule