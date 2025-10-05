//=============================================================================
// This Mux is used to select accessed signals between two Masters on Write Transactions
//=============================================================================

`timescale 1ns/1ns

module AXI_Master_Mux_W
#(
    parameter DATA_WIDTH  = 32,
    parameter ADDR_WIDTH  = 32,
    parameter ID_WIDTH    = 2,
    parameter USER_WIDTH  = 4,
    parameter STRB_WIDTH  = (DATA_WIDTH/8)
)
(
	
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
    output reg                  m0_AWREADY,
    // W Channel
    // input      [ID_WIDTH-1:0]   m0_WID,
    input      [DATA_WIDTH-1:0] m0_WDATA,
    input      [STRB_WIDTH-1:0] m0_WSTRB,
    input                       m0_WLAST,
    input      [USER_WIDTH-1:0] m0_WUSER,
    input                       m0_WVALID,
    output reg                  m0_WREADY,
    // B Channel
    output reg [ID_WIDTH-1:0]	m0_BID,
	output reg [1:0]	        m0_BRESP,
	output reg [USER_WIDTH-1:0] m0_BUSER,
	output reg                  m0_BVALID,
    input                       m0_BREADY,
    
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
    output reg                  m1_AWREADY,
    // W Channel
    // input      [ID_WIDTH-1:0]   m1_WID,
    input      [DATA_WIDTH-1:0] m1_WDATA,
    input      [STRB_WIDTH-1:0] m1_WSTRB,
    input                       m1_WLAST,
    input      [USER_WIDTH-1:0] m1_WUSER,
    input                       m1_WVALID,
    output reg                  m1_WREADY,
    // B Channel
    output reg [ID_WIDTH-1:0]	m1_BID,
	output reg [1:0]	        m1_BRESP,
	output reg [USER_WIDTH-1:0] m1_BUSER,
	output reg                  m1_BVALID,
    input                       m1_BREADY,
    
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
    output reg                  m2_AWREADY,
    // W Channel
    // input      [ID_WIDTH-1:0]   m0_WID,
    input      [DATA_WIDTH-1:0] m2_WDATA,
    input      [STRB_WIDTH-1:0] m2_WSTRB,
    input                       m2_WLAST,
    input      [USER_WIDTH-1:0] m2_WUSER,
    input                       m2_WVALID,
    output reg                  m2_WREADY,
    // B Channel
    output reg [ID_WIDTH-1:0]	m2_BID,
	output reg [1:0]	        m2_BRESP,
	output reg [USER_WIDTH-1:0] m2_BUSER,
	output reg                  m2_BVALID,
    input                       m2_BREADY,
    
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
    output reg                  m3_AWREADY,
    // W Channel
    // input      [ID_WIDTH-1:0]   m1_WID,
    input      [DATA_WIDTH-1:0] m3_WDATA,
    input      [STRB_WIDTH-1:0] m3_WSTRB,
    input                       m3_WLAST,
    input      [USER_WIDTH-1:0] m3_WUSER,
    input                       m3_WVALID,
    output reg                  m3_WREADY,
    // B Channel
    output reg [ID_WIDTH-1:0]	m3_BID,
	output reg [1:0]	        m3_BRESP,
	output reg [USER_WIDTH-1:0] m3_BUSER,
	output reg                  m3_BVALID,
    input                       m3_BREADY,
    
    /******** Slave ********/
    // AW Channel
    output reg [ID_WIDTH-1:0]   s_AWID,
    output reg [ADDR_WIDTH-1:0]	s_AWADDR,
    output reg [7:0]            s_AWLEN,
    output reg [2:0]            s_AWSIZE,
    output reg [1:0]            s_AWBURST,
    output reg                  s_AWLOCK,
    output reg [3:0]            s_AWCACHE,
    output reg [2:0]            s_AWPROT,
    output reg [3:0]            s_AWQOS,
    output reg [3:0]            s_AWREGION,
    output reg [USER_WIDTH-1:0] s_AWUSER,
    output reg                  s_AWVALID,
    input                       s_AWREADY,
    // W Channel
    // output reg [ID_WIDTH-1:0]   s_WID,
    output reg [DATA_WIDTH-1:0] s_WDATA,
    output reg [STRB_WIDTH-1:0] s_WSTRB,
    output reg                  s_WLAST,
    output reg [USER_WIDTH-1:0] s_WUSER,
    output reg                  s_WVALID,
    input                       s_WREADY,
    // B Channel
    input	   [ID_WIDTH-1:0]	s_BID,
	input	   [1:0]	        s_BRESP,
	input	   [USER_WIDTH-1:0] s_BUSER,
    input                       s_BVALID,
    output reg                  s_BREADY,
    
    /******** input from Arbiter ********/
    input                       m0_wgrnt,
	input                       m1_wgrnt,
	input                       m2_wgrnt,
	input                       m3_wgrnt
);

    //---------------------------------------------------------
    always @(*) begin
        case({m0_wgrnt,m1_wgrnt,m2_wgrnt,m3_wgrnt})     
            4'b1000: begin
                // AW Channel
                s_AWID      =  m0_AWID;
                s_AWADDR    =  m0_AWADDR;
                s_AWLEN     =  m0_AWLEN;
                s_AWSIZE    =  m0_AWSIZE;
                s_AWBURST   =  m0_AWBURST;
                s_AWLOCK    =  m0_AWLOCK;
                s_AWCACHE   =  m0_AWCACHE;
                s_AWPROT    =  m0_AWPROT;
                s_AWQOS     =  m0_AWQOS;
                s_AWREGION  =  m0_AWREGION;
                s_AWUSER    =  m0_AWUSER;
                s_AWVALID   =  m0_AWVALID;
                // W Channel
                // s_WID       =  m0_WID;
                s_WDATA     =  m0_WDATA;
                s_WSTRB     =  m0_WSTRB;
                s_WLAST     =  m0_WLAST;
                s_WUSER     =  m0_WUSER;
                s_WVALID    =  m0_WVALID;
                // B Channel
                s_BREADY    =  m0_BREADY;
            end
            4'b0100: begin
                // AW Channel
                s_AWID      =  m1_AWID;
                s_AWADDR    =  m1_AWADDR;
                s_AWLEN     =  m1_AWLEN;
                s_AWSIZE    =  m1_AWSIZE;
                s_AWBURST   =  m1_AWBURST;
                s_AWLOCK    =  m1_AWLOCK;
                s_AWCACHE   =  m1_AWCACHE;
                s_AWPROT    =  m1_AWPROT;
                s_AWQOS     =  m1_AWQOS;
                s_AWREGION  =  m1_AWREGION;
                s_AWUSER    =  m1_AWUSER;
                s_AWVALID   =  m1_AWVALID;
                // W Channel
                // s_WID       =  m1_WID;
                s_WDATA     =  m1_WDATA;
                s_WSTRB     =  m1_WSTRB;
                s_WLAST     =  m1_WLAST;
                s_WUSER     =  m1_WUSER;
                s_WVALID    =  m1_WVALID;
                // B Channel
                s_BREADY    =  m1_BREADY;
            end
            4'b0010: begin
                // AW Channel
                s_AWID      =  m2_AWID;
                s_AWADDR    =  m2_AWADDR;
                s_AWLEN     =  m2_AWLEN;
                s_AWSIZE    =  m2_AWSIZE;
                s_AWBURST   =  m2_AWBURST;
                s_AWLOCK    =  m2_AWLOCK;
                s_AWCACHE   =  m2_AWCACHE;
                s_AWPROT    =  m2_AWPROT;
                s_AWQOS     =  m2_AWQOS;
                s_AWREGION  =  m2_AWREGION;
                s_AWUSER    =  m2_AWUSER;
                s_AWVALID   =  m2_AWVALID;
                // W Channel
                // s_WID       =  m2_WID;
                s_WDATA     =  m2_WDATA;
                s_WSTRB     =  m2_WSTRB;
                s_WLAST     =  m2_WLAST;
                s_WUSER     =  m2_WUSER;
                s_WVALID    =  m2_WVALID;
                // B Channel
                s_BREADY    =  m2_BREADY;
            end
            4'b0001: begin
                // AW Channel
                s_AWID      =  m3_AWID;
                s_AWADDR    =  m3_AWADDR;
                s_AWLEN     =  m3_AWLEN;
                s_AWSIZE    =  m3_AWSIZE;
                s_AWBURST   =  m3_AWBURST;
                s_AWLOCK    =  m3_AWLOCK;
                s_AWCACHE   =  m3_AWCACHE;
                s_AWPROT    =  m3_AWPROT;
                s_AWQOS     =  m3_AWQOS;
                s_AWREGION  =  m3_AWREGION;
                s_AWUSER    =  m3_AWUSER;
                s_AWVALID   =  m3_AWVALID;
                // W Channel
                // s_WID       =  m3_WID;
                s_WDATA     =  m3_WDATA;
                s_WSTRB     =  m3_WSTRB;
                s_WLAST     =  m3_WLAST;
                s_WUSER     =  m3_WUSER;
                s_WVALID    =  m3_WVALID;
                // B Channel
                s_BREADY    =  m3_BREADY;
            end
            default: begin
                // AW Channel
                s_AWID      =  'b0;
                s_AWADDR    =  'b0;
                s_AWLEN     =  'b0;
                s_AWSIZE    =  'b0;
                s_AWBURST   =  'b0;
                s_AWLOCK    =  'b0;
                s_AWCACHE   =  'b0;
                s_AWPROT    =  'b0;
                s_AWQOS     =  'b0;
                s_AWREGION  =  'b0;
                s_AWUSER    =  'b0;
                s_AWVALID   =  'b0;
                // W Channel
                // s_WID       =  'b0;
                s_WDATA     =  'b0;
                s_WSTRB     =  'b0;
                s_WLAST     =  'b0;
                s_WUSER     =  'b0;
                s_WVALID    =  'b0;
                // B Channel
                s_BREADY    =  'b0;
            end
        endcase
    end


    //---------------------------------------------------------
    //AWREADY
    always @(*) begin
        case({m0_wgrnt,m1_wgrnt,m2_wgrnt,m3_wgrnt})
            4'b1000: begin 
                m0_AWREADY = s_AWREADY;
                m1_AWREADY = 'b0;
                m2_AWREADY = 'b0;
                m3_AWREADY = 'b0;
            end
            4'b0100: begin
                m0_AWREADY = 'b0;
                m1_AWREADY = s_AWREADY;
                m2_AWREADY = 'b0;
                m3_AWREADY = 'b0;
            end
            4'b0010: begin 
                m0_AWREADY = 'b0;
                m1_AWREADY = 'b0;
                m2_AWREADY = s_AWREADY;
                m3_AWREADY = 'b0;
            end
            4'b0001: begin
                m0_AWREADY = 'b0;
                m1_AWREADY = 'b0;
                m2_AWREADY = 'b0;
                m3_AWREADY = s_AWREADY;
            end
            default: begin
                m0_AWREADY = 'b0;
                m1_AWREADY = 'b0;
                m2_AWREADY = 'b0;
                m3_AWREADY = 'b0;
            end
        endcase
    end

    //---------------------------------------------------------
    //WREADY
    always @(*) begin
        case({m0_wgrnt,m1_wgrnt,m2_wgrnt,m3_wgrnt})
            4'b1000: begin 
                m0_WREADY = s_WREADY;
                m1_WREADY = 'b0;
                m2_WREADY = 'b0;
                m3_WREADY = 'b0;
            end
            4'b0100: begin
                m0_WREADY = 'b0;
                m1_WREADY = s_WREADY;
                m2_WREADY = 'b0;
                m3_WREADY = 'b0;
            end
            4'b0010: begin 
                m0_WREADY = 'b0;
                m1_WREADY = 'b0;
                m2_WREADY = s_WREADY;
                m3_WREADY = 'b0;
            end
            4'b0001: begin
                m0_WREADY = 'b0;
                m1_WREADY = 'b0;
                m2_WREADY = 'b0;
                m3_WREADY = s_WREADY;
            end
            default: begin
                m0_WREADY = 'b0;
                m1_WREADY = 'b0;
                m2_WREADY = 'b0;
                m3_WREADY = 'b0;
            end
        endcase
    end    

    //---------------------------------------------------------
    //BVALID
    always @(*) begin
        case({m0_wgrnt,m1_wgrnt,m2_wgrnt,m3_wgrnt})
            4'b1000: begin 
                m0_BID    = s_BID  ;
                m0_BRESP  = s_BRESP;
                m0_BUSER  = s_BUSER;
                m0_BVALID = s_BVALID;
                
                m1_BID    = 'b0;
                m1_BRESP  = 'b0;
                m1_BUSER  = 'b0;
                m1_BVALID = 'b0;
                
                m2_BID    = 'b0;
                m2_BRESP  = 'b0;
                m2_BUSER  = 'b0;
                m2_BVALID = 'b0;
                
                m3_BID    = 'b0;
                m3_BRESP  = 'b0;
                m3_BUSER  = 'b0;
                m3_BVALID = 'b0;
            end
            4'b0100: begin
                m0_BID    = 'b0;
                m0_BRESP  = 'b0;
                m0_BUSER  = 'b0;
                m0_BVALID = 'b0;
                
                m1_BID    = s_BID  ;
                m1_BRESP  = s_BRESP;
                m1_BUSER  = s_BUSER;
                m1_BVALID = s_BVALID;
                
                m2_BID    = 'b0;
                m2_BRESP  = 'b0;
                m2_BUSER  = 'b0;
                m2_BVALID = 'b0;
                
                m3_BID    = 'b0;
                m3_BRESP  = 'b0;
                m3_BUSER  = 'b0;
                m3_BVALID = 'b0;
            end
            4'b0010: begin 
                m0_BID    = 'b0;
                m0_BRESP  = 'b0;
                m0_BUSER  = 'b0;
                m0_BVALID = 'b0;
                
                m1_BID    = 'b0;
                m1_BRESP  = 'b0;
                m1_BUSER  = 'b0;
                m1_BVALID = 'b0;
                
                m2_BID    = s_BID  ; 
                m2_BRESP  = s_BRESP; 
                m2_BUSER  = s_BUSER; 
                m2_BVALID = s_BVALID;
                
                m3_BID    = 'b0;
                m3_BRESP  = 'b0;
                m3_BUSER  = 'b0;
                m3_BVALID = 'b0;
            end
            4'b0001: begin
                m0_BID    = 'b0;
                m0_BRESP  = 'b0;
                m0_BUSER  = 'b0;
                m0_BVALID = 'b0;
                
                m1_BID    = 'b0;
                m1_BRESP  = 'b0;
                m1_BUSER  = 'b0;
                m1_BVALID = 'b0;
                
                m2_BID    = 'b0;
                m2_BRESP  = 'b0;
                m2_BUSER  = 'b0;
                m2_BVALID = 'b0;
                
                m3_BID    = s_BID  ; 
                m3_BRESP  = s_BRESP; 
                m3_BUSER  = s_BUSER; 
                m3_BVALID = s_BVALID;
            end
            default: begin
                m0_BID    = 'b0;
                m0_BRESP  = 'b0;
                m0_BUSER  = 'b0;
                m0_BVALID = 'b0;
                
                m1_BID    = 'b0;
                m1_BRESP  = 'b0;
                m1_BUSER  = 'b0;
                m1_BVALID = 'b0;
                
                m2_BID    = 'b0;
                m2_BRESP  = 'b0;
                m2_BUSER  = 'b0;
                m2_BVALID = 'b0;
                
                m3_BID    = 'b0;
                m3_BRESP  = 'b0;
                m3_BUSER  = 'b0;
                m3_BVALID = 'b0;
            end
        endcase
    end    

endmodule