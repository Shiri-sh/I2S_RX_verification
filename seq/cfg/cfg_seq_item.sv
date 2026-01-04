class cfg_seq_item extends uvm_sequence_item;

    rand bit en;
    rand bit cfg_ch_single;
    rand bit cfg_ch_sel;

  `uvm_object_utils_begin(cfg_seq_item);
        `uvm_field_int(en,UVM_DEFAULT)
   		`uvm_field_int(cfg_ch_single,UVM_DEFAULT)
 		`uvm_field_int(cfg_ch_sel,UVM_DEFAULT)
  `uvm_object_utils_end

    function new(string name = "cfg_seq_item");
        super.new(name);
    endfunction

endclass