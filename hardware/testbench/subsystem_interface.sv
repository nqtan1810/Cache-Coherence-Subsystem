`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// this is definition of dual_core_cache interface
//////////////////////////////////////////////////////////////////////////////////

interface dual_core_cache_if 
#(
    parameter DATA_WIDTH  = 32,
    parameter ADDR_WIDTH  = 32,
    parameter ID_WIDTH    = 1,
    parameter USER_WIDTH  = 4,
    parameter STRB_WIDTH  = (DATA_WIDTH/8),
    parameter SHAREABLE_REGION_START = 32'h0002_0000, // start address of shareable region
    parameter SHAREABLE_REGION_END   = 32'h0003_FFFF,  // end address of shareable region
    // output files
    parameter STATE_TAG_A = "D:/University/KLTN/hw_design/coherence_cache/coherence_cache.srcs/sim_1/new/state_tag_A.mem",
    parameter STATE_TAG_B = "D:/University/KLTN/hw_design/coherence_cache/coherence_cache.srcs/sim_1/new/state_tag_B.mem",
    parameter PLRUT_RAM_A = "D:/University/KLTN/hw_design/coherence_cache/coherence_cache.srcs/sim_1/new/plrut_ram_A.mem",
    parameter PLRUT_RAM_B = "D:/University/KLTN/hw_design/coherence_cache/coherence_cache.srcs/sim_1/new/plrut_ram_B.mem",
    parameter DATA_RAM_A = "D:/University/KLTN/hw_design/coherence_cache/coherence_cache.srcs/sim_1/new/data_ram_A.mem",
    parameter DATA_RAM_B = "D:/University/KLTN/hw_design/coherence_cache/coherence_cache.srcs/sim_1/new/data_ram_B.mem",
    parameter MAIN_MEMORY = "D:/University/KLTN/hw_design/coherence_cache/coherence_cache.srcs/sim_1/new/main_memory_result.mem"
) (input bit ACLK);

    // system signals
    logic                      ARESETn;
    
    // Master 0
    logic                      m0_ENABLE;
    logic                      m0_D_CACHE_HIT;
    logic                      m0_D_CACHE_BUSY;
    
    // AXI5 Interface (connect with CPU)
    // AW Channel
    logic   [ID_WIDTH-1:0]     m0_AWID;
    logic   [ADDR_WIDTH-1:0]   m0_AWADDR;
    logic   [7:0]              m0_AWLEN;
    logic   [2:0]              m0_AWSIZE;
    logic   [1:0]              m0_AWBURST;
    logic                      m0_AWLOCK;
    logic   [3:0]              m0_AWCACHE;
    logic   [2:0]              m0_AWPROT;
    logic   [3:0]              m0_AWQOS;
    logic   [3:0]              m0_AWREGION;
    logic   [USER_WIDTH-1:0]   m0_AWUSER;
    logic   [1:0]              m0_AWDOMAIN;
    logic                      m0_AWVALID;
    logic                      m0_AWREADY;
    
    // W Channel
    // logic                      m_WID;
    logic   [DATA_WIDTH-1:0]   m0_WDATA;
    logic   [STRB_WIDTH-1:0]   m0_WSTRB; // use default value: 0xF
    logic                      m0_WLAST;
    logic   [USER_WIDTH-1:0]   m0_WUSER;
    logic                      m0_WVALID;
    logic                      m0_WREADY;
    
    // B Channel
    
    logic  [ID_WIDTH-1:0]      m0_BID;
    logic  [1:0]               m0_BRESP;
    logic  [USER_WIDTH-1:0]    m0_BUSER;
    logic                      m0_BVALID;
    logic                      m0_BREADY;
    
    // AR Channel
    logic   [ID_WIDTH-1:0]     m0_ARID;
    logic   [ADDR_WIDTH-1:0]   m0_ARADDR;
    logic   [7:0]              m0_ARLEN;
    logic   [2:0]              m0_ARSIZE;
    logic   [1:0]              m0_ARBURST;
    logic                      m0_ARLOCK;
    logic   [3:0]              m0_ARCACHE;
    logic   [2:0]              m0_ARPROT;
    logic   [3:0]              m0_ARQOS;
    logic   [3:0]              m0_ARREGION;
    logic   [USER_WIDTH-1:0]   m0_ARUSER;
    logic   [1:0]              m0_ARDOMAIN;
    logic                      m0_ARVALID;
    logic                      m0_ARREADY;
    
    // R Channel
    
    logic  [ID_WIDTH-1:0]      m0_RID;
    logic  [DATA_WIDTH-1:0]    m0_RDATA;
    logic  [1:0]               m0_RRESP;
    logic                      m0_RLAST;
    logic  [USER_WIDTH-1:0]	   m0_RUSER;
    logic                      m0_RVALID;
    logic                      m0_RREADY;
    
    // I-CacheA
    logic                      m0_I_CACHE_HIT;
    logic                      m0_I_CACHE_BUSY;
    
    // Master 1
    logic                      m1_ENABLE;
    logic                      m1_D_CACHE_HIT;
    logic                      m1_D_CACHE_BUSY;
    
    // AXI5 Interface (connect with CPU)
    // AW Channel
    logic   [ID_WIDTH-1:0]     m1_AWID;
    logic   [ADDR_WIDTH-1:0]   m1_AWADDR;
    logic   [7:0]              m1_AWLEN;
    logic   [2:0]              m1_AWSIZE;
    logic   [1:0]              m1_AWBURST;
    logic                      m1_AWLOCK;
    logic   [3:0]              m1_AWCACHE;
    logic   [2:0]              m1_AWPROT;
    logic   [3:0]              m1_AWQOS;
    logic   [3:0]              m1_AWREGION;
    logic   [USER_WIDTH-1:0]   m1_AWUSER;
    logic   [1:0]              m1_AWDOMAIN;
    logic                      m1_AWVALID;
    logic                      m1_AWREADY;
    
    // W Channel
    // logic                       m_WID;
    logic   [DATA_WIDTH-1:0]   m1_WDATA;
    logic   [STRB_WIDTH-1:0]   m1_WSTRB; // use default value: 0xF
    logic                      m1_WLAST;
    logic   [USER_WIDTH-1:0]   m1_WUSER;
    logic                      m1_WVALID;
    logic                      m1_WREADY;
    
    // B Channel
    
    logic  [ID_WIDTH-1:0]      m1_BID;
    logic  [1:0]               m1_BRESP;
    logic  [USER_WIDTH-1:0]    m1_BUSER;
    logic                      m1_BVALID;
    logic                      m1_BREADY;
    
    // AR Channel
    logic   [ID_WIDTH-1:0]     m1_ARID;
    logic   [ADDR_WIDTH-1:0]   m1_ARADDR;
    logic   [7:0]              m1_ARLEN;
    logic   [2:0]              m1_ARSIZE;
    logic   [1:0]              m1_ARBURST;
    logic                      m1_ARLOCK;
    logic   [3:0]              m1_ARCACHE;
    logic   [2:0]              m1_ARPROT;
    logic   [3:0]              m1_ARQOS;
    logic   [3:0]              m1_ARREGION;
    logic   [USER_WIDTH-1:0]   m1_ARUSER;
    logic   [1:0]              m1_ARDOMAIN;
    logic                      m1_ARVALID;
    logic                      m1_ARREADY;
    
    // R Channel
    
    logic  [ID_WIDTH-1:0]      m1_RID;
    logic  [DATA_WIDTH-1:0]    m1_RDATA;
    logic  [1:0]               m1_RRESP;
    logic                      m1_RLAST;
    logic  [USER_WIDTH-1:0]	   m1_RUSER;
    logic                      m1_RVALID;
    logic                      m1_RREADY;
    
    // I-CacheB
    logic                      m1_I_CACHE_HIT;
    logic                      m1_I_CACHE_BUSY;
    
    // Slave
    // AW Channel
    logic  [ID_WIDTH-1:0]      s_AWID;
    logic  [ADDR_WIDTH-1:0]    s_AWADDR;
    logic  [7:0]               s_AWLEN;
    logic  [2:0]               s_AWSIZE;
    logic  [1:0]               s_AWBURST;
    logic                      s_AWLOCK;
    logic  [3:0]               s_AWCACHE;
    logic  [2:0]               s_AWPROT;
    logic  [3:0]               s_AWQOS;
    logic  [3:0]               s_AWREGION;
    logic  [USER_WIDTH-1:0]    s_AWUSER;
    logic                      s_AWVALID;
    logic	   	               s_AWREADY;
    // W Channel
    // logic     [ID_WIDTH-1:0]   s_WID;
    logic  [DATA_WIDTH-1:0]    s_WDATA;
    logic  [STRB_WIDTH-1:0]    s_WSTRB;
    logic                      s_WLAST;
    logic  [USER_WIDTH-1:0]    s_WUSER;
    logic                      s_WVALID;
    logic	  		           s_WREADY;
    // B Channel
	logic  [ID_WIDTH-1:0]      s_BID;
	logic  [1:0]	           s_BRESP;
	logic  [USER_WIDTH-1:0]    s_BUSER;
	logic	     		       s_BVALID;
    logic                      s_BREADY;
    // AR Channel
    logic  [ID_WIDTH-1:0]      s_ARID;    
    logic  [ADDR_WIDTH-1:0]    s_ARADDR;
    logic  [7:0]               s_ARLEN;
    logic  [2:0]               s_ARSIZE;
    logic  [1:0]               s_ARBURST;
    logic                      s_ARLOCK;
    logic  [3:0]               s_ARCACHE;
    logic  [2:0]               s_ARPROT;
    logic  [3:0]               s_ARQOS;
    logic  [3:0]               s_ARREGION;
    logic  [USER_WIDTH-1:0]    s_ARUSER;
    logic                      s_ARVALID;
	logic	  		           s_ARREADY;
    // R Channel
	logic  [ID_WIDTH-1:0]      s_RID;
	logic  [DATA_WIDTH-1:0]    s_RDATA;
	logic  [1:0]	           s_RRESP;
	logic 		               s_RLAST;
	logic  [USER_WIDTH-1:0]    s_RUSER;
	logic		               s_RVALID; 
    logic                      s_RREADY;

    // Clocking Block
    clocking drv_cb @(posedge ACLK);
        default input #0.5 output #4;
        // system signals
        output  ARESETn;
        
        // Master 0
        output  m0_ENABLE;
        input   m0_D_CACHE_HIT;
        input   m0_D_CACHE_BUSY;
        
        // AXI Interface (connect with CPU)
        // AW Channel
        output  m0_AWID;
        output  m0_AWADDR;
        output  m0_AWLEN;
        output  m0_AWSIZE;
        output  m0_AWBURST;
        output  m0_AWLOCK;
        output  m0_AWCACHE;
        output  m0_AWPROT;
        output  m0_AWQOS;
        output  m0_AWREGION;
        output  m0_AWUSER;
        output  m0_AWDOMAIN;
        output  m0_AWVALID;
        input   m0_AWREADY;
        
        // W Channel
        // output                       m_WID;
        output  m0_WDATA;
        output  m0_WSTRB; // use default value: 0xF
        output  m0_WLAST;
        output  m0_WUSER;
        output  m0_WVALID;
        input   m0_WREADY;
        
        // B Channel
        
        input   m0_BID;
        input   m0_BRESP;
        input   m0_BUSER;
        input   m0_BVALID;
        output  m0_BREADY;
        
        // AR Channel
        output  m0_ARID;
        output  m0_ARADDR;
        output  m0_ARLEN;
        output  m0_ARSIZE;
        output  m0_ARBURST;
        output  m0_ARLOCK;
        output  m0_ARCACHE;
        output  m0_ARPROT;
        output  m0_ARQOS;
        output  m0_ARREGION;
        output  m0_ARUSER;
        output  m0_ARDOMAIN;
        output  m0_ARVALID;
        input   m0_ARREADY;
        
        // R Channel
        
        input   m0_RID;
        input   m0_RDATA;
        input   m0_RRESP;
        input   m0_RLAST;
        input   m0_RUSER;
        input   m0_RVALID;
        output  m0_RREADY;
        
        // I-cacheA
        input   m0_I_CACHE_HIT;
        input   m0_I_CACHE_BUSY;
        
        // Master 1
        output  m1_ENABLE;
        input   m1_D_CACHE_HIT;
        input   m1_D_CACHE_BUSY;
        
        // AXI5 Interface (connect with CPU)
        // AW Channel
        output  m1_AWID;
        output  m1_AWADDR;
        output  m1_AWLEN;
        output  m1_AWSIZE;
        output  m1_AWBURST;
        output  m1_AWLOCK;
        output  m1_AWCACHE;
        output  m1_AWPROT;
        output  m1_AWQOS;
        output  m1_AWREGION;
        output  m1_AWUSER;
        output  m1_AWDOMAIN;
        output  m1_AWVALID;
        input   m1_AWREADY;
        
        // W Channel
        // output                       m_WID;
        output  m1_WDATA;
        output  m1_WSTRB; // use default value: 0xF
        output  m1_WLAST;
        output  m1_WUSER;
        output  m1_WVALID;
        input   m1_WREADY;
        
        // B Channel
        
        input   m1_BID;
        input   m1_BRESP;
        input   m1_BUSER;
        input   m1_BVALID;
        output  m1_BREADY;
        
        // AR Channel
        output  m1_ARID;
        output  m1_ARADDR;
        output  m1_ARLEN;
        output  m1_ARSIZE;
        output  m1_ARBURST;
        output  m1_ARLOCK;
        output  m1_ARCACHE;
        output  m1_ARPROT;
        output  m1_ARQOS;
        output  m1_ARREGION;
        output  m1_ARUSER;
        output  m1_ARDOMAIN;
        output  m1_ARVALID;
        input   m1_ARREADY;
        
        // R Channel
        
        input   m1_RID;
        input   m1_RDATA;
        input   m1_RRESP;
        input   m1_RLAST;
        input   m1_RUSER;
        input   m1_RVALID;
        output  m1_RREADY;
        
        // I-cacheB
        input   m1_I_CACHE_HIT;
        input   m1_I_CACHE_BUSY;
        
        // Slave
        // AW Channel
        input   s_AWID;
        input   s_AWADDR;
        input   s_AWLEN;
        input   s_AWSIZE;
        input   s_AWBURST;
        input   s_AWLOCK;
        input   s_AWCACHE;
        input   s_AWPROT;
        input   s_AWQOS;
        input   s_AWREGION;
        input   s_AWUSER;
        input   s_AWVALID;
        output  s_AWREADY;
        // W Channel
        // input     [ID_WIDTH-1:0]   s_WID;
        input   s_WDATA;
        input   s_WSTRB;
        input   s_WLAST;
        input   s_WUSER;
        input   s_WVALID;
        output  s_WREADY;
        // B Channel
        output  s_BID;
        output  s_BRESP;
        output  s_BUSER;
        output  s_BVALID;
        input   s_BREADY;
        // AR Channel
        input   s_ARID;    
        input   s_ARADDR;
        input   s_ARLEN;
        input   s_ARSIZE;
        input   s_ARBURST;
        input   s_ARLOCK;
        input   s_ARCACHE;
        input   s_ARPROT;
        input   s_ARQOS;
        input   s_ARREGION;
        input   s_ARUSER;
        input   s_ARVALID;
        output  s_ARREADY;
        // R Channel
        output  s_RID;
        output  s_RDATA;
        output  s_RRESP;
        output  s_RLAST;
        output  s_RUSER;
        output  s_RVALID; 
        input   s_RREADY;
    endclocking
    
    clocking mon_cb @(posedge ACLK);
        default input #0.5 output #4;
        // system signals
        input   ARESETn;
        
        // Master 0
        input   m0_ENABLE;
        input   m0_D_CACHE_HIT;
        input   m0_D_CACHE_BUSY;
        
        // AXI5 Interface (connect with CPU)
        // AW Channel
        input   m0_AWID;
        input   m0_AWADDR;
        input   m0_AWLEN;
        input   m0_AWSIZE;
        input   m0_AWBURST;
        input   m0_AWLOCK;
        input   m0_AWCACHE;
        input   m0_AWPROT;
        input   m0_AWQOS;
        input   m0_AWREGION;
        input   m0_AWUSER;
        input   m0_AWDOMAIN;
        input   m0_AWVALID;
        input   m0_AWREADY;
        
        // W Channel
        // input                       m_WID;
        input   m0_WDATA;
        input   m0_WSTRB; // use default value: 0xF
        input   m0_WLAST;
        input   m0_WUSER;
        input   m0_WVALID;
        input   m0_WREADY;
        
        // B Channel
        
        input   m0_BID;
        input   m0_BRESP;
        input   m0_BUSER;
        input   m0_BVALID;
        input   m0_BREADY;
        
        // AR Channel
        input   m0_ARID;
        input   m0_ARADDR;
        input   m0_ARLEN;
        input   m0_ARSIZE;
        input   m0_ARBURST;
        input   m0_ARLOCK;
        input   m0_ARCACHE;
        input   m0_ARPROT;
        input   m0_ARQOS;
        input   m0_ARREGION;
        input   m0_ARUSER;
        input   m0_ARDOMAIN;
        input   m0_ARVALID;
        input   m0_ARREADY;
        
        // R Channel
        
        input   m0_RID;
        input   m0_RDATA;
        input   m0_RRESP;
        input   m0_RLAST;
        input   m0_RUSER;
        input   m0_RVALID;
        input   m0_RREADY;
        
        // I-cacheA
        input   m0_I_CACHE_HIT;
        input   m0_I_CACHE_BUSY;
        
        // Master 1
        input   m1_ENABLE;
        input   m1_D_CACHE_HIT;
        input   m1_D_CACHE_BUSY;
        
        // AXI5 Interface (connect with CPU)
        // AW Channel
        input   m1_AWID;
        input   m1_AWADDR;
        input   m1_AWLEN;
        input   m1_AWSIZE;
        input   m1_AWBURST;
        input   m1_AWLOCK;
        input   m1_AWCACHE;
        input   m1_AWPROT;
        input   m1_AWQOS;
        input   m1_AWREGION;
        input   m1_AWUSER;
        input   m1_AWDOMAIN;
        input   m1_AWVALID;
        input   m1_AWREADY;
        
        // W Channel
        // input                       m_WID;
        input   m1_WDATA;
        input   m1_WSTRB; // use default value: 0xF
        input   m1_WLAST;
        input   m1_WUSER;
        input   m1_WVALID;
        input   m1_WREADY;
        
        // B Channel
        
        input   m1_BID;
        input   m1_BRESP;
        input   m1_BUSER;
        input   m1_BVALID;
        input   m1_BREADY;
        
        // AR Channel
        input   m1_ARID;
        input   m1_ARADDR;
        input   m1_ARLEN;
        input   m1_ARSIZE;
        input   m1_ARBURST;
        input   m1_ARLOCK;
        input   m1_ARCACHE;
        input   m1_ARPROT;
        input   m1_ARQOS;
        input   m1_ARREGION;
        input   m1_ARUSER;
        input   m1_ARDOMAIN;
        input   m1_ARVALID;
        input   m1_ARREADY;
        
        // R Channel
        
        input   m1_RID;
        input   m1_RDATA;
        input   m1_RRESP;
        input   m1_RLAST;
        input   m1_RUSER;
        input   m1_RVALID;
        input   m1_RREADY;
        
        // I-cacheB
        input   m1_I_CACHE_HIT;
        input   m1_I_CACHE_BUSY;
        
        // Slave
        // AW Channel
        input   s_AWID;
        input   s_AWADDR;
        input   s_AWLEN;
        input   s_AWSIZE;
        input   s_AWBURST;
        input   s_AWLOCK;
        input   s_AWCACHE;
        input   s_AWPROT;
        input   s_AWQOS;
        input   s_AWREGION;
        input   s_AWUSER;
        input   s_AWVALID;
        input   s_AWREADY;
        // W Channel
        // input     [ID_WIDTH-1:0]   s_WID;
        input   s_WDATA;
        input   s_WSTRB;
        input   s_WLAST;
        input   s_WUSER;
        input   s_WVALID;
        input   s_WREADY;
        // B Channel
        input   s_BID;
        input   s_BRESP;
        input   s_BUSER;
        input   s_BVALID;
        input   s_BREADY;
        // AR Channel
        input   s_ARID;    
        input   s_ARADDR;
        input   s_ARLEN;
        input   s_ARSIZE;
        input   s_ARBURST;
        input   s_ARLOCK;
        input   s_ARCACHE;
        input   s_ARPROT;
        input   s_ARQOS;
        input   s_ARREGION;
        input   s_ARUSER;
        input   s_ARVALID;
        input   s_ARREADY;
        // R Channel
        input   s_RID;
        input   s_RDATA;
        input   s_RRESP;
        input   s_RLAST;
        input   s_RUSER;
        input   s_RVALID; 
        input   s_RREADY;
    endclocking
    
    task reset_n();
        $display("[%0t(ns)] Starting reset!", $time);
        // system signals
        drv_cb.ARESETn      <= 0;
        
        // Master 0
        drv_cb.m0_ENABLE    <= 0;
        
        // AXI5 Interface (connect with CPU)
        // AW Channel
        drv_cb.m0_AWID      <= 0;
        drv_cb.m0_AWADDR    <= 0;
        drv_cb.m0_AWLEN     <= 0;
        drv_cb.m0_AWSIZE    <= 0;
        drv_cb.m0_AWBURST   <= 0;
        drv_cb.m0_AWLOCK    <= 0;
        drv_cb.m0_AWCACHE   <= 0;
        drv_cb.m0_AWPROT    <= 0;
        drv_cb.m0_AWQOS     <= 0;
        drv_cb.m0_AWREGION  <= 0;
        drv_cb.m0_AWUSER    <= 0;
        drv_cb.m0_AWDOMAIN  <= 0;
        drv_cb.m0_AWVALID   <= 0;
        
        // W Channel
        // output                       m_WID <= 0;
        drv_cb.m0_WDATA     <= 0;
        drv_cb.m0_WSTRB     <= 0; // use default value: 0xF
        drv_cb.m0_WLAST     <= 0;
        drv_cb.m0_WUSER     <= 0;
        drv_cb.m0_WVALID    <= 0;
        
        // B Channel
        drv_cb.m0_BREADY    <= 0;
        
        // AR Channel
        drv_cb.m0_ARID      <= 0;
        drv_cb.m0_ARADDR    <= 0;
        drv_cb.m0_ARLEN     <= 0;
        drv_cb.m0_ARSIZE    <= 0;
        drv_cb.m0_ARBURST   <= 0;
        drv_cb.m0_ARLOCK    <= 0;
        drv_cb.m0_ARCACHE   <= 0;
        drv_cb.m0_ARPROT    <= 0;
        drv_cb.m0_ARQOS     <= 0;
        drv_cb.m0_ARREGION  <= 0;
        drv_cb.m0_ARUSER    <= 0;
        drv_cb.m0_ARDOMAIN  <= 0;
        drv_cb.m0_ARVALID   <= 0;
        
        // R Channel
        drv_cb.m0_RREADY    <= 0;
        
        // Master 1
        drv_cb.m1_ENABLE    <= 0;
        
        // AXI5 Interface (connect with CPU)
        // AW Channel
        drv_cb.m1_AWID      <= 0;
        drv_cb.m1_AWADDR    <= 0;
        drv_cb.m1_AWLEN     <= 0;
        drv_cb.m1_AWSIZE    <= 0;
        drv_cb.m1_AWBURST   <= 0;
        drv_cb.m1_AWLOCK    <= 0;
        drv_cb.m1_AWCACHE   <= 0;
        drv_cb.m1_AWPROT    <= 0;
        drv_cb.m1_AWQOS     <= 0;
        drv_cb.m1_AWREGION  <= 0;
        drv_cb.m1_AWUSER    <= 0;
        drv_cb.m1_AWDOMAIN  <= 0;
        drv_cb.m1_AWVALID   <= 0;
        
        // W Channel
        // output                       m_WID <= 0;
        drv_cb.m1_WDATA     <= 0;
        drv_cb.m1_WSTRB     <= 0; // use default value: 0xF
        drv_cb.m1_WLAST     <= 0;
        drv_cb.m1_WUSER     <= 0;
        drv_cb.m1_WVALID    <= 0;
        
        // B Channel
        drv_cb.m1_BREADY    <= 0;
        
        // AR Channel
        drv_cb.m1_ARID      <= 0;
        drv_cb.m1_ARADDR    <= 0;
        drv_cb.m1_ARLEN     <= 0;
        drv_cb.m1_ARSIZE    <= 0;
        drv_cb.m1_ARBURST   <= 0;
        drv_cb.m1_ARLOCK    <= 0;
        drv_cb.m1_ARCACHE   <= 0;
        drv_cb.m1_ARPROT    <= 0;
        drv_cb.m1_ARQOS     <= 0;
        drv_cb.m1_ARREGION  <= 0;
        drv_cb.m1_ARUSER    <= 0;
        drv_cb.m1_ARDOMAIN  <= 0;
        drv_cb.m1_ARVALID   <= 0;
        
        // R Channel
        drv_cb.m1_RREADY    <= 0;
        
        // Slave
        // AW Channel
        drv_cb.s_AWREADY    <= 0;
        // W Channel
        drv_cb.s_WREADY     <= 0;
        // B Channel
        drv_cb.s_BID        <= 0;
        drv_cb.s_BRESP      <= 0;
        drv_cb.s_BUSER      <= 0;
        drv_cb.s_BVALID     <= 0;
        // AR Channel
        drv_cb.s_ARREADY    <= 0;
        // R Channel
        drv_cb.s_RID        <= 0;
        drv_cb.s_RDATA      <= 0;
        drv_cb.s_RRESP      <= 0;
        drv_cb.s_RLAST      <= 0;
        drv_cb.s_RUSER      <= 0;
        drv_cb.s_RVALID     <= 0; 
        
        // Hold reset for a few clock cycles
        repeat (20) @(drv_cb);
        drv_cb.ARESETn      <= 1;
        drv_cb.m0_ENABLE    <= 1;
        drv_cb.m1_ENABLE    <= 1;
        $display("[%0t(ns)] Finishing reset!", $time);
    endtask
    
    task save_state_tag_ram(
        input string path,
        input reg [24:0] state_tag_ram0 [0:15],
        input reg [24:0] state_tag_ram1 [0:15],
        input reg [24:0] state_tag_ram2 [0:15],
        input reg [24:0] state_tag_ram3 [0:15]
    );
        integer file;
        integer i;
    
        // Open the file for writing
        file = $fopen(path, "w");
        if (file == 0) begin
            $display("Error: Unable to open file %s", path);
            return;
        end
        // Write data
        for (i = 0; i < 16; i = i + 1) begin
            $fdisplay(file, "%25b %25b %25b %25b", state_tag_ram0[i], state_tag_ram1[i], state_tag_ram2[i], state_tag_ram3[i]);
        end
        // Close the file
        $fclose(file);
    endtask

    
    task save_plrut_ram(input string path, input reg [2:0] plrut_ram [0:15]);
        integer file;
        integer i;
    
        // Open the file for writing
        file = $fopen(path, "w");
        if (file == 0) begin
            $display("Error: Unable to open file %s", path);
            return;
        end
        // Write data
        for (i = 0; i < 16; i = i + 1) begin
            $fdisplay(file, "%3b", plrut_ram[i]);
        end
        // Close the file
        $fclose(file);
    endtask
    
    task save_data_ram(input string path, input reg [31:0] cache [0:1023]);
        integer file;
        integer i, j;
    
        // Open the file for writing
        file = $fopen(path, "w");
        if (file == 0) begin
            $display("Error: Unable to open file %s", path);
            return;
        end
        // Write data
        for (i = 0; i < 64; i = i + 1) begin
            $fdisplay(file, "0x%h 0x%h 0x%h 0x%h 0x%h 0x%h 0x%h 0x%h 0x%h 0x%h 0x%h 0x%h 0x%h 0x%h 0x%h 0x%h", 
                      cache[i*16+15], cache[i*16+14], cache[i*16+13], cache[i*16+12],
                      cache[i*16+11], cache[i*16+10], cache[i*16+9], cache[i*16+8],
                      cache[i*16+7], cache[i*16+6], cache[i*16+5], cache[i*16+4],
                      cache[i*16+3], cache[i*16+2], cache[i*16+1], cache[i*16+0]);
        end
        // Close the file
        $fclose(file);
    endtask
    
    task save_main_memory(input string path, input reg [31:0] main_memory [0:2**16-1]);
        integer file;
        integer i;
    
        // Open the file for writing
        file = $fopen(path, "w");
        if (file == 0) begin
            $display("Error: Unable to open file %s", path);
            return;
        end
        // Write data
        for (i = 0; i < 2**16; i = i + 1) begin
            $fdisplay(file, "0x%h", main_memory[i]);
        end
        // Close the file
        $fclose(file);
    endtask
    
    task save_cache(
                    input reg [24:0] state_tag_ram_A_0 [0:15],
                    input reg [24:0] state_tag_ram_A_1 [0:15],
                    input reg [24:0] state_tag_ram_A_2 [0:15],
                    input reg [24:0] state_tag_ram_A_3 [0:15],
                    
                    input reg [24:0] state_tag_ram_B_0 [0:15],
                    input reg [24:0] state_tag_ram_B_1 [0:15],
                    input reg [24:0] state_tag_ram_B_2 [0:15],
                    input reg [24:0] state_tag_ram_B_3 [0:15], 
                    
                    input reg [2:0] plrut_ram_A [0:15],
                    input reg [2:0] plrut_ram_B [0:15],
                    
                    input reg [31:0] cache_data_A [0:1023],
                    input reg [31:0] cache_data_B [0:1023]
                    
//                    input reg [31:0] main_memory [0:2**16-1]
                  );
        // $display("[%0t(ns)] Start saving simulation result!", $time);
        save_state_tag_ram(STATE_TAG_A, state_tag_ram_A_0, state_tag_ram_A_1, state_tag_ram_A_2, state_tag_ram_A_3);
        save_state_tag_ram(STATE_TAG_B, state_tag_ram_B_0, state_tag_ram_B_1, state_tag_ram_B_2, state_tag_ram_B_3);
        
        save_plrut_ram(PLRUT_RAM_A, plrut_ram_A);
        save_plrut_ram(PLRUT_RAM_B, plrut_ram_B);
        
        save_data_ram(DATA_RAM_A, cache_data_A);
        save_data_ram(DATA_RAM_B, cache_data_B);
        
//        save_main_memory(MAIN_MEMORY, main_memory);
        // $display("[%0t(ns)] Finish saving simulation result!", $time);
    endtask
    
    task save_single_cache(
                    input reg [24:0] state_tag_ram_A_0 [0:15],
                    input reg [24:0] state_tag_ram_A_1 [0:15],
                    input reg [24:0] state_tag_ram_A_2 [0:15],
                    input reg [24:0] state_tag_ram_A_3 [0:15],
                    
                    input reg [2:0] plrut_ram_A [0:15],
                    
                    input reg [31:0] cache_data_A [0:1023]
                  );
        $display("[%0t(ns)] Start saving simulation result!", $time);
        save_state_tag_ram(STATE_TAG_A, state_tag_ram_A_0, state_tag_ram_A_1, state_tag_ram_A_2, state_tag_ram_A_3);
        
        save_plrut_ram(PLRUT_RAM_A, plrut_ram_A);
        
        save_data_ram(DATA_RAM_A, cache_data_A);
        $display("[%0t(ns)] Finish saving simulation result!", $time);
    endtask

endinterface
