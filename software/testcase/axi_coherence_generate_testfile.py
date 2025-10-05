import os
import random

def testcase_1(n_set=4):
    base_path = "axi_coherence_testcase/testcase_1/"; os.makedirs(base_path, exist_ok=True)
    path_0 = os.path.join(base_path, "instr_mem_A.mem"); path_1 = os.path.join(base_path, "instr_mem_B.mem"); path_mem = os.path.join(base_path, "main_memory_init.mem")
    tag_bits = 32 - (int(n_set).bit_length() + 4 + 2)
    set_index = random.randint(0, n_set - 1)
    tag = random.randint(0, (1 << tag_bits) - 1)
    addr = ((tag << (4 + int(n_set).bit_length() + 2)) | (set_index << 6)) & 0x0000FFC0
    addr = (addr & 0x0000FFFF) | 0x00000000  # Đảm bảo địa chỉ thuộc inst_0 (0x00000000 - 0x0000FFFF)
    with open(path_0, 'w') as f0:
        f0.write(f"read\t0x{addr:08x}")
    with open(path_1, 'w') as f1: pass
    with open(path_mem, 'w') as f_mem:
        data = '\t'.join(f"0x{random.randint(0, 2**32 - 1):08x}" for _ in range(16))
        f_mem.write(f"0x{addr:08x}\t{data}\n")
    print("Testcase 1 created")
def testcase_2(n_set=4):
    base_path = "axi_coherence_testcase/testcase_2/"; os.makedirs(base_path, exist_ok=True)
    path_0 = os.path.join(base_path, "instr_mem_A.mem"); path_1 = os.path.join(base_path, "instr_mem_B.mem"); path_mem = os.path.join(base_path, "main_memory_init.mem")
    tag_bits = 32 - (int(n_set).bit_length() + 4 + 2)
    set_index = random.randint(0, n_set - 1)
    tag = random.randint(0, (1 << tag_bits) - 1)
    addr = ((tag << (4 + int(n_set).bit_length() + 2)) | (set_index << 6)) & 0x0000FFC0
    addr = (addr & 0x0000FFFF) | 0x00000000  # Đảm bảo địa chỉ thuộc inst_0 (0x00000000 - 0x0000FFFF)
    with open(path_0, 'w') as f0:
        data = '\t'.join(f"0x{random.randint(0, 2**32 - 1):08x}" for _ in range(16))
        f0.write(f"write\t0x{addr:08x}\t{data}")
    with open(path_1, 'w') as f1: pass
    with open(path_mem, 'w') as f_mem:
        data = '\t'.join(f"0x{random.randint(0, 2**32 - 1):08x}" for _ in range(16))
        f_mem.write(f"0x{addr:08x}\t{data}\n")
    print("Testcase 2 created")
def testcase_3(n_set=4):
    base_path = "axi_coherence_testcase/testcase_3/"; os.makedirs(base_path, exist_ok=True)
    path_0 = os.path.join(base_path, "instr_mem_A.mem")
    path_1 = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    set_index = random.randint(0, n_set - 1)
    word_offset = random.randint(0, 15)
    addr = (random.randint(0x00010000, 0x0001FFFF) & 0xFFFFFF00) | (word_offset << 2)  # Đảm bảo 6 bit cuối bằng 0
    addr &= 0xFFFFFFC0  # Đảm bảo 6 bit cuối luôn bằng 0
    with open(path_0, 'w') as f: pass
    with open(path_1, 'w') as f: f.write(f"read\t0x{addr:08x}\n")
    with open(path_mem, 'w') as f:
        block_addr = addr & 0xFFFFFF00
        data = [f"0x{random.randint(0, 2**32 - 1):08x}" for _ in range(16)]
        f.write(f"0x{block_addr:08x}\t" + '\t'.join(data) + '\n')
    print("Testcase 3 created")
def testcase_4(n_set=4):
    base_path = "axi_coherence_testcase/testcase_4/"; os.makedirs(base_path, exist_ok=True)
    path_0 = os.path.join(base_path, "instr_mem_A.mem")
    path_1 = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    set_index = random.randint(0, n_set - 1)
    word_offset = random.randint(0, 15)
    addr = (random.randint(0x00010000, 0x0001FFFF) & 0xFFFFFF00) | (word_offset << 2)  # Đảm bảo 6 bit cuối bằng 0
    addr &= 0xFFFFFFC0  # Đảm bảo 6 bit cuối luôn bằng 0
    with open(path_0, 'w') as f: pass
    with open(path_1, 'w') as f: f.write(f"write\t0x{addr:08x}\t" + '\t'.join([f"0x{random.randint(0, 2**32 - 1):08x}" for _ in range(16)]) + '\n')
    with open(path_mem, 'w') as f:
        block_addr = addr & 0xFFFFFF00
        data = [f"0x{random.randint(0, 2**32 - 1):08x}" for _ in range(16)]
        f.write(f"0x{block_addr:08x}\t" + '\t'.join(data) + '\n')
    print("Testcase 4 created")
