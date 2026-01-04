class env extends uvm_env;
  `uvm_component_utils(env);
  
  scoreboard m_scrb;
  
  pcm_agent pcm_agt;
  cfg_agent cfg_agt;
  i2s_agent i2s_agt;

  function new(string name="env",uvm_component parent=null);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    m_scrb=scoreboard::type_id::create("m_scrb",this);
    pcm_agt=pcm_agent::type_id::create("pcm_agt",this);
    cfg_agt=cfg_agent::type_id::create("cfg_agt",this);
    i2s_agt=i2s_agent::type_id::create("i2s_agt",this);
  endfunction
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    pcm_agt.m_mon_pcm.item_collect_port_out.connect(m_scrb.pcm_actual_imp);
    
 //   pcm_agt.m_mon_pcm.item_collect_port_in.connect(m_scrb.pcm_expected_imp);
    i2s_agt.m_mon_i2s.item_collect_port.connect(m_scrb.i2s_expected_imp);
    cfg_agt.m_mon_cfg.item_collect_port.connect(m_scrb.cfg_expected_imp);
    
  endfunction

endclass