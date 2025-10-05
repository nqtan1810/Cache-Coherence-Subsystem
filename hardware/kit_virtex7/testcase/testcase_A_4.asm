# ======================================================================
# Description: 
# ======================================================================
.text
# ===================== To Synchronize =======================
nop_synchronize:
    addi    x1, x0, 50        	      # x1 = loop counter = 100

nop_loop:
    add     x0, x0, x0                # no effect, but still consumes an instruction
    addi    x1, x1, -1                # decrement counter
    bne     x1, x0, nop_loop          # repeat until x1 == 0

base_addr_1:
    addi    x1, x0, 0x10              # x1 = 0x10
    slli    x1, x1, 8                 # x1 = 0x1000 (base address) 
            
quick_check_1:
    lw      x10,  0(x1)
    lw      x11,  4(x1)
    lw      x12,  8(x1)
    lw      x13,  12(x1)
    lw      x14,  16(x1)
    lw      x15,  20(x1)
    lw      x16,  24(x1)
    lw      x17,  28(x1)
    
# ===================== Test Invalid Request ===================
# ===================== Store to 0x1000 ======================
base_addr_2:
    addi    x2, x0, 8                 # x2 = i = 8
    addi    x3, x0, 16                # x3 = loop limit = 16
    
store_loop2:
    beq     x2, x3, quick_check_2     # if i == 16, jump to next phase

    # Generate constant 0x00ABCDEF using LUI + ORI (no LI)
    lui     x6, 0x86420               # x6 = 0x11223000
    ori     x6, x6, 0x2C0             # x6 = 0x112237C0 (~= 0x112237C0)

    xor     x5, x5, x6                # pseudo-random base (x5 ^= 0x112237C0)
    andi    x5, x5, -16               # align to 16 bytes (clear lower 4 bits)
    or      x4, x5, x2                # embed i into LSB of value

    slli    x5, x2, 2                 # offset = i * 4
    add     x6, x1, x5                # target address = base + offset
    sw      x4, 0(x6)                 # store value at address

    addi    x2, x2, 1                 # i++
    jal     x0, store_loop2           # repeat loop
    
quick_check_2:
    lw      x20,  32(x1)
    lw      x21,  36(x1)
    lw      x22,  40(x1)  
    lw      x23,  44(x1)
    lw      x24,  48(x1)
    lw      x25,  52(x1)  
    lw      x26,  56(x1)
    lw      x27,  60(x1)
    
end_program: