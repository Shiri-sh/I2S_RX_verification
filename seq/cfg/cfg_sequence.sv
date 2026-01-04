class cfg_sequence  extends uvm_sequence #(cfg_seq_item);
  `uvm_object_utils(cfg_sequence)
 
  function new(string name = "cfg_sequence");
    super.new(name);
  endfunction
  cfg_seq_item req;

  task pre_body();
      if(starting_phase != null)
        starting_phase.raise_objection(this);
  endtask

 task body();
   //repeat(10) begin
   //  `uvm_do(req);
   // end
    start_item(req);
    finish_item(req);
 endtask
  
  task post_body();
      if(starting_phase != null)
        starting_phase.drop_objection(this);
  endtask

  
endclass