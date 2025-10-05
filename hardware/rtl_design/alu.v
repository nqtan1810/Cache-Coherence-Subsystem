`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 
//////////////////////////////////////////////////////////////////////////////////

`include "riscv_define.vh"

module alu
(
    input  [3:0]      i_alu_control,
    input  [31:0]     i_alusrcA,
    input  [31:0]     i_alusrcB,
    output reg [31:0] o_alu_result,
    output            o_sign_bit
);

    always @(*) begin
        casex (i_alu_control)
            `ALU_ADD : o_alu_result = i_alusrcA + i_alusrcB;
            `ALU_SUB : o_alu_result = i_alusrcA - i_alusrcB;
            `ALU_SLL : o_alu_result = i_alusrcA << i_alusrcB[4:0];
            `ALU_SSUB: o_alu_result = $signed(i_alusrcA) - $signed(i_alusrcB);
            `ALU_USUB: o_alu_result = $unsigned(i_alusrcA) - $unsigned(i_alusrcB);
            `ALU_XOR : o_alu_result = i_alusrcA ^ i_alusrcB;
            `ALU_SRL : o_alu_result = i_alusrcA >> i_alusrcB[4:0];
            `ALU_SRA : o_alu_result = $signed(i_alusrcA) >>> i_alusrcB[4:0];
            `ALU_OR  : o_alu_result = i_alusrcA | i_alusrcB;
            `ALU_AND : o_alu_result = i_alusrcA & i_alusrcB;
            default  : o_alu_result = 0;
        endcase
    end
    
    assign o_sign_bit = (i_alu_control == `ALU_SSUB)  ? ($signed(i_alusrcA) < $signed(i_alusrcB)) :
                        (i_alu_control == `ALU_USUB)  ? ($unsigned(i_alusrcA) < $unsigned(i_alusrcB)) : 1'b0;

endmodule
