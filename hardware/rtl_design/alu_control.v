`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//
//////////////////////////////////////////////////////////////////////////////////

`include "riscv_define.vh"

module alu_control
(
    input   [6:0]      i_opcode,
    input   [2:0]      i_funct3,
    input   [6:0]      i_funct7,
    output  reg [3:0]  o_alu_control
);
    
    always @(*) begin
        case(i_opcode)
            `OP_R_TYPE: begin
                case(i_funct3)
                    `FUNCT3_ADD_SUB: begin
                        case(i_funct7) 
                            `FUNCT7_ADD: o_alu_control = `ALU_ADD;
                            `FUNCT7_SUB: o_alu_control = `ALU_SUB;
                            default    : o_alu_control = `ALU_ADD;
                        endcase
                    end
                    `FUNCT3_SLL    : o_alu_control = `ALU_SLL ;
                    `FUNCT3_SLT    : o_alu_control = `ALU_SSUB;
                    `FUNCT3_SLTU   : o_alu_control = `ALU_USUB;
                    `FUNCT3_XOR    : o_alu_control = `ALU_XOR ;
                    `FUNCT3_SRL_SRA: begin
                        case(i_funct7) 
                            `FUNCT7_SRL: o_alu_control = `ALU_SRL;
                            `FUNCT7_SRA: o_alu_control = `ALU_SRA;
                            default    : o_alu_control = `ALU_SRL;
                        endcase
                    end
                    `FUNCT3_OR     : o_alu_control = `ALU_OR ;
                    `FUNCT3_AND    : o_alu_control = `ALU_AND;
                    default        : o_alu_control = `ALU_ADD;
                endcase
            end
            `OP_I_TYPE: begin
                case(i_funct3)
                    `FUNCT3_ADDI       : o_alu_control = `ALU_ADD; 
                    `FUNCT3_SLLI       : o_alu_control = `ALU_SLL;  
                    `FUNCT3_SLTI       : o_alu_control = `ALU_SSUB;  
                    `FUNCT3_SLTIU      : o_alu_control = `ALU_USUB;  
                    `FUNCT3_XORI       : o_alu_control = `ALU_XOR;  
                    `FUNCT3_SRLI_SRAI  : begin
                        case(i_funct7) 
                           `FUNCT7_SRLI: o_alu_control = `ALU_SRL;
                           `FUNCT7_SRAI: o_alu_control = `ALU_SRA;
                           default     : o_alu_control = `ALU_SRL;
                        endcase
                    end
                    `FUNCT3_ORI        : o_alu_control = `ALU_OR;
                    `FUNCT3_ANDI       : o_alu_control = `ALU_AND;
                    default            : o_alu_control = `ALU_ADD; 
                endcase
            end
            `OP_S_TYPE: o_alu_control = `ALU_ADD;
            `OP_LOAD  : o_alu_control = `ALU_ADD;
            `OP_B_TYPE: begin
                case(i_funct3)
                    `FUNCT3_BEQ  : o_alu_control = `ALU_SSUB; // not used
                    `FUNCT3_BNE  : o_alu_control = `ALU_SSUB; // not used 
                    `FUNCT3_BLT  : o_alu_control = `ALU_SSUB; // not used 
                    `FUNCT3_BGE  : o_alu_control = `ALU_SSUB; // not used
                    `FUNCT3_BLTU : o_alu_control = `ALU_USUB; // not used
                    `FUNCT3_BGEU : o_alu_control = `ALU_USUB; // not used
                    default      : o_alu_control = `ALU_SSUB; // not used
                endcase
            end
            `OP_JALR  : o_alu_control = `ALU_ADD;  // not used
            `OP_JAL   : o_alu_control = `ALU_ADD;  // not used
            `OP_LUI   : o_alu_control = `ALU_ADD;  // not used
            `OP_AUIPC : o_alu_control = `ALU_ADD;  // not used
            default   : o_alu_control = `ALU_ADD;
        endcase
    end
    
endmodule