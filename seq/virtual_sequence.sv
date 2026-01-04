class virtual_sequence extends uvm_sequence;
    
    env env_i;

    cfg_seq_item cfg_item;
  
    cfg_sequence cfg_seq;
    i2s_sequence i2s_seq;
    pcm_sequence pcm_seq;

  `uvm_object_utils(virtual_sequence);

  function new(string name = "virtual_sequence");
    super.new(name);
  endfunction
  
   function void set_env(env env_i);
      this.env_i = env_i;
   endfunction
  
  task pre_body();
      if(starting_phase != null)
        starting_phase.raise_objection(this);
    
      cfg_seq= cfg_sequence::type_id::create("cfg_seq");
      cfg_seq.req=cfg_item;
      i2s_seq = i2s_sequence::type_id::create("i2s_seq");
      i2s_seq.cfg_i = cfg_item;
      pcm_seq = pcm_sequence::type_id::create("pcm_seq");
  endtask
  
  task body();
    fork 
      cfg_seq.start(env_i.cfg_agt.m_seqr_cfg);
      i2s_seq.start(env_i.i2s_agt.m_seqr_i2s);
      pcm_seq.start(env_i.pcm_agt.m_seqr_pcm);
    join
  endtask
  
  task post_body();
    if(starting_phase != null)
      starting_phase.drop_objection(this);
  endtask
endclass