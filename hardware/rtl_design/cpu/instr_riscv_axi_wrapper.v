`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// axi wrapper for instruction access
//////////////////////////////////////////////////////////////////////////////////


module instr_riscv_axi_wrapper
#(
    parameter ID          = 0,
    parameter DATA_WIDTH  = 32,
    parameter ADDR_WIDTH  = 32,
    parameter ID_WIDTH    = 2,
    parameter USER_WIDTH  = 4,
    parameter STRB_WIDTH  = (DATA_WIDTH/8),
    parameter ADDR_START  = 32'h0000_0000, // start address of code region
    parameter ADDR_END    = 32'h0000_03FF  // end address of code region
)
(
    // system signals
    input                           ACLK,
    input                           ARESETn,
    
    // enable
    input                           enable,
    
    // Interface connect with D-Cache
    // D-Cache enable
    output                          i_CACHE_EN,
    
    // AXI5 Interface
    // AW Channel
    output reg [ID_WIDTH-1:0]       i_AWID,
    output reg [ADDR_WIDTH-1:0]     i_AWADDR,
    output reg [7:0]                i_AWLEN,
    output reg [2:0]                i_AWSIZE,
    output reg [1:0]                i_AWBURST,
    output reg                      i_AWLOCK,
    output reg [3:0]                i_AWCACHE,
    output reg [2:0]                i_AWPROT,
    output reg [3:0]                i_AWQOS,
    output reg [3:0]                i_AWREGION,
    output reg [USER_WIDTH-1:0]     i_AWUSER,
    output reg                      i_AWVALID,
    input                           i_AWREADY,
    
    // W Channel
    output reg [DATA_WIDTH-1:0]     i_WDATA,
    output reg [STRB_WIDTH-1:0]     i_WSTRB, 
    output reg                      i_WLAST,
    output reg [USER_WIDTH-1:0]     i_WUSER,
    output reg                      i_WVALID,
    input                           i_WREADY,
    
    // B Channel
    input  [ID_WIDTH-1:0]           i_BID,
    input  [1:0]                    i_BRESP,
    input  [USER_WIDTH-1:0]         i_BUSER,
    input                           i_BVALID,
    output reg                      i_BREADY,
   
    // AR Channel
    output reg [ID_WIDTH-1:0]       i_ARID,
    output reg [ADDR_WIDTH-1:0]     i_ARADDR,
    output reg [7:0]                i_ARLEN,
    output reg [2:0]                i_ARSIZE,
    output reg [1:0]                i_ARBURST,
    output reg                      i_ARLOCK,
    output reg [3:0]                i_ARCACHE,
    output reg [2:0]                i_ARPROT,
    output reg [3:0]                i_ARQOS,
    output reg [3:0]                i_ARREGION,
    output reg [USER_WIDTH-1:0]     i_ARUSER,
    output reg                      i_ARVALID,
    input                           i_ARREADY,
    
    // R Channel
    input  [ID_WIDTH-1:0]           i_RID,
    input  [DATA_WIDTH-1:0]         i_RDATA,
    input  [1:0]                    i_RRESP,
    input                           i_RLAST,
    input  [USER_WIDTH-1:0]	        i_RUSER,
    input                           i_RVALID,
    output reg                      i_RREADY,
    
    // interface connect with Instruction Mem
    input                           i_imem_access,  // should asserted every cycle
    input                           i_r0w1,         // only used read operation
    input [ADDR_WIDTH-1:0]          i_pc,           // address to load instruction
    input [DATA_WIDTH-1:0]          i_w_data        // should be not used as instruction is read-only
);

    // state definition
    localparam  IDLE   = 0;
    localparam  W_ADDR = 1;
    localparam  W_DATA = 3;
    localparam  W_RESP = 2;
    localparam  R_ADDR = 4;
    localparam  R_DATA = 5;
    
    reg [2:0] state;
    reg [2:0] next_state;
    
    // assgining
    assign i_CACHE_EN = 1;
    
    // state transition
    always @(posedge ACLK) begin
        if (!ARESETn) begin
            state <= IDLE;
        end
        else begin
            state <= next_state;
        end
    end
    
    // next state
    always @(*) begin
        case (state)
            IDLE    : next_state = (enable & i_imem_access) ? (i_r0w1 ? W_ADDR : R_ADDR) : IDLE;
            W_ADDR  : next_state = i_AWREADY ? W_DATA : W_ADDR;
            W_DATA  : next_state = i_WREADY ? W_RESP : W_DATA;
            W_RESP  : next_state = i_BVALID ? IDLE : W_RESP;
            R_ADDR  : next_state = i_ARREADY ? R_DATA : R_ADDR;
            R_DATA  : next_state = i_RVALID ? IDLE : R_DATA;
            default : next_state = IDLE;
        endcase
    end
    
    // output
    always @(*) begin
        case (state)
            IDLE    : begin
                // AW Channel
                i_AWID      = ID;
                i_AWADDR    = 0;
                i_AWLEN     = 0;
                i_AWSIZE    = 0;
                i_AWBURST   = 0;
                i_AWLOCK    = 0;
                i_AWCACHE   = 0;
                i_AWPROT    = 0;
                i_AWQOS     = 0;
                i_AWREGION  = 0;
                i_AWUSER    = 0;
                i_AWVALID   = 0;
                
                // W Channel
                i_WDATA     = 0;
                i_WSTRB     = 0; 
                i_WLAST     = 0;
                i_WUSER     = 0;
                i_WVALID    = 0;
                
                // B Channel
                i_BREADY    = 0;
               
                // AR Channel
                i_ARID      = ID;
                i_ARADDR    = 0;
                i_ARLEN     = 0;
                i_ARSIZE    = 0;
                i_ARBURST   = 0;
                i_ARLOCK    = 0;
                i_ARCACHE   = 0;
                i_ARPROT    = 0;
                i_ARQOS     = 0;
                i_ARREGION  = 0;
                i_ARUSER    = 0;
                i_ARVALID   = 0;
                
                // R Channel
                i_RREADY    = 0;
            end
            W_ADDR  : begin
                // AW Channel
                i_AWID      = ID;
                i_AWADDR    = ADDR_START | i_pc;
                i_AWLEN     = 0;
                i_AWSIZE    = 3'h2;
                i_AWBURST   = 2'h1;
                i_AWLOCK    = 0;
                i_AWCACHE   = 4'hF;
                i_AWPROT    = 0;
                i_AWQOS     = 0;
                i_AWREGION  = 0;
                i_AWUSER    = 0;
                i_AWVALID   = 1;
                
                // W Channel
                i_WDATA     = 0;
                i_WSTRB     = 0; 
                i_WLAST     = 0;
                i_WUSER     = 0;
                i_WVALID    = 0;
                
                // B Channel
                i_BREADY    = 0;
               
                // AR Channel
                i_ARID      = ID;
                i_ARADDR    = 0;
                i_ARLEN     = 0;
                i_ARSIZE    = 0;
                i_ARBURST   = 0;
                i_ARLOCK    = 0;
                i_ARCACHE   = 0;
                i_ARPROT    = 0;
                i_ARQOS     = 0;
                i_ARREGION  = 0;
                i_ARUSER    = 0;
                i_ARVALID   = 0;
                
                // R Channel
                i_RREADY    = 0;
            end
            W_DATA  : begin
                // AW Channel
                i_AWID      = ID;
                i_AWADDR    = 0;
                i_AWLEN     = 0;
                i_AWSIZE    = 0;
                i_AWBURST   = 0;
                i_AWLOCK    = 0;
                i_AWCACHE   = 0;
                i_AWPROT    = 0;
                i_AWQOS     = 0;
                i_AWREGION  = 0;
                i_AWUSER    = 0;
                i_AWVALID   = 0;
                
                // W Channel
                i_WDATA     = i_w_data;
                i_WSTRB     = 4'hF; 
                i_WLAST     = 1;
                i_WUSER     = 0;
                i_WVALID    = 1;
                
                // B Channel
                i_BREADY    = 0;
               
                // AR Channel
                i_ARID      = ID;
                i_ARADDR    = 0;
                i_ARLEN     = 0;
                i_ARSIZE    = 0;
                i_ARBURST   = 0;
                i_ARLOCK    = 0;
                i_ARCACHE   = 0;
                i_ARPROT    = 0;
                i_ARQOS     = 0;
                i_ARREGION  = 0;
                i_ARUSER    = 0;
                i_ARVALID   = 0;
                
                // R Channel
                i_RREADY    = 0;
            end
            W_RESP  : begin
                // AW Channel
                i_AWID      = ID;
                i_AWADDR    = 0;
                i_AWLEN     = 0;
                i_AWSIZE    = 0;
                i_AWBURST   = 0;
                i_AWLOCK    = 0;
                i_AWCACHE   = 0;
                i_AWPROT    = 0;
                i_AWQOS     = 0;
                i_AWREGION  = 0;
                i_AWUSER    = 0;
                i_AWVALID   = 0;
                
                // W Channel
                i_WDATA     = 0;
                i_WSTRB     = 0; 
                i_WLAST     = 0;
                i_WUSER     = 0;
                i_WVALID    = 0;
                
                // B Channel
                i_BREADY    = 1;
               
                // AR Channel
                i_ARID      = ID;
                i_ARADDR    = 0;
                i_ARLEN     = 0;
                i_ARSIZE    = 0;
                i_ARBURST   = 0;
                i_ARLOCK    = 0;
                i_ARCACHE   = 0;
                i_ARPROT    = 0;
                i_ARQOS     = 0;
                i_ARREGION  = 0;
                i_ARUSER    = 0;
                i_ARVALID   = 0;
                
                // R Channel
                i_RREADY    = 0;
            end
            R_ADDR  : begin
                // AW Channel
                i_AWID      = ID;
                i_AWADDR    = 0;
                i_AWLEN     = 0;
                i_AWSIZE    = 0;
                i_AWBURST   = 0;
                i_AWLOCK    = 0;
                i_AWCACHE   = 0;
                i_AWPROT    = 0;
                i_AWQOS     = 0;
                i_AWREGION  = 0;
                i_AWUSER    = 0;
                i_AWVALID   = 0;
                
                // W Channel
                i_WDATA     = 0;
                i_WSTRB     = 0; 
                i_WLAST     = 0;
                i_WUSER     = 0;
                i_WVALID    = 0;
                
                // B Channel
                i_BREADY    = 0;
               
                // AR Channel
                i_ARID      = ID;
                i_ARADDR    = ADDR_START | i_pc;
                i_ARLEN     = 0;
                i_ARSIZE    = 3'h2;
                i_ARBURST   = 2'h1;
                i_ARLOCK    = 0;
                i_ARCACHE   = 4'hF;
                i_ARPROT    = 0;
                i_ARQOS     = 0;
                i_ARREGION  = 0;
                i_ARUSER    = 0;
                i_ARVALID   = 1;
                
                // R Channel
                i_RREADY    = 0;
            end
            R_DATA  : begin
                // AW Channel
                i_AWID      = ID;
                i_AWADDR    = 0;
                i_AWLEN     = 0;
                i_AWSIZE    = 0;
                i_AWBURST   = 0;
                i_AWLOCK    = 0;
                i_AWCACHE   = 0;
                i_AWPROT    = 0;
                i_AWQOS     = 0;
                i_AWREGION  = 0;
                i_AWUSER    = 0;
                i_AWVALID   = 0;
                
                // W Channel
                i_WDATA     = 0;
                i_WSTRB     = 0; 
                i_WLAST     = 0;
                i_WUSER     = 0;
                i_WVALID    = 0;
                
                // B Channel
                i_BREADY    = 0;
               
                // AR Channel
                i_ARID      = ID;
                i_ARADDR    = 0;
                i_ARLEN     = 0;
                i_ARSIZE    = 0;
                i_ARBURST   = 0;
                i_ARLOCK    = 0;
                i_ARCACHE   = 0;
                i_ARPROT    = 0;
                i_ARQOS     = 0;
                i_ARREGION  = 0;
                i_ARUSER    = 0;
                i_ARVALID   = 0;
                
                // R Channel
                i_RREADY    = 1;
            end
            default : begin
                // AW Channel
                i_AWID      = ID;
                i_AWADDR    = 0;
                i_AWLEN     = 0;
                i_AWSIZE    = 0;
                i_AWBURST   = 0;
                i_AWLOCK    = 0;
                i_AWCACHE   = 0;
                i_AWPROT    = 0;
                i_AWQOS     = 0;
                i_AWREGION  = 0;
                i_AWUSER    = 0;
                i_AWVALID   = 0;
                
                // W Channel
                i_WDATA     = 0;
                i_WSTRB     = 0; 
                i_WLAST     = 0;
                i_WUSER     = 0;
                i_WVALID    = 0;
                
                // B Channel
                i_BREADY    = 0;
               
                // AR Channel
                i_ARID      = ID;
                i_ARADDR    = 0;
                i_ARLEN     = 0;
                i_ARSIZE    = 0;
                i_ARBURST   = 0;
                i_ARLOCK    = 0;
                i_ARCACHE   = 0;
                i_ARPROT    = 0;
                i_ARQOS     = 0;
                i_ARREGION  = 0;
                i_ARUSER    = 0;
                i_ARVALID   = 0;
                
                // R Channel
                i_RREADY    = 0;
            end
        endcase
    end

endmodule
