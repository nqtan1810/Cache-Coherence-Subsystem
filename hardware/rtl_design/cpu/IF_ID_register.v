//////////////////////////////////////////////////////////////////////////////////
// IF-ID pipeline register
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module IF_ID_register
(
    input               i_clk,
    input               i_rst_n,
    input               i_enable,
    input               i_blocking,
    input               i_flush_IF,
    input [31 : 0]      i_pc_incr4_IF,
    input [31 : 0]      i_pc_IF,
    input [31 : 0]      i_inst_IF,
    
    output reg [31 : 0] o_pc_incr4_ID,
    output reg [31 : 0] o_pc_ID,
    output reg [31 : 0] o_inst_ID 
);

    
    
    always @(posedge i_clk) begin
        if(!i_rst_n) begin
            o_pc_incr4_ID <= 32'd0;
            o_pc_ID       <= 32'd0;
            o_inst_ID     <= 32'd0;
        end
        else 
        if (i_enable) begin
            if(i_blocking) begin
                o_pc_incr4_ID <= o_pc_incr4_ID;
                o_pc_ID       <= o_pc_ID;
                o_inst_ID     <= o_inst_ID;
            end
            else if (i_flush_IF) begin
                o_pc_incr4_ID <= 32'd0;
                o_pc_ID       <= 32'd0;
                o_inst_ID     <= 32'd0;
            end
            else begin
                o_pc_incr4_ID <= i_pc_incr4_IF;
                o_pc_ID       <= i_pc_IF;
                o_inst_ID     <= i_inst_IF;
            end
        end
    end

endmodule
