class cfg_monitor extends uvm_monitor;
  
  `uvm_component_utils(cfg_monitor)
  

   virtual cfg_if vif;


  uvm_analysis_port #(cfg_seq_item) item_collect_port;


  cfg_seq_item trans_collected;   

  function new (string name, uvm_component parent);
    super.new(name, parent);
    item_collect_port = new("item_collect_port", this);
  endfunction

   
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual cfg_if)::get(this, "", "cfg_if_i", vif))
      `uvm_fatal("NO_VIF",{"virtual interface must be set for: ",get_full_name(),".cfg_vif"});
  endfunction

  task run_phase(uvm_phase phase);
    trans_collected = cfg_seq_item::type_id::create("trans_collected", this);
    forever begin
    @(negedge vif.clk);
      if(vif.rstn != 0)
        begin
          collect_result();
        end
    end
  endtask 
  
  task collect_result();
     
     @(posedge vif.clk);
     @(negedge vif.clk);
     
     trans_collected.en = vif.en;
     trans_collected.cfg_ch_single = vif.cfg_ch_single;
     trans_collected.cfg_ch_sel = vif.cfg_ch_sel;
     
     item_collect_port.write(trans_collected);  
     
   endtask
   
endclass 

 
