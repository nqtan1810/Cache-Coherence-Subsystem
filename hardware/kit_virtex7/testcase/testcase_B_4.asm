# ======================================================================
# Description: 
# ======================================================================
.text
# ===================== Test Invalid Response =====================
# ===================== Store to 0x1000 ======================
base_addr_1:
    addi    x1, x0, 0x10              # x1 = 0x10
    slli    x1, x1, 8                 # x1 = 0x1000 (base address)

    addi    x2, x0, 0                 # x2 = i = 0
    addi    x3, x0, 8                # x3 = loop limit = 8

store_loop1:
    beq     x2, x3, quick_check_1     # if i == 16, jump to next phase

    # Generate constant 0x097530A0 using LUI + ORI (no LI)
    lui     x6, 0x09753               # x6 = 0x09753
    ori     x6, x6, 0x0A0             # x6 = 00x097530A0

    xor     x5, x5, x6                # pseudo-random base (x5 ^= 0x097530A0)
    andi    x5, x5, -16               # align to 16 bytes (clear lower 4 bits)
    or      x4, x5, x2                # embed i into LSB of value

    slli    x5, x2, 2                 # offset = i * 4
    add     x6, x1, x5                # target address = base + offset
    sw      x4, 0(x6)                 # store value at address

    addi    x2, x2, 1                 # i++
    jal     x0, store_loop1           # repeat loop
    
quick_check_1:
    lw      x10,  0(x1)
    lw      x11,  4(x1)
    lw      x12,  8(x1)
    lw      x13,  12(x1)
    lw      x14,  16(x1)
    lw      x15,  20(x1)
    lw      x16,  24(x1)
    lw      x17,  28(x1)

end_program: