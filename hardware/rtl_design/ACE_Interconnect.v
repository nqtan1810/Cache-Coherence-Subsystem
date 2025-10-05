//=====================================================================================================
// This is an ACE Interconnect support two Master with ACE Interface and one Slave with AXI Interface
//=====================================================================================================

`timescale 1ns/1ns

module ACE_Interconnect
#(
    parameter DATA_WIDTH  = 32,
    parameter ADDR_WIDTH  = 32,
    parameter ID_WIDTH    = 2,
    parameter USER_WIDTH  = 4,
    parameter STRB_WIDTH  = (DATA_WIDTH/8)
)
(
	/********* System signals *********/
	input                       ACLK,
	input      	                ARESETn,
	// ====================== D-Cache of Master0 ======================
    /********** Master 0 side **********/
    // AW Channel
	input      [ID_WIDTH-1:0]   m0_AWID,
    input	   [ADDR_WIDTH-1:0] m0_AWADDR,
    input      [7:0]            m0_AWLEN,
    input      [2:0]            m0_AWSIZE,
    input      [1:0]            m0_AWBURST,
    input                       m0_AWLOCK,
    input      [3:0]            m0_AWCACHE,
    input      [2:0]            m0_AWPROT,
    input      [3:0]            m0_AWQOS,
    input      [3:0]            m0_AWREGION,
    input      [USER_WIDTH-1:0] m0_AWUSER,
    input      [1:0]            m0_AWDOMAIN,
    input      [2:0]            m0_AWSNOOP,
    input                       m0_AWVALID,
    output                      m0_AWREADY,
    // W Channel
    // input      [ID_WIDTH-1:0]   m0_WID,
    input      [DATA_WIDTH-1:0] m0_WDATA,
    input      [STRB_WIDTH-1:0] m0_WSTRB,
    input                       m0_WLAST,
    input      [USER_WIDTH-1:0] m0_WUSER,
    input                       m0_WVALID,
    output                      m0_WREADY,
    // B Channel
    output     [ID_WIDTH-1:0]	m0_BID,
	output     [1:0]	        m0_BRESP,
	output     [USER_WIDTH-1:0] m0_BUSER,
	output                      m0_BVALID,
    input                       m0_BREADY,
    // AR Channel
    input      [ID_WIDTH-1:0]   m0_ARID,
    input      [ADDR_WIDTH-1:0] m0_ARADDR,
    input      [7:0]            m0_ARLEN,
    input      [2:0]            m0_ARSIZE,
    input      [1:0]            m0_ARBURST,
    input                       m0_ARLOCK,
    input      [3:0]            m0_ARCACHE,
    input      [2:0]            m0_ARPROT,
    input      [3:0]            m0_ARQOS,
    input      [3:0]            m0_ARREGION,
    input      [USER_WIDTH-1:0] m0_ARUSER,
    input      [1:0]            m0_ARDOMAIN,
    input      [3:0]            m0_ARSNOOP,
    input                       m0_ARVALID,
    output                      m0_ARREADY,
    // R Channel
    output     [ID_WIDTH-1:0]   m0_RID,
	output     [DATA_WIDTH-1:0] m0_RDATA,
	output     [3:0]	        m0_RRESP,
    output                      m0_RLAST,
	output     [USER_WIDTH-1:0]	m0_RUSER,
	output                      m0_RVALID,
    input                       m0_RREADY,
    // Snoop Channels
    // AC Channel
    output                      m0_ACVALID,
    output   [ADDR_WIDTH-1:0]   m0_ACADDR,
    output   [3:0]              m0_ACSNOOP,
    output   [2:0]              m0_ACPROT,
    input                       m0_ACREADY,
    
    // CR Channel
    output                      m0_CRREADY,
    input                       m0_CRVALID,
    input  [4:0]                m0_CRRESP,
    
    // CD Channel
    output                      m0_CDREADY,
    input                       m0_CDVALID,
    input  [DATA_WIDTH-1:0]     m0_CDDATA,
    input                       m0_CDLAST,
    
    // ====================== D-Cache of Master1 ======================
    /********** Master 1 side **********/
    // AW Channel
    input      [ID_WIDTH-1:0]   m1_AWID,
    input	   [ADDR_WIDTH-1:0]	m1_AWADDR,
    input      [7:0]            m1_AWLEN,
    input      [2:0]            m1_AWSIZE,
    input      [1:0]            m1_AWBURST,
    input                       m1_AWLOCK,
    input      [3:0]            m1_AWCACHE,
    input      [2:0]            m1_AWPROT,
    input      [3:0]            m1_AWQOS,
    input      [3:0]            m1_AWREGION,
    input      [USER_WIDTH-1:0] m1_AWUSER,
    input      [1:0]            m1_AWDOMAIN,
    input      [2:0]            m1_AWSNOOP,
    input                       m1_AWVALID,
    output                      m1_AWREADY,
    // W Channel
    // input      [ID_WIDTH-1:0]   m1_WID,
    input      [DATA_WIDTH-1:0] m1_WDATA,
    input      [STRB_WIDTH-1:0] m1_WSTRB,
    input                       m1_WLAST,
    input      [USER_WIDTH-1:0] m1_WUSER,
    input                       m1_WVALID,
    output                      m1_WREADY,
    // B Channel
    output     [ID_WIDTH-1:0]	m1_BID,
	output     [1:0]	        m1_BRESP,
	output     [USER_WIDTH-1:0] m1_BUSER,
	output                      m1_BVALID,
    input                       m1_BREADY,
    // AR Channel
    input      [ID_WIDTH-1:0]   m1_ARID,
    input      [ADDR_WIDTH-1:0] m1_ARADDR,
    input      [7:0]            m1_ARLEN,
    input      [2:0]            m1_ARSIZE,
    input      [1:0]            m1_ARBURST,
    input                       m1_ARLOCK,
    input      [3:0]            m1_ARCACHE,
    input      [2:0]            m1_ARPROT,
    input      [3:0]            m1_ARQOS,
    input      [3:0]            m1_ARREGION,
    input      [USER_WIDTH-1:0] m1_ARUSER,
    input      [1:0]            m1_ARDOMAIN,
    input      [3:0]            m1_ARSNOOP,
    input                       m1_ARVALID,
    output                      m1_ARREADY,
    // R Channel
    output     [ID_WIDTH-1:0]   m1_RID,
	output     [DATA_WIDTH-1:0] m1_RDATA,
	output     [3:0]	        m1_RRESP,
    output                      m1_RLAST,
	output     [USER_WIDTH-1:0]	m1_RUSER,
	output                      m1_RVALID,
    input                       m1_RREADY,
    // Snoop Channels
    // AC Channel
    output                      m1_ACVALID,
    output   [ADDR_WIDTH-1:0]   m1_ACADDR,
    output   [3:0]              m1_ACSNOOP,
    output   [2:0]              m1_ACPROT,
    input                       m1_ACREADY,
    
    // CR Channel
    output                      m1_CRREADY,
    input                       m1_CRVALID,
    input  [4:0]                m1_CRRESP,
    
    // CD Channel
    output                      m1_CDREADY,
    input                       m1_CDVALID,
    input  [DATA_WIDTH-1:0]     m1_CDDATA,
    input                       m1_CDLAST,
    
    // ====================== I-Cache of Master0 ======================
    // AW Channel
    input   [ID_WIDTH-1:0]      m2_AWID,
    input   [ADDR_WIDTH-1:0]    m2_AWADDR,
    input   [7:0]               m2_AWLEN,
    input   [2:0]               m2_AWSIZE,
    input   [1:0]               m2_AWBURST,
    input                       m2_AWLOCK,
    input   [3:0]               m2_AWCACHE,
    input   [2:0]               m2_AWPROT,
    input   [3:0]               m2_AWQOS,
    input   [3:0]               m2_AWREGION,
    input   [USER_WIDTH-1:0]    m2_AWUSER,
    input                       m2_AWVALID,
    output                      m2_AWREADY,
    
    // W Channel
    input   [DATA_WIDTH-1:0]    m2_WDATA,
    input   [STRB_WIDTH-1:0]    m2_WSTRB, // can use to 1-byte, 2-byte, 4-byte access
    input                       m2_WLAST,
    input   [USER_WIDTH-1:0]    m2_WUSER,
    input                       m2_WVALID,
    output                      m2_WREADY,
    
    // B Channel
    output  [ID_WIDTH-1:0]      m2_BID,
    output  [1:0]               m2_BRESP,
    output  [USER_WIDTH-1:0]    m2_BUSER,
    output                      m2_BVALID,
    input                       m2_BREADY,
    
    // AR Channel
    input   [ID_WIDTH-1:0]      m2_ARID,
    input   [ADDR_WIDTH-1:0]    m2_ARADDR,
    input   [7:0]               m2_ARLEN,
    input   [2:0]               m2_ARSIZE,
    input   [1:0]               m2_ARBURST,
    input                       m2_ARLOCK,
    input   [3:0]               m2_ARCACHE,
    input   [2:0]               m2_ARPROT,
    input   [3:0]               m2_ARQOS,
    input   [3:0]               m2_ARREGION,
    input   [USER_WIDTH-1:0]    m2_ARUSER,
    input                       m2_ARVALID,
    output                      m2_ARREADY,
    
    // R Channel
    output  [ID_WIDTH-1:0]      m2_RID,
    output  [DATA_WIDTH-1:0]    m2_RDATA,
    output  [1:0]               m2_RRESP,
    output                      m2_RLAST,
    output  [USER_WIDTH-1:0]	m2_RUSER,
    output                      m2_RVALID,
    input                       m2_RREADY,
    
    // ====================== I-Cache of Master1 ======================
    // AW Channel
    input   [ID_WIDTH-1:0]      m3_AWID,
    input   [ADDR_WIDTH-1:0]    m3_AWADDR,
    input   [7:0]               m3_AWLEN,
    input   [2:0]               m3_AWSIZE,
    input   [1:0]               m3_AWBURST,
    input                       m3_AWLOCK,
    input   [3:0]               m3_AWCACHE,
    input   [2:0]               m3_AWPROT,
    input   [3:0]               m3_AWQOS,
    input   [3:0]               m3_AWREGION,
    input   [USER_WIDTH-1:0]    m3_AWUSER,
    input                       m3_AWVALID,
    output                      m3_AWREADY,
    
    // W Channel
    input   [DATA_WIDTH-1:0]    m3_WDATA,
    input   [STRB_WIDTH-1:0]    m3_WSTRB, // can use to 1-byte, 2-byte, 4-byte access
    input                       m3_WLAST,
    input   [USER_WIDTH-1:0]    m3_WUSER,
    input                       m3_WVALID,
    output                      m3_WREADY,
    
    // B Channel
    output  [ID_WIDTH-1:0]      m3_BID,
    output  [1:0]               m3_BRESP,
    output  [USER_WIDTH-1:0]    m3_BUSER,
    output                      m3_BVALID,
    input                       m3_BREADY,
    
    // AR Channel
    input   [ID_WIDTH-1:0]      m3_ARID,
    input   [ADDR_WIDTH-1:0]    m3_ARADDR,
    input   [7:0]               m3_ARLEN,
    input   [2:0]               m3_ARSIZE,
    input   [1:0]               m3_ARBURST,
    input                       m3_ARLOCK,
    input   [3:0]               m3_ARCACHE,
    input   [2:0]               m3_ARPROT,
    input   [3:0]               m3_ARQOS,
    input   [3:0]               m3_ARREGION,
    input   [USER_WIDTH-1:0]    m3_ARUSER,
    input                       m3_ARVALID,
    output                      m3_ARREADY,
    
    // R Channel
    output  [ID_WIDTH-1:0]      m3_RID,
    output  [DATA_WIDTH-1:0]    m3_RDATA,
    output  [1:0]               m3_RRESP,
    output                      m3_RLAST,
    output  [USER_WIDTH-1:0]	m3_RUSER,
    output                      m3_RVALID,
    input                       m3_RREADY,

    /********** Slave side**********/
    // AW Channel
    output     [ID_WIDTH-1:0]   s_AWID,
    output     [ADDR_WIDTH-1:0]	s_AWADDR,
    output     [7:0]            s_AWLEN,
    output     [2:0]            s_AWSIZE,
    output     [1:0]            s_AWBURST,
    output                      s_AWLOCK,
    output     [3:0]            s_AWCACHE,
    output     [2:0]            s_AWPROT,
    output     [3:0]            s_AWQOS,
    output     [3:0]            s_AWREGION,
    output     [USER_WIDTH-1:0] s_AWUSER,
    output                      s_AWVALID,
    input	   	                s_AWREADY,
    // W Channel
    // output     [ID_WIDTH-1:0]   s_WID,
    output     [DATA_WIDTH-1:0] s_WDATA,
    output     [STRB_WIDTH-1:0] s_WSTRB,
    output                      s_WLAST,
    output     [USER_WIDTH-1:0] s_WUSER,
    output                      s_WVALID,
    input	  		            s_WREADY,
    // B Channel
	input	   [ID_WIDTH-1:0]	s_BID,
	input	   [1:0]	        s_BRESP,
	input	   [USER_WIDTH-1:0] s_BUSER,
	input	     		        s_BVALID,
    output                      s_BREADY,
    // AR Channel
    output     [ID_WIDTH-1:0]   s_ARID,    
    output     [ADDR_WIDTH-1:0] s_ARADDR,
    output     [7:0]            s_ARLEN,
    output     [2:0]            s_ARSIZE,
    output     [1:0]            s_ARBURST,
    output                      s_ARLOCK,
    output     [3:0]            s_ARCACHE,
    output     [2:0]            s_ARPROT,
    output     [3:0]            s_ARQOS,
    output     [3:0]            s_ARREGION,
    output     [USER_WIDTH-1:0] s_ARUSER,
    output                      s_ARVALID,
	input	  		            s_ARREADY,
    // R Channel
	input	   [ID_WIDTH-1:0]   s_RID,
	input	   [DATA_WIDTH-1:0] s_RDATA,
	input	   [1:0]	        s_RRESP,
	input	  		            s_RLAST,
	input	   [USER_WIDTH-1:0]	s_RUSER,
	input	 		            s_RVALID, 
    output                      s_RREADY
);

    // AR Channel
    wire [ID_WIDTH-1:0]   r0_ARID;    
    wire [ADDR_WIDTH-1:0] r0_ARADDR;
    wire [7:0]            r0_ARLEN;
    wire [2:0]            r0_ARSIZE;
    wire [1:0]            r0_ARBURST;
    wire                  r0_ARLOCK;
    wire [3:0]            r0_ARCACHE;
    wire [2:0]            r0_ARPROT;
    wire [3:0]            r0_ARQOS;
    wire [3:0]            r0_ARREGION;
    wire [USER_WIDTH-1:0] r0_ARUSER;
    wire                  r0_ARVALID;
    wire                  r0_ARREADY;
    // R Channel
	wire [ID_WIDTH-1:0]   r0_RID;
	wire [DATA_WIDTH-1:0] r0_RDATA;
	wire [1:0]	          r0_RRESP;
	wire 	              r0_RLAST;
	wire [USER_WIDTH-1:0] r0_RUSER;
	wire 	              r0_RVALID; 
    wire                  r0_RREADY;
    
    // for fix E_E bug
    reg is_E_E;
    wire                  r0_is_busy_fetch_mem;
    reg  [ADDR_WIDTH-1:0] r0_ARADDR_reg;
    
    // for fix WB_hit_mis bug
    wire                  m0_write_enable;
    wire                  m1_write_enable;
    
    wire                  m0_read_enable;
    wire                  m1_read_enable;
    
    wire                  m0_is_shareable_busy_WB;   
    wire                  m1_is_shareable_busy_WB;
    
    wire [ADDR_WIDTH-1:0] m0_current_shareable_AWADDR;
    wire [ADDR_WIDTH-1:0] m1_current_shareable_AWADDR;
    
    wire                  m0_is_shareable_busy_R;
    wire                  m1_is_shareable_busy_R;
    
    wire [ADDR_WIDTH-1:0] m0_current_shareable_ARADDR;
    wire [ADDR_WIDTH-1:0] m1_current_shareable_ARADDR;
    
    assign m0_write_enable = m1_is_shareable_busy_R ? (m0_AWADDR[31:6] ^ m1_current_shareable_ARADDR[31:6]) : 1;
    assign m1_write_enable = m0_is_shareable_busy_R ? (m1_AWADDR[31:6] ^ m0_current_shareable_ARADDR[31:6]) : 1;
    
    assign m0_read_enable = m1_is_shareable_busy_WB ? (m0_ARADDR[31:6] ^ m1_current_shareable_AWADDR[31:6]) : 1;
    assign m1_read_enable = m0_is_shareable_busy_WB ? (m1_ARADDR[31:6] ^ m0_current_shareable_AWADDR[31:6]) : 1;
    
    ACE_Controller_R
    #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH),
        .ID_WIDTH  (ID_WIDTH  ),
        .USER_WIDTH(USER_WIDTH),
        .STRB_WIDTH(STRB_WIDTH)
    )
    uACE_Controller_R_coreA
    (
        /********* System signals *********/
        .ACLK(ACLK),
        .ARESETn(ARESETn),
        
        // AR Channel
        .m_ARID     (m0_ARID    ), // use default value: 0x0
        .m_ARADDR   (m0_ARADDR  ),
        .m_ARLEN    (m0_ARLEN   ),
        .m_ARSIZE   (m0_ARSIZE  ),  // use default value: Data bus width = 32-bit -> ARSIZE = 0x2
        .m_ARBURST  (m0_ARBURST ), // use default value: 0x1(), INCR  
        .m_ARLOCK   (m0_ARLOCK  ),
        .m_ARCACHE  (m0_ARCACHE ),
        .m_ARPROT   (m0_ARPROT  ),
        .m_ARQOS    (m0_ARQOS   ),
        .m_ARREGION (m0_ARREGION),
        .m_ARUSER   (m0_ARUSER  ),
        .m_ARDOMAIN (m0_ARDOMAIN),
        .m_ARSNOOP  (m0_ARSNOOP ),
        .m_ARVALID  (m0_ARVALID & m0_read_enable),
        .m_ARREADY  (m0_ARREADY ),
        
        // R Channel
        .m_RID      (m0_RID   ),  // use default value: 0x0
        .m_RDATA    (m0_RDATA ),
        .m_RRESP    (m0_RRESP ),
        .m_RLAST    (m0_RLAST ),
        .m_RUSER    (m0_RUSER ),
        .m_RVALID   (m0_RVALID),
        .m_RREADY   (m0_RREADY),
        
        // Snoop Channels
        // AC Channel
        .ACVALID    (m0_ACVALID),
        .ACADDR     (m0_ACADDR ),
        .ACSNOOP    (m0_ACSNOOP),
        .ACPROT     (m0_ACPROT ),
        .ACREADY    (m0_ACREADY),
        
        // CR Channel
        .CRREADY    (m0_CRREADY),
        .CRVALID    (m0_CRVALID),
        .CRRESP     (m0_CRRESP ),
        
        // CD Channel
        .CDREADY    (m0_CDREADY),
        .CDVALID    (m0_CDVALID),
        .CDDATA     (m0_CDDATA ),
        .CDLAST     (m0_CDLAST ),
        
        // AR Channel
        .s_ARID     (r0_ARID    ),    
        .s_ARADDR   (r0_ARADDR  ),
        .s_ARLEN    (r0_ARLEN   ),
        .s_ARSIZE   (r0_ARSIZE  ),
        .s_ARBURST  (r0_ARBURST ),
        .s_ARLOCK   (r0_ARLOCK  ),
        .s_ARCACHE  (r0_ARCACHE ),
        .s_ARPROT   (r0_ARPROT  ),
        .s_ARQOS    (r0_ARQOS   ),
        .s_ARREGION (r0_ARREGION),
        .s_ARUSER   (r0_ARUSER  ),
        .s_ARVALID  (r0_ARVALID ),
        .s_ARREADY  (r0_ARREADY ),
        // R Channel
        .s_RID      (r0_RID   ),
        .s_RDATA    (r0_RDATA ),
        .s_RRESP    (r0_RRESP ),
        .s_RLAST    (r0_RLAST ),
        .s_RUSER    (r0_RUSER ),
        .s_RVALID   (r0_RVALID), 
        .s_RREADY   (r0_RREADY),
        
        // for fix E_E bug
        .is_busy_fetch_mem(r0_is_busy_fetch_mem),
        .is_E_E(is_E_E),
        
        // for fix WB_hit_mis but
        .is_shareable_busy(m0_is_shareable_busy_R),
        .current_shareable_ARADDR(m0_current_shareable_ARADDR)
    );
    
    // AR Channel
    wire [ID_WIDTH-1:0]   r1_ARID;    
    wire [ADDR_WIDTH-1:0] r1_ARADDR;
    wire [7:0]            r1_ARLEN;
    wire [2:0]            r1_ARSIZE;
    wire [1:0]            r1_ARBURST;
    wire                  r1_ARLOCK;
    wire [3:0]            r1_ARCACHE;
    wire [2:0]            r1_ARPROT;
    wire [3:0]            r1_ARQOS;
    wire [3:0]            r1_ARREGION;
    wire [USER_WIDTH-1:0] r1_ARUSER;
    wire                  r1_ARVALID;
    wire                  r1_ARREADY;
    // R Channel
	wire [ID_WIDTH-1:0]   r1_RID;
	wire [DATA_WIDTH-1:0] r1_RDATA;
	wire [1:0]	          r1_RRESP;
	wire 	              r1_RLAST;
	wire [USER_WIDTH-1:0] r1_RUSER;
	wire 	              r1_RVALID; 
    wire                  r1_RREADY;
    
    // for fix E_E bug
    wire                  r1_is_busy_fetch_mem;
    reg  [ADDR_WIDTH-1:0] r1_ARADDR_reg;
    
    ACE_Controller_R
    #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH),
        .ID_WIDTH  (ID_WIDTH  ),
        .USER_WIDTH(USER_WIDTH),
        .STRB_WIDTH(STRB_WIDTH)
    )
    uACE_Controller_R_coreB
    (
        /********* System signals *********/
        .ACLK(ACLK),
        .ARESETn(ARESETn),
        
        // AR Channel
        .m_ARID     (m1_ARID    ), // use default value: 0x0
        .m_ARADDR   (m1_ARADDR  ),
        .m_ARLEN    (m1_ARLEN   ),
        .m_ARSIZE   (m1_ARSIZE  ),  // use default value: Data bus width = 32-bit -> ARSIZE = 0x2
        .m_ARBURST  (m1_ARBURST ), // use default value: 0x1(), INCR  
        .m_ARLOCK   (m1_ARLOCK  ),
        .m_ARCACHE  (m1_ARCACHE ),
        .m_ARPROT   (m1_ARPROT  ),
        .m_ARQOS    (m1_ARQOS   ),
        .m_ARREGION (m1_ARREGION),
        .m_ARUSER   (m1_ARUSER  ),
        .m_ARDOMAIN (m1_ARDOMAIN),
        .m_ARSNOOP  (m1_ARSNOOP ),
        .m_ARVALID  (m1_ARVALID & m1_read_enable),
        .m_ARREADY  (m1_ARREADY ),
        
        // R Channel
        .m_RID      (m1_RID   ),  // use default value: 0x0
        .m_RDATA    (m1_RDATA ),
        .m_RRESP    (m1_RRESP ),
        .m_RLAST    (m1_RLAST ),
        .m_RUSER    (m1_RUSER ),
        .m_RVALID   (m1_RVALID),
        .m_RREADY   (m1_RREADY),
        
        // Snoop Channels
        // AC Channel
        .ACVALID    (m1_ACVALID),
        .ACADDR     (m1_ACADDR ),
        .ACSNOOP    (m1_ACSNOOP),
        .ACPROT     (m1_ACPROT ),
        .ACREADY    (m1_ACREADY),
        
        // CR Channel
        .CRREADY    (m1_CRREADY),
        .CRVALID    (m1_CRVALID),
        .CRRESP     (m1_CRRESP ),
        
        // CD Channel
        .CDREADY    (m1_CDREADY),
        .CDVALID    (m1_CDVALID),
        .CDDATA     (m1_CDDATA ),
        .CDLAST     (m1_CDLAST ),
        
        // AR Channel
        .s_ARID     (r1_ARID    ),    
        .s_ARADDR   (r1_ARADDR  ),
        .s_ARLEN    (r1_ARLEN   ),
        .s_ARSIZE   (r1_ARSIZE  ),
        .s_ARBURST  (r1_ARBURST ),
        .s_ARLOCK   (r1_ARLOCK  ),
        .s_ARCACHE  (r1_ARCACHE ),
        .s_ARPROT   (r1_ARPROT  ),
        .s_ARQOS    (r1_ARQOS   ),
        .s_ARREGION (r1_ARREGION),
        .s_ARUSER   (r1_ARUSER  ),
        .s_ARVALID  (r1_ARVALID ),
        .s_ARREADY  (r1_ARREADY ),
        // R Channel
        .s_RID      (r1_RID   ),
        .s_RDATA    (r1_RDATA ),
        .s_RRESP    (r1_RRESP ),
        .s_RLAST    (r1_RLAST ),
        .s_RUSER    (r1_RUSER ),
        .s_RVALID   (r1_RVALID), 
        .s_RREADY   (r1_RREADY),
        
        // for fix E_E bug
        .is_busy_fetch_mem(r1_is_busy_fetch_mem),
        .is_E_E(is_E_E),
        
        // for fix WB_hit_mis but
        .is_shareable_busy(m1_is_shareable_busy_R),
        .current_shareable_ARADDR(m1_current_shareable_ARADDR)
    );
    
    // to fix E_E bug
    reg m0_done;
    reg m1_done;
    
    always @(posedge ACLK) begin
        if (!ARESETn) begin
            is_E_E        <= 0;
            r0_ARADDR_reg <= 0;
            r1_ARADDR_reg <= 0;
            m0_done       <= 0;
            m1_done       <= 0;
        end
        else begin
            if (m0_ARVALID) begin
                r0_ARADDR_reg <= m0_ARADDR;
                // m0_done <= 0;
            end
            if (m1_ARVALID) begin
                r1_ARADDR_reg <= m1_ARADDR;
                // m1_done <= 0;
            end
            
            if (r0_RVALID && r0_RLAST && r0_RREADY) begin
                m0_done <= 1;
            end
            if (r1_RVALID && r1_RLAST && r1_RREADY) begin
                m1_done <= 1;
            end
            
            if (r0_is_busy_fetch_mem & r1_is_busy_fetch_mem & (!(r0_ARADDR_reg[31:6] ^ r1_ARADDR_reg[31:6]))) begin
                is_E_E <= 1;
            end
            
            if (m0_done && m1_done) begin
                m0_done <= 0;
                m1_done <= 0;
                is_E_E  <= 0;
            end
        end
    end
    
    // assign is_E_E = (r0_is_busy_fetch_mem & r1_is_busy_fetch_mem & (!(r0_ARADDR_reg[31:6] ^ r1_ARADDR_reg[31:6]))) ? 1 : 0;
    
    // AW Channel
    wire [ID_WIDTH-1:0]   w0_AWID;
    wire [ADDR_WIDTH-1:0] w0_AWADDR;
    wire [7:0]            w0_AWLEN;
    wire [2:0]            w0_AWSIZE;
    wire [1:0]            w0_AWBURST;
    wire                  w0_AWLOCK;
    wire [3:0]            w0_AWCACHE;
    wire [2:0]            w0_AWPROT;
    wire [3:0]            w0_AWQOS;
    wire [3:0]            w0_AWREGION;
    wire [USER_WIDTH-1:0] w0_AWUSER;
    wire                  w0_AWVALID;
    wire 	              w0_AWREADY;
    // W Channel
    // output     [ID_WIDTH-1:0]   s_WID;
    wire [DATA_WIDTH-1:0] w0_WDATA;
    wire [STRB_WIDTH-1:0] w0_WSTRB;
    wire                  w0_WLAST;
    wire [USER_WIDTH-1:0] w0_WUSER;
    wire                  w0_WVALID;
    wire		          w0_WREADY;
    // B Channel
	wire [ID_WIDTH-1:0]	  w0_BID;
	wire [1:0]	          w0_BRESP;
	wire [USER_WIDTH-1:0] w0_BUSER;
	wire   		          w0_BVALID;
    wire                  w0_BREADY;
    
    ACE_Controller_W
    #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH),
        .ID_WIDTH  (ID_WIDTH  ),
        .USER_WIDTH(USER_WIDTH),
        .STRB_WIDTH(STRB_WIDTH)
    )
    uACE_Controller_W_coreA
    (
        /********* System signals *********/
        .ACLK(ACLK),
        .ARESETn(ARESETn),
        
        // input
        // AW Channel
        .i_AWID     (m0_AWID    ), // use default value: 0x0
        .i_AWADDR   (m0_AWADDR  ),
        .i_AWLEN    (m0_AWLEN   ),
        .i_AWSIZE   (m0_AWSIZE  ),  // use default value: Data bus width = 32-bit -> AWSIZE = 0x2
        .i_AWBURST  (m0_AWBURST ), // use default value: 0x1(), INCR
        .i_AWLOCK   (m0_AWLOCK  ),
        .i_AWCACHE  (m0_AWCACHE ),
        .i_AWPROT   (m0_AWPROT  ),
        .i_AWQOS    (m0_AWQOS   ),
        .i_AWREGION (m0_AWREGION),
        .i_AWUSER   (m0_AWUSER  ),   
        .i_AWDOMAIN (m0_AWDOMAIN),
        .i_AWSNOOP  (m0_AWSNOOP ),
        .i_AWVALID  (m0_AWVALID & m0_write_enable),
        .i_AWREADY  (w0_AWREADY ),
        
        // W Channel
        // output  s_WID(),  // use default value: 0x0
        .i_WDATA    (m0_WDATA ),
        .i_WSTRB    (m0_WSTRB ),  // use default value: 0xF
        .i_WLAST    (m0_WLAST ),
        .i_WUSER    (m0_WUSER ),
        .i_WVALID   (m0_WVALID),
        .i_WREADY   (w0_WREADY),
        
        // B Channel
        .i_BID      (w0_BID   ),  // use default value: 0x0
        .i_BRESP    (w0_BRESP ),  
        .i_BUSER    (w0_BUSER ),
        .i_BVALID   (w0_BVALID),
        .i_BREADY   (m0_BREADY),
        
        // output
        // AW Channel
        .o_AWID     (w0_AWID    ), // use default value: 0x0
        .o_AWADDR   (w0_AWADDR  ),
        .o_AWLEN    (w0_AWLEN   ),
        .o_AWSIZE   (w0_AWSIZE  ),  // use default value: Data bus width = 32-bit -> AWSIZE = 0x2
        .o_AWBURST  (w0_AWBURST ), // use default value: 0x1(), INCR
        .o_AWLOCK   (w0_AWLOCK  ),
        .o_AWCACHE  (w0_AWCACHE ),
        .o_AWPROT   (w0_AWPROT  ),
        .o_AWQOS    (w0_AWQOS   ),
        .o_AWREGION (w0_AWREGION),
        .o_AWUSER   (w0_AWUSER  ),   
        // output  reg [1:0]                o_AWDOMAIN(),
        // output  reg [2:0]                o_AWSNOOP(),
        .o_AWVALID  (w0_AWVALID),
        .o_AWREADY  (m0_AWREADY),
        
        // W Channel
        // output  s_WID(),  // use default value: 0x0
        .o_WDATA    (w0_WDATA ),
        .o_WSTRB    (w0_WSTRB ),  // use default value: 0xF
        .o_WLAST    (w0_WLAST ),
        .o_WUSER    (w0_WUSER ),
        .o_WVALID   (w0_WVALID),
        .o_WREADY   (m0_WREADY),
        
        // B Channel
        .o_BID      (m0_BID   ),  // use default value: 0x0
        .o_BRESP    (m0_BRESP ),  
        .o_BUSER    (m0_BUSER ),
        .o_BVALID   (m0_BVALID),
        .o_BREADY   (w0_BREADY),
    
        // for fix WB_hit_mis bug
        .is_shareable_busy_WB(m0_is_shareable_busy_WB),
        .current_shareable_AWADDR(m0_current_shareable_AWADDR)
    );
    
    // AW Channel
    wire [ID_WIDTH-1:0]   w1_AWID;
    wire [ADDR_WIDTH-1:0] w1_AWADDR;
    wire [7:0]            w1_AWLEN;
    wire [2:0]            w1_AWSIZE;
    wire [1:0]            w1_AWBURST;
    wire                  w1_AWLOCK;
    wire [3:0]            w1_AWCACHE;
    wire [2:0]            w1_AWPROT;
    wire [3:0]            w1_AWQOS;
    wire [3:0]            w1_AWREGION;
    wire [USER_WIDTH-1:0] w1_AWUSER;
    wire                  w1_AWVALID;
    wire 	              w1_AWREADY;
    // W Channel
    // output     [ID_WIDTH-1:0]   s_WID;
    wire [DATA_WIDTH-1:0] w1_WDATA;
    wire [STRB_WIDTH-1:0] w1_WSTRB;
    wire                  w1_WLAST;
    wire [USER_WIDTH-1:0] w1_WUSER;
    wire                  w1_WVALID;
    wire		          w1_WREADY;
    // B Channel
	wire [ID_WIDTH-1:0]	  w1_BID;
	wire [1:0]	          w1_BRESP;
	wire [USER_WIDTH-1:0] w1_BUSER;
	wire   		          w1_BVALID;
    wire                  w1_BREADY;
    
    ACE_Controller_W
    #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH),
        .ID_WIDTH  (ID_WIDTH  ),
        .USER_WIDTH(USER_WIDTH),
        .STRB_WIDTH(STRB_WIDTH)
    )
    uACE_Controller_W_coreB
    (
        /********* System signals *********/
        .ACLK(ACLK),
        .ARESETn(ARESETn),
        
        // input
        // AW Channel
        .i_AWID     (m1_AWID    ), // use default value: 0x0
        .i_AWADDR   (m1_AWADDR  ),
        .i_AWLEN    (m1_AWLEN   ),
        .i_AWSIZE   (m1_AWSIZE  ),  // use default value: Data bus width = 32-bit -> AWSIZE = 0x2
        .i_AWBURST  (m1_AWBURST ), // use default value: 0x1(), INCR
        .i_AWLOCK   (m1_AWLOCK  ),
        .i_AWCACHE  (m1_AWCACHE ),
        .i_AWPROT   (m1_AWPROT  ),
        .i_AWQOS    (m1_AWQOS   ),
        .i_AWREGION (m1_AWREGION),
        .i_AWUSER   (m1_AWUSER  ),   
        .i_AWDOMAIN (m1_AWDOMAIN),
        .i_AWSNOOP  (m1_AWSNOOP ),
        .i_AWVALID  (m1_AWVALID & m1_write_enable),
        .i_AWREADY  (w1_AWREADY ),
        
        // W Channel
        // output  s_WID(),  // use default value: 0x0
        .i_WDATA    (m1_WDATA ),
        .i_WSTRB    (m1_WSTRB ),  // use default value: 0xF
        .i_WLAST    (m1_WLAST ),
        .i_WUSER    (m1_WUSER ),
        .i_WVALID   (m1_WVALID),
        .i_WREADY   (w1_WREADY),
        
        // B Channel
        .i_BID      (w1_BID   ),  // use default value: 0x0
        .i_BRESP    (w1_BRESP ),  
        .i_BUSER    (w1_BUSER ),
        .i_BVALID   (w1_BVALID),
        .i_BREADY   (m1_BREADY),
        
        // output
        // AW Channel
        .o_AWID     (w1_AWID    ), // use default value: 0x0
        .o_AWADDR   (w1_AWADDR  ),
        .o_AWLEN    (w1_AWLEN   ),
        .o_AWSIZE   (w1_AWSIZE  ),  // use default value: Data bus width = 32-bit -> AWSIZE = 0x2
        .o_AWBURST  (w1_AWBURST ), // use default value: 0x1(), INCR
        .o_AWLOCK   (w1_AWLOCK  ),
        .o_AWCACHE  (w1_AWCACHE ),
        .o_AWPROT   (w1_AWPROT  ),
        .o_AWQOS    (w1_AWQOS   ),
        .o_AWREGION (w1_AWREGION),
        .o_AWUSER   (w1_AWUSER  ),   
        // output  reg [1:0]                o_AWDOMAIN(),
        // output  reg [2:0]                o_AWSNOOP(),
        .o_AWVALID  (w1_AWVALID),
        .o_AWREADY  (m1_AWREADY),
        
        // W Channel
        // output  s_WID(),  // use default value: 0x0
        .o_WDATA    (w1_WDATA ),
        .o_WSTRB    (w1_WSTRB ),  // use default value: 0xF
        .o_WLAST    (w1_WLAST ),
        .o_WUSER    (w1_WUSER ),
        .o_WVALID   (w1_WVALID),
        .o_WREADY   (m1_WREADY),
        
        // B Channel
        .o_BID      (m1_BID   ),  // use default value: 0x0
        .o_BRESP    (m1_BRESP ),  
        .o_BUSER    (m1_BUSER ),
        .o_BVALID   (m1_BVALID),
        .o_BREADY   (w1_BREADY),
    
        // for fix WB_hit_mis bug
        .is_shareable_busy_WB(m1_is_shareable_busy_WB),
        .current_shareable_AWADDR(m1_current_shareable_AWADDR)
    );
    
    AXI_Interconnect #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH),
        .ID_WIDTH(ID_WIDTH),
        .USER_WIDTH(USER_WIDTH),
        .STRB_WIDTH(STRB_WIDTH)
    )
    uAXI_Interconnect
    (
        /********* System signals *********/
        .ACLK(ACLK),
        .ARESETn(ARESETn),
        /********** Master 0 **********/
        // AW Channel
        .m0_AWID    (w0_AWID    ),
        .m0_AWADDR  (w0_AWADDR  ),
        .m0_AWLEN   (w0_AWLEN   ),
        .m0_AWSIZE  (w0_AWSIZE  ),
        .m0_AWBURST (w0_AWBURST ),
        .m0_AWLOCK  (w0_AWLOCK  ),
        .m0_AWCACHE (w0_AWCACHE ),
        .m0_AWPROT  (w0_AWPROT  ),
        .m0_AWQOS   (w0_AWQOS   ),
        .m0_AWREGION(w0_AWREGION),
        .m0_AWUSER  (w0_AWUSER  ),
        .m0_AWVALID (w0_AWVALID ),
        .m0_AWREADY (w0_AWREADY ),
        // W Channel
        // input      [ID_WIDTH-1:0]   m0_WID,
        .m0_WDATA   (w0_WDATA ),
        .m0_WSTRB   (w0_WSTRB ),
        .m0_WLAST   (w0_WLAST ),
        .m0_WUSER   (w0_WUSER ),
        .m0_WVALID  (w0_WVALID),
        .m0_WREADY  (w0_WREADY),
        // B Channel
        .m0_BID     (w0_BID   ),
        .m0_BRESP   (w0_BRESP ),
        .m0_BUSER   (w0_BUSER ),
        .m0_BVALID  (w0_BVALID),
        .m0_BREADY  (w0_BREADY),
        // AR Channel
        .m0_ARID    (r0_ARID    ),
        .m0_ARADDR  (r0_ARADDR  ),
        .m0_ARLEN   (r0_ARLEN   ),
        .m0_ARSIZE  (r0_ARSIZE  ),
        .m0_ARBURST (r0_ARBURST ),
        .m0_ARLOCK  (r0_ARLOCK  ),
        .m0_ARCACHE (r0_ARCACHE ),
        .m0_ARPROT  (r0_ARPROT  ),
        .m0_ARQOS   (r0_ARQOS   ),
        .m0_ARREGION(r0_ARREGION),
        .m0_ARUSER  (r0_ARUSER  ),
        .m0_ARVALID (r0_ARVALID ),
        .m0_ARREADY (r0_ARREADY ),
        // R Channel
        .m0_RID     (r0_RID   ),
        .m0_RDATA   (r0_RDATA ),
        .m0_RRESP   (r0_RRESP ),
        .m0_RLAST   (r0_RLAST ),
        .m0_RUSER   (r0_RUSER ),
        .m0_RVALID  (r0_RVALID),
        .m0_RREADY  (r0_RREADY),
        /********** Master 1 **********/
        // AW Channel
        .m1_AWID    (w1_AWID    ),
        .m1_AWADDR  (w1_AWADDR  ),
        .m1_AWLEN   (w1_AWLEN   ),
        .m1_AWSIZE  (w1_AWSIZE  ),
        .m1_AWBURST (w1_AWBURST ),
        .m1_AWLOCK  (w1_AWLOCK  ),
        .m1_AWCACHE (w1_AWCACHE ),
        .m1_AWPROT  (w1_AWPROT  ),
        .m1_AWQOS   (w1_AWQOS   ),
        .m1_AWREGION(w1_AWREGION),
        .m1_AWUSER  (w1_AWUSER  ),
        .m1_AWVALID (w1_AWVALID ),
        .m1_AWREADY (w1_AWREADY ),
        // W Channel
        // input      [ID_WIDTH-1:0]   m1_WID,
        .m1_WDATA   (w1_WDATA ),
        .m1_WSTRB   (w1_WSTRB ),
        .m1_WLAST   (w1_WLAST ),
        .m1_WUSER   (w1_WUSER ),
        .m1_WVALID  (w1_WVALID),
        .m1_WREADY  (w1_WREADY),
        // B Channel
        .m1_BID     (w1_BID   ),
        .m1_BRESP   (w1_BRESP ),
        .m1_BUSER   (w1_BUSER ),
        .m1_BVALID  (w1_BVALID),
        .m1_BREADY  (w1_BREADY),
        // AR Channel
        .m1_ARID    (r1_ARID    ),
        .m1_ARADDR  (r1_ARADDR  ),
        .m1_ARLEN   (r1_ARLEN   ),
        .m1_ARSIZE  (r1_ARSIZE  ),
        .m1_ARBURST (r1_ARBURST ),
        .m1_ARLOCK  (r1_ARLOCK  ),
        .m1_ARCACHE (r1_ARCACHE ),
        .m1_ARPROT  (r1_ARPROT  ),
        .m1_ARQOS   (r1_ARQOS   ),
        .m1_ARREGION(r1_ARREGION),
        .m1_ARUSER  (r1_ARUSER  ),
        .m1_ARVALID (r1_ARVALID ),
        .m1_ARREADY (r1_ARREADY ),
        // R Channel
        .m1_RID     (r1_RID   ),
        .m1_RDATA   (r1_RDATA ),
        .m1_RRESP   (r1_RRESP ),
        .m1_RLAST   (r1_RLAST ),
        .m1_RUSER   (r1_RUSER ),
        .m1_RVALID  (r1_RVALID),
        .m1_RREADY  (r1_RREADY),
        
        /********** Master 2 **********/
        // AW Channel
        .m2_AWID    (m2_AWID    ),
        .m2_AWADDR  (m2_AWADDR  ),
        .m2_AWLEN   (m2_AWLEN   ),
        .m2_AWSIZE  (m2_AWSIZE  ),
        .m2_AWBURST (m2_AWBURST ),
        .m2_AWLOCK  (m2_AWLOCK  ),
        .m2_AWCACHE (m2_AWCACHE ),
        .m2_AWPROT  (m2_AWPROT  ),
        .m2_AWQOS   (m2_AWQOS   ),
        .m2_AWREGION(m2_AWREGION),
        .m2_AWUSER  (m2_AWUSER  ),
        .m2_AWVALID (m2_AWVALID ),
        .m2_AWREADY (m2_AWREADY ),
        // W Channel
        // input      [ID_WIDTH-1:0]   m2_WID,
        .m2_WDATA   (m2_WDATA ),
        .m2_WSTRB   (m2_WSTRB ),
        .m2_WLAST   (m2_WLAST ),
        .m2_WUSER   (m2_WUSER ),
        .m2_WVALID  (m2_WVALID),
        .m2_WREADY  (m2_WREADY),
        // B Channel
        .m2_BID     (m2_BID   ),
        .m2_BRESP   (m2_BRESP ),
        .m2_BUSER   (m2_BUSER ),
        .m2_BVALID  (m2_BVALID),
        .m2_BREADY  (m2_BREADY),
        // AR Channel
        .m2_ARID    (m2_ARID    ),
        .m2_ARADDR  (m2_ARADDR  ),
        .m2_ARLEN   (m2_ARLEN   ),
        .m2_ARSIZE  (m2_ARSIZE  ),
        .m2_ARBURST (m2_ARBURST ),
        .m2_ARLOCK  (m2_ARLOCK  ),
        .m2_ARCACHE (m2_ARCACHE ),
        .m2_ARPROT  (m2_ARPROT  ),
        .m2_ARQOS   (m2_ARQOS   ),
        .m2_ARREGION(m2_ARREGION),
        .m2_ARUSER  (m2_ARUSER  ),
        .m2_ARVALID (m2_ARVALID ),
        .m2_ARREADY (m2_ARREADY ),
        // R Channel
        .m2_RID     (m2_RID   ),
        .m2_RDATA   (m2_RDATA ),
        .m2_RRESP   (m2_RRESP ),
        .m2_RLAST   (m2_RLAST ),
        .m2_RUSER   (m2_RUSER ),
        .m2_RVALID  (m2_RVALID),
        .m2_RREADY  (m2_RREADY),
        
        /********** Master 3 **********/
        // AW Channel
        .m3_AWID    (m3_AWID    ),
        .m3_AWADDR  (m3_AWADDR  ),
        .m3_AWLEN   (m3_AWLEN   ),
        .m3_AWSIZE  (m3_AWSIZE  ),
        .m3_AWBURST (m3_AWBURST ),
        .m3_AWLOCK  (m3_AWLOCK  ),
        .m3_AWCACHE (m3_AWCACHE ),
        .m3_AWPROT  (m3_AWPROT  ),
        .m3_AWQOS   (m3_AWQOS   ),
        .m3_AWREGION(m3_AWREGION),
        .m3_AWUSER  (m3_AWUSER  ),
        .m3_AWVALID (m3_AWVALID ),
        .m3_AWREADY (m3_AWREADY ),
        // W Channel
        // input      [ID_WIDTH-1:0]   m2_WID,
        .m3_WDATA   (m3_WDATA ),
        .m3_WSTRB   (m3_WSTRB ),
        .m3_WLAST   (m3_WLAST ),
        .m3_WUSER   (m3_WUSER ),
        .m3_WVALID  (m3_WVALID),
        .m3_WREADY  (m3_WREADY),
        // B Channel
        .m3_BID     (m3_BID   ),
        .m3_BRESP   (m3_BRESP ),
        .m3_BUSER   (m3_BUSER ),
        .m3_BVALID  (m3_BVALID),
        .m3_BREADY  (m3_BREADY),
        // AR Channel
        .m3_ARID    (m3_ARID    ),
        .m3_ARADDR  (m3_ARADDR  ),
        .m3_ARLEN   (m3_ARLEN   ),
        .m3_ARSIZE  (m3_ARSIZE  ),
        .m3_ARBURST (m3_ARBURST ),
        .m3_ARLOCK  (m3_ARLOCK  ),
        .m3_ARCACHE (m3_ARCACHE ),
        .m3_ARPROT  (m3_ARPROT  ),
        .m3_ARQOS   (m3_ARQOS   ),
        .m3_ARREGION(m3_ARREGION),
        .m3_ARUSER  (m3_ARUSER  ),
        .m3_ARVALID (m3_ARVALID ),
        .m3_ARREADY (m3_ARREADY ),
        // R Channel
        .m3_RID     (m3_RID   ),
        .m3_RDATA   (m3_RDATA ),
        .m3_RRESP   (m3_RRESP ),
        .m3_RLAST   (m3_RLAST ),
        .m3_RUSER   (m3_RUSER ),
        .m3_RVALID  (m3_RVALID),
        .m3_RREADY  (m3_RREADY),
    
        /********** Slave **********/
        // AW Channel
        .s_AWID     (s_AWID    ),
        .s_AWADDR   (s_AWADDR  ),
        .s_AWLEN    (s_AWLEN   ),
        .s_AWSIZE   (s_AWSIZE  ),
        .s_AWBURST  (s_AWBURST ),
        .s_AWLOCK   (s_AWLOCK  ),
        .s_AWCACHE  (s_AWCACHE ),
        .s_AWPROT   (s_AWPROT  ),
        .s_AWQOS    (s_AWQOS   ),
        .s_AWREGION (s_AWREGION),
        .s_AWUSER   (s_AWUSER  ),
        .s_AWVALID  (s_AWVALID ),
        .s_AWREADY  (s_AWREADY ),
        // W Channel
        // output     [ID_WIDTH-1:0]   s_WID,
        .s_WDATA    (s_WDATA ),
        .s_WSTRB    (s_WSTRB ),
        .s_WLAST    (s_WLAST ),
        .s_WUSER    (s_WUSER ),
        .s_WVALID   (s_WVALID),
        .s_WREADY   (s_WREADY),
        // B Channel
        .s_BID      (s_BID   ),
        .s_BRESP    (s_BRESP ),
        .s_BUSER    (s_BUSER ),
        .s_BVALID   (s_BVALID),
        .s_BREADY   (s_BREADY),
        // AR Channel
        .s_ARID     (s_ARID    ),    
        .s_ARADDR   (s_ARADDR  ),
        .s_ARLEN    (s_ARLEN   ),
        .s_ARSIZE   (s_ARSIZE  ),
        .s_ARBURST  (s_ARBURST ),
        .s_ARLOCK   (s_ARLOCK  ),
        .s_ARCACHE  (s_ARCACHE ),
        .s_ARPROT   (s_ARPROT  ),
        .s_ARQOS    (s_ARQOS   ),
        .s_ARREGION (s_ARREGION),
        .s_ARUSER   (s_ARUSER  ),
        .s_ARVALID  (s_ARVALID ),
        .s_ARREADY  (s_ARREADY ),
        // R Channel
        .s_RID      (s_RID   ),
        .s_RDATA    (s_RDATA ),
        .s_RRESP    (s_RRESP ),
        .s_RLAST    (s_RLAST ),
        .s_RUSER    (s_RUSER ),
        .s_RVALID   (s_RVALID), 
        .s_RREADY   (s_RREADY)
    );
    
endmodule