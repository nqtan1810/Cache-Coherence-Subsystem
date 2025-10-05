`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// top design
//////////////////////////////////////////////////////////////////////////////////


module subsystem_kit
#(
    parameter DATA_WIDTH  = 32,
    parameter ADDR_WIDTH  = 32,
    parameter ID_WIDTH    = 2,
    parameter USER_WIDTH  = 4,
    parameter STRB_WIDTH  = (DATA_WIDTH/8),
    parameter SHAREABLE_REGION_START = 32'h0000_1000, // start address of shareable region
    parameter SHAREABLE_REGION_END   = 32'h0003_FFFF,  // end address of shareable region
    parameter A_CODE_REGION_START = 32'h0000_0000, // start address of code region
    parameter A_CODE_REGION_END   = 32'h0000_03FF,  // end address of code region
    parameter B_CODE_REGION_START = 32'h0000_0400, // start address of code region
    parameter B_CODE_REGION_END   = 32'h0000_07FF,  // end address of code region
//    parameter IMEM_A_PATH   = "D:/University/KLTN/hw_design/coherence_cache/coherence_cache.srcs/sources_1/new/imem_A.mem",
//    parameter IMEM_B_PATH   = "D:/University/KLTN/hw_design/coherence_cache/coherence_cache.srcs/sources_1/new/imem_B.mem",
    parameter DMEM_INIT   = "D:/University/KLTN/hw_design/coherence_cache/coherence_cache.srcs/sources_1/new/mem_init.mem"
)
(
    // system signals
    input                    ACLK,
    input                    ARESETn,
    
    // enable
    input                    enable,
    
    // regfile of CPU-A
    input                    m0_reg_rd_en,
    input   [4:0]            m0_reg_addr,
    output  [DATA_WIDTH-1:0] m0_reg_data,
    
    // regfile of CPU-B
    input                    m1_reg_rd_en,
    input   [4:0]            m1_reg_addr,
    output  [DATA_WIDTH-1:0] m1_reg_data,
    
    // to Main Memory
    input                    m_wr_mem_en,
    input   [ADDR_WIDTH-1:0] m_wr_mem_addr,
    input   [DATA_WIDTH-1:0] m_wr_mem_data
);

    wire                     m0_ENABLE;
    // AXI Interface (connect with CPU)
    // AW Channel
    wire [ID_WIDTH-1:0]      m0_AWID;
    wire [ADDR_WIDTH-1:0]    m0_AWADDR;
    wire [7:0]               m0_AWLEN;
    wire [2:0]               m0_AWSIZE;
    wire [1:0]               m0_AWBURST;
    wire                     m0_AWLOCK;
    wire [3:0]               m0_AWCACHE;
    wire [2:0]               m0_AWPROT;
    wire [3:0]               m0_AWQOS;
    wire [3:0]               m0_AWREGION;
    wire [USER_WIDTH-1:0]    m0_AWUSER;
    wire [1:0]               m0_AWDOMAIN;
    wire                     m0_AWVALID;
    wire                     m0_AWREADY;
    
    // W Channel
    wire [DATA_WIDTH-1:0]    m0_WDATA;
    wire [STRB_WIDTH-1:0]    m0_WSTRB; 
    wire                     m0_WLAST;
    wire [USER_WIDTH-1:0]    m0_WUSER;
    wire                     m0_WVALID;
    wire                     m0_WREADY;
    
    // B Channel
    wire [ID_WIDTH-1:0]      m0_BID;
    wire [1:0]               m0_BRESP;
    wire [USER_WIDTH-1:0]    m0_BUSER;
    wire                     m0_BVALID;
    wire                     m0_BREADY;
    
    // AR Channel
    wire [ID_WIDTH-1:0]      m0_ARID;
    wire [ADDR_WIDTH-1:0]    m0_ARADDR;
    wire [7:0]               m0_ARLEN;
    wire [2:0]               m0_ARSIZE;
    wire [1:0]               m0_ARBURST;
    wire                     m0_ARLOCK;
    wire [3:0]               m0_ARCACHE;
    wire [2:0]               m0_ARPROT;
    wire [3:0]               m0_ARQOS;
    wire [3:0]               m0_ARREGION;
    wire [USER_WIDTH-1:0]    m0_ARUSER;
    wire [1:0]               m0_ARDOMAIN;
    wire                     m0_ARVALID;
    wire                     m0_ARREADY;
    
    // R Channel
    wire [ID_WIDTH-1:0]      m0_RID;
    wire [DATA_WIDTH-1:0]    m0_RDATA;
    wire [1:0]               m0_RRESP;
    wire                     m0_RLAST;
    wire [USER_WIDTH-1:0]	 m0_RUSER;
    wire                     m0_RVALID;
    wire                     m0_RREADY;
    
    // I-CacheA signals
    wire                     m2_ENABLE;
    // AW Channel
    wire [ID_WIDTH-1:0]      m2_AWID;
    wire [ADDR_WIDTH-1:0]    m2_AWADDR;
    wire [7:0]               m2_AWLEN;
    wire [2:0]               m2_AWSIZE;
    wire [1:0]               m2_AWBURST;
    wire                     m2_AWLOCK;
    wire [3:0]               m2_AWCACHE;
    wire [2:0]               m2_AWPROT;
    wire [3:0]               m2_AWQOS;
    wire [3:0]               m2_AWREGION;
    wire [USER_WIDTH-1:0]    m2_AWUSER;
    wire                     m2_AWVALID;
    wire                     m2_AWREADY;
    
    // W Channel
    wire [DATA_WIDTH-1:0]    m2_WDATA;
    wire [STRB_WIDTH-1:0]    m2_WSTRB; 
    wire                     m2_WLAST;
    wire [USER_WIDTH-1:0]    m2_WUSER;
    wire                     m2_WVALID;
    wire                     m2_WREADY;
    
    // B Channel
    wire [ID_WIDTH-1:0]      m2_BID;
    wire [1:0]               m2_BRESP;
    wire [USER_WIDTH-1:0]    m2_BUSER;
    wire                     m2_BVALID;
    wire                     m2_BREADY;
    
    // AR Channel
    wire [ID_WIDTH-1:0]      m2_ARID;
    wire [ADDR_WIDTH-1:0]    m2_ARADDR;
    wire [7:0]               m2_ARLEN;
    wire [2:0]               m2_ARSIZE;
    wire [1:0]               m2_ARBURST;
    wire                     m2_ARLOCK;
    wire [3:0]               m2_ARCACHE;
    wire [2:0]               m2_ARPROT;
    wire [3:0]               m2_ARQOS;
    wire [3:0]               m2_ARREGION;
    wire [USER_WIDTH-1:0]    m2_ARUSER;
    wire                     m2_ARVALID;
    wire                     m2_ARREADY;
    
    // R Channel
    wire [ID_WIDTH-1:0]      m2_RID;
    wire [DATA_WIDTH-1:0]    m2_RDATA;
    wire [1:0]               m2_RRESP;
    wire                     m2_RLAST;
    wire [USER_WIDTH-1:0]	 m2_RUSER;
    wire                     m2_RVALID;
    wire                     m2_RREADY;

    riscv_processor #(
        .ID                     (0                     ),
        .DATA_WIDTH             (DATA_WIDTH            ),
        .ADDR_WIDTH             (ADDR_WIDTH            ),
        .ID_WIDTH               (ID_WIDTH              ),
        .USER_WIDTH             (USER_WIDTH            ),
        .STRB_WIDTH             (STRB_WIDTH            ),
        .SHAREABLE_REGION_START (SHAREABLE_REGION_START),
        .SHAREABLE_REGION_END   (SHAREABLE_REGION_END  ),
        .CODE_REGION_START      (A_CODE_REGION_START   ), // start address of code region
        .CODE_REGION_END        (A_CODE_REGION_END     )  // end address of code region
        // .IMEM_PATH              (IMEM_A_PATH           )
    ) cpuA (
        .ACLK           (ACLK),
        .ARESETn        (ARESETn),
        
        // enable
        .enable         (enable),
        
        // regfile
        .reg_rd_en      (m0_reg_rd_en),
        .reg_addr       (m0_reg_addr ),
        .reg_data       (m0_reg_data ),
        
        // D-Cache interface
        .d_CACHE_EN     (m0_ENABLE),
        
        // AXI Write Address Channel
        .d_AWID         (m0_AWID    ),
        .d_AWADDR       (m0_AWADDR  ),
        .d_AWLEN        (m0_AWLEN   ),
        .d_AWSIZE       (m0_AWSIZE  ),
        .d_AWBURST      (m0_AWBURST ),
        .d_AWLOCK       (m0_AWLOCK  ),
        .d_AWCACHE      (m0_AWCACHE ),
        .d_AWPROT       (m0_AWPROT  ),
        .d_AWQOS        (m0_AWQOS   ),
        .d_AWREGION     (m0_AWREGION),
        .d_AWUSER       (m0_AWUSER  ),
        .d_AWDOMAIN     (m0_AWDOMAIN),
        .d_AWVALID      (m0_AWVALID ),
        .d_AWREADY      (m0_AWREADY ),
    
        // AXI Write Data Channel
        .d_WDATA        (m0_WDATA ),
        .d_WSTRB        (m0_WSTRB ),
        .d_WLAST        (m0_WLAST ),
        .d_WUSER        (m0_WUSER ),
        .d_WVALID       (m0_WVALID),
        .d_WREADY       (m0_WREADY),
    
        // AXI Write Response Channel
        .d_BID          (m0_BID   ),
        .d_BRESP        (m0_BRESP ),
        .d_BUSER        (m0_BUSER ),
        .d_BVALID       (m0_BVALID),
        .d_BREADY       (m0_BREADY),
    
        // AXI Read Address Channel
        .d_ARID         (m0_ARID    ),
        .d_ARADDR       (m0_ARADDR  ),
        .d_ARLEN        (m0_ARLEN   ),
        .d_ARSIZE       (m0_ARSIZE  ),
        .d_ARBURST      (m0_ARBURST ),
        .d_ARLOCK       (m0_ARLOCK  ),
        .d_ARCACHE      (m0_ARCACHE ),
        .d_ARPROT       (m0_ARPROT  ),
        .d_ARQOS        (m0_ARQOS   ),
        .d_ARREGION     (m0_ARREGION),
        .d_ARUSER       (m0_ARUSER  ),
        .d_ARDOMAIN     (m0_ARDOMAIN),
        .d_ARVALID      (m0_ARVALID ),
        .d_ARREADY      (m0_ARREADY ),
    
        // AXI Read Data Channel
        .d_RID          (m0_RID   ),
        .d_RDATA        (m0_RDATA ),
        .d_RRESP        (m0_RRESP ),
        .d_RLAST        (m0_RLAST ),
        .d_RUSER        (m0_RUSER ),
        .d_RVALID       (m0_RVALID),
        .d_RREADY       (m0_RREADY),
        
        // I-Cache related signals
        .i_CACHE_EN     (m2_ENABLE),
        // AXI4
        // AW Channel
        .i_AWID         (m2_AWID    ),
        .i_AWADDR       (m2_AWADDR  ),
        .i_AWLEN        (m2_AWLEN   ),
        .i_AWSIZE       (m2_AWSIZE  ),
        .i_AWBURST      (m2_AWBURST ),
        .i_AWLOCK       (m2_AWLOCK  ),
        .i_AWCACHE      (m2_AWCACHE ),
        .i_AWPROT       (m2_AWPROT  ),
        .i_AWQOS        (m2_AWQOS   ),
        .i_AWREGION     (m2_AWREGION),
        .i_AWUSER       (m2_AWUSER  ),
        .i_AWVALID      (m2_AWVALID ),
        .i_AWREADY      (m2_AWREADY ),
        
        // W Channel
        .i_WDATA        (m2_WDATA ),
        .i_WSTRB        (m2_WSTRB ), 
        .i_WLAST        (m2_WLAST ),
        .i_WUSER        (m2_WUSER ),
        .i_WVALID       (m2_WVALID),
        .i_WREADY       (m2_WREADY),
        
        // B Channel
        .i_BID          (m2_BID   ),
        .i_BRESP        (m2_BRESP ),
        .i_BUSER        (m2_BUSER ),
        .i_BVALID       (m2_BVALID),
        .i_BREADY       (m2_BREADY),
       
        // AR Channel
        .i_ARID         (m2_ARID    ),
        .i_ARADDR       (m2_ARADDR  ),
        .i_ARLEN        (m2_ARLEN   ),
        .i_ARSIZE       (m2_ARSIZE  ),
        .i_ARBURST      (m2_ARBURST ),
        .i_ARLOCK       (m2_ARLOCK  ),
        .i_ARCACHE      (m2_ARCACHE ),
        .i_ARPROT       (m2_ARPROT  ),
        .i_ARQOS        (m2_ARQOS   ),
        .i_ARREGION     (m2_ARREGION),
        .i_ARUSER       (m2_ARUSER  ),
        .i_ARVALID      (m2_ARVALID ),
        .i_ARREADY      (m2_ARREADY ),
        
        // R Channel
        .i_RID          (m2_RID   ),
        .i_RDATA        (m2_RDATA ),
        .i_RRESP        (m2_RRESP ),
        .i_RLAST        (m2_RLAST ),
        .i_RUSER        (m2_RUSER ),
        .i_RVALID       (m2_RVALID),
        .i_RREADY       (m2_RREADY)
    );
    
    wire                     m1_ENABLE;
    // AXI Interface (connect with CPU)
    // AW Channel
    wire [ID_WIDTH-1:0]      m1_AWID;
    wire [ADDR_WIDTH-1:0]    m1_AWADDR;
    wire [7:0]               m1_AWLEN;
    wire [2:0]               m1_AWSIZE;
    wire [1:0]               m1_AWBURST;
    wire                     m1_AWLOCK;
    wire [3:0]               m1_AWCACHE;
    wire [2:0]               m1_AWPROT;
    wire [3:0]               m1_AWQOS;
    wire [3:0]               m1_AWREGION;
    wire [USER_WIDTH-1:0]    m1_AWUSER;
    wire [1:0]               m1_AWDOMAIN;
    wire                     m1_AWVALID;
    wire                     m1_AWREADY;
    
    // W Channel
    wire [DATA_WIDTH-1:0]    m1_WDATA;
    wire [STRB_WIDTH-1:0]    m1_WSTRB; 
    wire                     m1_WLAST;
    wire [USER_WIDTH-1:0]    m1_WUSER;
    wire                     m1_WVALID;
    wire                     m1_WREADY;
    
    // B Channel
    wire [ID_WIDTH-1:0]      m1_BID;
    wire [1:0]               m1_BRESP;
    wire [USER_WIDTH-1:0]    m1_BUSER;
    wire                     m1_BVALID;
    wire                     m1_BREADY;
    
    // AR Channel
    wire [ID_WIDTH-1:0]      m1_ARID;
    wire [ADDR_WIDTH-1:0]    m1_ARADDR;
    wire [7:0]               m1_ARLEN;
    wire [2:0]               m1_ARSIZE;
    wire [1:0]               m1_ARBURST;
    wire                     m1_ARLOCK;
    wire [3:0]               m1_ARCACHE;
    wire [2:0]               m1_ARPROT;
    wire [3:0]               m1_ARQOS;
    wire [3:0]               m1_ARREGION;
    wire [USER_WIDTH-1:0]    m1_ARUSER;
    wire [1:0]               m1_ARDOMAIN;
    wire                     m1_ARVALID;
    wire                     m1_ARREADY;
    
    // R Channel
    wire [ID_WIDTH-1:0]      m1_RID;
    wire [DATA_WIDTH-1:0]    m1_RDATA;
    wire [1:0]               m1_RRESP;
    wire                     m1_RLAST;
    wire [USER_WIDTH-1:0]	 m1_RUSER;
    wire                     m1_RVALID;
    wire                     m1_RREADY;
    
    // I-CacheB signals
    wire                     m3_ENABLE;
    // AW Channel
    wire [ID_WIDTH-1:0]      m3_AWID;
    wire [ADDR_WIDTH-1:0]    m3_AWADDR;
    wire [7:0]               m3_AWLEN;
    wire [2:0]               m3_AWSIZE;
    wire [1:0]               m3_AWBURST;
    wire                     m3_AWLOCK;
    wire [3:0]               m3_AWCACHE;
    wire [2:0]               m3_AWPROT;
    wire [3:0]               m3_AWQOS;
    wire [3:0]               m3_AWREGION;
    wire [USER_WIDTH-1:0]    m3_AWUSER;
    wire                     m3_AWVALID;
    wire                     m3_AWREADY;
    
    // W Channel
    wire [DATA_WIDTH-1:0]    m3_WDATA;
    wire [STRB_WIDTH-1:0]    m3_WSTRB; 
    wire                     m3_WLAST;
    wire [USER_WIDTH-1:0]    m3_WUSER;
    wire                     m3_WVALID;
    wire                     m3_WREADY;
    
    // B Channel
    wire [ID_WIDTH-1:0]      m3_BID;
    wire [1:0]               m3_BRESP;
    wire [USER_WIDTH-1:0]    m3_BUSER;
    wire                     m3_BVALID;
    wire                     m3_BREADY;
    
    // AR Channel
    wire [ID_WIDTH-1:0]      m3_ARID;
    wire [ADDR_WIDTH-1:0]    m3_ARADDR;
    wire [7:0]               m3_ARLEN;
    wire [2:0]               m3_ARSIZE;
    wire [1:0]               m3_ARBURST;
    wire                     m3_ARLOCK;
    wire [3:0]               m3_ARCACHE;
    wire [2:0]               m3_ARPROT;
    wire [3:0]               m3_ARQOS;
    wire [3:0]               m3_ARREGION;
    wire [USER_WIDTH-1:0]    m3_ARUSER;
    wire                     m3_ARVALID;
    wire                     m3_ARREADY;
    
    // R Channel
    wire [ID_WIDTH-1:0]      m3_RID;
    wire [DATA_WIDTH-1:0]    m3_RDATA;
    wire [1:0]               m3_RRESP;
    wire                     m3_RLAST;
    wire [USER_WIDTH-1:0]	 m3_RUSER;
    wire                     m3_RVALID;
    wire                     m3_RREADY;

    riscv_processor #(
        .ID                     (1                     ),
        .DATA_WIDTH             (DATA_WIDTH            ),
        .ADDR_WIDTH             (ADDR_WIDTH            ),
        .ID_WIDTH               (ID_WIDTH              ),
        .USER_WIDTH             (USER_WIDTH            ),
        .STRB_WIDTH             (STRB_WIDTH            ),
        .SHAREABLE_REGION_START (SHAREABLE_REGION_START),
        .SHAREABLE_REGION_END   (SHAREABLE_REGION_END  ),
        .CODE_REGION_START      (B_CODE_REGION_START   ), // start address of code region
        .CODE_REGION_END        (B_CODE_REGION_END     )  // end address of code region
        // .IMEM_PATH              (IMEM_B_PATH           )
    ) cpuB (
        .ACLK           (ACLK),
        .ARESETn        (ARESETn),
        
        // enable
        .enable         (enable),
        
        // regfile
        .reg_rd_en      (m1_reg_rd_en),
        .reg_addr       (m1_reg_addr ),
        .reg_data       (m1_reg_data ),
        
        // D-Cache interface
        .d_CACHE_EN     (m1_ENABLE),
        
        // AXI Write Address Channel
        .d_AWID         (m1_AWID    ),
        .d_AWADDR       (m1_AWADDR  ),
        .d_AWLEN        (m1_AWLEN   ),
        .d_AWSIZE       (m1_AWSIZE  ),
        .d_AWBURST      (m1_AWBURST ),
        .d_AWLOCK       (m1_AWLOCK  ),
        .d_AWCACHE      (m1_AWCACHE ),
        .d_AWPROT       (m1_AWPROT  ),
        .d_AWQOS        (m1_AWQOS   ),
        .d_AWREGION     (m1_AWREGION),
        .d_AWUSER       (m1_AWUSER  ),
        .d_AWDOMAIN     (m1_AWDOMAIN),
        .d_AWVALID      (m1_AWVALID ),
        .d_AWREADY      (m1_AWREADY ),
    
        // AXI Write Data Channel
        .d_WDATA        (m1_WDATA ),
        .d_WSTRB        (m1_WSTRB ),
        .d_WLAST        (m1_WLAST ),
        .d_WUSER        (m1_WUSER ),
        .d_WVALID       (m1_WVALID),
        .d_WREADY       (m1_WREADY),
    
        // AXI Write Response Channel
        .d_BID          (m1_BID   ),
        .d_BRESP        (m1_BRESP ),
        .d_BUSER        (m1_BUSER ),
        .d_BVALID       (m1_BVALID),
        .d_BREADY       (m1_BREADY),
    
        // AXI Read Address Channel
        .d_ARID         (m1_ARID    ),
        .d_ARADDR       (m1_ARADDR  ),
        .d_ARLEN        (m1_ARLEN   ),
        .d_ARSIZE       (m1_ARSIZE  ),
        .d_ARBURST      (m1_ARBURST ),
        .d_ARLOCK       (m1_ARLOCK  ),
        .d_ARCACHE      (m1_ARCACHE ),
        .d_ARPROT       (m1_ARPROT  ),
        .d_ARQOS        (m1_ARQOS   ),
        .d_ARREGION     (m1_ARREGION),
        .d_ARUSER       (m1_ARUSER  ),
        .d_ARDOMAIN     (m1_ARDOMAIN),
        .d_ARVALID      (m1_ARVALID ),
        .d_ARREADY      (m1_ARREADY ),
    
        // AXI Read Data Channel
        .d_RID          (m1_RID   ),
        .d_RDATA        (m1_RDATA ),
        .d_RRESP        (m1_RRESP ),
        .d_RLAST        (m1_RLAST ),
        .d_RUSER        (m1_RUSER ),
        .d_RVALID       (m1_RVALID),
        .d_RREADY       (m1_RREADY),
        
        // I-Cache related signals
        .i_CACHE_EN     (m3_ENABLE),
        // AXI4
        // AW Channel
        .i_AWID         (m3_AWID    ),
        .i_AWADDR       (m3_AWADDR  ),
        .i_AWLEN        (m3_AWLEN   ),
        .i_AWSIZE       (m3_AWSIZE  ),
        .i_AWBURST      (m3_AWBURST ),
        .i_AWLOCK       (m3_AWLOCK  ),
        .i_AWCACHE      (m3_AWCACHE ),
        .i_AWPROT       (m3_AWPROT  ),
        .i_AWQOS        (m3_AWQOS   ),
        .i_AWREGION     (m3_AWREGION),
        .i_AWUSER       (m3_AWUSER  ),
        .i_AWVALID      (m3_AWVALID ),
        .i_AWREADY      (m3_AWREADY ),
        
        // W Channel
        .i_WDATA        (m3_WDATA ),
        .i_WSTRB        (m3_WSTRB ), 
        .i_WLAST        (m3_WLAST ),
        .i_WUSER        (m3_WUSER ),
        .i_WVALID       (m3_WVALID),
        .i_WREADY       (m3_WREADY),
        
        // B Channel
        .i_BID          (m3_BID   ),
        .i_BRESP        (m3_BRESP ),
        .i_BUSER        (m3_BUSER ),
        .i_BVALID       (m3_BVALID),
        .i_BREADY       (m3_BREADY),
       
        // AR Channel
        .i_ARID         (m3_ARID    ),
        .i_ARADDR       (m3_ARADDR  ),
        .i_ARLEN        (m3_ARLEN   ),
        .i_ARSIZE       (m3_ARSIZE  ),
        .i_ARBURST      (m3_ARBURST ),
        .i_ARLOCK       (m3_ARLOCK  ),
        .i_ARCACHE      (m3_ARCACHE ),
        .i_ARPROT       (m3_ARPROT  ),
        .i_ARQOS        (m3_ARQOS   ),
        .i_ARREGION     (m3_ARREGION),
        .i_ARUSER       (m3_ARUSER  ),
        .i_ARVALID      (m3_ARVALID ),
        .i_ARREADY      (m3_ARREADY ),
        
        // R Channel
        .i_RID          (m3_RID   ),
        .i_RDATA        (m3_RDATA ),
        .i_RRESP        (m3_RRESP ),
        .i_RLAST        (m3_RLAST ),
        .i_RUSER        (m3_RUSER ),
        .i_RVALID       (m3_RVALID),
        .i_RREADY       (m3_RREADY)
    );
    
    // AW Channel
    wire [ID_WIDTH-1:0]   s2_AWID;
    wire [ADDR_WIDTH-1:0] s2_AWADDR;
    wire [7:0]            s2_AWLEN;
    wire [2:0]            s2_AWSIZE;
    wire [1:0]            s2_AWBURST;
    wire                  s2_AWLOCK;
    wire [3:0]            s2_AWCACHE;
    wire [2:0]            s2_AWPROT;
    wire [3:0]            s2_AWQOS;
    wire [3:0]            s2_AWREGION;
    wire [USER_WIDTH-1:0] s2_AWUSER;
    wire                  s2_AWVALID;
    wire 	              s2_AWREADY;
    // W Channel
    // output     [ID_WIDTH-1:0]   s_WID;
    wire [DATA_WIDTH-1:0] s2_WDATA;
    wire [STRB_WIDTH-1:0] s2_WSTRB;
    wire                  s2_WLAST;
    wire [USER_WIDTH-1:0] s2_WUSER;
    wire                  s2_WVALID;
    wire		          s2_WREADY;
    // B Channel
	wire [ID_WIDTH-1:0]	  s2_BID;
	wire [1:0]	          s2_BRESP;
	wire [USER_WIDTH-1:0] s2_BUSER;
	wire   		          s2_BVALID;
    wire                  s2_BREADY;
    // AR Channel
    wire [ID_WIDTH-1:0]   s2_ARID;    
    wire [ADDR_WIDTH-1:0] s2_ARADDR;
    wire [7:0]            s2_ARLEN;
    wire [2:0]            s2_ARSIZE;
    wire [1:0]            s2_ARBURST;
    wire                  s2_ARLOCK;
    wire [3:0]            s2_ARCACHE;
    wire [2:0]            s2_ARPROT;
    wire [3:0]            s2_ARQOS;
    wire [3:0]            s2_ARREGION;
    wire [USER_WIDTH-1:0] s2_ARUSER;
    wire                  s2_ARVALID;
	wire		          s2_ARREADY;
    // R Channel
	wire [ID_WIDTH-1:0]   s2_RID;
	wire [DATA_WIDTH-1:0] s2_RDATA;
	wire [1:0]	          s2_RRESP;
	wire		          s2_RLAST;
	wire [USER_WIDTH-1:0] s2_RUSER;
	wire	              s2_RVALID; 
    wire                  s2_RREADY;
    
    instr_cache #(
        .DATA_WIDTH    (DATA_WIDTH),
        .ADDR_WIDTH    (ADDR_WIDTH),
        .ID_WIDTH      (ID_WIDTH  ),
        .USER_WIDTH    (USER_WIDTH),
        .STRB_WIDTH    (STRB_WIDTH),
        .ADDR_START    (A_CODE_REGION_START),
        .ADDR_END      (A_CODE_REGION_END  )
    ) 
    I_cacheA
    (
        // system signals
        .ACLK          (ACLK   ),
        .ARESETn       (ARESETn),
        .ENABLE        (m2_ENABLE),
        .CACHE_HIT     (/*m0_I_CACHE_HIT */),
        .CACHE_BUSY    (/*m0_I_CACHE_BUSY*/),
    
        // AXI5 Interface (connect with CPU)
        // AW Channel
        .m_AWID        (m2_AWID    ),
        .m_AWADDR      (m2_AWADDR  ),
        .m_AWLEN       (m2_AWLEN   ),
        .m_AWSIZE      (m2_AWSIZE  ),
        .m_AWBURST     (m2_AWBURST ),
        .m_AWLOCK      (m2_AWLOCK  ),
        .m_AWCACHE     (m2_AWCACHE ),
        .m_AWPROT      (m2_AWPROT  ),
        .m_AWQOS       (m2_AWQOS   ),
        .m_AWREGION    (m2_AWREGION),
        .m_AWUSER      (m2_AWUSER  ),
        .m_AWVALID     (m2_AWVALID ),
        .m_AWREADY     (m2_AWREADY ),
        
        // W Channel
        .m_WDATA       (m2_WDATA ),
        .m_WSTRB       (m2_WSTRB ),
        .m_WLAST       (m2_WLAST ),
        .m_WUSER       (m2_WUSER ),
        .m_WVALID      (m2_WVALID),
        .m_WREADY      (m2_WREADY),
        
        // B Channel
        .m_BID         (m2_BID   ),
        .m_BRESP       (m2_BRESP ),
        .m_BUSER       (m2_BUSER ),
        .m_BVALID      (m2_BVALID),
        .m_BREADY      (m2_BREADY),
        
        // AR Channel
        .m_ARID        (m2_ARID    ),
        .m_ARADDR      (m2_ARADDR  ),
        .m_ARLEN       (m2_ARLEN   ),
        .m_ARSIZE      (m2_ARSIZE  ),
        .m_ARBURST     (m2_ARBURST ),
        .m_ARLOCK      (m2_ARLOCK  ),
        .m_ARCACHE     (m2_ARCACHE ),
        .m_ARPROT      (m2_ARPROT  ),
        .m_ARQOS       (m2_ARQOS   ),
        .m_ARREGION    (m2_ARREGION),
        .m_ARUSER      (m2_ARUSER  ),
        .m_ARVALID     (m2_ARVALID ),
        .m_ARREADY     (m2_ARREADY ),
        
        // R Channel
        .m_RID         (m2_RID   ),
        .m_RDATA       (m2_RDATA ),
        .m_RRESP       (m2_RRESP ),
        .m_RLAST       (m2_RLAST ),
        .m_RUSER       (m2_RUSER ),
        .m_RVALID      (m2_RVALID),
        .m_RREADY      (m2_RREADY),
        
        // AXI5 Interface (connect with Cache L2)
        // AW Channel
        .s_AWID        (s2_AWID    ),
        .s_AWADDR      (s2_AWADDR  ),
        .s_AWLEN       (s2_AWLEN   ),
        .s_AWSIZE      (s2_AWSIZE  ),
        .s_AWBURST     (s2_AWBURST ),
        .s_AWLOCK      (s2_AWLOCK  ),
        .s_AWCACHE     (s2_AWCACHE ),
        .s_AWPROT      (s2_AWPROT  ),
        .s_AWQOS       (s2_AWQOS   ),
        .s_AWREGION    (s2_AWREGION),
        .s_AWUSER      (s2_AWUSER  ),
        .s_AWVALID     (s2_AWVALID ),
        .s_AWREADY     (s2_AWREADY ),
        
        // W Channel
        .s_WDATA       (s2_WDATA ),
        .s_WSTRB       (s2_WSTRB ),
        .s_WLAST       (s2_WLAST ),
        .s_WUSER       (s2_WUSER ),
        .s_WVALID      (s2_WVALID),
        .s_WREADY      (s2_WREADY),
        
        // B Channel
        .s_BID         (s2_BID   ),
        .s_BRESP       (s2_BRESP ),
        .s_BUSER       (s2_BUSER ),
        .s_BVALID      (s2_BVALID),
        .s_BREADY      (s2_BREADY),
        
        // AR Channel
        .s_ARID        (s2_ARID    ),
        .s_ARADDR      (s2_ARADDR  ),
        .s_ARLEN       (s2_ARLEN   ),
        .s_ARSIZE      (s2_ARSIZE  ),
        .s_ARBURST     (s2_ARBURST ),
        .s_ARLOCK      (s2_ARLOCK  ),
        .s_ARCACHE     (s2_ARCACHE ),
        .s_ARPROT      (s2_ARPROT  ),
        .s_ARQOS       (s2_ARQOS   ),
        .s_ARREGION    (s2_ARREGION),
        .s_ARUSER      (s2_ARUSER  ),
        .s_ARVALID     (s2_ARVALID ),
        .s_ARREADY     (s2_ARREADY ),
        
        // R Channel
        .s_RID         (s2_RID   ),
        .s_RDATA       (s2_RDATA ),
        .s_RRESP       (s2_RRESP ),
        .s_RLAST       (s2_RLAST ),
        .s_RUSER       (s2_RUSER ),
        .s_RVALID      (s2_RVALID),
        .s_RREADY      (s2_RREADY)
    );
    
    
    // AW Channel
    wire [ID_WIDTH-1:0]   s3_AWID;
    wire [ADDR_WIDTH-1:0] s3_AWADDR;
    wire [7:0]            s3_AWLEN;
    wire [2:0]            s3_AWSIZE;
    wire [1:0]            s3_AWBURST;
    wire                  s3_AWLOCK;
    wire [3:0]            s3_AWCACHE;
    wire [2:0]            s3_AWPROT;
    wire [3:0]            s3_AWQOS;
    wire [3:0]            s3_AWREGION;
    wire [USER_WIDTH-1:0] s3_AWUSER;
    wire                  s3_AWVALID;
    wire 	              s3_AWREADY;
    // W Channel
    // output     [ID_WIDTH-1:0]   s_WID;
    wire [DATA_WIDTH-1:0] s3_WDATA;
    wire [STRB_WIDTH-1:0] s3_WSTRB;
    wire                  s3_WLAST;
    wire [USER_WIDTH-1:0] s3_WUSER;
    wire                  s3_WVALID;
    wire		          s3_WREADY;
    // B Channel
	wire [ID_WIDTH-1:0]	  s3_BID;
	wire [1:0]	          s3_BRESP;
	wire [USER_WIDTH-1:0] s3_BUSER;
	wire   		          s3_BVALID;
    wire                  s3_BREADY;
    // AR Channel
    wire [ID_WIDTH-1:0]   s3_ARID;    
    wire [ADDR_WIDTH-1:0] s3_ARADDR;
    wire [7:0]            s3_ARLEN;
    wire [2:0]            s3_ARSIZE;
    wire [1:0]            s3_ARBURST;
    wire                  s3_ARLOCK;
    wire [3:0]            s3_ARCACHE;
    wire [2:0]            s3_ARPROT;
    wire [3:0]            s3_ARQOS;
    wire [3:0]            s3_ARREGION;
    wire [USER_WIDTH-1:0] s3_ARUSER;
    wire                  s3_ARVALID;
	wire		          s3_ARREADY;
    // R Channel
	wire [ID_WIDTH-1:0]   s3_RID;
	wire [DATA_WIDTH-1:0] s3_RDATA;
	wire [1:0]	          s3_RRESP;
	wire		          s3_RLAST;
	wire [USER_WIDTH-1:0] s3_RUSER;
	wire	              s3_RVALID; 
    wire                  s3_RREADY;
    
    instr_cache #(
        .DATA_WIDTH    (DATA_WIDTH),
        .ADDR_WIDTH    (ADDR_WIDTH),
        .ID_WIDTH      (ID_WIDTH  ),
        .USER_WIDTH    (USER_WIDTH),
        .STRB_WIDTH    (STRB_WIDTH),
        .ADDR_START    (B_CODE_REGION_START),
        .ADDR_END      (B_CODE_REGION_END  )
    ) 
    I_cacheB
    (
        // system signals
        .ACLK          (ACLK   ),
        .ARESETn       (ARESETn),
        .ENABLE        (m3_ENABLE),
        .CACHE_HIT     (/*m1_I_CACHE_HIT */),
        .CACHE_BUSY    (/*m1_I_CACHE_BUSY*/),
    
        // AXI5 Interface (connect with CPU)
        // AW Channel
        .m_AWID        (m3_AWID    ),
        .m_AWADDR      (m3_AWADDR  ),
        .m_AWLEN       (m3_AWLEN   ),
        .m_AWSIZE      (m3_AWSIZE  ),
        .m_AWBURST     (m3_AWBURST ),
        .m_AWLOCK      (m3_AWLOCK  ),
        .m_AWCACHE     (m3_AWCACHE ),
        .m_AWPROT      (m3_AWPROT  ),
        .m_AWQOS       (m3_AWQOS   ),
        .m_AWREGION    (m3_AWREGION),
        .m_AWUSER      (m3_AWUSER  ),
        .m_AWVALID     (m3_AWVALID ),
        .m_AWREADY     (m3_AWREADY ),
        
        // W Channel
        .m_WDATA       (m3_WDATA ),
        .m_WSTRB       (m3_WSTRB ),
        .m_WLAST       (m3_WLAST ),
        .m_WUSER       (m3_WUSER ),
        .m_WVALID      (m3_WVALID),
        .m_WREADY      (m3_WREADY),
        
        // B Channel
        .m_BID         (m3_BID   ),
        .m_BRESP       (m3_BRESP ),
        .m_BUSER       (m3_BUSER ),
        .m_BVALID      (m3_BVALID),
        .m_BREADY      (m3_BREADY),
        
        // AR Channel
        .m_ARID        (m3_ARID    ),
        .m_ARADDR      (m3_ARADDR  ),
        .m_ARLEN       (m3_ARLEN   ),
        .m_ARSIZE      (m3_ARSIZE  ),
        .m_ARBURST     (m3_ARBURST ),
        .m_ARLOCK      (m3_ARLOCK  ),
        .m_ARCACHE     (m3_ARCACHE ),
        .m_ARPROT      (m3_ARPROT  ),
        .m_ARQOS       (m3_ARQOS   ),
        .m_ARREGION    (m3_ARREGION),
        .m_ARUSER      (m3_ARUSER  ),
        .m_ARVALID     (m3_ARVALID ),
        .m_ARREADY     (m3_ARREADY ),
        
        // R Channel
        .m_RID         (m3_RID   ),
        .m_RDATA       (m3_RDATA ),
        .m_RRESP       (m3_RRESP ),
        .m_RLAST       (m3_RLAST ),
        .m_RUSER       (m3_RUSER ),
        .m_RVALID      (m3_RVALID),
        .m_RREADY      (m3_RREADY),
        
        // AXI5 Interface (connect with Cache L2)
        // AW Channel
        .s_AWID        (s3_AWID    ),
        .s_AWADDR      (s3_AWADDR  ),
        .s_AWLEN       (s3_AWLEN   ),
        .s_AWSIZE      (s3_AWSIZE  ),
        .s_AWBURST     (s3_AWBURST ),
        .s_AWLOCK      (s3_AWLOCK  ),
        .s_AWCACHE     (s3_AWCACHE ),
        .s_AWPROT      (s3_AWPROT  ),
        .s_AWQOS       (s3_AWQOS   ),
        .s_AWREGION    (s3_AWREGION),
        .s_AWUSER      (s3_AWUSER  ),
        .s_AWVALID     (s3_AWVALID ),
        .s_AWREADY     (s3_AWREADY ),
        
        // W Channel
        .s_WDATA       (s3_WDATA ),
        .s_WSTRB       (s3_WSTRB ),
        .s_WLAST       (s3_WLAST ),
        .s_WUSER       (s3_WUSER ),
        .s_WVALID      (s3_WVALID),
        .s_WREADY      (s3_WREADY),
        
        // B Channel
        .s_BID         (s3_BID   ),
        .s_BRESP       (s3_BRESP ),
        .s_BUSER       (s3_BUSER ),
        .s_BVALID      (s3_BVALID),
        .s_BREADY      (s3_BREADY),
        
        // AR Channel
        .s_ARID        (s3_ARID    ),
        .s_ARADDR      (s3_ARADDR  ),
        .s_ARLEN       (s3_ARLEN   ),
        .s_ARSIZE      (s3_ARSIZE  ),
        .s_ARBURST     (s3_ARBURST ),
        .s_ARLOCK      (s3_ARLOCK  ),
        .s_ARCACHE     (s3_ARCACHE ),
        .s_ARPROT      (s3_ARPROT  ),
        .s_ARQOS       (s3_ARQOS   ),
        .s_ARREGION    (s3_ARREGION),
        .s_ARUSER      (s3_ARUSER  ),
        .s_ARVALID     (s3_ARVALID ),
        .s_ARREADY     (s3_ARREADY ),
        
        // R Channel
        .s_RID         (s3_RID   ),
        .s_RDATA       (s3_RDATA ),
        .s_RRESP       (s3_RRESP ),
        .s_RLAST       (s3_RLAST ),
        .s_RUSER       (s3_RUSER ),
        .s_RVALID      (s3_RVALID),
        .s_RREADY      (s3_RREADY)
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
    wire                  m0_ACVALID;
    wire [ADDR_WIDTH-1:0] m0_ACADDR;
    wire [3:0]            m0_ACSNOOP;
    wire [2:0]            m0_ACPROT;
    wire                  m0_ACREADY;
   
    // CR Channe
    wire                  m0_CRREADY;
    wire                  m0_CRVALID;
    wire [4:0]            m0_CRRESP;
   
    // CD Channe
    wire                  m0_CDREADY;
    wire                  m0_CDVALID;
    wire [DATA_WIDTH-1:0] m0_CDDATA;
    wire                  m0_CDLAST;
   
    // AC Channe
    wire                  m1_ACVALID;
    wire [ADDR_WIDTH-1:0] m1_ACADDR;
    wire [3:0]            m1_ACSNOOP;
    wire [2:0]            m1_ACPROT;
    wire                  m1_ACREADY;
   
    // CR Channe
    wire                  m1_CRREADY;
    wire                  m1_CRVALID;
    wire [4:0]            m1_CRRESP;
   
    // CD Channe
    wire                  m1_CDREADY;
    wire                  m1_CDVALID;
    wire [DATA_WIDTH-1:0] m1_CDDATA;
    wire                  m1_CDLAST;
    
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
    D_cacheA
    (
        // system signals
        .ACLK       (ACLK   ),
        .ARESETn    (ARESETn),
        .ENABLE     (m0_ENABLE    ),
        .CACHE_HIT  (/*m0_D_CACHE_HIT */),
        .CACHE_BUSY (/*m0_D_CACHE_BUSY*/),
        
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
    D_cacheB
    (
        // system signals
        .ACLK       (ACLK   ),
        .ARESETn    (ARESETn),
        .ENABLE     (m1_ENABLE    ),
        .CACHE_HIT  (/*m1_D_CACHE_HIT */),
        .CACHE_BUSY (/*m1_D_CACHE_BUSY*/),
        
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
        
        // I-Cache related signals
        // AXI4
        // AW Channel
        .m2_AWID    (s2_AWID    ),
        .m2_AWADDR  (s2_AWADDR  ),
        .m2_AWLEN   (s2_AWLEN   ),
        .m2_AWSIZE  (s2_AWSIZE  ),
        .m2_AWBURST (s2_AWBURST ),
        .m2_AWLOCK  (s2_AWLOCK  ),
        .m2_AWCACHE (s2_AWCACHE ),
        .m2_AWPROT  (s2_AWPROT  ),
        .m2_AWQOS   (s2_AWQOS   ),
        .m2_AWREGION(s2_AWREGION),
        .m2_AWUSER  (s2_AWUSER  ),
        .m2_AWVALID (s2_AWVALID ),
        .m2_AWREADY (s2_AWREADY ),
        
        // W Channel
        .m2_WDATA   (s2_WDATA ),
        .m2_WSTRB   (s2_WSTRB ), 
        .m2_WLAST   (s2_WLAST ),
        .m2_WUSER   (s2_WUSER ),
        .m2_WVALID  (s2_WVALID),
        .m2_WREADY  (s2_WREADY),
        
        // B Channel
        .m2_BID     (s2_BID   ),
        .m2_BRESP   (s2_BRESP ),
        .m2_BUSER   (s2_BUSER ),
        .m2_BVALID  (s2_BVALID),
        .m2_BREADY  (s2_BREADY),
       
        // AR Channel
        .m2_ARID    (s2_ARID    ),
        .m2_ARADDR  (s2_ARADDR  ),
        .m2_ARLEN   (s2_ARLEN   ),
        .m2_ARSIZE  (s2_ARSIZE  ),
        .m2_ARBURST (s2_ARBURST ),
        .m2_ARLOCK  (s2_ARLOCK  ),
        .m2_ARCACHE (s2_ARCACHE ),
        .m2_ARPROT  (s2_ARPROT  ),
        .m2_ARQOS   (s2_ARQOS   ),
        .m2_ARREGION(s2_ARREGION),
        .m2_ARUSER  (s2_ARUSER  ),
        .m2_ARVALID (s2_ARVALID ),
        .m2_ARREADY (s2_ARREADY ),
        
        // R Channel
        .m2_RID     (s2_RID   ),
        .m2_RDATA   (s2_RDATA ),
        .m2_RRESP   (s2_RRESP ),
        .m2_RLAST   (s2_RLAST ),
        .m2_RUSER   (s2_RUSER ),
        .m2_RVALID  (s2_RVALID),
        .m2_RREADY  (s2_RREADY),
        
        // I-Cache related signals
        // AXI4
        // AW Channel
        .m3_AWID    (s3_AWID    ),
        .m3_AWADDR  (s3_AWADDR  ),
        .m3_AWLEN   (s3_AWLEN   ),
        .m3_AWSIZE  (s3_AWSIZE  ),
        .m3_AWBURST (s3_AWBURST ),
        .m3_AWLOCK  (s3_AWLOCK  ),
        .m3_AWCACHE (s3_AWCACHE ),
        .m3_AWPROT  (s3_AWPROT  ),
        .m3_AWQOS   (s3_AWQOS   ),
        .m3_AWREGION(s3_AWREGION),
        .m3_AWUSER  (s3_AWUSER  ),
        .m3_AWVALID (s3_AWVALID ),
        .m3_AWREADY (s3_AWREADY ),
        
        // W Channel
        .m3_WDATA   (s3_WDATA ),
        .m3_WSTRB   (s3_WSTRB ), 
        .m3_WLAST   (s3_WLAST ),
        .m3_WUSER   (s3_WUSER ),
        .m3_WVALID  (s3_WVALID),
        .m3_WREADY  (s3_WREADY),
        
        // B Channel
        .m3_BID     (s3_BID   ),
        .m3_BRESP   (s3_BRESP ),
        .m3_BUSER   (s3_BUSER ),
        .m3_BVALID  (s3_BVALID),
        .m3_BREADY  (s3_BREADY),
       
        // AR Channel
        .m3_ARID    (s3_ARID    ),
        .m3_ARADDR  (s3_ARADDR  ),
        .m3_ARLEN   (s3_ARLEN   ),
        .m3_ARSIZE  (s3_ARSIZE  ),
        .m3_ARBURST (s3_ARBURST ),
        .m3_ARLOCK  (s3_ARLOCK  ),
        .m3_ARCACHE (s3_ARCACHE ),
        .m3_ARPROT  (s3_ARPROT  ),
        .m3_ARQOS   (s3_ARQOS   ),
        .m3_ARREGION(s3_ARREGION),
        .m3_ARUSER  (s3_ARUSER  ),
        .m3_ARVALID (s3_ARVALID ),
        .m3_ARREADY (s3_ARREADY ),
        
        // R Channel
        .m3_RID     (s3_RID   ),
        .m3_RDATA   (s3_RDATA ),
        .m3_RRESP   (s3_RRESP ),
        .m3_RLAST   (s3_RLAST ),
        .m3_RUSER   (s3_RUSER ),
        .m3_RVALID  (s3_RVALID),
        .m3_RREADY  (s3_RREADY),
    
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
    
    (* keep_hierarchy = "yes" *) memory
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
        
        // to program instruction mem
        .wr_mem_en  (m_wr_mem_en  ),
        .wr_mem_addr(m_wr_mem_addr),
        .wr_mem_data(m_wr_mem_data),
        
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
