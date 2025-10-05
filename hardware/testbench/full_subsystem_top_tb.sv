`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// top most testbench including: CpuA, CpuB, CacheA, CacheB, AXI+Coherence, Mem
//////////////////////////////////////////////////////////////////////////////////


module full_subsystem_top_tb
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
    // input files
    parameter IMEM_A_PATH   = "D:/University/KLTN/hw_design/rtl_project/coherence_cache/coherence_cache.srcs/sources_1/new/imem_A.mem",
    parameter IMEM_B_PATH   = "D:/University/KLTN/hw_design/rtl_project/coherence_cache/coherence_cache.srcs/sources_1/new/imem_B.mem",
    parameter DMEM_INIT   = "D:/University/KLTN/hw_design/rtl_project/coherence_cache/coherence_cache.srcs/sources_1/new/mem_init.mem",
    
    // output files
    parameter STATE_TAG_A = "D:/University/KLTN/hw_design/rtl_project/coherence_cache/coherence_cache.srcs/sim_1/new/state_tag_A.mem",
    parameter STATE_TAG_B = "D:/University/KLTN/hw_design/rtl_project/coherence_cache/coherence_cache.srcs/sim_1/new/state_tag_B.mem",
    parameter PLRUT_RAM_A = "D:/University/KLTN/hw_design/rtl_project/coherence_cache/coherence_cache.srcs/sim_1/new/plrut_ram_A.mem",
    parameter PLRUT_RAM_B = "D:/University/KLTN/hw_design/rtl_project/coherence_cache/coherence_cache.srcs/sim_1/new/plrut_ram_B.mem",
    parameter DATA_RAM_A = "D:/University/KLTN/hw_design/rtl_project/coherence_cache/coherence_cache.srcs/sim_1/new/data_ram_A.mem",
    parameter DATA_RAM_B = "D:/University/KLTN/hw_design/rtl_project/coherence_cache/coherence_cache.srcs/sim_1/new/data_ram_B.mem"
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
        .STATE_TAG_B(STATE_TAG_B),
        .PLRUT_RAM_A(PLRUT_RAM_A),
        .PLRUT_RAM_B(PLRUT_RAM_B),
        .DATA_RAM_A (DATA_RAM_A ),
        .DATA_RAM_B (DATA_RAM_B )
    ) m_if (.ACLK(SystemClock)); // Connect clock signal
    
    initial begin
        forever
            #8 SystemClock = ~SystemClock;
    end
    
    initial begin
        $display("[%0t(ns)] Start simulation!", $time);
        m_if.reset_n();
        repeat(30000) @(m_if.drv_cb);
        $display("[%0t(ns)] Start saving simulation result!", $time);
//        m_if.save_cache(
//            DUT.D_cacheA.way0.state_tag_ram,
//            DUT.D_cacheA.way1.state_tag_ram,
//            DUT.D_cacheA.way2.state_tag_ram,
//            DUT.D_cacheA.way3.state_tag_ram,
            
//            DUT.D_cacheB.way0.state_tag_ram,
//            DUT.D_cacheB.way1.state_tag_ram,
//            DUT.D_cacheB.way2.state_tag_ram,
//            DUT.D_cacheB.way3.state_tag_ram,
            
//            DUT.D_cacheA.plrut_ram.plrut_ram,
//            DUT.D_cacheB.plrut_ram.plrut_ram,
            
//            DUT.D_cacheA.cache_data_ram.cache,
//            DUT.D_cacheB.cache_data_ram.cache,
            
//            DUT.main_memory.umem.mem
//            );
        $display("[%0t(ns)] Finish saving simulation result!", $time);
        $display("[%0t(ns)] Finish simulation!", $time);
    end
    
    full_subsystem
//    #(
//        .DATA_WIDTH(DATA_WIDTH),
//        .ADDR_WIDTH(ADDR_WIDTH),
//        .ID_WIDTH  (ID_WIDTH  ),
//        .USER_WIDTH(USER_WIDTH),
//        .STRB_WIDTH(STRB_WIDTH),
//        .SHAREABLE_REGION_START(SHAREABLE_REGION_START), // start address of shareable region
//        .SHAREABLE_REGION_END  (SHAREABLE_REGION_END  ),  // end address of shareable region
//        .IMEM_A_PATH(IMEM_A_PATH),
//        .IMEM_B_PATH(IMEM_B_PATH),
//        .DMEM_INIT  (DMEM_INIT  )
//    )
    DUT
    (
        // system signals
        .ACLK           (m_if.ACLK   ),
        .ARESETn        (m_if.ARESETn),
        
        // output of D-CacheA
        .m0_D_CACHE_HIT   (m_if.m0_D_CACHE_HIT ),
        .m0_D_CACHE_BUSY  (m_if.m0_D_CACHE_BUSY),
        
        // output of D-CacheB
        .m1_D_CACHE_HIT   (m_if.m1_D_CACHE_HIT ),
        .m1_D_CACHE_BUSY  (m_if.m1_D_CACHE_BUSY),
        
        // output of I-CacheA
        .m0_I_CACHE_HIT   (m_if.m0_I_CACHE_HIT ),
        .m0_I_CACHE_BUSY  (m_if.m0_I_CACHE_BUSY),
        
        // output of I-CacheB
        .m1_I_CACHE_HIT   (m_if.m1_I_CACHE_HIT ),
        .m1_I_CACHE_BUSY  (m_if.m1_I_CACHE_BUSY)
    );

endmodule
