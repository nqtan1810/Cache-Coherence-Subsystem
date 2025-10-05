//////////////////////////////////////////////////////////////////////////////////
// this module is used to store data of cache
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ns

module data_ram
#(
    parameter DATA_WIDTH = 32,
    parameter SET_WIDTH = 4,
    parameter WORD_WIDTH = 4, 
    parameter WAY_WIDTH = 2
)
(
    input  clk, rst_n, w_en,
    input  [DATA_WIDTH-1:0] w_data,
    input  [SET_WIDTH + WAY_WIDTH + WORD_WIDTH - 1:0] w_addr,  // address = {set, way, word offset}
    input  [SET_WIDTH + WAY_WIDTH + WORD_WIDTH - 1:0] r_addr1,
    input  [SET_WIDTH + WAY_WIDTH + WORD_WIDTH - 1:0] r_addr2,
    output reg [DATA_WIDTH-1:0] r_data1,
    output reg [DATA_WIDTH-1:0] r_data2
);

    // Memory array declaration
    reg [DATA_WIDTH-1:0] cache [0:2**(SET_WIDTH + WAY_WIDTH + WORD_WIDTH)-1];

    integer i;
    initial for (i=0; i<2**(SET_WIDTH + WAY_WIDTH + WORD_WIDTH); i=i+1) cache[i] = 0;

    // Synchronous Read/Write Logic
    always @(posedge clk) begin
        // Write operation (Modify the selected word in the cache block)
        if (w_en)
            cache[w_addr] <= w_data;
            
        // Read operation (Fetch the selected word from the cache block)        
        if (!rst_n) begin
            r_data1 <= 0;
            r_data2 <= 0;
        end
        else begin
            r_data1 <= cache[r_addr1]; 
            r_data2 <= cache[r_addr2]; 
        end
    end

endmodule