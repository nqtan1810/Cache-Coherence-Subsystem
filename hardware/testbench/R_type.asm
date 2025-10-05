# ********************* R-Type Tests - Extended *********************
.text

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
