// defines.vh
`ifndef DEFINE_RISCV
`define DEFINE_RISCV

// RISC-V Instruction Opcodes
`define OP_R_TYPE       7'b011_0011   // Register-type instructions
`define OP_I_TYPE       7'b001_0011   // Immediate-type ALU instructions
`define OP_S_TYPE       7'b010_0011   // Store
`define OP_LOAD         7'b000_0011   // Load 
`define OP_B_TYPE       7'b110_0011   // Branch instructions
`define OP_JALR         7'b110_0111   // Jump and link register
`define OP_JAL          7'b110_1111   // Jump and link
`define OP_LUI          7'b011_0111   // Load upper immediate
`define OP_AUIPC        7'b001_0111   // Add upper immediate to PC

// ------------------------------
// Load Instructions (I-type)
// ------------------------------
`define FUNCT3_LB    3'b000
`define FUNCT3_LH    3'b001
`define FUNCT3_LW    3'b010
`define FUNCT3_LBU   3'b100
`define FUNCT3_LHU   3'b101

// ------------------------------
// Store Instructions (S-type)
// ------------------------------
`define FUNCT3_SB    3'b000
`define FUNCT3_SH    3'b001
`define FUNCT3_SW    3'b010

// ------------------------------
// Immediate Arithmetic (I-type)
// ------------------------------
`define FUNCT3_ADDI         3'b000
`define FUNCT3_SLLI         3'b001
`define FUNCT3_SLTI         3'b010
`define FUNCT3_SLTIU        3'b011
`define FUNCT3_XORI         3'b100
`define FUNCT3_SRLI_SRAI    3'b101
`define FUNCT3_ORI          3'b110
`define FUNCT3_ANDI         3'b111

`define FUNCT7_SRLI         7'b0000000
`define FUNCT7_SRAI         7'b0100000

// ------------------------------
// Register-Register Arithmetic (R-type)
// ------------------------------
`define FUNCT3_ADD_SUB  3'b000
`define FUNCT3_SLL      3'b001
`define FUNCT3_SLT      3'b010
`define FUNCT3_SLTU     3'b011
`define FUNCT3_XOR      3'b100
`define FUNCT3_SRL_SRA  3'b101
`define FUNCT3_OR       3'b110
`define FUNCT3_AND      3'b111

`define FUNCT7_ADD   7'b0000000
`define FUNCT7_SUB   7'b0100000
`define FUNCT7_SRL   7'b0000000
`define FUNCT7_SRA   7'b0100000

// ------------------------------
// Branch Instructions (B-type)
// ------------------------------
`define FUNCT3_BEQ   3'b000
`define FUNCT3_BNE   3'b001
`define FUNCT3_BLT   3'b100
`define FUNCT3_BGE   3'b101
`define FUNCT3_BLTU  3'b110
`define FUNCT3_BGEU  3'b111

// ------------------------------
// JALR Instruction (I-type)
// ------------------------------
`define FUNCT3_JALR  3'b000

// ------------------------------
// ALU control define
// ------------------------------
// 0000: rs1 + rs2                      // add
// 0001: rs1 - rs2                      // sub
// 0010: rs1 << rs2                     // sll
// 0011: signed(rs1) - signed(rs2)      // slt
// 0100: unsigned(rs1) - unsigned(rs2)  // sltu
// 0101: rs1 ^ rs2                      // xor
// 0110: unsigned(rs1) >> unsigned(rs2) // srl
// 0111: signed(rs1) >> signed(rs2)     // sra
// 1000: rs1 | rs2                      // or
// 1001: rs1 & rs2                      // and
// 1010: 
// 1011:
`define ALU_ADD   4'b0000      //: rs1 + rs2                      // add
`define ALU_SUB   4'b0001      //: rs1 - rs2                      // sub
`define ALU_SLL   4'b0010      //: rs1 << rs2                     // sll
`define ALU_SSUB  4'b0011      //: signed(rs1) - signed(rs2)      // slt
`define ALU_USUB  4'b0100      //: unsigned(rs1) - unsigned(rs2)  // sltu
`define ALU_XOR   4'b0101      //: rs1 ^ rs2                      // xor
`define ALU_SRL   4'b0110      //: unsigned(rs1) >> unsigned(rs2) // srl
`define ALU_SRA   4'b0111      //: signed(rs1) >> signed(rs2)     // sra
`define ALU_OR    4'b1000      //: rs1 | rs2                      // or
`define ALU_AND   4'b1001      //: rs1 & rs2                      // and

`endif // DEFINE_RISCV
