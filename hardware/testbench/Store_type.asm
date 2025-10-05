# ********************* Store and Load Instruction Tests - RV32I *********************
.text

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
