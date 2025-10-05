`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 
//////////////////////////////////////////////////////////////////////////////////


module riscv_axi_wrapper
#(
    parameter ID          = 0,
    parameter DATA_WIDTH  = 32,
    parameter ADDR_WIDTH  = 32,
    parameter ID_WIDTH    = 2,
    parameter USER_WIDTH  = 4,
    parameter STRB_WIDTH  = (DATA_WIDTH/8),
    parameter SHAREABLE_REGION_START = 32'h0000_1000, // start address of shareable region
    parameter SHAREABLE_REGION_END   = 32'h0003_FFFF  // end address of shareable region
)
(
    // system signals
    input                           ACLK,
    input                           ARESETn,
    
    // Interface connect with D-Cache
    // D-Cache enable
    output                          d_CACHE_EN,
    
    // AXI5 Interface
    // AW Channel
    output reg [ID_WIDTH-1:0]       d_AWID,
    output reg [ADDR_WIDTH-1:0]     d_AWADDR,
    output reg [7:0]                d_AWLEN,
    output reg [2:0]                d_AWSIZE,
    output reg [1:0]                d_AWBURST,
    output reg                      d_AWLOCK,
    output reg [3:0]                d_AWCACHE,
    output reg [2:0]                d_AWPROT,
    output reg [3:0]                d_AWQOS,
    output reg [3:0]                d_AWREGION,
    output reg [USER_WIDTH-1:0]     d_AWUSER,
    output reg [1:0]                d_AWDOMAIN,
    output reg                      d_AWVALID,
    input                           d_AWREADY,
    
    // W Channel
    output reg [DATA_WIDTH-1:0]     d_WDATA,
    output reg [STRB_WIDTH-1:0]     d_WSTRB, 
    output reg                      d_WLAST,
    output reg [USER_WIDTH-1:0]     d_WUSER,
    output reg                      d_WVALID,
    input                           d_WREADY,
    
    // B Channel
    input  [ID_WIDTH-1:0]           d_BID,
    input  [1:0]                    d_BRESP,
    input  [USER_WIDTH-1:0]         d_BUSER,
    input                           d_BVALID,
    output reg                      d_BREADY,
   
    // AR Channel
    output reg [ID_WIDTH-1:0]       d_ARID,
    output reg [ADDR_WIDTH-1:0]     d_ARADDR,
    output reg [7:0]                d_ARLEN,
    output reg [2:0]                d_ARSIZE,
    output reg [1:0]                d_ARBURST,
    output reg                      d_ARLOCK,
    output reg [3:0]                d_ARCACHE,
    output reg [2:0]                d_ARPROT,
    output reg [3:0]                d_ARQOS,
    output reg [3:0]                d_ARREGION,
    output reg [USER_WIDTH-1:0]     d_ARUSER,
    output reg [1:0]                d_ARDOMAIN,
    output reg                      d_ARVALID,
    input                           d_ARREADY,
    
    // R Channel
    input  [ID_WIDTH-1:0]           d_RID,
    input  [DATA_WIDTH-1:0]         d_RDATA,
    input  [1:0]                    d_RRESP,
    input                           d_RLAST,
    input  [USER_WIDTH-1:0]	        d_RUSER,
    input                           d_RVALID,
    output reg                      d_RREADY,
    
    // interface connect with Data Ram
    input                           i_write_dmem,
    input   [31:0]                  i_waddr_dmem,
    input   [31:0]                  i_wdata_dmem,
    
    input                           i_read_dmem,
    input   [31:0]                  i_raddr_dmem,
    
    input                           i_ls_b,
    input                           i_ls_h
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
    assign d_CACHE_EN = 1;
    
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
            IDLE    : next_state = i_write_dmem ? W_ADDR : (i_read_dmem ? R_ADDR : IDLE);
            W_ADDR  : next_state = d_AWREADY ? W_DATA : W_ADDR;
            W_DATA  : next_state = d_WREADY ? W_RESP : W_DATA;
            W_RESP  : next_state = d_BVALID ? IDLE : W_RESP;
            R_ADDR  : next_state = d_ARREADY ? R_DATA : R_ADDR;
            R_DATA  : next_state = d_RVALID ? IDLE : R_DATA;
            default : next_state = IDLE;
        endcase
    end
    
    // output
    always @(*) begin
        case (state)
            IDLE    : begin
                // AW Channel
                d_AWID      = ID;
                d_AWADDR    = 0;
                d_AWLEN     = 0;
                d_AWSIZE    = 0;
                d_AWBURST   = 0;
                d_AWLOCK    = 0;
                d_AWCACHE   = 0;
                d_AWPROT    = 0;
                d_AWQOS     = 0;
                d_AWREGION  = 0;
                d_AWUSER    = 0;
                d_AWDOMAIN  = 0;
                d_AWVALID   = 0;
                
                // W Channel
                d_WDATA     = 0;
                d_WSTRB     = 0; 
                d_WLAST     = 0;
                d_WUSER     = 0;
                d_WVALID    = 0;
                
                // B Channel
                d_BREADY    = 0;
               
                // AR Channel
                d_ARID      = ID;
                d_ARADDR    = 0;
                d_ARLEN     = 0;
                d_ARSIZE    = 0;
                d_ARBURST   = 0;
                d_ARLOCK    = 0;
                d_ARCACHE   = 0;
                d_ARPROT    = 0;
                d_ARQOS     = 0;
                d_ARREGION  = 0;
                d_ARUSER    = 0;
                d_ARDOMAIN  = 0;
                d_ARVALID   = 0;
                
                // R Channel
                d_RREADY    = 0;
            end
            W_ADDR  : begin
                // AW Channel
                d_AWID      = ID;
                d_AWADDR    = i_waddr_dmem;
                d_AWLEN     = 0;
                d_AWSIZE    = i_ls_b ? 3'h0 : (i_ls_h ? 3'h1 : 3'h2);
                d_AWBURST   = 2'h1;
                d_AWLOCK    = 0;
                d_AWCACHE   = 4'hF;
                d_AWPROT    = 0;
                d_AWQOS     = 0;
                d_AWREGION  = 0;
                d_AWUSER    = 0;
                d_AWDOMAIN  = (i_waddr_dmem >= SHAREABLE_REGION_START && i_waddr_dmem <= SHAREABLE_REGION_END) ? 2'b10 : 2'b00;
                d_AWVALID   = 1;
                
                // W Channel
                d_WDATA     = 0;
                d_WSTRB     = 0; 
                d_WLAST     = 0;
                d_WUSER     = 0;
                d_WVALID    = 0;
                
                // B Channel
                d_BREADY    = 0;
               
                // AR Channel
                d_ARID      = ID;
                d_ARADDR    = 0;
                d_ARLEN     = 0;
                d_ARSIZE    = 0;
                d_ARBURST   = 0;
                d_ARLOCK    = 0;
                d_ARCACHE   = 0;
                d_ARPROT    = 0;
                d_ARQOS     = 0;
                d_ARREGION  = 0;
                d_ARUSER    = 0;
                d_ARDOMAIN  = 0;
                d_ARVALID   = 0;
                
                // R Channel
                d_RREADY    = 0;
            end
            W_DATA  : begin
                // AW Channel
                d_AWID      = ID;
                d_AWADDR    = 0;
                d_AWLEN     = 0;
                d_AWSIZE    = 0;
                d_AWBURST   = 0;
                d_AWLOCK    = 0;
                d_AWCACHE   = 0;
                d_AWPROT    = 0;
                d_AWQOS     = 0;
                d_AWREGION  = 0;
                d_AWUSER    = 0;
                d_AWDOMAIN  = 0;
                d_AWVALID   = 0;
                
                // W Channel
                d_WDATA     = i_wdata_dmem << ((i_waddr_dmem & 32'h3) * 8);
                d_WSTRB     = (i_ls_b ? 4'h1 : (i_ls_h ? 4'h3 : 4'hF)) << (i_waddr_dmem & 32'h3); 
                d_WLAST     = 1;
                d_WUSER     = 0;
                d_WVALID    = 1;
                
                // B Channel
                d_BREADY    = 0;
               
                // AR Channel
                d_ARID      = ID;
                d_ARADDR    = 0;
                d_ARLEN     = 0;
                d_ARSIZE    = 0;
                d_ARBURST   = 0;
                d_ARLOCK    = 0;
                d_ARCACHE   = 0;
                d_ARPROT    = 0;
                d_ARQOS     = 0;
                d_ARREGION  = 0;
                d_ARUSER    = 0;
                d_ARDOMAIN  = 0;
                d_ARVALID   = 0;
                
                // R Channel
                d_RREADY    = 0;
            end
            W_RESP  : begin
                // AW Channel
                d_AWID      = ID;
                d_AWADDR    = 0;
                d_AWLEN     = 0;
                d_AWSIZE    = 0;
                d_AWBURST   = 0;
                d_AWLOCK    = 0;
                d_AWCACHE   = 0;
                d_AWPROT    = 0;
                d_AWQOS     = 0;
                d_AWREGION  = 0;
                d_AWUSER    = 0;
                d_AWDOMAIN  = 0;
                d_AWVALID   = 0;
                
                // W Channel
                d_WDATA     = 0;
                d_WSTRB     = 0; 
                d_WLAST     = 0;
                d_WUSER     = 0;
                d_WVALID    = 0;
                
                // B Channel
                d_BREADY    = 1;
               
                // AR Channel
                d_ARID      = ID;
                d_ARADDR    = 0;
                d_ARLEN     = 0;
                d_ARSIZE    = 0;
                d_ARBURST   = 0;
                d_ARLOCK    = 0;
                d_ARCACHE   = 0;
                d_ARPROT    = 0;
                d_ARQOS     = 0;
                d_ARREGION  = 0;
                d_ARUSER    = 0;
                d_ARDOMAIN  = 0;
                d_ARVALID   = 0;
                
                // R Channel
                d_RREADY    = 0;
            end
            R_ADDR  : begin
                // AW Channel
                d_AWID      = ID;
                d_AWADDR    = 0;
                d_AWLEN     = 0;
                d_AWSIZE    = 0;
                d_AWBURST   = 0;
                d_AWLOCK    = 0;
                d_AWCACHE   = 0;
                d_AWPROT    = 0;
                d_AWQOS     = 0;
                d_AWREGION  = 0;
                d_AWUSER    = 0;
                d_AWDOMAIN  = 0;
                d_AWVALID   = 0;
                
                // W Channel
                d_WDATA     = 0;
                d_WSTRB     = 0; 
                d_WLAST     = 0;
                d_WUSER     = 0;
                d_WVALID    = 0;
                
                // B Channel
                d_BREADY    = 0;
               
                // AR Channel
                d_ARID      = ID;
                d_ARADDR    = i_raddr_dmem;
                d_ARLEN     = 0;
                d_ARSIZE    = i_ls_b ? 3'h0 : (i_ls_h ? 3'h1 : 3'h2);
                d_ARBURST   = 2'h1;
                d_ARLOCK    = 0;
                d_ARCACHE   = 4'hF;
                d_ARPROT    = 0;
                d_ARQOS     = 0;
                d_ARREGION  = 0;
                d_ARUSER    = 0;
                d_ARDOMAIN  = (i_raddr_dmem >= SHAREABLE_REGION_START && i_raddr_dmem <= SHAREABLE_REGION_END) ? 2'b10 : 2'b00;
                d_ARVALID   = 1;
                
                // R Channel
                d_RREADY    = 0;
            end
            R_DATA  : begin
                // AW Channel
                d_AWID      = ID;
                d_AWADDR    = 0;
                d_AWLEN     = 0;
                d_AWSIZE    = 0;
                d_AWBURST   = 0;
                d_AWLOCK    = 0;
                d_AWCACHE   = 0;
                d_AWPROT    = 0;
                d_AWQOS     = 0;
                d_AWREGION  = 0;
                d_AWUSER    = 0;
                d_AWDOMAIN  = 0;
                d_AWVALID   = 0;
                
                // W Channel
                d_WDATA     = 0;
                d_WSTRB     = 0; 
                d_WLAST     = 0;
                d_WUSER     = 0;
                d_WVALID    = 0;
                
                // B Channel
                d_BREADY    = 0;
               
                // AR Channel
                d_ARID      = ID;
                d_ARADDR    = 0;
                d_ARLEN     = 0;
                d_ARSIZE    = 0;
                d_ARBURST   = 0;
                d_ARLOCK    = 0;
                d_ARCACHE   = 0;
                d_ARPROT    = 0;
                d_ARQOS     = 0;
                d_ARREGION  = 0;
                d_ARUSER    = 0;
                d_ARDOMAIN  = 0;
                d_ARVALID   = 0;
                
                // R Channel
                d_RREADY    = 1;
            end
            default : begin
                // AW Channel
                d_AWID      = ID;
                d_AWADDR    = 0;
                d_AWLEN     = 0;
                d_AWSIZE    = 0;
                d_AWBURST   = 0;
                d_AWLOCK    = 0;
                d_AWCACHE   = 0;
                d_AWPROT    = 0;
                d_AWQOS     = 0;
                d_AWREGION  = 0;
                d_AWUSER    = 0;
                d_AWDOMAIN  = 0;
                d_AWVALID   = 0;
                
                // W Channel
                d_WDATA     = 0;
                d_WSTRB     = 0; 
                d_WLAST     = 0;
                d_WUSER     = 0;
                d_WVALID    = 0;
                
                // B Channel
                d_BREADY    = 0;
               
                // AR Channel
                d_ARID      = ID;
                d_ARADDR    = 0;
                d_ARLEN     = 0;
                d_ARSIZE    = 0;
                d_ARBURST   = 0;
                d_ARLOCK    = 0;
                d_ARCACHE   = 0;
                d_ARPROT    = 0;
                d_ARQOS     = 0;
                d_ARREGION  = 0;
                d_ARUSER    = 0;
                d_ARDOMAIN  = 0;
                d_ARVALID   = 0;
                
                // R Channel
                d_RREADY    = 0;
            end
        endcase
    end

endmodule
