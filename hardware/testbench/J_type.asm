# ********************* J-Type Instructions Test - RV32I *********************
.text

addi x1, x0, 48			# pc = 0
addi x2, x0, 64			# pc = 4
addi x3, x0, 84			# pc = 8
addi x4, x0, 108		# pc = 12

jal x5, JUMP_1			# pc = 16
addi x6, x0, 100		# pc = 20
addi x7, x0, 200		# pc = 24

JUMP_1:
addi x8, x0, 300		# pc = 28
addi x9, x0, 400		# pc = 32

jal x10, JUMP_2			# pc = 36
addi x11, x0, 500		# pc = 40

JUMP_2:
addi x12, x0, 600		# pc = 44

jalr x13, x1, 8			# pc = 48
addi x14, x0, 700		# pc = 52
addi x15, x0, 710		# pc = 56

addi x16, x0, 720		# pc = 60
jalr x17, x2, 12		# pc = 64
addi x18, x0, 720		# pc = 68
addi x19, x0, 730		# pc = 72
addi x20, x0, 740		# pc = 76

addi x21, x0, 750		# pc = 80
jalr x22, x3, 16		# pc = 84
addi x23, x0, 760		# pc = 88
addi x24, x0, 770		# pc = 92
addi x25, x0, 780		# pc = 96
addi x26, x0, 790		# pc = 100

addi x27, x0, 799		# pc = 104
jalr x28, x4, 4			# pc = 108
addi x29, x0, 733		# pc = 112
addi x30, x0, 755		# pc = 116
addi x31, x0, 715		# pc = 120