# ********************* J-Type Instructions Test - RV32I *********************
.text

addi x1, x0, 48			# pc = 0
addi x2, x0, 64			# pc = 4
addi x3, x0, 84			# pc = 8
addi x4, x0, 108		# pc = 12

jal x5, JUMP_1			# pc = 16
addi x6, x0, 100		# pc = 20
addi x7, x0, 200		# pc = 24

JUMP_1:
addi x8, x0, 300		# pc = 28
addi x9, x0, 400		# pc = 32

jal x10, JUMP_2			# pc = 36
addi x11, x0, 500		# pc = 40

JUMP_2:
addi x12, x0, 600		# pc = 44

jalr x13, x1, 8			# pc = 48
addi x14, x0, 700		# pc = 52
addi x15, x0, 710		# pc = 56

addi x16, x0, 720		# pc = 60
jalr x17, x2, 12		# pc = 64
addi x18, x0, 720		# pc = 68
addi x19, x0, 730		# pc = 72
addi x20, x0, 740		# pc = 76

addi x21, x0, 750		# pc = 80
jalr x22, x3, 16		# pc = 84
addi x23, x0, 760		# pc = 88
addi x24, x0, 770		# pc = 92
addi x25, x0, 780		# pc = 96
addi x26, x0, 790		# pc = 100

addi x27, x0, 799		# pc = 104
jalr x28, x4, 4			# pc = 108
addi x29, x0, 733		# pc = 112
addi x30, x0, 755		# pc = 116
addi x31, x0, 715		# pc = 120

# ********************* B-Type Instructions Test - RV32I *********************
#.text

# Initial setup of registers (using addi to set values for the test)
addi x1, x0, 5         # x1 = 5
addi x2, x0, 10        # x2 = 10
addi x3, x0, -3        # x3 = -3 (0xFFFFFFFD)
addi x4, x0, 255       # x4 = 255
addi x5, x0, 127       # x5 = 127
addi x6, x0, 128       # x6 = 128
addi x7, x0, -1        # x7 = -1 (signed)

# Test BEQ (Branch if Equal)
beq x1, x2, beq_taken  # Branch to beq_taken if x1 == x2 (not taken)
addi x8, x0, 0x111     # This should execute if branch does not happen
beq_taken:
addi x9, x0, 0x222     # This should execute if branch happened

# Test BNE (Branch if Not Equal)
bne x1, x2, bne_taken  # Branch to bne_taken if x1 != x2 (taken)
addi x10, x0, 0x333    # This should not execute if branch happens
bne_taken:
addi x11, x0, 0x444    # This should execute if branch happened

# Test BLT (Branch if Less Than, signed comparison)
blt x1, x2, blt_taken  # Branch to blt_taken if x1 < x2 (signed) (taken)
addi x12, x0, 0x555    # This should not execute if branch happens
blt_taken:
addi x13, x0, 0x666    # This should execute if branch happened

# Test BGE (Branch if Greater or Equal, signed comparison)
bge x1, x2, bge_taken  # Branch to bge_taken if x1 >= x2 (signed) (not taken)
addi x14, x0, 0x777    # This should execute if branch does not happen
bge_taken:
addi x15, x0, 0x88     # This should execute if branch happened

# Test BLTU (Branch if Less Than, unsigned comparison)
bltu x1, x2, bltu_taken # Branch to bltu_taken if x1 < x2 (unsigned) (taken)
addi x16, x0, 0x99     # This should not execute if branch happens
bltu_taken:
addi x17, x0, 0xAA     # This should execute if branch happened

# Test BGEU (Branch if Greater or Equal, unsigned comparison)
bgeu x1, x2, bgeu_taken # Branch to bgeu_taken if x1 >= x2 (unsigned) (not taken)
addi x18, x0, 0xBB     # This should execute if branch does not happen
bgeu_taken:
addi x19, x0, 0xCC     # This should execute if branch happened

# Reset the registers to check the conditions where branch will NOT happen

# Test BEQ (Branch if Equal) - Not taken
beq x1, x2, beq_not_taken  # Branch to beq_not_taken if x1 == x2 (taken)
addi x20, x0, 0x111        # This should not execute if branch happens
beq_not_taken:
addi x21, x0, 0x222        # This should execute if branch did not happen

# Test BNE (Branch if Not Equal) - Not taken
bne x1, x2, bne_not_taken  # Branch to bne_not_taken if x1 != x2 (not taken)
addi x22, x0, 0x333        # This should execute if branch does not happen
bne_not_taken:
addi x23, x0, 0x444        # This should execute if branch did not happen

