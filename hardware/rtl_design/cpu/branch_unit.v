`timescale 1ns/1ps
//////////////////////////////////////////////////////////////////////////////////
// branch unit module: move from ID to EX stage
//////////////////////////////////////////////////////////////////////////////////

// *******************************************************************************
// New branch_unit
// *******************************************************************************
module branch_unit (                        
    input               i_jalr_EX,
    input               i_branch_EX,
    input [2:0]         i_funct3_EX,

    input [4:0]         i_rs1_EX,
    input [4:0]         i_rs2_EX,

    input               i_jump_EX,

    input [4:0]         i_write_reg_MEM,
    input               i_jump_MEM,
    input               i_wb_MEM,
    input               i_slt_MEM,
    input               i_memread_MEM,
    input [31:0]        i_pc_incr4_MEM,
    input [31:0]        i_auipc_lui_data_MEM,
    input [31:0]        i_slt_data_MEM,
    input [31:0]        i_alu_result_MEM,
    input [31:0]        i_dataR_gen,

    input [4:0]         i_write_reg_WB,
    input               i_jump_WB,
    input               i_wb_WB,
    input               i_slt_WB,
    input               i_regwrite_WB,
    input [31:0]        i_pc_incr4_WB,
    input [31:0]        i_auipc_lui_data_WB,
    input [31:0]        i_slt_data_WB,
    input [31:0]        i_alu_result_WB,
    input [31:0]        i_dataD,

    input [31:0]        i_dataA_EX,
    input [31:0]        i_dataB_EX,

    output reg [31:0]   o_rs1_data,
    output reg          o_pcsel1,
    output reg          o_pcsel2
);

    reg [31:0] src_A; 
    reg [31:0] src_B;
    
    wire rs1_MEM_match; 
    wire rs2_MEM_match; 
    wire rs1_WB_match; 
    wire rs2_WB_match;
    
    assign rs1_MEM_match = i_rs1_EX == i_write_reg_MEM;
    assign rs2_MEM_match = i_rs2_EX == i_write_reg_MEM;
    
    assign rs1_WB_match = i_rs1_EX == i_write_reg_WB;
    assign rs2_WB_match = i_rs2_EX == i_write_reg_WB;
    
    always @(*) begin
        o_pcsel1    = 0;
        o_pcsel2    = 0;
        o_rs1_data  = 0;
        src_A = i_dataA_EX;
        src_B = i_dataB_EX;
        if((!i_jump_EX) && (!i_branch_EX)) begin  // khong phai lenh nhay/re nhanh
            o_pcsel1 = 0;
            o_pcsel2 = 0;
        end 
        else begin
            if(i_jump_EX) begin 
                if(i_jalr_EX) begin      // jalr
                    o_pcsel1 = 1;
                    o_pcsel2 = 1;
                    if(rs1_MEM_match) begin     // get data from MEM stage
                        if(i_jump_MEM) begin
                            o_rs1_data = i_pc_incr4_MEM;
                        end
                        else if(i_wb_MEM) begin
                            o_rs1_data = i_auipc_lui_data_MEM;
                        end
                        else if(i_slt_MEM) begin
                            o_rs1_data = i_slt_data_MEM;
                        end
                        else begin
                            o_rs1_data = i_alu_result_MEM;
                        end
                    end 
                    else if(rs1_WB_match) begin      // get data from WB stage
                        if(i_jump_WB) begin
                            o_rs1_data = i_pc_incr4_WB;
                        end
                        else if(i_wb_WB) begin
                            o_rs1_data = i_auipc_lui_data_WB;
                        end
                        else if(i_slt_WB) begin
                            o_rs1_data = i_slt_data_WB;
                        end
                        else begin
                            o_rs1_data = i_alu_result_WB;
                        end
                    end 
                    else begin
                        o_rs1_data = i_dataA_EX;
                    end
                end
                else begin          // jal
                    o_pcsel1 = 1;
                    o_pcsel2 = 0;
                    o_rs1_data = i_dataA_EX;
                end
            end
            else if (i_branch_EX) begin      // nhom lenh branch: beq, bne, ...
                o_pcsel2 = 0;
                // khong xung dot
                if (!(rs1_MEM_match || rs2_MEM_match || rs1_WB_match || rs2_WB_match)) begin
                    src_A = i_dataA_EX;
                    src_B = i_dataB_EX;
                end        
                // xung dot tai tang WB
                if(rs1_WB_match) begin     
                    if(i_jump_WB) begin
                        src_A = i_pc_incr4_WB;
                    end
                    else if(i_wb_WB) begin
                        src_A = i_auipc_lui_data_WB;
                    end
                    else if(i_slt_WB) begin
                        src_A = i_slt_data_WB;
                    end
                    else begin
                        src_A = i_regwrite_WB ? i_dataD : i_dataA_EX;
                    end
                end
                if(rs2_WB_match) begin     
                    if(i_jump_WB) begin
                        src_B = i_pc_incr4_WB;
                    end
                    else if(i_wb_WB) begin
                        src_B = i_auipc_lui_data_WB;
                    end
                    else if(i_slt_WB) begin
                        src_B = i_slt_data_WB;
                    end
                    else begin
                        src_B = i_regwrite_WB ? i_dataD : i_dataB_EX;
                    end
                end                    
                // xung dot tai tang MEM
                if(rs1_MEM_match) begin     
                    if(i_jump_MEM) begin
                        src_A = i_pc_incr4_MEM;
                    end
                    else if(i_wb_MEM) begin
                        src_A = i_auipc_lui_data_MEM;
                    end
                    else if(i_slt_MEM) begin
                        src_A = i_slt_data_MEM;
                    end
                    else begin
                        src_A = i_memread_MEM ? i_dataR_gen : i_alu_result_MEM;
                    end
                end
                if(rs2_MEM_match) begin     
                    if(i_jump_MEM) begin
                        src_B = i_pc_incr4_MEM;
                    end
                    else if(i_wb_MEM) begin
                        src_B = i_auipc_lui_data_MEM;
                    end
                    else if(i_slt_MEM) begin
                        src_B = i_slt_data_MEM;
                    end
                    else begin
                        src_B = i_memread_MEM ? i_dataR_gen : i_alu_result_MEM;
                    end
                end
                case (i_funct3_EX)
                    3'b000: o_pcsel1 = src_A == src_B;//beq
                    3'b001: o_pcsel1 = src_A != src_B;//bne
                    3'b100: o_pcsel1 = $signed(src_A) < $signed(src_B); //blt
                    3'b101: o_pcsel1 = $signed(src_A) >= $signed(src_B); //bge
                    3'b110: o_pcsel1 = src_A < src_B; // bltu
                    3'b111: o_pcsel1 = src_A >= src_B; //bgeu
                    default: o_pcsel1 = 1'b0;
                endcase
            end
        end
    end
endmodule


//module branch_unit (                        // slack = ?
//    input               i_jalr_EX,
//    input               i_branch_EX,
//    input [2:0]         i_funct3_EX,

//    input [4:0]         i_rs1_EX,
//    input [4:0]         i_rs2_EX,

//    input               i_jump_EX,

//    input [4:0]         i_write_reg_MEM,
//    input               i_jump_MEM,
//    input               i_wb_MEM,
//    input               i_slt_MEM,
//    input               i_memread_MEM,
//    input [31:0]        i_pc_incr4_MEM,
//    input [31:0]        i_auipc_lui_data_MEM,
//    input [31:0]        i_slt_data_MEM,
//    input [31:0]        i_alu_result_MEM,
//    input [31:0]        i_dataR_gen,

//    input [4:0]         i_write_reg_WB,
//    input               i_jump_WB,
//    input               i_wb_WB,
//    input               i_slt_WB,
//    input               i_regwrite_WB,
//    input [31:0]        i_pc_incr4_WB,
//    input [31:0]        i_auipc_lui_data_WB,
//    input [31:0]        i_slt_data_WB,
//    input [31:0]        i_alu_result_WB,
//    input [31:0]        i_dataD,

//    input [31:0]        i_dataA_EX,
//    input [31:0]        i_dataB_EX,

//    output reg [31:0]   o_rs1_data,
//    output reg          o_pcsel1,
//    output reg          o_pcsel2
//);

//    always @(*) begin
//        o_pcsel1    = 0;
//        o_pcsel2    = 0;
//        o_rs1_data  = 0;
//        if((!i_jump_EX) && (!i_branch_EX)) begin  // khong phai lenh nhay/re nhanh
//            o_pcsel1 = 0;
//            o_pcsel2 = 0;
//        end 
//        else begin
//            if(i_jump_EX) begin 
//                if(i_jalr_EX) begin      // jalr
//                    o_pcsel1 = 1;
//                    o_pcsel2 = 1;
//                    if(i_rs1_EX == i_write_reg_MEM) begin     // get data from MEM stage
//                        if(i_jump_MEM) begin
//                            o_rs1_data = i_pc_incr4_MEM;
//                        end
//                        else if(i_wb_MEM) begin
//                            o_rs1_data = i_auipc_lui_data_MEM;
//                        end
//                        else if(i_slt_MEM) begin
//                            o_rs1_data = i_slt_data_MEM;
//                        end
//                        else begin
//                            o_rs1_data = i_alu_result_MEM;
//                        end
//                    end 
//                    else if(i_rs1_EX == i_write_reg_WB) begin      // get data from WB stage
//                        if(i_jump_WB) begin
//                            o_rs1_data = i_pc_incr4_WB;
//                        end
//                        else if(i_wb_WB) begin
//                            o_rs1_data = i_auipc_lui_data_WB;
//                        end
//                        else if(i_slt_WB) begin
//                            o_rs1_data = i_slt_data_WB;
//                        end
//                        else begin
//                            o_rs1_data = i_alu_result_WB;
//                        end
//                    end 
//                    else begin
//                        o_rs1_data = i_dataA_EX;
//                    end
//                end
//                else begin          // jal
//                    o_pcsel1 = 1;
//                    o_pcsel2 = 0;
//                    o_rs1_data = i_dataA_EX;
//                end
//            end
//            else if (i_branch_EX) begin      // nhom lenh branch: beq, bne, ...
//                o_pcsel2 = 0;
//                if ((i_rs1_EX!=i_write_reg_MEM)&&(i_rs2_EX!=i_write_reg_MEM)&&(i_rs1_EX!=i_write_reg_WB)&&(i_rs2_EX!=i_write_reg_WB)) begin
//                    case (i_funct3_EX)
//                        3'b000: o_pcsel1 = i_dataA_EX == i_dataB_EX;//beq
//                        3'b001: o_pcsel1 = i_dataA_EX != i_dataB_EX;//bne
//                        3'b100: o_pcsel1 = $signed(i_dataA_EX) < $signed(i_dataB_EX); //blt
//                        3'b101: o_pcsel1 = $signed(i_dataA_EX) >= $signed(i_dataB_EX); //bge
//                        3'b110: o_pcsel1 = i_dataA_EX < i_dataB_EX; // bltu
//                        3'b111: o_pcsel1 = i_dataA_EX >= i_dataB_EX; //bgeu
//                        default: o_pcsel1 = 1'b0;
//                    endcase
//                end        
//                else if(i_rs1_EX == i_write_reg_MEM || i_rs2_EX == i_write_reg_MEM) begin     // xung dot tai tang MEM
//                    if(i_jump_MEM) begin
//                        if(i_rs1_EX == i_write_reg_MEM) begin
//                            case (i_funct3_EX)
//                                3'b000: o_pcsel1= i_pc_incr4_MEM == i_dataB_EX;//beq
//                                3'b001: o_pcsel1= i_pc_incr4_MEM != i_dataB_EX;//bne
//                                3'b100: o_pcsel1= $signed(i_pc_incr4_MEM) < $signed(i_dataB_EX); //blt
//                                3'b101: o_pcsel1= $signed(i_pc_incr4_MEM) >= $signed(i_dataB_EX); //bge
//                                3'b110: o_pcsel1= i_pc_incr4_MEM < i_dataB_EX; // bltu
//                                3'b111: o_pcsel1= i_pc_incr4_MEM >= i_dataB_EX; //bgeu
//                                default: o_pcsel1 = 1'b0;
//                            endcase
//                        end
//                        else if(i_rs2_EX == i_write_reg_MEM) begin
//                            case (i_funct3_EX)
//                                3'b000: o_pcsel1= i_pc_incr4_MEM == i_dataA_EX;//beq
//                                3'b001: o_pcsel1= i_pc_incr4_MEM != i_dataA_EX;//bne
//                                3'b100: o_pcsel1= $signed(i_dataA_EX) < $signed(i_pc_incr4_MEM); //blt
//                                3'b101: o_pcsel1= $signed(i_dataA_EX) >= $signed(i_pc_incr4_MEM); //bge
//                                3'b110: o_pcsel1= i_dataA_EX < i_pc_incr4_MEM; // bltu
//                                3'b111: o_pcsel1= i_dataA_EX >= i_pc_incr4_MEM; //bgeu
//                                default: o_pcsel1 = 1'b0;
//                            endcase
//                        end
//                        else begin
//                            o_pcsel1 = 0;
//                        end
//                    end
//                    else if(i_wb_MEM) begin
//                        if(i_rs1_EX == i_write_reg_MEM) begin
//                            case (i_funct3_EX)
//                                3'b000: o_pcsel1= i_auipc_lui_data_MEM == i_dataB_EX;//beq
//                                3'b001: o_pcsel1= i_auipc_lui_data_MEM != i_dataB_EX;//bne
//                                3'b100: o_pcsel1= $signed(i_auipc_lui_data_MEM) < $signed(i_dataB_EX); //blt
//                                3'b101: o_pcsel1= $signed(i_auipc_lui_data_MEM) >= $signed(i_dataB_EX); //bge
//                                3'b110: o_pcsel1= i_auipc_lui_data_MEM < i_dataB_EX; // bltu
//                                3'b111: o_pcsel1= i_auipc_lui_data_MEM >= i_dataB_EX; //bgeu
//                                default: o_pcsel1 = 1'b0;
//                            endcase
//                        end
//                        else if(i_rs2_EX == i_write_reg_MEM) begin
//                            case (i_funct3_EX)
//                                3'b000: o_pcsel1= i_auipc_lui_data_MEM == i_dataA_EX;//beq
//                                3'b001: o_pcsel1= i_auipc_lui_data_MEM != i_dataA_EX;//bne
//                                3'b100: o_pcsel1= $signed(i_dataA_EX) < $signed(i_auipc_lui_data_MEM); //blt
//                                3'b101: o_pcsel1= $signed(i_dataA_EX) >= $signed(i_auipc_lui_data_MEM); //bge
//                                3'b110: o_pcsel1= i_dataA_EX < i_auipc_lui_data_MEM; // bltu
//                                3'b111: o_pcsel1= i_dataA_EX >= i_auipc_lui_data_MEM; //bgeu
//                                default: o_pcsel1 = 1'b0;
//                            endcase
//                        end
//                        else begin
//                            o_pcsel1 = 0;
//                        end
//                    end
//                    else if(i_slt_MEM) begin
//                        if(i_rs1_EX == i_write_reg_MEM) begin
//                            case (i_funct3_EX)
//                                3'b000: o_pcsel1= i_slt_data_MEM == i_dataB_EX;//beq
//                                3'b001: o_pcsel1= i_slt_data_MEM != i_dataB_EX;//bne
//                                3'b100: o_pcsel1= $signed(i_slt_data_MEM) < $signed(i_dataB_EX); //blt
//                                3'b101: o_pcsel1= $signed(i_slt_data_MEM) >= $signed(i_dataB_EX); //bge
//                                3'b110: o_pcsel1= i_slt_data_MEM < i_dataB_EX; // bltu
//                                3'b111: o_pcsel1= i_slt_data_MEM >= i_dataB_EX; //bgeu
//                                default: o_pcsel1 = 1'b0;
//                            endcase
//                        end
//                        else if(i_rs2_EX == i_write_reg_MEM) begin
//                            case (i_funct3_EX)
//                                3'b000: o_pcsel1= i_slt_data_MEM == i_dataA_EX;//beq
//                                3'b001: o_pcsel1= i_slt_data_MEM != i_dataA_EX;//bne
//                                3'b100: o_pcsel1= $signed(i_dataA_EX) < $signed(i_slt_data_MEM); //blt
//                                3'b101: o_pcsel1= $signed(i_dataA_EX) >= $signed(i_slt_data_MEM); //bge
//                                3'b110: o_pcsel1= i_dataA_EX < i_slt_data_MEM; // bltu
//                                3'b111: o_pcsel1= i_dataA_EX >= i_slt_data_MEM; //bgeu
//                                default: o_pcsel1 = 1'b0;
//                            endcase
//                        end
//                        else begin
//                            o_pcsel1 = 0;
//                        end
//                    end
//                    else begin
//                        if(i_rs1_EX == i_write_reg_MEM) begin
//                            case (i_funct3_EX)
//                                3'b000: o_pcsel1= (i_memread_MEM) ? (i_dataR_gen == i_dataB_EX) : (i_alu_result_MEM == i_dataB_EX);//beq
//                                3'b001: o_pcsel1= (i_memread_MEM) ? (i_dataR_gen != i_dataB_EX) : (i_alu_result_MEM != i_dataB_EX);//bne
//                                3'b100: o_pcsel1= (i_memread_MEM) ? ($signed(i_dataR_gen) < $signed(i_dataB_EX)) : ($signed(i_alu_result_MEM) < $signed(i_dataB_EX)); //blt
//                                3'b101: o_pcsel1= (i_memread_MEM) ? ($signed(i_dataR_gen) >= $signed(i_dataB_EX)) : ($signed(i_alu_result_MEM) >= $signed(i_dataB_EX)); //bge
//                                3'b110: o_pcsel1= (i_memread_MEM) ? (i_dataR_gen < i_dataB_EX) : (i_alu_result_MEM < i_dataB_EX); // bltu
//                                3'b111: o_pcsel1= (i_memread_MEM) ? (i_dataR_gen >= i_dataB_EX) : (i_alu_result_MEM >= i_dataB_EX); //bgeu
//                                default: o_pcsel1 = 1'b0;
//                            endcase
//                        end
//                        else if(i_rs2_EX == i_write_reg_MEM) begin
//                            case (i_funct3_EX)
//                                3'b000: o_pcsel1= (i_memread_MEM) ? (i_dataR_gen == i_dataA_EX) : (i_alu_result_MEM == i_dataA_EX);//beq
//                                3'b001: o_pcsel1= (i_memread_MEM) ? (i_dataR_gen != i_dataA_EX) : (i_alu_result_MEM != i_dataA_EX);//bne
//                                3'b100: o_pcsel1= (i_memread_MEM) ? ($signed(i_dataA_EX) < $signed(i_dataR_gen)) : ($signed(i_dataA_EX) < $signed(i_alu_result_MEM)); //blt
//                                3'b101: o_pcsel1= (i_memread_MEM) ? ($signed(i_dataA_EX) >= $signed(i_dataR_gen)) : ($signed(i_dataA_EX) >= $signed(i_alu_result_MEM)); //bge
//                                3'b110: o_pcsel1= (i_memread_MEM) ? (i_dataA_EX < i_dataR_gen) : (i_dataA_EX < i_alu_result_MEM); // bltu
//                                3'b111: o_pcsel1= (i_memread_MEM) ? (i_dataA_EX >= i_dataR_gen) : (i_dataA_EX >= i_alu_result_MEM); //bgeu
//                                default: o_pcsel1 = 1'b0;
//                            endcase
//                        end
//                        else begin
//                            o_pcsel1 = 0;
//                        end
//                    end
//                end
//                else if(i_rs1_EX == i_write_reg_WB || i_rs2_EX == i_write_reg_WB) begin     // xung dot tai tang WB
//                    if(i_jump_WB) begin
//                        if(i_rs1_EX == i_write_reg_WB) begin
//                            case (i_funct3_EX)
//                                3'b000: o_pcsel1= i_pc_incr4_WB == i_dataB_EX;//beq
//                                3'b001: o_pcsel1= i_pc_incr4_WB != i_dataB_EX;//bne
//                                3'b100: o_pcsel1= $signed(i_pc_incr4_WB) < $signed(i_dataB_EX); //blt
//                                3'b101: o_pcsel1= $signed(i_pc_incr4_WB) >= $signed(i_dataB_EX); //bge
//                                3'b110: o_pcsel1= i_pc_incr4_WB < i_dataB_EX; // bltu
//                                3'b111: o_pcsel1= i_pc_incr4_WB >= i_dataB_EX; //bgeu
//                                default: o_pcsel1 = 1'b0;
//                            endcase
//                        end
//                        else if(i_rs2_EX == i_write_reg_WB) begin
//                            case (i_funct3_EX)
//                                3'b000: o_pcsel1= i_pc_incr4_WB == i_dataA_EX;//beq
//                                3'b001: o_pcsel1= i_pc_incr4_WB != i_dataA_EX;//bne
//                                3'b100: o_pcsel1= $signed(i_dataA_EX) < $signed(i_pc_incr4_WB); //blt
//                                3'b101: o_pcsel1= $signed(i_dataA_EX) >= $signed(i_pc_incr4_WB); //bge
//                                3'b110: o_pcsel1= i_dataA_EX < i_pc_incr4_WB; // bltu
//                                3'b111: o_pcsel1= i_dataA_EX >= i_pc_incr4_WB; //bgeu
//                                default: o_pcsel1 = 1'b0;
//                            endcase
//                        end
//                        else begin
//                            o_pcsel1 = 0;
//                        end
//                    end
//                    else if(i_wb_WB) begin
//                        if(i_rs1_EX == i_write_reg_WB) begin
//                            case (i_funct3_EX)
//                                3'b000: o_pcsel1= i_auipc_lui_data_WB == i_dataB_EX;//beq
//                                3'b001: o_pcsel1= i_auipc_lui_data_WB != i_dataB_EX;//bne
//                                3'b100: o_pcsel1= $signed(i_auipc_lui_data_WB) < $signed(i_dataB_EX); //blt
//                                3'b101: o_pcsel1= $signed(i_auipc_lui_data_WB) >= $signed(i_dataB_EX); //bge
//                                3'b110: o_pcsel1= i_auipc_lui_data_WB < i_dataB_EX; // bltu
//                                3'b111: o_pcsel1= i_auipc_lui_data_WB >= i_dataB_EX; //bgeu
//                                default: o_pcsel1 = 1'b0;
//                            endcase
//                        end
//                        else if(i_rs2_EX == i_write_reg_WB) begin
//                            case (i_funct3_EX)
//                                3'b000: o_pcsel1= i_auipc_lui_data_WB == i_dataA_EX;//beq
//                                3'b001: o_pcsel1= i_auipc_lui_data_WB != i_dataA_EX;//bne
//                                3'b100: o_pcsel1= $signed(i_dataA_EX) < $signed(i_auipc_lui_data_WB); //blt
//                                3'b101: o_pcsel1= $signed(i_dataA_EX) >= $signed(i_auipc_lui_data_WB); //bge
//                                3'b110: o_pcsel1= i_dataA_EX < i_auipc_lui_data_WB; // bltu
//                                3'b111: o_pcsel1= i_dataA_EX >= i_auipc_lui_data_WB; //bgeu
//                                default: o_pcsel1 = 1'b0;
//                            endcase
//                        end
//                        else begin
//                            o_pcsel1 = 0;
//                        end
//                    end
//                    else if(i_slt_WB) begin
//                        if(i_rs1_EX == i_write_reg_WB) begin
//                            case (i_funct3_EX)
//                                3'b000: o_pcsel1= i_slt_data_WB == i_dataB_EX;//beq
//                                3'b001: o_pcsel1= i_slt_data_WB != i_dataB_EX;//bne
//                                3'b100: o_pcsel1= $signed(i_slt_data_WB) < $signed(i_dataB_EX); //blt
//                                3'b101: o_pcsel1= $signed(i_slt_data_WB) >= $signed(i_dataB_EX); //bge
//                                3'b110: o_pcsel1= i_slt_data_WB < i_dataB_EX; // bltu
//                                3'b111: o_pcsel1= i_slt_data_WB >= i_dataB_EX; //bgeu
//                                default: o_pcsel1 = 1'b0;
//                            endcase
//                        end
//                        else if(i_rs2_EX == i_write_reg_WB) begin
//                            case (i_funct3_EX)
//                                3'b000: o_pcsel1= i_slt_data_WB == i_dataA_EX;//beq
//                                3'b001: o_pcsel1= i_slt_data_WB != i_dataA_EX;//bne
//                                3'b100: o_pcsel1= $signed(i_dataA_EX) < $signed(i_slt_data_WB); //blt
//                                3'b101: o_pcsel1= $signed(i_dataA_EX) >= $signed(i_slt_data_WB); //bge
//                                3'b110: o_pcsel1= i_dataA_EX < i_slt_data_WB; // bltu
//                                3'b111: o_pcsel1= i_dataA_EX >= i_slt_data_WB; //bgeu
//                                default: o_pcsel1 = 1'b0;
//                            endcase
//                        end
//                        else begin
//                            o_pcsel1 = 0;
//                        end
//                    end
//                    else begin
//                        if(i_rs1_EX == i_write_reg_WB) begin
//                            case (i_funct3_EX)
//                                3'b000: o_pcsel1= (i_regwrite_WB) ? (i_dataD == i_dataB_EX) : (i_dataA_EX == i_dataB_EX);//beq
//                                3'b001: o_pcsel1= (i_regwrite_WB) ? (i_dataD != i_dataB_EX) : (i_dataA_EX != i_dataB_EX);//bne
//                                3'b100: o_pcsel1= (i_regwrite_WB) ? ($signed(i_dataD) < $signed(i_dataB_EX)) : ($signed(i_dataA_EX) < $signed(i_dataB_EX)); //blt
//                                3'b101: o_pcsel1= (i_regwrite_WB) ? ($signed(i_dataD) >= $signed(i_dataB_EX)) : ($signed(i_dataA_EX) >= $signed(i_dataB_EX)); //bge
//                                3'b110: o_pcsel1= (i_regwrite_WB) ? (i_dataD < i_dataB_EX) : (i_dataA_EX < i_dataB_EX); // bltu
//                                3'b111: o_pcsel1= (i_regwrite_WB) ? (i_dataD >= i_dataB_EX) : (i_dataA_EX >= i_dataB_EX); //bgeu
//                                default: o_pcsel1 = 1'b0;
//                            endcase
//                        end
//                        else if(i_rs2_EX == i_write_reg_WB) begin
//                            case (i_funct3_EX)
//                                3'b000: o_pcsel1= (i_regwrite_WB) ? (i_dataD == i_dataA_EX) : (i_dataB_EX == i_dataA_EX);//beq
//                                3'b001: o_pcsel1= (i_regwrite_WB) ? (i_dataD != i_dataA_EX) : (i_dataB_EX != i_dataA_EX);//bne
//                                3'b100: o_pcsel1= (i_regwrite_WB) ? ($signed(i_dataA_EX) < $signed(i_dataD)) : ($signed(i_dataA_EX) < $signed(i_dataB_EX)); //blt
//                                3'b101: o_pcsel1= (i_regwrite_WB) ? ($signed(i_dataA_EX) >= $signed(i_dataD)) : ($signed(i_dataA_EX) >= $signed(i_dataB_EX)); //bge
//                                3'b110: o_pcsel1= (i_regwrite_WB) ? (i_dataA_EX < i_dataD) : (i_dataA_EX < i_dataB_EX); // bltu
//                                3'b111: o_pcsel1= (i_regwrite_WB) ? (i_dataA_EX >= i_dataD) : (i_dataA_EX >= i_dataB_EX); //bgeu
//                                default: o_pcsel1 = 1'b0;
//                            endcase
//                        end
//                        else begin
//                            o_pcsel1 = 0;
//                        end
//                    end
//                end
//            end
//            else begin
//                o_pcsel1 = 0;
//            end
//        end
//    end
    
//endmodule

//////////////////////////////////////////////////////////////////////////////////
// branch unit module
//////////////////////////////////////////////////////////////////////////////////

//module branch_unit(                     // 0.122
//    input  wire        i_jump,
//    input  wire        i_jalr,
//    input  wire        i_branch,
//    input  wire [2:0]  i_funct3,
//    input  wire [4:0]  i_rs1,
//    input  wire [4:0]  i_rs2,
//    input  wire [4:0]  i_write_reg_EX,
//    input  wire        i_jump_EX,
//    input  wire        i_wb_EX,
//    input  wire        i_slt_EX,
//    input  wire [31:0] i_pc_incr4_EX,
//    input  wire [31:0] i_auipc_lui_data,
//    input  wire [31:0] i_slt_data,
//    input  wire [31:0] i_alu_result,
//    input  wire [4:0]  i_write_reg_MEM,
//    input  wire        i_jump_MEM,
//    input  wire        i_wb_MEM,
//    input  wire        i_slt_MEM,
//    input  wire        i_memread_MEM,
//    input  wire [31:0] i_pc_incr4_MEM,
//    input  wire [31:0] i_auipc_lui_data_MEM,
//    input  wire [31:0] i_slt_data_MEM,
//    input  wire [31:0] i_alu_result_MEM,
//    input  wire [31:0] i_dataR_gen,
//    input  wire [4:0]  i_write_reg_WB,
//    input  wire        i_jump_WB,
//    input  wire        i_wb_WB,
//    input  wire        i_slt_WB,
//    input  wire [31:0] i_pc_incr4_WB,
//    input  wire [31:0] i_auipc_lui_data_WB,
//    input  wire [31:0] i_slt_data_WB,
//    input  wire [31:0] i_alu_result_WB,
//    input  wire [31:0] i_dataA,
//    input  wire [31:0] i_dataB,
//    output wire [31:0] o_rs1_data,
//    output wire        o_pcsel1,
//    output wire        o_pcsel2
//);

//// ---- Forwarding datapaths ----
//wire [31:0] forward_EX  = i_jump_EX   ? i_pc_incr4_EX   :
//                          i_wb_EX     ? i_auipc_lui_data :
//                          i_slt_EX    ? i_slt_data       :
//                                        i_alu_result;
//wire [31:0] forward_MEM = i_jump_MEM   ? i_pc_incr4_MEM       :
//                          i_wb_MEM     ? i_auipc_lui_data_MEM :
//                          i_slt_MEM    ? i_slt_data_MEM       :
//                                        (i_memread_MEM ? i_dataR_gen : i_alu_result_MEM);
//wire [31:0] forward_WB  = i_jump_WB    ? i_pc_incr4_WB   :
//                          i_wb_WB      ? i_auipc_lui_data_WB :
//                          i_slt_WB     ? i_slt_data_WB      :
//                                        i_alu_result_WB;

//// Select forwarded source1
//wire useEX1  = (i_rs1 == i_write_reg_EX);
//wire useMEM1 = (i_rs1 == i_write_reg_MEM);
//wire useWB1  = (i_rs1 == i_write_reg_WB);
//wire [31:0] rs1_fwd = useEX1  ? forward_EX  :
//                      useMEM1 ? forward_MEM :
//                      useWB1  ? forward_WB  :
//                                i_dataA;

//// Select forwarded source2
//wire useEX2  = (i_rs2 == i_write_reg_EX);
//wire useMEM2 = (i_rs2 == i_write_reg_MEM);
//wire useWB2  = (i_rs2 == i_write_reg_WB);
//wire [31:0] rs2_fwd = useEX2  ? forward_EX  :
//                      useMEM2 ? forward_MEM :
//                      useWB2  ? forward_WB  :
//                                i_dataB;

//// ---- Jump / Branch decode ----
//wire do_jal   = i_jump && !i_jalr;
//wire do_jalr  = i_jump &&  i_jalr;
//wire do_br    = i_branch;

//// Branch conditions
//wire cond_beq  = (i_funct3 == 3'b000) && (rs1_fwd == rs2_fwd);
//wire cond_bne  = (i_funct3 == 3'b001) && (rs1_fwd != rs2_fwd);
//wire cond_blt  = (i_funct3 == 3'b100) && ($signed(rs1_fwd) <  $signed(rs2_fwd));
//wire cond_bge  = (i_funct3 == 3'b101) && ($signed(rs1_fwd) >= $signed(rs2_fwd));
//wire cond_bltu = (i_funct3 == 3'b110) && (rs1_fwd <  rs2_fwd);
//wire cond_bgeu = (i_funct3 == 3'b111) && (rs1_fwd >= rs2_fwd);
//wire branch_cond = cond_beq || cond_bne || cond_blt || cond_bge || cond_bltu || cond_bgeu;

//// ---- Outputs ----
//assign o_rs1_data = rs1_fwd;
//assign o_pcsel1   = do_jal   ? 1'b1 :
//                    do_jalr  ? 1'b1 :
//                    do_br    ? branch_cond : 1'b0;
//assign o_pcsel2   = do_jal   ? 1'b0 :
//                    do_jalr  ? 1'b1 : 1'b0;

//endmodule

//module branch_unit(                             // 0.122
//  input              i_jump, i_jalr, i_branch,
//  input  [2:0]       i_funct3,
//  input  [4:0]       i_rs1, i_rs2,

//  input  [4:0]       i_write_reg_EX,
//  input              i_jump_EX, i_wb_EX, i_slt_EX,
//  input  [31:0]      i_pc_incr4_EX, i_auipc_lui_data, i_slt_data, i_alu_result,

//  input  [4:0]       i_write_reg_MEM,
//  input              i_jump_MEM, i_wb_MEM, i_slt_MEM, i_memread_MEM,
//  input  [31:0]      i_pc_incr4_MEM, i_auipc_lui_data_MEM,
//                     i_slt_data_MEM, i_alu_result_MEM, i_dataR_gen,

//  input  [4:0]       i_write_reg_WB,
//  input              i_jump_WB, i_wb_WB, i_slt_WB,
//  input  [31:0]      i_pc_incr4_WB, i_auipc_lui_data_WB,
//                     i_slt_data_WB, i_alu_result_WB,

//  input  [31:0]      i_dataA, i_dataB,

//  output [31:0]      o_rs1_data,
//  output             o_pcsel1,
//  output             o_pcsel2
//);

//  // === Pre-compute stage results ===
//  wire [31:0] ex_data   = i_jump_EX     ? i_pc_incr4_EX
//                        : i_wb_EX       ? i_auipc_lui_data
//                        : i_slt_EX      ? i_slt_data
//                                        : i_alu_result;

//  wire [31:0] mem_data  = i_jump_MEM    ? i_pc_incr4_MEM
//                        : i_wb_MEM      ? i_auipc_lui_data_MEM
//                        : i_slt_MEM     ? i_slt_data_MEM
//                        : i_memread_MEM ? i_dataR_gen
//                                        : i_alu_result_MEM;

//  wire [31:0] wb_data   = i_jump_WB     ? i_pc_incr4_WB
//                        : i_wb_WB       ? i_auipc_lui_data_WB
//                        : i_slt_WB      ? i_slt_data_WB
//                                        : i_alu_result_WB;

//  // === Forwarding logic ===
//  wire [31:0] rs1_val = (i_rs1 == i_write_reg_EX)  ? ex_data  :
//                        (i_rs1 == i_write_reg_MEM) ? mem_data :
//                        (i_rs1 == i_write_reg_WB)  ? wb_data  :
//                                                    i_dataA;

//  wire [31:0] rs2_val = (i_rs2 == i_write_reg_EX)  ? ex_data  :
//                        (i_rs2 == i_write_reg_MEM) ? mem_data :
//                        (i_rs2 == i_write_reg_WB)  ? wb_data  :
//                                                    i_dataB;

//  // === Branch comparator ===
//  wire eq  = (rs1_val == rs2_val);
//  wire ne  = ~eq;
//  wire slt = $signed(rs1_val) <  $signed(rs2_val);
//  wire sge = $signed(rs1_val) >= $signed(rs2_val);
//  wire ult = rs1_val < rs2_val;
//  wire uge = rs1_val >= rs2_val;

//  wire branch_taken =
//        (i_funct3 == 3'b000 && eq ) ||
//        (i_funct3 == 3'b001 && ne ) ||
//        (i_funct3 == 3'b100 && slt) ||
//        (i_funct3 == 3'b101 && sge) ||
//        (i_funct3 == 3'b110 && ult) ||
//        (i_funct3 == 3'b111 && uge);

//  // === Final outputs ===
//  assign o_pcsel1   = i_jump | (i_branch & branch_taken);
//  assign o_pcsel2   = i_jump & i_jalr;
//  assign o_rs1_data = (i_jump & i_jalr) ? rs1_val : 32'b0;

//endmodule


//(* keep_hierarchy = "yes" *)

//module branch_unit (                        // - 0.032
//    input               i_jump,
//    input               i_jalr,
//    input               i_branch,
//    input [2:0]         i_funct3,

//    input [4:0]         i_rs1,
//    input [4:0]         i_rs2,

//    input [4:0]         i_write_reg_EX,
//    input               i_jump_EX,
//    input               i_wb_EX,
//    input               i_slt_EX,
//    input [31:0]        i_pc_incr4_EX,
//    input [31:0]        i_auipc_lui_data,
//    input [31:0]        i_slt_data,
//    input [31:0]        i_alu_result,

//    input [4:0]         i_write_reg_MEM,
//    input               i_jump_MEM,
//    input               i_wb_MEM,
//    input               i_slt_MEM,
//    input               i_memread_MEM,
//    input [31:0]        i_pc_incr4_MEM,
//    input [31:0]        i_auipc_lui_data_MEM,
//    input [31:0]        i_slt_data_MEM,
//    input [31:0]        i_alu_result_MEM,
//    input [31:0]        i_dataR_gen,

//    input [4:0]         i_write_reg_WB,
//    input               i_jump_WB,
//    input               i_wb_WB,
//    input               i_slt_WB,
//    input [31:0]        i_pc_incr4_WB,
//    input [31:0]        i_auipc_lui_data_WB,
//    input [31:0]        i_slt_data_WB,
//    input [31:0]        i_alu_result_WB,

//    input [31:0]        i_dataA,
//    input [31:0]        i_dataB,

//    output reg [31:0]   o_rs1_data,
//    output reg          o_pcsel1,
//    output reg          o_pcsel2
//);

//    always @(*) begin
//        o_pcsel1    = 0;
//        o_pcsel2    = 0;
//        o_rs1_data  = 0;
//        if((!i_jump) && (!i_branch)) begin  // khong phai lenh nhay/re nhanh
//            o_pcsel1 = 0;
//            o_pcsel2 = 0;
//        end 
//        else begin
//            if(i_jump) begin 
//                if(i_jalr) begin      // jalr
//                    o_pcsel1 = 1;
//                    o_pcsel2 = 1;
//                    if(i_rs1 == i_write_reg_EX) begin       // get data from EX stage
//                        if(i_jump_EX) begin
//                            o_rs1_data = i_pc_incr4_EX;
//                        end
//                        else if(i_wb_EX) begin
//                            o_rs1_data = i_auipc_lui_data;
//                        end
//                        else if(i_slt_EX) begin
//                            o_rs1_data = i_slt_data;
//                        end
//                        else begin
//                            o_rs1_data = i_alu_result;
//                        end
//                    end
//                    else if(i_rs1 == i_write_reg_MEM) begin     // get data from MEM stage
//                        if(i_jump_MEM) begin
//                            o_rs1_data = i_pc_incr4_MEM;
//                        end
//                        else if(i_wb_MEM) begin
//                            o_rs1_data = i_auipc_lui_data_MEM;
//                        end
//                        else if(i_slt_MEM) begin
//                            o_rs1_data = i_slt_data_MEM;
//                        end
//                        else begin
//                            o_rs1_data = i_alu_result_MEM;
//                        end
//                    end 
//                    else if(i_rs1 == i_write_reg_WB) begin      // get data from WB stage
//                        if(i_jump_WB) begin
//                            o_rs1_data = i_pc_incr4_WB;
//                        end
//                        else if(i_wb_WB) begin
//                            o_rs1_data = i_auipc_lui_data_WB;
//                        end
//                        else if(i_slt_WB) begin
//                            o_rs1_data = i_slt_data_WB;
//                        end
//                        else begin
//                            o_rs1_data = i_alu_result_WB;
//                        end
//                    end 
//                    else begin
//                        o_rs1_data = i_dataA;
//                    end
//                end
//                else begin          // jal
//                    o_pcsel1 = 1;
//                    o_pcsel2 = 0;
//                    o_rs1_data = i_dataA;
//                end
//            end
//            else if (i_branch) begin      // nhom lenh branch: beq, bne, ...
//                o_pcsel2 = 0;
//                if ((i_rs1!=i_write_reg_EX)&&(i_rs2!=i_write_reg_EX)&&(i_rs1!=i_write_reg_MEM)&&(i_rs2!=i_write_reg_MEM)&&(i_rs1!=i_write_reg_MEM)&&(i_rs2!=i_write_reg_MEM)) begin
//                    case (i_funct3)
//                        3'b000: o_pcsel1 = i_dataA == i_dataB;//beq
//                        3'b001: o_pcsel1 = i_dataA != i_dataB;//bne
//                        3'b100: o_pcsel1 = $signed(i_dataA) < $signed(i_dataB); //blt
//                        3'b101: o_pcsel1 = $signed(i_dataA) >= $signed(i_dataB); //bge
//                        3'b110: o_pcsel1 = i_dataA < i_dataB; // bltu
//                        3'b111: o_pcsel1 = i_dataA >= i_dataB; //bgeu
//                        default: o_pcsel1 = 1'b0;
//                    endcase
//                end        
//                else if(i_rs1 == i_write_reg_EX || i_rs2 == i_write_reg_EX) begin    // xung dot tai tang EX
//                    if(i_jump_EX) begin
//                        if(i_rs1 == i_write_reg_EX) begin
//                            case (i_funct3)
//                                3'b000: o_pcsel1= i_pc_incr4_EX == i_dataB;//beq
//                                3'b001: o_pcsel1= i_pc_incr4_EX != i_dataB;//bne
//                                3'b100: o_pcsel1= $signed(i_pc_incr4_EX) < $signed(i_dataB); //blt
//                                3'b101: o_pcsel1= $signed(i_pc_incr4_EX) >= $signed(i_dataB); //bge
//                                3'b110: o_pcsel1= i_pc_incr4_EX < i_dataB; // bltu
//                                3'b111: o_pcsel1= i_pc_incr4_EX >= i_dataB; //bgeu
//                                default: o_pcsel1 = 1'b0;
//                            endcase
//                        end
//                        else if(i_rs2 == i_write_reg_EX) begin
//                            case (i_funct3)
//                                3'b000: o_pcsel1= i_pc_incr4_EX == i_dataA;//beq
//                                3'b001: o_pcsel1= i_pc_incr4_EX != i_dataA;//bne
//                                3'b100: o_pcsel1= $signed(i_dataA) < $signed(i_pc_incr4_EX); //blt
//                                3'b101: o_pcsel1= $signed(i_dataA) >= $signed(i_pc_incr4_EX); //bge
//                                3'b110: o_pcsel1= i_dataA < i_pc_incr4_EX; // bltu
//                                3'b111: o_pcsel1= i_dataA >= i_pc_incr4_EX; //bgeu
//                                default: o_pcsel1 = 1'b0;
//                            endcase
//                        end
//                        else begin
//                            o_pcsel1 = 0;
//                        end
//                    end
//                    else if(i_wb_EX) begin
//                        if(i_rs1 == i_write_reg_EX) begin
//                            case (i_funct3)
//                                3'b000: o_pcsel1= i_auipc_lui_data == i_dataB;//beq
//                                3'b001: o_pcsel1= i_auipc_lui_data != i_dataB;//bne
//                                3'b100: o_pcsel1= $signed(i_auipc_lui_data) < $signed(i_dataB); //blt
//                                3'b101: o_pcsel1= $signed(i_auipc_lui_data) >= $signed(i_dataB); //bge
//                                3'b110: o_pcsel1= i_auipc_lui_data < i_dataB; // bltu
//                                3'b111: o_pcsel1= i_auipc_lui_data >= i_dataB; //bgeu
//                                default: o_pcsel1 = 1'b0;
//                            endcase
//                        end
//                        else if(i_rs2 == i_write_reg_EX) begin
//                            case (i_funct3)
//                                3'b000: o_pcsel1= i_auipc_lui_data == i_dataA;//beq
//                                3'b001: o_pcsel1= i_auipc_lui_data != i_dataA;//bne
//                                3'b100: o_pcsel1= $signed(i_dataA) < $signed(i_auipc_lui_data); //blt
//                                3'b101: o_pcsel1= $signed(i_dataA) >= $signed(i_auipc_lui_data); //bge
//                                3'b110: o_pcsel1= i_dataA < i_auipc_lui_data; // bltu
//                                3'b111: o_pcsel1= i_dataA >= i_auipc_lui_data; //bgeu
//                                default: o_pcsel1 = 1'b0;
//                            endcase
//                        end
//                        else begin
//                            o_pcsel1 = 0;
//                        end
//                    end
//                    else if(i_slt_EX) begin
//                        if(i_rs1 == i_write_reg_EX) begin
//                            case (i_funct3)
//                                3'b000: o_pcsel1= i_slt_data == i_dataB;//beq
//                                3'b001: o_pcsel1= i_slt_data != i_dataB;//bne
//                                3'b100: o_pcsel1= $signed(i_slt_data) < $signed(i_dataB); //blt
//                                3'b101: o_pcsel1= $signed(i_slt_data) >= $signed(i_dataB); //bge
//                                3'b110: o_pcsel1= i_slt_data < i_dataB; // bltu
//                                3'b111: o_pcsel1= i_slt_data >= i_dataB; //bgeu
//                                default: o_pcsel1 = 1'b0;
//                            endcase
//                        end
//                        else if(i_rs2 == i_write_reg_EX) begin
//                            case (i_funct3)
//                                3'b000: o_pcsel1= i_slt_data == i_dataA;//beq
//                                3'b001: o_pcsel1= i_slt_data != i_dataA;//bne
//                                3'b100: o_pcsel1= $signed(i_dataA) < $signed(i_slt_data); //blt
//                                3'b101: o_pcsel1= $signed(i_dataA) >= $signed(i_slt_data); //bge
//                                3'b110: o_pcsel1= i_dataA < i_slt_data; // bltu
//                                3'b111: o_pcsel1= i_dataA >= i_slt_data; //bgeu
//                                default: o_pcsel1 = 1'b0;
//                            endcase
//                        end
//                        else begin
//                            o_pcsel1 = 0;
//                        end
//                    end
//                    else begin
//                        if(i_rs1 == i_write_reg_EX) begin
//                            case (i_funct3)
//                                3'b000: o_pcsel1= i_alu_result == i_dataB;//beq
//                                3'b001: o_pcsel1= i_alu_result != i_dataB;//bne
//                                3'b100: o_pcsel1= $signed(i_alu_result) < $signed(i_dataB); //blt
//                                3'b101: o_pcsel1= $signed(i_alu_result) >= $signed(i_dataB); //bge
//                                3'b110: o_pcsel1= i_alu_result < i_dataB; // bltu
//                                3'b111: o_pcsel1= i_alu_result >= i_dataB; //bgeu
//                                default: o_pcsel1 = 1'b0;
//                            endcase
//                        end
//                        else if(i_rs2 == i_write_reg_EX) begin
//                            case (i_funct3)
//                                3'b000: o_pcsel1= i_alu_result == i_dataA;//beq
//                                3'b001: o_pcsel1= i_alu_result != i_dataA;//bne
//                                3'b100: o_pcsel1= $signed(i_dataA) < $signed(i_alu_result); //blt
//                                3'b101: o_pcsel1= $signed(i_dataA) >= $signed(i_alu_result); //bge
//                                3'b110: o_pcsel1= i_dataA < i_alu_result; // bltu
//                                3'b111: o_pcsel1= i_dataA >= i_alu_result; //bgeu
//                                default: o_pcsel1 = 1'b0;
//                            endcase
//                        end
//                        else begin
//                            o_pcsel1 = 0;
//                        end
//                    end
//                end
//                else if(i_rs1 == i_write_reg_MEM || i_rs2 == i_write_reg_MEM) begin     // xung dot tai tang MEM
//                    if(i_jump_MEM) begin
//                        if(i_rs1 == i_write_reg_MEM) begin
//                            case (i_funct3)
//                                3'b000: o_pcsel1= i_pc_incr4_MEM == i_dataB;//beq
//                                3'b001: o_pcsel1= i_pc_incr4_MEM != i_dataB;//bne
//                                3'b100: o_pcsel1= $signed(i_pc_incr4_MEM) < $signed(i_dataB); //blt
//                                3'b101: o_pcsel1= $signed(i_pc_incr4_MEM) >= $signed(i_dataB); //bge
//                                3'b110: o_pcsel1= i_pc_incr4_MEM < i_dataB; // bltu
//                                3'b111: o_pcsel1= i_pc_incr4_MEM >= i_dataB; //bgeu
//                                default: o_pcsel1 = 1'b0;
//                            endcase
//                        end
//                        else if(i_rs2 == i_write_reg_MEM) begin
//                            case (i_funct3)
//                                3'b000: o_pcsel1= i_pc_incr4_MEM == i_dataA;//beq
//                                3'b001: o_pcsel1= i_pc_incr4_MEM != i_dataA;//bne
//                                3'b100: o_pcsel1= $signed(i_dataA) < $signed(i_pc_incr4_MEM); //blt
//                                3'b101: o_pcsel1= $signed(i_dataA) >= $signed(i_pc_incr4_MEM); //bge
//                                3'b110: o_pcsel1= i_dataA < i_pc_incr4_MEM; // bltu
//                                3'b111: o_pcsel1= i_dataA >= i_pc_incr4_MEM; //bgeu
//                                default: o_pcsel1 = 1'b0;
//                            endcase
//                        end
//                        else begin
//                            o_pcsel1 = 0;
//                        end
//                    end
//                    else if(i_wb_MEM) begin
//                        if(i_rs1 == i_write_reg_MEM) begin
//                            case (i_funct3)
//                                3'b000: o_pcsel1= i_auipc_lui_data_MEM == i_dataB;//beq
//                                3'b001: o_pcsel1= i_auipc_lui_data_MEM != i_dataB;//bne
//                                3'b100: o_pcsel1= $signed(i_auipc_lui_data_MEM) < $signed(i_dataB); //blt
//                                3'b101: o_pcsel1= $signed(i_auipc_lui_data_MEM) >= $signed(i_dataB); //bge
//                                3'b110: o_pcsel1= i_auipc_lui_data_MEM < i_dataB; // bltu
//                                3'b111: o_pcsel1= i_auipc_lui_data_MEM >= i_dataB; //bgeu
//                                default: o_pcsel1 = 1'b0;
//                            endcase
//                        end
//                        else if(i_rs2 == i_write_reg_MEM) begin
//                            case (i_funct3)
//                                3'b000: o_pcsel1= i_auipc_lui_data_MEM == i_dataA;//beq
//                                3'b001: o_pcsel1= i_auipc_lui_data_MEM != i_dataA;//bne
//                                3'b100: o_pcsel1= $signed(i_dataA) < $signed(i_auipc_lui_data_MEM); //blt
//                                3'b101: o_pcsel1= $signed(i_dataA) >= $signed(i_auipc_lui_data_MEM); //bge
//                                3'b110: o_pcsel1= i_dataA < i_auipc_lui_data_MEM; // bltu
//                                3'b111: o_pcsel1= i_dataA >= i_auipc_lui_data_MEM; //bgeu
//                                default: o_pcsel1 = 1'b0;
//                            endcase
//                        end
//                        else begin
//                            o_pcsel1 = 0;
//                        end
//                    end
//                    else if(i_slt_MEM) begin
//                        if(i_rs1 == i_write_reg_MEM) begin
//                            case (i_funct3)
//                                3'b000: o_pcsel1= i_slt_data_MEM == i_dataB;//beq
//                                3'b001: o_pcsel1= i_slt_data_MEM != i_dataB;//bne
//                                3'b100: o_pcsel1= $signed(i_slt_data_MEM) < $signed(i_dataB); //blt
//                                3'b101: o_pcsel1= $signed(i_slt_data_MEM) >= $signed(i_dataB); //bge
//                                3'b110: o_pcsel1= i_slt_data_MEM < i_dataB; // bltu
//                                3'b111: o_pcsel1= i_slt_data_MEM >= i_dataB; //bgeu
//                                default: o_pcsel1 = 1'b0;
//                            endcase
//                        end
//                        else if(i_rs2 == i_write_reg_MEM) begin
//                            case (i_funct3)
//                                3'b000: o_pcsel1= i_slt_data_MEM == i_dataA;//beq
//                                3'b001: o_pcsel1= i_slt_data_MEM != i_dataA;//bne
//                                3'b100: o_pcsel1= $signed(i_dataA) < $signed(i_slt_data_MEM); //blt
//                                3'b101: o_pcsel1= $signed(i_dataA) >= $signed(i_slt_data_MEM); //bge
//                                3'b110: o_pcsel1= i_dataA < i_slt_data_MEM; // bltu
//                                3'b111: o_pcsel1= i_dataA >= i_slt_data_MEM; //bgeu
//                                default: o_pcsel1 = 1'b0;
//                            endcase
//                        end
//                        else begin
//                            o_pcsel1 = 0;
//                        end
//                    end
//                    else begin
//                        if(i_rs1 == i_write_reg_MEM) begin
//                            case (i_funct3)
//                                3'b000: o_pcsel1= (i_memread_MEM) ? (i_dataR_gen == i_dataB) : (i_alu_result_MEM == i_dataB);//beq
//                                3'b001: o_pcsel1= (i_memread_MEM) ? (i_dataR_gen != i_dataB) : (i_alu_result_MEM != i_dataB);//bne
//                                3'b100: o_pcsel1= (i_memread_MEM) ? ($signed(i_dataR_gen) < $signed(i_dataB)) : ($signed(i_alu_result_MEM) < $signed(i_dataB)); //blt
//                                3'b101: o_pcsel1= (i_memread_MEM) ? ($signed(i_dataR_gen) >= $signed(i_dataB)) : ($signed(i_alu_result_MEM) >= $signed(i_dataB)); //bge
//                                3'b110: o_pcsel1= (i_memread_MEM) ? (i_dataR_gen < i_dataB) : (i_alu_result_MEM < i_dataB); // bltu
//                                3'b111: o_pcsel1= (i_memread_MEM) ? (i_dataR_gen >= i_dataB) : (i_alu_result_MEM >= i_dataB); //bgeu
//                                default: o_pcsel1 = 1'b0;
//                            endcase
//                        end
//                        else if(i_rs2 == i_write_reg_MEM) begin
//                            case (i_funct3)
//                                3'b000: o_pcsel1= (i_memread_MEM) ? (i_dataR_gen == i_dataA) : (i_alu_result_MEM == i_dataA);//beq
//                                3'b001: o_pcsel1= (i_memread_MEM) ? (i_dataR_gen != i_dataA) : (i_alu_result_MEM != i_dataA);//bne
//                                3'b100: o_pcsel1= (i_memread_MEM) ? ($signed(i_dataA) < $signed(i_dataR_gen)) : ($signed(i_dataA) < $signed(i_alu_result_MEM)); //blt
//                                3'b101: o_pcsel1= (i_memread_MEM) ? ($signed(i_dataA) >= $signed(i_dataR_gen)) : ($signed(i_dataA) >= $signed(i_alu_result_MEM)); //bge
//                                3'b110: o_pcsel1= (i_memread_MEM) ? (i_dataA < i_dataR_gen) : (i_dataA < i_alu_result_MEM); // bltu
//                                3'b111: o_pcsel1= (i_memread_MEM) ? (i_dataA >= i_dataR_gen) : (i_dataA >= i_alu_result_MEM); //bgeu
//                                default: o_pcsel1 = 1'b0;
//                            endcase
//                        end
//                        else begin
//                            o_pcsel1 = 0;
//                        end
//                    end
//                end
//            end
//            else begin
//                o_pcsel1 = 0;
//            end
//        end
//    end
    
//endmodule

