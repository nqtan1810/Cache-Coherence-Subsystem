# ======================================================================
# Description: 
# ======================================================================
.text
# ============= Write Miss, Write Hit, Write Allocate Test =============
# ===================== Store to 0x3000 ======================
base_addr_1:
    addi    x1, x0, 0x24              # x1 = 0x24
    slli    x1, x1, 8                 # x1 = 0x2400

    addi    x2, x0, 0                 # i = 0
    addi    x3, x0, 16                # loop limit = 16

store_loop1:
    beq     x2, x3, base_addr_2       # if i == 16, jump to next phase

    lui     x6, 0x00ABC               # x6 = 0x00ABC000
    ori     x6, x6, 0x7EF             # x6 = 0x00ABC7EF

    xor     x5, x5, x6                # pseudo-random value
    andi    x5, x5, -16               # align to 16 bytes
    or      x4, x5, x2                # embed i into LSB

    slli    x5, x2, 2                 # offset = i * 4
    add     x6, x1, x5                # address = base + offset
    sw      x4, 0(x6)                 # store to memory

    addi    x2, x2, 1
    jal     x0, store_loop1

# ===================== Read Hit Test ======================
base_addr_2:
    addi    x2, x0, 0
    addi    x3, x0, 16
    addi    x22, x0, -1               # AND accumulator

load_loop_2:
    beq     x2, x3, base_addr_3

    slli    x4, x2, 2
    add     x5, x1, x4

    lw      x6,  0(x5)
    lh      x7,  0(x5)
    lhu     x8,  0(x5)
    lb      x9,  0(x5)
    lbu     x10, 0(x5)

    or      x21, x21, x6             
    and     x22, x22, x7             
    xor     x23, x23, x8             
    add     x24, x24, x9             
    add     x25, x25, x10             

    addi    x2, x2, 1
    jal     x0, load_loop_2

# ===================== Store to 0x2800 ======================
base_addr_3:
    addi    x1, x0, 0x28
    slli    x1, x1, 8                 # x1 = 0x2800

    lui     x5, 0x12345
    ori     x5, x5, 0x678
    sw      x5, 0(x1)

# ===================== Store to 0x2c00 ======================
base_addr_4:
    addi    x1, x0, 0x2c
    slli    x1, x1, 8                 # x1 = 0x2c00

    lui     x5, 0xCAFEB
    ori     x5, x5, 0x0BE
    sw      x5, 0(x1)

# ===================== Store to 0xc00 ======================
base_addr_5:
    addi    x1, x0, 0xc
    slli    x1, x1, 8                 # x1 = 0xc00

    lui     x5, 0x13579
    ori     x5, x5, 0x0E0
    sw      x5, 0(x1)

# ===================== Store to 0xc40 ======================
base_addr_6:
    addi    x1, x0, 0xc4
    slli    x1, x1, 4                 # x1 = 0xc40

    lui     x5, 0x2468A
    ori     x5, x5, 0x0CE
    sw      x5, 0(x1)

# ============= Read Miss, Read Hit, Read Allocate Test =============
base_addr_7:
    addi    x1, x0, 0x24
    slli    x1, x1, 8                 # x1 = 0x2400

    addi    x2, x0, 0
    addi    x3, x0, 16
    addi    x27, x0, -1               # x27 = 0xFFFFFFFF

load_loop_7:
    beq     x2, x3, quick_check

    slli    x4, x2, 2
    add     x5, x1, x4

    lw      x6,  0(x5)
    lh      x7,  0(x5)
    lhu     x8,  0(x5)
    lb      x9,  0(x5)
    lbu     x10, 0(x5)

    or      x26, x26, x6             
    and     x27, x27, x7             
    xor     x28, x28, x8             
    add     x29, x29, x9           
    add     x30, x30, x10             

    addi    x2, x2, 1
    jal     x0, load_loop_7

quick_check:  
    # to quick check
    xor     x11, x21, x26              
    xor     x12, x22, x27             
    xor     x13, x23, x28             
    xor     x14, x24, x29            
    xor     x15, x25, x30            

end_program:
