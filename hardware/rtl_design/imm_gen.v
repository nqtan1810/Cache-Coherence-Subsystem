`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 
//////////////////////////////////////////////////////////////////////////////////

`include "riscv_define.vh"

module imm_gen
(
    input   [6:0]      i_opcode,
    input   [2:0]      i_funct3,
    input   [31:0]     i_instr,
    output  reg [31:0] o_imm_ext
);
    
    always @(*) begin
        case(i_opcode)
            `OP_I_TYPE: begin
                case(i_funct3)
                    3'b001 : o_imm_ext = {27'd0,i_instr[24:20]}; //slli        
                    3'b101 : o_imm_ext = {27'd0,i_instr[24:20]}; //srli,srai
                    default: o_imm_ext = {{20{i_instr[31]}}, i_instr[31:20]};
                endcase
            end
            `OP_S_TYPE: o_imm_ext = {{20{i_instr[31]}}, i_instr[31:25], i_instr[11:7]};
            `OP_LOAD  : o_imm_ext = {{20{i_instr[31]}}, i_instr[31:20]};
            `OP_B_TYPE: o_imm_ext = {{20{i_instr[31]}}, i_instr[7], i_instr[30:25], i_instr[11:8]};
            `OP_JALR  : o_imm_ext = {{20{i_instr[31]}}, i_instr[31:20]};
            `OP_JAL   : o_imm_ext = {{12{i_instr[31]}}, i_instr[19:12], i_instr[20], i_instr[30:21]};
            `OP_LUI   : o_imm_ext = i_instr[31:12];
            `OP_AUIPC : o_imm_ext = i_instr[31:12];
            default   : o_imm_ext = 32'd0;
        endcase
    end
    
endmodule
