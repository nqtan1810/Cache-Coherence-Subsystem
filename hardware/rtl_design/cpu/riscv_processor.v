`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// this is riscv processor with AXI interface to D-Cache
//////////////////////////////////////////////////////////////////////////////////

`include "riscv_define.vh"

module riscv_processor
#(
    parameter ID          = 0,
    parameter DATA_WIDTH  = 32,
    parameter ADDR_WIDTH  = 32,
    parameter ID_WIDTH    = 2,
    parameter USER_WIDTH  = 4,
    parameter STRB_WIDTH  = (DATA_WIDTH/8),
    parameter SHAREABLE_REGION_START = 32'h0000_1000, // start address of shareable region
    parameter SHAREABLE_REGION_END   = 32'h0003_FFFF,  // end address of shareable region
    parameter CODE_REGION_START = 32'h0000_0000, // start address of code region
    parameter CODE_REGION_END   = 32'h0000_03FF  // end address of code region
    // parameter IMEM_PATH = "D:/University/KLTN/hw_design/coherence_cache/coherence_cache.srcs/sources_1/new/imem_A.mem"
)
(
    // system signals
    input                       ACLK,
    input                       ARESETn,
    
    // enable
    input                       enable,
    
    // interface with regfile
    input                       reg_rd_en,
    input   [4:0]               reg_addr,
    output  [DATA_WIDTH-1:0]    reg_data,
    
    // Interface connect with D-Cache and I-Cache
    // D-Cache enable
    output                      d_CACHE_EN,
    // I-Cache enable
    output                      i_CACHE_EN,
    
    // D-Cache related signals
    // AXI5 Interface
    // AW Channel
    output   [ID_WIDTH-1:0]     d_AWID,
    output   [ADDR_WIDTH-1:0]   d_AWADDR,
    output   [7:0]              d_AWLEN,
    output   [2:0]              d_AWSIZE,
    output   [1:0]              d_AWBURST,
    output                      d_AWLOCK,
    output   [3:0]              d_AWCACHE,
    output   [2:0]              d_AWPROT,
    output   [3:0]              d_AWQOS,
    output   [3:0]              d_AWREGION,
    output   [USER_WIDTH-1:0]   d_AWUSER,
    output   [1:0]              d_AWDOMAIN,
    output                      d_AWVALID,
    input                       d_AWREADY,
    
    // W Channel
    output   [DATA_WIDTH-1:0]   d_WDATA,
    output   [STRB_WIDTH-1:0]   d_WSTRB, 
    output                      d_WLAST,
    output   [USER_WIDTH-1:0]   d_WUSER,
    output                      d_WVALID,
    input                       d_WREADY,
    
    // B Channel
    input  [ID_WIDTH-1:0]       d_BID,
    input  [1:0]                d_BRESP,
    input  [USER_WIDTH-1:0]     d_BUSER,
    input                       d_BVALID,
    output                      d_BREADY,
   
    // AR Channel
    output   [ID_WIDTH-1:0]     d_ARID,
    output   [ADDR_WIDTH-1:0]   d_ARADDR,
    output   [7:0]              d_ARLEN,
    output   [2:0]              d_ARSIZE,
    output   [1:0]              d_ARBURST,
    output                      d_ARLOCK,
    output   [3:0]              d_ARCACHE,
    output   [2:0]              d_ARPROT,
    output   [3:0]              d_ARQOS,
    output   [3:0]              d_ARREGION,
    output   [USER_WIDTH-1:0]   d_ARUSER,
    output   [1:0]              d_ARDOMAIN,
    output                      d_ARVALID,
    input                       d_ARREADY,
    
    // R Channel
    input  [ID_WIDTH-1:0]       d_RID,
    input  [DATA_WIDTH-1:0]     d_RDATA,
    input  [1:0]                d_RRESP,
    input                       d_RLAST,
    input  [USER_WIDTH-1:0]	    d_RUSER,
    input                       d_RVALID,
    output                      d_RREADY,
    
    // I-Cache related signals
    // AXI4
    // AW Channel
    output [ID_WIDTH-1:0]       i_AWID,
    output [ADDR_WIDTH-1:0]     i_AWADDR,
    output [7:0]                i_AWLEN,
    output [2:0]                i_AWSIZE,
    output [1:0]                i_AWBURST,
    output                      i_AWLOCK,
    output [3:0]                i_AWCACHE,
    output [2:0]                i_AWPROT,
    output [3:0]                i_AWQOS,
    output [3:0]                i_AWREGION,
    output [USER_WIDTH-1:0]     i_AWUSER,
    output                      i_AWVALID,
    input                       i_AWREADY,
    
    // W Channel
    output [DATA_WIDTH-1:0]     i_WDATA,
    output [STRB_WIDTH-1:0]     i_WSTRB, 
    output                      i_WLAST,
    output [USER_WIDTH-1:0]     i_WUSER,
    output                      i_WVALID,
    input                       i_WREADY,
    
    // B Channel
    input  [ID_WIDTH-1:0]       i_BID,
    input  [1:0]                i_BRESP,
    input  [USER_WIDTH-1:0]     i_BUSER,
    input                       i_BVALID,
    output                      i_BREADY,
   
    // AR Channel
    output [ID_WIDTH-1:0]       i_ARID,
    output [ADDR_WIDTH-1:0]     i_ARADDR,
    output [7:0]                i_ARLEN,
    output [2:0]                i_ARSIZE,
    output [1:0]                i_ARBURST,
    output                      i_ARLOCK,
    output [3:0]                i_ARCACHE,
    output [2:0]                i_ARPROT,
    output [3:0]                i_ARQOS,
    output [3:0]                i_ARREGION,
    output [USER_WIDTH-1:0]     i_ARUSER,
    output                      i_ARVALID,
    input                       i_ARREADY,
    
    // R Channel
    input  [ID_WIDTH-1:0]       i_RID,
    input  [DATA_WIDTH-1:0]     i_RDATA,
    input  [1:0]                i_RRESP,
    input                       i_RLAST,
    input  [USER_WIDTH-1:0]	    i_RUSER,
    input                       i_RVALID,
    output                      i_RREADY
);
    
    // enable for pipeline registers
    wire pipeline_enable;
    wire IF_ready;
    wire is_not_done;
    
    // ********************************* IF Stage *********************************
    reg  [31:0] pc;
    wire [31:0] pc1;
    wire [31:0] pc2;
    wire [31:0] pc_ID;
    wire [31:0] pc_EX;
    wire [31:0] pc_incr4;
    wire [31:0] pc_incr4_ID;
    wire [31:0] pc_incr4_EX;
    wire [31:0] pc_incr4_MEM;
    wire [31:0] pc_incr4_WB;
    wire        stall;
    wire        flush_IF_ID;
    wire        pcsel1;
    wire        pcsel2;
    wire [31:0] instr;
    wire [31:0] instr_ID;
    
    // ********************************* ID Stage *********************************
    wire [4:0]  rs1;
    wire [4:0]  rs1_EX;
    wire [4:0]  rs2;
    wire [4:0]  rs2_EX;
    wire [4:0]  w_reg;
    wire [4:0]  w_reg_EX;
    wire [4:0]  w_reg_MEM;
    wire [4:0]  w_reg_WB;
    wire [2:0]  funct3;
    wire [2:0]  funct3_EX;
    wire [6:0]  funct7;
    wire [6:0]  funct7_EX;
    wire [31:0] imm;
    wire [31:0] imm_EX;
    wire [31:0] dataA;
    wire [31:0] dataA_EX;
    wire [31:0] dataB;
    wire [31:0] dataB_EX;
    wire [31:0] dataD;
    wire [31:0] dataW;
    wire [31:0] dataW_MEM;
    wire [31:0] dataR;
    wire [31:0] dataR_gen;       
    wire [31:0] dataR_gen_WB;
    wire [31:0] rs1_data;
    
    // ********************************* EX Stage *********************************
    reg  [31:0] alusrcA;
    reg  [31:0] alusrcB_temp;
    wire [31:0] alusrcB;
    wire        sign_bit;
    wire [31:0] alu_result;
    wire [31:0] alu_result_MEM;
    wire [31:0] alu_result_WB;
    wire [31:0] slt_data;
    wire [31:0] slt_data_MEM;
    wire [31:0] slt_data_WB;
    wire [31:0] auipc_lui_data;
    wire [31:0] auipc_lui_data_MEM;
    wire [31:0] auipc_lui_data_WB;
    
    wire regwrite;
    wire regwrite_EX;
    wire regwrite_MEM;
    wire regwrite_WB;
    wire wb;
    wire wb_EX;
    wire wb_MEM;
    wire wb_WB;
    wire slt;
    wire slt_EX;
    wire slt_MEM;
    wire slt_WB;
    wire jump;
    wire jump_EX;
    wire jump_MEM;
    wire jump_WB;
    wire memtoreg;
    wire memtoreg_EX;
    wire memtoreg_MEM;
    wire memtoreg_WB;
    wire memwrite;
    wire memwrite_EX;
    wire memwrite_MEM;
    wire unsigned_ID;
    wire unsigned_EX;
    wire unsigned_MEM;
    wire memread;
    wire memread_EX;
    wire memread_MEM;
    wire auipc_lui;
    wire auipc_lui_EX;
    wire alusrc;
    wire alusrc_EX;
    wire [3:0] alu_control;
    wire ls_b;
    wire ls_b_EX;
    wire ls_b_MEM;
    wire ls_h;
    wire ls_h_EX;
    wire ls_h_MEM;
    wire jalr;
    wire jalr_EX;
    wire jalr_MEM;
    wire jal;
    wire jal_EX;
    wire jal_MEM;
    wire branch;
    wire branch_EX;
    wire branch_MEM;
    wire [2:0] fwd1;
    wire [2:0] fwd2;
    wire [6:0] opcode;
    wire [6:0] opcode_EX;
    
    // ********************************* MEM Stage ********************************
    reg [DATA_WIDTH-1:0] d_RDATA_reg;
    // ********************************* WB Stage *********************************
    wire [31:0] dataD_memtoreg;
    wire [31:0] dataD_jump;
    wire [31:0] dataD_slt;

    pipeline_control u_pipeline_control (
        .ACLK              (ACLK),  // Clock signal
        .ARESETn           (ARESETn),  // Active-low reset signal
        // D-Cache related signals
        .i_memwrite_EX     (memwrite_EX & IF_ready),  // MEM Write enable from EX stage
        .i_memread_EX      (memread_EX & IF_ready),  // MEM Read enable from EX stage
        .i_d_BVALID        (d_BVALID),  // BVALID signal from AXI response
        .i_d_RVALID        (d_RVALID),  // RVALID signal from AXI response
        .i_d_RLAST         (d_RLAST),  // RLAST signal from AXI response
        // // I-Cache related signals
        // .i_RRESP           (i_RRESP ),
        // .i_RLAST           (i_RLAST ),
        // .i_RVALID          (i_RVALID),
        .o_enable          (pipeline_enable)   // Output enable signal for pipeline control
    );
    
    assign IF_ready = i_RVALID & i_RLAST & (i_RRESP == 0);
    assign is_not_done = (pc >> 2) < 256;
    
    // ****************************************************************************
    // START - for calculate performance purpose only
    // ****************************************************************************
    reg [31:0] instr_num;
    reg [31:0] runtime_in_cycle;
    
    always @(posedge ACLK) begin
        if (!ARESETn) begin
            runtime_in_cycle <= 0;
        end
        else begin
            runtime_in_cycle <= runtime_in_cycle + (enable & is_not_done);
        end
    end
    
    always @(posedge ACLK) begin
        if (!ARESETn) begin
            instr_num <= 0;
        end
        else begin
            instr_num <= instr_num + i_RVALID;
        end
    end
    
    // ****************************************************************************
    // END - for calculate performance purpose only
    // ****************************************************************************
    
    // ********************************* IF Stage *********************************
    always @(posedge ACLK) begin
        if(!ARESETn) begin
            pc <= 0;
        end
        else 
        if (pipeline_enable & IF_ready) begin
            if(stall) begin
                pc <= pc;
            end
            else begin
                pc <= (pcsel2) ? pc2 : ((pcsel1) ? pc1 : pc_incr4);
            end
        end
    end

    assign pc_incr4    = pc + 4;
    assign pc1         = pc_EX + (imm_EX << 1);
    assign pc2         = rs1_data + imm_EX;
    assign flush_IF_ID = pcsel1 | pcsel2;
    
    instr_riscv_axi_wrapper
    #(
        .ID        (ID + 2    ),
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH),
        .ID_WIDTH  (ID_WIDTH  ),
        .USER_WIDTH(USER_WIDTH),
        .STRB_WIDTH(DATA_WIDTH/8),
        .ADDR_START(CODE_REGION_START), // start address of code region
        .ADDR_END  (CODE_REGION_END  ) // end address of code region
    )
    i_cache_axi_wrapper
    (
        // system signals
        .ACLK       (ACLK   ),
        .ARESETn    (ARESETn),
        
        // enable
        .enable     (enable),
        
        // Interface connect with D-Cache
        // D-Cache enable
        .i_CACHE_EN (i_CACHE_EN),
        
        // AXI5 Interface
        // AW Channel
        .i_AWID     (i_AWID    ),
        .i_AWADDR   (i_AWADDR  ),
        .i_AWLEN    (i_AWLEN   ),
        .i_AWSIZE   (i_AWSIZE  ),
        .i_AWBURST  (i_AWBURST ),
        .i_AWLOCK   (i_AWLOCK  ),
        .i_AWCACHE  (i_AWCACHE ),
        .i_AWPROT   (i_AWPROT  ),
        .i_AWQOS    (i_AWQOS   ),
        .i_AWREGION (i_AWREGION),
        .i_AWUSER   (i_AWUSER  ),
        .i_AWVALID  (i_AWVALID ),
        .i_AWREADY  (i_AWREADY ),
        
        // W Channel
        .i_WDATA    (i_WDATA ),
        .i_WSTRB    (i_WSTRB ), 
        .i_WLAST    (i_WLAST ),
        .i_WUSER    (i_WUSER ),
        .i_WVALID   (i_WVALID),
        .i_WREADY   (i_WREADY),
        
        // B Channel
        .i_BID      (i_BID   ),
        .i_BRESP    (i_BRESP ),
        .i_BUSER    (i_BUSER ),
        .i_BVALID   (i_BVALID),
        .i_BREADY   (i_BREADY),
       
        // AR Channel
        .i_ARID     (i_ARID    ),
        .i_ARADDR   (i_ARADDR  ),
        .i_ARLEN    (i_ARLEN   ),
        .i_ARSIZE   (i_ARSIZE  ),
        .i_ARBURST  (i_ARBURST ),
        .i_ARLOCK   (i_ARLOCK  ),
        .i_ARCACHE  (i_ARCACHE ),
        .i_ARPROT   (i_ARPROT  ),
        .i_ARQOS    (i_ARQOS   ),
        .i_ARREGION (i_ARREGION),
        .i_ARUSER   (i_ARUSER  ),
        .i_ARVALID  (i_ARVALID ),
        .i_ARREADY  (i_ARREADY ),
        
        // R Channel
        .i_RID      (i_RID   ),
        .i_RDATA    (i_RDATA ),
        .i_RRESP    (i_RRESP ),
        .i_RLAST    (i_RLAST ),
        .i_RUSER    (i_RUSER ),
        .i_RVALID   (i_RVALID),
        .i_RREADY   (i_RREADY),
        
        // interface connect with Instruction Mem
        .i_imem_access(pipeline_enable & is_not_done),  // should asserted every cycle
        .i_r0w1       (1'b0),  // only used read operation
        .i_pc         (pc),  // address to load instruction
        .i_w_data     (0)   // should be not used as instruction is read-only
    );
    
    // imem #(
    //     .DATA_WIDTH (DATA_WIDTH), 
    //     .ADDR_WIDTH (ADDR_WIDTH), 
    //     .IMEM_PATH  (IMEM_PATH)
    // ) u_imem (
    //     .i_addr (pc),
    //     .o_data (instr)
    // );
    assign instr = i_RDATA;
    
    IF_ID_register u_IF_ID_register (
        .i_clk         (ACLK),
        .i_rst_n       (ARESETn),
        .i_enable      (pipeline_enable & IF_ready),
        .i_blocking    (stall),
        .i_flush_IF    (flush_IF_ID),
        .i_pc_incr4_IF (pc_incr4),
        .i_pc_IF       (pc),
        .i_inst_IF     (instr),
        .o_pc_incr4_ID (pc_incr4_ID),
        .o_pc_ID       (pc_ID),
        .o_inst_ID     (instr_ID)
    );

    // ********************************* ID Stage *********************************
    assign opcode = instr_ID[6:0];
    assign funct3 = instr_ID[14:12];
    assign funct7 = instr_ID[31:25];
    assign rs1    = instr_ID[19:15];
    assign rs2    = instr_ID[24:20];
    assign w_reg  = instr_ID[11:7];
    
    hazard_detect_unit u_hazard_detect_unit (
        .i_rs1        (rs1),
        .i_rs2        (rs2),
        .i_memread    (memread_EX),
        .i_write_reg  (w_reg_EX),
        .o_stall      (stall)
    );

    main_control u_main_control (
        .i_stall       (stall),
        .i_opcode      (opcode),
        .i_funct3      (funct3),
        .i_funct7      (funct7),
        .o_regwrite    (regwrite),
        .o_wb          (wb),
        .o_slt         (slt),
        .o_jump        (jump),
        .o_memtoreg    (memtoreg),
        .o_memwrite    (memwrite),
        .o_unsigned    (unsigned_ID),   // not use unsigned because this is the same name with "unsigned" syntax
        .o_memread     (memread),
        .o_auipc_lui   (auipc_lui),
        .o_alusrc      (alusrc),
        .o_ls_b        (ls_b),
        .o_ls_h        (ls_h),
        .o_jalr        (jalr),
        .o_jal         (jal),
        .o_branch      (branch)
    );
    
    
    register_file u_register_file (
        .clk         (ACLK),
        .rst_n       (ARESETn),
        // regfile
        .reg_rd_en   (reg_rd_en),
        .reg_addr    (reg_addr ),
        .reg_data    (reg_data ),
        
        .regwrite    (regwrite_WB),
        .write_reg   (w_reg_WB),
        .write_data  (dataD),
        .rs1         (rs1),
        .rs2         (rs2),
        .read_data1  (dataA),
        .read_data2  (dataB)
    );
    
    imm_gen u_imm_gen (
        .i_opcode   (opcode),
        .i_funct3   (funct3),
        .i_instr    (instr_ID),
        .o_imm_ext  (imm)
    );
    
    ID_EX_register u_ID_EX_register (
        .i_clk             (ACLK),
        .i_rst_n           (ARESETn),
        .i_enable          (pipeline_enable & IF_ready),
        .i_flush_ID        (flush_IF_ID),
        .i_regwrite_ID     (regwrite),
        .i_wb_ID           (wb),
        .i_slt_ID          (slt),
        .i_jump_ID         (jump),
        .i_memtoreg_ID     (memtoreg),
        .i_memwrite_ID     (memwrite),
        .i_unsigned_ID     (unsigned_ID),
        .i_memread_ID      (memread),
        .i_auipc_lui_ID    (auipc_lui),
        .i_alusrc_ID       (alusrc),
        .i_ls_b_ID         (ls_b),
        .i_ls_h_ID         (ls_h),
        .i_jalr_ID         (jalr),
        .i_jal_ID          (jal),
        .i_branch_ID       (branch),
        .i_pc_incr4_ID     (pc_incr4_ID),
        .i_pc_ID           (pc_ID),
        .i_dataA_ID        (dataA),
        .i_dataB_ID        (dataB),
        .i_imm_ID          (imm),
        .i_opcode_ID       (opcode),
        .i_funct3_ID       (funct3),
        .i_funct7_ID       (funct7),
        .i_write_reg_ID    (w_reg),
        .i_rs1_ID          (rs1),
        .i_rs2_ID          (rs2),
        .o_regwrite_EX     (regwrite_EX),
        .o_wb_EX           (wb_EX       ),
        .o_slt_EX          (slt_EX      ),
        .o_jump_EX         (jump_EX     ),
        .o_memtoreg_EX     (memtoreg_EX ),
        .o_memwrite_EX     (memwrite_EX ),
        .o_unsigned_EX     (unsigned_EX ),
        .o_memread_EX      (memread_EX  ),
        .o_auipc_lui_EX    (auipc_lui_EX),
        .o_alusrc_EX       (alusrc_EX   ),
        .o_ls_b_EX         (ls_b_EX     ),
        .o_ls_h_EX         (ls_h_EX     ),
        .o_jalr_EX         (jalr_EX     ),
        .o_jal_EX          (jal_EX      ),
        .o_branch_EX       (branch_EX   ),
        .o_pc_incr4_EX     (pc_incr4_EX),
        .o_pc_EX           (pc_EX),
        .o_dataA_EX        (dataA_EX),
        .o_dataB_EX        (dataB_EX),
        .o_imm_EX          (imm_EX),
        .o_opcode_EX       (opcode_EX   ),
        .o_funct3_EX       (funct3_EX   ),
        .o_funct7_EX       (funct7_EX   ),
        .o_write_reg_EX    (w_reg_EX),
        .o_rs1_EX          (rs1_EX      ),
        .o_rs2_EX          (rs2_EX      )
    );

    // ********************************* EX Stage *********************************
    // select alusrcA, alusrcB
    always @(*) begin
        case(fwd1)
            0: alusrcA = alu_result_MEM;
            1: alusrcA = dataA_EX;
            2: alusrcA = slt_data_MEM;
            3: alusrcA = auipc_lui_data_MEM;
            4: alusrcA = pc_incr4_MEM;
            5: alusrcA = dataD;
            default: alusrcA = dataA_EX;
        endcase
        case(fwd2)
            0: alusrcB_temp = dataB_EX;
            1: alusrcB_temp = alu_result_MEM;
            2: alusrcB_temp = slt_data_MEM;
            3: alusrcB_temp = auipc_lui_data_MEM;
            4: alusrcB_temp = pc_incr4_MEM;
            5: alusrcB_temp = dataD;
            default: alusrcB_temp = dataB_EX;
        endcase
    end
    assign alusrcB = (alusrc_EX) ? imm_EX : alusrcB_temp;
    
    // select data for auipc_lui_data
    assign auipc_lui_data = (auipc_lui_EX) ? (imm_EX << 12) : (pc_EX + (imm_EX << 12));
    
    // select data for slt_data
    assign slt_data = (sign_bit) ? 1 : 0;
    
    // write dato to mem
    assign dataW = alusrcB_temp;
    
    branch_unit u_branch_unit (
        .i_jalr_EX            (jalr_EX  ),
        .i_branch_EX          (branch_EX),
        .i_funct3_EX          (funct3_EX),
     
        .i_rs1_EX             (rs1_EX   ),
        .i_rs2_EX             (rs2_EX   ),
    
        .i_jump_EX            (jump_EX       ),
    
        .i_write_reg_MEM      (w_reg_MEM         ),
        .i_jump_MEM           (jump_MEM          ),
        .i_wb_MEM             (wb_MEM            ),
        .i_slt_MEM            (slt_MEM           ),
        .i_memread_MEM        (memread_MEM       ),
        .i_pc_incr4_MEM       (pc_incr4_MEM      ),
        .i_auipc_lui_data_MEM (auipc_lui_data_MEM),
        .i_slt_data_MEM       (slt_data_MEM      ),
        .i_alu_result_MEM     (alu_result_MEM    ),
        .i_dataR_gen          (dataR_gen         ),
    
        .i_write_reg_WB       (w_reg_WB         ),
        .i_jump_WB            (jump_WB          ),
        .i_wb_WB              (wb_WB            ),
        .i_slt_WB             (slt_WB           ),
        .i_regwrite_WB        (regwrite_WB      ),
        .i_pc_incr4_WB        (pc_incr4_WB      ),
        .i_auipc_lui_data_WB  (auipc_lui_data_WB),
        .i_slt_data_WB        (slt_data_WB      ),
        .i_alu_result_WB      (alu_result_WB    ),
        .i_dataD              (dataD            ),
    
        .i_dataA_EX           (dataA_EX),
        .i_dataB_EX           (dataB_EX),
    
        .o_rs1_data           (rs1_data),
        .o_pcsel1             (pcsel1  ),
        .o_pcsel2             (pcsel2  )
    );
        
    alu u_alu (
        .i_alu_control  (alu_control),
        .i_alusrcA      (alusrcA    ),
        .i_alusrcB      (alusrcB    ),
        .o_alu_result   (alu_result ),
        .o_sign_bit     (sign_bit   )
    );
    
    alu_control u_alu_control (
        .i_opcode       (opcode_EX),
        .i_funct3       (funct3_EX),
        .i_funct7       (funct7_EX),
        .o_alu_control  (alu_control)
    );

    forwarding_unit u_forwarding_unit (
        .i_rs1_EX            (rs1_EX      ),
        .i_rs2_EX            (rs2_EX      ),
        .i_write_reg_MEM     (w_reg_MEM   ),
        .i_write_reg_WB      (w_reg_WB    ),
        .i_regwrite_MEM      (regwrite_MEM),
        .i_regwrite_WB       (regwrite_WB ),
        .i_wb_MEM            (wb_MEM      ),
        .i_slt_MEM           (slt_MEM     ),
        .i_jump_MEM          (jump_MEM    ),
        .i_memtoreg_MEM      (memtoreg_MEM),
        .o_fwd1              (fwd1        ),
        .o_fwd2              (fwd2        )
    );
    
    EX_MEM_register u_EX_MEM_register (
        .i_clk                (ACLK),
        .i_rst_n              (ARESETn),
        .i_enable             (pipeline_enable & IF_ready),
        .i_regwrite_EX        (regwrite_EX),
        .i_wb_EX              (wb_EX      ),
        .i_slt_EX             (slt_EX     ),
        .i_jump_EX            (jump_EX    ),
        .i_memtoreg_EX        (memtoreg_EX),
        .i_memwrite_EX        (memwrite_EX),
        .i_unsigned_EX        (unsigned_EX),
        .i_memread_EX         (memread_EX ),
        .i_ls_b_EX            (ls_b_EX    ),
        .i_ls_h_EX            (ls_h_EX    ),
        .i_jalr_EX            (jalr_EX    ),
        .i_jal_EX             (jal_EX     ),
        .i_branch_EX          (branch_EX  ),
        .i_pc_incr4_EX        (pc_incr4_EX),
        .i_auipc_lui_data_EX  (auipc_lui_data),
        .i_slt_data_EX        (slt_data),
        .i_alu_result_EX      (alu_result),
        .i_dataW_EX           (dataW),
        .i_write_reg_EX       (w_reg_EX),
        .o_regwrite_MEM       (regwrite_MEM),
        .o_wb_MEM             (wb_MEM      ),
        .o_slt_MEM            (slt_MEM     ),
        .o_jump_MEM           (jump_MEM    ),
        .o_memtoreg_MEM       (memtoreg_MEM),
        .o_memwrite_MEM       (memwrite_MEM),
        .o_unsigned_MEM       (unsigned_MEM),
        .o_memread_MEM        (memread_MEM ),
        .o_ls_b_MEM           (ls_b_MEM    ),
        .o_ls_h_MEM           (ls_h_MEM    ),
        .o_jalr_MEM           (jalr_MEM    ),
        .o_jal_MEM            (jal_MEM     ),
        .o_branch_MEM         (branch_MEM  ),
        .o_pc_incr4_MEM       (pc_incr4_MEM),
        .o_auipc_lui_data_MEM (auipc_lui_data_MEM),
        .o_slt_data_MEM       (slt_data_MEM      ),
        .o_alu_result_MEM     (alu_result_MEM    ),
        .o_dataW_MEM          (dataW_MEM),
        .o_write_reg_MEM      (w_reg_MEM)
    );

    // ********************************* MEM Stage ********************************
    riscv_axi_wrapper #(
        .ID                    (ID        ),
        .DATA_WIDTH            (DATA_WIDTH),
        .ADDR_WIDTH            (ADDR_WIDTH),
        .ID_WIDTH              (ID_WIDTH  ),
        .USER_WIDTH            (USER_WIDTH),
        .STRB_WIDTH            (STRB_WIDTH),
        .SHAREABLE_REGION_START(SHAREABLE_REGION_START),
        .SHAREABLE_REGION_END  (SHAREABLE_REGION_END  )
    ) d_cache_axi_wrapper (
        // system signals
        .ACLK                  (ACLK),
        .ARESETn               (ARESETn),
        
        // Interface connect with D-Cache
        .d_CACHE_EN            (d_CACHE_EN),
        
        // AXI5 Interface
        // AW Channel
        .d_AWID                (d_AWID    ),
        .d_AWADDR              (d_AWADDR  ),
        .d_AWLEN               (d_AWLEN   ),
        .d_AWSIZE              (d_AWSIZE  ),
        .d_AWBURST             (d_AWBURST ),
        .d_AWLOCK              (d_AWLOCK  ),
        .d_AWCACHE             (d_AWCACHE ),
        .d_AWPROT              (d_AWPROT  ),
        .d_AWQOS               (d_AWQOS   ),
        .d_AWREGION            (d_AWREGION),
        .d_AWUSER              (d_AWUSER  ),
        .d_AWDOMAIN            (d_AWDOMAIN),
        .d_AWVALID             (d_AWVALID ),
        .d_AWREADY             (d_AWREADY ),
        
        // W Channel
        .d_WDATA               (d_WDATA ),
        .d_WSTRB               (d_WSTRB ),
        .d_WLAST               (d_WLAST ),
        .d_WUSER               (d_WUSER ),
        .d_WVALID              (d_WVALID),
        .d_WREADY              (d_WREADY),
        
        // B Channel
        .d_BID                 (d_BID   ),
        .d_BRESP               (d_BRESP ),
        .d_BUSER               (d_BUSER ),
        .d_BVALID              (d_BVALID),
        .d_BREADY              (d_BREADY),
       
        // AR Channel
        .d_ARID                (d_ARID    ),
        .d_ARADDR              (d_ARADDR  ),
        .d_ARLEN               (d_ARLEN   ),
        .d_ARSIZE              (d_ARSIZE  ),
        .d_ARBURST             (d_ARBURST ),
        .d_ARLOCK              (d_ARLOCK  ),
        .d_ARCACHE             (d_ARCACHE ),
        .d_ARPROT              (d_ARPROT  ),
        .d_ARQOS               (d_ARQOS   ),
        .d_ARREGION            (d_ARREGION),
        .d_ARUSER              (d_ARUSER  ),
        .d_ARDOMAIN            (d_ARDOMAIN),
        .d_ARVALID             (d_ARVALID ),
        .d_ARREADY             (d_ARREADY ),
        
        // R Channel
        .d_RID                 (d_RID   ),
        .d_RDATA               (d_RDATA ),
        .d_RRESP               (d_RRESP ),
        .d_RLAST               (d_RLAST ),
        .d_RUSER               (d_RUSER ),
        .d_RVALID              (d_RVALID),
        .d_RREADY              (d_RREADY),
        
        // interface connect with Data Ram
        .i_write_dmem          (memwrite_EX & IF_ready),
        .i_waddr_dmem          (alu_result_MEM),
        .i_wdata_dmem          (dataW_MEM),
        
        .i_read_dmem           (memread_EX & IF_ready),
        .i_raddr_dmem          (alu_result_MEM),
        
        .i_ls_b                (ls_b_MEM),
        .i_ls_h                (ls_h_MEM)
    );
    
    MEM_WB_register u_MEM_WB_register (
        .i_clk                (ACLK),
        .i_rst_n              (ARESETn),
        .i_enable             (pipeline_enable & IF_ready),
        .i_regwrite_MEM       (regwrite_MEM),
        .i_wb_MEM             (wb_MEM      ),
        .i_slt_MEM            (slt_MEM     ),
        .i_jump_MEM           (jump_MEM    ),
        .i_memtoreg_MEM       (memtoreg_MEM),
        .i_pc_incr4_MEM       (pc_incr4_MEM),
        .i_auipc_lui_data_MEM (auipc_lui_data_MEM),
        .i_slt_data_MEM       (slt_data_MEM      ),
        .i_dataR_gen_MEM      (dataR_gen),
        .i_alu_result_MEM     (alu_result_MEM),
        .i_write_reg_MEM      (w_reg_MEM),
        .o_regwrite_WB        (regwrite_WB),
        .o_wb_WB              (wb_WB      ),
        .o_slt_WB             (slt_WB     ),
        .o_jump_WB            (jump_WB    ),
        .o_memtoreg_WB        (memtoreg_WB),
        .o_pc_incr4_WB        (pc_incr4_WB),
        .o_auipc_lui_data_WB  (auipc_lui_data_WB),
        .o_slt_data_WB        (slt_data_WB      ),
        .o_dataR_gen_WB       (dataR_gen_WB),
        .o_alu_result_WB      (alu_result_WB),
        .o_write_reg_WB       (w_reg_WB)
    );

    // ********************************* WB Stage *********************************
    //To Reg File
    assign dataD_memtoreg = (memtoreg_WB) ? dataR_gen_WB : alu_result_WB;
    assign dataD_jump     = (jump_WB) ? pc_incr4_WB : dataD_memtoreg;
    assign dataD_slt      = (slt_WB) ? slt_data_WB : dataD_jump;
    assign dataD          = (wb_WB) ? auipc_lui_data_WB : dataD_slt;
    
    // loaded data from dmem (D-Cache)
    always @(posedge ACLK) begin
        if (d_RVALID && d_RLAST) begin
            d_RDATA_reg <= d_RDATA;
        end
    end
    assign dataR = d_RDATA_reg;
    assign dataR_gen = (unsigned_MEM) ? ((ls_b_MEM) ? dataR[7:0] : ((ls_h_MEM) ? dataR[15:0] : dataR)) : ((ls_b_MEM) ? {{24{dataR[7]}}, dataR[7:0]} : ((ls_h_MEM) ? {{16{dataR[15]}}, dataR[15:0]} : dataR));
    
endmodule
