class cfg_driver extends uvm_driver#(cfg_seq_item);
  `uvm_component_utils(cfg_driver);
  
  virtual cfg_if vif;
  
  function new(string name="cfg_driver",uvm_component parent=null);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
     super.build_phase(phase);
    
    if(!uvm_config_db#(virtual cfg_if)::get(this,"","cfg_if_i",vif))
       `uvm_error("NO_VIF",{"virtual interface must be set for: ",get_full_name(),".cfg_if_i"})
    
  endfunction
  
  task run_phase(uvm_phase phase);
    forever begin
      wait(vif.rstn==1);
      seq_item_port.get_next_item(req);
      drive_data();
      seq_item_port.item_done();
    end
  endtask
  
  task drive_data();
    req.print();
    vif.en<=req.en;
    vif.cfg_ch_single <=req.cfg_ch_single;
    vif.cfg_ch_sel <=req.cfg_ch_sel;
  //  repeat(20) @(posedge vif.clk);
  endtask  
endclass