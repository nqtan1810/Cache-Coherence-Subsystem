//////////////////////////////////////////////////////////////////////////////////
// 
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

//`include "subsystem_pkg.sv"
//import subsystem_pkg::*;

module processor
#(
    parameter ID          = 0,
    parameter DATA_WIDTH  = 32,
    parameter ADDR_WIDTH  = 32,
    parameter ID_WIDTH    = 1,
    parameter USER_WIDTH  = 4,
    parameter STRB_WIDTH  = (DATA_WIDTH/8),
    parameter SHAREABLE_REGION_START = 32'h0002_0000, // start address of shareable region
    parameter SHAREABLE_REGION_END   = 32'h0003_FFFF,  // end address of shareable region
    // input files
    parameter IMEM = "D:/University/KLTN/hw_design/coherence_cache/coherence_cache.srcs/sim_1/new/instr_mem_A.mem",
    // output files
    parameter READ_DATA = "D:/University/KLTN/hw_design/coherence_cache/coherence_cache.srcs/sim_1/new/read_data_A.mem"
)
(
//    // system signals
//    input                        ACLK,
//    input                        ARESETn,
    
//    // AW Channel
//    output reg [ID_WIDTH-1:0]    AWID,
//    output reg [ADDR_WIDTH-1:0]  AWADDR,
//    output reg [7:0]             AWLEN,
//    output reg [2:0]             AWSIZE,
//    output reg [1:0]             AWBURST,
//    output reg                   AWLOCK,
//    output reg [3:0]             AWCACHE,
//    output reg [2:0]             AWPROT,
//    output reg [3:0]             AWQOS,
//    output reg [3:0]             AWREGION,
//    output reg [USER_WIDTH-1:0]  AWUSER,
//    output reg [1:0]             AWDOMAIN,
//    output reg                   AWVALID,
//    input                        AWREADY,
    
//    // W Channel
//    output reg [DATA_WIDTH-1:0]  WDATA,
//    output reg [STRB_WIDTH-1:0]  WSTRB, // use default value: 0xF
//    output reg                   WLAST,
//    output reg [USER_WIDTH-1:0]  WUSER,
//    output reg                   WVALID,
//    input                        WREADY,
    
//    // B Channel
//    input    [ID_WIDTH-1:0]      BID,
//    input    [1:0]               BRESP,
//    input    [USER_WIDTH-1:0]    BUSER,
//    input                        BVALID,
//    output reg                   BREADY,
    
//    // AR Channel
//    output reg [ID_WIDTH-1:0]    ARID,
//    output reg [ADDR_WIDTH-1:0]  ARADDR,
//    output reg [7:0]             ARLEN,
//    output reg [2:0]             ARSIZE,
//    output reg [1:0]             ARBURST,
//    output reg                   ARLOCK,
//    output reg [3:0]             ARCACHE,
//    output reg [2:0]             ARPROT,
//    output reg [3:0]             ARQOS,
//    output reg [3:0]             ARREGION,
//    output reg [USER_WIDTH-1:0]  ARUSER,
//    output reg [1:0]             ARDOMAIN,
//    output reg                   ARVALID,
//    input                        ARREADY,
    
//    // R Channel
//    input    [ID_WIDTH-1:0]      RID,
//    input    [DATA_WIDTH-1:0]    RDATA,
//    input    [1:0]               RRESP,
//    input                        RLAST,
//    input    [USER_WIDTH-1:0]    RUSER,
//    input                        RVALID,
//    output reg                   RREADY
    dual_core_cache_if m_if
);

    instruction_s cpu_instr_mem[$];
    cache_word_s read_data[$];
    
    instruction_16_s cpu_instr_16_mem[$];
    cache_block_s read_data_16[$];
    
    // for fix warning
    int un_used;
    
    function void load_instr_mem();
        int file, num_tokens;
        string line;
        string op;
        bit [31:0] addr, data;
        
        // Clear the queue before loading new data
        cpu_instr_mem.delete(); // Reset the queue
        file = $fopen(IMEM, "r");
        if (file == 0) begin
            $display("Error: Unable to open file %s", IMEM);
            return;
        end
        while (!$feof(file)) begin
            line = "";
            un_used = $fgets(line, file);
            if (line == "") continue;
            op = "";
            addr = 0;
            data = 0;
            num_tokens = $sscanf(line, "%s %h %h", op, addr, data);
            if (num_tokens >= 2) begin
                instruction_s instr_entry;
                instr_entry.addr = addr;
                if (op == "read") begin
                    instr_entry.instr_type = 1'b0; // Read instruction
                    instr_entry.data = 32'b0; // No data for read operations
                end else if (op == "write" && num_tokens == 3) begin
                    instr_entry.instr_type = 1'b1; // Write instruction
                    instr_entry.data = data;
                end else begin
                    $display("Error: Invalid instruction format");
                    continue;
                end
                cpu_instr_mem.push_back(instr_entry); // Add to the queue
            end
        end
        $fclose(file);
    endfunction
    
    task run();
        $display("[%0t(ns)] Core_%0d start!", $time, ID);
        foreach(cpu_instr_mem[i]) begin
            cache_word_s read_out_trans;
            if (cpu_instr_mem[i].instr_type) begin
                cpu_write(cpu_instr_mem[i].addr, cpu_instr_mem[i].data);
            end
            else begin
                cpu_read(cpu_instr_mem[i].addr, cpu_instr_mem[i].data);
                read_out_trans.addr = cpu_instr_mem[i].addr;
                read_out_trans.data = cpu_instr_mem[i].data;
                read_data.push_back(read_out_trans);
            end
        end
        $display("[%0t(ns)] Core_%0d finish!", $time, ID);
    endtask
    
    task cpu_read(input bit [31:0] read_addr, output bit [31:0] read_data);
        $display("[%0t(ns)] Core_%0d start reading from Address = 0x%h", $time, ID, read_addr);
        @(m_if.drv_cb);
        if (ID == 0) begin
            // AR Channel
            m_if.drv_cb.m0_ARID      <= ID;
            m_if.drv_cb.m0_ARADDR    <= read_addr;
            m_if.drv_cb.m0_ARLEN     <= 0;
            m_if.drv_cb.m0_ARSIZE    <= 3'h2;
            m_if.drv_cb.m0_ARBURST   <= 2'h1;
            m_if.drv_cb.m0_ARLOCK    <= 0;
            m_if.drv_cb.m0_ARCACHE   <= 4'hF;
            m_if.drv_cb.m0_ARPROT    <= 0;
            m_if.drv_cb.m0_ARQOS     <= 0;
            m_if.drv_cb.m0_ARREGION  <= 0;
            m_if.drv_cb.m0_ARUSER    <= 0;
            m_if.drv_cb.m0_ARDOMAIN  <= (read_addr >= SHAREABLE_REGION_START && read_addr <= SHAREABLE_REGION_END) ? 2'b10 : 2'b00;
            m_if.drv_cb.m0_ARVALID   <= 1;
            do begin
                @(m_if.drv_cb);
            end while (!m_if.drv_cb.m0_ARREADY);
            m_if.drv_cb.m0_ARVALID <= 0;
            m_if.drv_cb.m0_RREADY  <= 1;
            do begin
                @(m_if.drv_cb);
            end while (!m_if.drv_cb.m0_RVALID);
            read_data = m_if.drv_cb.m0_RDATA;
            m_if.drv_cb.m0_RREADY <= 0;
        end
        if (ID == 1) begin
            // AR Channel
            m_if.drv_cb.m1_ARID      <= ID;
            m_if.drv_cb.m1_ARADDR    <= read_addr;
            m_if.drv_cb.m1_ARLEN     <= 0;
            m_if.drv_cb.m1_ARSIZE    <= 3'h2;
            m_if.drv_cb.m1_ARBURST   <= 2'h1;
            m_if.drv_cb.m1_ARLOCK    <= 0;
            m_if.drv_cb.m1_ARCACHE   <= 4'hF;
            m_if.drv_cb.m1_ARPROT    <= 0;
            m_if.drv_cb.m1_ARQOS     <= 0;
            m_if.drv_cb.m1_ARREGION  <= 0;
            m_if.drv_cb.m1_ARUSER    <= 0;
            m_if.drv_cb.m1_ARDOMAIN  <= (read_addr >= SHAREABLE_REGION_START && read_addr <= SHAREABLE_REGION_END) ? 2'b10 : 2'b00;
            m_if.drv_cb.m1_ARVALID   <= 1;
            do begin
                @(m_if.drv_cb);
            end while (!m_if.drv_cb.m1_ARREADY);
            m_if.drv_cb.m1_ARVALID <= 0;
            m_if.drv_cb.m1_RREADY  <= 1;
            do begin
                @(m_if.drv_cb);
            end while (!m_if.drv_cb.m1_RVALID);
            read_data = m_if.drv_cb.m1_RDATA;
            m_if.drv_cb.m1_RREADY <= 0;
        end
        @(m_if.drv_cb);
        $display("[%0t(ns)] Core_%0d finish reading from Address = 0x%h, Data = 0x%h", $time, ID, read_addr, read_data);
    endtask
    
    task cpu_write(input bit [31:0] write_addr, input bit [31:0] write_data);
        $display("[%0t(ns)] Core_%0d start writing from Address = 0x%h, Data = 0x%h", $time, ID, write_addr, write_data);
        @(m_if.drv_cb);
        if (ID == 0) begin
            // AW Channel
            m_if.drv_cb.m0_AWID      <= ID;
            m_if.drv_cb.m0_AWADDR    <= write_addr;
            m_if.drv_cb.m0_AWLEN     <= 0;
            m_if.drv_cb.m0_AWSIZE    <= 3'h2;
            m_if.drv_cb.m0_AWBURST   <= 2'h1;
            m_if.drv_cb.m0_AWLOCK    <= 0;
            m_if.drv_cb.m0_AWCACHE   <= 4'hF;
            m_if.drv_cb.m0_AWPROT    <= 0;
            m_if.drv_cb.m0_AWQOS     <= 0;
            m_if.drv_cb.m0_AWREGION  <= 0;
            m_if.drv_cb.m0_AWUSER    <= 0;
            m_if.drv_cb.m0_AWDOMAIN  <= (write_addr >= SHAREABLE_REGION_START && write_addr <= SHAREABLE_REGION_END) ? 2'b10 : 2'b00;
            m_if.drv_cb.m0_AWVALID   <= 1;
            do begin
                @(m_if.drv_cb);
            end while (!m_if.drv_cb.m0_AWREADY);
            m_if.drv_cb.m0_AWVALID   <= 0;
            // W Channel
            m_if.drv_cb.m0_WDATA     <= write_data;
            m_if.drv_cb.m0_WSTRB     <= 4'hF;
            m_if.drv_cb.m0_WLAST     <= 1;
            m_if.drv_cb.m0_WUSER     <= 0;
            m_if.drv_cb.m0_WVALID    <= 1;
            do begin
                @(m_if.drv_cb);
            end while (!m_if.drv_cb.m0_WREADY);
            m_if.drv_cb.m0_WVALID    <= 0;
            m_if.drv_cb.m0_WLAST     <= 0;
            m_if.drv_cb.m0_BREADY    <= 1;
            do begin
                @(m_if.drv_cb);
            end while (!m_if.drv_cb.m0_BVALID);
            m_if.drv_cb.m0_BREADY    <= 0;
        end
        if (ID == 1) begin
            // AW Channel
            m_if.drv_cb.m1_AWID      <= ID;
            m_if.drv_cb.m1_AWADDR    <= write_addr;
            m_if.drv_cb.m1_AWLEN     <= 0;
            m_if.drv_cb.m1_AWSIZE    <= 3'h2;
            m_if.drv_cb.m1_AWBURST   <= 2'h1;
            m_if.drv_cb.m1_AWLOCK    <= 0;
            m_if.drv_cb.m1_AWCACHE   <= 4'hF;
            m_if.drv_cb.m1_AWPROT    <= 0;
            m_if.drv_cb.m1_AWQOS     <= 0;
            m_if.drv_cb.m1_AWREGION  <= 0;
            m_if.drv_cb.m1_AWUSER    <= 0;
            m_if.drv_cb.m1_AWDOMAIN  <= (write_addr >= SHAREABLE_REGION_START && write_addr <= SHAREABLE_REGION_END) ? 2'b10 : 2'b00;
            m_if.drv_cb.m1_AWVALID   <= 1;
            do begin
                @(m_if.drv_cb);
            end while (!m_if.drv_cb.m1_AWREADY);
            m_if.drv_cb.m1_AWVALID   <= 0;
            // W Channel
            m_if.drv_cb.m1_WDATA     <= write_data;
            m_if.drv_cb.m1_WSTRB     <= 4'hF;
            m_if.drv_cb.m1_WLAST     <= 1;
            m_if.drv_cb.m1_WUSER     <= 0;
            m_if.drv_cb.m1_WVALID    <= 1;
            do begin
                @(m_if.drv_cb);
            end while (!m_if.drv_cb.m1_WREADY);
            m_if.drv_cb.m1_WVALID    <= 0;
            m_if.drv_cb.m1_WLAST     <= 0;
            m_if.drv_cb.m1_BREADY    <= 1;
            do begin
                @(m_if.drv_cb);
            end while (!m_if.drv_cb.m1_BVALID);
            m_if.drv_cb.m1_BREADY    <= 0;
        end
        @(m_if.drv_cb);
        $display("[%0t(ns)] Core_%0d finish writing from Address = 0x%h, Data = 0x%h", $time, ID, write_addr, write_data);
    endtask
    
    task save_read_data();
        integer file;
        integer i, j;
    
        // Open the file for writing
        file = $fopen(READ_DATA, "w");
        if (file == 0) begin
            $display("Error: Unable to open file %s", READ_DATA);
            return;
        end
        // Write data
        foreach(read_data[i]) begin
            $fdisplay(file, "0x%h 0x%h", read_data[i].addr, read_data[i].data);
        end
        // Close the file
        $fclose(file);
    endtask
    
    
    function void load_instr_16_mem();
        int file, num_tokens;
        string line;
        string op;
        bit [31:0] addr;
        bit [15:0][31:0] data;
        
        // Clear the queue before loading new data
        cpu_instr_16_mem.delete(); // Reset the queue
        file = $fopen(IMEM, "r");
        if (file == 0) begin
            $display("Error: Unable to open file %s", IMEM);
            return;
        end
        while (!$feof(file)) begin
            line = "";
            un_used = $fgets(line, file);
            if (line == "") continue;
            op = "";
            addr = 0;
            foreach(data[i]) data[i] = 0;
            num_tokens = $sscanf(line, "%s 0x%h 0x%h 0x%h 0x%h 0x%h 0x%h 0x%h 0x%h 0x%h 0x%h 0x%h 0x%h 0x%h 0x%h 0x%h 0x%h 0x%h", 
                                 op, 
                                 addr, 
                                 data[15], data[14], data[13], data[12],
                                 data[11], data[10], data[9] , data[8] ,
                                 data[7] , data[6] , data[5] , data[4] ,
                                 data[3] , data[2] , data[1] , data[0] );
            if (num_tokens >= 2) begin
                instruction_16_s instr_entry;
                instr_entry.addr = addr;
                if (op == "read") begin
                    instr_entry.instr_type = 1'b0; // Read instruction
                    // instr_entry.data = 32'b0; // No data for read operations
                end else if (op == "write") begin
                    instr_entry.instr_type = 1'b1; // Write instruction
                    instr_entry.data = data;
                end else begin
                    $display("Error: Invalid instruction format");
                    continue;
                end
                cpu_instr_16_mem.push_back(instr_entry); // Add to the queue
            end
        end
        $fclose(file);
        // foreach(cpu_instr_16_mem[i]) $display("%p", cpu_instr_16_mem[i]);
    endfunction
    
    task save_read_data_16();
        integer file;
        integer i, j;
    
        // Open the file for writing
        file = $fopen(READ_DATA, "w");
        if (file == 0) begin
            $display("Error: Unable to open file %s", READ_DATA);
            return;
        end
        // Write data
        foreach(read_data_16[i]) begin
            $fdisplay(file, "0x%h 0x%h 0x%h 0x%h 0x%h 0x%h 0x%h 0x%h 0x%h 0x%h 0x%h 0x%h 0x%h 0x%h 0x%h 0x%h 0x%h", 
                      read_data_16[i].addr,
                      read_data_16[i].data[15], read_data_16[i].data[14], read_data_16[i].data[13], read_data_16[i].data[12],
                      read_data_16[i].data[11], read_data_16[i].data[10], read_data_16[i].data[9] , read_data_16[i].data[8] ,
                      read_data_16[i].data[7] , read_data_16[i].data[6] , read_data_16[i].data[5] , read_data_16[i].data[4] ,
                      read_data_16[i].data[3] , read_data_16[i].data[2] , read_data_16[i].data[1] , read_data_16[i].data[0] );
        end
        // Close the file
        $fclose(file);
    endtask
    
    task run_16();
        $display("[%0t(ns)] Core_%0d start!", $time, ID);
        foreach(cpu_instr_16_mem[i]) begin
            cache_block_s read_out_trans;
            if (cpu_instr_16_mem[i].instr_type) begin
                cpu_write_16(cpu_instr_16_mem[i].addr, cpu_instr_16_mem[i].data);
            end
            else begin
                cpu_read_16(cpu_instr_16_mem[i].addr, cpu_instr_16_mem[i].data);
                read_out_trans.addr = cpu_instr_16_mem[i].addr;
                read_out_trans.data = cpu_instr_16_mem[i].data;
                read_data_16.push_back(read_out_trans);
            end
        end
        $display("[%0t(ns)] Core_%0d finish!", $time, ID);
    endtask
    
    task cpu_read_16(input bit [31:0] read_addr, output bit [15:0][31:0] read_data);
        int cnt;
        $display("[%0t(ns)] Core_%0d start reading from Address = 0x%h", $time, ID, read_addr);
        @(m_if.drv_cb);
        if (ID == 0) begin
            // AR Channel
            m_if.drv_cb.m0_ARID      <= ID;
            m_if.drv_cb.m0_ARADDR    <= read_addr;
            m_if.drv_cb.m0_ARLEN     <= 15;
            m_if.drv_cb.m0_ARSIZE    <= 3'h2;
            m_if.drv_cb.m0_ARBURST   <= 2'h1;
            m_if.drv_cb.m0_ARLOCK    <= 0;
            m_if.drv_cb.m0_ARCACHE   <= 4'hF;
            m_if.drv_cb.m0_ARPROT    <= 0;
            m_if.drv_cb.m0_ARQOS     <= 0;
            m_if.drv_cb.m0_ARREGION  <= 0;
            m_if.drv_cb.m0_ARUSER    <= 0;
            m_if.drv_cb.m0_ARDOMAIN  <= (read_addr >= SHAREABLE_REGION_START && read_addr <= SHAREABLE_REGION_END) ? 2'b10 : 2'b00;
            m_if.drv_cb.m0_ARVALID   <= 1;
            do begin
                @(m_if.drv_cb);
            end while (!m_if.drv_cb.m0_ARREADY);
            m_if.drv_cb.m0_ARVALID <= 0;
            m_if.drv_cb.m0_RREADY  <= 1;
            cnt = 0;
            do begin
                if (m_if.drv_cb.m0_RVALID) begin
                    read_data[cnt] = m_if.drv_cb.m0_RDATA;
                    cnt++;
                end
                @(m_if.drv_cb);
            end while (cnt < 16);
            // read_data = RDATA;
            m_if.drv_cb.m0_RREADY <= 0;
        end
        if (ID == 1) begin
            // AR Channel
            m_if.drv_cb.m1_ARID      <= ID;
            m_if.drv_cb.m1_ARADDR    <= read_addr;
            m_if.drv_cb.m1_ARLEN     <= 15;
            m_if.drv_cb.m1_ARSIZE    <= 3'h2;
            m_if.drv_cb.m1_ARBURST   <= 2'h1;
            m_if.drv_cb.m1_ARLOCK    <= 0;
            m_if.drv_cb.m1_ARCACHE   <= 4'hF;
            m_if.drv_cb.m1_ARPROT    <= 0;
            m_if.drv_cb.m1_ARQOS     <= 0;
            m_if.drv_cb.m1_ARREGION  <= 0;
            m_if.drv_cb.m1_ARUSER    <= 0;
            m_if.drv_cb.m1_ARDOMAIN  <= (read_addr >= SHAREABLE_REGION_START && read_addr <= SHAREABLE_REGION_END) ? 2'b10 : 2'b00;
            m_if.drv_cb.m1_ARVALID   <= 1;
            do begin
                @(m_if.drv_cb);
            end while (!m_if.drv_cb.m1_ARREADY);
            m_if.drv_cb.m1_ARVALID <= 0;
            m_if.drv_cb.m1_RREADY  <= 1;
            cnt = 0;
            do begin
                if (m_if.drv_cb.m1_RVALID) begin
                    read_data[cnt] = m_if.drv_cb.m1_RDATA;
                    cnt++;
                end
                @(m_if.drv_cb);
            end while (cnt < 16);
            // read_data = RDATA;
            m_if.drv_cb.m1_RREADY <= 0;
        end
        @(m_if.drv_cb);
        $display("[%0t(ns)] Core_%0d finish reading from Address = 0x%h, Data = 0x%h", $time, ID, read_addr, read_data);
    endtask
    
    task cpu_write_16(input bit [31:0] write_addr, input bit [15:0][31:0] write_data);
        int cnt;
        $display("[%0t(ns)] Core_%0d start writing from Address = 0x%h, Data = 0x%h", $time, ID, write_addr, write_data);
        @(m_if.drv_cb);
        if (ID == 0) begin
            // AW Channel
            m_if.drv_cb.m0_AWID      <= ID;
            m_if.drv_cb.m0_AWADDR    <= write_addr;
            m_if.drv_cb.m0_AWLEN     <= 15;
            m_if.drv_cb.m0_AWSIZE    <= 3'h2;
            m_if.drv_cb.m0_AWBURST   <= 2'h1;
            m_if.drv_cb.m0_AWLOCK    <= 0;
            m_if.drv_cb.m0_AWCACHE   <= 4'hF;
            m_if.drv_cb.m0_AWPROT    <= 0;
            m_if.drv_cb.m0_AWQOS     <= 0;
            m_if.drv_cb.m0_AWREGION  <= 0;
            m_if.drv_cb.m0_AWUSER    <= 0;
            m_if.drv_cb.m0_AWDOMAIN  <= (write_addr >= SHAREABLE_REGION_START && write_addr <= SHAREABLE_REGION_END) ? 2'b10 : 2'b00;
            m_if.drv_cb.m0_AWVALID   <= 1;
            do begin
                @(m_if.drv_cb);
            end while (!m_if.drv_cb.m0_AWREADY);
            m_if.drv_cb.m0_AWVALID   <= 0;
            cnt = 0;
            do begin
                if (m_if.drv_cb.m0_WREADY) begin
                    m_if.drv_cb.m0_WDATA   <= write_data[cnt];
                    m_if.drv_cb.m0_WSTRB   <= 4'hF;
                    m_if.drv_cb.m0_WLAST   <= cnt == 15;
                    m_if.drv_cb.m0_WUSER   <= 0;
                    m_if.drv_cb.m0_WVALID  <= 1;
                    cnt++;
                end
                @(m_if.drv_cb);
            end while (cnt < 16);
            m_if.drv_cb.m0_WVALID    <= 0;
            m_if.drv_cb.m0_WLAST     <= 0;
            m_if.drv_cb.m0_BREADY    <= 1;
            do begin
                @(m_if.drv_cb);
            end while (!m_if.drv_cb.m0_BVALID);
            m_if.drv_cb.m0_BREADY    <= 0;
        end
        if (ID == 1) begin
            // AW Channel
            m_if.drv_cb.m1_AWID      <= ID;
            m_if.drv_cb.m1_AWADDR    <= write_addr;
            m_if.drv_cb.m1_AWLEN     <= 15;
            m_if.drv_cb.m1_AWSIZE    <= 3'h2;
            m_if.drv_cb.m1_AWBURST   <= 2'h1;
            m_if.drv_cb.m1_AWLOCK    <= 0;
            m_if.drv_cb.m1_AWCACHE   <= 4'hF;
            m_if.drv_cb.m1_AWPROT    <= 0;
            m_if.drv_cb.m1_AWQOS     <= 0;
            m_if.drv_cb.m1_AWREGION  <= 0;
            m_if.drv_cb.m1_AWUSER    <= 0;
            m_if.drv_cb.m1_AWDOMAIN  <= (write_addr >= SHAREABLE_REGION_START && write_addr <= SHAREABLE_REGION_END) ? 2'b10 : 2'b00;
            m_if.drv_cb.m1_AWVALID   <= 1;
            do begin
                @(m_if.drv_cb);
            end while (!m_if.drv_cb.m1_AWREADY);
            m_if.drv_cb.m1_AWVALID   <= 0;
            cnt = 0;
            do begin
                if (m_if.drv_cb.m1_WREADY) begin
                    m_if.drv_cb.m1_WDATA   <= write_data[cnt];
                    m_if.drv_cb.m1_WSTRB   <= 4'hF;
                    m_if.drv_cb.m1_WLAST   <= cnt == 15;
                    m_if.drv_cb.m1_WUSER   <= 0;
                    m_if.drv_cb.m1_WVALID  <= 1;
                    cnt++;
                end
                @(m_if.drv_cb);
            end while (cnt < 16);
            m_if.drv_cb.m1_WVALID    <= 0;
            m_if.drv_cb.m1_WLAST     <= 0;
            m_if.drv_cb.m1_BREADY    <= 1;
            do begin
                @(m_if.drv_cb);
            end while (!m_if.drv_cb.m1_BVALID);
            m_if.drv_cb.m1_BREADY    <= 0;
        end
        @(m_if.drv_cb);
        $display("[%0t(ns)] Core_%0d finish writing from Address = 0x%h, Data = 0x%h", $time, ID, write_addr, write_data);
    endtask
    
endmodule
