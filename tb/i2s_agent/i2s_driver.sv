class i2s_driver extends uvm_driver#(i2s_seq_item);
  `uvm_component_utils(i2s_driver);
  
  virtual i2s_if vif;
  bit cur_ws;
  bit first;
  i2s_coverage i2s_cov;
  function new(string name="i2s_driver",uvm_component parent=null);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
     super.build_phase(phase);
    if(!uvm_config_db#(virtual i2s_if)::get(this,"","i2s_if_i",vif))
       `uvm_error("NO_VIF",{"virtual interface must be set for: ",get_full_name(),".i2s_if_i"})
    i2s_cov=new();
  endfunction
  
  task run_phase(uvm_phase phase);
    wait(vif.rstn);
    @(posedge vif.clk);

    vif.ws_i <= 0;
    vif.sd_i <= 0;
    cur_ws<=0;
    first<=1;
    
    forever begin
      seq_item_port.get_next_item(req);
      drive_data(req);
      seq_item_port.item_done();
    end
  endtask
  
    task drive_data(i2s_seq_item req);
      vif.ws_i <= cur_ws;

      @(posedge vif.clk);
      req.ws_i=vif.ws_i;

      if(req.channel_op===cur_ws||req.channel_op===2)begin
        
        i2s_cov.sample_item(req);

        for (int i = 23; i >= 0; i--) begin
          vif.sd_i <= req.send_data[i];
          @(posedge vif.clk);
        end
        
         `uvm_info("I2S_DRV",$sformatf("Sent data=%0h", req.send_data),UVM_LOW)
        
        repeat (7) begin
          vif.sd_i<=0;
          @(posedge vif.clk);
        end
       
      end
      else begin
          `uvm_info("I2S_DRV",$sformatf("no data send because channel cfg is= %0d and current ws=%0d",req.channel_op,cur_ws),UVM_LOW)
          repeat(32) @(posedge vif.clk);
      end
      cur_ws<= ~cur_ws;
      
    endtask
     function void final_phase(uvm_phase phase);
        super.final_phase(phase);
        i2s_cov.report();
     endfunction
endclass