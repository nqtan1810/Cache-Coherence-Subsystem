`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// This is data ram for I-Cache
//////////////////////////////////////////////////////////////////////////////////


module instr_data_ram
#(
    parameter DATA_WIDTH = 32,
    parameter SET_WIDTH  = 4,
    parameter WORD_WIDTH = 4,
    parameter WAY_WIDTH  = 2
)
(
    input  clk,
    input  rst_n,
    input  w_en,
    input  [DATA_WIDTH/8-1:0] w_be,  // Byte enable: 4 bits for 32-bit data
    input  [DATA_WIDTH-1:0] w_data,
    input  [SET_WIDTH + WAY_WIDTH + WORD_WIDTH - 1:0] w_addr,
    input  [SET_WIDTH + WAY_WIDTH + WORD_WIDTH - 1:0] r_addr,
    output reg [DATA_WIDTH-1:0] r_data
);

    localparam ADDR_WIDTH = SET_WIDTH + WAY_WIDTH + WORD_WIDTH;
    localparam NUM_BYTES  = DATA_WIDTH / 8;

    reg [DATA_WIDTH-1:0] cache [0:(2**ADDR_WIDTH)-1];

    integer i, j;
    // Memory initialization (for simulation only)
    initial begin
        for (j = 0; j < (2**ADDR_WIDTH); j = j + 1) begin
            cache[j] = {DATA_WIDTH{1'b0}};
        end
    end
    
    // Read logic (read-first)
    always @(posedge clk) begin
        if (!rst_n) begin
            r_data <= {DATA_WIDTH{1'b0}};
        end else begin
            r_data <= cache[r_addr];
        end
    end

    // Write logic with byte-enable
    always @(posedge clk) begin
        if (w_en) begin
            for (i = 0; i < NUM_BYTES; i = i + 1) begin
                if (w_be[i]) begin
                    cache[w_addr][i*8 +: 8] <= w_data[i*8 +: 8];
                end
            end
        end
    end
    
endmodule
