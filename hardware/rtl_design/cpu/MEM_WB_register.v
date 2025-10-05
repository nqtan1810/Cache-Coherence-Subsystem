`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// EX-MEM pipeline register
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module MEM_WB_register(
    input               i_clk,
    input               i_rst_n,
    input               i_enable,
    input               i_regwrite_MEM,
    input               i_wb_MEM,
    input               i_slt_MEM,
    input               i_jump_MEM,
    input               i_memtoreg_MEM,
    input [31:0]        i_pc_incr4_MEM,
    input [31:0]        i_auipc_lui_data_MEM,
    input [31:0]        i_slt_data_MEM,
    input [31:0]        i_dataR_gen_MEM,
    input [31:0]        i_alu_result_MEM,
    input [4:0]         i_write_reg_MEM,

    output reg          o_regwrite_WB,
    output reg          o_wb_WB,
    output reg          o_slt_WB,
    output reg          o_jump_WB,
    output reg          o_memtoreg_WB,
    output reg [31:0]   o_pc_incr4_WB,
    output reg [31:0]   o_auipc_lui_data_WB,
    output reg [31:0]   o_slt_data_WB,
    output reg [31:0]   o_dataR_gen_WB,
    output reg [31:0]   o_alu_result_WB,
    output reg [4:0]    o_write_reg_WB
);

    always @(posedge i_clk) begin
        if (!i_rst_n) begin
            o_regwrite_WB         <= 0;
            o_wb_WB               <= 0;
            o_slt_WB              <= 0;
            o_jump_WB             <= 0;
            o_memtoreg_WB         <= 0;
            o_pc_incr4_WB         <= 0;
            o_auipc_lui_data_WB   <= 0;
            o_slt_data_WB         <= 0;
            o_dataR_gen_WB        <= 0;
            o_alu_result_WB       <= 0;
            o_write_reg_WB        <= 0;
        end
        else 
        if (i_enable) begin
            o_regwrite_WB         <= i_regwrite_MEM;
            o_wb_WB               <= i_wb_MEM;
            o_slt_WB              <= i_slt_MEM;
            o_jump_WB             <= i_jump_MEM;
            o_memtoreg_WB         <= i_memtoreg_MEM;
            o_pc_incr4_WB         <= i_pc_incr4_MEM;
            o_auipc_lui_data_WB   <= i_auipc_lui_data_MEM;
            o_slt_data_WB         <= i_slt_data_MEM;
            o_dataR_gen_WB        <= i_dataR_gen_MEM;
            o_alu_result_WB       <= i_alu_result_MEM;
            o_write_reg_WB        <= i_write_reg_MEM;
        end
    end

endmodule
