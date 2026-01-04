class pcm_agent extends uvm_agent;
  `uvm_component_utils(pcm_agent);
  
  pcm_driver m_drv_pcm;
  pcm_sequencer m_seqr_pcm;
  pcm_monitor m_mon_pcm;
  
  function new (string name="pcm_agent",uvm_component parent=null);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    m_drv_pcm  =pcm_driver::type_id::create("m_drv_pcm",this);
    m_seqr_pcm =pcm_sequencer::type_id::create("m_seqr_pcm",this);
    m_mon_pcm  =pcm_monitor::type_id::create("m_mon_pcm",this);
  endfunction
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    m_drv_pcm.seq_item_port.connect(m_seqr_pcm.seq_item_export);
  endfunction
endclass