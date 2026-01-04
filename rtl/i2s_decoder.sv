module I2S_DECODER #(
    parameter DATA_WIDTH = 24
)(
    input  logic clk, rstn, en,
    input  logic ws_i, sd_i,
    output logic [DATA_WIDTH-1:0] left_word_o,
    output logic [DATA_WIDTH-1:0] right_word_o,
    output logic left_word_valid_o,
    output logic right_word_valid_o
);

    logic ws_dly;
    logic [$clog2(DATA_WIDTH+1)-1:0] bit_cnt;
    logic [DATA_WIDTH-1:0] shift_reg;

    always_ff @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            ws_dly              <= 1'bx;
            bit_cnt             <= '0;
            shift_reg           <= '0;
            left_word_valid_o   <= 1'b0;
            right_word_valid_o  <= 1'b0;
        end
        else if (en) begin
            ws_dly             <= ws_i;
            left_word_valid_o  <= 1'b0;
            right_word_valid_o <= 1'b0;

            // Detect WS edge
           if (ws_i !== ws_dly)
                bit_cnt <= '0;
            else if (bit_cnt < DATA_WIDTH)
                bit_cnt <= bit_cnt + 1'b1;

            // Shift data
            if (bit_cnt < DATA_WIDTH)
                shift_reg <= {shift_reg[DATA_WIDTH-2:0], sd_i};

            // Word complete
            if (bit_cnt == DATA_WIDTH-1) begin
                if (ws_i == 1'b0) begin
                    left_word_o       <= {shift_reg[DATA_WIDTH-2:0], sd_i};
                    left_word_valid_o <= 1'b1;
                end
                else begin
                    right_word_o       <= {shift_reg[DATA_WIDTH-2:0], sd_i};
                    right_word_valid_o <= 1'b1;
                end
            end
        end
    end
endmodule