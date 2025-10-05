# ======================================================================
# Description: 
# ======================================================================
.text
# ===================== Test I -> E ===================
base_addr_1:
    addi    x1, x0, 0x10              # x1 = 0x10
    slli    x1, x1, 8                 # x1 = 0x1000 (base address) 
    
load_1:
    lw      x6,  0(x1)                # load word
    lh      x7,  0(x1)                # load halfword (signed)
    lhu     x8,  0(x1)                # load halfword (unsigned)
    lb      x9,  0(x1)                # load byte (signed)
    lbu     x10, 0(x1)                # load byte (unsigned)
    
# ===================== To Synchronize =======================
nop_synchronize:
    addi    x1, x0, 50        	      # x1 = loop counter = 100

nop_loop:
    add     x0, x0, x0                # no effect, but still consumes an instruction
    addi    x1, x1, -1                # decrement counter
    bne     x1, x0, nop_loop          # repeat until x1 == 0
    
# ===================== Test I -> S ===================
base_addr_2:
    addi    x1, x0, 0x14              # x1 = 0x14
    slli    x1, x1, 8                 # x1 = 0x1400 (base address) 
    
load_2:
    lw      x11,  0(x1)               # load word
    lh      x12,  0(x1)               # load halfword (signed)
    lhu     x13,  0(x1)               # load halfword (unsigned)
    lb      x14,  0(x1)               # load byte (signed)
    lbu     x15,  0(x1)               # load byte (unsigned)
    
# ===================== Test I -> M ===================
base_addr_3:
    addi    x1, x0, 0x18              # x1 = 0x18
    slli    x1, x1, 8                 # x1 = 0x1800 (base address) 
    
store_3:
    sw      x11,  0(x1)               # load word
    sh      x12,  4(x1)               # load halfword (signed)
    sb      x13,  8(x1)               # load halfword (unsigned)
    
end_program: