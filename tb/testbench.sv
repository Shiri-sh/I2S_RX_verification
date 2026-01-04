
import uvm_pkg::*;

`include "pkg.sv"

module top;
  
  bit clk =0;
  always #50 clk = ~clk;

  bit rstn = 1;
  
  initial begin
    rstn = 0;
    #100;
    rstn = 1;
  end
  
  cfg_if cfg_if_i();
  assign cfg_if_i.clk = clk;
  assign cfg_if_i.rstn = rstn;

  i2s_if i2s_if_i(clk,rstn);
  pcm_if pcm_if_i(clk,rstn);
  
  
  I2R_RX 
   #(
     .DATA_WIDTH(24)
  )
  I2R_RX_i(  
    .clk(cfg_if_i.clk),
    .rstn(cfg_if_i.rstn),
    .en(cfg_if_i.en),
    .cfg_ch_single(cfg_if_i.cfg_ch_single),
    .cfg_ch_sel(cfg_if_i.cfg_ch_sel),
    
    .ws_i(i2s_if_i.ws_i),
    .sd_i(i2s_if_i.sd_i),
    
    .tx_ready(pcm_if_i.tx_ready),
    .tx_valid(pcm_if_i.tx_valid),
    .tx_data(pcm_if_i.tx_data),
    .tx_ch(pcm_if_i.tx_ch)
  );
  
  initial begin
    uvm_config_db#(virtual i2s_if)::set(null,"*","i2s_if_i",i2s_if_i);
    $dumpvars(0, top);
    uvm_config_db#(virtual pcm_if)::set(null,"*","pcm_if_i",pcm_if_i);
    $dumpvars(0, top);
    uvm_config_db#(virtual cfg_if)::set(null,"*","cfg_if_i",cfg_if_i);
    $dumpvars(0, top);
  end
  
  initial begin
    //run_test("test_enable");
    run_test("test_cfg_sterio");
    // run_test("test_cfg_mono_right");
    // run_test("test_cfg_mono_left");

  end
endmodule