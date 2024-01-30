package SPI_test_pkg;
//for the SPI
    import  SPI_config_pkg::*;
    import uvm_pkg::*;
    import SPI_main_seq1::*;
    import SPI_main_seq2::*;
    import SPI_main_seq3::*;
    import SPI_main_seq4::*;
    import SPI_reset_seq::*;
    `include "uvm_macros.svh"
    import SPI_env_pkg::*;
    //RAM req packs
    import  ram_config_pkg::*;
    import uvm_pkg::*;
    import ram_main_seq1::*;
    import ram_main_seq2::*;
    import ram_main_seq3::*;
    import ram_reset_seq::*;
    import ram_env_pkg::*;
    
    class SPI_test extends uvm_test;
    //regester the class to the factory
    `uvm_component_utils(SPI_test)
    //for the SPI
    SPI_env SPI_env_obj;
    SPI_config_obj SPI_config_obj_test;
    virtual SPI_if SPI_test_vif;
    SPI_main_seq1 S_main_seq1;
    SPI_main_seq2 S_main_seq2;
    SPI_main_seq3 S_main_seq3;
    SPI_main_seq4 S_main_seq4;
    SPI_reset_seq S_reset_seq;
    //for the RAM
    ram_env ram_env_obj;
    ram_config_obj ram_config_obj_test;
    virtual ram_if ram_test_vif;
    

        function new(string name ="SPI_test",uvm_component parent=null);
        super.new(name,parent);
        endfunction //new()
        //building phase
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            //building the SPI requirments
            SPI_env_obj=SPI_env::type_id::create("SPI_env_obj",this);
            SPI_config_obj_test=SPI_config_obj::type_id::create("SPI_cfg",this);
            S_main_seq1=SPI_main_seq1::type_id::create("S_main_seq1",this);
            S_main_seq2=SPI_main_seq2::type_id::create("S_main_seq2",this);
            S_main_seq3=SPI_main_seq3::type_id::create("S_main_seq3",this);
            S_main_seq4=SPI_main_seq4::type_id::create("S_main_seq4",this);
            S_reset_seq=SPI_reset_seq::type_id::create("S_reset_seq",this);
            SPI_config_obj_test.SPI_active=UVM_ACTIVE;

            if(!uvm_config_db#(virtual SPI_wrapper_if)::get(this,"","wrapper_IF",SPI_config_obj_test.SPI_config_vif))
            `uvm_fatal("build_phase","test _unable to get the virtual inteface of the SPI from the uvm_config_dp");

             if(!uvm_config_db#(virtual SPI_wrapper_G_if)::get(this,"","wrapper_G_IF",SPI_config_obj_test.SPI_G_config_vif))
            `uvm_fatal("build_phase","test _unable to get the virtual inteface of the SPI from the uvm_config_dp");

            uvm_config_db#(SPI_config_obj)::set (this,"*","SPI_CFG",SPI_config_obj_test);

            //building the ram requirments
            ram_env_obj=ram_env::type_id::create("ram_env_obj",this);
            ram_config_obj_test=ram_config_obj::type_id::create("ram_cfg",this);
            ram_config_obj_test.ram_active=UVM_PASSIVE;

            if(!uvm_config_db#(virtual ram_if)::get(this,"","ram_IF",ram_config_obj_test.ram_config_vif))
            `uvm_fatal("build_phase","test _unable to get the virtual inteface of the ram from the uvm_config_dp");

            if(!uvm_config_db#(virtual ram_G_if)::get(this,"","ram_G_IF",ram_config_obj_test.ram_G_config_vif))
            `uvm_fatal("build_phase","test _unable to get the virtual inteface of the ram from the uvm_config_dp");

            uvm_config_db#(ram_config_obj)::set (this,"*","ram_CFG",ram_config_obj_test);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            
            phase.raise_objection(this);
            //SPI
            if(SPI_config_obj_test.SPI_active==UVM_ACTIVE)begin
            //reset seq
            `uvm_info("run_phase","reset asserted",UVM_LOW)
            S_reset_seq.start(SPI_env_obj.agt.sqr);
            `uvm_info("run_phase","reset deasserted",UVM_LOW)
            //main seq
            `uvm_info("run_phase","stimulus generation started",UVM_LOW)
            //first seq
            S_main_seq1.start(SPI_env_obj.agt.sqr);
            //second seq
            S_main_seq2.start(SPI_env_obj.agt.sqr);
            //third seq
            S_main_seq3.start(SPI_env_obj.agt.sqr);
            //forth seq
            S_main_seq4.start(SPI_env_obj.agt.sqr);
            `uvm_info("run_phase","stimulus generation ended",UVM_LOW)
            end
            
            phase.drop_objection(this);

        endtask //run_phase
    
    endclass //SPI_test
    
endpackage