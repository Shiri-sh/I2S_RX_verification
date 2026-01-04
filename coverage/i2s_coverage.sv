class i2s_coverage;

  covergroup i2s_cg with function sample(
      bit [23:0] send_data,
      bit [1:0]  channel_op,
      bit        ws_i
  );

    // --- DATA ---
    send_data_cp : coverpoint send_data {
      bins zero        = {24'h0};
      bins max         = {24'hFFFFFF};
      bins mid         = {[24'h100000 : 24'hEFFFFF]};
      bins random[]    = default;
    }

//     // --- CHANNEL OP ---
//     channel_op_cp : coverpoint channel_op {
//       bins left        = {2'b00};
//       bins right       = {2'b01};
//       bins both        = {2'b10};
//       bins illegal     = default;
//     }

    // --- WS ---
    ws_cp : coverpoint ws_i {
      bins left_ws     = {0};
      bins right_ws    = {1};
    }

//     --- CROSS ---
//     channel_ws_cross : cross channel_op_cp, ws_cp;

  endgroup

  function new();
    i2s_cg = new();
  endfunction

  function void sample_item(i2s_seq_item item);
    i2s_cg.sample(item.send_data, item.channel_op, item.ws_i);
  endfunction
  
 function void report();
  real data_cov;
  real ws_cov;
 // real cross_cov;
  real total;

  data_cov  = i2s_cg.send_data_cp.get_coverage();
  ws_cov    = i2s_cg.ws_cp.get_coverage();
 // cross_cov = i2s_cg.channel_ws_cross.get_coverage();

   total = (data_cov  + ws_cov ) / 2.0;

  $display("--------------------------------------------------");
  $display("I2S FUNCTIONAL COVERAGE REPORT");
  $display("Send data coverage        : %0.2f%%", data_cov);
//  $display("Channel operation coverage: %0.2f%%", ch_cov);
  $display("WS coverage               : %0.2f%%", ws_cov);
 // $display("Channel x WS coverage     : %0.2f%%", cross_cov);
  $display("TOTAL I2S COVERAGE        : %0.2f%%", total);
  $display("--------------------------------------------------");
endfunction
endclass