def testcase_5(n_set=4):
    base_path = "axi_coherence_testcase/testcase_5/"; os.makedirs(base_path, exist_ok=True)
    path_0 = os.path.join(base_path, "instr_mem_A.mem")
    path_1 = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    set_index = random.randint(0, n_set - 1)
    word_offset_read = random.randint(0, 15)
    word_offset_write = random.randint(0, 15)
    addr_read = (random.randint(0x00000000, 0x0000FFFF) & 0xFFFFFF00) | (word_offset_read << 2)  # Đảm bảo 6 bit cuối bằng 0
    addr_read &= 0xFFFFFFC0  # Đảm bảo 6 bit cuối luôn bằng 0
    addr_write = (random.randint(0x00000000, 0x0000FFFF) & 0xFFFFFF00) | (word_offset_write << 2)  # Đảm bảo 6 bit cuối bằng 0
    addr_write &= 0xFFFFFFC0  # Đảm bảo 6 bit cuối luôn bằng 0
    with open(path_0, 'w') as f:
        f.write(f"read\t0x{addr_read:08x}\n")
        f.write(f"write\t0x{addr_write:08x}\t" + '\t'.join([f"0x{random.randint(0, 2**32 - 1):08x}" for _ in range(16)]) + '\n')
    with open(path_1, 'w') as f: pass
    with open(path_mem, 'w') as f:
        block_addr_read = addr_read & 0xFFFFFF00
        block_addr_write = addr_write & 0xFFFFFF00
        data_read = [f"0x{random.randint(0, 2**32 - 1):08x}" for _ in range(16)]
        data_write = [f"0x{random.randint(0, 2**32 - 1):08x}" for _ in range(16)]
        if block_addr_read != block_addr_write:
            f.write(f"0x{block_addr_read:08x}\t" + '\t'.join(data_read) + '\n')
            f.write(f"0x{block_addr_write:08x}\t" + '\t'.join(data_write) + '\n')
        else:
            f.write(f"0x{block_addr_read:08x}\t" + '\t'.join(data_read) + '\n')
    print("Testcase 5 created")
def testcase_6(n_set=4):
    base_path = "axi_coherence_testcase/testcase_6/"; os.makedirs(base_path, exist_ok=True)
    path_0 = os.path.join(base_path, "instr_mem_A.mem")
    path_1 = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    set_index = random.randint(0, n_set - 1)
    word_offset_write = random.randint(0, 15)
    word_offset_read = random.randint(0, 15)
    addr_write = (random.randint(0x00000000, 0x0000FFFF) & 0xFFFFFF00) | (word_offset_write << 2)  # Đảm bảo 6 bit cuối bằng 0
    addr_write &= 0xFFFFFFC0  # Đảm bảo 6 bit cuối luôn bằng 0
    addr_read = (random.randint(0x00000000, 0x0000FFFF) & 0xFFFFFF00) | (word_offset_read << 2)  # Đảm bảo 6 bit cuối bằng 0
    addr_read &= 0xFFFFFFC0  # Đảm bảo 6 bit cuối luôn bằng 0
    with open(path_0, 'w') as f:
        f.write(f"write\t0x{addr_write:08x}\t" + '\t'.join([f"0x{random.randint(0, 2**32 - 1):08x}" for _ in range(16)]) + '\n')
        f.write(f"read\t0x{addr_read:08x}\n")
    with open(path_1, 'w') as f: pass
    with open(path_mem, 'w') as f:
        block_addr_write = addr_write & 0xFFFFFF00
        block_addr_read = addr_read & 0xFFFFFF00
        data_write = [f"0x{random.randint(0, 2**32 - 1):08x}" for _ in range(16)]
        data_read = [f"0x{random.randint(0, 2**32 - 1):08x}" for _ in range(16)]
        if block_addr_write != block_addr_read:
            f.write(f"0x{block_addr_write:08x}\t" + '\t'.join(data_write) + '\n')
            f.write(f"0x{block_addr_read:08x}\t" + '\t'.join(data_read) + '\n')
        else:
            f.write(f"0x{block_addr_write:08x}\t" + '\t'.join(data_write) + '\n')
    print("Testcase 6 created")