# Test BLT (Branch if Less Than, signed comparison) - Not taken
blt x1, x2, blt_not_taken  # Branch to blt_not_taken if x1 < x2 (signed) (not taken)
addi x24, x0, 0x555        # This should execute if branch does not happen
blt_not_taken:
addi x25, x0, 0x666        # This should execute if branch did not happen

# Test BGE (Branch if Greater or Equal, signed comparison) - Not taken
bge x1, x2, bge_not_taken  # Branch to bge_not_taken if x1 >= x2 (signed) (taken)
addi x26, x0, 0x777        # This should not execute if branch happens
bge_not_taken:
addi x27, x0, 0x88         # This should execute if branch did not happen

# Test BLTU (Branch if Less Than, unsigned comparison) - Not taken
bltu x1, x2, bltu_not_taken # Branch to bltu_not_taken if x1 < x2 (unsigned) (not taken)
addi x28, x0, 0x99         # This should execute if branch does not happen
bltu_not_taken:
addi x29, x0, 0xAA         # This should execute if branch did not happen

# Test BGEU (Branch if Greater or Equal, unsigned comparison) - Not taken
bgeu x1, x2, bgeu_not_taken # Branch to bgeu_not_taken if x1 >= x2 (unsigned) (taken)
addi x30, x0, 0xBB          # This should not execute if branch happens
bgeu_not_taken:
addi x31, x0, 0xCC          # This should execute if branch did not happen

# ********************* U-Type Tests - LUI & AUIPC *********************
#.text

# PC = 0x00
# ---- LUI ----
lui x1, 0x00001        # x1 = 0x00001000
lui x2, 0xFFFFF        # x2 = 0xFFFFF000 (sign-extended -1 << 12)
lui x3, 0x00000        # x3 = 0x00000000
lui x4, 0xABCDE        # x4 = 0xABCDE000

# ---- AUIPC ----
# Note: result = PC + (imm << 12), where PC is current instr address
# PC = 0x10
auipc x5, 0x00001      # x5 = 0x10 + 0x00001000 = 0x1010
# PC = 0x14
auipc x6, 0xFFFFF      # x6 = 0x14 + 0xFFFFF000 = 0xFFFFF014 (wrap-around behavior)
# PC = 0x18
auipc x7, 0x00000      # x7 = 0x18
# PC = 0x1C
auipc x8, 0xABCDE      # x8 = 0x1C + 0xABCDE000 = 0xABCDE01C

# ---- More Registers (check upper regs too) ----
lui x28, 0x12345       # x28 = 0x12345000
lui x29, 0x80000       # x29 = 0x80000000 (sign bit set)
auipc x30, 0x00010     # PC = 0x28 ? x30 = 0x28 + 0x10000 = 0x10028
auipc x31, 0x000FF     # PC = 0x2C ? x31 = 0x2C + 0xFF000 = 0xFF02C

# ********************* Store and Load Instruction Tests - RV32I *********************
#.text

# PC = 0x00
# Setup base address
lui x1, 0x1          # x1 = 0x1000 (base address for memory tests)

# Preload registers with known values for storing
addi x2, x0, 0x78     # x2 = 0x78 (positive byte)
addi x3, x0, -1       # x3 = 0xFFFFFFFF = -1 (signed byte)
addi x4, x0, 0x123    # x4 = 0x123 (positive halfword)
addi x5, x0, 0x123    # x5 = 0x123 (positive halfword for testing, limited to 12-bit range)
addi x6, x0, 0x78     # x6 = 0x78 (positive word)
addi x7, x0, 0x567    # x7 = 0x567 (positive word, within 12-bit range)

# ---- Store Byte ---- (sb)
sb x2, 0(x1)           # Store byte 0x78 at MEM[0x1000]
lb x8, 0(x1)           # Load byte at MEM[0x1000] -> x8 = 0x78

sb x3, 4(x1)           # Store byte 0xFF at MEM[0x1004] (0xFFFFFFFF -> 0xFF)
lb x9, 4(x1)           # Load byte at MEM[0x1004] -> x9 = 0xFF

sb x6, 8(x1)           # Store byte 0x78 at MEM[0x1008] (0xFFFFFF78 -> 0x78)
lb x10, 8(x1)          # Load byte at MEM[0x1008] -> x10 = 0x78

