class test_enable extends uvm_test;
  `uvm_component_utils(test_enable);
  
  env env_i;
  virtual_sequence vir_seq_i;
  cfg_seq_item cfg_i;
  cfg_sequence cfg_seq_i;
  cfg_sequence cfg_seq_disable;
  i2s_sequence i2s_seq_i;
  pcm_sequence pcm_seq_i;

  
  function new(string name="test_enable",uvm_component parent=null);
    super.new(name,parent);
  endfunction
  
   function void build_phase(uvm_phase phase);
     super.build_phase(phase);
    // uvm_root::get().set_global_seed($urandom);
     
     env_i = env::type_id::create("env_i", this);
     
     cfg_seq_i= cfg_sequence::type_id::create("cfg_seq_i", this);
     
     cfg_i = cfg_seq_item::type_id::create("cfg_item");

     cfg_i.cfg_ch_single=1'b1;
     cfg_i.cfg_ch_sel=1'b1;
     cfg_i.en=1'b1;

     cfg_seq_i.req=cfg_i;
     
     pcm_seq_i= pcm_sequence::type_id::create("pcm_seq_i", this);
     
     i2s_seq_i= i2s_sequence::type_id::create("i2s_seq_i", this);
     i2s_seq_i.cfg_i = cfg_i;
     
   endfunction

  function void  start_of_simulation_phase(uvm_phase phase);
      super.start_of_simulation_phase (phase);
  endfunction
  
  task run_phase(uvm_phase phase);
    $display("test_enable");
    phase.raise_objection(this);
    #150;
    cfg_seq_i.start(env_i.cfg_agt.m_seqr_cfg);
    fork
        i2s_seq_i.start(env_i.i2s_agt.m_seqr_i2s);
        pcm_seq_i.start(env_i.pcm_agt.m_seqr_pcm);
    join_none
    #10000;

    cfg_i.en = 1'b0;

    cfg_seq_disable = cfg_sequence::type_id::create("cfg_seq_disable",this);
    cfg_seq_disable.req = cfg_i;
    cfg_seq_disable.start(env_i.cfg_agt.m_seqr_cfg);

    #15000
    phase.drop_objection(this);
  endtask 
endclass