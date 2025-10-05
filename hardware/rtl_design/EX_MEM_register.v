`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// EX-MEM pipeline register
//////////////////////////////////////////////////////////////////////////////////

module EX_MEM_register(
    input               i_clk,
    input               i_rst_n,
    input               i_enable,
    input               i_regwrite_EX,
    input               i_wb_EX,
    input               i_slt_EX,
    input               i_jump_EX,
    input               i_memtoreg_EX,
    input               i_memwrite_EX, 
    input               i_unsigned_EX, 
    input               i_memread_EX,
    input               i_ls_b_EX,
    input               i_ls_h_EX,
    input               i_jalr_EX, 
    input               i_jal_EX, 
    input               i_branch_EX,
    input [31:0]        i_pc_incr4_EX,
    input [31:0]        i_auipc_lui_data_EX,
    input [31:0]        i_slt_data_EX,
    input [31:0]        i_alu_result_EX,
    input [31:0]        i_dataW_EX,
    input [4:0]         i_write_reg_EX,
    
    output reg          o_regwrite_MEM,
    output reg          o_wb_MEM,
    output reg          o_slt_MEM,
    output reg          o_jump_MEM,
    output reg          o_memtoreg_MEM,
    output reg          o_memwrite_MEM, 
    output reg          o_unsigned_MEM, 
    output reg          o_memread_MEM,
    output reg          o_ls_b_MEM,
    output reg          o_ls_h_MEM,
    output reg          o_jalr_MEM, 
    output reg          o_jal_MEM, 
    output reg          o_branch_MEM,
    output reg [31:0]   o_pc_incr4_MEM,
    output reg [31:0]   o_auipc_lui_data_MEM,
    output reg [31:0]   o_slt_data_MEM,
    output reg [31:0]   o_alu_result_MEM,
    output reg [31:0]   o_dataW_MEM,
    output reg [4:0]    o_write_reg_MEM
);

    always @(posedge i_clk) begin
        if (!i_rst_n) begin
            o_regwrite_MEM         <= 0;
            o_wb_MEM               <= 0;
            o_slt_MEM              <= 0;
            o_jump_MEM             <= 0;
            o_memtoreg_MEM         <= 0;
            o_memwrite_MEM         <= 0; 
            o_unsigned_MEM         <= 0; 
            o_memread_MEM          <= 0;
            o_ls_b_MEM             <= 0;
            o_ls_h_MEM             <= 0;
            o_jalr_MEM             <= 0; 
            o_jal_MEM              <= 0; 
            o_branch_MEM           <= 0;
            o_pc_incr4_MEM         <= 0;
            o_auipc_lui_data_MEM   <= 0;
            o_slt_data_MEM         <= 0;
            o_alu_result_MEM       <= 0;
            o_dataW_MEM            <= 0;
            o_write_reg_MEM        <= 0;
        end
        else 
        if (i_enable) begin 
            o_regwrite_MEM         <= i_regwrite_EX;
            o_wb_MEM               <= i_wb_EX;
            o_slt_MEM              <= i_slt_EX;
            o_jump_MEM             <= i_jump_EX;
            o_memtoreg_MEM         <= i_memtoreg_EX;
            o_memwrite_MEM         <= i_memwrite_EX;
            o_unsigned_MEM         <= i_unsigned_EX;
            o_memread_MEM          <= i_memread_EX;
            o_ls_b_MEM             <= i_ls_b_EX;
            o_ls_h_MEM             <= i_ls_h_EX;
            o_jalr_MEM             <= i_jalr_EX; 
            o_jal_MEM              <= i_jal_EX; 
            o_branch_MEM           <= i_branch_EX;
            o_pc_incr4_MEM         <= i_pc_incr4_EX;
            o_auipc_lui_data_MEM   <= i_auipc_lui_data_EX;
            o_slt_data_MEM         <= i_slt_data_EX;
            o_alu_result_MEM       <= i_alu_result_EX;
            o_dataW_MEM            <= i_dataW_EX;
            o_write_reg_MEM        <= i_write_reg_EX;
        end
    end

endmodule