# ---- Store Halfword ---- (sh)
sh x4, 12(x1)          # Store halfword 0x0123 at MEM[0x100C]
lh x11, 12(x1)         # Load halfword at MEM[0x100C] -> x11 = 0x123

sh x5, 16(x1)          # Store halfword 0x0123 at MEM[0x1010] (same value, valid within 12-bit range)
lh x12, 16(x1)         # Load halfword at MEM[0x1010] -> x12 = 0x123

sh x6, 20(x1)          # Store halfword 0x0078 at MEM[0x1014] (0x78 -> 0x0078)
lh x13, 20(x1)         # Load halfword at MEM[0x1014] -> x13 = 0x0078

# ---- Store Word ---- (sw)
sw x7, 24(x1)          # Store word 0x0567 at MEM[0x1018]
lw x14, 24(x1)         # Load word at MEM[0x1018] -> x14 = 0x0567

sw x2, 28(x1)          # Store word 0x00000078 at MEM[0x101C]
lw x15, 28(x1)         # Load word at MEM[0x101C] -> x15 = 0x00000078

sw x3, 32(x1)          # Store word 0xFFFFFFFF at MEM[0x1020] (0xFFFFFFFF)
lw x16, 32(x1)         # Load word at MEM[0x1020] -> x16 = 0xFFFFFFFF

# ---- Store to high-numbered registers ----
sb x7, 40(x1)          # Store byte 0x78 from x7 (0x12345678) at MEM[0x1028]
lb x17, 40(x1)         # Load byte at MEM[0x1028] -> x17 = 0x78

sh x6, 44(x1)          # Store halfword 0xFF78 from x6 at MEM[0x102C]
lh x18, 44(x1)         # Load halfword at MEM[0x102C] -> x18 = 0xFF78

sw x4, 48(x1)          # Store word 0x00000123 from x4 at MEM[0x1030]
lw x19, 48(x1)         # Load word at MEM[0x1030] -> x19 = 0x00000123

# ********************* R-Type Tests - Extended *********************
#.text

# PC = 0x00
addi x1, x0, 5       # x1 = 5
addi x2, x0, 10      # x2 = 10
addi x3, x0, -3      # x3 = -3 (0xFFFFFFFD)
addi x4, x0, 0xFF    # x4 = 255
addi x5, x0, 0x7F    # x5 = 127
addi x6, x0, 0x80    # x6 = 128
addi x7, x0, 0xFFFFFFFF # x7 = -1 (signed)

# Begin R-type ops
# PC = 0x1C
add x8, x1, x2       # 5 + 10 = 15
sub x9, x2, x1       # 10 - 5 = 5
sll x10, x1, x3      # shift left by (x3 & 0x1F)
slt x11, x5, x6      # 127 < 128 => 1
sltu x12, x6, x5     # 128 < 127 (unsigned) => 0
xor x13, x1, x4      # 5 ^ 255
srl x14, x4, x1      # logical shift right
sra x15, x7, x1      # arithmetic shift right of -1
or x16, x1, x2       # 5 | 10
and x17, x1, x2      # 5 & 10

# More combinations
add x18, x5, x6      # 127 + 128
sub x19, x6, x5      # 128 - 127
sll x20, x6, x1      # shift left
slt x21, x6, x5      # 128 < 127? => 0
sltu x22, x5, x6     # unsigned 127 < 128 => 1
xor x23, x5, x6
srl x24, x6, x1
sra x25, x6, x1
or x26, x5, x6
and x27, x5, x6

# Test with x31 to verify high regs
add x28, x1, x31
sub x29, x2, x31
or  x30, x1, x31
and x31, x2, x31

# ********************* Load Instruction Tests - RV32I *********************
#.text

# PC = 0x00
# Setup base address
lui x1, 0x1          # x1 = 0x1000 (base address for memory tests)

# Preload memory with known values using sw
addi x2, x0, 0x78      # 0x78 = 0b01111000 (positive byte)
addi x3, x0, -1        # 0xFFFFFFFF = -1 (signed), 0xFF (unsigned byte)
addi x4, x0, 0x123     # 16-bit positive (now within valid 12-bit range)
lui  x5, 0xFFFF0       # upper bits set: 0xFFFF0000
addi x5, x5, 0xAB      # final word = 0xFFFF00AB

