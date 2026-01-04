class i2s_sequence  extends uvm_sequence #(i2s_seq_item);
   `uvm_object_utils(i2s_sequence)
  
    cfg_seq_item cfg_i;
  function new(string name = "i2s_sequence");
      super.new(name);
  endfunction

    task pre_body();
        if(starting_phase != null)
          starting_phase.raise_objection(this);
    endtask

     task body();
       i2s_seq_item req;
       repeat(8) begin
         //`uvm_do(req);
         req=i2s_seq_item::type_id::create("req");
         assert(req.randomize()); 
//          `uvm_info(get_type_name(),"in sequence i2s ", UVM_NONE)
//          req.print();
         if(cfg_i.en===0)begin
           `uvm_info(get_type_name(),"dont send req because en=0:", UVM_NONE)
            return;
         end
         if(cfg_i.cfg_ch_single===1)begin
           if(cfg_i.cfg_ch_sel===1)begin
             //if the cfg is mono and right is chosen
             `uvm_info(get_type_name(),"right channel", UVM_NONE)
             req.channel_op=2'b01;
           end
           else begin
             //if the cfg is mono and left is chosen
             `uvm_info(get_type_name(),"left channel", UVM_NONE)
             req.channel_op=2'b00;
           end
         end
         else begin
           //sterio ->both chanells
           req.channel_op=2'b10;
         end
         
          start_item(req);
          finish_item(req);
        end
     endtask
  
    task post_body();
        if(starting_phase != null)
          starting_phase.drop_objection(this);
    endtask

  
endclass