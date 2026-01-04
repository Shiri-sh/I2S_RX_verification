class i2s_agent extends uvm_agent;
  `uvm_component_utils(i2s_agent);
  
  i2s_driver m_drv_i2s;
  i2s_sequencer m_seqr_i2s;
  i2s_monitor m_mon_i2s;
  
  function new (string name="i2s_agent",uvm_component parent=null);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    m_drv_i2s  =i2s_driver::type_id::create("m_drv_i2s",this);
    m_seqr_i2s =i2s_sequencer::type_id::create("m_seqr_i2s",this);
    m_mon_i2s  =i2s_monitor::type_id::create("m_mon_i2s",this);
  endfunction
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    m_drv_i2s.seq_item_port.connect(m_seqr_i2s.seq_item_export);
  endfunction
endclass