def testcase_7(n_set=4):
    base_path = "axi_coherence_testcase/testcase_7/"; os.makedirs(base_path, exist_ok=True)
    path_0 = os.path.join(base_path, "instr_mem_A.mem")
    path_1 = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    with open(path_0, 'w') as f0: pass
    set_index = random.randint(0, n_set - 1)
    word_offset_read = random.randint(0, 15)
    word_offset_write = random.randint(0, 15)
    addr_read = (random.randint(0x00010000, 0x0001FFFF) & 0xFFFFFF00) | (word_offset_read << 2) & 0xFFFFFFC0
    addr_write = (random.randint(0x00010000, 0x0001FFFF) & 0xFFFFFF00) | (word_offset_write << 2) & 0xFFFFFFC0
    with open(path_1, 'w') as f1:
        f1.write(f"read\t0x{addr_read:08x}\n")
        f1.write(f"write\t0x{addr_write:08x}\t" + '\t'.join([f"0x{random.randint(0, 2**32 - 1):08x}" for _ in range(16)]) + '\n')
    with open(path_mem, 'w') as f_mem:
        block_addr_read = addr_read & 0xFFFFFF00
        block_addr_write = addr_write & 0xFFFFFF00
        data_read = [f"0x{random.randint(0, 2**32 - 1):08x}" for _ in range(16)]
        data_write = [f"0x{random.randint(0, 2**32 - 1):08x}" for _ in range(16)]
        if block_addr_read != block_addr_write:
            f_mem.write(f"0x{block_addr_read:08x}\t" + '\t'.join(data_read) + '\n')
            f_mem.write(f"0x{block_addr_write:08x}\t" + '\t'.join(data_write) + '\n')
        else:
            f_mem.write(f"0x{block_addr_read:08x}\t" + '\t'.join(data_read) + '\n')
    print("Testcase 7 created")
def testcase_8(n_set=4):
    base_path = "axi_coherence_testcase/testcase_8/"; os.makedirs(base_path, exist_ok=True)
    path_0 = os.path.join(base_path, "instr_mem_A.mem")
    path_1 = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    with open(path_0, 'w') as f0: pass
    set_index = random.randint(0, n_set - 1)
    word_offset_write = random.randint(0, 15)
    word_offset_read = random.randint(0, 15)
    addr_write = (random.randint(0x00010000, 0x0001FFFF) & 0xFFFFFF00) | (word_offset_write << 2) & 0xFFFFFFC0
    addr_read = (random.randint(0x00010000, 0x0001FFFF) & 0xFFFFFF00) | (word_offset_read << 2) & 0xFFFFFFC0
    with open(path_1, 'w') as f1:
        f1.write(f"write\t0x{addr_write:08x}\t" + '\t'.join([f"0x{random.randint(0, 2**32 - 1):08x}" for _ in range(16)]) + '\n')
        f1.write(f"read\t0x{addr_read:08x}\n")
    with open(path_mem, 'w') as f_mem:
        block_addr_write = addr_write & 0xFFFFFF00
        block_addr_read = addr_read & 0xFFFFFF00
        data_write = [f"0x{random.randint(0, 2**32 - 1):08x}" for _ in range(16)]
        data_read = [f"0x{random.randint(0, 2**32 - 1):08x}" for _ in range(16)]
        if block_addr_write != block_addr_read:
            f_mem.write(f"0x{block_addr_write:08x}\t" + '\t'.join(data_write) + '\n')
            f_mem.write(f"0x{block_addr_read:08x}\t" + '\t'.join(data_read) + '\n')
        else:
            f_mem.write(f"0x{block_addr_write:08x}\t" + '\t'.join(data_write) + '\n')
    print("Testcase 8 created")
