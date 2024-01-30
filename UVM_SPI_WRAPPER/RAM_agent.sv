package ram_agent_pkg;
import ram_monitor::*;
import ram_driver_pkg::*;
import ram_sequencer_pkg::*;
import ram_config_pkg::*;
import ram_sequence_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class ram_agent extends uvm_agent;
`uvm_component_utils(ram_agent)

    ram_sequencer sqr;
    ram_driver drv;
    ram_monitor mon;
    ram_config_obj ram_cfg;

    //making the agent port
    uvm_analysis_port #(ram_seq_item) agt_ap;

    function new(string name="ram_agent",uvm_component parent=null);
    super.new(name,parent);
    endfunction //new()

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!( uvm_config_db #(ram_config_obj)::get(this , "" , "ram_CFG" , ram_cfg)))
       begin
        `uvm_fatal("build_phase" , "unable to retrieve config in the the agent")
       end
       if(ram_cfg.ram_active==UVM_ACTIVE)begin
        sqr=ram_sequencer::type_id::create("sqr",this);
        drv=ram_driver::type_id::create("drv",this);
       end
        mon=ram_monitor::type_id::create("mon",this);
        agt_ap=new("agt_ap",this);
    endfunction

    
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        if(ram_cfg.ram_active==UVM_ACTIVE)begin
        drv.ram_driver_vif=ram_cfg.ram_config_vif;
        drv.seq_item_port.connect(sqr.seq_item_export);
        end
        mon.ram_vif=ram_cfg.ram_config_vif;
        mon.ram_G_vif=ram_cfg.ram_G_config_vif;
        mon.mon_ap.connect(agt_ap);
    endfunction


endclass //ram_agent extends uvm_agent

    
endpackage