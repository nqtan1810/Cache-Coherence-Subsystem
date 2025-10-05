# ********************* B-Type Instructions Test - RV32I *********************
.text

# Initial setup of registers (using addi to set values for the test)
addi x1, x0, 5         # x1 = 5
addi x2, x0, 10        # x2 = 10
addi x3, x0, -3        # x3 = -3 (0xFFFFFFFD)
addi x4, x0, 255       # x4 = 255
addi x5, x0, 127       # x5 = 127
addi x6, x0, 128       # x6 = 128
addi x7, x0, -1        # x7 = -1 (signed)

# Test BEQ (Branch if Equal)
beq x1, x2, beq_taken  # Branch to beq_taken if x1 == x2 (not taken)
addi x8, x0, 0x111     # This should execute if branch does not happen
beq_taken:
addi x9, x0, 0x222     # This should execute if branch happened

# Test BNE (Branch if Not Equal)
bne x1, x2, bne_taken  # Branch to bne_taken if x1 != x2 (taken)
addi x10, x0, 0x333    # This should not execute if branch happens
bne_taken:
addi x11, x0, 0x444    # This should execute if branch happened

# Test BLT (Branch if Less Than, signed comparison)
blt x1, x2, blt_taken  # Branch to blt_taken if x1 < x2 (signed) (taken)
addi x12, x0, 0x555    # This should not execute if branch happens
blt_taken:
addi x13, x0, 0x666    # This should execute if branch happened

# Test BGE (Branch if Greater or Equal, signed comparison)
bge x1, x2, bge_taken  # Branch to bge_taken if x1 >= x2 (signed) (not taken)
addi x14, x0, 0x777    # This should execute if branch does not happen
bge_taken:
addi x15, x0, 0x88     # This should execute if branch happened

# Test BLTU (Branch if Less Than, unsigned comparison)
bltu x1, x2, bltu_taken # Branch to bltu_taken if x1 < x2 (unsigned) (taken)
addi x16, x0, 0x99     # This should not execute if branch happens
bltu_taken:
addi x17, x0, 0xAA     # This should execute if branch happened

# Test BGEU (Branch if Greater or Equal, unsigned comparison)
bgeu x1, x2, bgeu_taken # Branch to bgeu_taken if x1 >= x2 (unsigned) (not taken)
addi x18, x0, 0xBB     # This should execute if branch does not happen
bgeu_taken:
addi x19, x0, 0xCC     # This should execute if branch happened

# Reset the registers to check the conditions where branch will NOT happen

# Test BEQ (Branch if Equal) - Not taken
beq x1, x2, beq_not_taken  # Branch to beq_not_taken if x1 == x2 (taken)
addi x20, x0, 0x111        # This should not execute if branch happens
beq_not_taken:
addi x21, x0, 0x222        # This should execute if branch did not happen

# Test BNE (Branch if Not Equal) - Not taken
bne x1, x2, bne_not_taken  # Branch to bne_not_taken if x1 != x2 (not taken)
addi x22, x0, 0x333        # This should execute if branch does not happen
bne_not_taken:
addi x23, x0, 0x444        # This should execute if branch did not happen

# Test BLT (Branch if Less Than, signed comparison) - Not taken
blt x1, x2, blt_not_taken  # Branch to blt_not_taken if x1 < x2 (signed) (not taken)
addi x24, x0, 0x555        # This should execute if branch does not happen
blt_not_taken:
addi x25, x0, 0x666        # This should execute if branch did not happen

# Test BGE (Branch if Greater or Equal, signed comparison) - Not taken
bge x1, x2, bge_not_taken  # Branch to bge_not_taken if x1 >= x2 (signed) (taken)
addi x26, x0, 0x777        # This should not execute if branch happens
bge_not_taken:
addi x27, x0, 0x88         # This should execute if branch did not happen

# Test BLTU (Branch if Less Than, unsigned comparison) - Not taken
bltu x1, x2, bltu_not_taken # Branch to bltu_not_taken if x1 < x2 (unsigned) (not taken)
addi x28, x0, 0x99         # This should execute if branch does not happen
bltu_not_taken:
addi x29, x0, 0xAA         # This should execute if branch did not happen

# Test BGEU (Branch if Greater or Equal, unsigned comparison) - Not taken
bgeu x1, x2, bgeu_not_taken # Branch to bgeu_not_taken if x1 >= x2 (unsigned) (taken)
addi x30, x0, 0xBB          # This should not execute if branch happens
bgeu_not_taken:
addi x31, x0, 0xCC          # This should execute if branch did not happen
