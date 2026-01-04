class cfg_agent extends uvm_agent;
  `uvm_component_utils(cfg_agent);
  
  cfg_driver m_drv_cfg;
  cfg_sequencer m_seqr_cfg;
  cfg_monitor m_mon_cfg;
  
  function new (string name="cfg_agent",uvm_component parent=null);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    m_drv_cfg  =cfg_driver::type_id::create("m_drv_cfg",this);
    m_seqr_cfg =cfg_sequencer::type_id::create("m_seqr_cfg",this);
    m_mon_cfg  =cfg_monitor::type_id::create("m_mon_cfg",this);
  endfunction
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    m_drv_cfg.seq_item_port.connect(m_seqr_cfg.seq_item_export);
  endfunction
endclass