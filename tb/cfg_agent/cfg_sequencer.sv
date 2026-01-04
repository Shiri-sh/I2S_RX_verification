class cfg_sequencer extends uvm_sequencer#(cfg_seq_item);
  
  `uvm_component_utils(cfg_sequencer);
  
  function new(string name="cfg_sequencer",uvm_component parent=null);
    super.new(name,parent);
  endfunction
           
endclass