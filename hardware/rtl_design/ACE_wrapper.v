`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// this is wrapper of ACE_Interconnect designed for synthesis purpose only
//////////////////////////////////////////////////////////////////////////////////


module ACE_wrapper
#(
    parameter DATA_WIDTH  = 32,
    parameter ADDR_WIDTH  = 32,
    parameter ID_WIDTH    = 2,
    parameter USER_WIDTH  = 4,
    parameter STRB_WIDTH  = (DATA_WIDTH/8)
)
(
/********* System signals *********/
	input            ACLK,
	input      	     ARESETn,
	
/**********************************/
    input  [127:0]   m0_IN,
    output [127:0]   m0_OUT,
  
    input  [127:0]   m1_IN,
    output [127:0]   m1_OUT,
  
    input  [127:0]   m2_IN,
    output [63:0]   m2_OUT,
  
    input  [127:0]   m3_IN,
    output [63:0]   m3_OUT,
 
    output [127:0]   s_OUT
);

    // **************** D-CacheA ******************
    // AW Channel
	wire [ID_WIDTH-1:0]   m0_AWID;
    wire [ADDR_WIDTH-1:0] m0_AWADDR;
    wire [7:0]            m0_AWLEN;
    wire [2:0]            m0_AWSIZE;
    wire [1:0]            m0_AWBURST;
    wire                  m0_AWLOCK;
    wire [3:0]            m0_AWCACHE;
    wire [2:0]            m0_AWPROT;
    wire [3:0]            m0_AWQOS;
    wire [3:0]            m0_AWREGION;
    wire [USER_WIDTH-1:0] m0_AWUSER;
    wire [1:0]            m0_AWDOMAIN;
    wire [2:0]            m0_AWSNOOP;
    wire                  m0_AWVALID;
    wire                  m0_AWREADY;
    // W Channel
    wire [DATA_WIDTH-1:0] m0_WDATA;
    wire [STRB_WIDTH-1:0] m0_WSTRB;
    wire                  m0_WLAST;
    wire [USER_WIDTH-1:0] m0_WUSER;
    wire                  m0_WVALID;
    wire                  m0_WREADY;
    // B Channel
    wire [ID_WIDTH-1:0]	  m0_BID;
	wire [1:0]	          m0_BRESP;
	wire [USER_WIDTH-1:0] m0_BUSER;
	wire                  m0_BVALID;
    wire                  m0_BREADY;
    // AR Channel
    wire [ID_WIDTH-1:0]   m0_ARID;
    wire [ADDR_WIDTH-1:0] m0_ARADDR;
    wire [7:0]            m0_ARLEN;
    wire [2:0]            m0_ARSIZE;
    wire [1:0]            m0_ARBURST;
    wire                  m0_ARLOCK;
    wire [3:0]            m0_ARCACHE;
    wire [2:0]            m0_ARPROT;
    wire [3:0]            m0_ARQOS;
    wire [3:0]            m0_ARREGION;
    wire [USER_WIDTH-1:0] m0_ARUSER;
    wire [1:0]            m0_ARDOMAIN;
    wire [3:0]            m0_ARSNOOP;
    wire                  m0_ARVALID;
    wire                  m0_ARREADY;
    // R Channel
    wire [ID_WIDTH-1:0]   m0_RID;
	wire [DATA_WIDTH-1:0] m0_RDATA;
	wire [3:0]	          m0_RRESP;
    wire                  m0_RLAST;
	wire [USER_WIDTH-1:0] m0_RUSER;
	wire                  m0_RVALID;
    wire                  m0_RREADY;
    // Snoop Channels
    // AC Channel
    wire                  m0_ACVALID;
    wire [ADDR_WIDTH-1:0] m0_ACADDR;
    wire [3:0]            m0_ACSNOOP;
    wire [2:0]            m0_ACPROT;
    wire                  m0_ACREADY;
    // CR Channel
    wire                  m0_CRREADY;
    wire                  m0_CRVALID;
    wire [4:0]            m0_CRRESP;
    // CD Channel
    wire                  m0_CDREADY;
    wire                  m0_CDVALID;
    wire [DATA_WIDTH-1:0] m0_CDDATA;
    wire                  m0_CDLAST;
    
    // **************** D-CacheB ******************
    // AW Channel
	wire [ID_WIDTH-1:0]   m1_AWID;
    wire [ADDR_WIDTH-1:0] m1_AWADDR;
    wire [7:0]            m1_AWLEN;
    wire [2:0]            m1_AWSIZE;
    wire [1:0]            m1_AWBURST;
    wire                  m1_AWLOCK;
    wire [3:0]            m1_AWCACHE;
    wire [2:0]            m1_AWPROT;
    wire [3:0]            m1_AWQOS;
    wire [3:0]            m1_AWREGION;
    wire [USER_WIDTH-1:0] m1_AWUSER;
    wire [1:0]            m1_AWDOMAIN;
    wire [2:0]            m1_AWSNOOP;
    wire                  m1_AWVALID;
    wire                  m1_AWREADY;
    // W Channel
    wire [DATA_WIDTH-1:0] m1_WDATA;
    wire [STRB_WIDTH-1:0] m1_WSTRB;
    wire                  m1_WLAST;
    wire [USER_WIDTH-1:0] m1_WUSER;
    wire                  m1_WVALID;
    wire                  m1_WREADY;
    // B Channel
    wire [ID_WIDTH-1:0]	  m1_BID;
	wire [1:0]	          m1_BRESP;
	wire [USER_WIDTH-1:0] m1_BUSER;
	wire                  m1_BVALID;
    wire                  m1_BREADY;
    // AR Channel
    wire [ID_WIDTH-1:0]   m1_ARID;
    wire [ADDR_WIDTH-1:0] m1_ARADDR;
    wire [7:0]            m1_ARLEN;
    wire [2:0]            m1_ARSIZE;
    wire [1:0]            m1_ARBURST;
    wire                  m1_ARLOCK;
    wire [3:0]            m1_ARCACHE;
    wire [2:0]            m1_ARPROT;
    wire [3:0]            m1_ARQOS;
    wire [3:0]            m1_ARREGION;
    wire [USER_WIDTH-1:0] m1_ARUSER;
    wire [1:0]            m1_ARDOMAIN;
    wire [3:0]            m1_ARSNOOP;
    wire                  m1_ARVALID;
    wire                  m1_ARREADY;
    // R Channel
    wire [ID_WIDTH-1:0]   m1_RID;
	wire [DATA_WIDTH-1:0] m1_RDATA;
	wire [3:0]	          m1_RRESP;
    wire                  m1_RLAST;
	wire [USER_WIDTH-1:0] m1_RUSER;
	wire                  m1_RVALID;
    wire                  m1_RREADY;
    // Snoop Channels
    // AC Channel
    wire                  m1_ACVALID;
    wire [ADDR_WIDTH-1:0] m1_ACADDR;
    wire [3:0]            m1_ACSNOOP;
    wire [2:0]            m1_ACPROT;
    wire                  m1_ACREADY;
    // CR Channel
    wire                  m1_CRREADY;
    wire                  m1_CRVALID;
    wire [4:0]            m1_CRRESP;
    // CD Channel
    wire                  m1_CDREADY;
    wire                  m1_CDVALID;
    wire [DATA_WIDTH-1:0] m1_CDDATA;
    wire                  m1_CDLAST;
    
    // **************** I-CacheA ******************
    // AW Channel
    wire [ID_WIDTH-1:0]   m2_AWID;
    wire [ADDR_WIDTH-1:0] m2_AWADDR;
    wire [7:0]            m2_AWLEN;
    wire [2:0]            m2_AWSIZE;
    wire [1:0]            m2_AWBURST;
    wire                  m2_AWLOCK;
    wire [3:0]            m2_AWCACHE;
    wire [2:0]            m2_AWPROT;
    wire [3:0]            m2_AWQOS;
    wire [3:0]            m2_AWREGION;
    wire [USER_WIDTH-1:0] m2_AWUSER;
    wire                  m2_AWVALID;
    wire                  m2_AWREADY;
    
    // W Channel
    wire [DATA_WIDTH-1:0] m2_WDATA;
    wire [STRB_WIDTH-1:0] m2_WSTRB; // can use to 1-byte; 2-byte; 4-byte access
    wire                  m2_WLAST;
    wire [USER_WIDTH-1:0] m2_WUSER;
    wire                  m2_WVALID;
    wire                  m2_WREADY;
    
    // B Channel
    wire [ID_WIDTH-1:0]   m2_BID;
    wire [1:0]            m2_BRESP;
    wire [USER_WIDTH-1:0] m2_BUSER;
    wire                  m2_BVALID;
    wire                  m2_BREADY;
    
    // AR Channel
    wire [ID_WIDTH-1:0]   m2_ARID;
    wire [ADDR_WIDTH-1:0] m2_ARADDR;
    wire [7:0]            m2_ARLEN;
    wire [2:0]            m2_ARSIZE;
    wire [1:0]            m2_ARBURST;
    wire                  m2_ARLOCK;
    wire [3:0]            m2_ARCACHE;
    wire [2:0]            m2_ARPROT;
    wire [3:0]            m2_ARQOS;
    wire [3:0]            m2_ARREGION;
    wire [USER_WIDTH-1:0] m2_ARUSER;
    wire                  m2_ARVALID;
    wire                  m2_ARREADY;
    
    // R Channel
    wire [ID_WIDTH-1:0]   m2_RID;
    wire [DATA_WIDTH-1:0] m2_RDATA;
    wire [1:0]            m2_RRESP;
    wire                  m2_RLAST;
    wire [USER_WIDTH-1:0] m2_RUSER;
    wire                  m2_RVALID;
    wire                  m2_RREADY;
    
    // **************** I-CacheB ******************
    // AW Channel
    wire [ID_WIDTH-1:0]   m3_AWID;
    wire [ADDR_WIDTH-1:0] m3_AWADDR;
    wire [7:0]            m3_AWLEN;
    wire [2:0]            m3_AWSIZE;
    wire [1:0]            m3_AWBURST;
    wire                  m3_AWLOCK;
    wire [3:0]            m3_AWCACHE;
    wire [2:0]            m3_AWPROT;
    wire [3:0]            m3_AWQOS;
    wire [3:0]            m3_AWREGION;
    wire [USER_WIDTH-1:0] m3_AWUSER;
    wire                  m3_AWVALID;
    wire                  m3_AWREADY;
    
    // W Channel
    wire [DATA_WIDTH-1:0] m3_WDATA;
    wire [STRB_WIDTH-1:0] m3_WSTRB; // can use to 1-byte; 2-byte; 4-byte access
    wire                  m3_WLAST;
    wire [USER_WIDTH-1:0] m3_WUSER;
    wire                  m3_WVALID;
    wire                  m3_WREADY;
    
    // B Channel
    wire [ID_WIDTH-1:0]   m3_BID;
    wire [1:0]            m3_BRESP;
    wire [USER_WIDTH-1:0] m3_BUSER;
    wire                  m3_BVALID;
    wire                  m3_BREADY;
    
    // AR Channel
    wire [ID_WIDTH-1:0]   m3_ARID;
    wire [ADDR_WIDTH-1:0] m3_ARADDR;
    wire [7:0]            m3_ARLEN;
    wire [2:0]            m3_ARSIZE;
    wire [1:0]            m3_ARBURST;
    wire                  m3_ARLOCK;
    wire [3:0]            m3_ARCACHE;
    wire [2:0]            m3_ARPROT;
    wire [3:0]            m3_ARQOS;
    wire [3:0]            m3_ARREGION;
    wire [USER_WIDTH-1:0] m3_ARUSER;
    wire                  m3_ARVALID;
    wire                  m3_ARREADY;
    
    // R Channel
    wire [ID_WIDTH-1:0]   m3_RID;
    wire [DATA_WIDTH-1:0] m3_RDATA;
    wire [1:0]            m3_RRESP;
    wire                  m3_RLAST;
    wire [USER_WIDTH-1:0] m3_RUSER;
    wire                  m3_RVALID;
    wire                  m3_RREADY;
    
    /********** Main Memory **********/
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
    wire [DATA_WIDTH-1:0] s_WDATA;
    wire [STRB_WIDTH-1:0] s_WSTRB;
    wire                  s_WLAST;
    wire [USER_WIDTH-1:0] s_WUSER;
    wire                  s_WVALID;
    wire    	          s_WREADY;
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
	wire 	              s_RLAST;
	wire [USER_WIDTH-1:0] s_RUSER;
	wire 	              s_RVALID; 
    wire                  s_RREADY;
    
    /***************************** m0 *********************/
    assign {m0_AWID, m0_AWADDR, m0_AWLEN, m0_AWSIZE, m0_AWBURST, m0_AWLOCK, m0_AWCACHE, m0_AWPROT, m0_AWQOS, m0_AWREGION, m0_AWUSER, m0_AWDOMAIN, m0_AWSNOOP, m0_AWVALID} = m0_IN;
    assign {m0_WDATA, m0_WSTRB, m0_WLAST, m0_WUSER, m0_WVALID} = m0_IN;
    assign {m0_BREADY} = m0_IN;
    assign m0_OUT[0] = m0_AWREADY;
    assign m0_OUT[1] = m0_WREADY;
    assign m0_OUT[10:2] = {m0_BID, m0_BRESP, m0_BUSER, m0_BVALID};
    
    assign {m0_ARID, m0_ARADDR, m0_ARLEN, m0_ARSIZE, m0_ARBURST, m0_ARLOCK, m0_ARCACHE, m0_ARPROT, m0_ARQOS, m0_ARREGION, m0_ARUSER, m0_ARDOMAIN, m0_ARSNOOP, m0_ARVALID} = m0_IN;
    assign {m0_RREADY} = m0_IN;
    assign {m0_ACREADY} = m0_IN;
    assign {m0_CRVALID, m0_CRRESP} = m0_IN;
    assign {m0_CDVALID, m0_CDDATA, m0_CDLAST} = m0_IN;
    assign m0_OUT[11] = m0_ARREADY;
    assign m0_OUT[63:12] = {m0_RID, m0_RDATA, m0_RRESP, m0_RLAST, m0_RUSER, m0_RVALID};
    assign m0_OUT[127:66] = {m0_ACVALID, m0_ACADDR, m0_ACSNOOP, m0_ACPROT};
    assign m0_OUT[64] = m0_CRREADY;
    assign m0_OUT[65] = m0_CDREADY;
    
    /***************************** m1 *********************/
    assign {m1_AWID, m1_AWADDR, m1_AWLEN, m1_AWSIZE, m1_AWBURST, m1_AWLOCK, m1_AWCACHE, m1_AWPROT, m1_AWQOS, m1_AWREGION, m1_AWUSER, m1_AWDOMAIN, m1_AWSNOOP, m1_AWVALID} = m1_IN;
    assign {m1_WDATA, m1_WSTRB, m1_WLAST, m1_WUSER, m1_WVALID} = m1_IN;
    assign {m1_BREADY} = m1_IN;
    assign m1_OUT[0] = m1_AWREADY;
    assign m1_OUT[1] = m1_WREADY;
    assign m1_OUT[10:2] = {m1_BID, m1_BRESP, m1_BUSER, m1_BVALID};
    
    assign {m1_ARID, m1_ARADDR, m1_ARLEN, m1_ARSIZE, m1_ARBURST, m1_ARLOCK, m1_ARCACHE, m1_ARPROT, m1_ARQOS, m1_ARREGION, m1_ARUSER, m1_ARDOMAIN, m1_ARSNOOP, m1_ARVALID} = m1_IN;
    assign {m1_RREADY} = m1_IN;
    assign {m1_ACREADY} = m1_IN;
    assign {m1_CRVALID, m1_CRRESP} = m1_IN;
    assign {m1_CDVALID, m1_CDDATA, m1_CDLAST} = m1_IN;
    assign m1_OUT[11] = m1_ARREADY;
    assign m1_OUT[63:12] = {m1_RID, m1_RDATA, m1_RRESP, m1_RLAST, m1_RUSER, m1_RVALID};
    assign m1_OUT[127:66] = {m1_ACVALID, m1_ACADDR, m1_ACSNOOP, m1_ACPROT};
    assign m1_OUT[64] = m1_CRREADY;
    assign m1_OUT[65] = m1_CDREADY;
    
    /***************************** m2 *********************/
    assign {m2_AWID, m2_AWADDR, m2_AWLEN, m2_AWSIZE, m2_AWBURST, m2_AWLOCK, m2_AWCACHE, m2_AWPROT, m2_AWQOS, m2_AWREGION, m2_AWUSER, m2_AWVALID} = m2_IN;
    assign {m2_WDATA, m2_WSTRB, m2_WLAST, m2_WUSER, m2_WVALID} = m2_IN;
    assign {m2_BREADY} = m2_IN;
    assign m2_OUT[0] = m2_AWREADY;
    assign m2_OUT[1] = m2_WREADY;
    assign m2_OUT[10:2] = {m2_BID, m2_BRESP, m2_BUSER, m2_BVALID};
    
    assign {m2_ARID, m2_ARADDR, m2_ARLEN, m2_ARSIZE, m2_ARBURST, m2_ARLOCK, m2_ARCACHE, m2_ARPROT, m2_ARQOS, m2_ARREGION, m2_ARUSER, m2_ARVALID} = m2_IN;
    assign {m2_RREADY} = m2_IN;
    assign m2_OUT[11] = m2_ARREADY;
    assign m2_OUT[63:12] = {m2_RID, m2_RDATA, m2_RRESP, m2_RLAST, m2_RUSER, m2_RVALID};
    
    /***************************** m3 *********************/
    assign {m3_AWID, m3_AWADDR, m3_AWLEN, m3_AWSIZE, m3_AWBURST, m3_AWLOCK, m3_AWCACHE, m3_AWPROT, m3_AWQOS, m3_AWREGION, m3_AWUSER, m3_AWVALID} = m3_IN;
    assign {m3_WDATA, m3_WSTRB, m3_WLAST, m3_WUSER, m3_WVALID} = m3_IN;
    assign {m3_BREADY} = m3_IN;
    assign m3_OUT[0] = m3_AWREADY;
    assign m3_OUT[1] = m3_WREADY;
    assign m3_OUT[10:2] = {m3_BID, m3_BRESP, m3_BUSER, m3_BVALID};
    
    assign {m3_ARID, m3_ARADDR, m3_ARLEN, m3_ARSIZE, m3_ARBURST, m3_ARLOCK, m3_ARCACHE, m3_ARPROT, m3_ARQOS, m3_ARREGION, m3_ARUSER, m3_ARVALID} = m3_IN;
    assign {m3_RREADY} = m3_IN;
    assign m3_OUT[11] = m3_ARREADY;
    assign m3_OUT[63:12] = {m3_RID, m3_RDATA, m3_RRESP, m3_RLAST, m3_RUSER, m3_RVALID};
    
    /***************************** slave *********************/
    assign s_OUT = {s_AWID, s_AWADDR, s_AWLEN, s_AWSIZE, s_AWBURST, s_AWLOCK, s_AWCACHE, s_AWPROT, s_AWQOS, s_AWREGION, s_AWUSER, s_AWVALID, s_WDATA, s_WSTRB, s_WLAST, s_WUSER, s_WVALID, s_BREADY, s_ARID, s_ARADDR, s_ARLEN, s_ARSIZE, s_ARBURST, s_ARLOCK, s_ARCACHE, s_ARPROT, s_ARQOS, s_ARREGION, s_ARUSER, s_ARVALID, s_RREADY};
    
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
        .m0_AWID    (m0_AWID    ),
        .m0_AWADDR  (m0_AWADDR  ),
        .m0_AWLEN   (m0_AWLEN   ),
        .m0_AWSIZE  (m0_AWSIZE  ),
        .m0_AWBURST (m0_AWBURST ),
        .m0_AWLOCK  (m0_AWLOCK  ),
        .m0_AWCACHE (m0_AWCACHE ),
        .m0_AWPROT  (m0_AWPROT  ),
        .m0_AWQOS   (m0_AWQOS   ),
        .m0_AWREGION(m0_AWREGION),
        .m0_AWUSER  (m0_AWUSER  ),
        .m0_AWDOMAIN(m0_AWDOMAIN),
        .m0_AWSNOOP (m0_AWSNOOP ),
        .m0_AWVALID (m0_AWVALID ),
        .m0_AWREADY (m0_AWREADY ),
        // W Channel
        .m0_WDATA   (m0_WDATA   ),
        .m0_WSTRB   (m0_WSTRB   ),
        .m0_WLAST   (m0_WLAST   ),
        .m0_WUSER   (m0_WUSER   ),
        .m0_WVALID  (m0_WVALID  ),
        .m0_WREADY  (m0_WREADY  ),
        // B Channel
        .m0_BID     (m0_BID     ),
        .m0_BRESP   (m0_BRESP   ),
        .m0_BUSER   (m0_BUSER   ),
        .m0_BVALID  (m0_BVALID  ),
        .m0_BREADY  (m0_BREADY  ),
        // AR Channel
        .m0_ARID    (m0_ARID    ),
        .m0_ARADDR  (m0_ARADDR  ),
        .m0_ARLEN   (m0_ARLEN   ),
        .m0_ARSIZE  (m0_ARSIZE  ),
        .m0_ARBURST (m0_ARBURST ),
        .m0_ARLOCK  (m0_ARLOCK  ),
        .m0_ARCACHE (m0_ARCACHE ),
        .m0_ARPROT  (m0_ARPROT  ),
        .m0_ARQOS   (m0_ARQOS   ),
        .m0_ARREGION(m0_ARREGION),
        .m0_ARUSER  (m0_ARUSER  ),
        .m0_ARDOMAIN(m0_ARDOMAIN),
        .m0_ARSNOOP (m0_ARSNOOP ),
        .m0_ARVALID (m0_ARVALID ),
        .m0_ARREADY (m0_ARREADY ),
        // R Channel
        .m0_RID     (m0_RID     ),
        .m0_RDATA   (m0_RDATA   ),
        .m0_RRESP   (m0_RRESP   ),
        .m0_RLAST   (m0_RLAST   ),
        .m0_RUSER   (m0_RUSER   ),
        .m0_RVALID  (m0_RVALID  ),
        .m0_RREADY  (m0_RREADY  ),
        // Snoop Channels
        // AC Channel
        .m0_ACVALID (m0_ACVALID ),
        .m0_ACADDR  (m0_ACADDR  ),
        .m0_ACSNOOP (m0_ACSNOOP ),
        .m0_ACPROT  (m0_ACPROT  ),
        .m0_ACREADY (m0_ACREADY ),
        // CR Channel
        .m0_CRREADY (m0_CRREADY ),
        .m0_CRVALID (m0_CRVALID ),
        .m0_CRRESP  (m0_CRRESP  ),
        // CD Channel
        .m0_CDREADY (m0_CDREADY ),
        .m0_CDVALID (m0_CDVALID ),
        .m0_CDDATA  (m0_CDDATA  ),
        .m0_CDLAST  (m0_CDLAST  ),
        
        /********** Master 1 side **********/
        // AW Channel
        .m1_AWID    (m1_AWID    ),
        .m1_AWADDR  (m1_AWADDR  ),
        .m1_AWLEN   (m1_AWLEN   ),
        .m1_AWSIZE  (m1_AWSIZE  ),
        .m1_AWBURST (m1_AWBURST ),
        .m1_AWLOCK  (m1_AWLOCK  ),
        .m1_AWCACHE (m1_AWCACHE ),
        .m1_AWPROT  (m1_AWPROT  ),
        .m1_AWQOS   (m1_AWQOS   ),
        .m1_AWREGION(m1_AWREGION),
        .m1_AWUSER  (m1_AWUSER  ),
        .m1_AWDOMAIN(m1_AWDOMAIN),
        .m1_AWSNOOP (m1_AWSNOOP ),
        .m1_AWVALID (m1_AWVALID ),
        .m1_AWREADY (m1_AWREADY ),
        // W Channel
        .m1_WDATA   (m1_WDATA   ),
        .m1_WSTRB   (m1_WSTRB   ),
        .m1_WLAST   (m1_WLAST   ),
        .m1_WUSER   (m1_WUSER   ),
        .m1_WVALID  (m1_WVALID  ),
        .m1_WREADY  (m1_WREADY  ),
        // B Channel
        .m1_BID     (m1_BID     ),
        .m1_BRESP   (m1_BRESP   ),
        .m1_BUSER   (m1_BUSER   ),
        .m1_BVALID  (m1_BVALID  ),
        .m1_BREADY  (m1_BREADY  ),
        // AR Channel
        .m1_ARID    (m1_ARID    ),
        .m1_ARADDR  (m1_ARADDR  ),
        .m1_ARLEN   (m1_ARLEN   ),
        .m1_ARSIZE  (m1_ARSIZE  ),
        .m1_ARBURST (m1_ARBURST ),
        .m1_ARLOCK  (m1_ARLOCK  ),
        .m1_ARCACHE (m1_ARCACHE ),
        .m1_ARPROT  (m1_ARPROT  ),
        .m1_ARQOS   (m1_ARQOS   ),
        .m1_ARREGION(m1_ARREGION),
        .m1_ARUSER  (m1_ARUSER  ),
        .m1_ARDOMAIN(m1_ARDOMAIN),
        .m1_ARSNOOP (m1_ARSNOOP ),
        .m1_ARVALID (m1_ARVALID ),
        .m1_ARREADY (m1_ARREADY ),
        // R Channel
        .m1_RID     (m1_RID     ),
        .m1_RDATA   (m1_RDATA   ),
        .m1_RRESP   (m1_RRESP   ),
        .m1_RLAST   (m1_RLAST   ),
        .m1_RUSER   (m1_RUSER   ),
        .m1_RVALID  (m1_RVALID  ),
        .m1_RREADY  (m1_RREADY  ),
        // Snoop Channels
        // AC Channel
        .m1_ACVALID (m1_ACVALID ),
        .m1_ACADDR  (m1_ACADDR  ),
        .m1_ACSNOOP (m1_ACSNOOP ),
        .m1_ACPROT  (m1_ACPROT  ),
        .m1_ACREADY (m1_ACREADY ),
        // CR Channel
        .m1_CRREADY (m1_CRREADY ),
        .m1_CRVALID (m1_CRVALID ),
        .m1_CRRESP  (m1_CRRESP  ),
        // CD Channel
        .m1_CDREADY (m1_CDREADY ),
        .m1_CDVALID (m1_CDVALID ),
        .m1_CDDATA  (m1_CDDATA  ),
        .m1_CDLAST  (m1_CDLAST  ),
        
        // I-Cache related signals
        // AXI4
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
        .m2_WDATA   (m2_WDATA   ),
        .m2_WSTRB   (m2_WSTRB   ), 
        .m2_WLAST   (m2_WLAST   ),
        .m2_WUSER   (m2_WUSER   ),
        .m2_WVALID  (m2_WVALID  ),
        .m2_WREADY  (m2_WREADY  ),
        // B Channel
        .m2_BID     (m2_BID     ),
        .m2_BRESP   (m2_BRESP   ),
        .m2_BUSER   (m2_BUSER   ),
        .m2_BVALID  (m2_BVALID  ),
        .m2_BREADY  (m2_BREADY  ),
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
        .m2_RID     (m2_RID     ),
        .m2_RDATA   (m2_RDATA   ),
        .m2_RRESP   (m2_RRESP   ),
        .m2_RLAST   (m2_RLAST   ),
        .m2_RUSER   (m2_RUSER   ),
        .m2_RVALID  (m2_RVALID  ),
        .m2_RREADY  (m2_RREADY  ),
        
        // I-Cache related signals
        // AXI4
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
        .m3_WDATA   (m3_WDATA   ),
        .m3_WSTRB   (m3_WSTRB   ), 
        .m3_WLAST   (m3_WLAST   ),
        .m3_WUSER   (m3_WUSER   ),
        .m3_WVALID  (m3_WVALID  ),
        .m3_WREADY  (m3_WREADY  ),
        // B Channel
        .m3_BID     (m3_BID     ),
        .m3_BRESP   (m3_BRESP   ),
        .m3_BUSER   (m3_BUSER   ),
        .m3_BVALID  (m3_BVALID  ),
        .m3_BREADY  (m3_BREADY  ),
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
        .m3_RID     (m3_RID     ),
        .m3_RDATA   (m3_RDATA   ),
        .m3_RRESP   (m3_RRESP   ),
        .m3_RLAST   (m3_RLAST   ),
        .m3_RUSER   (m3_RUSER   ),
        .m3_RVALID  (m3_RVALID  ),
        .m3_RREADY  (m3_RREADY  ),
    
        /********** Slave side**********/
        // AW Channel
        .s_AWID     (s_AWID     ),
        .s_AWADDR   (s_AWADDR   ),
        .s_AWLEN    (s_AWLEN    ),
        .s_AWSIZE   (s_AWSIZE   ),
        .s_AWBURST  (s_AWBURST  ),
        .s_AWLOCK   (s_AWLOCK   ),
        .s_AWCACHE  (s_AWCACHE  ),
        .s_AWPROT   (s_AWPROT   ),
        .s_AWQOS    (s_AWQOS    ),
        .s_AWREGION (s_AWREGION ),
        .s_AWUSER   (s_AWUSER   ),
        .s_AWVALID  (s_AWVALID  ),
        .s_AWREADY  (s_AWREADY  ),
        // W Channel
        .s_WDATA    (s_WDATA    ),
        .s_WSTRB    (s_WSTRB    ),
        .s_WLAST    (s_WLAST    ),
        .s_WUSER    (s_WUSER    ),
        .s_WVALID   (s_WVALID   ),
        .s_WREADY   (s_WREADY   ),
        // B Channel
        .s_BID      (s_BID      ),
        .s_BRESP    (s_BRESP    ),
        .s_BUSER    (s_BUSER    ),
        .s_BVALID   (s_BVALID   ),
        .s_BREADY   (s_BREADY   ),
        // AR Channel
        .s_ARID     (s_ARID     ),    
        .s_ARADDR   (s_ARADDR   ),
        .s_ARLEN    (s_ARLEN    ),
        .s_ARSIZE   (s_ARSIZE   ),
        .s_ARBURST  (s_ARBURST  ),
        .s_ARLOCK   (s_ARLOCK   ),
        .s_ARCACHE  (s_ARCACHE  ),
        .s_ARPROT   (s_ARPROT   ),
        .s_ARQOS    (s_ARQOS    ),
        .s_ARREGION (s_ARREGION ),
        .s_ARUSER   (s_ARUSER   ),
        .s_ARVALID  (s_ARVALID  ),
        .s_ARREADY  (s_ARREADY  ),
        // R Channel
        .s_RID      (s_RID      ),
        .s_RDATA    (s_RDATA    ),
        .s_RRESP    (s_RRESP    ),
        .s_RLAST    (s_RLAST    ),
        .s_RUSER    (s_RUSER    ),
        .s_RVALID   (s_RVALID   ), 
        .s_RREADY   (s_RREADY   )
    );

endmodule