def testcase_9(n_set=4):
    base_path = "axi_coherence_testcase/testcase_9/"; os.makedirs(base_path, exist_ok=True)
    path_0 = os.path.join(base_path, "instr_mem_A.mem")
    path_1 = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    word_offset_read = random.randint(0, 15)
    word_offset_write = random.randint(0, 15)
    addr_read = (random.randint(0x00000000, 0x0000FFFF) & 0xFFFFFF00) | (word_offset_read << 2) & 0xFFFFFFC0
    addr_write = (random.randint(0x00010000, 0x0001FFFF) & 0xFFFFFF00) | (word_offset_write << 2) & 0xFFFFFFC0
    with open(path_0, 'w') as f0:
        f0.write(f"read\t0x{addr_read:08x}\n")
    with open(path_1, 'w') as f1:
        f1.write(f"write\t0x{addr_write:08x}\t" + '\t'.join([f"0x{random.randint(0, 2**32 - 1):08x}" for _ in range(16)]) + '\n')
    with open(path_mem, 'w') as f_mem:
        block_addr_read = addr_read & 0xFFFFFF00
        block_addr_write = addr_write & 0xFFFFFF00
        data_read = [f"0x{random.randint(0, 2**32 - 1):08x}" for _ in range(16)]
        data_write = [f"0x{random.randint(0, 2**32 - 1):08x}" for _ in range(16)]
        if block_addr_read != block_addr_write:
            f_mem.write(f"0x{block_addr_read:08x}\t" + '\t'.join(data_read) + '\n')
            f_mem.write(f"0x{block_addr_write:08x}\t" + '\t'.join(data_write) + '\n')
        else:
            f_mem.write(f"0x{block_addr_read:08x}\t" + '\t'.join(data_read) + '\n')
    print("Testcase 9 created")
def testcase_10(n_set=4):
    base_path = "axi_coherence_testcase/testcase_10/"; os.makedirs(base_path, exist_ok=True)
    path_0 = os.path.join(base_path, "instr_mem_A.mem")
    path_1 = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    word_offset_write = random.randint(0, 15)
    word_offset_read = random.randint(0, 15)
    addr_write = (random.randint(0x00000000, 0x0000FFFF) & 0xFFFFFF00) | (word_offset_write << 2) & 0xFFFFFFC0
    addr_read = (random.randint(0x00010000, 0x0001FFFF) & 0xFFFFFF00) | (word_offset_read << 2) & 0xFFFFFFC0
    with open(path_0, 'w') as f0:
        f0.write(f"write\t0x{addr_write:08x}\t" + '\t'.join([f"0x{random.randint(0, 2**32 - 1):08x}" for _ in range(16)]) + '\n')
    with open(path_1, 'w') as f1:
        f1.write(f"read\t0x{addr_read:08x}\n")
    with open(path_mem, 'w') as f_mem:
        block_addr_write = addr_write & 0xFFFFFF00
        block_addr_read = addr_read & 0xFFFFFF00
        data_write = [f"0x{random.randint(0, 2**32 - 1):08x}" for _ in range(16)]
        data_read = [f"0x{random.randint(0, 2**32 - 1):08x}" for _ in range(16)]
        if block_addr_write != block_addr_read:
            f_mem.write(f"0x{block_addr_write:08x}\t" + '\t'.join(data_write) + '\n')
            f_mem.write(f"0x{block_addr_read:08x}\t" + '\t'.join(data_read) + '\n')
        else:
            f_mem.write(f"0x{block_addr_write:08x}\t" + '\t'.join(data_write) + '\n')
    print("Testcase 10 created")
def testcase_11(n_set=4):
    base_path = "axi_coherence_testcase/testcase_11/"; os.makedirs(base_path, exist_ok=True)
    path_0 = os.path.join(base_path, "instr_mem_A.mem")
    path_1 = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    word_offset_read_0 = random.randint(0, 15)
    word_offset_read_1 = random.randint(0, 15)
    addr_read_0 = (random.randint(0x00000000, 0x0000FFFF) & 0xFFFFFF00) | (word_offset_read_0 << 2) & 0xFFFFFFC0
    addr_read_1 = (random.randint(0x00010000, 0x0001FFFF) & 0xFFFFFF00) | (word_offset_read_1 << 2) & 0xFFFFFFC0
    with open(path_0, 'w') as f0:
        f0.write(f"read\t0x{addr_read_0:08x}\n")
    with open(path_1, 'w') as f1:
        f1.write(f"read\t0x{addr_read_1:08x}\n")
    with open(path_mem, 'w') as f_mem:
        block_addr_read_0 = addr_read_0 & 0xFFFFFF00
        block_addr_read_1 = addr_read_1 & 0xFFFFFF00
        data_read_0 = [f"0x{random.randint(0, 2**32 - 1):08x}" for _ in range(16)]
        data_read_1 = [f"0x{random.randint(0, 2**32 - 1):08x}" for _ in range(16)]
        if block_addr_read_0 != block_addr_read_1:
            f_mem.write(f"0x{block_addr_read_0:08x}\t" + '\t'.join(data_read_0) + '\n')
            f_mem.write(f"0x{block_addr_read_1:08x}\t" + '\t'.join(data_read_1) + '\n')
        else:
            f_mem.write(f"0x{block_addr_read_0:08x}\t" + '\t'.join(data_read_0) + '\n')
    print("Testcase 11 created")
