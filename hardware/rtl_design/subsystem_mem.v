`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// this is top module of Subsystem + Main memory
//////////////////////////////////////////////////////////////////////////////////


module subsystem_mem
#(
    parameter DATA_WIDTH  = 32,
    parameter ADDR_WIDTH  = 32,
    parameter ID_WIDTH    = 1,
    parameter USER_WIDTH  = 4,
    parameter STRB_WIDTH  = (DATA_WIDTH/8),
    parameter SHAREABLE_REGION_START = 32'h0002_0000, // start address of shareable region
    parameter SHAREABLE_REGION_END   = 32'h0003_FFFF,  // end address of shareable region
    parameter DMEM_INIT   = "D:/University/KLTN/hw_design/coherence_cache/coherence_cache.srcs/sources_1/new/mem_init.mem"
)
(
     // system signals
    input                       ACLK,
    input                       ARESETn,
    
    // Master 0
    input                       m0_ENABLE,
    output                      m0_CACHE_HIT,
    output                      m0_CACHE_BUSY,
    
    // AXI Interface (connect with CPU)
    // AW Channel
    input   [ID_WIDTH-1:0]      m0_AWID,
    input   [ADDR_WIDTH-1:0]    m0_AWADDR,
    input   [7:0]               m0_AWLEN,
    input   [2:0]               m0_AWSIZE,
    input   [1:0]               m0_AWBURST,
    input                       m0_AWLOCK,
    input   [3:0]               m0_AWCACHE,
    input   [2:0]               m0_AWPROT,
    input   [3:0]               m0_AWQOS,
    input   [3:0]               m0_AWREGION,
    input   [USER_WIDTH-1:0]    m0_AWUSER,
    input   [1:0]               m0_AWDOMAIN,
    input                       m0_AWVALID,
    output                      m0_AWREADY,
    
    // W Channel
    input   [DATA_WIDTH-1:0]    m0_WDATA,
    input   [STRB_WIDTH-1:0]    m0_WSTRB, 
    input                       m0_WLAST,
    input   [USER_WIDTH-1:0]    m0_WUSER,
    input                       m0_WVALID,
    output                      m0_WREADY,
    
    // B Channel
    output  [ID_WIDTH-1:0]      m0_BID,
    output  [1:0]               m0_BRESP,
    output  [USER_WIDTH-1:0]    m0_BUSER,
    output                      m0_BVALID,
    input                       m0_BREADY,
    
    // AR Channel
    input   [ID_WIDTH-1:0]      m0_ARID,
    input   [ADDR_WIDTH-1:0]    m0_ARADDR,
    input   [7:0]               m0_ARLEN,
    input   [2:0]               m0_ARSIZE,
    input   [1:0]               m0_ARBURST,
    input                       m0_ARLOCK,
    input   [3:0]               m0_ARCACHE,
    input   [2:0]               m0_ARPROT,
    input   [3:0]               m0_ARQOS,
    input   [3:0]               m0_ARREGION,
    input   [USER_WIDTH-1:0]    m0_ARUSER,
    input   [1:0]               m0_ARDOMAIN,
    input                       m0_ARVALID,
    output                      m0_ARREADY,
    
    // R Channel
    output  [ID_WIDTH-1:0]      m0_RID,
    output  [DATA_WIDTH-1:0]    m0_RDATA,
    output  [1:0]               m0_RRESP,
    output                      m0_RLAST,
    output  [USER_WIDTH-1:0]	m0_RUSER,
    output                      m0_RVALID,
    input                       m0_RREADY,
    
    // Master 1
    input                       m1_ENABLE,
    output                      m1_CACHE_HIT,
    output                      m1_CACHE_BUSY,
    
    // AXI5 Interface (connect with CPU)
    // AW Channel
    input   [ID_WIDTH-1:0]      m1_AWID,
    input   [ADDR_WIDTH-1:0]    m1_AWADDR,
    input   [7:0]               m1_AWLEN,
    input   [2:0]               m1_AWSIZE,
    input   [1:0]               m1_AWBURST,
    input                       m1_AWLOCK,
    input   [3:0]               m1_AWCACHE,
    input   [2:0]               m1_AWPROT,
    input   [3:0]               m1_AWQOS,
    input   [3:0]               m1_AWREGION,
    input   [USER_WIDTH-1:0]    m1_AWUSER,
    input   [1:0]               m1_AWDOMAIN,
    input                       m1_AWVALID,
    output                      m1_AWREADY,
    
    // W Channel
    input   [DATA_WIDTH-1:0]    m1_WDATA,
    input   [STRB_WIDTH-1:0]    m1_WSTRB, 
    input                       m1_WLAST,
    input   [USER_WIDTH-1:0]    m1_WUSER,
    input                       m1_WVALID,
    output                      m1_WREADY,
    
    // B Channel
    output  [ID_WIDTH-1:0]      m1_BID,
    output  [1:0]               m1_BRESP,
    output  [USER_WIDTH-1:0]    m1_BUSER,
    output                      m1_BVALID,
    input                       m1_BREADY,
    
    // AR Channel
    input   [ID_WIDTH-1:0]      m1_ARID,
    input   [ADDR_WIDTH-1:0]    m1_ARADDR,
    input   [7:0]               m1_ARLEN,
    input   [2:0]               m1_ARSIZE,
    input   [1:0]               m1_ARBURST,
    input                       m1_ARLOCK,
    input   [3:0]               m1_ARCACHE,
    input   [2:0]               m1_ARPROT,
    input   [3:0]               m1_ARQOS,
    input   [3:0]               m1_ARREGION,
    input   [USER_WIDTH-1:0]    m1_ARUSER,
    input   [1:0]               m1_ARDOMAIN,
    input                       m1_ARVALID,
    output                      m1_ARREADY,
    
    // R Channel
    output  [ID_WIDTH-1:0]      m1_RID,
    output  [DATA_WIDTH-1:0]    m1_RDATA,
    output  [1:0]               m1_RRESP,
    output                      m1_RLAST,
    output  [USER_WIDTH-1:0]	m1_RUSER,
    output                      m1_RVALID,
    input                       m1_RREADY
);

    // AW Channel
    wire [ID_WIDTH-1:0]   s0_AWID;
    wire [ADDR_WIDTH-1:0] s0_AWADDR;
    wire [7:0]            s0_AWLEN;
    wire [2:0]            s0_AWSIZE;
    wire [1:0]            s0_AWBURST;
    wire                  s0_AWLOCK;
    wire [3:0]            s0_AWCACHE;
    wire [2:0]            s0_AWPROT;
    wire [3:0]            s0_AWQOS;
    wire [3:0]            s0_AWREGION;
    wire [USER_WIDTH-1:0] s0_AWUSER;
    wire [1:0]            s0_AWDOMAIN;
    wire [2:0]            s0_AWSNOOP;
    wire                  s0_AWVALID;
    wire 	              s0_AWREADY;
    // W Channel
    // output     [ID_WIDTH-1:0]   s_WID;
    wire [DATA_WIDTH-1:0] s0_WDATA;
    wire [STRB_WIDTH-1:0] s0_WSTRB;
    wire                  s0_WLAST;
    wire [USER_WIDTH-1:0] s0_WUSER;
    wire                  s0_WVALID;
    wire		          s0_WREADY;
    // B Channel
	wire [ID_WIDTH-1:0]	  s0_BID;
	wire [1:0]	          s0_BRESP;
	wire [USER_WIDTH-1:0] s0_BUSER;
	wire   		          s0_BVALID;
    wire                  s0_BREADY;
    // AR Channel
    wire [ID_WIDTH-1:0]   s0_ARID;    
    wire [ADDR_WIDTH-1:0] s0_ARADDR;
    wire [7:0]            s0_ARLEN;
    wire [2:0]            s0_ARSIZE;
    wire [1:0]            s0_ARBURST;
    wire                  s0_ARLOCK;
    wire [3:0]            s0_ARCACHE;
    wire [2:0]            s0_ARPROT;
    wire [3:0]            s0_ARQOS;
    wire [3:0]            s0_ARREGION;
    wire [USER_WIDTH-1:0] s0_ARUSER;
    wire [1:0]            s0_ARDOMAIN;
    wire [3:0]            s0_ARSNOOP;
    wire                  s0_ARVALID;
	wire		          s0_ARREADY;
    // R Channel
	wire [ID_WIDTH-1:0]   s0_RID;
	wire [DATA_WIDTH-1:0] s0_RDATA;
	wire [3:0]	          s0_RRESP;
	wire		          s0_RLAST;
	wire [USER_WIDTH-1:0] s0_RUSER;
	wire	              s0_RVALID; 
    wire                  s0_RREADY;
    
    // AW Channel
    wire [ID_WIDTH-1:0]   s1_AWID;
    wire [ADDR_WIDTH-1:0] s1_AWADDR;
    wire [7:0]            s1_AWLEN;
    wire [2:0]            s1_AWSIZE;
    wire [1:0]            s1_AWBURST;
    wire                  s1_AWLOCK;
    wire [3:0]            s1_AWCACHE;
    wire [2:0]            s1_AWPROT;
    wire [3:0]            s1_AWQOS;
    wire [3:0]            s1_AWREGION;
    wire [USER_WIDTH-1:0] s1_AWUSER;
    wire [1:0]            s1_AWDOMAIN;
    wire [2:0]            s1_AWSNOOP;
    wire                  s1_AWVALID;
    wire 	              s1_AWREADY;
    // W Channel
    // output     [ID_WIDTH-1:0]   s_WID;
    wire [DATA_WIDTH-1:0] s1_WDATA;
    wire [STRB_WIDTH-1:0] s1_WSTRB;
    wire                  s1_WLAST;
    wire [USER_WIDTH-1:0] s1_WUSER;
    wire                  s1_WVALID;
    wire		          s1_WREADY;
    // B Channel
	wire [ID_WIDTH-1:0]	  s1_BID;
	wire [1:0]	          s1_BRESP;
	wire [USER_WIDTH-1:0] s1_BUSER;
	wire   		          s1_BVALID;
    wire                  s1_BREADY;
    // AR Channel
    wire [ID_WIDTH-1:0]   s1_ARID;    
    wire [ADDR_WIDTH-1:0] s1_ARADDR;
    wire [7:0]            s1_ARLEN;
    wire [2:0]            s1_ARSIZE;
    wire [1:0]            s1_ARBURST;
    wire                  s1_ARLOCK;
    wire [3:0]            s1_ARCACHE;
    wire [2:0]            s1_ARPROT;
    wire [3:0]            s1_ARQOS;
    wire [3:0]            s1_ARREGION;
    wire [USER_WIDTH-1:0] s1_ARUSER;
    wire [1:0]            s1_ARDOMAIN;
    wire [3:0]            s1_ARSNOOP;
    wire                  s1_ARVALID;
	wire		          s1_ARREADY;
    // R Channel
	wire [ID_WIDTH-1:0]   s1_RID;
	wire [DATA_WIDTH-1:0] s1_RDATA;
	wire [3:0]	          s1_RRESP;
	wire		          s1_RLAST;
	wire [USER_WIDTH-1:0] s1_RUSER;
	wire	              s1_RVALID; 
    wire                  s1_RREADY;
    
    // AC Channel
    wire                     m0_ACVALID;
    wire [ADDR_WIDTH-1:0]    m0_ACADDR;
    wire [3:0]               m0_ACSNOOP;
    wire [2:0]               m0_ACPROT;
    wire                     m0_ACREADY;
    
    // CR Channel
    wire                     m0_CRREADY;
    wire                     m0_CRVALID;
    wire [4:0]               m0_CRRESP;
    
    // CD Channel
    wire                     m0_CDREADY;
    wire                     m0_CDVALID;
    wire [DATA_WIDTH-1:0]    m0_CDDATA;
    wire                     m0_CDLAST;
    
    // AC Channel
    wire                     m1_ACVALID;
    wire [ADDR_WIDTH-1:0]    m1_ACADDR;
    wire [3:0]               m1_ACSNOOP;
    wire [2:0]               m1_ACPROT;
    wire                     m1_ACREADY;
    
    // CR Channel
    wire                     m1_CRREADY;
    wire                     m1_CRVALID;
    wire [4:0]               m1_CRRESP;
    
    // CD Channel
    wire                     m1_CDREADY;
    wire                     m1_CDVALID;
    wire [DATA_WIDTH-1:0]    m1_CDDATA;
    wire                     m1_CDLAST;

    single_core_cache
    #(
        .DATA_WIDTH            (DATA_WIDTH),
        .ADDR_WIDTH            (ADDR_WIDTH),
        .ID_WIDTH              (ID_WIDTH  ),
        .USER_WIDTH            (USER_WIDTH),
        .STRB_WIDTH            (STRB_WIDTH),
        .SHAREABLE_REGION_START(SHAREABLE_REGION_START), // start address of shareable region
        .SHAREABLE_REGION_END  (SHAREABLE_REGION_END  ) // end address of shareable region
    )
    cacheA
    (
        // system signals
        .ACLK       (ACLK   ),
        .ARESETn    (ARESETn),
        .ENABLE     (m0_ENABLE    ),
        .CACHE_HIT  (m0_CACHE_HIT ),
        .CACHE_BUSY (m0_CACHE_BUSY),
        
        // AXI5 Interface (connect with CPU)
        // AW Channel
        .m_AWID     (m0_AWID    ),
        .m_AWADDR   (m0_AWADDR  ),
        .m_AWLEN    (m0_AWLEN   ),
        .m_AWSIZE   (m0_AWSIZE  ),
        .m_AWBURST  (m0_AWBURST ),
        .m_AWLOCK   (m0_AWLOCK  ),
        .m_AWCACHE  (m0_AWCACHE ),
        .m_AWPROT   (m0_AWPROT  ),
        .m_AWQOS    (m0_AWQOS   ),
        .m_AWREGION (m0_AWREGION),
        .m_AWUSER   (m0_AWUSER  ),
        .m_AWDOMAIN (m0_AWDOMAIN),
        .m_AWVALID  (m0_AWVALID ),
        .m_AWREADY  (m0_AWREADY ),
        
        // W Channel
        // input                       m_WID(),
        .m_WDATA    (m0_WDATA ),
        .m_WSTRB    (m0_WSTRB ), // use default value: 0xF
        .m_WLAST    (m0_WLAST ),
        .m_WUSER    (m0_WUSER ),
        .m_WVALID   (m0_WVALID),
        .m_WREADY   (m0_WREADY),
        
        // B Channel
        
        .m_BID      (m0_BID   ),
        .m_BRESP    (m0_BRESP ),
        .m_BUSER    (m0_BUSER ),
        .m_BVALID   (m0_BVALID),
        .m_BREADY   (m0_BREADY),
        
        // AR Channel
        .m_ARID     (m0_ARID    ),
        .m_ARADDR   (m0_ARADDR  ),
        .m_ARLEN    (m0_ARLEN   ),
        .m_ARSIZE   (m0_ARSIZE  ),
        .m_ARBURST  (m0_ARBURST ),
        .m_ARLOCK   (m0_ARLOCK  ),
        .m_ARCACHE  (m0_ARCACHE ),
        .m_ARPROT   (m0_ARPROT  ),
        .m_ARQOS    (m0_ARQOS   ),
        .m_ARREGION (m0_ARREGION),
        .m_ARUSER   (m0_ARUSER  ),
        .m_ARDOMAIN (m0_ARDOMAIN),
        .m_ARVALID  (m0_ARVALID ),
        .m_ARREADY  (m0_ARREADY ),
        
        // R Channel
        
        .m_RID      (m0_RID   ),
        .m_RDATA    (m0_RDATA ),
        .m_RRESP    (m0_RRESP ),
        .m_RLAST    (m0_RLAST ),
        .m_RUSER    (m0_RUSER ),
        .m_RVALID   (m0_RVALID),
        .m_RREADY   (m0_RREADY),
        
        
        // AXI5 Interface (connect with Cache L2)
        // AW Channel
        .s_AWID     (s0_AWID    ), // use default value: 0x0
        .s_AWADDR   (s0_AWADDR  ),
        .s_AWLEN    (s0_AWLEN   ),
        .s_AWSIZE   (s0_AWSIZE  ),  // use default value: Data bus width = 32-bit -> AWSIZE = 0x2
        .s_AWBURST  (s0_AWBURST ), // use default value: 0x1(), INCR
        .s_AWLOCK   (s0_AWLOCK  ),
        .s_AWCACHE  (s0_AWCACHE ),
        .s_AWPROT   (s0_AWPROT  ),
        .s_AWQOS    (s0_AWQOS   ),
        .s_AWREGION (s0_AWREGION),
        .s_AWUSER   (s0_AWUSER  ),   
        .s_AWDOMAIN (s0_AWDOMAIN),
        .s_AWSNOOP  (s0_AWSNOOP ),
        .s_AWVALID  (s0_AWVALID ),
        .s_AWREADY  (s0_AWREADY ),
        
        // W Channel
        // output  s_WID(),  // use default value: 0x0
        .s_WDATA    (s0_WDATA ),
        .s_WSTRB    (s0_WSTRB ),  // use default value: 0xF
        .s_WLAST    (s0_WLAST ),
        .s_WUSER    (s0_WUSER ),
        .s_WVALID   (s0_WVALID),
        .s_WREADY   (s0_WREADY),
        
        // B Channel
        .s_BID      (s0_BID   ),  // use default value: 0x0
        .s_BRESP    (s0_BRESP ),  
        .s_BUSER    (s0_BUSER ),
        .s_BVALID   (s0_BVALID),
        .s_BREADY   (s0_BREADY),
        
        // AR Channel
        .s_ARID     (s0_ARID    ), // use default value: 0x0
        .s_ARADDR   (s0_ARADDR  ),
        .s_ARLEN    (s0_ARLEN   ),
        .s_ARSIZE   (s0_ARSIZE  ),  // use default value: Data bus width = 32-bit -> ARSIZE = 0x2
        .s_ARBURST  (s0_ARBURST ), // use default value: 0x1(), INCR  
        .s_ARLOCK   (s0_ARLOCK  ),
        .s_ARCACHE  (s0_ARCACHE ),
        .s_ARPROT   (s0_ARPROT  ),
        .s_ARQOS    (s0_ARQOS   ),
        .s_ARREGION (s0_ARREGION),
        .s_ARUSER   (s0_ARUSER  ),
        .s_ARDOMAIN (s0_ARDOMAIN),
        .s_ARSNOOP  (s0_ARSNOOP ),
        .s_ARVALID  (s0_ARVALID ),
        .s_ARREADY  (s0_ARREADY ),
        
        // R Channel
        .s_RID      (s0_RID   ),  // use default value: 0x0
        .s_RDATA    (s0_RDATA ),
        .s_RRESP    (s0_RRESP ),
        .s_RLAST    (s0_RLAST ),
        .s_RUSER    (s0_RUSER ),
        .s_RVALID   (s0_RVALID),
        .s_RREADY   (s0_RREADY),
        
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
        .CDLAST     (m1_CDLAST )
        
        // for demo to fix E-E bug
        // input is_E_E
        // input is_R_R
        ///////////////////////////////////
    );
    
    single_core_cache
    #(
        .DATA_WIDTH            (DATA_WIDTH),
        .ADDR_WIDTH            (ADDR_WIDTH),
        .ID_WIDTH              (ID_WIDTH  ),
        .USER_WIDTH            (USER_WIDTH),
        .STRB_WIDTH            (STRB_WIDTH),
        .SHAREABLE_REGION_START(SHAREABLE_REGION_START), // start address of shareable region
        .SHAREABLE_REGION_END  (SHAREABLE_REGION_END  ) // end address of shareable region
    )
    cacheB
    (
        // system signals
        .ACLK       (ACLK   ),
        .ARESETn    (ARESETn),
        .ENABLE     (m1_ENABLE    ),
        .CACHE_HIT  (m1_CACHE_HIT ),
        .CACHE_BUSY (m1_CACHE_BUSY),
        
        // AXI5 Interface (connect with CPU)
        // AW Channel
        .m_AWID     (m1_AWID    ),
        .m_AWADDR   (m1_AWADDR  ),
        .m_AWLEN    (m1_AWLEN   ),
        .m_AWSIZE   (m1_AWSIZE  ),
        .m_AWBURST  (m1_AWBURST ),
        .m_AWLOCK   (m1_AWLOCK  ),
        .m_AWCACHE  (m1_AWCACHE ),
        .m_AWPROT   (m1_AWPROT  ),
        .m_AWQOS    (m1_AWQOS   ),
        .m_AWREGION (m1_AWREGION),
        .m_AWUSER   (m1_AWUSER  ),
        .m_AWDOMAIN (m1_AWDOMAIN),
        .m_AWVALID  (m1_AWVALID ),
        .m_AWREADY  (m1_AWREADY ),
        
        // W Channel
        // input                       m_WID(),
        .m_WDATA    (m1_WDATA ),
        .m_WSTRB    (m1_WSTRB ), // use default value: 0xF
        .m_WLAST    (m1_WLAST ),
        .m_WUSER    (m1_WUSER ),
        .m_WVALID   (m1_WVALID),
        .m_WREADY   (m1_WREADY),
        
        // B Channel
        
        .m_BID      (m1_BID   ),
        .m_BRESP    (m1_BRESP ),
        .m_BUSER    (m1_BUSER ),
        .m_BVALID   (m1_BVALID),
        .m_BREADY   (m1_BREADY),
        
        // AR Channel
        .m_ARID     (m1_ARID    ),
        .m_ARADDR   (m1_ARADDR  ),
        .m_ARLEN    (m1_ARLEN   ),
        .m_ARSIZE   (m1_ARSIZE  ),
        .m_ARBURST  (m1_ARBURST ),
        .m_ARLOCK   (m1_ARLOCK  ),
        .m_ARCACHE  (m1_ARCACHE ),
        .m_ARPROT   (m1_ARPROT  ),
        .m_ARQOS    (m1_ARQOS   ),
        .m_ARREGION (m1_ARREGION),
        .m_ARUSER   (m1_ARUSER  ),
        .m_ARDOMAIN (m1_ARDOMAIN),
        .m_ARVALID  (m1_ARVALID ),
        .m_ARREADY  (m1_ARREADY ),
        
        // R Channel
        
        .m_RID      (m1_RID   ),
        .m_RDATA    (m1_RDATA ),
        .m_RRESP    (m1_RRESP ),
        .m_RLAST    (m1_RLAST ),
        .m_RUSER    (m1_RUSER ),
        .m_RVALID   (m1_RVALID),
        .m_RREADY   (m1_RREADY),
        
        
        // AXI5 Interface (connect with Cache L2)
        // AW Channel
        .s_AWID     (s1_AWID    ), // use default value: 0x0
        .s_AWADDR   (s1_AWADDR  ),
        .s_AWLEN    (s1_AWLEN   ),
        .s_AWSIZE   (s1_AWSIZE  ),  // use default value: Data bus width = 32-bit -> AWSIZE = 0x2
        .s_AWBURST  (s1_AWBURST ), // use default value: 0x1(), INCR
        .s_AWLOCK   (s1_AWLOCK  ),
        .s_AWCACHE  (s1_AWCACHE ),
        .s_AWPROT   (s1_AWPROT  ),
        .s_AWQOS    (s1_AWQOS   ),
        .s_AWREGION (s1_AWREGION),
        .s_AWUSER   (s1_AWUSER  ),   
        .s_AWDOMAIN (s1_AWDOMAIN),
        .s_AWSNOOP  (s1_AWSNOOP ),
        .s_AWVALID  (s1_AWVALID ),
        .s_AWREADY  (s1_AWREADY ),
        
        // W Channel
        // output  s_WID(),  // use default value: 0x0
        .s_WDATA    (s1_WDATA ),
        .s_WSTRB    (s1_WSTRB ),  // use default value: 0xF
        .s_WLAST    (s1_WLAST ),
        .s_WUSER    (s1_WUSER ),
        .s_WVALID   (s1_WVALID),
        .s_WREADY   (s1_WREADY),
        
        // B Channel
        .s_BID      (s1_BID   ),  // use default value: 0x0
        .s_BRESP    (s1_BRESP ),  
        .s_BUSER    (s1_BUSER ),
        .s_BVALID   (s1_BVALID),
        .s_BREADY   (s1_BREADY),
        
        // AR Channel
        .s_ARID     (s1_ARID    ), // use default value: 0x0
        .s_ARADDR   (s1_ARADDR  ),
        .s_ARLEN    (s1_ARLEN   ),
        .s_ARSIZE   (s1_ARSIZE  ),  // use default value: Data bus width = 32-bit -> ARSIZE = 0x2
        .s_ARBURST  (s1_ARBURST ), // use default value: 0x1(), INCR  
        .s_ARLOCK   (s1_ARLOCK  ),
        .s_ARCACHE  (s1_ARCACHE ),
        .s_ARPROT   (s1_ARPROT  ),
        .s_ARQOS    (s1_ARQOS   ),
        .s_ARREGION (s1_ARREGION),
        .s_ARUSER   (s1_ARUSER  ),
        .s_ARDOMAIN (s1_ARDOMAIN),
        .s_ARSNOOP  (s1_ARSNOOP ),
        .s_ARVALID  (s1_ARVALID ),
        .s_ARREADY  (s1_ARREADY ),
        
        // R Channel
        .s_RID      (s1_RID   ),  // use default value: 0x0
        .s_RDATA    (s1_RDATA ),
        .s_RRESP    (s1_RRESP ),
        .s_RLAST    (s1_RLAST ),
        .s_RUSER    (s1_RUSER ),
        .s_RVALID   (s1_RVALID),
        .s_RREADY   (s1_RREADY),
        
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
        .CDLAST     (m0_CDLAST )
        
        // for demo to fix E-E bug
        // input is_E_E
        // input is_R_R
        ///////////////////////////////////
    );
     
    // Slave
    // AW Channel
    wire [ID_WIDTH-1:0]   s_AWID;
    wire [ADDR_WIDTH-1:0] s_AWADDR;
    wire [7:0]            s_AWLEN;
    wire [2:0]            s_AWSIZE;
    wire [1:0]            s_AWBURST;
    wire                  s_AWLOCK;
    wire [3:0]            s_AWCACHE;
    wire [2:0]            s_AWPROT;
    wire [3:0]            s_AWQOS;
    wire [3:0]            s_AWREGION;
    wire [USER_WIDTH-1:0] s_AWUSER;
    wire                  s_AWVALID;
    wire 	              s_AWREADY;
    // W Channel
    // output     [ID_WIDTH-1:0]   s_WID;
    wire [DATA_WIDTH-1:0] s_WDATA;
    wire [STRB_WIDTH-1:0] s_WSTRB;
    wire                  s_WLAST;
    wire [USER_WIDTH-1:0] s_WUSER;
    wire                  s_WVALID;
    wire		          s_WREADY;
    // B Channel
	wire [ID_WIDTH-1:0]	  s_BID;
	wire [1:0]	          s_BRESP;
	wire [USER_WIDTH-1:0] s_BUSER;
	wire   		          s_BVALID;
    wire                  s_BREADY;
    // AR Channel
    wire [ID_WIDTH-1:0]   s_ARID;    
    wire [ADDR_WIDTH-1:0] s_ARADDR;
    wire [7:0]            s_ARLEN;
    wire [2:0]            s_ARSIZE;
    wire [1:0]            s_ARBURST;
    wire                  s_ARLOCK;
    wire [3:0]            s_ARCACHE;
    wire [2:0]            s_ARPROT;
    wire [3:0]            s_ARQOS;
    wire [3:0]            s_ARREGION;
    wire [USER_WIDTH-1:0] s_ARUSER;
    wire                  s_ARVALID;
	wire                  s_ARREADY;
    // R Channel
	wire [ID_WIDTH-1:0]   s_RID;
	wire [DATA_WIDTH-1:0] s_RDATA;
	wire [1:0]	          s_RRESP;
	wire	  		      s_RLAST;
	wire [USER_WIDTH-1:0] s_RUSER;
	wire 		          s_RVALID; 
    wire                  s_RREADY;
    
    ACE_Interconnect
    #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH),
        .ID_WIDTH  (ID_WIDTH  ) ,
        .USER_WIDTH(USER_WIDTH) ,
        .STRB_WIDTH(STRB_WIDTH)
    )
    uACE_Interconnect
    (
        /********* System signals *********/
        .ACLK       (ACLK   ),
        .ARESETn    (ARESETn),
        /********** Master 0 side **********/
        // AW Channel
        .m0_AWID    (s0_AWID    ),
        .m0_AWADDR  (s0_AWADDR  ),
        .m0_AWLEN   (s0_AWLEN   ),
        .m0_AWSIZE  (s0_AWSIZE  ),
        .m0_AWBURST (s0_AWBURST ),
        .m0_AWLOCK  (s0_AWLOCK  ),
        .m0_AWCACHE (s0_AWCACHE ),
        .m0_AWPROT  (s0_AWPROT  ),
        .m0_AWQOS   (s0_AWQOS   ),
        .m0_AWREGION(s0_AWREGION),
        .m0_AWUSER  (s0_AWUSER  ),
        .m0_AWDOMAIN(s0_AWDOMAIN),
        .m0_AWSNOOP (s0_AWSNOOP ),
        .m0_AWVALID (s0_AWVALID ),
        .m0_AWREADY (s0_AWREADY ),
        // W Channel
        // input      [ID_WIDTH-1:0]   m0_WID(),
        .m0_WDATA   (s0_WDATA ),
        .m0_WSTRB   (s0_WSTRB ),
        .m0_WLAST   (s0_WLAST ),
        .m0_WUSER   (s0_WUSER ),
        .m0_WVALID  (s0_WVALID),
        .m0_WREADY  (s0_WREADY),
        // B Channel
        .m0_BID     (s0_BID   ),
        .m0_BRESP   (s0_BRESP ),
        .m0_BUSER   (s0_BUSER ),
        .m0_BVALID  (s0_BVALID),
        .m0_BREADY  (s0_BREADY),
        // AR Channel
        .m0_ARID    (s0_ARID    ),
        .m0_ARADDR  (s0_ARADDR  ),
        .m0_ARLEN   (s0_ARLEN   ),
        .m0_ARSIZE  (s0_ARSIZE  ),
        .m0_ARBURST (s0_ARBURST ),
        .m0_ARLOCK  (s0_ARLOCK  ),
        .m0_ARCACHE (s0_ARCACHE ),
        .m0_ARPROT  (s0_ARPROT  ),
        .m0_ARQOS   (s0_ARQOS   ),
        .m0_ARREGION(s0_ARREGION),
        .m0_ARUSER  (s0_ARUSER  ),
        .m0_ARDOMAIN(s0_ARDOMAIN),
        .m0_ARSNOOP (s0_ARSNOOP ),
        .m0_ARVALID (s0_ARVALID ),
        .m0_ARREADY (s0_ARREADY ),
        // R Channel
        .m0_RID     (s0_RID   ),
        .m0_RDATA   (s0_RDATA ),
        .m0_RRESP   (s0_RRESP ),
        .m0_RLAST   (s0_RLAST ),
        .m0_RUSER   (s0_RUSER ),
        .m0_RVALID  (s0_RVALID),
        .m0_RREADY  (s0_RREADY),
        // Snoop Channels
        // AC Channel
        .m0_ACVALID (m0_ACVALID),
        .m0_ACADDR  (m0_ACADDR ),
        .m0_ACSNOOP (m0_ACSNOOP),
        .m0_ACPROT  (m0_ACPROT ),
        .m0_ACREADY (m0_ACREADY),
        
        // CR Channel
        .m0_CRREADY (m0_CRREADY),
        .m0_CRVALID (m0_CRVALID),
        .m0_CRRESP  (m0_CRRESP ),
        
        // CD Channel
        .m0_CDREADY (m0_CDREADY),
        .m0_CDVALID (m0_CDVALID),
        .m0_CDDATA  (m0_CDDATA ),
        .m0_CDLAST  (m0_CDLAST ),
        
        /********** Master 1 side **********/
        // AW Channel
        .m1_AWID    (s1_AWID    ),
        .m1_AWADDR  (s1_AWADDR  ),
        .m1_AWLEN   (s1_AWLEN   ),
        .m1_AWSIZE  (s1_AWSIZE  ),
        .m1_AWBURST (s1_AWBURST ),
        .m1_AWLOCK  (s1_AWLOCK  ),
        .m1_AWCACHE (s1_AWCACHE ),
        .m1_AWPROT  (s1_AWPROT  ),
        .m1_AWQOS   (s1_AWQOS   ),
        .m1_AWREGION(s1_AWREGION),
        .m1_AWUSER  (s1_AWUSER  ),
        .m1_AWDOMAIN(s1_AWDOMAIN),
        .m1_AWSNOOP (s1_AWSNOOP ),
        .m1_AWVALID (s1_AWVALID ),
        .m1_AWREADY (s1_AWREADY ),
        // W Channel
        // input      [ID_WIDTH-1:0]   m1_WID(),
        .m1_WDATA   (s1_WDATA ),
        .m1_WSTRB   (s1_WSTRB ),
        .m1_WLAST   (s1_WLAST ),
        .m1_WUSER   (s1_WUSER ),
        .m1_WVALID  (s1_WVALID),
        .m1_WREADY  (s1_WREADY),
        // B Channel
        .m1_BID     (s1_BID   ),
        .m1_BRESP   (s1_BRESP ),
        .m1_BUSER   (s1_BUSER ),
        .m1_BVALID  (s1_BVALID),
        .m1_BREADY  (s1_BREADY),
        // AR Channel
        .m1_ARID    (s1_ARID    ),
        .m1_ARADDR  (s1_ARADDR  ),
        .m1_ARLEN   (s1_ARLEN   ),
        .m1_ARSIZE  (s1_ARSIZE  ),
        .m1_ARBURST (s1_ARBURST ),
        .m1_ARLOCK  (s1_ARLOCK  ),
        .m1_ARCACHE (s1_ARCACHE ),
        .m1_ARPROT  (s1_ARPROT  ),
        .m1_ARQOS   (s1_ARQOS   ),
        .m1_ARREGION(s1_ARREGION),
        .m1_ARUSER  (s1_ARUSER  ),
        .m1_ARDOMAIN(s1_ARDOMAIN),
        .m1_ARSNOOP (s1_ARSNOOP ),
        .m1_ARVALID (s1_ARVALID ),
        .m1_ARREADY (s1_ARREADY ),
        // R Channel
        .m1_RID     (s1_RID   ),
        .m1_RDATA   (s1_RDATA ),
        .m1_RRESP   (s1_RRESP ),
        .m1_RLAST   (s1_RLAST ),
        .m1_RUSER   (s1_RUSER ),
        .m1_RVALID  (s1_RVALID),
        .m1_RREADY  (s1_RREADY),
        // Snoop Channels
        // AC Channel
        .m1_ACVALID (m1_ACVALID),
        .m1_ACADDR  (m1_ACADDR ),
        .m1_ACSNOOP (m1_ACSNOOP),
        .m1_ACPROT  (m1_ACPROT ),
        .m1_ACREADY (m1_ACREADY),
        
        // CR Channel
        .m1_CRREADY (m1_CRREADY),
        .m1_CRVALID (m1_CRVALID),
        .m1_CRRESP  (m1_CRRESP ),
        
        // CD Channel
        .m1_CDREADY (m1_CDREADY),
        .m1_CDVALID (m1_CDVALID),
        .m1_CDDATA  (m1_CDDATA ),
        .m1_CDLAST  (m1_CDLAST ),
    
        /********** Slave side**********/
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
        // output     [ID_WIDTH-1:0]   s_WID(),
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
    
    memory
    #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH),
        .ID_WIDTH  (ID_WIDTH  ),
        .USER_WIDTH(USER_WIDTH),
        .STRB_WIDTH(DATA_WIDTH/8),
        .INIT_PATH (DMEM_INIT)
    )
    main_memory
    (
        /********* System signals *********/
        .ACLK       (ACLK   ),
        .ARESETn    (ARESETn),
        
        /********** Slave Interface **********/
        // AW Channel
        .m_AWID     (s_AWID    ),
        .m_AWADDR   (s_AWADDR  ),
        .m_AWLEN    (s_AWLEN   ),
        .m_AWSIZE   (s_AWSIZE  ),
        .m_AWBURST  (s_AWBURST ),
        .m_AWLOCK   (s_AWLOCK  ),
        .m_AWCACHE  (s_AWCACHE ),
        .m_AWPROT   (s_AWPROT  ),
        .m_AWQOS    (s_AWQOS   ),
        .m_AWREGION (s_AWREGION),
        .m_AWUSER   (s_AWUSER  ),
        .m_AWVALID  (s_AWVALID ),
        .m_AWREADY  (s_AWREADY ),
        // W Channel
        // input     [ID_WIDTH-1:0]   m_WID(),
        .m_WDATA    (s_WDATA ),
        .m_WSTRB    (s_WSTRB ),
        .m_WLAST    (s_WLAST ),
        .m_WUSER    (s_WUSER ),
        .m_WVALID   (s_WVALID),
        .m_WREADY   (s_WREADY),
        // B Channel
        .m_BID      (s_BID   ),
        .m_BRESP    (s_BRESP ),
        .m_BUSER    (s_BUSER ),
        .m_BVALID   (s_BVALID),
        .m_BREADY   (s_BREADY),
        // AR Channel
        .m_ARID     (s_ARID    ),    
        .m_ARADDR   (s_ARADDR  ),
        .m_ARLEN    (s_ARLEN   ),
        .m_ARSIZE   (s_ARSIZE  ),
        .m_ARBURST  (s_ARBURST ),
        .m_ARLOCK   (s_ARLOCK  ),
        .m_ARCACHE  (s_ARCACHE ),
        .m_ARPROT   (s_ARPROT  ),
        .m_ARQOS    (s_ARQOS   ),
        .m_ARREGION (s_ARREGION),
        .m_ARUSER   (s_ARUSER  ),
        .m_ARVALID  (s_ARVALID ),
        .m_ARREADY  (s_ARREADY ),
        // R Channel
        .m_RID      (s_RID   ),
        .m_RDATA    (s_RDATA ),
        .m_RRESP    (s_RRESP ),
        .m_RLAST    (s_RLAST ),
        .m_RUSER    (s_RUSER ),
        .m_RVALID   (s_RVALID), 
        .m_RREADY   (s_RREADY)
    );

endmodule
