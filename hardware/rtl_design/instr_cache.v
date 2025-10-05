`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// This is I-Cache design
//////////////////////////////////////////////////////////////////////////////////


module instr_cache
#(
    parameter DATA_WIDTH  = 32,
    parameter ADDR_WIDTH  = 32,
    parameter ID_WIDTH    = 2,          // I-CacheA: 2'b10, I-CacheB: 2'b11
    parameter USER_WIDTH  = 4,
    parameter STRB_WIDTH  = (DATA_WIDTH/8),
    parameter ADDR_START  = 32'h0000_0000, // start address of instruction region
    parameter ADDR_END    = 32'h0000_03FF  // end address of instruction region
)
(
    // system signals
    input                       ACLK,
    input                       ARESETn,
    input                       ENABLE,
    output                      CACHE_HIT,
    output                      CACHE_BUSY,
    
    // AXI5 Interface (connect with CPU)
    // AW Channel
    input   [ID_WIDTH-1:0]      m_AWID,
    input   [ADDR_WIDTH-1:0]    m_AWADDR,
    input   [7:0]               m_AWLEN,
    input   [2:0]               m_AWSIZE,
    input   [1:0]               m_AWBURST,
    input                       m_AWLOCK,
    input   [3:0]               m_AWCACHE,
    input   [2:0]               m_AWPROT,
    input   [3:0]               m_AWQOS,
    input   [3:0]               m_AWREGION,
    input   [USER_WIDTH-1:0]    m_AWUSER,
    input                       m_AWVALID,
    output                      m_AWREADY,
    
    // W Channel
    input   [DATA_WIDTH-1:0]    m_WDATA,
    input   [STRB_WIDTH-1:0]    m_WSTRB, // can use to 1-byte, 2-byte, 4-byte access
    input                       m_WLAST,
    input   [USER_WIDTH-1:0]    m_WUSER,
    input                       m_WVALID,
    output                      m_WREADY,
    
    // B Channel
    output  [ID_WIDTH-1:0]      m_BID,
    output  [1:0]               m_BRESP,
    output  [USER_WIDTH-1:0]    m_BUSER,
    output                      m_BVALID,
    input                       m_BREADY,
    
    // AR Channel
    input   [ID_WIDTH-1:0]      m_ARID,
    input   [ADDR_WIDTH-1:0]    m_ARADDR,
    input   [7:0]               m_ARLEN,
    input   [2:0]               m_ARSIZE,
    input   [1:0]               m_ARBURST,
    input                       m_ARLOCK,
    input   [3:0]               m_ARCACHE,
    input   [2:0]               m_ARPROT,
    input   [3:0]               m_ARQOS,
    input   [3:0]               m_ARREGION,
    input   [USER_WIDTH-1:0]    m_ARUSER,
    input                       m_ARVALID,
    output                      m_ARREADY,
    
    // R Channel
    output  [ID_WIDTH-1:0]      m_RID,
    output  reg[DATA_WIDTH-1:0] m_RDATA,
    output  [1:0]               m_RRESP,
    output                      m_RLAST,
    output  [USER_WIDTH-1:0]	m_RUSER,
    output                      m_RVALID,
    input                       m_RREADY,
    
    
    // AXI5 Interface (connect with Cache L2)
    // AW Channel
    output  [ID_WIDTH-1:0]      s_AWID, // use default value: 0x0
    output  [ADDR_WIDTH-1:0]    s_AWADDR,
    output  [7:0]               s_AWLEN,
    output  [2:0]               s_AWSIZE,  // use default value: Data bus width = 32-bit -> AWSIZE = 0x2
    output  [1:0]               s_AWBURST, // use default value: 0x1, INCR
    output                      s_AWLOCK,
    output  [3:0]               s_AWCACHE,
    output  [2:0]               s_AWPROT,
    output  [3:0]               s_AWQOS,
    output  [3:0]               s_AWREGION,
    output  [USER_WIDTH-1:0]    s_AWUSER,   
    output                      s_AWVALID,
    input                       s_AWREADY,
    
    // W Channel
    output  [DATA_WIDTH-1:0]    s_WDATA,
    output  [STRB_WIDTH-1:0]    s_WSTRB,  // use default value: 0xF
    output                      s_WLAST,
    output  [USER_WIDTH-1:0]    s_WUSER,
    output                      s_WVALID,
    input                       s_WREADY,
    
    // B Channel
    input   [ID_WIDTH-1:0]      s_BID,  // use default value: 0x0
    input   [1:0]               s_BRESP,  
    input	[USER_WIDTH-1:0]    s_BUSER,
    input                       s_BVALID,
    output                      s_BREADY,
    
    // AR Channel
    output  [ID_WIDTH-1:0]      s_ARID, // use default value: 0x0
    output  [ADDR_WIDTH-1:0]    s_ARADDR,
    output  [7:0]               s_ARLEN,
    output  [2:0]               s_ARSIZE,  // use default value: Data bus width = 32-bit -> ARSIZE = 0x2
    output  [1:0]               s_ARBURST, // use default value: 0x1, INCR  
    output                      s_ARLOCK,
    output  [3:0]               s_ARCACHE,
    output  [2:0]               s_ARPROT,
    output  [3:0]               s_ARQOS,
    output  [3:0]               s_ARREGION,
    output  [USER_WIDTH-1:0]    s_ARUSER,
    output                      s_ARVALID,
    input                       s_ARREADY,
    
    // R Channel
    input   [ID_WIDTH-1:0]      s_RID,  // use default value: 0x0
    input   [DATA_WIDTH-1:0]    s_RDATA,
    input   [1:0]               s_RRESP,
    input                       s_RLAST,
    input	[USER_WIDTH-1:0]	s_RUSER,
    input                       s_RVALID,
    output                      s_RREADY
);

    // internal register to store captured signals
    // signals CPU --> Cache L1
    reg [ID_WIDTH-1:0]   m_AWID_reg;
    reg [ADDR_WIDTH-1:0] m_AWADDR_reg;
    reg [2:0]            m_AWSIZE_reg;
    reg [DATA_WIDTH-1:0] m_WDATA_reg;
    reg [STRB_WIDTH-1:0] m_WSTRB_reg;
    
    reg [ID_WIDTH-1:0]   m_ARID_reg;
    reg [ADDR_WIDTH-1:0] m_ARADDR_reg;
    reg [2:0]            m_ARSIZE_reg;
    reg instr_type;
    
    // signals Cache L1 --> Cache L2
    reg [ADDR_WIDTH-1:0] s_AWADDR_reg;
    reg [ADDR_WIDTH-1:0] s_ARADDR_reg;
    
    // internal wires
    // for cache_controller
    wire data_w_en;
    wire plrut_w_en;
    
    // wire mem_wb;
    wire mem_fetch;
    wire is_mem_fetch;
    wire w_data_sel;
    
    wire state_tag_w_en;
    wire cpu_m_aw_in_reg_en;
    wire cpu_m_w_in_reg_en;
    wire cpu_m_ar_in_reg_en;
    wire mem_s_aw_out_reg_en;
    wire mem_s_ar_out_reg_en;
    
    // for state_tag_ram
    wire w_en_w0, w_en_w1, w_en_w2, w_en_w3;
    wire [1:0]  r_state_w0, r_state_w1, r_state_w2, r_state_w3;
    wire [21:0] r_tag_w0, r_tag_w1, r_tag_w2, r_tag_w3;
    
    // for checker_port1
    wire [21:0] tag;
    wire [3:0]  set;
    wire [1:0] hit_way;
    wire hit;
    wire full;
    wire [3:0] valid;
    wire [1:0] hit_way_state;

    // for PLRUt_controller
    wire [1:0] access_way;
    wire [2:0] r_PLRUt;
    wire [2:0] w_PLRUt;
    
    // for state controller
    wire dirty;
    wire [1:0] next_state;
    
    // data_mem
    wire [DATA_WIDTH-1:0] w_data;
    wire [9:0] w_addr;
    wire [STRB_WIDTH-1:0] m_strobe;
    wire [3:0] word_offset, w_word_offset, control_offset;
    wire [9:0] r_addr;
    wire [DATA_WIDTH-1:0] r_data;
    wire [21:0] wb_tag;
    wire [ADDR_WIDTH-1:0] wb_addr;
    
    assign {tag, set} = instr_type ? m_AWADDR_reg[31:6] : m_ARADDR_reg[31:6];
    
    assign word_offset = instr_type ? m_AWADDR_reg[5:2] : m_ARADDR_reg[5:2];
    assign w_word_offset = mem_fetch ? control_offset : word_offset;
    assign m_strobe = mem_fetch ? 4'hF : m_WSTRB_reg;
    
    assign w_data = w_data_sel ? s_RDATA : m_WDATA_reg;
    assign w_addr = {set, access_way, w_word_offset};
    assign r_addr = {set, access_way, w_word_offset};
    
    wire [1:0] byte_offset;
    assign byte_offset = m_ARADDR_reg[1:0];
    always @(*) begin
        case (m_ARSIZE_reg)
            3'b000: begin // 1 byte access
                case (byte_offset)
                    2'b00: m_RDATA = {24'b0, r_data[7:0]};
                    2'b01: m_RDATA = {24'b0, r_data[15:8]};
                    2'b10: m_RDATA = {24'b0, r_data[23:16]};
                    2'b11: m_RDATA = {24'b0, r_data[31:24]};
                    default: m_RDATA = 32'b0;
                endcase
            end
    
            3'b001: begin // 2 byte access (half-word), aligned to 2 bytes
                case (byte_offset)
                    2'b00: m_RDATA = {16'b0, r_data[15:0]};
                    2'b10: m_RDATA = {16'b0, r_data[31:16]};
                    default: m_RDATA = 32'b0; // misaligned half-word (optional: handle separately)
                endcase
            end
    
            3'b010: begin // 4 byte access (word), must be 4-byte aligned
                if (byte_offset == 2'b00)
                    m_RDATA = r_data;
                else
                    m_RDATA = 32'b0; // misaligned word (optional: handle separately)
            end
    
            default: m_RDATA = 32'b0; // unsupported ARSIZE
        endcase
        m_RDATA = {32{m_RVALID}} & m_RDATA;
    end
    // assign m_RDATA = r_data;
    assign s_WDATA = r_data;
    
    assign wb_tag = (access_way == 2'b00) ? r_tag_w0 : (access_way == 2'b01) ? r_tag_w1 : (access_way == 2'b10) ? r_tag_w2 : (access_way == 2'b11) ? r_tag_w3 : r_tag_w0;
    assign wb_addr = {wb_tag, set, 6'b000000};
    
    // assign output
    assign s_ARADDR = s_ARADDR_reg;
    assign s_AWADDR = s_AWADDR_reg;
    
    always @(posedge ACLK) begin
        if (!ARESETn) begin
            // registers CPU --> Cache L1
            m_AWID_reg <= 0;
            m_AWADDR_reg <= 0;
            m_AWSIZE_reg <= 0;
            m_WDATA_reg <= 0;
            m_WSTRB_reg <= 0;
            
            m_ARID_reg <= 0;
            m_ARADDR_reg <= 0;
            m_ARSIZE_reg <= 0;
            instr_type <= 0;
            // registers Cache L1 --> Cache L2
            s_AWADDR_reg <= 0;
            s_ARADDR_reg <= 0;
            // registers Other Cache L1 --> Cache L1
        end
        else begin
            // registers CPU <--> Cache L1
            if (cpu_m_aw_in_reg_en) begin 
                m_AWID_reg <= m_AWID;
                m_AWADDR_reg <= m_AWADDR;
                m_AWSIZE_reg <= m_AWSIZE;
                instr_type <= 1;
            end
            if (cpu_m_w_in_reg_en) begin
                m_WDATA_reg <= m_WDATA;
                m_WSTRB_reg <= m_WSTRB;
            end
            if (cpu_m_ar_in_reg_en) begin
                m_ARID_reg <= m_ARID;
                m_ARADDR_reg <= m_ARADDR; 
                m_ARSIZE_reg <= m_ARSIZE;
                instr_type <= 0;
            end  
            
            // registers Cache L1 --> Cache L2
            if (mem_s_aw_out_reg_en) begin
                s_AWADDR_reg <= wb_addr;
            end
            
            if (mem_s_ar_out_reg_en) begin
                s_ARADDR_reg <= instr_type ? {m_AWADDR_reg[31:6], 6'b000000} : {m_ARADDR_reg[31:6], 6'b000000};
            end
        end
    end
    
    // instance sub-modules
    // instance 4-Way: way0, way1, way2, way3
    instr_state_tag_ram   way0
    (
        .clk(ACLK), .rst_n(ARESETn),       // input 
        .w_en       (w_en_w0),               // input
        .w_state_tag({next_state, tag}),        // input
        .rw_addr    (set),            // input
        .r_state_tag({r_state_w0, r_tag_w0})        // output
    );
    
    instr_state_tag_ram   way1
    (
        .clk(ACLK), .rst_n(ARESETn),       // input 
        .w_en       (w_en_w1),               // input
        .w_state_tag({next_state, tag}),        // input
        .rw_addr    (set),            // input
        .r_state_tag({r_state_w1, r_tag_w1})        // output
    );
    
    instr_state_tag_ram   way2
    (
        .clk(ACLK), .rst_n(ARESETn),       // input 
        .w_en       (w_en_w2),               // input
        .w_state_tag({next_state, tag}),        // input
        .rw_addr    (set),            // input
        .r_state_tag({r_state_w2, r_tag_w2})        // output
    );
    
    instr_state_tag_ram   way3
    (
        .clk(ACLK), .rst_n(ARESETn),       // input 
        .w_en       (w_en_w3),               // input
        .w_state_tag({next_state, tag}),        // input
        .rw_addr    (set),            // input
        .r_state_tag({r_state_w3, r_tag_w3})        // output
    );
    
    // to check whether hit/miss when request coming from CPU
    instr_checker   checker_cpu_port
    (
        .tag_compare(tag),         // input
                                // input
        .tag_w0(r_tag_w0),              // input
        .tag_w1(r_tag_w1),              // input
        .tag_w2(r_tag_w2),              // input
        .tag_w3(r_tag_w3),              // input
                                // input
        .state_w0(r_state_w0),            // input
        .state_w1(r_state_w1),            // input
        .state_w2(r_state_w2),            // input
        .state_w3(r_state_w3),            // input
        
        .state_tag_w_en(state_tag_w_en),      // input
        .way(access_way),                 // input
        
        // write enable in state_tag_ram
        .w_en_w0(w_en_w0),             // output
        .w_en_w1(w_en_w1),             // output
        .w_en_w2(w_en_w2),             // output
        .w_en_w3(w_en_w3),             // output
                                
        .hit(hit),                 // output
        .hit_way(hit_way),             // output
        .full(full),                // output
        .valid(valid),               // output
        .hit_way_state(hit_way_state)        // output
    );
    
    // to store data in cache
    instr_data_ram    cache_data_ram
    (
        .clk(ACLK), .rst_n(ARESETn),       // input
        .w_en(data_w_en),                // input
        // .w_be(4'hF),
        .w_be(m_strobe),             // implement strobes to support writing 1-byte, 2-byte, 4-byte for sb, shw, sw instr
        .w_data(w_data),              // input
        .w_addr(w_addr),              // input    // address = {set, way, word offset}
        .r_addr(r_addr),             // input
        .r_data(r_data)              // output
    );
    
    // to store 3-bit PLRUt for 4-Way Set Associative Cache
    plrut_ram   plrut_ram
    (
        .clk(ACLK), .rst_n(ARESETn),       // input    
        .w_en(plrut_w_en),                // input    
        .w_plrut(w_PLRUt),             // input
        .w_addr(set),              // input    // using addr[9:6] to access
        .r_addr(set),              // input
        .r_plrut(r_PLRUt)              // output
    );
    
    // to deter which is the selected way to access, evict, ...
    plrut_controller    plrut_controller
    (
        .hit(hit),                 // input
        .full(full),                // input
        .valid(valid),               // input
        .hit_way(hit_way),             // input
        .current_PLRUt(r_PLRUt),       // input
        
        .next_PLRUt(w_PLRUt),          // output
        .access_way(access_way)           // output
    );
    
    // to determine the next state of I-Cache
    instr_state_controller state_controller
    (
        .hit_way_state(hit_way_state),     // both hit_way and evicted_way
        .hit          (hit          ),
        .instr_type   (instr_type   ),               // read = 0, write = 1
        .is_mem_fetch (is_mem_fetch ),
       
        .is_dirty     (dirty        ),
        .next_state   (next_state   )
    );
    
    // cache controller - used to control the access of CPU
    instr_cache_controller
    #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH),
        .ID_WIDTH  (ID_WIDTH),
        .USER_WIDTH(USER_WIDTH),
        .STRB_WIDTH(DATA_WIDTH/8),
        .ADDR_START(ADDR_START), // start address of shareable region
        .ADDR_END(ADDR_END) // end address of shareable region
    )
    cache_controller
    (
        // system signals
        .ACLK(ACLK),
        .ARESETn(ARESETn),
        .ENABLE(ENABLE),
        .CACHE_HIT(CACHE_HIT),
        .CACHE_BUSY(CACHE_BUSY),
        
        // AXI5 Interface (connect with CPU)
        // AW Channel
        .m_AWID(m_AWID_reg),
        .m_AWLEN(m_AWLEN),
        .m_AWSIZE(m_AWSIZE),
        .m_AWBURST(m_AWBURST),
        .m_AWLOCK(m_AWLOCK),
        .m_AWCACHE(m_AWCACHE), 
        .m_AWPROT(m_AWPROT),
        .m_AWQOS(m_AWQOS),
        .m_AWREGION(m_AWREGION),
        .m_AWUSER(m_AWUSER),
        .m_AWVALID(m_AWVALID),
        .m_AWREADY(m_AWREADY),
        // input   [ADDR_WIDTH-1:0] m_AWADDR,
        
        // W Channel
        .m_WLAST(m_WLAST),
        // input   [DATA_WIDTH-1:0] m_WDATA(),
        .m_WSTRB(m_WSTRB), // use default value: 0xF
        .m_WUSER(m_WUSER),
        .m_WVALID(m_WVALID),
        .m_WREADY(m_WREADY),
        
        // B Channel
        .m_BID(m_BID),
        .m_BRESP(m_BRESP),
        .m_BUSER(m_BUSER),
        .m_BVALID(m_BVALID),
        .m_BREADY(m_BREADY),
        
        // AR Channel
        .m_ARID(m_ARID_reg),
        .m_ARLEN(m_ARLEN),
        .m_ARSIZE(m_ARSIZE),
        .m_ARBURST(m_ARBURST),
        .m_ARLOCK(m_ARLOCK),
        .m_ARCACHE(m_ARCACHE),
        .m_ARPROT(m_ARPROT),
        .m_ARQOS(m_ARQOS),
        .m_ARREGION(m_ARREGION),
        .m_ARUSER(m_ARUSER),  
        // .m_ARADDR(m_ARADDR_reg),
        .m_ARVALID(m_ARVALID),
        .m_ARREADY(m_ARREADY),
        
        // R Channel
        .m_RID(m_RID),  
        .m_RRESP(m_RRESP),
        .m_RLAST(m_RLAST),
        .m_RUSER(m_RUSER),
        .m_RVALID(m_RVALID),
        .m_RREADY(m_RREADY),
        // output  [DATA_WIDTH-1:0] m_RDATA(),
        
        
        // AXI5 Interface (connect with Cache L2)
        // AW Channel
        .s_AWID(s_AWID), // use default value: 0x0
        .s_AWLEN(s_AWLEN),
        .s_AWSIZE(s_AWSIZE),  // use default value: Data bus width = 32-bit -> AWSIZE = 0x2
        .s_AWBURST(s_AWBURST), // use default value: 0x1(), INCR 
        .s_AWLOCK(s_AWLOCK),
        .s_AWCACHE(s_AWCACHE),
        .s_AWPROT(s_AWPROT),
        .s_AWQOS(s_AWQOS),
        .s_AWREGION(s_AWREGION),
        .s_AWUSER(s_AWUSER),
        .s_AWVALID(s_AWVALID),
        .s_AWREADY(s_AWREADY),
        
        // W Channel
        // .s_WID(s_WID),  // use default value: 0x0
        // output  [DATA_WIDTH-1:0] s_WDATA(),
        .s_WSTRB(s_WSTRB),  // use default value: 0xF
        .s_WLAST(s_WLAST),
        .s_WUSER(s_WUSER),
        .s_WVALID(s_WVALID),
        .s_WREADY(s_WREADY),
        
        // B Channel
        .s_BID(s_BID),  // use default value: 0x0
        .s_BRESP(s_BRESP),  
        .s_BUSER(s_BUSER),
        .s_BVALID(s_BVALID),
        .s_BREADY(s_BREADY),
        
        // AR Channel
        .s_ARID(s_ARID), // use default value: 0x0
        .s_ARLEN(s_ARLEN),
        .s_ARSIZE(s_ARSIZE),  // use default value: Data bus width = 32-bit -> ARSIZE = 0x2
        .s_ARBURST(s_ARBURST), // use default value: 0x1(), INCR 
        .s_ARLOCK(s_ARLOCK),
        .s_ARCACHE(s_ARCACHE),
        .s_ARPROT(s_ARPROT),
        .s_ARQOS(s_ARQOS),
        .s_ARREGION(s_ARREGION),
        .s_ARUSER(s_ARUSER),
        .s_ARVALID(s_ARVALID),
        .s_ARREADY(s_ARREADY),
        
        // R Channel
        .s_RID(s_RID),  // use default value: 0x0
        // input   [DATA_WIDTH-1:0] s_RDATA(),
        .s_RRESP(s_RRESP),
        .s_RLAST(s_RLAST),
        .s_RUSER(s_RUSER),
        .s_RVALID(s_RVALID),
        .s_RREADY(s_RREADY),
        
        // signals to control datapath
        .hit(hit),
        .dirty(dirty),
        .full(full),
        .instr_type(instr_type),   // read = 0, write = 1
        
        // .mem_wb(mem_wb),
        .plrut_w_en(plrut_w_en),
        .state_tag_w_en(state_tag_w_en),
        .data_w_en(data_w_en),
        
        .mem_fetch(mem_fetch),
        .control_offset(control_offset),
        .w_data_sel(w_data_sel),
        .is_mem_fetch(is_mem_fetch),
        
        .cpu_m_aw_in_reg_en(cpu_m_aw_in_reg_en),
        .cpu_m_w_in_reg_en(cpu_m_w_in_reg_en),
        .cpu_m_ar_in_reg_en(cpu_m_ar_in_reg_en),
        
        .mem_s_aw_out_reg_en(mem_s_aw_out_reg_en),
        .mem_s_ar_out_reg_en(mem_s_ar_out_reg_en)
    );

endmodule
