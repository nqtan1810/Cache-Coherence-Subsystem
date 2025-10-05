//=====================================================================================================
// This is controller of Write port in ACE, support three transactions: WriteNoSnoop, WriteBack
//=====================================================================================================

`timescale 1ns/1ns

module ACE_Controller_W
#(
    parameter DATA_WIDTH  = 32,
    parameter ADDR_WIDTH  = 32,
    parameter ID_WIDTH    = 1,
    parameter USER_WIDTH  = 4,
    parameter STRB_WIDTH  = (DATA_WIDTH/8)
)
(
    /********* System signals *********/
	input                       ACLK,
	input      	                ARESETn,
	
	// input
	// AW Channel
    input  [ID_WIDTH-1:0]       i_AWID, // use default value: 0x0
    input  [ADDR_WIDTH-1:0]     i_AWADDR,
    input  [7:0]                i_AWLEN,
    input  [2:0]                i_AWSIZE,  // use default value: Data bus width = 32-bit -> AWSIZE = 0x2
    input  [1:0]                i_AWBURST, // use default value: 0x1, INCR
    input                       i_AWLOCK,
    input  [3:0]                i_AWCACHE,
    input  [2:0]                i_AWPROT,
    input  [3:0]                i_AWQOS,
    input  [3:0]                i_AWREGION,
    input  [USER_WIDTH-1:0]     i_AWUSER,   
    input  [1:0]                i_AWDOMAIN,
    input  [2:0]                i_AWSNOOP,
    input                       i_AWVALID,
    input                       i_AWREADY,
    
    // W Channel
    // output  s_WID,  // use default value: 0x0
    input  [DATA_WIDTH-1:0]     i_WDATA,
    input  [STRB_WIDTH-1:0]     i_WSTRB,  // use default value: 0xF
    input                       i_WLAST,
    input  [USER_WIDTH-1:0]     i_WUSER,
    input                       i_WVALID,
    input                       i_WREADY,
    
    // B Channel
    input   [ID_WIDTH-1:0]      i_BID,  // use default value: 0x0
    input   [1:0]               i_BRESP,  
    input	[USER_WIDTH-1:0]    i_BUSER,
    input                       i_BVALID,
    input                       i_BREADY,
    
    // output
    // AW Channel
    output  reg [ID_WIDTH-1:0]       o_AWID, // use default value: 0x0
    output  reg [ADDR_WIDTH-1:0]     o_AWADDR,
    output  reg [7:0]                o_AWLEN,
    output  reg [2:0]                o_AWSIZE,  // use default value: Data bus width = 32-bit -> AWSIZE = 0x2
    output  reg [1:0]                o_AWBURST, // use default value: 0x1, INCR
    output  reg                      o_AWLOCK,
    output  reg [3:0]                o_AWCACHE,
    output  reg [2:0]                o_AWPROT,
    output  reg [3:0]                o_AWQOS,
    output  reg [3:0]                o_AWREGION,
    output  reg [USER_WIDTH-1:0]     o_AWUSER,   
    // output  reg [1:0]                o_AWDOMAIN,
    // output  reg [2:0]                o_AWSNOOP,
    output  reg                      o_AWVALID,
    output  reg                      o_AWREADY,
    
    // W Channel
    // output  s_WID,  // use default value: 0x0
    output  reg [DATA_WIDTH-1:0]     o_WDATA,
    output  reg [STRB_WIDTH-1:0]     o_WSTRB,  // use default value: 0xF
    output  reg                      o_WLAST,
    output  reg [USER_WIDTH-1:0]     o_WUSER,
    output  reg                      o_WVALID,
    output  reg                      o_WREADY,
    
    // B Channel
    output  reg [ID_WIDTH-1:0]       o_BID,  // use default value: 0x0
    output  reg [1:0]                o_BRESP,  
    output	reg [USER_WIDTH-1:0]     o_BUSER,
    output  reg                      o_BVALID,
    output  reg                      o_BREADY,
    
    // for fix WB_hit_mis bug
    output                      is_shareable_busy_WB,
    output     [ADDR_WIDTH-1:0] current_shareable_AWADDR
);
    
    // state define
    localparam IDLE     = 0;
    localparam S_W_ADDR = 1;
    localparam S_W_DATA = 2;
    localparam S_W_RESP = 3;
    
    // state for Write Channel
    reg [1:0] w_state, w_next_state;
    
    // output for buffer enable
    reg aw_buffer_en;
    reg [ADDR_WIDTH-1:0] AWADDR_reg;
    reg [1:0] AWDOMAIN_reg;
    reg [2:0] AWSNOOP_reg;
    
    // for fix WB_hit_mis bug
    assign is_shareable_busy_WB = w_state != IDLE && (AWDOMAIN_reg == 1 || AWDOMAIN_reg == 2);
    assign current_shareable_AWADDR = AWADDR_reg;
    
    always @(*) begin
        case(w_state)
            IDLE    : w_next_state = i_AWVALID ? S_W_ADDR : IDLE;
            S_W_ADDR: w_next_state = (i_AWVALID && o_AWREADY) ? S_W_DATA : S_W_ADDR;
            S_W_DATA: w_next_state = (i_WVALID && o_WREADY && i_WLAST) ? S_W_RESP : S_W_DATA;
            S_W_RESP: w_next_state = (o_BVALID && i_BREADY) ? IDLE : S_W_RESP;
            default : w_next_state = IDLE;
        endcase
    end
    
    always @(posedge ACLK) begin
        if (!ARESETn) begin
            w_state <= IDLE;
        end
        else begin
            w_state <= w_next_state;
        end
    end
    
    always @(*) begin
        if(w_state == S_W_ADDR || w_state == S_W_DATA || w_state == S_W_RESP) begin
            // AW Channel
            o_AWID      = ((AWDOMAIN_reg == 0 && AWSNOOP_reg == 0) || ((AWDOMAIN_reg != 3) && AWSNOOP_reg == 3)) ? i_AWID    : 0; // use default value: 0x0
            o_AWADDR    = ((AWDOMAIN_reg == 0 && AWSNOOP_reg == 0) || ((AWDOMAIN_reg != 3) && AWSNOOP_reg == 3)) ? i_AWADDR  : 0;
            o_AWLEN     = ((AWDOMAIN_reg == 0 && AWSNOOP_reg == 0) || ((AWDOMAIN_reg != 3) && AWSNOOP_reg == 3)) ? i_AWLEN   : 0;
            o_AWSIZE    = ((AWDOMAIN_reg == 0 && AWSNOOP_reg == 0) || ((AWDOMAIN_reg != 3) && AWSNOOP_reg == 3)) ? i_AWSIZE  : 0;  // use default value: Data bus width = 32-bit -> AWSIZE = 0x2
            o_AWBURST   = ((AWDOMAIN_reg == 0 && AWSNOOP_reg == 0) || ((AWDOMAIN_reg != 3) && AWSNOOP_reg == 3)) ? i_AWBURST : 0; // use default value: 0x1, INCR
            o_AWLOCK    = ((AWDOMAIN_reg == 0 && AWSNOOP_reg == 0) || ((AWDOMAIN_reg != 3) && AWSNOOP_reg == 3)) ? i_AWLOCK  : 0;
            o_AWCACHE   = ((AWDOMAIN_reg == 0 && AWSNOOP_reg == 0) || ((AWDOMAIN_reg != 3) && AWSNOOP_reg == 3)) ? i_AWCACHE : 0;
            o_AWPROT    = ((AWDOMAIN_reg == 0 && AWSNOOP_reg == 0) || ((AWDOMAIN_reg != 3) && AWSNOOP_reg == 3)) ? i_AWPROT  : 0;
            o_AWQOS     = ((AWDOMAIN_reg == 0 && AWSNOOP_reg == 0) || ((AWDOMAIN_reg != 3) && AWSNOOP_reg == 3)) ? i_AWQOS   : 0;
            o_AWREGION  = ((AWDOMAIN_reg == 0 && AWSNOOP_reg == 0) || ((AWDOMAIN_reg != 3) && AWSNOOP_reg == 3)) ? i_AWREGION: 0;
            o_AWUSER    = ((AWDOMAIN_reg == 0 && AWSNOOP_reg == 0) || ((AWDOMAIN_reg != 3) && AWSNOOP_reg == 3)) ? i_AWUSER  : 0;   
            // o_AWDOMAIN  = i_AWDOMAIN;
            // o_AWSNOOP   = i_AWSNOOP ;
            o_AWVALID   = ((AWDOMAIN_reg == 0 && AWSNOOP_reg == 0) || ((AWDOMAIN_reg != 3) && AWSNOOP_reg == 3)) ? i_AWVALID : 0;
            o_AWREADY   = ((AWDOMAIN_reg == 0 && AWSNOOP_reg == 0) || ((AWDOMAIN_reg != 3) && AWSNOOP_reg == 3)) ? i_AWREADY : 1;
            
            // W Channel
            // output  s_WID,  // use default value: 0x0
            o_WDATA     = ((AWDOMAIN_reg == 0 && AWSNOOP_reg == 0) || ((AWDOMAIN_reg != 3) && AWSNOOP_reg == 3)) ? i_WDATA : 0;
            o_WSTRB     = ((AWDOMAIN_reg == 0 && AWSNOOP_reg == 0) || ((AWDOMAIN_reg != 3) && AWSNOOP_reg == 3)) ? i_WSTRB : 0;  // use default value: 0xF
            o_WLAST     = ((AWDOMAIN_reg == 0 && AWSNOOP_reg == 0) || ((AWDOMAIN_reg != 3) && AWSNOOP_reg == 3)) ? i_WLAST : 0;
            o_WUSER     = ((AWDOMAIN_reg == 0 && AWSNOOP_reg == 0) || ((AWDOMAIN_reg != 3) && AWSNOOP_reg == 3)) ? i_WUSER : 0;
            o_WVALID    = ((AWDOMAIN_reg == 0 && AWSNOOP_reg == 0) || ((AWDOMAIN_reg != 3) && AWSNOOP_reg == 3)) ? i_WVALID : 0;
            o_WREADY    = ((AWDOMAIN_reg == 0 && AWSNOOP_reg == 0) || ((AWDOMAIN_reg != 3) && AWSNOOP_reg == 3)) ? i_WREADY : 1;
            
            // B Channel
            o_BID       = ((AWDOMAIN_reg == 0 && AWSNOOP_reg == 0) || ((AWDOMAIN_reg != 3) && AWSNOOP_reg == 3)) ? i_BID   : 0;  // use default value: 0x0
            o_BRESP     = ((AWDOMAIN_reg == 0 && AWSNOOP_reg == 0) || ((AWDOMAIN_reg != 3) && AWSNOOP_reg == 3)) ? i_BRESP : 3;  
            o_BUSER     = ((AWDOMAIN_reg == 0 && AWSNOOP_reg == 0) || ((AWDOMAIN_reg != 3) && AWSNOOP_reg == 3)) ? i_BUSER : 0;
            o_BVALID    = ((AWDOMAIN_reg == 0 && AWSNOOP_reg == 0) || ((AWDOMAIN_reg != 3) && AWSNOOP_reg == 3)) ? i_BVALID : 1;
            o_BREADY    = ((AWDOMAIN_reg == 0 && AWSNOOP_reg == 0) || ((AWDOMAIN_reg != 3) && AWSNOOP_reg == 3)) ? i_BREADY : 0;
            
            // output for buffer enable
            aw_buffer_en = 0;
        end
        else begin
            // AW Channel
            o_AWID      = 0; // use default value: 0x0
            o_AWADDR    = 0;
            o_AWLEN     = 0;
            o_AWSIZE    = 0;  // use default value: Data bus width = 32-bit -> AWSIZE = 0x2
            o_AWBURST   = 0; // use default value: 0x1, INCR
            o_AWLOCK    = 0;
            o_AWCACHE   = 0;
            o_AWPROT    = 0;
            o_AWQOS     = 0;
            o_AWREGION  = 0;
            o_AWUSER    = 0;   
            // o_AWDOMAIN  = 0;
            // o_AWSNOOP   = 0;
            o_AWVALID   = 0;
            o_AWREADY   = 0;
            
            // W Channel
            // output  s_WID,  // use default value: 0x0
            o_WDATA     = 0;
            o_WSTRB     = 0;  // use default value: 0xF
            o_WLAST     = 0;
            o_WUSER     = 0;
            o_WVALID    = 0;
            o_WREADY    = 0;
            
            // B Channel
            o_BID       = 0;  // use default value: 0x0
            o_BRESP     = 0;  
            o_BUSER     = 0;
            o_BVALID    = 0;
            o_BREADY    = 0;
            
            // output for buffer enable
            aw_buffer_en = 1;
        end
    end
    
    always @(posedge ACLK) begin
        if (!ARESETn) begin
            AWADDR_reg   <= 0;
            AWDOMAIN_reg <= 0;
            AWSNOOP_reg  <= 0;
        end
        else begin
            if (aw_buffer_en) begin
                AWADDR_reg   <= i_AWADDR;
                AWDOMAIN_reg <= i_AWDOMAIN;
                AWSNOOP_reg  <= i_AWSNOOP;
            end
        end
    end
    
endmodule
