class scoreboard extends uvm_scoreboard;
  `uvm_component_utils(scoreboard);
  
  `uvm_analysis_imp_decl(_actual)
  `uvm_analysis_imp_decl(_cfg_expected)
  `uvm_analysis_imp_decl(_i2s_expected)

  
  uvm_analysis_imp_actual #(pcm_seq_item,scoreboard) pcm_actual_imp;
  
  uvm_analysis_imp_i2s_expected  #(i2s_seq_item,scoreboard) i2s_expected_imp;
  uvm_analysis_imp_cfg_expected  #(cfg_seq_item,scoreboard) cfg_expected_imp;

  cfg_seq_item cfg_item;

  i2s_seq_item exp;
  
  i2s_seq_item  i2s_q_data_in[$];

  
  function new(string name="scoreboard",uvm_component parent=null);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_type_name(),"in scoreboard:", UVM_NONE)

    pcm_actual_imp=new ("pcm_actual_imp",this);
    
    i2s_expected_imp=new ("i2s_expected_imp",this);
    cfg_expected_imp=new ("cfg_expected_imp",this);
    
  endfunction
  
  function void write_cfg_expected(cfg_seq_item item);
    cfg_item=item;
  endfunction
  
  function void write_i2s_expected(i2s_seq_item item);
    
    if(!cfg_item.cfg_ch_single || item.ws_i==cfg_item.cfg_ch_sel)
       i2s_q_data_in.push_back(item);
    $display("size of i2s queue=%0d",i2s_q_data_in.size());
  endfunction
  
  function void write_actual(pcm_seq_item item);
    
    $display("write actual");

    if(cfg_item.en===0)
      `uvm_error("EN_LOW",$sformatf("pcm data recieve but en = 0"),UVM_LOW);
    
    if(i2s_q_data_in.size()==0)begin
      `uvm_error("Mismatch_data",$sformatf("pcm data recieve but no i2s data was sent!"),UVM_LOW);
    end
     else begin
       exp = i2s_q_data_in.pop_front();
       compare(exp,item);
     end
  endfunction
  
  function void compare(i2s_seq_item i2s_item, pcm_seq_item pcm_item_out);
       $display("--------------------compare----------------------");
    
       i2s_item.print();
       pcm_item_out.print();
    
       if(i2s_item.send_data !== pcm_item_out.tx_data) begin
         `uvm_error("Mismatch_data",$sformatf("send_data=%0h  but tx_data=%0h (expected equals)",
                     i2s_item.send_data,
                     pcm_item_out.tx_data));
       end
       if(cfg_item.cfg_ch_single && !(pcm_item_out.tx_ch==cfg_item.cfg_ch_sel)) begin 
      `uvm_error("Mismatch_ch", $sformatf("cfg_ch_sel=%0d but tx_ch=%0d",
                     cfg_item.cfg_ch_sel,
                     pcm_item_out.tx_ch));
       end
  endfunction
  
  function void final_phase(uvm_phase phase);
    super.final_phase(phase);

    if (i2s_q_data_in.size() != 0) begin
      `uvm_warning("SCOREBOARD",
        $sformatf("I2S queue not empty at end of simulation! Remaining items = %0d",
                  i2s_q_data_in.size()))
    end
    else begin
      `uvm_info("SCOREBOARD",
        "I2S queue empty at end of simulation – all data returned",
        UVM_LOW)
    end
  endfunction
endclass