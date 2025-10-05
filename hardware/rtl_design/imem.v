`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// instruction mem of risc-v
//////////////////////////////////////////////////////////////////////////////////


module imem
#(
    parameter DATA_WIDTH  = 32,
    parameter ADDR_WIDTH  = 32,
    parameter IMEM_PATH = "D:/University/KLTN/hw_design/coherence_cache/coherence_cache.srcs/sources_1/new/imem_A.mem"
)
(    
    input   [31:0] i_addr,
    output  [31:0] o_data
);

    (*rom_style = "block" *) reg [31:0] rom[0:255];

    initial begin
        $readmemh(IMEM_PATH, rom);
    end

    assign o_data = rom[i_addr[31:2]]; // word aligned
endmodule

