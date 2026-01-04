class pcm_driver extends uvm_driver#(pcm_seq_item);
  `uvm_component_utils(pcm_driver);
  
  virtual pcm_if vif;
  
  function new(string name="pcm_driver",uvm_component parent=null);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
     super.build_phase(phase);
    
    if(!uvm_config_db#(virtual pcm_if)::get(this,"","pcm_if_i",vif))
      `uvm_error("NO_VIF",{"virtual interface must be set for: ",get_full_name(),".pcm_if_i"})

  endfunction
  
  task run_phase(uvm_phase phase);
     wait(vif.rstn==1);
     @(posedge vif.clk);

     vif.tx_ready <= 1'b0;
      forever begin
        seq_item_port.get_next_item(req);

        vif.tx_ready <=req.tx_ready;

        repeat(req.num_clk_dly) @(posedge vif.clk);

        seq_item_port.item_done();
      end
  endtask
endclass