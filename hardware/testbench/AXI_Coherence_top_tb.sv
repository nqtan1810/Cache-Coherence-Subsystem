`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// this testbench is used to verify ACE Interconnect
//////////////////////////////////////////////////////////////////////////////////

`include "subsystem_pkg.sv"
import subsystem_pkg::*;

module axi_coherence_top_tb
#(
    parameter ID_A        = 0,
    parameter ID_B        = 1,
    parameter DATA_WIDTH  = 32,
    parameter ADDR_WIDTH  = 32,
    parameter ID_WIDTH    = 1,
    parameter USER_WIDTH  = 4,
    parameter STRB_WIDTH  = (DATA_WIDTH/8),
    parameter SHAREABLE_REGION_START = 32'h0002_0000, // start address of shareable region
    parameter SHAREABLE_REGION_END   = 32'h0003_FFFF,  // end address of shareable region
    // input files
    parameter IMEM_A = "D:/University/KLTN/hw_design/coherence_cache/coherence_cache.srcs/sim_1/new/instr_mem_A.mem",
    parameter IMEM_B = "D:/University/KLTN/hw_design/coherence_cache/coherence_cache.srcs/sim_1/new/instr_mem_B.mem",
    parameter DMEM_INIT = "D:/University/KLTN/hw_design/coherence_cache/coherence_cache.srcs/sim_1/new/main_memory_init.mem",
    // output files
    parameter DMEM_RESULT = "D:/University/KLTN/hw_design/coherence_cache/coherence_cache.srcs/sim_1/new/main_memory_result.mem",
    parameter READ_DATA_A = "D:/University/KLTN/hw_design/coherence_cache/coherence_cache.srcs/sim_1/new/read_data_A.mem",
    parameter READ_DATA_B = "D:/University/KLTN/hw_design/coherence_cache/coherence_cache.srcs/sim_1/new/read_data_B.mem"  
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
        cpuB.load_instr_16_mem();
        main_memory.load_mem();
        
        fork
            begin
                cpuA.run_16();
            end
            begin
                cpuB.run_16();
            end
            begin
                main_memory.run();
            end
        join_any
        
        repeat(1000) @(m_if.drv_cb);
        $display("[%0t(ns)] Start saving simulation result!", $time);
        cpuA.save_read_data_16();
        cpuB.save_read_data_16();
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
    
    processor
    #(
        .ID        (ID_B),
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH),
        .ID_WIDTH  (ID_WIDTH  ),
        .USER_WIDTH(USER_WIDTH),
        .STRB_WIDTH(DATA_WIDTH/8),
        .SHAREABLE_REGION_START(SHAREABLE_REGION_START), // start address of shareable region
        .SHAREABLE_REGION_END  (SHAREABLE_REGION_END  ),  // end address of shareable region
        // input files
        .IMEM(IMEM_B),
        // output files
        .READ_DATA(READ_DATA_B)
    )
    cpuB
    (
//        // system signals
//        .ACLK       (m_if.ACLK   ),
//        .ARESETn    (m_if.ARESETn),
        
//        // AW Channel
//        .AWID       (m_if.m1_AWID    ),
//        .AWADDR     (m_if.m1_AWADDR  ),
//        .AWLEN      (m_if.m1_AWLEN   ),
//        .AWSIZE     (m_if.m1_AWSIZE  ),
//        .AWBURST    (m_if.m1_AWBURST ),
//        .AWLOCK     (m_if.m1_AWLOCK  ),
//        .AWCACHE    (m_if.m1_AWCACHE ),
//        .AWPROT     (m_if.m1_AWPROT  ),
//        .AWQOS      (m_if.m1_AWQOS   ),
//        .AWREGION   (m_if.m1_AWREGION),
//        .AWUSER     (m_if.m1_AWUSER  ),
//        .AWDOMAIN   (m_if.m1_AWDOMAIN),
//        .AWVALID    (m_if.m1_AWVALID ),
//        .AWREADY    (m_if.m1_AWREADY ),
        
//        // W Channel
//        .WDATA      (m_if.m1_WDATA ),
//        .WSTRB      (m_if.m1_WSTRB ), // use default value: 0xF
//        .WLAST      (m_if.m1_WLAST ),
//        .WUSER      (m_if.m1_WUSER ),
//        .WVALID     (m_if.m1_WVALID),
//        .WREADY     (m_if.m1_WREADY),
        
//        // B Channel
//        .BID        (m_if.m1_BID   ),
//        .BRESP      (m_if.m1_BRESP ),
//        .BUSER      (m_if.m1_BUSER ),
//        .BVALID     (m_if.m1_BVALID),
//        .BREADY     (m_if.m1_BREADY),
        
//        // AR Channel
//        .ARID       (m_if.m1_ARID    ),
//        .ARADDR     (m_if.m1_ARADDR  ),
//        .ARLEN      (m_if.m1_ARLEN   ),
//        .ARSIZE     (m_if.m1_ARSIZE  ),
//        .ARBURST    (m_if.m1_ARBURST ),
//        .ARLOCK     (m_if.m1_ARLOCK  ),
//        .ARCACHE    (m_if.m1_ARCACHE ),
//        .ARPROT     (m_if.m1_ARPROT  ),
//        .ARQOS      (m_if.m1_ARQOS   ),
//        .ARREGION   (m_if.m1_ARREGION),
//        .ARUSER     (m_if.m1_ARUSER  ),
//        .ARDOMAIN   (m_if.m1_ARDOMAIN),
//        .ARVALID    (m_if.m1_ARVALID ),
//        .ARREADY    (m_if.m1_ARREADY ),
        
//        // R Channel
//        .RID        (m_if.m1_RID   ),
//        .RDATA      (m_if.m1_RDATA ),
//        .RRESP      (m_if.m1_RRESP ),
//        .RLAST      (m_if.m1_RLAST ),
//        .RUSER      (m_if.m1_RUSER ),
//        .RVALID     (m_if.m1_RVALID),
//        .RREADY     (m_if.m1_RREADY)
        .m_if(m_if)
    );
    
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
        .ACLK       (m_if.ACLK   ),
        .ARESETn    (m_if.ARESETn),
        /********** Master 0 side **********/
        // AW Channel
        .m0_AWID    (m_if.m0_AWID    ),
        .m0_AWADDR  (m_if.m0_AWADDR  ),
        .m0_AWLEN   (m_if.m0_AWLEN   ),
        .m0_AWSIZE  (m_if.m0_AWSIZE  ),
        .m0_AWBURST (m_if.m0_AWBURST ),
        .m0_AWLOCK  (m_if.m0_AWLOCK  ),
        .m0_AWCACHE (m_if.m0_AWCACHE ),
        .m0_AWPROT  (m_if.m0_AWPROT  ),
        .m0_AWQOS   (m_if.m0_AWQOS   ),
        .m0_AWREGION(m_if.m0_AWREGION),
        .m0_AWUSER  (m_if.m0_AWUSER  ),
        .m0_AWDOMAIN(m_if.m0_AWDOMAIN),
        .m0_AWSNOOP (3'h0),
        .m0_AWVALID (m_if.m0_AWVALID ),
        .m0_AWREADY (m_if.m0_AWREADY ),
        // W Channel
        // input      [ID_WIDTH-1:0]   m0_WID(),
        .m0_WDATA   (m_if.m0_WDATA ),
        .m0_WSTRB   (m_if.m0_WSTRB ),
        .m0_WLAST   (m_if.m0_WLAST ),
        .m0_WUSER   (m_if.m0_WUSER ),
        .m0_WVALID  (m_if.m0_WVALID),
        .m0_WREADY  (m_if.m0_WREADY),
        // B Channel
        .m0_BID     (m_if.m0_BID   ),
        .m0_BRESP   (m_if.m0_BRESP ),
        .m0_BUSER   (m_if.m0_BUSER ),
        .m0_BVALID  (m_if.m0_BVALID),
        .m0_BREADY  (m_if.m0_BREADY),
        // AR Channel
        .m0_ARID    (m_if.m0_ARID    ),
        .m0_ARADDR  (m_if.m0_ARADDR  ),
        .m0_ARLEN   (m_if.m0_ARLEN   ),
        .m0_ARSIZE  (m_if.m0_ARSIZE  ),
        .m0_ARBURST (m_if.m0_ARBURST ),
        .m0_ARLOCK  (m_if.m0_ARLOCK  ),
        .m0_ARCACHE (m_if.m0_ARCACHE ),
        .m0_ARPROT  (m_if.m0_ARPROT  ),
        .m0_ARQOS   (m_if.m0_ARQOS   ),
        .m0_ARREGION(m_if.m0_ARREGION),
        .m0_ARUSER  (m_if.m0_ARUSER  ),
        .m0_ARDOMAIN(m_if.m0_ARDOMAIN),
        .m0_ARSNOOP (4'h0),
        .m0_ARVALID (m_if.m0_ARVALID ),
        .m0_ARREADY (m_if.m0_ARREADY ),
        // R Channel
        .m0_RID     (m_if.m0_RID   ),
        .m0_RDATA   (m_if.m0_RDATA ),
        .m0_RRESP   (m_if.m0_RRESP ),
        .m0_RLAST   (m_if.m0_RLAST ),
        .m0_RUSER   (m_if.m0_RUSER ),
        .m0_RVALID  (m_if.m0_RVALID),
        .m0_RREADY  (m_if.m0_RREADY),
        // Snoop Channels
        // AC Channel
        .m0_ACVALID (),
        .m0_ACADDR  (),
        .m0_ACSNOOP (),
        .m0_ACPROT  (),
        .m0_ACREADY (),
        
        // CR Channel
        .m0_CRREADY (),
        .m0_CRVALID (),
        .m0_CRRESP  (),
        
        // CD Channel
        .m0_CDREADY (),
        .m0_CDVALID (),
        .m0_CDDATA  (),
        .m0_CDLAST  (),
        
        /********** Master 1 side **********/
        // AW Channel
        .m1_AWID    (m_if.m1_AWID    ),
        .m1_AWADDR  (m_if.m1_AWADDR  ),
        .m1_AWLEN   (m_if.m1_AWLEN   ),
        .m1_AWSIZE  (m_if.m1_AWSIZE  ),
        .m1_AWBURST (m_if.m1_AWBURST ),
        .m1_AWLOCK  (m_if.m1_AWLOCK  ),
        .m1_AWCACHE (m_if.m1_AWCACHE ),
        .m1_AWPROT  (m_if.m1_AWPROT  ),
        .m1_AWQOS   (m_if.m1_AWQOS   ),
        .m1_AWREGION(m_if.m1_AWREGION),
        .m1_AWUSER  (m_if.m1_AWUSER  ),
        .m1_AWDOMAIN(m_if.m1_AWDOMAIN),
        .m1_AWSNOOP (3'h0),
        .m1_AWVALID (m_if.m1_AWVALID ),
        .m1_AWREADY (m_if.m1_AWREADY ),
        // W Channel
        // input      [ID_WIDTH-1:0]   m1_WID(),
        .m1_WDATA   (m_if.m1_WDATA ),
        .m1_WSTRB   (m_if.m1_WSTRB ),
        .m1_WLAST   (m_if.m1_WLAST ),
        .m1_WUSER   (m_if.m1_WUSER ),
        .m1_WVALID  (m_if.m1_WVALID),
        .m1_WREADY  (m_if.m1_WREADY),
        // B Channel
        .m1_BID     (m_if.m1_BID   ),
        .m1_BRESP   (m_if.m1_BRESP ),
        .m1_BUSER   (m_if.m1_BUSER ),
        .m1_BVALID  (m_if.m1_BVALID),
        .m1_BREADY  (m_if.m1_BREADY),
        // AR Channel
        .m1_ARID    (m_if.m1_ARID    ),
        .m1_ARADDR  (m_if.m1_ARADDR  ),
        .m1_ARLEN   (m_if.m1_ARLEN   ),
        .m1_ARSIZE  (m_if.m1_ARSIZE  ),
        .m1_ARBURST (m_if.m1_ARBURST ),
        .m1_ARLOCK  (m_if.m1_ARLOCK  ),
        .m1_ARCACHE (m_if.m1_ARCACHE ),
        .m1_ARPROT  (m_if.m1_ARPROT  ),
        .m1_ARQOS   (m_if.m1_ARQOS   ),
        .m1_ARREGION(m_if.m1_ARREGION),
        .m1_ARUSER  (m_if.m1_ARUSER  ),
        .m1_ARDOMAIN(m_if.m1_ARDOMAIN),
        .m1_ARSNOOP (4'h0),
        .m1_ARVALID (m_if.m1_ARVALID ),
        .m1_ARREADY (m_if.m1_ARREADY ),
        // R Channel
        .m1_RID     (m_if.m1_RID   ),
        .m1_RDATA   (m_if.m1_RDATA ),
        .m1_RRESP   (m_if.m1_RRESP ),
        .m1_RLAST   (m_if.m1_RLAST ),
        .m1_RUSER   (m_if.m1_RUSER ),
        .m1_RVALID  (m_if.m1_RVALID),
        .m1_RREADY  (m_if.m1_RREADY),
        // Snoop Channels
        // AC Channel
        .m1_ACVALID (),
        .m1_ACADDR  (),
        .m1_ACSNOOP (),
        .m1_ACPROT  (),
        .m1_ACREADY (),
        
        // CR Channel
        .m1_CRREADY (),
        .m1_CRVALID (),
        .m1_CRRESP  (),
        
        // CD Channel
        .m1_CDREADY (),
        .m1_CDVALID (),
        .m1_CDDATA  (),
        .m1_CDLAST  (),
    
        /********** Slave side**********/
        // AW Channel
        .s_AWID     (m_if.s_AWID    ),
        .s_AWADDR   (m_if.s_AWADDR  ),
        .s_AWLEN    (m_if.s_AWLEN   ),
        .s_AWSIZE   (m_if.s_AWSIZE  ),
        .s_AWBURST  (m_if.s_AWBURST ),
        .s_AWLOCK   (m_if.s_AWLOCK  ),
        .s_AWCACHE  (m_if.s_AWCACHE ),
        .s_AWPROT   (m_if.s_AWPROT  ),
        .s_AWQOS    (m_if.s_AWQOS   ),
        .s_AWREGION (m_if.s_AWREGION),
        .s_AWUSER   (m_if.s_AWUSER  ),
        .s_AWVALID  (m_if.s_AWVALID ),
        .s_AWREADY  (m_if.s_AWREADY ),
        // W Channel
        // output     [ID_WIDTH-1:0]   s_WID(),
        .s_WDATA    (m_if.s_WDATA ),
        .s_WSTRB    (m_if.s_WSTRB ),
        .s_WLAST    (m_if.s_WLAST ),
        .s_WUSER    (m_if.s_WUSER ),
        .s_WVALID   (m_if.s_WVALID),
        .s_WREADY   (m_if.s_WREADY),
        // B Channel
        .s_BID      (m_if.s_BID   ),
        .s_BRESP    (m_if.s_BRESP ),
        .s_BUSER    (m_if.s_BUSER ),
        .s_BVALID   (m_if.s_BVALID),
        .s_BREADY   (m_if.s_BREADY),
        // AR Channel
        .s_ARID     (m_if.s_ARID    ),    
        .s_ARADDR   (m_if.s_ARADDR  ),
        .s_ARLEN    (m_if.s_ARLEN   ),
        .s_ARSIZE   (m_if.s_ARSIZE  ),
        .s_ARBURST  (m_if.s_ARBURST ),
        .s_ARLOCK   (m_if.s_ARLOCK  ),
        .s_ARCACHE  (m_if.s_ARCACHE ),
        .s_ARPROT   (m_if.s_ARPROT  ),
        .s_ARQOS    (m_if.s_ARQOS   ),
        .s_ARREGION (m_if.s_ARREGION),
        .s_ARUSER   (m_if.s_ARUSER  ),
        .s_ARVALID  (m_if.s_ARVALID ),
        .s_ARREADY  (m_if.s_ARREADY ),
        // R Channel
        .s_RID      (m_if.s_RID   ),
        .s_RDATA    (m_if.s_RDATA ),
        .s_RRESP    (m_if.s_RRESP ),
        .s_RLAST    (m_if.s_RLAST ),
        .s_RUSER    (m_if.s_RUSER ),
        .s_RVALID   (m_if.s_RVALID), 
        .s_RREADY   (m_if.s_RREADY)
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
