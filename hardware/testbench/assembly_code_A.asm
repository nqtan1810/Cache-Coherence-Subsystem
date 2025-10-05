# This is testcase_A_1.asm
# Description: CORE_0/CORE_1 Read/Write hit/miss, access private region and shared region but no overlap address

.text
# assembly code is start here!
# === Set x1 = 0x0800 ===
addi x1, x0, 0x08
slli x1, x1, 8        # x1 = 0x0800

# === x2 = index = 0 ===
addi x2, x0, 0

# === Store 5 values to memory ===
store_loop1:
    addi x3, x0, 5
    beq  x2, x3, load_loop1

    # Value = 0x11111111 + i
    addi x4, x0, 0x11
    slli x4, x4, 8
    ori  x4, x4, 0x11
    slli x4, x4, 8
    ori  x4, x4, 0x11
    slli x4, x4, 8
    ori  x4, x4, 0x11
    add  x4, x4, x2

    slli x5, x2, 2
    add  x6, x1, x5
    sw   x4, 0(x6)

    addi x2, x2, 1
    jal  x0, store_loop1

# === Load values from 0x0800 ===
load_loop1:
    addi x2, x0, 0
    addi x7, x0, 0

load1:
    addi x3, x0, 5
    beq  x2, x3, switch_base

    slli x5, x2, 2
    add  x6, x1, x5

    lw   x8, 0(x6)
    lh   x9, 0(x6)
    lhu  x10, 0(x6)
    lb   x11, 0(x6)
    lbu  x12, 0(x6)

    add  x7, x7, x8
    xor  x7, x7, x9
    or   x7, x7, x10
    and  x7, x7, x11
    add  x7, x7, x12

    addi x2, x2, 1
    jal  x0, load1

# === Switch to base 0x1000 ===
switch_base:
    addi x1, x0, 0x10
    slli x1, x1, 8       # x1 = 0x1000
    addi x2, x0, 0

# === Store to 0x1000 ===
store_loop2:
    addi x3, x0, 5
    beq  x2, x3, load_loop2

    # Value = 0xCAFEBABE + i
    addi x4, x0, 0xBE
    slli x4, x4, 8
    ori  x4, x4, 0xBA
    slli x4, x4, 8
    ori  x4, x4, 0xFE
    slli x4, x4, 8
    ori  x4, x4, 0xCA
    add  x4, x4, x2

    slli x5, x2, 2
    add  x6, x1, x5
    sw   x4, 0(x6)

    addi x2, x2, 1
    jal  x0, store_loop2

# === Load from 0x1000 ===
load_loop2:
    addi x2, x0, 0

load2:
    addi x3, x0, 5
    beq  x2, x3, end_program

    slli x5, x2, 2
    add  x6, x1, x5

    lw   x8, 0(x6)
    lh   x9, 0(x6)
    lhu  x10, 0(x6)
    lb   x11, 0(x6)
    lbu  x12, 0(x6)

    addi x2, x2, 1
    jal  x0, load2

# === End of program ===
end_program:
