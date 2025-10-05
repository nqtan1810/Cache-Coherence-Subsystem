# ======================================================================
# Description: 
# ======================================================================
.text
# ===================== To create I -> E ===================
base_addr_1:
    addi    x1, x0, 0x10              # x1 = 0x10
    slli    x1, x1, 8                 # x1 = 0x1000 (base address) 
    
load_1:
    lw      x6,  0(x1)                # load word
    
# ===================== To create I -> E ===================
base_addr_2:
    addi    x1, x0, 0x14              # x1 = 0x14
    slli    x1, x1, 8                 # x1 = 0x1400 (base address) 
    
load_2:
    lw      x7,  0(x1)                # load word
    
# ===================== To create I -> E ===================
base_addr_3:
    addi    x1, x0, 0x18              # x1 = 0x18
    slli    x1, x1, 8                 # x1 = 0x1800 (base address) 
    
load_3:
    lw      x7,  0(x1)                # load word
    
# ===================== Test E -> M (In Core_0) =====================
store_3:
    addi    x2, x0, 0x789
    sw      x2, 0(x1)

quick_check:
    lw      x8, 0(x1)		      # load to check
    
end_program: