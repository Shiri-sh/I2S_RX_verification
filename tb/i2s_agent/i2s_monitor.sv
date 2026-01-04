class i2s_monitor extends uvm_monitor;
  
  `uvm_component_utils(i2s_monitor)
  

   virtual i2s_if vif;


  uvm_analysis_port #(i2s_seq_item) item_collect_port;


  i2s_seq_item trans_collected;   
  bit [23:0] temp_send_data;
  
  function new (string name, uvm_component parent);
    super.new(name, parent);
    item_collect_port = new("item_collect_port", this);
  endfunction

   
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual i2s_if)::get(this, "", "i2s_if_i", vif))
      `uvm_fatal("NO_VIF",{"virtual interface must be set for: ",get_full_name(),".i2s_vif"});
  endfunction
 
   

  task run_phase(uvm_phase phase);
    i2s_seq_item item;
    logic prev_ws;
     bit first;
     prev_ws = 1'bx;

    forever begin

      @(posedge vif.clk);

      if (vif.rstn && (vif.ws_i !== prev_ws)) begin
        
          item = i2s_seq_item::type_id::create("item",this);

          item.send_data = 24'b0;
        
          @(posedge vif.clk);
        
          for (int i = 0; i < 24; i++) begin
            item.send_data = { item.send_data[22:0], vif.sd_i };
            @(posedge vif.clk);
          end

            `uvm_info("I2S_MON",
                      $sformatf("Collected data hex=%06h, channel=%0d",
                item.send_data,
                vif.ws_i ),
      UVM_LOW)
          item.ws_i=vif.ws_i;
          item_collect_port.write(item);
          prev_ws = vif.ws_i;
        end
    end
  endtask
   
endclass 

 
