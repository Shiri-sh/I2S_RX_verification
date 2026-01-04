class pcm_monitor extends uvm_monitor;
  
  `uvm_component_utils(pcm_monitor)

   virtual pcm_if vif;

  uvm_analysis_port #(pcm_seq_item) item_collect_port_out;

  pcm_seq_item trans_collected;   
  pcm_coverage pcm_cov;
  
  function new (string name, uvm_component parent);
    super.new(name, parent);
    item_collect_port_out = new("item_collect_port_out", this);
  endfunction

   
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
       
    if(!uvm_config_db#(virtual pcm_if)::get(this, "", "pcm_if_i", vif))
      `uvm_fatal("NO_VIF",{"virtual interface must be set for: ",get_full_name(),".pcm_vif"});
     pcm_cov = new(vif);

  endfunction
  
   task run_phase(uvm_phase phase);
    forever begin
      @(posedge vif.clk);
       pcm_cov.sample();

      if (vif.tx_valid && vif.tx_ready) begin
        pcm_seq_item item;
        item = pcm_seq_item::type_id::create("item");
        
        item.tx_data = vif.tx_data;
        item.tx_ch   = vif.tx_ch;
        item.tx_valid =vif.tx_valid;
        item.tx_ready=vif.tx_ready;
        
        item_collect_port_out.write(item);
      end
    end
  endtask
  
 function void final_phase(uvm_phase phase);
    super.final_phase(phase);
    pcm_cov.report();
 endfunction
endclass 

 
