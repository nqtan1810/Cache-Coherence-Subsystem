# ********************* U-Type Tests - LUI & AUIPC *********************
.text

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
