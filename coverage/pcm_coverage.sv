`ifndef PCM_COVERAGE_SV
`define PCM_COVERAGE_SV

class pcm_coverage;

  virtual pcm_if pcm_vif;
  int wait_cnt;

  // --------------------------------------------------
  // Handshake + valid/ready coverage
  // --------------------------------------------------
  covergroup pcm_handshake_cg @(posedge pcm_vif.clk);
    option.per_instance = 1;

    valid_cp : coverpoint pcm_vif.tx_valid {
      bins v0 = {0};
      bins v1 = {1};
    }

    ready_cp : coverpoint pcm_vif.tx_ready {
      bins r0 = {0};
      bins r1 = {1};
    }

    handshake_cp : coverpoint (pcm_vif.tx_valid && pcm_vif.tx_ready) {
      bins handshake = {1};
    }

    valid_ready_cross : cross valid_cp, ready_cp;

  endgroup

  // Wait cycles coverage (valid=1, ready=0)
  covergroup pcm_wait_cg @(posedge pcm_vif.clk);
    option.per_instance = 1;

    wait_cycles : coverpoint wait_cnt {
      bins zero   = {0};
      bins short  = {[1:2]};
      bins mediumm = {[3:7]};
      bins long   = {[8:$]};
    }
  endgroup

  // Data + channel coverage (ONLY on handshake)
  covergroup pcm_data_cg @(posedge pcm_vif.clk
                           iff (pcm_vif.tx_valid && pcm_vif.tx_ready));
    option.per_instance = 1;

    data_cp : coverpoint pcm_vif.tx_data {
      bins zero = {24'h0};
      bins max  = {24'hFFFFFF};
      bins mid  = {[24'h400000:24'hBFFFFF]};
    }

    ch_cp : coverpoint pcm_vif.tx_ch {
      bins left  = {0};
      bins right = {1};
    }

    cross data_cp, ch_cp;
  endgroup

  // --------------------------------------------------
  function new (virtual pcm_if vif);
    pcm_vif = vif;
    wait_cnt = 0;
    pcm_handshake_cg = new();
    pcm_wait_cg      = new();
    pcm_data_cg      = new();
  endfunction

  // --------------------------------------------------
  function void sample();
    if (pcm_vif.tx_valid && !pcm_vif.tx_ready)
      wait_cnt++;
    else
      wait_cnt = 0;
  endfunction
  
  function void report();
    real h_cov, w_cov, d_cov, total;

    h_cov = pcm_handshake_cg.get_coverage();
    w_cov = pcm_wait_cg.get_coverage();
    d_cov = pcm_data_cg.get_coverage();

    total = (h_cov + w_cov + d_cov) / 3.0;

    $display("--------------------------------------------------");
    $display("PCM FUNCTIONAL COVERAGE REPORT");
    $display("Handshake coverage : %0.2f%%", h_cov);
    $display("Wait cycles coverage: %0.2f%%", w_cov);
    $display("Data+Channel coverage: %0.2f%%", d_cov);
    $display("TOTAL PCM COVERAGE  : %0.2f%%", total);
    $display("--------------------------------------------------");
  endfunction
endclass

`endif