# Store words at memory: [0x1000, 0x1004, 0x1008, 0x100C]
sw x2, 0(x1)           # MEM[0x1000] = 0x00000078
sw x3, 4(x1)           # MEM[0x1004] = 0xFFFFFFFF
sw x4, 8(x1)           # MEM[0x1008] = 0x00000123
sw x5, 12(x1)          # MEM[0x100C] = 0xFFFF00AB

# PC = 0x30
# ---- LB ---- (sign-extended byte)
lb x6, 0(x1)           # x6 = 0x78 -> 0x00000078
lb x7, 4(x1)           # x7 = 0xFF -> 0xFFFFFFFF (sign-extended -1)
lb x8, 15(x1)          # x8 = 0xFF (from 0xFFFF00AB) -> 0xFFFFFFFF

# ---- LBU ---- (zero-extended byte)
lbu x9, 0(x1)          # x9 = 0x78
lbu x10, 4(x1)         # x10 = 0xFF -> 0x000000FF
lbu x11, 15(x1)        # x11 = 0xFF -> 0x000000FF

# ---- LH ---- (sign-extended halfword)
lh x12, 8(x1)          # x12 = 0x123
lh x13, 14(x1)         # x13 = 0xFFFF -> 0xFFFFFFFF

# ---- LHU ---- (zero-extended halfword)
lhu x14, 8(x1)         # x14 = 0x123
lhu x15, 14(x1)        # x15 = 0xFFFF -> 0x0000FFFF

# ---- LW ---- (full word load)
lw x16, 0(x1)          # x16 = 0x00000078
lw x17, 4(x1)          # x17 = 0xFFFFFFFF
lw x18, 8(x1)          # x18 = 0x00000123
lw x19, 12(x1)         # x19 = 0xFFFF00AB

# ---- Load to high-numbered regs ----
lb x28, 0(x1)
lh x29, 8(x1)
lhu x30, 14(x1)
lw x31, 12(x1)


# ********************* I-Type ALU Tests - RV32I Only *********************
#.text

# PC = 0x00
# Initialize base registers
addi x1, x0, 5         # x1 = 5
addi x2, x0, 10        # x2 = 10
addi x3, x0, -3        # x3 = -3
addi x4, x0, 0x7F      # x4 = 127
addi x5, x0, 0x80      # x5 = 128
addi x6, x0, -1        # x6 = 0xFFFFFFFF
addi x7, x0, 0         # x7 = 0

# PC = 0x1C
# ---- ADDI ----
addi x8, x1, 7         # 5 + 7 = 12
addi x9, x2, -5        # 10 + (-5) = 5
addi x10, x7, 0        # 0 + 0 = 0

# ---- SLLI ---- (shift amount in imm[4:0])
slli x11, x1, 1        # 5 << 1 = 10
slli x12, x2, 2        # 10 << 2 = 40
slli x13, x4, 4        # 127 << 4 = 2032

# ---- SLTI ----
slti x14, x1, 10       # 5 < 10 => 1
slti x15, x5, 127      # 128 < 127 => 0
slti x16, x3, 0        # -3 < 0 => 1

# ---- SLTIU ----
sltiu x17, x1, 10      # 5 < 10 => 1
sltiu x18, x5, 127     # 128 < 127 (unsigned) => 0
sltiu x19, x6, 0       # 0xFFFFFFFF < 0 => 0 (unsigned)

# ---- XORI ----
xori x20, x1, 0xAA     # 5 ^ 0xAA
xori x21, x4, 0xFF     # 127 ^ 0xFF
xori x22, x3, -1       # -3 ^ -1 = 2

# ---- SRLI ----
srli x23, x4, 1        # 127 >> 1 = 63
srli x24, x5, 2        # 128 >> 2 = 32
srli x25, x6, 4        # 0xFFFFFFFF >> 4 = 0x0FFFFFFF

# ---- SRAI ----
srai x26, x3, 1        # -3 >> 1 = -2
srai x27, x6, 4        # -1 >> 4 = -1 (sign-extend)
srai x28, x5, 2        # 128 >> 2 = 32 (MSB = 0)

# ---- ORI ----
ori x29, x1, 0xAA      # 5 | 0xAA
ori x30, x3, 0xFF      # -3 | 0xFF = 0xFFFFFFFF
ori x31, x0, 0x123     # 0 | 0x123 = 0x123

# ---- ANDI ----
andi x8, x1, 0xF       # 5 & 0xF = 5
andi x9, x4, 0x0F      # 127 & 0x0F = 15
andi x10, x3, 0xFF     # -3 & 0xFF = 0xFD