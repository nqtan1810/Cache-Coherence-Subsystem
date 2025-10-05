//=====================================================================================================
// This is controller of Read port in ACE, 
// support three snoop transactions: ReadShared, ReadUnique, MakeUnique and ReadNoSnoop
//=====================================================================================================

`timescale 1ns/1ns

module ACE_Controller_R
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
    
    // AR Channel
    input  [ID_WIDTH-1:0]       m_ARID, // use default value: 0x0
    input  [ADDR_WIDTH-1:0]     m_ARADDR,
    input  [7:0]                m_ARLEN,
    input  [2:0]                m_ARSIZE,  // use default value: Data bus width = 32-bit -> ARSIZE = 0x2
    input  [1:0]                m_ARBURST, // use default value: 0x1, INCR  
    input                       m_ARLOCK,
    input  [3:0]                m_ARCACHE,
    input  [2:0]                m_ARPROT,
    input  [3:0]                m_ARQOS,
    input  [3:0]                m_ARREGION,
    input  [USER_WIDTH-1:0]     m_ARUSER,
    input  [1:0]                m_ARDOMAIN,
    input  [3:0]                m_ARSNOOP,
    input                       m_ARVALID,
    output reg                  m_ARREADY,
    
    // R Channel
    output reg [ID_WIDTH-1:0]   m_RID,  // use default value: 0x0
    output reg [DATA_WIDTH-1:0] m_RDATA,
    output reg [3:0]            m_RRESP,
    output reg                  m_RLAST,
    output reg [USER_WIDTH-1:0]	m_RUSER,
    output reg                  m_RVALID,
    input                       m_RREADY,
    
    // Snoop Channels
    // AC Channel
    output reg                  ACVALID,
    output reg [ADDR_WIDTH-1:0] ACADDR,
    output reg [3:0]            ACSNOOP,
    output reg [2:0]            ACPROT,
    input                       ACREADY,
    
    // CR Channel
    output reg                  CRREADY,
    input                       CRVALID,
    input  [4:0]                CRRESP,
    
    // CD Channel
    output reg                  CDREADY,
    input                       CDVALID,
    input  [DATA_WIDTH-1:0]     CDDATA,
    input                       CDLAST,
    
    // AR Channel
    output reg [ID_WIDTH-1:0]   s_ARID,    
    output reg [ADDR_WIDTH-1:0] s_ARADDR,
    output reg [7:0]            s_ARLEN,
    output reg [2:0]            s_ARSIZE,
    output reg [1:0]            s_ARBURST,
    output reg                  s_ARLOCK,
    output reg [3:0]            s_ARCACHE,
    output reg [2:0]            s_ARPROT,
    output reg [3:0]            s_ARQOS,
    output reg [3:0]            s_ARREGION,
    output reg [USER_WIDTH-1:0] s_ARUSER,
    output reg                  s_ARVALID,
	input	  		            s_ARREADY,
    // R Channel
	input	   [ID_WIDTH-1:0]   s_RID,
	input	   [DATA_WIDTH-1:0] s_RDATA,
	input	   [1:0]	        s_RRESP,
	input	  		            s_RLAST,
	input	   [USER_WIDTH-1:0]	s_RUSER,
	input	 		            s_RVALID, 
    output reg                  s_RREADY,
    
    // for fix E_E bug
    output                      is_busy_fetch_mem,
    input                       is_E_E,
    
    // for fix WB_hit_mis but
    output                      is_shareable_busy,
    output     [ADDR_WIDTH-1:0] current_shareable_ARADDR
);
    
    // state define
    localparam IDLE     = 0;
    localparam S_R_ADDR = 1;
    localparam S_R_DATA = 2;
    localparam AC_ADDR  = 3;
    localparam CR_RESP  = 4;
    localparam CD_DATA  = 5;
    
    // state for Read Channel
    reg [2:0] r_state, r_next_state;
    
    // buffer
    // store request from Master
    reg                  m_ar_buffer_en;
    reg [ID_WIDTH-1:0]   m_ARID_reg;
    reg [ADDR_WIDTH-1:0] m_ARADDR_reg;
    reg [1:0]            m_ARDOMAIN_reg;
    reg [3:0]            m_ARSNOOP_reg;
    
    // store response from Other Cache
    reg       c_cr_buffer_en;
    reg [4:0] CRRESP_reg;
    reg       is_other_miss;    // when snoop done
    
    wire read_no_snoop;
    wire read_share;
    wire read_unique;
    wire make_unique;
    wire is_not_supported;
    wire is_snoop_trans;
    
    assign read_no_snoop = m_ARDOMAIN_reg == 2'b00 && m_ARSNOOP_reg == 4'b0000;
    assign read_share = (m_ARDOMAIN_reg == 2'b01 || m_ARDOMAIN_reg == 2'b10) && m_ARSNOOP_reg == 4'b0001;
    assign read_unique = (m_ARDOMAIN_reg == 2'b01 || m_ARDOMAIN_reg == 2'b10) && m_ARSNOOP_reg == 4'b0111;
    assign make_unique = (m_ARDOMAIN_reg == 2'b01 || m_ARDOMAIN_reg == 2'b10) && m_ARSNOOP_reg == 4'b1100;
    
    assign is_not_supported = !(read_no_snoop || read_share || read_unique || make_unique);
    assign is_snoop_trans = read_share || read_unique || make_unique;
    
    // for fix E_E bug
    assign is_busy_fetch_mem = (r_state == S_R_ADDR || r_state == S_R_DATA) & is_other_miss;
    
    // for fix WB_hit_mis but
    assign is_shareable_busy = r_state != IDLE && (m_ARDOMAIN_reg == 1 || m_ARDOMAIN_reg == 2);
    assign current_shareable_ARADDR = m_ARADDR_reg;
    
    always @(*) begin
        case(r_state)
            IDLE    : r_next_state = m_ARVALID ? S_R_ADDR : IDLE;
            S_R_ADDR: r_next_state = m_ARVALID && !is_other_miss ? ((read_no_snoop && s_ARREADY || is_not_supported) ? S_R_DATA : (is_snoop_trans ? AC_ADDR : S_R_ADDR)) : (is_other_miss && s_ARREADY ? S_R_DATA : S_R_ADDR); 
            S_R_DATA: r_next_state = (s_RVALID && s_RLAST || is_not_supported) && m_RREADY ? IDLE : S_R_DATA;
            AC_ADDR : r_next_state = ACREADY ? CR_RESP : AC_ADDR;
            CR_RESP : r_next_state = CRVALID ? (CRRESP[0] ? CD_DATA : (make_unique ? (m_RREADY ? IDLE : CR_RESP) : S_R_ADDR)) : CR_RESP;
            CD_DATA : r_next_state = CDVALID && CDLAST && m_RREADY ? IDLE : CD_DATA;
            default : r_next_state = IDLE;
        endcase
    end
    
    always @(posedge ACLK) begin
        if (!ARESETn) begin
            r_state <= IDLE;
        end
        else begin
            r_state <= r_next_state;
        end
    end
    
    always @(*) begin
        case(r_state)
            IDLE    : begin
                // to Master
                // AR Channel
                m_ARREADY   = 0;
                // R Channel
                m_RID       = 0;  // use default value: 0x0
                m_RDATA     = 0;
                m_RRESP     = 0;
                m_RLAST     = 0;
                m_RUSER     = 0;
                m_RVALID    = 0;
                
                // to Other Cache
                // Snoop Channels
                // AC Channel
                ACVALID     = 0;
                ACADDR      = 0;
                ACSNOOP     = 0;
                ACPROT      = 0;
                // CR Channel
                CRREADY     = 0;
                // CD Channel
                CDREADY     = 0;
                
                // to Slave
                // AR Channel
                s_ARID      = 0;    
                s_ARADDR    = 0;
                s_ARLEN     = 0;
                s_ARSIZE    = 0;
                s_ARBURST   = 0;
                s_ARLOCK    = 0;
                s_ARCACHE   = 0;
                s_ARPROT    = 0;
                s_ARQOS     = 0;
                s_ARREGION  = 0;
                s_ARUSER    = 0;
                s_ARVALID   = 0;
                // R Channel
                s_RREADY    = 0;
                
                m_ar_buffer_en = 1;
                c_cr_buffer_en = 0;
            end
            S_R_ADDR: begin
                // to Master
                // AR Channel
                m_ARREADY   = read_no_snoop ? s_ARREADY : 1;
                // R Channe
                m_RID       = 0;  // use default value: 0x0
                m_RDATA     = 0;
                m_RRESP     = 0;
                m_RLAST     = 0;
                m_RUSER     = 0;
                m_RVALID    = 0;
                
                // to Other Cache
                // Snoop Channels
                // AC Channel
                ACVALID     = 0;
                ACADDR      = 0;
                ACSNOOP     = 0;
                ACPROT      = 0;
                // CR Channe  
                CRREADY     = 0;
                // CD Channe 
                CDREADY     = 0;
                
                // to Slave
                // AR Channel
                s_ARID      = (read_no_snoop || is_other_miss) ? m_ARID_reg   : 0;    
                s_ARADDR    = (read_no_snoop || is_other_miss) ? m_ARADDR_reg : 0;
                s_ARLEN     = (read_no_snoop || is_other_miss) ? 4'hF         : 0;
                s_ARSIZE    = (read_no_snoop || is_other_miss) ? 3'h2         : 0;
                s_ARBURST   = (read_no_snoop || is_other_miss) ? 2'h1         : 0;
                s_ARLOCK    = 0;
                s_ARCACHE   = 0;
                s_ARPROT    = 0;
                s_ARQOS     = 0;
                s_ARREGION  = 0;
                s_ARUSER    = 0;
                s_ARVALID   = read_no_snoop ? m_ARVALID : (is_other_miss ? 1 : 0);
                // R Channel
                s_RREADY    = 0;
                
                m_ar_buffer_en = 0;
                c_cr_buffer_en = 0;
            end 
            S_R_DATA: begin
                // to Master
                // AR Channel
                m_ARREADY   = 0;
                // R Channe
                m_RID       = m_ARID_reg;  // use default value: 0x0
                m_RDATA     = (read_no_snoop || is_other_miss) ? s_RDATA  : 0;
                m_RRESP     = (read_no_snoop || is_other_miss) ? (is_E_E ? {2'b10, s_RRESP} : {2'b00, s_RRESP})  : is_not_supported ? 3 : 0;
                m_RLAST     = (read_no_snoop || is_other_miss) ? s_RLAST  : is_not_supported ? 1 : 0;
                m_RUSER     = (read_no_snoop || is_other_miss) ? s_RUSER  : 0;
                m_RVALID    = (read_no_snoop || is_other_miss) ? s_RVALID : is_not_supported ? 1 : 0;
                
                // to Other Cache
                // Snoop Channels
                // AC Channel
                ACVALID     = 0;
                ACADDR      = 0;
                ACSNOOP     = 0;
                ACPROT      = 0;
                // CR Channe  
                CRREADY     = 0;
                // CD Channe 
                CDREADY     = 0;
                
                // to Slave
                // AR Channel
                s_ARID      = 0;    
                s_ARADDR    = 0;
                s_ARLEN     = 0;
                s_ARSIZE    = 0;
                s_ARBURST   = 0;
                s_ARLOCK    = 0;
                s_ARCACHE   = 0;
                s_ARPROT    = 0;
                s_ARQOS     = 0;
                s_ARREGION  = 0;
                s_ARUSER    = 0;
                s_ARVALID   = 0;
                // R Channe
                s_RREADY    = (read_no_snoop || is_other_miss) ? m_RREADY : 0;
                
                m_ar_buffer_en = 0;
                c_cr_buffer_en = 0;
            end
            AC_ADDR : begin
                // to Master
                // AR Channel
                m_ARREADY   = 0;
                // R Channe
                m_RID       = 0;  // use default value: 0x0
                m_RDATA     = 0;
                m_RRESP     = 0;
                m_RLAST     = 0;
                m_RUSER     = 0;
                m_RVALID    = 0;
                
                // to Other Cache
                // Snoop Channels
                // AC Channel
                ACVALID     = 1;
                ACADDR      = m_ARADDR_reg;
                ACSNOOP     = make_unique ? 4'b1101 : m_ARSNOOP_reg;
                ACPROT      = 0;
                // CR Channe
                CRREADY     = 0;
                // CD Channe
                CDREADY     = 0;
                
                // to Slave
                // AR Channel
                s_ARID      = 0;    
                s_ARADDR    = 0;
                s_ARLEN     = 0;
                s_ARSIZE    = 0;
                s_ARBURST   = 0;
                s_ARLOCK    = 0;
                s_ARCACHE   = 0;
                s_ARPROT    = 0;
                s_ARQOS     = 0;
                s_ARREGION  = 0;
                s_ARUSER    = 0;
                s_ARVALID   = 0;
                // R Channe
                s_RREADY    = 0;
                
                m_ar_buffer_en = 0;
                c_cr_buffer_en = 0;
            end 
            CR_RESP : begin
                // to Master
                // AR Channel
                m_ARREADY   = 0;
                // R Channe
                m_RID       = make_unique ? m_ARID_reg : 0;  // use default value: 0x0
                m_RDATA     = 0;
                m_RRESP     = make_unique ? {CRRESP[3:2], 2'b00} : 0;
                m_RLAST     = make_unique ? 1 : 0;
                m_RUSER     = 0;
                m_RVALID    = make_unique ? 1 : 0;
                
                // to Other Cache
                // Snoop Channels
                // AC Channel
                ACVALID     = 0;
                ACADDR      = 0;
                ACSNOOP     = 0;
                ACPROT      = 0;
                // CR Channe
                CRREADY     = 1;
                // CD Channe
                CDREADY     = 0;
                
                // to Slave
                // AR Channel
                s_ARID      = 0;    
                s_ARADDR    = 0;
                s_ARLEN     = 0;
                s_ARSIZE    = 0;
                s_ARBURST   = 0;
                s_ARLOCK    = 0;
                s_ARCACHE   = 0;
                s_ARPROT    = 0;
                s_ARQOS     = 0;
                s_ARREGION  = 0;
                s_ARUSER    = 0;
                s_ARVALID   = 0;
                // R Channe
                s_RREADY    = 0;
                
                m_ar_buffer_en = 0;
                c_cr_buffer_en = 1;
            end
            CD_DATA : begin
                // to Master
                // AR Channel
                m_ARREADY   = 0;
                // R Channe
                m_RID       = m_ARID_reg;  // use default value: 0x0
                m_RDATA     = CDDATA;
                m_RRESP     = {CRRESP_reg[3:2], 2'b00};
                m_RLAST     = CDLAST;
                m_RUSER     = 0;
                m_RVALID    = CDVALID;
                
                // to Other Cache
                // Snoop Channels
                // AC Channel
                ACVALID     = 0;
                ACADDR      = 0;
                ACSNOOP     = 0;
                ACPROT      = 0;
                // CR Channe
                CRREADY     = 0;
                // CD Channe
                CDREADY     = 1;
                
                // to Slave
                // AR Channel
                s_ARID      = 0;    
                s_ARADDR    = 0;
                s_ARLEN     = 0;
                s_ARSIZE    = 0;
                s_ARBURST   = 0;
                s_ARLOCK    = 0;
                s_ARCACHE   = 0;
                s_ARPROT    = 0;
                s_ARQOS     = 0;
                s_ARREGION  = 0;
                s_ARUSER    = 0;
                s_ARVALID   = 0;
                // R Channe
                s_RREADY    = 0;
                
                m_ar_buffer_en = 0;
                c_cr_buffer_en = 0;
            end
            default : begin
                // to Master
                // AR Channel
                m_ARREADY   = 0;
                // R Channel
                m_RID       = 0;  // use default value: 0x0
                m_RDATA     = 0;
                m_RRESP     = 0;
                m_RLAST     = 0;
                m_RUSER     = 0;
                m_RVALID    = 0;
                
                // to Other Cache
                // Snoop Channels
                // AC Channel
                ACVALID     = 0;
                ACADDR      = 0;
                ACSNOOP     = 0;
                ACPROT      = 0;
                // CR Channel
                CRREADY     = 0;
                // CD Channel
                CDREADY     = 0;
                
                // to Slave
                // AR Channel
                s_ARID      = 0;    
                s_ARADDR    = 0;
                s_ARLEN     = 0;
                s_ARSIZE    = 0;
                s_ARBURST   = 0;
                s_ARLOCK    = 0;
                s_ARCACHE   = 0;
                s_ARPROT    = 0;
                s_ARQOS     = 0;
                s_ARREGION  = 0;
                s_ARUSER    = 0;
                s_ARVALID   = 0;
                // R Channel
                s_RREADY    = 0;
                
                m_ar_buffer_en = 0;
                c_cr_buffer_en = 0;
            end
        endcase
    end
    
    always @(posedge ACLK) begin
        if (!ARESETn) begin
            m_ARID_reg      <= 0;
            m_ARADDR_reg    <= 0;
            m_ARDOMAIN_reg  <= 0;
            m_ARSNOOP_reg   <= 0;
            
            CRRESP_reg      <= 0;
            
            is_other_miss   <= 0;
        end
        else begin
            if (m_ar_buffer_en) begin
                m_ARID_reg      <= m_ARID;
                m_ARADDR_reg    <= m_ARADDR;
                m_ARDOMAIN_reg  <= m_ARDOMAIN;
                m_ARSNOOP_reg   <= m_ARSNOOP;
            end
            
            if (c_cr_buffer_en) begin
                CRRESP_reg <= CRRESP;
            end
            
            if (r_state == CR_RESP && r_next_state == S_R_ADDR) begin
                is_other_miss <= 1;
            end
            else
            if (r_next_state == IDLE) begin
                is_other_miss <= 0;
            end
        end
    end
    
endmodule
