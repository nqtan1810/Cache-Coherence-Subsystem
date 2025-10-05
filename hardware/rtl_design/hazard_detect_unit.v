`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 
//////////////////////////////////////////////////////////////////////////////////

module hazard_detect_unit
(
    input [4:0] i_rs1,
    input [4:0] i_rs2,
    input       i_memread,
    input [4:0] i_write_reg,
    output      o_stall
);

    assign o_stall = (i_memread) & ((i_rs1 == i_write_reg) | (i_rs2 == i_write_reg));
    
endmodule
