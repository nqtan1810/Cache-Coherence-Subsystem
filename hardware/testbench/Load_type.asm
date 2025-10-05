# ********************* Load Instruction Tests - RV32I *********************
.text

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
