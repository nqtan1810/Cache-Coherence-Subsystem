# ======================================================================
# Description: 
# ======================================================================
.text
# ============= Write Miss, Write Hit, Write Allocate Test =============
# ===================== Store to 0x1000 ======================
base_addr_1:
    addi    x1, x0, 0x10              # x1 = 0x10
    slli    x1, x1, 8                 # x1 = 0x1000 (base address)

    addi    x2, x0, 0                 # x2 = i = 0
    addi    x3, x0, 16                # x3 = loop limit = 16

store_loop1:
    beq     x2, x3, base_addr_2       # if i == 16, jump to next phase

    # Generate constant 0x00ABCDEF using LUI + ORI (no LI)
    lui     x6, 0x00ABC               # x6 = 0x00ABC000
    ori     x6, x6, 0x7EF             # x6 = 0x00ABC7EF (~= 0xABCDEF)

    xor     x5, x5, x6                # pseudo-random base (x5 ^= 0xABCDEF)
    andi    x5, x5, -16               # align to 16 bytes (clear lower 4 bits)
    or      x4, x5, x2                # embed i into LSB of value

    slli    x5, x2, 2                 # offset = i * 4
    add     x6, x1, x5                # target address = base + offset
    sw      x4, 0(x6)                 # store value at address

    addi    x2, x2, 1                 # i++
    jal     x0, store_loop1          # repeat loop

# ===================== Read Hit Test ======================
base_addr_2:
    addi    x2, x0, 0                 # i = 0
    addi    x3, x0, 16                # loop limit = 16
    addi    x12, x0, -1               # x12 = 0xFFFFFFFF (AND accumulator)

load_loop_2:
    beq     x2, x3, base_addr_3       # if i == 16, jump to next phase

    slli    x4, x2, 2                 # offset = i * 4
    add     x5, x1, x4                # address = base + offset

    lw      x6,  0(x5)                # load word
    lh      x7,  0(x5)                # load halfword (signed)
    lhu     x8,  0(x5)                # load halfword (unsigned)
    lb      x9,  0(x5)                # load byte (signed)
    lbu     x10, 0(x5)                # load byte (unsigned)

    or      x11, x11, x6              # OR accumulation
    and     x12, x12, x7              # AND accumulation
    xor     x13, x13, x8              # XOR accumulation
    add     x14, x14, x9              # signed byte sum
    add     x15, x15, x10             # unsigned byte sum

    addi    x2, x2, 1                 # i++
    jal     x0, load_loop_2          # repeat loop

# ===================== Store to 0x1400 ======================
base_addr_3:
    addi    x1, x0, 0x14              # x1 = 0x14
    slli    x1, x1, 8                 # x1 = 0x1400

    lui     x5, 0x12345               # upper 20 bits
    ori     x5, x5, 0x678             # x5 = 0x12345678
    sw      x5, 0(x1)                 # store to memory

# ===================== Store to 0x1800 ======================
base_addr_4:
    addi    x1, x0, 0x18              # x1 = 0x18
    slli    x1, x1, 8                 # x1 = 0x1800

    lui     x5, 0xCAFEB               # upper 20 bits
    ori     x5, x5, 0x0BE             # x5 = 0xCAFEB0BE
    sw      x5, 0(x1)                 # store to memory

# ===================== Store to 0x1C00 ======================
base_addr_5:
    addi    x1, x0, 0x1C              # x1 = 0x1C
    slli    x1, x1, 8                 # x1 = 0x1C00

    lui     x5, 0x13579               # upper 20 bits
    ori     x5, x5, 0x0E0             # x5 = 0x135790E0
    sw      x5, 0(x1)                 # store to memory

# ===================== Store to 0x2000 ======================
base_addr_6:
    addi    x1, x0, 0x20              # x1 = 0x20
    slli    x1, x1, 8                 # x1 = 0x2000

    lui     x5, 0x2468A               # upper 20 bits
    ori     x5, x5, 0x0CE             # x5 = 0x2468A0CE
    sw      x5, 0(x1)                 # store to memory

# ============= Read Miss, Read Hit, Read Allocate Test =============
base_addr_7:
    addi    x1, x0, 0x10              # x1 = 0x10
    slli    x1, x1, 8                 # x1 = 0x1000 (base address)
    
    addi    x2, x0, 0                 # i = 0
    addi    x3, x0, 16                # loop limit = 16
    addi    x17, x0, -1               # AND accumulator = 0xFFFFFFFF

load_loop_7:
    beq     x2, x3, quick_check       # if i == 16, jump to end

    slli    x4, x2, 2                 # offset = i * 4
    add     x5, x1, x4                # address = base + offset

    lw      x6,  0(x5)                # load word
    lh      x7,  0(x5)                # load halfword (signed)
    lhu     x8,  0(x5)                # load halfword (unsigned)
    lb      x9,  0(x5)                # load byte (signed)
    lbu     x10, 0(x5)                # load byte (unsigned)

    or      x16, x16, x6              # OR accumulation
    and     x17, x17, x7              # AND accumulation
    xor     x18, x18, x8              # XOR accumulation
    add     x19, x19, x9              # signed byte sum
    add     x20, x20, x10             # unsigned byte sum

    addi    x2, x2, 1                 # i++
    jal     x0, load_loop_7           # repeat loop

quick_check:  
    # to quick check
    xor     x21, x11, x16              
    xor     x22, x12, x17             
    xor     x23, x13, x18             
    xor     x24, x14, x19            
    xor     x25, x15, x20 
    
end_program:
