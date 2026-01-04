class pcm_sequence  extends uvm_sequence #(pcm_seq_item);
  `uvm_object_utils(pcm_sequence)
 
  function new(string name = "pcm_sequence");
    super.new(name);
  endfunction
  
  task pre_body();
      if(starting_phase != null)
        starting_phase.raise_objection(this);
  endtask

 task body();
   pcm_seq_item req;
   repeat(24) begin
     `uvm_do(req);
    end
 endtask
  
  task post_body();
      if(starting_phase != null)
        starting_phase.drop_objection(this);
  endtask
endclass