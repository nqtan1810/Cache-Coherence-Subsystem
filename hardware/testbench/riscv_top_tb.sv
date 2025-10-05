`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// top tb of riscv cpu
//////////////////////////////////////////////////////////////////////////////////


module riscv_top_tb
#(
    parameter ID          = 0,
    parameter DATA_WIDTH  = 32,
    parameter ADDR_WIDTH  = 32,
    parameter ID_WIDTH    = 1,
    parameter USER_WIDTH  = 4,
    parameter STRB_WIDTH  = (DATA_WIDTH/8),
    parameter SHAREABLE_REGION_START = 32'h0002_0000, // start address of shareable region
    parameter SHAREABLE_REGION_END   = 32'h0003_FFFF,  // end address of shareable region
    parameter IMEM_PATH = "D:/University/KLTN/hw_design/coherence_cache/coherence_cache.srcs/sources_1/new/imem_A.mem"
)
();

    bit ACLK;
    bit ARESETn;
    
    initial begin
        forever
            #5 ACLK = ~ACLK;
    end
    
    initial begin 
        ARESETn = 0;
        #10;
        ARESETn = 1;
        repeat(1000) @(posedge ACLK);
        $finish;
    end
    
    riscv_processor #(
        .ID                     (ID                    ),
        .DATA_WIDTH             (DATA_WIDTH            ),
        .ADDR_WIDTH             (ADDR_WIDTH            ),
        .ID_WIDTH               (ID_WIDTH              ),
        .USER_WIDTH             (USER_WIDTH            ),
        .STRB_WIDTH             (STRB_WIDTH            ),
        .SHAREABLE_REGION_START (SHAREABLE_REGION_START),
        .SHAREABLE_REGION_END   (SHAREABLE_REGION_END  ),
        .IMEM_PATH              (IMEM_PATH             )
    ) u_riscv_processor (
        .ACLK           (ACLK),
        .ARESETn        (ARESETn),
        
        // D-Cache interface
        .d_CACHE_EN     (),
        
        // AXI Write Address Channel
        .d_AWID         (),
        .d_AWADDR       (),
        .d_AWLEN        (),
        .d_AWSIZE       (),
        .d_AWBURST      (),
        .d_AWLOCK       (),
        .d_AWCACHE      (),
        .d_AWPROT       (),
        .d_AWQOS        (),
        .d_AWREGION     (),
        .d_AWUSER       (),
        .d_AWDOMAIN     (),
        .d_AWVALID      (),
        .d_AWREADY      (),
    
        // AXI Write Data Channel
        .d_WDATA        (),
        .d_WSTRB        (),
        .d_WLAST        (),
        .d_WUSER        (),
        .d_WVALID       (),
        .d_WREADY       (),
    
        // AXI Write Response Channel
        .d_BID          (),
        .d_BRESP        (),
        .d_BUSER        (),
        .d_BVALID       (),
        .d_BREADY       (),
    
        // AXI Read Address Channel
        .d_ARID         (),
        .d_ARADDR       (),
        .d_ARLEN        (),
        .d_ARSIZE       (),
        .d_ARBURST      (),
        .d_ARLOCK       (),
        .d_ARCACHE      (),
        .d_ARPROT       (),
        .d_ARQOS        (),
        .d_ARREGION     (),
        .d_ARUSER       (),
        .d_ARDOMAIN     (),
        .d_ARVALID      (),
        .d_ARREADY      (),
    
        // AXI Read Data Channel
        .d_RID          (),
        .d_RDATA        (),
        .d_RRESP        (),
        .d_RLAST        (),
        .d_RUSER        (),
        .d_RVALID       (),
        .d_RREADY       ()
    );

endmodule
