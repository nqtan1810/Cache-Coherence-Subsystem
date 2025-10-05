//=============================================================================
// This is an AXI Interconnect support two Master and one Slave
//=============================================================================

`timescale 1ns/1ns

module AXI_Interconnect
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
    /********** Master 0 **********/
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
    input                       m0_ARVALID,
    output                      m0_ARREADY,
    // R Channel
    output     [ID_WIDTH-1:0]   m0_RID,
	output     [DATA_WIDTH-1:0] m0_RDATA,
	output     [1:0]	        m0_RRESP,
    output                      m0_RLAST,
	output     [USER_WIDTH-1:0]	m0_RUSER,
	output                      m0_RVALID,
    input                       m0_RREADY,
    /********** Master 1 **********/
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
    input                       m1_ARVALID,
    output                      m1_ARREADY,
    // R Channel
    output     [ID_WIDTH-1:0]   m1_RID,
	output     [DATA_WIDTH-1:0] m1_RDATA,
	output     [1:0]	        m1_RRESP,
    output                      m1_RLAST,
	output     [USER_WIDTH-1:0]	m1_RUSER,
	output                      m1_RVALID,
    input                       m1_RREADY,
    
    /********** Master 2 **********/
    // AW Channel
	input      [ID_WIDTH-1:0]   m2_AWID,
    input	   [ADDR_WIDTH-1:0] m2_AWADDR,
    input      [7:0]            m2_AWLEN,
    input      [2:0]            m2_AWSIZE,
    input      [1:0]            m2_AWBURST,
    input                       m2_AWLOCK,
    input      [3:0]            m2_AWCACHE,
    input      [2:0]            m2_AWPROT,
    input      [3:0]            m2_AWQOS,
    input      [3:0]            m2_AWREGION,
    input      [USER_WIDTH-1:0] m2_AWUSER,
    input                       m2_AWVALID,
    output                      m2_AWREADY,
    // W Channel
    // input      [ID_WIDTH-1:0]   m2_WID,
    input      [DATA_WIDTH-1:0] m2_WDATA,
    input      [STRB_WIDTH-1:0] m2_WSTRB,
    input                       m2_WLAST,
    input      [USER_WIDTH-1:0] m2_WUSER,
    input                       m2_WVALID,
    output                      m2_WREADY,
    // B Channel
    output     [ID_WIDTH-1:0]	m2_BID,
	output     [1:0]	        m2_BRESP,
	output     [USER_WIDTH-1:0] m2_BUSER,
	output                      m2_BVALID,
    input                       m2_BREADY,
    // AR Channel
    input      [ID_WIDTH-1:0]   m2_ARID,
    input      [ADDR_WIDTH-1:0] m2_ARADDR,
    input      [7:0]            m2_ARLEN,
    input      [2:0]            m2_ARSIZE,
    input      [1:0]            m2_ARBURST,
    input                       m2_ARLOCK,
    input      [3:0]            m2_ARCACHE,
    input      [2:0]            m2_ARPROT,
    input      [3:0]            m2_ARQOS,
    input      [3:0]            m2_ARREGION,
    input      [USER_WIDTH-1:0] m2_ARUSER,
    input                       m2_ARVALID,
    output                      m2_ARREADY,
    // R Channel
    output     [ID_WIDTH-1:0]   m2_RID,
	output     [DATA_WIDTH-1:0] m2_RDATA,
	output     [1:0]	        m2_RRESP,
    output                      m2_RLAST,
	output     [USER_WIDTH-1:0]	m2_RUSER,
	output                      m2_RVALID,
    input                       m2_RREADY,
    /********** Master 3 **********/
    // AW Channel
    input      [ID_WIDTH-1:0]   m3_AWID,
    input	   [ADDR_WIDTH-1:0]	m3_AWADDR,
    input      [7:0]            m3_AWLEN,
    input      [2:0]            m3_AWSIZE,
    input      [1:0]            m3_AWBURST,
    input                       m3_AWLOCK,
    input      [3:0]            m3_AWCACHE,
    input      [2:0]            m3_AWPROT,
    input      [3:0]            m3_AWQOS,
    input      [3:0]            m3_AWREGION,
    input      [USER_WIDTH-1:0] m3_AWUSER,
    input                       m3_AWVALID,
    output                      m3_AWREADY,
    // W Channel
    // input      [ID_WIDTH-1:0]   m3_WID,
    input      [DATA_WIDTH-1:0] m3_WDATA,
    input      [STRB_WIDTH-1:0] m3_WSTRB,
    input                       m3_WLAST,
    input      [USER_WIDTH-1:0] m3_WUSER,
    input                       m3_WVALID,
    output                      m3_WREADY,
    // B Channel
    output     [ID_WIDTH-1:0]	m3_BID,
	output     [1:0]	        m3_BRESP,
	output     [USER_WIDTH-1:0] m3_BUSER,
	output                      m3_BVALID,
    input                       m3_BREADY,
    // AR Channel
    input      [ID_WIDTH-1:0]   m3_ARID,
    input      [ADDR_WIDTH-1:0] m3_ARADDR,
    input      [7:0]            m3_ARLEN,
    input      [2:0]            m3_ARSIZE,
    input      [1:0]            m3_ARBURST,
    input                       m3_ARLOCK,
    input      [3:0]            m3_ARCACHE,
    input      [2:0]            m3_ARPROT,
    input      [3:0]            m3_ARQOS,
    input      [3:0]            m3_ARREGION,
    input      [USER_WIDTH-1:0] m3_ARUSER,
    input                       m3_ARVALID,
    output                      m3_ARREADY,
    // R Channel
    output     [ID_WIDTH-1:0]   m3_RID,
	output     [DATA_WIDTH-1:0] m3_RDATA,
	output     [1:0]	        m3_RRESP,
    output                      m3_RLAST,
	output     [USER_WIDTH-1:0]	m3_RUSER,
	output                      m3_RVALID,
    input                       m3_RREADY,

    /********** Slave **********/
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


    //=========================================================
    wire  m0_wgrnt_w;
    wire  m1_wgrnt_w;
    wire  m2_wgrnt_w;
    wire  m3_wgrnt_w;
    
    wire  m0_wgrnt_r;
    wire  m1_wgrnt_r;
    wire  m2_wgrnt_r;
    wire  m3_wgrnt_r;

    //=========================================================
    AXI_Arbiter_W u_AXI_Arbiter_W(
        /********* System signals *********/
        .ACLK(ACLK),
        .ARESETn(ARESETn),
        /********** Master 0 **********/
        .m0_AWVALID(m0_AWVALID),
        .m0_WVALID(m0_WVALID),
        .m0_BREADY(m0_BREADY),
        /********** Master 1 **********/
        .m1_AWVALID(m1_AWVALID),
        .m1_WVALID(m1_WVALID),
        .m1_BREADY(m1_BREADY),
        /********** Master 2 **********/
        .m2_AWVALID(m2_AWVALID),
        .m2_WVALID(m2_WVALID),
        .m2_BREADY(m2_BREADY),
        /********** Master 3 **********/
        .m3_AWVALID(m3_AWVALID),
        .m3_WVALID(m3_WVALID),
        .m3_BREADY(m3_BREADY),
        /********** Slave **********/
        .s_AWREADY(s_AWREADY),
        .s_WREADY(s_WREADY),
        .s_BVALID(s_BVALID),
        
        .m0_wgrnt(m0_wgrnt_w),
        .m1_wgrnt(m1_wgrnt_w),
        .m2_wgrnt(m2_wgrnt_w),
        .m3_wgrnt(m3_wgrnt_w)
    );

    //=========================================================
    AXI_Arbiter_R u_AXI_Arbiter_R(
        /********* System signals *********/
        .ACLK(ACLK),
        .ARESETn(ARESETn),
        /********** Master 0 **********/
        .m0_ARVALID(m0_ARVALID),
        .m0_RREADY(m0_RREADY),
        /********** Master 1 **********/
        .m1_ARVALID(m1_ARVALID),
        .m1_RREADY(m1_RREADY),
        /********** Master 2 **********/
        .m2_ARVALID(m2_ARVALID),
        .m2_RREADY(m2_RREADY),
        /********** Master 3 **********/
        .m3_ARVALID(m3_ARVALID),
        .m3_RREADY(m3_RREADY),
        /********** Slave **********/
        .s_RVALID(s_RVALID),
        .s_RLAST(s_RLAST),
        
        .m0_rgrnt(m0_wgrnt_r),
        .m1_rgrnt(m1_wgrnt_r),
        .m2_rgrnt(m2_wgrnt_r),
        .m3_rgrnt(m3_wgrnt_r)
    );

    //=========================================================
    AXI_Master_Mux_W #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH),
        .ID_WIDTH(ID_WIDTH),
        .USER_WIDTH(USER_WIDTH),
        .STRB_WIDTH(STRB_WIDTH)
    )u_AXI_Master_Mux_W(
        /********** Master 0 **********/
        // AW Channel
        .m0_AWID(m0_AWID),
        .m0_AWADDR(m0_AWADDR),
        .m0_AWLEN(m0_AWLEN),
        .m0_AWSIZE(m0_AWSIZE),
        .m0_AWBURST(m0_AWBURST),
        .m0_AWLOCK(m0_AWLOCK),
        .m0_AWCACHE(m0_AWCACHE),
        .m0_AWPROT(m0_AWPROT),
        .m0_AWQOS(m0_AWQOS),
        .m0_AWREGION(m0_AWREGION),
        .m0_AWUSER(m0_AWUSER),
        .m0_AWVALID(m0_AWVALID),
        .m0_AWREADY(m0_AWREADY),
        // W Channel
        // .m0_WID(m0_WID),
        .m0_WDATA(m0_WDATA),
        .m0_WSTRB(m0_WSTRB),
        .m0_WLAST(m0_WLAST),
        .m0_WUSER(m0_WUSER),
        .m0_WVALID(m0_WVALID),
        .m0_WREADY(m0_WREADY),
        // B Channel
        .m0_BID(m0_BID),
        .m0_BRESP(m0_BRESP),
        .m0_BUSER(m0_BUSER),
        .m0_BVALID(m0_BVALID),
        .m0_BREADY(m0_BREADY),
        /********** Master 1 **********/
        // AW Channel
        .m1_AWID(m1_AWID),
        .m1_AWADDR(m1_AWADDR),
        .m1_AWLEN(m1_AWLEN),
        .m1_AWSIZE(m1_AWSIZE),
        .m1_AWBURST(m1_AWBURST),
        .m1_AWLOCK(m1_AWLOCK),
        .m1_AWCACHE(m1_AWCACHE),
        .m1_AWPROT(m1_AWPROT),
        .m1_AWQOS(m1_AWQOS),
        .m1_AWREGION(m1_AWREGION),
        .m1_AWUSER(m1_AWUSER),
        .m1_AWVALID(m1_AWVALID),
        .m1_AWREADY(m1_AWREADY),
        // W Channel
        // .m1_WID(m1_WID),
        .m1_WDATA(m1_WDATA),
        .m1_WSTRB(m1_WSTRB),
        .m1_WLAST(m1_WLAST),
        .m1_WUSER(m1_WUSER),
        .m1_WVALID(m1_WVALID),
        .m1_WREADY(m1_WREADY),
        // B Channel
        .m1_BID(m1_BID),
        .m1_BRESP(m1_BRESP),
        .m1_BUSER(m1_BUSER),
        .m1_BVALID(m1_BVALID),
        .m1_BREADY(m1_BREADY),
        /********** Master 2 **********/
        // AW Channel
        .m2_AWID(m2_AWID),
        .m2_AWADDR(m2_AWADDR),
        .m2_AWLEN(m2_AWLEN),
        .m2_AWSIZE(m2_AWSIZE),
        .m2_AWBURST(m2_AWBURST),
        .m2_AWLOCK(m2_AWLOCK),
        .m2_AWCACHE(m2_AWCACHE),
        .m2_AWPROT(m2_AWPROT),
        .m2_AWQOS(m2_AWQOS),
        .m2_AWREGION(m2_AWREGION),
        .m2_AWUSER(m2_AWUSER),
        .m2_AWVALID(m2_AWVALID),
        .m2_AWREADY(m2_AWREADY),
        // W Channel
        // .m2_WID(m2_WID),
        .m2_WDATA(m2_WDATA),
        .m2_WSTRB(m2_WSTRB),
        .m2_WLAST(m2_WLAST),
        .m2_WUSER(m2_WUSER),
        .m2_WVALID(m2_WVALID),
        .m2_WREADY(m2_WREADY),
        // B Channel
        .m2_BID(m2_BID),
        .m2_BRESP(m2_BRESP),
        .m2_BUSER(m2_BUSER),
        .m2_BVALID(m2_BVALID),
        .m2_BREADY(m2_BREADY),
        /********** Master 3 **********/
        // AW Channel
        .m3_AWID(m3_AWID),
        .m3_AWADDR(m3_AWADDR),
        .m3_AWLEN(m3_AWLEN),
        .m3_AWSIZE(m3_AWSIZE),
        .m3_AWBURST(m3_AWBURST),
        .m3_AWLOCK(m3_AWLOCK),
        .m3_AWCACHE(m3_AWCACHE),
        .m3_AWPROT(m3_AWPROT),
        .m3_AWQOS(m3_AWQOS),
        .m3_AWREGION(m3_AWREGION),
        .m3_AWUSER(m3_AWUSER),
        .m3_AWVALID(m3_AWVALID),
        .m3_AWREADY(m3_AWREADY),
        // W Channel
        // .m3_WID(m3_WID),
        .m3_WDATA(m3_WDATA),
        .m3_WSTRB(m3_WSTRB),
        .m3_WLAST(m3_WLAST),
        .m3_WUSER(m3_WUSER),
        .m3_WVALID(m3_WVALID),
        .m3_WREADY(m3_WREADY),
        // B Channel
        .m3_BID(m3_BID),
        .m3_BRESP(m3_BRESP),
        .m3_BUSER(m3_BUSER),
        .m3_BVALID(m3_BVALID),
        .m3_BREADY(m3_BREADY),
        /******** Slave ********/
        // AW Channel
        .s_AWID(s_AWID),
        .s_AWADDR(s_AWADDR),
        .s_AWLEN(s_AWLEN),
        .s_AWSIZE(s_AWSIZE),
        .s_AWBURST(s_AWBURST),
        .s_AWLOCK(s_AWLOCK),
        .s_AWCACHE(s_AWCACHE),
        .s_AWPROT(s_AWPROT),
        .s_AWQOS(s_AWQOS),
        .s_AWREGION(s_AWREGION),
        .s_AWUSER(s_AWUSER),
        .s_AWVALID(s_AWVALID),
        .s_AWREADY(s_AWREADY),
        // W Channel
        // .s_WID(s_WID),
        .s_WDATA(s_WDATA),
        .s_WSTRB(s_WSTRB),
        .s_WLAST(s_WLAST),
        .s_WUSER(s_WUSER),
        .s_WVALID(s_WVALID),
        .s_WREADY(s_WREADY),
        // B Channel
        .s_BID(s_BID),
        .s_BRESP(s_BRESP),
        .s_BUSER(s_BUSER),
        .s_BVALID(s_BVALID),
        .s_BREADY(s_BREADY),
        
        /******** input from Arbiter ********/
        .m0_wgrnt(m0_wgrnt_w),
        .m1_wgrnt(m1_wgrnt_w),
        .m2_wgrnt(m2_wgrnt_w),
        .m3_wgrnt(m3_wgrnt_w)
    );

    //=========================================================
    AXI_Master_Mux_R #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH),
        .ID_WIDTH(ID_WIDTH),
        .USER_WIDTH(USER_WIDTH)
    )u_AXI_Master_Mux_R(
        /********** Master 0 **********/
        // AR Channel
        .m0_ARID(m0_ARID),
        .m0_ARADDR(m0_ARADDR),
        .m0_ARLEN(m0_ARLEN),
        .m0_ARSIZE(m0_ARSIZE),
        .m0_ARBURST(m0_ARBURST),
        .m0_ARLOCK(m0_ARLOCK),
        .m0_ARCACHE(m0_ARCACHE),
        .m0_ARPROT(m0_ARPROT),
        .m0_ARQOS(m0_ARQOS),
        .m0_ARREGION(m0_ARREGION),
        .m0_ARUSER(m0_ARUSER),
        .m0_ARVALID(m0_ARVALID),
        .m0_ARREADY(m0_ARREADY),
        // R Channel
        .m0_RID(m0_RID),
        .m0_RDATA(m0_RDATA),
        .m0_RRESP(m0_RRESP),
        .m0_RLAST(m0_RLAST),
        .m0_RUSER(m0_RUSER),
        .m0_RVALID(m0_RVALID),
        .m0_RREADY(m0_RREADY),
        /********** Master 1 **********/
        // AR Channel
        .m1_ARID(m1_ARID),
        .m1_ARADDR(m1_ARADDR),
        .m1_ARLEN(m1_ARLEN),
        .m1_ARSIZE(m1_ARSIZE),
        .m1_ARBURST(m1_ARBURST),
        .m1_ARLOCK(m1_ARLOCK),
        .m1_ARCACHE(m1_ARCACHE),
        .m1_ARPROT(m1_ARPROT),
        .m1_ARQOS(m1_ARQOS),
        .m1_ARREGION(m1_ARREGION),
        .m1_ARUSER(m1_ARUSER),
        .m1_ARVALID(m1_ARVALID),
        .m1_ARREADY(m1_ARREADY),
        // R Channel
        .m1_RID(m1_RID),
        .m1_RDATA(m1_RDATA),
        .m1_RRESP(m1_RRESP),
        .m1_RLAST(m1_RLAST),
        .m1_RUSER(m1_RUSER),
        .m1_RVALID(m1_RVALID),
        .m1_RREADY(m1_RREADY),
        /********** Master 2 **********/
        // AR Channel
        .m2_ARID(m2_ARID),
        .m2_ARADDR(m2_ARADDR),
        .m2_ARLEN(m2_ARLEN),
        .m2_ARSIZE(m2_ARSIZE),
        .m2_ARBURST(m2_ARBURST),
        .m2_ARLOCK(m2_ARLOCK),
        .m2_ARCACHE(m2_ARCACHE),
        .m2_ARPROT(m2_ARPROT),
        .m2_ARQOS(m2_ARQOS),
        .m2_ARREGION(m2_ARREGION),
        .m2_ARUSER(m2_ARUSER),
        .m2_ARVALID(m2_ARVALID),
        .m2_ARREADY(m2_ARREADY),
        // R Channel
        .m2_RID(m2_RID),
        .m2_RDATA(m2_RDATA),
        .m2_RRESP(m2_RRESP),
        .m2_RLAST(m2_RLAST),
        .m2_RUSER(m2_RUSER),
        .m2_RVALID(m2_RVALID),
        .m2_RREADY(m2_RREADY),
        /********** Master 3 **********/
        // AR Channel
        .m3_ARID(m3_ARID),
        .m3_ARADDR(m3_ARADDR),
        .m3_ARLEN(m3_ARLEN),
        .m3_ARSIZE(m3_ARSIZE),
        .m3_ARBURST(m3_ARBURST),
        .m3_ARLOCK(m3_ARLOCK),
        .m3_ARCACHE(m3_ARCACHE),
        .m3_ARPROT(m3_ARPROT),
        .m3_ARQOS(m3_ARQOS),
        .m3_ARREGION(m3_ARREGION),
        .m3_ARUSER(m3_ARUSER),
        .m3_ARVALID(m3_ARVALID),
        .m3_ARREADY(m3_ARREADY),
        // R Channel
        .m3_RID(m3_RID),
        .m3_RDATA(m3_RDATA),
        .m3_RRESP(m3_RRESP),
        .m3_RLAST(m3_RLAST),
        .m3_RUSER(m3_RUSER),
        .m3_RVALID(m3_RVALID),
        .m3_RREADY(m3_RREADY),
        /******** Slave ********/
        // AR Channel
        .s_ARID(s_ARID),
        .s_ARADDR(s_ARADDR),
        .s_ARLEN(s_ARLEN),
        .s_ARSIZE(s_ARSIZE),
        .s_ARBURST(s_ARBURST),
        .s_ARLOCK(s_ARLOCK),
        .s_ARCACHE(s_ARCACHE),
        .s_ARPROT(s_ARPROT),
        .s_ARQOS(s_ARQOS),
        .s_ARREGION(s_ARREGION),
        .s_ARUSER(s_ARUSER),
        .s_ARVALID(s_ARVALID),
        .s_ARREADY(s_ARREADY),
        // R Channel
        .s_RID(s_RID),
        .s_RDATA(s_RDATA),
        .s_RRESP(s_RRESP),
        .s_RLAST(s_RLAST),
        .s_RUSER(s_RUSER),
        .s_RVALID(s_RVALID),
        .s_RREADY(s_RREADY),
        
        /******** input from Arbiter ********/
        .m0_rgrnt(m0_wgrnt_r),
        .m1_rgrnt(m1_wgrnt_r),
        .m2_rgrnt(m2_wgrnt_r),
        .m3_rgrnt(m3_wgrnt_r)
    );
    
endmodule