`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// this is tb of memory for axi wrapper testing
//////////////////////////////////////////////////////////////////////////////////


module memory_top_tb
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
    parameter DMEM_INIT = "D:/University/KLTN/hw_design/coherence_cache/coherence_cache.srcs/sources_1/new/mem_init.mem",
    // output files
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
        .STATE_TAG_A(),
        .STATE_TAG_B(),
        .PLRUT_RAM_A(),
        .PLRUT_RAM_B(),
        .DATA_RAM_A (),
        .DATA_RAM_B ()
    ) m_if (.ACLK(SystemClock)); // Connect clock signal
    
    initial begin
        forever
            #6.25 SystemClock = ~SystemClock;
    end
    
    initial begin
        $display("[%0t(ns)] Start simulation!", $time);
        m_if.reset_n();
        cpuA.load_instr_16_mem();
        
        fork
            begin
                cpuA.run_16();
            end
        join_any
        
        repeat(1000) @(m_if.drv_cb);
        $display("[%0t(ns)] Start saving simulation result!", $time);
        cpuA.save_read_data_16();
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
    
    memory
//    #(
//        .DATA_WIDTH(DATA_WIDTH),
//        .ADDR_WIDTH(ADDR_WIDTH),
//        .ID_WIDTH  (ID_WIDTH  ),
//        .USER_WIDTH(USER_WIDTH),
//        .STRB_WIDTH(DATA_WIDTH/8),
//        .INIT_PATH (DMEM_INIT)
//    )
    DUT
    (
        /********* System signals *********/
        .ACLK       (m_if.ACLK   ),
        .ARESETn    (m_if.ARESETn),
        
        /********** Slave Interface **********/
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
        .m_AWVALID  (m_if.m0_AWVALID ),
        .m_AWREADY  (m_if.m0_AWREADY ),
        // W Channel
        // input     [ID_WIDTH-1:0]   m_WID(),
        .m_WDATA    (m_if.m0_WDATA ),
        .m_WSTRB    (m_if.m0_WSTRB ),
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
        .m_ARVALID  (m_if.m0_ARVALID ),
        .m_ARREADY  (m_if.m0_ARREADY ),
        // R Channel
        .m_RID      (m_if.m0_RID   ),
        .m_RDATA    (m_if.m0_RDATA ),
        .m_RRESP    (m_if.m0_RRESP ),
        .m_RLAST    (m_if.m0_RLAST ),
        .m_RUSER    (m_if.m0_RUSER ),
        .m_RVALID   (m_if.m0_RVALID), 
        .m_RREADY   (m_if.m0_RREADY)
    );

endmodule
