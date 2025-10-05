`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// this is cache controller for I-Cache
//////////////////////////////////////////////////////////////////////////////////


module instr_cache_controller
#(
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 32,
    parameter ID_WIDTH    = 2,
    parameter USER_WIDTH  = 4,
    parameter STRB_WIDTH  = (DATA_WIDTH/8),
    parameter ADDR_START  = 32'h0000_0000, // start address of code region
    parameter ADDR_END    = 32'h0000_03FF // end address of code region
)
(
    // system signals
    input                       ACLK,
    input                       ARESETn,
    input                       ENABLE,
    output  reg                 CACHE_HIT,
    output  reg                 CACHE_BUSY,
    
    // AXI5 Interface (connect with CPU)
    // AW Channel
    input   [ID_WIDTH-1:0]      m_AWID,
    input   [7:0]               m_AWLEN,
    input   [2:0]               m_AWSIZE,
    input   [1:0]               m_AWBURST,
    input                       m_AWLOCK,
    input   [3:0]               m_AWCACHE, 
    input   [2:0]               m_AWPROT,
    input   [3:0]               m_AWQOS,
    input   [3:0]               m_AWREGION,
    input   [USER_WIDTH-1:0]    m_AWUSER,
    input                       m_AWVALID,
    output  reg                 m_AWREADY,
    // input   [ADDR_WIDTH-1:0] m_AWADDR,
    
    // W Channel
    // input   m_WID,
    input                       m_WLAST,
    // input   [DATA_WIDTH-1:0] m_WDATA,
    input   [STRB_WIDTH-1:0]    m_WSTRB, // use default value: 0xF
    input   [USER_WIDTH-1:0]    m_WUSER,
    input                       m_WVALID,
    output  reg                 m_WREADY,
    
    // B Channel
    output  reg [ID_WIDTH-1:0]  m_BID,
    output  reg [1:0]           m_BRESP,
    output  [USER_WIDTH-1:0]    m_BUSER,
    output  reg                 m_BVALID,
    input                       m_BREADY,
    
    // AR Channel
    input   [ID_WIDTH-1:0]      m_ARID,
    // input   [ADDR_WIDTH-1:0]    m_ARADDR,
    input   [7:0]               m_ARLEN,
    input   [2:0]               m_ARSIZE,
    input   [1:0]               m_ARBURST,
    input                       m_ARLOCK,
    input   [3:0]               m_ARCACHE,
    input   [2:0]               m_ARPROT,
    input   [3:0]               m_ARQOS,
    input   [3:0]               m_ARREGION,
    input   [USER_WIDTH-1:0]    m_ARUSER, 
    input                       m_ARVALID,
    output  reg                 m_ARREADY,
    
    // R Channel
    output  reg [ID_WIDTH-1:0]  m_RID,
    output  reg [1:0]           m_RRESP,
    output  reg                 m_RLAST,
    output  [USER_WIDTH-1:0]	m_RUSER,
    output  reg                 m_RVALID,
    input                       m_RREADY,
    // output  [DATA_WIDTH-1:0] m_RDATA,
    
    // AXI5 Interface (connect with Cache L2)
    // AW Channel
    output  reg [ID_WIDTH-1:0]  s_AWID, // use default value: 0x0
    output  reg [7:0]           s_AWLEN,
    output  reg [2:0]           s_AWSIZE,  // use default value: Data bus width = 32-bit -> AWSIZE = 0x2
    output  reg [1:0]           s_AWBURST, // use default value: 0x1, INCR   
    output                      s_AWLOCK,
    output  [3:0]               s_AWCACHE,
    output  [2:0]               s_AWPROT,
    output  [3:0]               s_AWQOS,
    output  [3:0]               s_AWREGION,
    output  [USER_WIDTH-1:0]    s_AWUSER,
    output  reg                 s_AWVALID,
    input                       s_AWREADY,
    // input   [ADDR_WIDTH-1:0]    s_AWADDR,
    
    // W Channel
    // output  reg s_WID,  // use default value: 0x0
    // output  [DATA_WIDTH-1:0] s_WDATA,
    output  reg [STRB_WIDTH-1:0]s_WSTRB,  // use default value: 0xF
    output  reg                 s_WLAST,
    output  [USER_WIDTH-1:0]    s_WUSER,
    output  reg                 s_WVALID,
    input                       s_WREADY,
    
    // B Channel
    input   [ID_WIDTH-1:0]      s_BID,  // use default value: 0x0
    input   [1:0]               s_BRESP,
    input	[USER_WIDTH-1:0]    s_BUSER,  
    input                       s_BVALID,
    output  reg                 s_BREADY,
    
    // AR Channel
    output  reg [ID_WIDTH-1:0]  s_ARID, // use default value: 0x0
    // input   [ADDR_WIDTH-1:0]    s_ARADDR,
    output  reg [7:0]           s_ARLEN,
    output  reg [2:0]           s_ARSIZE,  // use default value: Data bus width = 32-bit -> ARSIZE = 0x2
    output  reg [1:0]           s_ARBURST, // use default value: 0x1, INCR  
    output                      s_ARLOCK,
    output  [3:0]               s_ARCACHE,
    output  [2:0]               s_ARPROT,
    output  [3:0]               s_ARQOS,
    output  [3:0]               s_ARREGION,
    output  [USER_WIDTH-1:0]    s_ARUSER,
    output  reg                 s_ARVALID,
    input                       s_ARREADY,
    
    // R Channel
    input   [ID_WIDTH-1:0]      s_RID,  // use default value: 0x0
    // input   [DATA_WIDTH-1:0] s_RDATA,
    input   [1:0]               s_RRESP,
    input                       s_RLAST,
    input	[USER_WIDTH-1:0]	s_RUSER,
    input                       s_RVALID,
    output  reg                 s_RREADY,
    
    // signals to control datapath
    input                       hit,
    input                       dirty,
    input                       full,
    input                       instr_type,   // read = 0, write = 1
    
    // output reg mem_wb,
    output reg                  plrut_w_en,
    output reg                  state_tag_w_en,
    output reg                  data_w_en,
    
    output reg                  mem_fetch,      // used to select control_offset and word_offset
    output reg [3:0]            control_offset,
    output reg                  w_data_sel,
    output reg                  is_mem_fetch,   // used to input to state_tag_controller
    
    output reg                  cpu_m_aw_in_reg_en,
    output reg                  cpu_m_w_in_reg_en,
    output reg                  cpu_m_ar_in_reg_en,
    
    output reg                  mem_s_aw_out_reg_en,
    output reg                  mem_s_ar_out_reg_en
);

    // state definition
    localparam  IDLE      = 0;
    localparam  M_W_ADDR  = 1;
    localparam  M_W_DATA  = 3;
    localparam  M_W_RESP  = 2;
    localparam  M_R_ADDR  = 4;
    localparam  M_R_DATA  = 5;
    localparam  HIT_MISS  = 7;
    localparam  CPU_WRITE = 6;
    localparam  CPU_READ  = 8;
    localparam  WRITE_MEM = 9;
    localparam  S_W_ADDR  = 10;
    localparam  S_W_DATA  = 11;
    localparam  S_W_RESP  = 12;
    localparam  READ_MEM  = 13;
    localparam  S_R_ADDR  = 14;
    localparam  S_R_DATA  = 15;
    
    // variable to store state
    (* fsm_encoding = "none" *) reg [3:0] state;
    reg [3:0] next_state;
    
    // internal registers
    reg [3:0] word_cnt; // both sent_word_cnt and rcv_word_cnt
    reg fetch_done; // used to synchronize --> create a temp clk to check hit again when completing fetch from Cache L1/Other Cache L1
    reg [1:0] s_RRESP_reg;
    
    // ****************************************************************************
    // START - for calculate performance purpose only
    // ****************************************************************************
    reg [31:0] cache_hit_num;
    reg [31:0] cache_access_num;
    
    always @(posedge ACLK) begin
        if (!ARESETn) begin
            cache_hit_num <= 0;
        end
        else begin
            cache_hit_num <= cache_hit_num + ((state == HIT_MISS) & hit);
        end
    end
    
    always @(posedge ACLK) begin
        if (!ARESETn) begin
            cache_access_num <= 0;
        end
        else begin
            cache_access_num <= cache_access_num + ((state == M_W_ADDR) | (state == M_R_ADDR));
        end
    end
    // ****************************************************************************
    // END - for calculate performance purpose only
    // ****************************************************************************
    
    // some fixed value (do not use)
    assign m_BUSER      = 0;
    assign m_RUSER      = 0;
    assign s_AWLOCK     = 0;  
    assign s_AWCACHE    = 0; 
    assign s_AWPROT     = 0;  
    assign s_AWQOS      = 0;   
    assign s_AWREGION   = 0;
    assign s_AWUSER     = 0;  
    assign s_WUSER      = 0;  
    assign s_ARLOCK     = 0;  
    assign s_ARCACHE    = 0; 
    assign s_ARPROT     = 0;  
    assign s_ARQOS      = 0;  
    assign s_ARREGION   = 0; 
    assign s_ARUSER     = 0;
    
    always @(posedge ACLK) begin
        if (!ARESETn) begin
            state <= IDLE;
        end
        else 
        if (ENABLE) begin
            state <= next_state;
        end
    end
    
    always @(*) begin
        case (state)
            IDLE      : next_state = m_AWVALID ? M_W_ADDR : (m_ARVALID ? M_R_ADDR : IDLE);
            M_W_ADDR  : next_state = m_AWVALID ? M_W_DATA : M_W_ADDR;
            M_W_DATA  : next_state = m_WVALID ? HIT_MISS : M_W_DATA;
            M_W_RESP  : next_state = m_BREADY ? IDLE : M_W_RESP;
            M_R_ADDR  : next_state = m_ARVALID ? HIT_MISS : M_R_ADDR;
            M_R_DATA  : next_state = m_RREADY ? IDLE : M_R_DATA;
            HIT_MISS  : next_state = hit ? (instr_type ? CPU_WRITE : CPU_READ) : (full && dirty ? WRITE_MEM : READ_MEM);
            CPU_WRITE : next_state = M_W_RESP;
            CPU_READ  : next_state = M_R_DATA;
            WRITE_MEM : next_state = S_W_ADDR;
            S_W_ADDR  : next_state = s_AWREADY ? S_W_DATA : S_W_ADDR;
            S_W_DATA  : next_state = (word_cnt == 4'b1111 && s_WREADY) ? S_W_RESP : S_W_DATA;
            S_W_RESP  : next_state = s_BVALID ? (s_BRESP == 0 ? READ_MEM : WRITE_MEM) : S_W_RESP;
            READ_MEM  : next_state = S_R_ADDR;
            S_R_ADDR  : next_state = s_ARREADY ? S_R_DATA : S_R_ADDR;
            S_R_DATA  : next_state = (s_RRESP_reg != 0 && fetch_done) ? READ_MEM : (fetch_done ? (instr_type ? CPU_WRITE : CPU_READ) : S_R_DATA);
            default   : next_state = IDLE;
        endcase
    end
    
    always @(*) begin
        case (state)
            IDLE      : begin
                CACHE_HIT = 0;
                CACHE_BUSY = 0;
                m_AWREADY = 0;
                m_WREADY = 0;
                m_BVALID = 0;
                m_BID = m_AWID;
                m_BRESP = 0;
                m_ARREADY = 0;
                m_RVALID = 0;
                m_RID = m_ARID;
                m_RLAST = 0;
                m_RRESP = 0;
                s_AWID = 0;
                s_AWLEN = 4'h0;
                s_AWSIZE = 3'h0;
                s_AWBURST = 2'h1;
                s_AWVALID = 0;
                s_WSTRB = 4'hF;
                s_WLAST = 0;
                s_WVALID = 0;
                s_BREADY = 0;
                s_ARID = 0;
                s_ARLEN = 4'h0;
                s_ARSIZE = 3'h0;
                s_ARBURST = 2'h1;
                s_ARVALID = 0;
                s_RREADY = 0;
                // internal signals
                // mem_wb = 0;
                plrut_w_en = 0;
                state_tag_w_en = 0;
                data_w_en = 0;
                mem_fetch = 0;
                control_offset = 4'b0000;
                w_data_sel = 0;
                is_mem_fetch = 0;
                cpu_m_aw_in_reg_en = 1;
                cpu_m_w_in_reg_en = 0;
                cpu_m_ar_in_reg_en = 1;
                mem_s_aw_out_reg_en = 0;
                mem_s_ar_out_reg_en = 0;
            end
            M_W_ADDR  : begin
                CACHE_HIT = 0;
                CACHE_BUSY = 1;
                m_AWREADY = 1;
                m_WREADY = 0;
                m_BVALID = 0;
                m_BID = m_AWID;
                m_BRESP = 0;
                m_ARREADY = 0;
                m_RVALID = 0;
                m_RID = m_ARID;
                m_RLAST = 0;
                m_RRESP = 0;
                s_AWID = 0;
                s_AWLEN = 4'h0;
                s_AWSIZE = 3'h0;
                s_AWBURST = 2'h1;
                s_AWVALID = 0;
                s_WSTRB = 4'hF;
                s_WLAST = 0;
                s_WVALID = 0;
                s_BREADY = 0;
                s_ARID = 0;
                s_ARLEN = 4'h0;
                s_ARSIZE = 3'h0;
                s_ARBURST = 2'h1;
                s_ARVALID = 0;
                s_RREADY = 0;
                // internal signals
                // mem_wb = 0;
                plrut_w_en = 0;
                state_tag_w_en = 0;
                data_w_en = 0;
                mem_fetch = 0;
                control_offset = 4'b0000;
                w_data_sel = 0;
                is_mem_fetch = 0;
                cpu_m_aw_in_reg_en = 1;
                cpu_m_w_in_reg_en = 0;
                cpu_m_ar_in_reg_en = 0;
                mem_s_aw_out_reg_en = 0;
                mem_s_ar_out_reg_en = 0;
            end
            M_W_DATA  : begin
                CACHE_HIT = 0;
                CACHE_BUSY = 1;
                m_AWREADY = 0;
                m_WREADY = 1;
                m_BVALID = 0;
                m_BID = m_AWID;
                m_BRESP = 0;
                m_ARREADY = 0;
                m_RVALID = 0;
                m_RID = m_ARID;
                m_RLAST = 0;
                m_RRESP = 0;
                s_AWID = 0;
                s_AWLEN = 4'h0;
                s_AWSIZE = 3'h0;
                s_AWBURST = 2'h1;
                s_AWVALID = 0;
                s_WSTRB = 4'hF;
                s_WLAST = 0;
                s_WVALID = 0;
                s_BREADY = 0;
                s_ARID = 0;
                s_ARLEN = 4'h0;
                s_ARSIZE = 3'h0;
                s_ARBURST = 2'h1;
                s_ARVALID = 0;
                s_RREADY = 0;
                // internal signals
                // mem_wb = 0;
                plrut_w_en = 0;
                state_tag_w_en = 0;
                data_w_en = 0;
                mem_fetch = 0;
                control_offset = 4'b0000;
                w_data_sel = 0;
                is_mem_fetch = 0;
                cpu_m_aw_in_reg_en = 0;
                cpu_m_w_in_reg_en = 1;
                cpu_m_ar_in_reg_en = 0;
                mem_s_aw_out_reg_en = 0;
                mem_s_ar_out_reg_en = 0;
            end
            M_W_RESP  : begin
                CACHE_HIT = 0;
                CACHE_BUSY = 1;
                m_AWREADY = 0;
                m_WREADY = 0;
                m_BVALID = 1;
                m_BID = m_AWID;
                m_BRESP = 0;
                m_ARREADY = 0;
                m_RVALID = 0;
                m_RID = m_ARID;
                m_RLAST = 0;
                m_RRESP = 0;
                s_AWID = 0;
                s_AWLEN = 4'h0;
                s_AWSIZE = 3'h0;
                s_AWBURST = 2'h1;
                s_AWVALID = 0;
                s_WSTRB = 4'hF;
                s_WLAST = 0;
                s_WVALID = 0;
                s_BREADY = 0;
                s_ARID = 0;
                s_ARLEN = 4'h0;
                s_ARSIZE = 3'h0;
                s_ARBURST = 2'h1;
                s_ARVALID = 0;
                s_RREADY = 0;
                // internal signals
                // mem_wb = 0;
                plrut_w_en = 0;
                state_tag_w_en = 0;
                data_w_en = 0;
                mem_fetch = 0;
                control_offset = 4'b0000;
                w_data_sel = 0;
                is_mem_fetch = 0;
                cpu_m_aw_in_reg_en = 0;
                cpu_m_w_in_reg_en = 0;
                cpu_m_ar_in_reg_en = 0;
                mem_s_aw_out_reg_en = 0;
                mem_s_ar_out_reg_en = 0;
            end
            M_R_ADDR  : begin
                CACHE_HIT = 0;
                CACHE_BUSY = 1;
                m_AWREADY = 0;
                m_WREADY = 0;
                m_BVALID = 0;
                m_BID = m_AWID;
                m_BRESP = 0;
                m_ARREADY = 1;
                m_RVALID = 0;
                m_RID = m_ARID;
                m_RLAST = 0;
                m_RRESP = 0;
                s_AWID = 0;
                s_AWLEN = 4'h0;
                s_AWSIZE = 3'h0;
                s_AWBURST = 2'h1;
                s_AWVALID = 0;
                s_WSTRB = 4'hF;
                s_WLAST = 0;
                s_WVALID = 0;
                s_BREADY = 0;
                s_ARID = 0;
                s_ARLEN = 4'h0;
                s_ARSIZE = 3'h0;
                s_ARBURST = 2'h1;
                s_ARVALID = 0;
                s_RREADY = 0;
                // internal signals
                // mem_wb = 0;
                plrut_w_en = 0;
                state_tag_w_en = 0;
                data_w_en = 0;
                mem_fetch = 0;
                control_offset = 4'b0000;
                w_data_sel = 0;
                is_mem_fetch = 0;
                cpu_m_aw_in_reg_en = 0;
                cpu_m_w_in_reg_en = 0;
                cpu_m_ar_in_reg_en = 1;
                mem_s_aw_out_reg_en = 0;
                mem_s_ar_out_reg_en = 0;
            end
            M_R_DATA  : begin
                CACHE_HIT = 0;
                CACHE_BUSY = 1;
                m_AWREADY = 0;
                m_WREADY = 0;
                m_BVALID = 0;
                m_BID = m_AWID;
                m_BRESP = 0;
                m_ARREADY = 0;
                m_RVALID = 1;
                m_RID = m_ARID;
                m_RLAST = 1;
                m_RRESP = 0;
                s_AWID = 0;
                s_AWLEN = 4'h0;
                s_AWSIZE = 3'h0;
                s_AWBURST = 2'h1;
                s_AWVALID = 0;
                s_WSTRB = 4'hF;
                s_WLAST = 0;
                s_WVALID = 0;
                s_BREADY = 0;
                s_ARID = 0;
                s_ARLEN = 4'h0;
                s_ARSIZE = 3'h0;
                s_ARBURST = 2'h1;
                s_ARVALID = 0;
                s_RREADY = 0;
                // internal signals
                // mem_wb = 0;
                plrut_w_en = 0;
                state_tag_w_en = 0;
                data_w_en = 0;
                mem_fetch = 0;
                control_offset = 4'b0000;
                w_data_sel = 0;
                is_mem_fetch = 0;
                cpu_m_aw_in_reg_en = 0;
                cpu_m_w_in_reg_en = 0;
                cpu_m_ar_in_reg_en = 0;
                mem_s_aw_out_reg_en = 0;
                mem_s_ar_out_reg_en = 0;
            end
            HIT_MISS  : begin
                CACHE_HIT = hit;
                CACHE_BUSY = 1;
                m_AWREADY = 0;
                m_WREADY = 0;
                m_BVALID = 0;
                m_BID = m_AWID;
                m_BRESP = 0;
                m_ARREADY = 0;
                m_RVALID = 0;
                m_RID = m_ARID;
                m_RLAST = 0;
                m_RRESP = 0;
                s_AWID = 0;
                s_AWLEN = 4'h0;
                s_AWSIZE = 3'h0;
                s_AWBURST = 2'h1;
                s_AWVALID = 0;
                s_WSTRB = 4'hF;
                s_WLAST = 0;
                s_WVALID = 0;
                s_BREADY = 0;
                s_ARID = 0;
                s_ARLEN = 4'h0;
                s_ARSIZE = 3'h0;
                s_ARBURST = 2'h1;
                s_ARVALID = 0;
                s_RREADY = 0;
                // internal signals
                // mem_wb = 0;
                plrut_w_en = 0;
                state_tag_w_en = 0;
                data_w_en = 0;
                mem_fetch = 0;
                control_offset = 4'b0000;
                w_data_sel = 0;
                is_mem_fetch = 0;
                cpu_m_aw_in_reg_en = 0;
                cpu_m_w_in_reg_en = 0;
                cpu_m_ar_in_reg_en = 0;
                mem_s_aw_out_reg_en = 1;
                mem_s_ar_out_reg_en = 1;
            end
            CPU_WRITE : begin
                CACHE_HIT = hit;
                CACHE_BUSY = 1;
                m_AWREADY = 0;
                m_WREADY = 0;
                m_BVALID = 0;
                m_BID = m_AWID;
                m_BRESP = 0;
                m_ARREADY = 0;
                m_RVALID = 0;
                m_RID = m_ARID;
                m_RLAST = 0;
                m_RRESP = 0;
                s_AWID = 0;
                s_AWLEN = 4'h0;
                s_AWSIZE = 3'h0;
                s_AWBURST = 2'h1;
                s_AWVALID = 0;
                s_WSTRB = 4'hF;
                s_WLAST = 0;
                s_WVALID = 0;
                s_BREADY = 0;
                s_ARID = 0;
                s_ARLEN = 4'h0;
                s_ARSIZE = 3'h0;
                s_ARBURST = 2'h1;
                s_ARVALID = 0;
                s_RREADY = 0;
                // internal signals
                // mem_wb = 0;
                plrut_w_en = 1;
                state_tag_w_en = 1;
                data_w_en = 1;
                mem_fetch = 0;
                control_offset = 4'b0000;
                w_data_sel = 0;
                is_mem_fetch = 0;
                cpu_m_aw_in_reg_en = 0;
                cpu_m_w_in_reg_en = 0;
                cpu_m_ar_in_reg_en = 0;
                mem_s_aw_out_reg_en = 0;
                mem_s_ar_out_reg_en = 0;
            end
            CPU_READ  : begin
                CACHE_HIT = hit;
                CACHE_BUSY = 1;
                m_AWREADY = 0;
                m_WREADY = 0;
                m_BVALID = 0;
                m_BID = m_AWID;
                m_BRESP = 0;
                m_ARREADY = 0;
                m_RVALID = 0;
                m_RID = m_ARID;
                m_RLAST = 0;
                m_RRESP = 0;
                s_AWID = 0;
                s_AWLEN = 4'h0;
                s_AWSIZE = 3'h0;
                s_AWBURST = 2'h1;
                s_AWVALID = 0;
                s_WSTRB = 4'hF;
                s_WLAST = 0;
                s_WVALID = 0;
                s_BREADY = 0;
                s_ARID = 0;
                s_ARLEN = 4'h0;
                s_ARSIZE = 3'h0;
                s_ARBURST = 2'h1;
                s_ARVALID = 0;
                s_RREADY = 0;
                // internal signals
                // mem_wb = 0;
                plrut_w_en = 1;
                state_tag_w_en = 0;
                data_w_en = 0;
                mem_fetch = 0;
                control_offset = 4'b0000;
                w_data_sel = 0;
                is_mem_fetch = 0;
                cpu_m_aw_in_reg_en = 0;
                cpu_m_w_in_reg_en = 0;
                cpu_m_ar_in_reg_en = 0;
                mem_s_aw_out_reg_en = 0;
                mem_s_ar_out_reg_en = 0;
            end
            WRITE_MEM : begin
                CACHE_HIT = 0;
                CACHE_BUSY = 1;
                m_AWREADY = 0;
                m_WREADY = 0;
                m_BVALID = 0;
                m_BID = m_AWID;
                m_BRESP = 0;
                m_ARREADY = 0;
                m_RVALID = 0;
                m_RID = m_ARID;
                m_RLAST = 0;
                m_RRESP = 0;
                s_AWID = 0;
                s_AWLEN = 4'h0;
                s_AWSIZE = 3'h0;
                s_AWBURST = 2'h1;
                s_AWVALID = 0;
                s_WSTRB = 4'hF;
                s_WLAST = 0;
                s_WVALID = 0;
                s_BREADY = 0;
                s_ARID = 0;
                s_ARLEN = 4'h0;
                s_ARSIZE = 3'h0;
                s_ARBURST = 2'h1;
                s_ARVALID = 0;
                s_RREADY = 0;
                // internal signals
                // mem_wb = 1;
                plrut_w_en = 0;
                state_tag_w_en = 0;
                data_w_en = 0;
                mem_fetch = 0;
                control_offset = 4'b0000;
                w_data_sel = 0;
                is_mem_fetch = 0;
                cpu_m_aw_in_reg_en = 0;
                cpu_m_w_in_reg_en = 0;
                cpu_m_ar_in_reg_en = 0;
                mem_s_aw_out_reg_en = 0;
                mem_s_ar_out_reg_en = 0;
            end
            S_W_ADDR  : begin
                CACHE_HIT = 0;
                CACHE_BUSY = 1;
                m_AWREADY = 0;
                m_WREADY = 0;
                m_BVALID = 0;
                m_BID = m_AWID;
                m_BRESP = 0;
                m_ARREADY = 0;
                m_RVALID = 0;
                m_RID = m_ARID;
                m_RLAST = 0;
                m_RRESP = 0;
                s_AWID = m_AWID;
                s_AWLEN = 4'hF;
                s_AWSIZE = 3'h2;
                s_AWBURST = 2'h1;
                s_AWVALID = 1;
                s_WSTRB = 4'hF;
                s_WLAST = 0;
                s_WVALID = 0;
                s_BREADY = 0;
                s_ARID = 0;
                s_ARLEN = 4'h0;
                s_ARSIZE = 3'h0;
                s_ARBURST = 2'h1;
                s_ARVALID = 0;
                s_RREADY = 0;
                // internal signals
                // mem_wb = 1;
                plrut_w_en = 0;
                state_tag_w_en = 0;
                data_w_en = 0;
                mem_fetch = 1;
                control_offset = 4'b0000;
                w_data_sel = 0;
                is_mem_fetch = 0;
                cpu_m_aw_in_reg_en = 0;
                cpu_m_w_in_reg_en = 0;
                cpu_m_ar_in_reg_en = 0;
                mem_s_aw_out_reg_en = 0;
                mem_s_ar_out_reg_en = 0;
            end
            S_W_DATA  : begin
                CACHE_HIT = 0;
                CACHE_BUSY = 1;
                m_AWREADY = 0;
                m_WREADY = 0;
                m_BVALID = 0;
                m_BID = m_AWID;
                m_BRESP = 0;
                m_ARREADY = 0;
                m_RVALID = 0;
                m_RID = m_ARID;
                m_RLAST = 0;
                m_RRESP = 0;
                s_AWID = m_AWID;
                s_AWLEN = 4'hF;
                s_AWSIZE = 3'h2;
                s_AWBURST = 2'h1;
                s_AWVALID = 0;
                s_WSTRB = 4'hF;
                s_WLAST = (word_cnt == 4'b1111) ? 1 : 0;
                s_WVALID = 1;
                s_BREADY = 0;
                s_ARID = 0;
                s_ARLEN = 4'h0;
                s_ARSIZE = 3'h0;
                s_ARBURST = 2'h1;
                s_ARVALID = 0;
                s_RREADY = 0;
                // internal signals
                // mem_wb = 1;
                plrut_w_en = 0;
                // state_tag_w_en = s_WLAST & s_WREADY;
                state_tag_w_en = 0;
                data_w_en = 0;
                mem_fetch = 1;
                control_offset = word_cnt + 1;
                w_data_sel = 0;
                is_mem_fetch = 0;
                cpu_m_aw_in_reg_en = 0;
                cpu_m_w_in_reg_en = 0;
                cpu_m_ar_in_reg_en = 0;
                mem_s_aw_out_reg_en = 0;
                mem_s_ar_out_reg_en = 0;
            end
            S_W_RESP  : begin
                CACHE_HIT = 0;
                CACHE_BUSY = 1;
                m_AWREADY = 0;
                m_WREADY = 0;
                m_BVALID = 0;
                m_BID = m_AWID;
                m_BRESP = 0;
                m_ARREADY = 0;
                m_RVALID = 0;
                m_RID = m_ARID;
                m_RLAST = 0;
                m_RRESP = 0;
                s_AWID = m_AWID;
                s_AWLEN = 4'hF;
                s_AWSIZE = 3'h2;
                s_AWBURST = 2'h1;
                s_AWVALID = 0;
                s_WSTRB = 4'hF;
                s_WLAST = 0;
                s_WVALID = 0;
                s_BREADY = 1;
                s_ARID = 0;
                s_ARLEN = 4'h0;
                s_ARSIZE = 3'h0;
                s_ARBURST = 2'h1;
                s_ARVALID = 0;
                s_RREADY = 0;
                // internal signals
                // mem_wb = 1;
                plrut_w_en = 0;
                // state_tag_w_en = 0;
                state_tag_w_en = s_BVALID & s_BRESP == 0;
                data_w_en = 0;
                mem_fetch = 0;
                control_offset = 4'b0000;
                w_data_sel = 0;
                is_mem_fetch = 0;
                cpu_m_aw_in_reg_en = 0;
                cpu_m_w_in_reg_en = 0;
                cpu_m_ar_in_reg_en = 0;
                mem_s_aw_out_reg_en = 0;
                mem_s_ar_out_reg_en = 0;
            end
            READ_MEM  : begin
                CACHE_HIT = 0;
                CACHE_BUSY = 1;
                m_AWREADY = 0;
                m_WREADY = 0;
                m_BVALID = 0;
                m_BID = m_AWID;
                m_BRESP = 0;
                m_ARREADY = 0;
                m_RVALID = 0;
                m_RID = m_ARID;
                m_RLAST = 0;
                m_RRESP = 0;
                s_AWID = 0;
                s_AWLEN = 4'h0;
                s_AWSIZE = 3'h0;
                s_AWBURST = 2'h1;
                s_AWVALID = 0;
                s_WSTRB = 4'hF;
                s_WLAST = 0;
                s_WVALID = 0;
                s_BREADY = 0;
                s_ARID = 0;
                s_ARLEN = 4'h0;
                s_ARSIZE = 3'h0;
                s_ARBURST = 2'h1;
                s_ARVALID = 0;
                s_RREADY = 0;
                // internal signals
                // mem_wb = 0;
                plrut_w_en = 0;
                state_tag_w_en = 0;
                data_w_en = 0;
                mem_fetch = 0;
                control_offset = 4'b0000;
                w_data_sel = 1;
                is_mem_fetch = 0;
                cpu_m_aw_in_reg_en = 0;
                cpu_m_w_in_reg_en = 0;
                cpu_m_ar_in_reg_en = 0;
                mem_s_aw_out_reg_en = 0;
                mem_s_ar_out_reg_en = 0;
            end
            S_R_ADDR  : begin
                CACHE_HIT = 0;
                CACHE_BUSY = 1;
                m_AWREADY = 0;
                m_WREADY = 0;
                m_BVALID = 0;
                m_BID = m_AWID;
                m_BRESP = 0;
                m_ARREADY = 0;
                m_RVALID = 0;
                m_RID = m_ARID;
                m_RLAST = 0;
                m_RRESP = 0;
                s_AWID = 0;
                s_AWLEN = 4'h0;
                s_AWSIZE = 3'h0;
                s_AWBURST = 2'h1;
                s_AWVALID = 0;
                s_WSTRB = 4'hF;
                s_WLAST = 0;
                s_WVALID = 0;
                s_BREADY = 0;
                s_ARID = m_ARID;
                // s_ARLEN = 4'hF;
                s_ARLEN = 4'hF;
                s_ARSIZE = 3'h2;
                s_ARBURST = 2'h1;
                s_ARVALID = 1;
                s_RREADY = 0;
                // internal signals
                // mem_wb = 0;
                plrut_w_en = 0;
                state_tag_w_en = 0;
                data_w_en = 0;
                mem_fetch = 1;
                control_offset = 4'b0000;
                w_data_sel = 1;
                is_mem_fetch = 0;
                cpu_m_aw_in_reg_en = 0;
                cpu_m_w_in_reg_en = 0;
                cpu_m_ar_in_reg_en = 0;
                mem_s_aw_out_reg_en = 0;
                mem_s_ar_out_reg_en = 0;
            end
            S_R_DATA  : begin
                CACHE_HIT = 0;
                CACHE_BUSY = 1;
                m_AWREADY = 0;
                m_WREADY = 0;
                m_BVALID = 0;
                m_BID = m_AWID;
                m_BRESP = 0;
                m_ARREADY = 0;
                m_RVALID = 0;
                m_RID = m_ARID;
                m_RLAST = 0;
                m_RRESP = 0;
                s_AWID = 0;
                s_AWLEN = 4'h0;
                s_AWSIZE = 3'h0;
                s_AWBURST = 2'h1;
                s_AWVALID = 0;
                s_WSTRB = 4'hF;
                s_WLAST = 0;
                s_WVALID = 0;
                s_BREADY = 0;
                s_ARID = m_ARID;
                s_ARLEN = 4'hF;
                s_ARSIZE = 3'h2;
                s_ARBURST = 2'h1;
                s_ARVALID = 0;
                s_RREADY = 1;
                // internal signals
                // mem_wb = 0;
                plrut_w_en = 0/*s_RVALID & s_RLAST*/;
                state_tag_w_en = s_RVALID & s_RLAST & s_RRESP == 0 & s_RRESP_reg == 0;
                // state_tag_w_en = word_cnt == 4'b1110;
                // data_w_en = s_RVALID;
                data_w_en = s_RVALID & s_RRESP == 0 & s_RRESP_reg == 0;
                mem_fetch = 1;
                control_offset = word_cnt;
                w_data_sel = 1;
                is_mem_fetch = 1;
                cpu_m_aw_in_reg_en = 0;
                cpu_m_w_in_reg_en = 0;
                cpu_m_ar_in_reg_en = 0;
                mem_s_aw_out_reg_en = 0;
                mem_s_ar_out_reg_en = 0;
            end
            default   : begin
                CACHE_HIT = 0;
                CACHE_BUSY = 0;
                m_AWREADY = 0;
                m_WREADY = 0;
                m_BVALID = 0;
                m_BID = m_AWID;
                m_BRESP = 0;
                m_ARREADY = 0;
                m_RVALID = 0;
                m_RID = m_ARID;
                m_RLAST = 0;
                m_RRESP = 0;
                s_AWID = 0;
                s_AWLEN = 4'h0;
                s_AWSIZE = 3'h0;
                s_AWBURST = 2'h1;
                s_AWVALID = 0;
                s_WSTRB = 4'hF;
                s_WLAST = 0;
                s_WVALID = 0;
                s_BREADY = 0;
                s_ARID = 0;
                s_ARLEN = 4'h0;
                s_ARSIZE = 3'h0;
                s_ARBURST = 2'h1;
                s_ARVALID = 0;
                s_RREADY = 0;
                // internal signals
                // mem_wb = 0;
                plrut_w_en = 0;
                state_tag_w_en = 0;
                data_w_en = 0;
                mem_fetch = 0;
                control_offset = 4'b0000;
                w_data_sel = 0;
                is_mem_fetch = 0;
                cpu_m_aw_in_reg_en = 0;
                cpu_m_w_in_reg_en = 0;
                cpu_m_ar_in_reg_en = 0;
                mem_s_aw_out_reg_en = 0;
                mem_s_ar_out_reg_en = 0;
            end
        endcase
    end
    
    always @(posedge ACLK) begin
        if (!ARESETn) begin
            word_cnt <= 4'b0000;
            fetch_done <= 0;
            s_RRESP_reg <= 0;
        end
        else begin
            if (state != next_state) begin
                word_cnt <= 4'b0000;
                fetch_done <= 0;
                s_RRESP_reg <= 0;
            end
            else begin
                if (s_WREADY || s_RVALID) begin
                    word_cnt <= word_cnt + 4'b0001;
                end
                if ((state == S_R_DATA) && s_RVALID && s_RLAST) begin
                    fetch_done <= 1;
                end
                if (s_RVALID && s_RRESP != 0) begin
                    s_RRESP_reg <= s_RRESP;
                end
            end
        end
    end

endmodule
