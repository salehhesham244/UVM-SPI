package SPI_agent_pkg;
import SPI_monitor::*;
import SPI_driver_pkg::*;
import SPI_sequencer_pkg::*;
import SPI_config_pkg::*;
import SPI_sequence_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class SPI_agent extends uvm_agent;
`uvm_component_utils(SPI_agent)

    SPI_sequencer sqr;
    SPI_driver drv;
    SPI_monitor mon;
    SPI_config_obj SPI_cfg;

    //making the agent port
    uvm_analysis_port #(SPI_seq_item) agt_ap;

    function new(string name="SPI_agent",uvm_component parent=null);
    super.new(name,parent);
    endfunction //new()

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!( uvm_config_db #(SPI_config_obj)::get(this , "" , "SPI_CFG" , SPI_cfg)))
       begin
        `uvm_fatal("build_phase" , "unable to retrieve config in the the agent")
       end
       if(SPI_cfg.SPI_active==UVM_ACTIVE)begin
        sqr=SPI_sequencer::type_id::create("sqr",this);
        drv=SPI_driver::type_id::create("drv",this);
       end
        mon=SPI_monitor::type_id::create("mon",this);
        agt_ap=new("agt_ap",this);
    endfunction

    
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        if(SPI_cfg.SPI_active==UVM_ACTIVE)begin
        drv.SPI_driver_vif=SPI_cfg.SPI_config_vif;
        drv.seq_item_port.connect(sqr.seq_item_export);
        end
        mon.SPI_vif=SPI_cfg.SPI_config_vif;
        mon.SPI_G_vif=SPI_cfg.SPI_G_config_vif;
        mon.mon_ap.connect(agt_ap);
    endfunction


endclass //SPI_agent extends uvm_agent

    
endpackage