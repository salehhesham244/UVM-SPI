import uvm_pkg::*;
`include "uvm_macros.svh"
import SPI_test_pkg::*;
module top ();
    bit clk;

    initial begin
        forever begin
            #1 clk=!clk;
        end
    end

    //ram and golden ram interface requierd for the ram env
    ram_if ramif(clk);

    ram_G_if ramGif(clk);

    bind Dp_Sync_RAM ram_assertions DUT2(ramif.RAM_DUT);


    //wrapper model
    SPI_wrapper_if spiwrapperif(clk);
    SPI_Slave Slave(spiwrapperif);
    Dp_Sync_RAM RAM(spiwrapperif);

    //wrapper gold model
    SPI_wrapper_G_if spiwrappergif(clk);
    SPI_slave_G Slave_G(spiwrappergif);
    RAM_GOLD RAM_G(spiwrappergif);

    assign spiwrappergif.SS_n=spiwrapperif.SS_n;
    assign spiwrappergif.MOSI=spiwrapperif.MOSI;
    assign spiwrappergif.rst_n=spiwrapperif.rst_n;


    // driving ram intf
    assign ramif.rst_n=spiwrapperif.rst_n;
    assign ramif.din=spiwrapperif.rx_data;
    assign ramif.rx_valid=spiwrapperif.rx_valid;
    assign ramif.tx_valid=spiwrapperif.tx_valid;
    assign ramif.dout=spiwrapperif.tx_data; 

    // driving golden ram intf
    assign ramGif.rst_n=spiwrappergif.rst_n;
    assign ramGif.din=spiwrappergif.rx_data;
    assign ramGif.rx_valid=spiwrappergif.rx_valid;
    assign ramGif.tx_valid_G=spiwrappergif.tx_valid_G;
    assign ramGif.dout_G=spiwrappergif.tx_data_G; 

    initial begin
        //add wrapper interface to the config db
        uvm_config_db#(virtual SPI_wrapper_if)::set(null,"uvm_test_top","wrapper_IF",spiwrapperif);
        //add gold wrapper interface to the config db
        uvm_config_db#(virtual SPI_wrapper_G_if)::set(null,"uvm_test_top","wrapper_G_IF",spiwrappergif);
        //add ram interface to the config db
        uvm_config_db#(virtual ram_if)::set(null,"uvm_test_top","ram_IF",ramif);
        //add gold ram interface to the config db
        uvm_config_db#(virtual ram_G_if)::set(null,"uvm_test_top","ram_G_IF",ramGif);
        run_test("SPI_test");
    end
endmodule