def testcase_12(n_set=4):
    base_path = "axi_coherence_testcase/testcase_12/"; os.makedirs(base_path, exist_ok=True)
    path_0 = os.path.join(base_path, "instr_mem_A.mem")
    path_1 = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    word_offset_write_0 = random.randint(0, 15)
    word_offset_write_1 = random.randint(0, 15)
    addr_write_0 = (random.randint(0x00000000, 0x0000FFFF) & 0xFFFFFF00) | (word_offset_write_0 << 2) & 0xFFFFFFC0
    addr_write_1 = (random.randint(0x00010000, 0x0001FFFF) & 0xFFFFFF00) | (word_offset_write_1 << 2) & 0xFFFFFFC0
    with open(path_0, 'w') as f0:
        f0.write(f"write\t0x{addr_write_0:08x}\t" + '\t'.join([f"0x{random.randint(0, 2**32 - 1):08x}" for _ in range(16)]) + '\n')
    with open(path_1, 'w') as f1:
        f1.write(f"write\t0x{addr_write_1:08x}\t" + '\t'.join([f"0x{random.randint(0, 2**32 - 1):08x}" for _ in range(16)]) + '\n')
    with open(path_mem, 'w') as f_mem:
        block_addr_write_0 = addr_write_0 & 0xFFFFFF00
        block_addr_write_1 = addr_write_1 & 0xFFFFFF00
        data_write_0 = [f"0x{random.randint(0, 2**32 - 1):08x}" for _ in range(16)]
        data_write_1 = [f"0x{random.randint(0, 2**32 - 1):08x}" for _ in range(16)]
        if block_addr_write_0 != block_addr_write_1:
            f_mem.write(f"0x{block_addr_write_0:08x}\t" + '\t'.join(data_write_0) + '\n')
            f_mem.write(f"0x{block_addr_write_1:08x}\t" + '\t'.join(data_write_1) + '\n')
        else:
            f_mem.write(f"0x{block_addr_write_0:08x}\t" + '\t'.join(data_write_0) + '\n')
    print("Testcase 12 created")
def testcase_13(n_set=4):
    base_path = "axi_coherence_testcase/testcase_13/";
    os.makedirs(base_path, exist_ok=True)
    path_0 = os.path.join(base_path, "instr_mem_A.mem")
    path_1 = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    word_offset_read_0 = random.randint(0, 15)
    word_offset_write_1 = random.randint(0, 15)
    word_offset_read_1 = random.randint(0, 15)
    addr_read_0 = (random.randint(0x00000000, 0x0000FFFF) & 0xFFFFFF00) | (word_offset_read_0 << 2) & 0xFFFFFFC0
    addr_write_1 = (random.randint(0x00010000, 0x0001FFFF) & 0xFFFFFF00) | (word_offset_write_1 << 2) & 0xFFFFFFC0
    addr_read_1 = (random.randint(0x00010000, 0x0001FFFF) & 0xFFFFFF00) | (word_offset_read_1 << 2) & 0xFFFFFFC0

    with open(path_0, 'w') as f0:
        f0.write(f"read\t0x{addr_read_0:08x}\n")

    with open(path_1, 'w') as f1:
        f1.write(f"write\t0x{addr_write_1:08x}\t" + '\t'.join(
            [f"0x{random.randint(0, 2 ** 32 - 1):08x}" for _ in range(16)]) + '\n')
        f1.write(f"read\t0x{addr_read_1:08x}\n")

    with open(path_mem, 'w') as f_mem:
        block_addr_read_0 = addr_read_0 & 0xFFFFFF00
        block_addr_write_1 = addr_write_1 & 0xFFFFFF00
        block_addr_read_1 = addr_read_1 & 0xFFFFFF00
        data_read_0 = [f"0x{random.randint(0, 2 ** 32 - 1):08x}" for _ in range(16)]
        data_write_1 = [f"0x{random.randint(0, 2 ** 32 - 1):08x}" for _ in range(16)]
        data_read_1 = [f"0x{random.randint(0, 2 ** 32 - 1):08x}" for _ in range(16)]

        if block_addr_read_0 != block_addr_write_1:
            f_mem.write(f"0x{block_addr_read_0:08x}\t" + '\t'.join(data_read_0) + '\n')
        if block_addr_write_1 != block_addr_read_1:
            f_mem.write(f"0x{block_addr_write_1:08x}\t" + '\t'.join(data_write_1) + '\n')
        f_mem.write(f"0x{block_addr_read_1:08x}\t" + '\t'.join(data_read_1) + '\n')
    print("Testcase 13 created")
