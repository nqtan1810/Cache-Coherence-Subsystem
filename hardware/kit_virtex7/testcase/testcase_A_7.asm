# ======================================================================
# Description: 
# ======================================================================
.text
# ===================== To create I -> M ===================
base_addr_1:
    addi    x1, x0, 0x10              # x1 = 0x10
    slli    x1, x1, 8                 # x1 = 0x1000 (base address) 
    
store_1:
    addi    x2, x0, 0x7AC
    sw	    x2, 0(x1)

# ===================== To create I -> M =====================
# ===================== Store to 0x1400 ======================
base_addr_2:
    addi    x1, x0, 0x14              # x1 = 0x14
    slli    x1, x1, 8                 # x1 = 0x1400 (base address)

store_2:
    addi    x2, x0, 0x456
    sw      x2, 0(x1)                 # store value at address
end_program:
