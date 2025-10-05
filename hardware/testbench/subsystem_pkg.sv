`ifndef SUBSYSTEM_PKG_SV
`define SUBSYSTEM_PKG_SV

package subsystem_pkg;
    localparam DATA_WIDTH = 32;
    localparam ADDR_WIDTH = 32;
    
    // for instruction mem
    typedef struct packed {
        bit [ADDR_WIDTH-1:0] addr;
        bit [DATA_WIDTH-1:0] data;
        bit instr_type;
    } instruction_s;
    
    typedef struct packed {
        bit [ADDR_WIDTH-1:0] addr;
        bit [15:0][DATA_WIDTH-1:0] data;
        bit instr_type;
    } instruction_16_s;
    
    // for read/write trans from/to Cache L2
    typedef struct {
        bit [ADDR_WIDTH-1:0] addr;
        bit [15:0][DATA_WIDTH-1:0] data;
    } cache_block_s;
    
    // for read trans from CPU
    typedef struct packed {
        bit [ADDR_WIDTH-1:0] addr;
        bit [DATA_WIDTH-1:0] data;
    } cache_word_s;
endpackage

`endif