def testcase_14(n_set=4):
    base_path = "axi_coherence_testcase/testcase_14/";
    os.makedirs(base_path, exist_ok=True)
    path_0 = os.path.join(base_path, "instr_mem_A.mem")
    path_1 = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    word_offset_read_0 = random.randint(0, 15)
    word_offset_write_0 = random.randint(0, 15)
    word_offset_write_1 = random.randint(0, 15)
    addr_read_0 = (random.randint(0x00000000, 0x0000FFFF) & 0xFFFFFF00) | (word_offset_read_0 << 2) & 0xFFFFFFC0
    addr_write_0 = (random.randint(0x00000000, 0x0000FFFF) & 0xFFFFFF00) | (word_offset_write_0 << 2) & 0xFFFFFFC0
    addr_write_1 = (random.randint(0x00010000, 0x0001FFFF) & 0xFFFFFF00) | (word_offset_write_1 << 2) & 0xFFFFFFC0

    with open(path_0, 'w') as f0:
        f0.write(f"read\t0x{addr_read_0:08x}\n")
        f0.write(f"write\t0x{addr_write_0:08x}\t" + '\t'.join(
            [f"0x{random.randint(0, 2 ** 32 - 1):08x}" for _ in range(16)]) + '\n')

    with open(path_1, 'w') as f1:
        f1.write(f"write\t0x{addr_write_1:08x}\t" + '\t'.join(
            [f"0x{random.randint(0, 2 ** 32 - 1):08x}" for _ in range(16)]) + '\n')

    with open(path_mem, 'w') as f_mem:
        block_addr_read_0 = addr_read_0 & 0xFFFFFF00
        block_addr_write_0 = addr_write_0 & 0xFFFFFF00
        block_addr_write_1 = addr_write_1 & 0xFFFFFF00
        data_read_0 = [f"0x{random.randint(0, 2 ** 32 - 1):08x}" for _ in range(16)]
        data_write_0 = [f"0x{random.randint(0, 2 ** 32 - 1):08x}" for _ in range(16)]
        data_write_1 = [f"0x{random.randint(0, 2 ** 32 - 1):08x}" for _ in range(16)]

        if block_addr_read_0 != block_addr_write_0:
            f_mem.write(f"0x{block_addr_read_0:08x}\t" + '\t'.join(data_read_0) + '\n')
        f_mem.write(f"0x{block_addr_write_0:08x}\t" + '\t'.join(data_write_0) + '\n')
        f_mem.write(f"0x{block_addr_write_1:08x}\t" + '\t'.join(data_write_1) + '\n')
    print("Testcase 14 created")

def main():
    # Danh sách các hàm testcase
    list_testcases = [
        testcase_1, testcase_2, testcase_3, testcase_4, testcase_5, testcase_6, testcase_7, testcase_8,
        testcase_9, testcase_10, testcase_11, testcase_12, testcase_13, testcase_14
    ]

    print("========== MENU TẠO TESTCASE ==========")
    print("1. Tạo tất cả 14 testcase")
    print("2. Tạo testcase cụ thể")

    choice = input("Nhập lựa chọn (1 hoặc 2): ")

    if choice == '1':
        # Gọi tuần tự tất cả các hàm testcase
        for func in list_testcases:
            func()
    elif choice == '2':
        # Yêu cầu người dùng nhập số testcase mong muốn
        tc_number = input("Nhập testcase muốn tạo (1-22): ")
        if tc_number.isdigit():
            tc_number = int(tc_number)
            if 1 <= tc_number <= 200:
                # Gọi hàm tương ứng (do index trong list bắt đầu từ 0)
                list_testcases[tc_number - 1]()
            else:
                print("Số testcase không hợp lệ!")
        else:
            print("Vui lòng nhập số hợp lệ!")
    else:
        print("Lựa chọn không hợp lệ!")


if __name__ == "__main__":
    main()
