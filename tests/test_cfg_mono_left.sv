class test_cfg_mono_left extends uvm_test;
  `uvm_component_utils(test_cfg_mono_left);
  
  env env_i;
  virtual_sequence vir_seq_i;
  cfg_sequence cfg_seq_i;
  i2s_sequence i2s_seq_i;
  pcm_sequence pcm_seq_i;

  
  function new(string name="test_cfg_mono_left",uvm_component parent=null);
    super.new(name,parent);
  endfunction
  
   function void build_phase(uvm_phase phase);
     super.build_phase(phase);
    // uvm_root::get().set_global_seed($urandom);
     
     env_i = env::type_id::create("env_i", this);
     vir_seq_i=virtual_sequence::type_id::create("vir_seq_i",this);
     
     vir_seq_i.cfg_item = cfg_seq_item::type_id::create("cfg_item");
     vir_seq_i.cfg_item.cfg_ch_single=1'b1;
     vir_seq_i.cfg_item.cfg_ch_sel=1'b0;
     vir_seq_i.cfg_item.en=1'b1;
     
   endfunction
  

  function void  start_of_simulation_phase(uvm_phase phase);
    vir_seq_i.set_env(env_i);

  endfunction
  
  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    #150;
    vir_seq_i.start(null);
  
    phase.drop_objection(this);
  endtask 
endclass