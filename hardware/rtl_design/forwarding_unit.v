`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 
//////////////////////////////////////////////////////////////////////////////////

module forwarding_unit
(
    input [4:0] i_rs1_EX,
    input [4:0] i_rs2_EX,
    
    input [4:0] i_write_reg_MEM,
    input [4:0] i_write_reg_WB,
    input       i_regwrite_MEM,
    input       i_regwrite_WB,
    input       i_wb_MEM,
    input       i_slt_MEM,
    input       i_jump_MEM,
    input       i_memtoreg_MEM,
    
    output reg [2:0] o_fwd1,
    output reg [2:0] o_fwd2
);

    // forwarding unit
    always @(*) begin
        if((i_rs1_EX == i_write_reg_MEM) && (i_regwrite_MEM) && (i_write_reg_MEM != 0)) begin
            if({i_wb_MEM, i_slt_MEM, i_jump_MEM, i_memtoreg_MEM} == 4'b0000)
                o_fwd1 = 0;
            else if({i_wb_MEM, i_slt_MEM, i_jump_MEM, i_memtoreg_MEM} == 4'b0100)
                o_fwd1 = 2;
            else if({i_wb_MEM, i_slt_MEM, i_jump_MEM, i_memtoreg_MEM} == 4'b1000)
                o_fwd1 = 3; 
            else if({i_wb_MEM, i_slt_MEM, i_jump_MEM, i_memtoreg_MEM} == 4'b0010)
                o_fwd1 = 4;
            else
                o_fwd1 = 1;     
        end
        else if(i_rs1_EX == i_write_reg_WB && i_regwrite_WB && i_write_reg_WB != 0) begin
            o_fwd1 = 5;
        end
        else begin
            o_fwd1 = 1;  
        end
        
        if((i_rs2_EX == i_write_reg_MEM) && (i_regwrite_MEM) && (i_write_reg_MEM != 0)) begin
            if({i_wb_MEM, i_slt_MEM, i_jump_MEM, i_memtoreg_MEM} == 4'b0000)
                o_fwd2 = 1;
            else if({i_wb_MEM, i_slt_MEM, i_jump_MEM, i_memtoreg_MEM} == 4'b0100)
                o_fwd2 = 2;
            else if({i_wb_MEM, i_slt_MEM, i_jump_MEM, i_memtoreg_MEM} == 4'b1000)
                o_fwd2 = 3; 
            else if({i_wb_MEM, i_slt_MEM, i_jump_MEM, i_memtoreg_MEM} == 4'b0010)
                o_fwd2 = 4;
            else
                o_fwd2 = 0;
        end
        else if(i_rs2_EX == i_write_reg_WB && i_regwrite_WB && i_write_reg_WB != 0) begin
            o_fwd2 = 5;
        end
        else begin
            o_fwd2 = 0;  
        end
    end
    
endmodule
