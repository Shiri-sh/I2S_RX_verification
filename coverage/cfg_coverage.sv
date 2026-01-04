class cfg_coverage;

  covergroup cfg_cg with function sample(
      bit en,
      bit cfg_ch_single,
      bit cfg_ch_sel
  );

    // --- ENABLE ---
    en_cp : coverpoint en {
      bins disabled = {0};
      bins enabled  = {1};
    }

    // --- SINGLE / STEREO ---
    single_cp : coverpoint cfg_ch_single {
      bins stereo = {0};
      bins single = {1};
    }

    // --- CHANNEL SELECT ---
    ch_sel_cp : coverpoint cfg_ch_sel {
      bins ch0 = {0};
      bins ch1 = {1};
    }

    // --- IMPORTANT CROSS ---
    single_ch_cross : cross single_cp, ch_sel_cp {
      ignore_bins stereo_ch_sel =
        binsof(single_cp.stereo);
    }

  endgroup

  function new();
    cfg_cg = new();
  endfunction

  function void sample_item(cfg_seq_item item);
    cfg_cg.sample(item.en, item.cfg_ch_single, item.cfg_ch_sel);
  endfunction

endclass
