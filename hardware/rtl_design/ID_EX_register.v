//////////////////////////////////////////////////////////////////////////////////
// ID-EX pipeline register
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module ID_EX_register(
    input               i_clk,
    input               i_rst_n,
    input               i_enable,
    input               i_flush_ID,
    input               i_regwrite_ID,
    input               i_wb_ID,
    input               i_slt_ID,
    input               i_jump_ID,
    input               i_memtoreg_ID,
    input               i_memwrite_ID,
    input               i_unsigned_ID,
    input               i_memread_ID,
    input               i_auipc_lui_ID,
    input               i_alusrc_ID,
    input               i_ls_b_ID,
    input               i_ls_h_ID,
    input               i_jalr_ID, 
    input               i_jal_ID, 
    input               i_branch_ID,
    input [31:0]        i_pc_incr4_ID,
    input [31:0]        i_pc_ID,
    input [31:0]        i_dataA_ID,
    input [31:0]        i_dataB_ID,
    input [31:0]        i_imm_ID,
    input [6:0]         i_opcode_ID,
    input [2:0]         i_funct3_ID,
    input [6:0]         i_funct7_ID,
    input [4:0]         i_write_reg_ID,
    input [4:0]         i_rs1_ID,
    input [4:0]         i_rs2_ID,
    
    output reg          o_regwrite_EX,   
    output reg          o_wb_EX,       
    output reg          o_slt_EX,      
    output reg          o_jump_EX,     
    output reg          o_memtoreg_EX, 
    output reg          o_memwrite_EX, 
    output reg          o_unsigned_EX, 
    output reg          o_memread_EX,  
    output reg          o_auipc_lui_EX,
    output reg          o_alusrc_EX,
    output reg          o_ls_b_EX,
    output reg          o_ls_h_EX,
    output reg          o_jalr_EX, 
    output reg          o_jal_EX, 
    output reg          o_branch_EX,    
    output reg [31:0]   o_pc_incr4_EX, 
    output reg [31:0]   o_pc_EX,       
    output reg [31:0]   o_dataA_EX,    
    output reg [31:0]   o_dataB_EX,    
    output reg [31:0]   o_imm_EX,
    output reg [6:0]    o_opcode_EX,    
    output reg [2:0]    o_funct3_EX,   
    output reg [6:0]    o_funct7_EX,   
    output reg [4:0]    o_write_reg_EX,    
    output reg [4:0]    o_rs1_EX,      
    output reg [4:0]    o_rs2_EX
);
    
    always @(posedge i_clk) begin
        if(!i_rst_n) begin
            o_regwrite_EX   <= 0;   
            o_wb_EX         <= 0;       
            o_slt_EX        <= 0;      
            o_jump_EX       <= 0;     
            o_memtoreg_EX   <= 0; 
            o_memwrite_EX   <= 0; 
            o_unsigned_EX   <= 0; 
            o_memread_EX    <= 0;  
            o_auipc_lui_EX  <= 0;
            o_alusrc_EX     <= 0;
            o_ls_b_EX       <= 0;
            o_ls_h_EX       <= 0;
            o_jalr_EX       <= 0; 
            o_jal_EX        <= 0; 
            o_branch_EX     <= 0;
            o_pc_incr4_EX   <= 0; 
            o_pc_EX         <= 0;       
            o_dataA_EX      <= 0;    
            o_dataB_EX      <= 0;    
            o_imm_EX        <= 0;
            o_opcode_EX     <= 0;      
            o_funct3_EX     <= 0;   
            o_funct7_EX     <= 0;   
            o_write_reg_EX  <= 0;    
            o_rs1_EX        <= 0;      
            o_rs2_EX        <= 0;  
        end
        else 
        if (i_enable) begin
            if (i_flush_ID) begin
                o_regwrite_EX   <= 0;
                o_wb_EX         <= 0;
                o_slt_EX        <= 0;
                o_jump_EX       <= 0;
                o_memtoreg_EX   <= 0;
                o_memwrite_EX   <= 0;
                o_unsigned_EX   <= 0;
                o_memread_EX    <= 0;
                o_auipc_lui_EX  <= 0;
                o_alusrc_EX     <= 0;
                o_ls_b_EX       <= 0;
                o_ls_h_EX       <= 0;
                o_jalr_EX       <= 0;
                o_jal_EX        <= 0;
                o_branch_EX     <= 0;
                o_pc_incr4_EX   <= 0;
                o_pc_EX         <= 0;
                o_dataA_EX      <= 0;
                o_dataB_EX      <= 0;
                o_imm_EX        <= 0;
                o_opcode_EX     <= 0;
                o_funct3_EX     <= 0;
                o_funct7_EX     <= 0;
                o_write_reg_EX  <= 0;
                o_rs1_EX        <= 0;
                o_rs2_EX        <= 0;
            end
            else begin 
                o_regwrite_EX   <= i_regwrite_ID; 
                o_wb_EX         <= i_wb_ID;  
                o_slt_EX        <= i_slt_ID;     
                o_jump_EX       <= i_jump_ID;
                o_memtoreg_EX   <= i_memtoreg_ID;
                o_memwrite_EX   <= i_memwrite_ID;
                o_unsigned_EX   <= i_unsigned_ID;
                o_memread_EX    <= i_memread_ID;
                o_auipc_lui_EX  <= i_auipc_lui_ID;
                o_alusrc_EX     <= i_alusrc_ID;
                o_ls_b_EX       <= i_ls_b_ID;
                o_ls_h_EX       <= i_ls_h_ID;
                o_jalr_EX       <= i_jalr_ID; 
                o_jal_EX        <= i_jal_ID; 
                o_branch_EX     <= i_branch_ID;
                o_pc_incr4_EX   <= i_pc_incr4_ID;
                o_pc_EX         <= i_pc_ID;
                o_dataA_EX      <= i_dataA_ID; 
                o_dataB_EX      <= i_dataB_ID;
                o_imm_EX        <= i_imm_ID;
                o_opcode_EX     <= i_opcode_ID;
                o_funct3_EX     <= i_funct3_ID;
                o_funct7_EX     <= i_funct7_ID;
                o_write_reg_EX  <= i_write_reg_ID;
                o_rs1_EX        <= i_rs1_ID;
                o_rs2_EX        <= i_rs2_ID;
            end
        end
    end

endmodule