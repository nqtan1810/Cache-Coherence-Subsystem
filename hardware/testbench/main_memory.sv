//////////////////////////////////////////////////////////////////////////////////
// 
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module main_memory
#(
    parameter DATA_WIDTH  = 32,
    parameter ADDR_WIDTH  = 32,
    parameter ID_WIDTH    = 1,
    parameter USER_WIDTH  = 4,
    parameter STRB_WIDTH  = (DATA_WIDTH/8),
    parameter SHAREABLE_REGION_START = 32'h0002_0000, // start address of shareable region
    parameter SHAREABLE_REGION_END   = 32'h0003_FFFF,  // end address of shareable region
    // input files
    parameter DMEM_INIT = "D:/University/KLTN/hw_design/coherence_cache/coherence_cache.srcs/sim_1/new/main_memory_init.mem",
    // output files
    parameter DMEM_RESULT = "D:/University/KLTN/hw_design/coherence_cache/coherence_cache.srcs/sim_1/new/main_memory_result.mem"
)
(
//    // system signals
//    input                       ACLK,
//    output                      ARESETn,
    
//    // AW Channel
//    input     [ID_WIDTH-1:0]    AWID,
//    input     [ADDR_WIDTH-1:0]	AWADDR,
//    input     [7:0]             AWLEN,
//    input     [2:0]             AWSIZE,
//    input     [1:0]             AWBURST,
//    input                       AWLOCK,
//    input     [3:0]             AWCACHE,
//    input     [2:0]             AWPROT,
//    input     [3:0]             AWQOS,
//    input     [3:0]             AWREGION,
//    input     [USER_WIDTH-1:0]  AWUSER,
//    input                       AWVALID,
//    output reg 	                AWREADY,
//    // W Channel
//    // input     [ID_WIDTH-1:0]   s_WID,
//    input     [DATA_WIDTH-1:0]  WDATA,
//    input     [STRB_WIDTH-1:0]  WSTRB,
//    input                       WLAST,
//    input     [USER_WIDTH-1:0]  WUSER,
//    input                       WVALID,
//    output reg		            WREADY,
//    // B Channel
//	output reg [ID_WIDTH-1:0]	BID,
//	output reg [1:0]	        BRESP,
//	output reg [USER_WIDTH-1:0] BUSER,
//	output reg   		        BVALID,
//    input                       BREADY,
//    // AR Channel
//    input     [ID_WIDTH-1:0]    ARID,    
//    input     [ADDR_WIDTH-1:0]  ARADDR,
//    input     [7:0]             ARLEN,
//    input     [2:0]             ARSIZE,
//    input     [1:0]             ARBURST,
//    input                       ARLOCK,
//    input     [3:0]             ARCACHE,
//    input     [2:0]             ARPROT,
//    input     [3:0]             ARQOS,
//    input     [3:0]             ARREGION,
//    input     [USER_WIDTH-1:0]  ARUSER,
//    input                       ARVALID,
//	output reg		            ARREADY,
//    // R Channel
//	output reg [ID_WIDTH-1:0]   RID,
//	output reg [DATA_WIDTH-1:0] RDATA,
//	output reg [1:0]	        RRESP,
//	output reg  	            RLAST,
//	output reg [USER_WIDTH-1:0]	RUSER,
//	output reg  	            RVALID, 
//    input                       RREADY
    dual_core_cache_if m_if
);

    cache_block_s main_memory [$];
    
    // for fix warning
    int un_used;
    
    function void load_mem();
        int file, num_tokens;
        bit [7:0] line[256]; // Fixed-size array for line storage
        bit [31:0] addr;
        bit [15:0][31:0] data;
        
        // Clear the queue before loading new data
        main_memory.delete(); // Reset the queue
        file = $fopen(DMEM_INIT, "r");
        if (file == 0) begin
            $display("Error: Unable to open file %s", DMEM_INIT);
            return;
        end
        while (!$feof(file)) begin
            un_used = $fgets(line, file); // Read a line from the file
            // Read address and multiple data values
            num_tokens = $sscanf(line, "0x%h 0x%h 0x%h 0x%h 0x%h 0x%h 0x%h 0x%h 0x%h 0x%h 0x%h 0x%h 0x%h 0x%h 0x%h 0x%h 0x%h", 
                                 addr,
                                 data[15], data[14], data[13], data[12],
                                 data[11], data[10], data[9] , data[8] ,
                                 data[7] , data[6] , data[5] , data[4] ,
                                 data[3] , data[2] , data[1] , data[0] );
            if (num_tokens >= 2) begin
                cache_block_s cache_entry;
                cache_entry.addr = addr;
                cache_entry.data = data;
                main_memory.push_back(cache_entry); // Add to the queue
            end
        end
        $fclose(file);
    endfunction
    
    task run();
        fork
            begin
                read_mem();
            end
            begin
                write_mem();
            end
        join
    endtask
    
    task read_mem (/*output bit [31:0] cache_L2_read_addr, input bit [511:0] cache_L2_read_data*/);
        cache_block_s hit_block;
        int hit_index;
        int cnt;
        bit [31:0] read_addr;
        bit [ID_WIDTH-1:0] ARID_reg;
        while(1) begin
            @(m_if.drv_cb);
            m_if.drv_cb.s_ARREADY <= 1;
            do begin
                @(m_if.drv_cb);
            end while (!m_if.drv_cb.s_ARVALID);
            m_if.drv_cb.s_ARREADY <= 0;
            read_addr = m_if.drv_cb.s_ARADDR;
            ARID_reg  = m_if.drv_cb.s_ARID;
            $display("[%0t(ns)] Core_%0d start reading from Mem", $time, ARID_reg);
            // hit_block = cache_L2_read.find_first with (item.addr == read_addr);
            hit_index = -1;
            foreach(main_memory[i]) 
                if (main_memory[i].addr == read_addr) begin
                    hit_index = i;
                    break;
                end
            if (hit_index != -1) begin
                hit_block = main_memory[hit_index];
            end
            else begin
                hit_block.addr = read_addr;
                foreach(hit_block.data[i])
                    hit_block.data[i] = 'b0;        // default value when load from main memory is '0'
                main_memory.push_back(hit_block);
            end
            cnt = 0;
            do begin
                if (m_if.drv_cb.s_RREADY) begin
                    // R Channel
                    m_if.drv_cb.s_RID    <= ARID_reg;
                    m_if.drv_cb.s_RDATA  <= hit_block.data[cnt];
                    m_if.drv_cb.s_RRESP  <= 2'b00;
                    m_if.drv_cb.s_RLAST  <= cnt == 15;
                    m_if.drv_cb.s_RUSER  <= 0;
                    m_if.drv_cb.s_RVALID <= 1;
                    cnt++;
                end
                @(m_if.drv_cb);
            end while (cnt < 16);
            m_if.drv_cb.s_RLAST  <= 0;
            m_if.drv_cb.s_RVALID <= 0;
            @(m_if.drv_cb);
            $display("[%0t(ns)] Core_%0d finish reading from Mem", $time, ARID_reg);
        end
    endtask
    
    task write_mem (/*output bit [31:0] cache_L2_write_addr, output bit [511:0] cache_L2_write_data*/);
        cache_block_s hit_block;
        int hit_index;
        int cnt;
        bit [31:0] write_addr;
        bit [ID_WIDTH-1:0] AWID_reg;
        
        while(1) begin
            @(m_if.drv_cb);
            m_if.drv_cb.s_AWREADY <= 1;
            do begin
                @(m_if.drv_cb);
            end while (!m_if.drv_cb.s_AWVALID);
            m_if.drv_cb.s_AWREADY <= 0;
            write_addr = m_if.drv_cb.s_AWADDR;
            AWID_reg   = m_if.drv_cb.s_AWID;
            $display("[%0t(ns)] Core_%0d start writing to Mem", $time, AWID_reg);
            // hit_index = main_memory.find_first_index(x) with (x.addr == write_addr);
            hit_index = -1;
            foreach(main_memory[i]) 
                if (main_memory[i].addr == write_addr) begin
                    hit_index = i;
                    break;
                end
            m_if.drv_cb.s_WREADY <= 1;
            cnt = 0;
            do begin
                if (m_if.drv_cb.s_WVALID) begin
                    if (hit_index != -1) begin
                        main_memory[hit_index].data[cnt] = m_if.drv_cb.s_WDATA;
                    end
                    else begin
                        hit_block.addr      = write_addr;
                        hit_block.data[cnt] = m_if.drv_cb.s_WDATA;
                    end
                    cnt++;
                end
                @(m_if.drv_cb);
            end while (cnt < 16);
            m_if.drv_cb.s_WREADY <= 0;
            if (hit_index == -1) begin
                main_memory.push_back(hit_block);
            end
            // B Channel
            m_if.drv_cb.s_BID    <= AWID_reg;
            m_if.drv_cb.s_BRESP  <= 2'b00;
            m_if.drv_cb.s_BUSER  <= 0;
            m_if.drv_cb.s_BVALID <= 1;
            do begin
                @(m_if.drv_cb);
            end while (!m_if.drv_cb.s_BREADY);
            m_if.drv_cb.s_BVALID <= 0;
            @(m_if.drv_cb);
            $display("[%0t(ns)] Core_%0d finish writing to Mem", $time, AWID_reg);
        end
    endtask
    
    function void save_mem();
        int file, index;
        
        file = $fopen(DMEM_RESULT, "w");
        if (file == 0) begin
            $display("Error: Unable to open file %s for writing", DMEM_RESULT);
            return;
        end
        foreach (main_memory[index]) begin
            // Write address followed by 16 data values in a single line
            $fwrite(file, "0x%h", main_memory[index].addr);
            for (int i = 15; i >= 0; i--) begin
                $fwrite(file, " 0x%h", main_memory[index].data[i]);
            end
            $fwrite(file, "\n"); // New line after each entry
        end
        $fclose(file);
    endfunction

endmodule