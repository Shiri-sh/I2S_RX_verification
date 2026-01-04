interface pcm_if (input bit clk, input bit rstn);

    logic        tx_valid;
    logic        tx_ready;
    logic        tx_ch;
    logic [23:0] tx_data;  
  
 
  //  tx_valid must stay high until handshake
  property valid_stays_high_until_handshake;
    @(posedge clk)
    disable iff (!rstn)
    tx_valid && !tx_ready |=> tx_valid;
  endproperty

  assert property (valid_stays_high_until_handshake)
    else $error("ASSERT_VALID: tx_valid dropped before handshake");

  //  tx_data and tx_ch must remain stable while waiting
  property data_stable_while_waiting;
    @(posedge clk)
    disable iff (!rstn)
    tx_valid && !tx_ready |=> 
      ($stable(tx_data) && $stable(tx_ch));
  endproperty

  assert property (data_stable_while_waiting)
    else $error("ASSERT_DATA: tx_data or tx_ch changed before handshake");


endinterface