`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// data RAM for Main Memory, supports only 16-bit address for word access, write-first
//////////////////////////////////////////////////////////////////////////////////

module ram
#(
    parameter DATA_WIDTH  = 32,
    parameter ADDR_WIDTH  = 16,
    parameter INIT_PATH   = "D:/University/KLTN/hw_design/coherence_cache/coherence_cache.srcs/sources_1/new/mem_init.mem"
)
(
    input                           clk, 
    input                           rst_n,

    // write port
    input                           w_en,
    input       [ADDR_WIDTH-1:0]    w_addr,
    input       [DATA_WIDTH-1:0]    w_data,
    
    // read port
    input                           r_en,
    input       [ADDR_WIDTH-1:0]    r_addr,
    output  reg [DATA_WIDTH-1:0]    r_data
);

    // Single-port block RAM (1 write, 1 read)
    (* ram_style = "block" *) reg [DATA_WIDTH-1:0] mem [0:2**ADDR_WIDTH-1];

    // Load memory content for simulation
    initial begin
        $readmemh(INIT_PATH, mem);
    end

    // Write logic
    always @(posedge clk) begin
        if (w_en) begin
            mem[w_addr] <= w_data;
        end
    end

    // Read logic
    always @(posedge clk) begin
        if (!rst_n) begin
            r_data <= 0;
        end else if (r_en) begin
            r_data <= mem[r_addr];
        end
    end

endmodule
