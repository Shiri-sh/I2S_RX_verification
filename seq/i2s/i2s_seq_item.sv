class i2s_seq_item extends uvm_sequence_item;

    rand bit [23:0] send_data;
    bit [1:0] channel_op;
    bit ws_i;
  
  `uvm_object_utils_begin(i2s_seq_item);
    `uvm_field_int(ws_i,UVM_DEFAULT)
    `uvm_field_int(channel_op,UVM_DEFAULT)
    `uvm_field_int(send_data,UVM_DEFAULT)
  `uvm_object_utils_end

    function new(string name = "i2s_seq_item");
        super.new(name);
    endfunction

endclass