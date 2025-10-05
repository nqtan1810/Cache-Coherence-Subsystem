//////////////////////////////////////////////////////////////////////////////////
// this is top module of dual-core cache
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ns

module dual_core_cache
#(
    parameter DATA_WIDTH  = 32,
    parameter ADDR_WIDTH  = 32,
    parameter ID_WIDTH    = 1,
    parameter USER_WIDTH  = 4,
    parameter STRB_WIDTH  = (DATA_WIDTH/8),
    parameter SHAREABLE_REGION_START = 32'h8000_0000, // start address of shareable region
    parameter SHAREABLE_REGION_END   = 32'h8FFF_FFFF  // end address of shareable region
)
(
    // system signals
    input   ACLK,
    input   ARESETn,
    
    // core_0 cache
    input   ENABLE_0,
    output  CACHE_HIT_0,
    output  CACHE_BUSY_0,
    
    // AXI5-Lite Interface (connect with CPU)
    // AW Channel
    input   m_AWVALID_0,
    output  m_AWREADY_0,
    input   [ADDR_WIDTH-1:0] m_AWADDR_0,
    
    // W Channel
    input   m_WVALID_0,
    output  m_WREADY_0,
    input   [DATA_WIDTH-1:0] m_WDATA_0,
    input   [3:0] m_WSTRB_0, // use default value: 0xF
    
    // B Channel
    output  m_BVALID_0,
    input   m_BREADY_0,
    output  [1:0] m_BRESP_0,
    
    // AR Channel
    input   m_ARVALID_0,
    output  m_ARREADY_0,
    input   [ADDR_WIDTH-1:0] m_ARADDR_0,
    
    // R Channel
    output  m_RVALID_0,
    input   m_RREADY_0,
    output  [DATA_WIDTH-1:0] m_RDATA_0,
    output  [1:0] m_RRESP_0,
    
    // AXI5 Interface (connect with Cache L2)
    // AW Channel
    output  s_AWID_0, // use default value: 0x0
    output  [ADDR_WIDTH-1:0] s_AWADDR_0,
    output  [3:0] s_AWLEN_0,
    output  [2:0] s_AWSIZE_0,  // use default value: Data bus width = 32-bit -> AWSIZE = 0x2
    output  [1:0] s_AWBURST_0, // use default value: 0x1_0, INCR   
    output  s_AWVALID_0,
    input   s_AWREADY_0,
    
    // W Channel
    output  s_WID_0,  // use default value: 0x0
    output  [DATA_WIDTH-1:0] s_WDATA_0,
    output  [3:0] s_WSTRB_0,  // use default value: 0xF
    output  s_WLAST_0,
    output  s_WVALID_0,
    input   s_WREADY_0,
    
    // B Channel
    input   s_BID_0,  // use default value: 0x0
    input   [1:0] s_BRESP_0,  
    input   s_BVALID_0,
    output  s_BREADY_0,
    
    // AR Channel
    output  s_ARID_0, // use default value: 0x0
    output  [ADDR_WIDTH-1:0] s_ARADDR_0,
    output  [3:0] s_ARLEN_0,
    output  [2:0] s_ARSIZE_0,  // use default value: Data bus width = 32-bit -> ARSIZE = 0x2
    output  [1:0] s_ARBURST_0, // use default value: 0x1_0, INCR  
    output  s_ARVALID_0,
    input   s_ARREADY_0,
    
    // R Channel
    input   s_RID_0,  // use default value: 0x0
    input   [DATA_WIDTH-1:0] s_RDATA_0,
    input   [1:0] s_RRESP_0,
    input   s_RLAST_0,
    input   s_RVALID_0,
    output  s_RREADY_0,
    
    // core_1 cache
    input   ENABLE_1,
    output  CACHE_HIT_1,
    output  CACHE_BUSY_1,
    
    // AXI5-Lite Interface (connect with CPU)
    // AW Channel
    input   m_AWVALID_1,
    output  m_AWREADY_1,
    input   [ADDR_WIDTH-1:0] m_AWADDR_1,
    
    // W Channel
    input   m_WVALID_1,
    output  m_WREADY_1,
    input   [DATA_WIDTH-1:0] m_WDATA_1,
    input   [3:0] m_WSTRB_1, // use default value: 0xF
    
    // B Channel
    output  m_BVALID_1,
    input   m_BREADY_1,
    output  [1:0] m_BRESP_1,
    
    // AR Channel
    input   m_ARVALID_1,
    output  m_ARREADY_1,
    input   [ADDR_WIDTH-1:0] m_ARADDR_1,
    
    // R Channel
    output  m_RVALID_1,
    input   m_RREADY_1,
    output  [DATA_WIDTH-1:0] m_RDATA_1,
    output  [1:0] m_RRESP_1,
    
    // AXI5 Interface (connect with Cache L2)
    // AW Channel
    output  s_AWID_1, // use default value: 0x0
    output  [ADDR_WIDTH-1:0] s_AWADDR_1,
    output  [3:0] s_AWLEN_1,
    output  [2:0] s_AWSIZE_1,  // use default value: Data bus width = 32-bit -> AWSIZE = 0x2
    output  [1:0] s_AWBURST_1, // use default value: 0x1_1, INCR   
    output  s_AWVALID_1,
    input   s_AWREADY_1,
    
    // W Channel
    output  s_WID_1,  // use default value: 0x0
    output  [DATA_WIDTH-1:0] s_WDATA_1,
    output  [3:0] s_WSTRB_1,  // use default value: 0xF
    output  s_WLAST_1,
    output  s_WVALID_1,
    input   s_WREADY_1,
    
    // B Channel
    input   s_BID_1,  // use default value: 0x0
    input   [1:0] s_BRESP_1,  
    input   s_BVALID_1,
    output  s_BREADY_1,
    
    // AR Channel
    output  s_ARID_1, // use default value: 0x0
    output  [ADDR_WIDTH-1:0] s_ARADDR_1,
    output  [3:0] s_ARLEN_1,
    output  [2:0] s_ARSIZE_1,  // use default value: Data bus width = 32-bit -> ARSIZE = 0x2
    output  [1:0] s_ARBURST_1, // use default value: 0x1_1, INCR  
    output  s_ARVALID_1,
    input   s_ARREADY_1,
    
    // R Channel
    input   s_RID_1,  // use default value: 0x0
    input   [DATA_WIDTH-1:0] s_RDATA_1,
    input   [1:0] s_RRESP_1,
    input   s_RLAST_1,
    input   s_RVALID_1,
    output  s_RREADY_1
);
    
    // Custom Interface (connect with other Cache L1)
    // Snoop Request Channel
    // send request to other Cache L1
    wire m_ACVALID;
    wire m_ACREADY;
    wire [ADDR_WIDTH-1:0] m_ACADDR;
    wire [1:0] m_ACSNOOP;
    // receive response from other Cache L1
    wire m_CVALID;
    wire m_CREADY;
    wire [DATA_WIDTH-1:0] m_CDATA;
    wire m_CLAST;
    wire m_CHIT;
    
    // Snoop Response Channel
    // receive request from other Cache L1
    wire s_ACVALID;
    wire s_ACREADY;
    wire [ADDR_WIDTH-1:0] s_ACADDR;
    wire [1:0] s_ACSNOOP;
    // send response to other Cache L1
    wire s_CVALID;
    wire s_CREADY;
    wire [DATA_WIDTH-1:0] s_CDATA;
    wire s_CLAST;
    wire s_CHIT;
    
    // for demo to fix E-E bug
    // wire is_E_E;
    // assign is_E_E = s_ARADDR_0[31:6] == s_ARADDR_1[31:6];
    wire is_R_R;
    reg  [ADDR_WIDTH-1-6:0] m_ARADDR_0_reg;
    reg  [ADDR_WIDTH-1-6:0] m_ARADDR_1_reg;
    
    always @(posedge ACLK) begin
        if (ARESETn) begin
            m_ARADDR_0_reg <= 0;
            m_ARADDR_1_reg <= 0;
        end
        else begin
            if (m_ARVALID_0) begin
                m_ARADDR_0_reg <= m_ARADDR_0[31:6];
            end
            if (m_ARVALID_1) begin
                m_ARADDR_1_reg <= m_ARADDR_1[31:6];
            end
        end
    end
    
    assign is_R_R = (CACHE_BUSY_0 && CACHE_BUSY_1 && !(m_ARADDR_0_reg ^ m_ARADDR_1_reg)) ? 1 : 0;
    ///////////////////////////////////
    
    single_core_cache core_0_cache
    (
        // system signals
        .ACLK(ACLK),
        .ARESETn(ARESETn),
        .ENABLE(ENABLE_0),
        .CACHE_HIT(CACHE_HIT_0),
        .CACHE_BUSY(CACHE_BUSY_0),
        
        // AXI5-Lite Interface (connect with CPU)
        // AW Channel
        .m_AWVALID(m_AWVALID_0),
        .m_AWREADY(m_AWREADY_0),
        .m_AWADDR(m_AWADDR_0),
        
        // W Channel
        .m_WVALID(m_WVALID_0),
        .m_WREADY(m_WREADY_0),
        .m_WDATA(m_WDATA_0),
        .m_WSTRB(m_WSTRB_0), // use default value: 0xF
        
        // B Channel
        .m_BVALID(m_BVALID_0),
        .m_BREADY(m_BREADY_0),
        .m_BRESP(m_BRESP_0),
        
        // AR Channel
        .m_ARVALID(m_ARVALID_0),
        .m_ARREADY(m_ARREADY_0),
        .m_ARADDR(m_ARADDR_0),
        
        // R Channel
        .m_RVALID(m_RVALID_0),
        .m_RREADY(m_RREADY_0),
        .m_RDATA(m_RDATA_0),
        .m_RRESP(m_RRESP_0),
        
        // AXI5 Interface (connect with Cache L2)
        // AW Channel
        .s_AWID(s_AWID_0), // use default value: 0x0
        .s_AWADDR(s_AWADDR_0),
        .s_AWLEN(s_AWLEN_0),
        .s_AWSIZE(s_AWSIZE_0),  // use default value: Data bus width = 32-bit -> AWSIZE = 0x2
        .s_AWBURST(s_AWBURST_0), // use default value: 0x1(), INCR   
        .s_AWVALID(s_AWVALID_0),
        .s_AWREADY(s_AWREADY_0),
        
        // W Channel
        .s_WID(s_WID_0),  // use default value: 0x0
        .s_WDATA(s_WDATA_0),
        .s_WSTRB(s_WSTRB_0),  // use default value: 0xF
        .s_WLAST(s_WLAST_0),
        .s_WVALID(s_WVALID_0),
        .s_WREADY(s_WREADY_0),
        
        // B Channel
        .s_BID(s_BID_0),  // use default value: 0x0
        .s_BRESP(s_BRESP_0),  
        .s_BVALID(s_BVALID_0),
        .s_BREADY(s_BREADY_0),
        
        // AR Channel
        .s_ARID(s_ARID_0), // use default value: 0x0
        .s_ARADDR(s_ARADDR_0),
        .s_ARLEN(s_ARLEN_0),
        .s_ARSIZE(s_ARSIZE_0),  // use default value: Data bus width = 32-bit -> ARSIZE = 0x2
        .s_ARBURST(s_ARBURST_0), // use default value: 0x1(), INCR  
        .s_ARVALID(s_ARVALID_0),
        .s_ARREADY(s_ARREADY_0),
        
        // R Channel
        .s_RID(s_RID_0),  // use default value: 0x0
        .s_RDATA(s_RDATA_0),
        .s_RRESP(s_RRESP_0),
        .s_RLAST(s_RLAST_0),
        .s_RVALID(s_RVALID_0),
        .s_RREADY(s_RREADY_0),
        
        // Custom Interface (connect with other Cache L1)
        // Snoop Request Channel
        // send request to other Cache L1
        .m_ACVALID(m_ACVALID),
        .m_ACREADY(m_ACREADY),
        .m_ACADDR(m_ACADDR),
        .m_ACSNOOP(m_ACSNOOP),
        // receive response from other Cache L1
        .m_CVALID(m_CVALID),
        .m_CREADY(m_CREADY),
        .m_CDATA(m_CDATA),
        .m_CLAST(m_CLAST),
        .m_CHIT(m_CHIT),
        
        // Snoop Response Channel
        // receive request from other Cache L1
        .s_ACVALID(s_ACVALID),
        .s_ACREADY(s_ACREADY),
        .s_ACADDR(s_ACADDR),
        .s_ACSNOOP(s_ACSNOOP),
        // send response to other Cache L1
        .s_CVALID(s_CVALID),
        .s_CREADY(s_CREADY),
        .s_CDATA(s_CDATA),
        .s_CLAST(s_CLAST),
        .s_CHIT(s_CHIT),
        
        .is_R_R(is_R_R)
    );
    
    single_core_cache core_1_cache
    (
        // system signals
        .ACLK(ACLK),
        .ARESETn(ARESETn),
        .ENABLE(ENABLE_1),
        .CACHE_HIT(CACHE_HIT_1),
        .CACHE_BUSY(CACHE_BUSY_1),
        
        // AXI5-Lite Interface (connect with CPU)
        // AW Channel
        .m_AWVALID(m_AWVALID_1),
        .m_AWREADY(m_AWREADY_1),
        .m_AWADDR(m_AWADDR_1),
        
        // W Channel
        .m_WVALID(m_WVALID_1),
        .m_WREADY(m_WREADY_1),
        .m_WDATA(m_WDATA_1),
        .m_WSTRB(m_WSTRB_1), // use default value: 0xF
        
        // B Channel
        .m_BVALID(m_BVALID_1),
        .m_BREADY(m_BREADY_1),
        .m_BRESP(m_BRESP_1),
        
        // AR Channel
        .m_ARVALID(m_ARVALID_1),
        .m_ARREADY(m_ARREADY_1),
        .m_ARADDR(m_ARADDR_1),
        
        // R Channel
        .m_RVALID(m_RVALID_1),
        .m_RREADY(m_RREADY_1),
        .m_RDATA(m_RDATA_1),
        .m_RRESP(m_RRESP_1),
        
        // AXI5 Interface (connect with Cache L2)
        // AW Channel
        .s_AWID(s_AWID_1), // use default value: 0x0
        .s_AWADDR(s_AWADDR_1),
        .s_AWLEN(s_AWLEN_1),
        .s_AWSIZE(s_AWSIZE_1),  // use default value: Data bus width = 32-bit -> AWSIZE = 0x2
        .s_AWBURST(s_AWBURST_1), // use default value: 0x1(), INCR   
        .s_AWVALID(s_AWVALID_1),
        .s_AWREADY(s_AWREADY_1),
        
        // W Channel
        .s_WID(s_WID_1),  // use default value: 0x0
        .s_WDATA(s_WDATA_1),
        .s_WSTRB(s_WSTRB_1),  // use default value: 0xF
        .s_WLAST(s_WLAST_1),
        .s_WVALID(s_WVALID_1),
        .s_WREADY(s_WREADY_1),
        
        // B Channel
        .s_BID(s_BID_1),  // use default value: 0x0
        .s_BRESP(s_BRESP_1),  
        .s_BVALID(s_BVALID_1),
        .s_BREADY(s_BREADY_1),
        
        // AR Channel
        .s_ARID(s_ARID_1), // use default value: 0x0
        .s_ARADDR(s_ARADDR_1),
        .s_ARLEN(s_ARLEN_1),
        .s_ARSIZE(s_ARSIZE_1),  // use default value: Data bus width = 32-bit -> ARSIZE = 0x2
        .s_ARBURST(s_ARBURST_1), // use default value: 0x1(), INCR  
        .s_ARVALID(s_ARVALID_1),
        .s_ARREADY(s_ARREADY_1),
        
        // R Channel
        .s_RID(s_RID_1),  // use default value: 0x0
        .s_RDATA(s_RDATA_1),
        .s_RRESP(s_RRESP_1),
        .s_RLAST(s_RLAST_1),
        .s_RVALID(s_RVALID_1),
        .s_RREADY(s_RREADY_1),
        
        // Custom Interface (connect with other Cache L1)
        // Snoop Request Channel
        // send request to other Cache L1
        .m_ACVALID(s_ACVALID),
        .m_ACREADY(s_ACREADY),
        .m_ACADDR(s_ACADDR),
        .m_ACSNOOP(s_ACSNOOP),
        // receive response from other Cache L1
        .m_CVALID(s_CVALID),
        .m_CREADY(s_CREADY),
        .m_CDATA(s_CDATA),
        .m_CLAST(s_CLAST),
        .m_CHIT(s_CHIT),
        
        // Snoop Response Channel
        // receive request from other Cache L1
        .s_ACVALID(m_ACVALID),
        .s_ACREADY(m_ACREADY),
        .s_ACADDR(m_ACADDR),
        .s_ACSNOOP(m_ACSNOOP),
        // send response to other Cache L1
        .s_CVALID(m_CVALID),
        .s_CREADY(m_CREADY),
        .s_CDATA(m_CDATA),
        .s_CLAST(m_CLAST),
        .s_CHIT(m_CHIT),
        
        .is_R_R(is_R_R)
    );
    
endmodule
