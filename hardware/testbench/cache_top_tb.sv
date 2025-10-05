`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// this testbench is used to verify single_core_cache
//////////////////////////////////////////////////////////////////////////////////

`include "subsystem_pkg.sv"
import subsystem_pkg::*;

module cache_top_tb
#(
    parameter ID_A        = 0,
    parameter DATA_WIDTH  = 32,
    parameter ADDR_WIDTH  = 32,
    parameter ID_WIDTH    = 1,
    parameter USER_WIDTH  = 4,
    parameter STRB_WIDTH  = (DATA_WIDTH/8),
    parameter SHAREABLE_REGION_START = 32'h0002_0000, // start address of shareable region
    parameter SHAREABLE_REGION_END   = 32'h0003_FFFF,  // end address of shareable region
    // input files
    parameter IMEM_A = "D:/University/KLTN/hw_design/coherence_cache/coherence_cache.srcs/sim_1/new/instr_mem_A.mem",
    parameter DMEM_INIT = "D:/University/KLTN/hw_design/coherence_cache/coherence_cache.srcs/sim_1/new/main_memory_init.mem",
    // output files
    parameter DMEM_RESULT = "D:/University/KLTN/hw_design/coherence_cache/coherence_cache.srcs/sim_1/new/main_memory_result.mem",
    parameter STATE_TAG_A = "D:/University/KLTN/hw_design/coherence_cache/coherence_cache.srcs/sim_1/new/state_tag_A.mem",
    parameter PLRUT_RAM_A = "D:/University/KLTN/hw_design/coherence_cache/coherence_cache.srcs/sim_1/new/plrut_ram_A.mem",
    parameter DATA_RAM_A = "D:/University/KLTN/hw_design/coherence_cache/coherence_cache.srcs/sim_1/new/data_ram_A.mem",
    parameter READ_DATA_A = "D:/University/KLTN/hw_design/coherence_cache/coherence_cache.srcs/sim_1/new/read_data_A.mem"
)
();

    bit SystemClock;
    
    // Instantiate the interface with custom parameters
    dual_core_cache_if 
    #(
        .DATA_WIDTH (DATA_WIDTH),
        .ADDR_WIDTH (ADDR_WIDTH),
        .ID_WIDTH   (ID_WIDTH  ),
        .USER_WIDTH (USER_WIDTH),
        .STRB_WIDTH (DATA_WIDTH/8),
        .SHAREABLE_REGION_START (SHAREABLE_REGION_START), // start address of shareable region
        .SHAREABLE_REGION_END   (SHAREABLE_REGION_END  ),  // end address of shareable region
        // output files
        .STATE_TAG_A(STATE_TAG_A),
        .STATE_TAG_B(),
        .PLRUT_RAM_A(PLRUT_RAM_A),
        .PLRUT_RAM_B(),
        .DATA_RAM_A (DATA_RAM_A ),
        .DATA_RAM_B ()
    ) m_if (.ACLK(SystemClock)); // Connect clock signal
    
    initial begin
        forever
            #6.25 SystemClock = ~SystemClock;
    end
    
    initial begin
        $display("[%0t(ns)] Start simulation!", $time);
        m_if.reset_n();
        cpuA.load_instr_mem();
        main_memory.load_mem();
        
        fork
            begin
                cpuA.run();
            end
            begin
                main_memory.run();
            end
        join_any
        
        repeat(1000) @(m_if.drv_cb);
        $display("[%0t(ns)] Start saving simulation result!", $time);
        cpuA.save_read_data();
        m_if.save_single_cache(
            cacheA.way0.state_tag_ram,
            cacheA.way1.state_tag_ram,
            cacheA.way2.state_tag_ram,
            cacheA.way3.state_tag_ram,
            
            cacheA.plrut_ram.plrut_ram,
           
            cacheA.cache_data_ram.cache
            );
        main_memory.save_mem();
        $display("[%0t(ns)] Finish saving simulation result!", $time);
        $display("[%0t(ns)] Finish simulation!", $time);
    end
    
    processor
    #(
        .ID        (ID_A),
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH),
        .ID_WIDTH  (ID_WIDTH  ),
        .USER_WIDTH(USER_WIDTH),
        .STRB_WIDTH(DATA_WIDTH/8),
        .SHAREABLE_REGION_START(SHAREABLE_REGION_START), // start address of shareable region
        .SHAREABLE_REGION_END  (SHAREABLE_REGION_END  ),  // end address of shareable region
        // input files
        .IMEM(IMEM_A),
        // output files
        .READ_DATA(READ_DATA_A)
    )
    cpuA
    (
//        // system signals
//        .ACLK       (m_if.ACLK   ),
//        .ARESETn    (m_if.ARESETn),
        
//        // AW Channel
//        .AWID       (m_if.m0_AWID    ),
//        .AWADDR     (m_if.m0_AWADDR  ),
//        .AWLEN      (m_if.m0_AWLEN   ),
//        .AWSIZE     (m_if.m0_AWSIZE  ),
//        .AWBURST    (m_if.m0_AWBURST ),
//        .AWLOCK     (m_if.m0_AWLOCK  ),
//        .AWCACHE    (m_if.m0_AWCACHE ),
//        .AWPROT     (m_if.m0_AWPROT  ),
//        .AWQOS      (m_if.m0_AWQOS   ),
//        .AWREGION   (m_if.m0_AWREGION),
//        .AWUSER     (m_if.m0_AWUSER  ),
//        .AWDOMAIN   (m_if.m0_AWDOMAIN),
//        .AWVALID    (m_if.m0_AWVALID ),
//        .AWREADY    (m_if.m0_AWREADY ),
        
//        // W Channel
//        .WDATA      (m_if.m0_WDATA ),
//        .WSTRB      (m_if.m0_WSTRB ), // use default value: 0xF
//        .WLAST      (m_if.m0_WLAST ),
//        .WUSER      (m_if.m0_WUSER ),
//        .WVALID     (m_if.m0_WVALID),
//        .WREADY     (m_if.m0_WREADY),
        
//        // B Channel
//        .BID        (m_if.m0_BID   ),
//        .BRESP      (m_if.m0_BRESP ),
//        .BUSER      (m_if.m0_BUSER ),
//        .BVALID     (m_if.m0_BVALID),
//        .BREADY     (m_if.m0_BREADY),
        
//        // AR Channel
//        .ARID       (m_if.m0_ARID    ),
//        .ARADDR     (m_if.m0_ARADDR  ),
//        .ARLEN      (m_if.m0_ARLEN   ),
//        .ARSIZE     (m_if.m0_ARSIZE  ),
//        .ARBURST    (m_if.m0_ARBURST ),
//        .ARLOCK     (m_if.m0_ARLOCK  ),
//        .ARCACHE    (m_if.m0_ARCACHE ),
//        .ARPROT     (m_if.m0_ARPROT  ),
//        .ARQOS      (m_if.m0_ARQOS   ),
//        .ARREGION   (m_if.m0_ARREGION),
//        .ARUSER     (m_if.m0_ARUSER  ),
//        .ARDOMAIN   (m_if.m0_ARDOMAIN),
//        .ARVALID    (m_if.m0_ARVALID ),
//        .ARREADY    (m_if.m0_ARREADY ),
        
//        // R Channel
//        .RID        (m_if.m0_RID   ),
//        .RDATA      (m_if.m0_RDATA ),
//        .RRESP      (m_if.m0_RRESP ),
//        .RLAST      (m_if.m0_RLAST ),
//        .RUSER      (m_if.m0_RUSER ),
//        .RVALID     (m_if.m0_RVALID),
//        .RREADY     (m_if.m0_RREADY)
        .m_if(m_if)
    );
    
    // instance single cache here
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
        .ACLK       (m_if.ACLK   ),
        .ARESETn    (m_if.ARESETn),
        .ENABLE     (m_if.m0_ENABLE    ),
        .CACHE_HIT  (m_if.m0_CACHE_HIT ),
        .CACHE_BUSY (m_if.m0_CACHE_BUSY),
        
        // AXI5 Interface (connect with CPU)
        // AW Channel
        .m_AWID     (m_if.m0_AWID    ),
        .m_AWADDR   (m_if.m0_AWADDR  ),
        .m_AWLEN    (m_if.m0_AWLEN   ),
        .m_AWSIZE   (m_if.m0_AWSIZE  ),
        .m_AWBURST  (m_if.m0_AWBURST ),
        .m_AWLOCK   (m_if.m0_AWLOCK  ),
        .m_AWCACHE  (m_if.m0_AWCACHE ),
        .m_AWPROT   (m_if.m0_AWPROT  ),
        .m_AWQOS    (m_if.m0_AWQOS   ),
        .m_AWREGION (m_if.m0_AWREGION),
        .m_AWUSER   (m_if.m0_AWUSER  ),
        .m_AWDOMAIN (m_if.m0_AWDOMAIN),
        .m_AWVALID  (m_if.m0_AWVALID ),
        .m_AWREADY  (m_if.m0_AWREADY ),
        
        // W Channel
        // input                       m_WID(),
        .m_WDATA    (m_if.m0_WDATA ),
        .m_WSTRB    (m_if.m0_WSTRB ), // use default value: 0xF
        .m_WLAST    (m_if.m0_WLAST ),
        .m_WUSER    (m_if.m0_WUSER ),
        .m_WVALID   (m_if.m0_WVALID),
        .m_WREADY   (m_if.m0_WREADY),
        
        // B Channel
        
        .m_BID      (m_if.m0_BID   ),
        .m_BRESP    (m_if.m0_BRESP ),
        .m_BUSER    (m_if.m0_BUSER ),
        .m_BVALID   (m_if.m0_BVALID),
        .m_BREADY   (m_if.m0_BREADY),
        
        // AR Channel
        .m_ARID     (m_if.m0_ARID    ),
        .m_ARADDR   (m_if.m0_ARADDR  ),
        .m_ARLEN    (m_if.m0_ARLEN   ),
        .m_ARSIZE   (m_if.m0_ARSIZE  ),
        .m_ARBURST  (m_if.m0_ARBURST ),
        .m_ARLOCK   (m_if.m0_ARLOCK  ),
        .m_ARCACHE  (m_if.m0_ARCACHE ),
        .m_ARPROT   (m_if.m0_ARPROT  ),
        .m_ARQOS    (m_if.m0_ARQOS   ),
        .m_ARREGION (m_if.m0_ARREGION),
        .m_ARUSER   (m_if.m0_ARUSER  ),
        .m_ARDOMAIN (m_if.m0_ARDOMAIN),
        .m_ARVALID  (m_if.m0_ARVALID ),
        .m_ARREADY  (m_if.m0_ARREADY ),
        
        // R Channel
        
        .m_RID      (m_if.m0_RID   ),
        .m_RDATA    (m_if.m0_RDATA ),
        .m_RRESP    (m_if.m0_RRESP ),
        .m_RLAST    (m_if.m0_RLAST ),
        .m_RUSER    (m_if.m0_RUSER ),
        .m_RVALID   (m_if.m0_RVALID),
        .m_RREADY   (m_if.m0_RREADY),
        
        
        // AXI5 Interface (connect with Cache L2)
        // AW Channel
        .s_AWID     (m_if.s_AWID    ), // use default value: 0x0
        .s_AWADDR   (m_if.s_AWADDR  ),
        .s_AWLEN    (m_if.s_AWLEN   ),
        .s_AWSIZE   (m_if.s_AWSIZE  ),  // use default value: Data bus width = 32-bit -> AWSIZE = 0x2
        .s_AWBURST  (m_if.s_AWBURST ), // use default value: 0x1(), INCR
        .s_AWLOCK   (m_if.s_AWLOCK  ),
        .s_AWCACHE  (m_if.s_AWCACHE ),
        .s_AWPROT   (m_if.s_AWPROT  ),
        .s_AWQOS    (m_if.s_AWQOS   ),
        .s_AWREGION (m_if.s_AWREGION),
        .s_AWUSER   (m_if.s_AWUSER  ),   
        .s_AWDOMAIN (),
        .s_AWSNOOP  (),
        .s_AWVALID  (m_if.s_AWVALID ),
        .s_AWREADY  (m_if.s_AWREADY ),
        
        // W Channel
        // output  s_WID(),  // use default value: 0x0
        .s_WDATA    (m_if.s_WDATA ),
        .s_WSTRB    (m_if.s_WSTRB ),  // use default value: 0xF
        .s_WLAST    (m_if.s_WLAST ),
        .s_WUSER    (m_if.s_WUSER ),
        .s_WVALID   (m_if.s_WVALID),
        .s_WREADY   (m_if.s_WREADY),
        
        // B Channel
        .s_BID      (m_if.s_BID   ),  // use default value: 0x0
        .s_BRESP    (m_if.s_BRESP ),  
        .s_BUSER    (m_if.s_BUSER ),
        .s_BVALID   (m_if.s_BVALID),
        .s_BREADY   (m_if.s_BREADY),
        
        // AR Channel
        .s_ARID     (m_if.s_ARID    ), // use default value: 0x0
        .s_ARADDR   (m_if.s_ARADDR  ),
        .s_ARLEN    (m_if.s_ARLEN   ),
        .s_ARSIZE   (m_if.s_ARSIZE  ),  // use default value: Data bus width = 32-bit -> ARSIZE = 0x2
        .s_ARBURST  (m_if.s_ARBURST ), // use default value: 0x1(), INCR  
        .s_ARLOCK   (m_if.s_ARLOCK  ),
        .s_ARCACHE  (m_if.s_ARCACHE ),
        .s_ARPROT   (m_if.s_ARPROT  ),
        .s_ARQOS    (m_if.s_ARQOS   ),
        .s_ARREGION (m_if.s_ARREGION),
        .s_ARUSER   (m_if.s_ARUSER  ),
        .s_ARDOMAIN (),
        .s_ARSNOOP  (),
        .s_ARVALID  (m_if.s_ARVALID ),
        .s_ARREADY  (m_if.s_ARREADY ),
        
        // R Channel
        .s_RID      (m_if.s_RID   ),  // use default value: 0x0
        .s_RDATA    (m_if.s_RDATA ),
        .s_RRESP    ({2'b00, m_if.s_RRESP}),
        .s_RLAST    (m_if.s_RLAST ),
        .s_RUSER    (m_if.s_RUSER ),
        .s_RVALID   (m_if.s_RVALID),
        .s_RREADY   (m_if.s_RREADY),
        
        // Snoop Channels
        // AC Channel
        .ACVALID    (),
        .ACADDR     (),
        .ACSNOOP    (),
        .ACPROT     (),
        .ACREADY    (),
        
        // CR Channel
        .CRREADY    (),
        .CRVALID    (),
        .CRRESP     (),
        
        // CD Channel
        .CDREADY    (),
        .CDVALID    (),
        .CDDATA     (),
        .CDLAST     ()
        
        // for demo to fix E-E bug
        // input is_E_E
        // input is_R_R
        ///////////////////////////////////
    );
    
    main_memory
    #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH),
        .ID_WIDTH  (ID_WIDTH  ),
        .USER_WIDTH(USER_WIDTH),
        .STRB_WIDTH(DATA_WIDTH/8),
        .SHAREABLE_REGION_START(SHAREABLE_REGION_START), // start address of shareable region
        .SHAREABLE_REGION_END  (SHAREABLE_REGION_END  ),  // end address of shareable region
        // input files
        .DMEM_INIT  (DMEM_INIT),
        // output files
        .DMEM_RESULT(DMEM_RESULT)
    )
    main_memory
    (
//        // system signals
//        .ACLK       (m_if.ACLK   ),
//        .ARESETn    (m_if.ARESETn),
        
//        // AW Channel
//        .AWID       (m_if.s_AWID    ),
//        .AWADDR     (m_if.s_AWADDR  ),
//        .AWLEN      (m_if.s_AWLEN   ),
//        .AWSIZE     (m_if.s_AWSIZE  ),
//        .AWBURST    (m_if.s_AWBURST ),
//        .AWLOCK     (m_if.s_AWLOCK  ),
//        .AWCACHE    (m_if.s_AWCACHE ),
//        .AWPROT     (m_if.s_AWPROT  ),
//        .AWQOS      (m_if.s_AWQOS   ),
//        .AWREGION   (m_if.s_AWREGION),
//        .AWUSER     (m_if.s_AWUSER  ),
//        .AWVALID    (m_if.s_AWVALID ),
//        .AWREADY    (m_if.s_AWREADY ),
//        // W Channel
//        // input     [ID_WIDTH-1:0]   s_WID(),
//        .WDATA      (m_if.s_WDATA ),
//        .WSTRB      (m_if.s_WSTRB ),
//        .WLAST      (m_if.s_WLAST ),
//        .WUSER      (m_if.s_WUSER ),
//        .WVALID     (m_if.s_WVALID),
//        .WREADY     (m_if.s_WREADY),
//        // B Channel
//        .BID        (m_if.s_BID   ),
//        .BRESP      (m_if.s_BRESP ),
//        .BUSER      (m_if.s_BUSER ),
//        .BVALID     (m_if.s_BVALID),
//        .BREADY     (m_if.s_BREADY),
//        // AR Channel
//        .ARID       (m_if.s_ARID    ),    
//        .ARADDR     (m_if.s_ARADDR  ),
//        .ARLEN      (m_if.s_ARLEN   ),
//        .ARSIZE     (m_if.s_ARSIZE  ),
//        .ARBURST    (m_if.s_ARBURST ),
//        .ARLOCK     (m_if.s_ARLOCK  ),
//        .ARCACHE    (m_if.s_ARCACHE ),
//        .ARPROT     (m_if.s_ARPROT  ),
//        .ARQOS      (m_if.s_ARQOS   ),
//        .ARREGION   (m_if.s_ARREGION),
//        .ARUSER     (m_if.s_ARUSER  ),
//        .ARVALID    (m_if.s_ARVALID ),
//        .ARREADY    (m_if.s_ARREADY ),
//        // R Channel
//        .RID        (m_if.s_RID   ),
//        .RDATA      (m_if.s_RDATA ),
//        .RRESP      (m_if.s_RRESP ),
//        .RLAST      (m_if.s_RLAST ),
//        .RUSER      (m_if.s_RUSER ),
//        .RVALID     (m_if.s_RVALID), 
//        .RREADY     (m_if.s_RREADY)
        .m_if(m_if)
    );

endmodule
