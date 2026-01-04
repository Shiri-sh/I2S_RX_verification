class pcm_seq_item extends uvm_sequence_item;
    rand bit        tx_ready;
    bit        tx_valid;
    bit        tx_ch;
    bit [23:0] tx_data;
    
  rand bit [4:0] num_clk_dly;

  `uvm_object_utils_begin(pcm_seq_item);
        `uvm_field_int(tx_ready,UVM_DEFAULT)
   		`uvm_field_int(tx_valid,UVM_DEFAULT)
 		`uvm_field_int(tx_ch,UVM_DEFAULT)
 		`uvm_field_int(tx_data,UVM_DEFAULT)
        `uvm_field_int(num_clk_dly,UVM_DEFAULT) 

  `uvm_object_utils_end

    function new(string name = "pcm_seq_item");
        super.new(name);
    endfunction
  
  constraint valid_dly {num_clk_dly > 0;}

endclass