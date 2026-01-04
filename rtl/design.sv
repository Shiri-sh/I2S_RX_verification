`include "i2s_decoder.sv"
module I2R_RX #(
    parameter DATA_WIDTH = 24
)(
    input  logic rstn, clk, en,
    input  logic cfg_ch_single, cfg_ch_sel,
    input  logic ws_i, sd_i,
    input  logic tx_ready,
    output logic tx_valid,
    output logic tx_ch,
    output logic [DATA_WIDTH-1:0] tx_data
);

    localparam LEFT  = 1'b0;
    localparam RIGHT = 1'b1;

    // Decoder outputs
    logic [DATA_WIDTH-1:0] l_word, r_word;
    logic l_valid, r_valid;

    I2S_DECODER #(.DATA_WIDTH(DATA_WIDTH)) decoder_inst (
        .clk(clk),
        .rstn(rstn),
        .en(en),
        .ws_i(ws_i),
        .sd_i(sd_i),
        .left_word_o(l_word),
        .right_word_o(r_word),
        .left_word_valid_o(l_valid),
        .right_word_valid_o(r_valid)
    );

    // Internal buffer (1-deep queue)
    logic [DATA_WIDTH-1:0] buf_data;
    logic buf_valid;
    logic buf_ch;

    always_ff @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            tx_valid  <= 1'b0;
            tx_data   <= '0;
            tx_ch     <= 1'b0;
            buf_valid <= 1'b0;
            buf_data  <= '0;
            buf_ch    <= 1'b0;
        end
        else if (en) begin

            // 1. Handshake: consume output
            if (tx_valid && tx_ready) begin
                tx_valid  <= 1'b0;
                buf_valid <= 1'b0; // buffer consumed
            end

            // 2. Capture from I2S into buffer
            if (!buf_valid) begin
                if (cfg_ch_single) begin
                    if (cfg_ch_sel == LEFT && l_valid) begin
                        buf_data  <= l_word;
                        buf_ch    <= LEFT;
                        buf_valid <= 1'b1;
                    end
                    else if (cfg_ch_sel == RIGHT && r_valid) begin
                        buf_data  <= r_word;
                        buf_ch    <= RIGHT;
                        buf_valid <= 1'b1;
                    end
                end
                else begin
                    // DUAL mode: prioritize LEFT then RIGHT
                    if (l_valid) begin
                        buf_data  <= l_word;
                        buf_ch    <= LEFT;
                        buf_valid <= 1'b1;
                    end
                    else if (r_valid) begin
                        buf_data  <= r_word;
                        buf_ch    <= RIGHT;
                        buf_valid <= 1'b1;
                    end
                end
            end

            // 3. Drive PCM interface
           if (!tx_valid && buf_valid) begin
    tx_data  <= buf_data;
    tx_ch    <= buf_ch;
    tx_valid <= 1'b1;
end
else if (tx_valid && tx_ready) begin
    tx_valid  <= 1'b0;
    buf_valid <= 1'b0; 
end
        end
    end
endmodule