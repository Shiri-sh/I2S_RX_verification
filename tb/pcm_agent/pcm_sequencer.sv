class pcm_sequencer extends uvm_sequencer#(pcm_seq_item);
  
  `uvm_component_utils(pcm_sequencer);
  
  function new(string name="pcm_sequencer",uvm_component parent=null);
    super.new(name,parent);
  endfunction
           
endclass