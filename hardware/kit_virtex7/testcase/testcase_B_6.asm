# ======================================================================
# Description: 
# ======================================================================
.text
# ===================== To Synchronize =======================
nop_synchronize:
    addi    x1, x0, 150        	      # x1 = loop counter = 100

nop_loop:
    add     x0, x0, x0                # no effect, but still consumes an instruction
    addi    x1, x1, -1                # decrement counter
    bne     x1, x0, nop_loop          # repeat until x1 == 0

# ===================== Test E -> I (In Core_0) =====================
# ===================== Store to 0x1000 ======================
base_addr_1:
    addi    x1, x0, 0x10              # x1 = 0x10
    slli    x1, x1, 8                 # x1 = 0x1000 (base address)

store_1:
    addi    x2, x0, 0x3FF
    sw      x2, 0(x1)                 # store value at address
    
# ===================== Test E -> S (In Core_0) =====================
# ===================== Store to 0x1000 ======================
base_addr_2:
    addi    x1, x0, 0x14              # x1 = 0x14
    slli    x1, x1, 8                 # x1 = 0x1400 (base address)
    
store_2:
    lw      x6, 0(x1)                 # load value at address
    
end_program: