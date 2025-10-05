`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 
//////////////////////////////////////////////////////////////////////////////////


module memory
#(
    parameter DATA_WIDTH  = 32,
    parameter ADDR_WIDTH  = 32,
    parameter ID_WIDTH    = 2,
    parameter USER_WIDTH  = 4,
    parameter STRB_WIDTH  = (DATA_WIDTH/8),
    parameter INIT_PATH   = "D:/University/KLTN/hw_design/coherence_cache/coherence_cache.srcs/sources_1/new/mem_init.mem"
)
(
    /********* System signals *********/
	input                       ACLK,
	input      	                ARESETn,
	
	// to Main Memory
    input                       wr_mem_en,
    input   [ADDR_WIDTH-1:0]    wr_mem_addr,
    input   [DATA_WIDTH-1:0]    wr_mem_data,
	
    /********** Slave Interface **********/
    // AW Channel
    input      [ID_WIDTH-1:0]   m_AWID,
    input      [ADDR_WIDTH-1:0]	m_AWADDR,
    input      [7:0]            m_AWLEN,
    input      [2:0]            m_AWSIZE,
    input      [1:0]            m_AWBURST,
    input                       m_AWLOCK,
    input      [3:0]            m_AWCACHE,
    input      [2:0]            m_AWPROT,
    input      [3:0]            m_AWQOS,
    input      [3:0]            m_AWREGION,
    input      [USER_WIDTH-1:0] m_AWUSER,
    input                       m_AWVALID,
    output	   	                m_AWREADY,
    // W Channel
    // input     [ID_WIDTH-1:0]   m_WID,
    input      [DATA_WIDTH-1:0] m_WDATA,
    input      [STRB_WIDTH-1:0] m_WSTRB,
    input                       m_WLAST,
    input      [USER_WIDTH-1:0] m_WUSER,
    input                       m_WVALID,
    output	  		            m_WREADY,
    // B Channel
	output	   [ID_WIDTH-1:0]	m_BID,
	output	   [1:0]	        m_BRESP,
	output	   [USER_WIDTH-1:0] m_BUSER,
	output	     		        m_BVALID,
    input                       m_BREADY,
    // AR Channel
    input      [ID_WIDTH-1:0]   m_ARID,    
    input      [ADDR_WIDTH-1:0] m_ARADDR,
    input      [7:0]            m_ARLEN,
    input      [2:0]            m_ARSIZE,
    input      [1:0]            m_ARBURST,
    input                       m_ARLOCK,
    input      [3:0]            m_ARCACHE,
    input      [2:0]            m_ARPROT,
    input      [3:0]            m_ARQOS,
    input      [3:0]            m_ARREGION,
    input      [USER_WIDTH-1:0] m_ARUSER,
    input                       m_ARVALID,
	output	  		            m_ARREADY,
    // R Channel
	output	   [ID_WIDTH-1:0]   m_RID,
	output	   [DATA_WIDTH-1:0] m_RDATA,
	output	   [1:0]	        m_RRESP,
	output	  		            m_RLAST,
	output	   [USER_WIDTH-1:0]	m_RUSER,
	output	 		            m_RVALID, 
    input                       m_RREADY
);

    // interface connect with mem
    // write port
    wire                  w_en;
    wire [ADDR_WIDTH-1:0] w_addr;
    wire [DATA_WIDTH-1:0] w_data;
    
    // read port
    wire                  r_en;
    wire [ADDR_WIDTH-1:0] r_addr;
    wire [DATA_WIDTH-1:0] r_data;
    
    mem_axi_wrapper
    #(
        .DATA_WIDTH(DATA_WIDTH  ),
        .ADDR_WIDTH(ADDR_WIDTH  ),
        .ID_WIDTH  (ID_WIDTH    ),
        .USER_WIDTH(USER_WIDTH  ),
        .STRB_WIDTH(DATA_WIDTH/8)
    )
    umem_axi_wrapper
    (
        /********* System signals *********/
        .ACLK       (ACLK   ),
        .ARESETn    (ARESETn),
        
        /********** Slave Interface **********/
        // AW Channel
        .m_AWID     (m_AWID    ),
        .m_AWADDR   (m_AWADDR  ),
        .m_AWLEN    (m_AWLEN   ),
        .m_AWSIZE   (m_AWSIZE  ),
        .m_AWBURST  (m_AWBURST ),
        .m_AWLOCK   (m_AWLOCK  ),
        .m_AWCACHE  (m_AWCACHE ),
        .m_AWPROT   (m_AWPROT  ),
        .m_AWQOS    (m_AWQOS   ),
        .m_AWREGION (m_AWREGION),
        .m_AWUSER   (m_AWUSER  ),
        .m_AWVALID  (m_AWVALID ),
        .m_AWREADY  (m_AWREADY ),
        // W Channel
        // input     [ID_WIDTH-1:0]   m_WID(),
        .m_WDATA    (m_WDATA ),
        .m_WSTRB    (m_WSTRB ),
        .m_WLAST    (m_WLAST ),
        .m_WUSER    (m_WUSER ),
        .m_WVALID   (m_WVALID),
        .m_WREADY   (m_WREADY),
        // B Channel
        .m_BID      (m_BID   ),
        .m_BRESP    (m_BRESP ),
        .m_BUSER    (m_BUSER ),
        .m_BVALID   (m_BVALID),
        .m_BREADY   (m_BREADY),
        // AR Channel
        .m_ARID     (m_ARID    ),    
        .m_ARADDR   (m_ARADDR  ),
        .m_ARLEN    (m_ARLEN   ),
        .m_ARSIZE   (m_ARSIZE  ),
        .m_ARBURST  (m_ARBURST ),
        .m_ARLOCK   (m_ARLOCK  ),
        .m_ARCACHE  (m_ARCACHE ),
        .m_ARPROT   (m_ARPROT  ),
        .m_ARQOS    (m_ARQOS   ),
        .m_ARREGION (m_ARREGION),
        .m_ARUSER   (m_ARUSER  ),
        .m_ARVALID  (m_ARVALID ),
        .m_ARREADY  (m_ARREADY ),
        // R Channel
        .m_RID      (m_RID   ),
        .m_RDATA    (m_RDATA ),
        .m_RRESP    (m_RRESP ),
        .m_RLAST    (m_RLAST ),
        .m_RUSER    (m_RUSER ),
        .m_RVALID   (m_RVALID), 
        .m_RREADY   (m_RREADY),
        
        // interface connect with mem
        // write port
        .w_en       (w_en  ),
        .w_addr     (w_addr),
        .w_data     (w_data),
        
        // read port
        .r_en       (r_en  ),
        .r_addr     (r_addr),
        .r_data     (r_data)
    );
    
    ram
    #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(16),
        .INIT_PATH (INIT_PATH)
    )
    umem
    (
        .clk    (ACLK   ), 
        .rst_n  (ARESETn),
    
        // write port
        .w_en   (w_en | wr_mem_en),
        .w_addr (({16{w_en}} & w_addr[17:2]) | ({16{wr_mem_en}} & wr_mem_addr[17:2])),
        .w_data (({32{w_en}} & w_data) | ({32{wr_mem_en}} & wr_mem_data)),
        
        // read port
        .r_en   (r_en  ),
        .r_addr (r_addr[17:2]),
        .r_data (r_data)
    );
    
endmodule
