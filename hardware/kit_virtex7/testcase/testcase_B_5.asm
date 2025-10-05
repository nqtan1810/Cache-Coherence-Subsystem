# ======================================================================
# Description: 
# ======================================================================
.text
# ===================== To test I -> S  =====================
# ===================== Store to 0x1400 ======================
base_addr_1:
    addi    x1, x0, 0x14              # x1 = 0x14
    slli    x1, x1, 8                 # x1 = 0x1400 (base address)

    addi    x2, x0, 0                 # x2 = i = 0
    addi    x3, x0, 8                 # x3 = loop limit = 8

store_loop1:
    beq     x2, x3, end_program       # if i == 16, jump to next phase

    # Generate constant 0x01234567 using LUI + ORI (no LI)
    lui     x6, 0x1234                # x6 = 0x01234
    ori     x6, x6, 0x567             # x6 = 0x01234567

    xor     x5, x5, x6                # pseudo-random base (x5 ^= 0x01234567)
    andi    x5, x5, -16               # align to 16 bytes (clear lower 4 bits)
    or      x4, x5, x2                # embed i into LSB of value

    slli    x5, x2, 2                 # offset = i * 4
    add     x6, x1, x5                # target address = base + offset
    sw      x4, 0(x6)                 # store value at address

    addi    x2, x2, 1                 # i++
    jal     x0, store_loop1           # repeat loop
    
end_program: