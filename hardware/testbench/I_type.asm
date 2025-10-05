# ********************* I-Type ALU Tests - RV32I Only *********************
.text

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
