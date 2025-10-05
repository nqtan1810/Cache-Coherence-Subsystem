# ======================================================================
# Description: 
# ======================================================================
.text
# ===================== To create I -> E ===================
base_addr_1:
    addi    x1, x0, 0x10              # x1 = 0x10
    slli    x1, x1, 8                 # x1 = 0x1000 (base address) 
    
store_1:
    lw	    x6, 0(x1)
    
# ===================== To create I -> E ===================
base_addr_2:
    addi    x1, x0, 0x14              # x1 = 0x14
    slli    x1, x1, 8                 # x1 = 0x1400 (base address) 
    
store_2:
    lw	    x7, 0(x1)
    
nop_synchronize:
    addi    x2, x0, 150        	      # x1 = loop counter = 100

nop_loop:
    add     x0, x0, x0                # no effect, but still consumes an instruction
    addi    x2, x2, -1                # decrement counter
    bne     x2, x0, nop_loop          # repeat until x1 == 0
    
# ===================== Test S -> M (In Core_0) ===================    
store_3:
    addi    x2, x0, 0x3AE
    sw	    x2, 0(x1)

end_program: