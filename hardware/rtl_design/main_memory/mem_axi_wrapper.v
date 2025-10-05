`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// this is a wrapper of axi slave interface
//////////////////////////////////////////////////////////////////////////////////


module mem_axi_wrapper
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
    input                       m_RREADY,
    
    // interface connect with mem
    // write port
    output                      w_en,
    output     [ADDR_WIDTH-1:0] w_addr,
    output     [DATA_WIDTH-1:0] w_data,
    
    // read port
    output                      r_en,
    output     [ADDR_WIDTH-1:0] r_addr,
    input      [DATA_WIDTH-1:0] r_data
);

    wire aw_full;
    wire aw_empty;
    wire w_full;
    wire w_empty;
    
    wire ar_full;
    wire ar_empty;
    
    reg                  w_req_done;
    reg                  r_req_done;
    reg                  w_data_done;
    reg                  r_data_done;
    reg [3:0]            w_word_cnt;
    reg [3:0]            r_word_cnt;
//    reg [ADDR_WIDTH-1:0] next_AWADDR;
//    reg [ADDR_WIDTH-1:0] next_ARADDR;
    reg                  w_empty_last;
    reg                  w_resp_done;
    
    // AW Channel
    wire [ID_WIDTH-1:0]   AWID;
    wire [ADDR_WIDTH-1:0] AWADDR;
    wire [7:0]            AWLEN;
    wire [2:0]            AWSIZE;
    wire [1:0]            AWBURST;
    
    // W Channel
    wire [DATA_WIDTH-1:0] WDATA;
    wire [STRB_WIDTH-1:0] WSTRB;
    
    // AR Channel
    wire [ID_WIDTH-1:0]   ARID;    
    wire [ADDR_WIDTH-1:0] ARADDR;
    wire [7:0]            ARLEN;
    wire [2:0]            ARSIZE;
    wire [1:0]            ARBURST;
    
    // Write Address FIFO
    sync_fifo 
    #(
        .DATA_WIDTH(ID_WIDTH+ADDR_WIDTH+8+3+2),      // Data width = len(ID, ADDR, LEN, SIZE, BURST)
        .ADDR_WIDTH(1),               // Address width (depth = 2^ADDR)
        .DEPTH     (1 << 1)  // FIFO depth
    )
    aw_fifo
    (
        .clk    (ACLK   ),
        .rst_n  (ARESETn),
    
        // Write
        .wen    (m_AWVALID),
        .din    ({m_AWID, m_AWADDR, m_AWLEN, m_AWSIZE, m_AWBURST}),
        .full   (aw_full),
    
        // Read
        .ren    (w_req_done & (!aw_empty)),
        .dout   ({AWID, AWADDR, AWLEN, AWSIZE, AWBURST}),
        .empty  (aw_empty)
    );
    
    // Write FIFO
    sync_fifo 
    #(
        .DATA_WIDTH(DATA_WIDTH+STRB_WIDTH),      // Data width
        .ADDR_WIDTH(5),               // Address width (depth = 2^ADDR)
        .DEPTH     (1 << 5)  // FIFO depth
    )
    w_fifo
    (
        .clk    (ACLK   ),
        .rst_n  (ARESETn),
    
        // Write
        .wen    (m_WVALID),
        .din    ({m_WDATA, m_WSTRB}),
        .full   (w_full),
    
        // Read
        .ren    (~w_req_done & (!w_empty)),
        .dout   ({WDATA, WSTRB}),
        .empty  (w_empty)
    );
    
    // Read Address FIFO
    sync_fifo 
    #(
        .DATA_WIDTH(ID_WIDTH+ADDR_WIDTH+8+3+2),      // Data width
        .ADDR_WIDTH(1),               // Address width (depth = 2^ADDR)
        .DEPTH     (1 << 1)  // FIFO depth
    )
    ar_fifo
    (
        .clk    (ACLK   ),
        .rst_n  (ARESETn),
    
        // Write
        .wen    (m_ARVALID),
        .din    ({m_ARID, m_ARADDR, m_ARLEN, m_ARSIZE, m_ARBURST}),
        .full   (ar_full),
    
        // Read
        .ren    (r_req_done & (!ar_empty)),
        .dout   ({ARID, ARADDR, ARLEN, ARSIZE, ARBURST}),
        .empty  (ar_empty)
    );
    
    // Write
    assign m_AWREADY = ~aw_full;
    assign m_WREADY  = ~w_full;
    assign m_BVALID  =!w_req_done && w_data_done && !w_resp_done;
    
    assign m_BID     = AWID;
    assign m_BRESP   = 0;
    assign m_BUSER   = 0;
    
    // handle write data
    assign w_en      = (~w_empty_last) & (~w_req_done) & (~w_data_done);
    assign w_addr    = AWADDR + (w_word_cnt << AWSIZE);
    assign w_data    = {WDATA[31:24]&{8{WSTRB[3]}}, WDATA[23:16]&{8{WSTRB[2]}}, WDATA[15:8]&{8{WSTRB[1]}}, WDATA[7:0]&{8{WSTRB[0]}}};  
    
    // for write
    always @(posedge ACLK) begin
        if (!ARESETn) begin
            w_req_done   <= 1;
            w_data_done  <= 1;
            w_resp_done  <= 1;
//            next_AWADDR  <= 0;
            w_word_cnt   <= 0;
            w_empty_last <= 1;
        end
        else begin
            if (w_req_done && (!aw_empty)) begin
                w_req_done  <= 0;
            end
            else 
            if (m_BVALID && m_BREADY) begin
                w_req_done <= 1;
            end
            
            if (!w_req_done && w_data_done && w_resp_done) begin
                w_data_done <= 0;
            end
            else
            if (w_word_cnt == AWLEN) begin
                w_data_done <= 1;
            end

            if (!w_req_done && !w_data_done && w_resp_done) begin
                w_resp_done <= 0;
            end
            else 
            if (m_BVALID && m_BREADY) begin
                w_resp_done <= 1;
            end
            
//            if (w_en) begin
//                next_AWADDR <= next_AWADDR + (1 << AWSIZE);
//            end
                        
//            if (w_en) begin
//                if (w_word_cnt == AWLEN) begin
//                    w_word_cnt  <= 0;
//                end
//                else begin
//                    w_word_cnt <= w_word_cnt + 1;
//                end
//            end
            
            if (m_BVALID && m_BREADY && w_word_cnt == AWLEN) begin
                w_word_cnt  <= 0;
            end
            if (w_en) begin
                w_word_cnt <= w_word_cnt + 1;
            end
            
            w_empty_last <= w_empty;
        end
    end
    
    // for read
    always @(posedge ACLK) begin
        if (!ARESETn) begin
            r_req_done  <= 1;
            r_data_done <= 1;
//            next_ARADDR <= 0;
            r_word_cnt  <= 0;
        end
        else begin
            if (r_req_done && (!ar_empty)) begin
                r_req_done <= 0;
            end
            else 
            if (m_RVALID && m_RLAST && m_RREADY) begin
                r_req_done <= 1;
            end
            
            if (m_RVALID && m_RLAST && m_RREADY) begin
                r_data_done <= 1;
            end
            else
            if (!r_req_done) begin
                r_data_done <= 0;
            end
            
            
//            if (r_en) begin
//                next_ARADDR <= next_ARADDR + (1 << ARSIZE);
//            end
            
            if (~r_data_done) begin
                if (r_word_cnt == ARLEN) begin
                    r_word_cnt  <= 0;
                end
                else begin
                    r_word_cnt <= r_word_cnt + 1;
                end
            end
        end
    end
    
    // Read
    assign m_ARREADY = ~ar_full;
    
	assign m_RID    = ARID;
	assign m_RDATA  = r_data;
	assign m_RRESP  = 0;
	assign m_RLAST  = r_word_cnt == ARLEN & (~r_req_done) & (~r_data_done);
	assign m_RUSER  = 0;
	assign m_RVALID = (~r_req_done) & (~r_data_done);
    
    // handle read data
    // assign r_en   = (~r_req_done) | (r_req_done & (~ar_empty));
    assign r_en   = ~r_req_done;
    // assign r_addr = r_data_done ? ARADDR : next_ARADDR;
    assign r_addr = r_data_done ? ARADDR : ARADDR + ((r_word_cnt+1) << ARSIZE);
    
endmodule
