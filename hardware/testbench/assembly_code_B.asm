.text

lui x1, 0x1          # x1 = 0x1000 (base address for memory tests)
lui x2, 0x12345
addi x2, x2, 0x678
sh x2, 0(x1)           # Store byte 0x78 at MEM[0x1000]