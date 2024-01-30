package ram_test_pkg;
//for the ram
    import  ram_config_pkg::*;
    import uvm_pkg::*;
    import main_seq1::*;
    import main_seq2::*;
    import main_seq3::*;
    import reset_seq::*;

    `include "uvm_macros.svh"
    import ram_env_pkg::*;
    
    class ram_test extends uvm_test;
    //regester the class to the factory
    `uvm_component_utils(ram_test)
    //for the ram
    ram_env ram_env_obj;
    ram_config_obj ram_config_obj_test;
    virtual ram_if ram_test_vif;
    ram_main_seq1 main_seq1;
    ram_main_seq2 main_seq2;
    ram_main_seq3 main_seq3;
    ram_reset_seq reset_seq;

        function new(string name ="ram_test",uvm_component parent=null);
        super.new(name,parent);
        endfunction //new()
        //building phase
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            //building the ram requirments
            ram_env_obj=ram_env::type_id::create("ram_env_obj",this);
            ram_config_obj_test=ram_config_obj::type_id::create("ram_cfg",this);
            main_seq1=ram_main_seq1::type_id::create("main_seq1",this);
            main_seq2=ram_main_seq2::type_id::create("main_seq2",this);
            main_seq3=ram_main_seq3::type_id::create("main_seq3",this);
            reset_seq=ram_reset_seq::type_id::create("reset_seq",this);
            ram_config_obj_test.ram_active=UVM_ACTIVE;
            if(!uvm_config_db#(virtual ram_if)::get(this,"","ram_IF",ram_config_obj_test.ram_config_vif))
            `uvm_fatal("build_phase","test _unable to get the virtual inteface of the ram from the uvm_config_dp");

            if(!uvm_config_db#(virtual ram_G_if)::get(this,"","ram_G_IF",ram_config_obj_test.ram_G_config_vif))
            `uvm_fatal("build_phase","test _unable to get the virtual inteface of the ram from the uvm_config_dp");

            uvm_config_db#(ram_config_obj)::set (this,"*","ram_CFG",ram_config_obj_test);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            
            phase.raise_objection(this);
            //ram
            if(ram_config_obj_test.ram_active==UVM_ACTIVE)begin
            //reset seq
            `uvm_info("run_phase","reset asserted",UVM_LOW)
            reset_seq.start(ram_env_obj.agt.sqr);
            `uvm_info("run_phase","reset deasserted",UVM_LOW)
            //main seq
            `uvm_info("run_phase","stimulus generation started",UVM_LOW)
            //first seq
            main_seq1.start(ram_env_obj.agt.sqr);
            //second seq
            main_seq2.start(ram_env_obj.agt.sqr);
             //third seq
            main_seq3.start(ram_env_obj.agt.sqr);
            `uvm_info("run_phase","stimulus generation ended",UVM_LOW)
            end
            phase.drop_objection(this);

        endtask //run_phase
    
    endclass //ram_test
    
endpackage