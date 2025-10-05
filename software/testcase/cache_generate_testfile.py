import os
import random

# Hàm xử lý từng testcase trong nhóm 1.1
def testcase_1():
    def to_hex32(value): return f"0x{value:08X}"
    base_path = "cache_testcase/testcase_1/"
    os.makedirs(base_path, exist_ok=True)
    path_0 = os.path.join(base_path, "instr_mem_A.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    instructions = []
    addresses = []
    used_tags = set()
    fixed_set = random.randint(0, 0xF)
    n = random.randint(1, 4)
    tags_list = []
    for _ in range(n):
        while True:
            tag = random.randint(0, 0x3F)
            if tag not in used_tags:
                used_tags.add(tag)
                tags_list.append(tag)
                break
        offset = random.choice(range(0, 64, 4))
        addr = (tag << 10) | (fixed_set << 6) | offset
        instructions.append(f"read\t{to_hex32(addr)}")
        addresses.append(addr)
    tag = random.choice(tags_list)
    offset = random.choice(range(0, 64, 4))
    addr = (tag << 10) | (fixed_set << 6) | offset
    instructions.append(f"read\t{to_hex32(addr)}")
    addresses.append(addr)
    with open(path_0, "w") as f:
        for line in instructions: f.write(line + "\n")
    base_written = set()
    with open(path_mem, "w") as f:
        for addr in addresses:
            base_addr = addr & ~0x3F
            if base_addr in base_written: continue
            base_written.add(base_addr)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(base_addr)] + words) + "\n")
    print("testcase 1 created")
def testcase_2():
    def to_hex32(value): return f"0x{value:08X}"
    base_path = "cache_testcase/testcase_2/"
    os.makedirs(base_path, exist_ok=True)
    path_0 = os.path.join(base_path, "instr_mem_A.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    instructions = []
    addresses = []
    used_tags = set()
    fixed_set = random.randint(0, 0xF)
    for _ in range(4):
        while True:
            tag = random.randint(0, 0x3F)
            if tag not in used_tags:
                used_tags.add(tag)
                break
        offset = random.choice(range(0, 64, 4))
        addr = (tag << 10) | (fixed_set << 6) | offset
        instructions.append(f"read\t{to_hex32(addr)}")
        addresses.append(addr)
    with open(path_0, "w") as f:
        for line in instructions: f.write(line + "\n")
    base_written = set()
    with open(path_mem, "w") as f:
        for addr in addresses:
            base_addr = addr & ~0x3F
            if base_addr in base_written: continue
            base_written.add(base_addr)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(base_addr)] + words) + "\n")
    print("testcase 2 created")
def testcase_3():
    def to_hex32(value): return f"0x{value:08X}"
    base_path = "cache_testcase/testcase_3/"
    os.makedirs(base_path, exist_ok=True)
    path_0 = os.path.join(base_path, "instr_mem_A.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    instructions = []
    addresses = []
    used_tags = set()
    fixed_set = random.randint(0, 0xF)
    for _ in range(5):
        while True:
            tag = random.randint(0, 0x3F)
            if tag not in used_tags:
                used_tags.add(tag)
                break
        offset = random.choice(range(0, 64, 4))
        addr = (tag << 10) | (fixed_set << 6) | offset
        instructions.append(f"read\t{to_hex32(addr)}")
        addresses.append(addr)
    with open(path_0, "w") as f:
        for line in instructions: f.write(line + "\n")
    base_written = set()
    with open(path_mem, "w") as f:
        for addr in addresses:
            base_addr = addr & ~0x3F
            if base_addr in base_written: continue
            base_written.add(base_addr)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(base_addr)] + words) + "\n")
    print("testcase 3 created")
def testcase_4():
    def to_hex32(value): return f"0x{value:08X}"
    base_path = "cache_testcase/testcase_4/"
    os.makedirs(base_path, exist_ok=True)
    path_0 = os.path.join(base_path, "instr_mem_A.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    instructions = []
    addresses = []
    used_tags = set()
    fixed_set = random.randint(0, 0xF)
    for _ in range(4):
        while True:
            tag = random.randint(0, 0x3F)
            if tag not in used_tags:
                used_tags.add(tag)
                break
        offset = random.choice(range(0, 64, 4))
        addr = (tag << 10) | (fixed_set << 6) | offset
        addr_hex = to_hex32(addr)
        data = to_hex32(random.getrandbits(32))
        instructions.append(f"write\t{addr_hex}\t{data}")
        addresses.append(addr)
    while True:
        tag = random.randint(0, 0x3F)
        if tag not in used_tags:
            used_tags.add(tag)
            break
    offset = random.choice(range(0, 64, 4))
    addr = (tag << 10) | (fixed_set << 6) | offset
    addr_hex = to_hex32(addr)
    instructions.append(f"read\t{addr_hex}")
    addresses.append(addr)
    with open(path_0, "w") as f:
        for line in instructions: f.write(line + "\n")
    with open(path_mem, "w") as f:
        for addr in addresses:
            base_addr = addr & ~0x3F
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(base_addr)] + words) + "\n")
    print("testcase 4 created")
def testcase_5():
    def to_hex32(value): return f"0x{value:08X}"
    base_path = "cache_testcase/testcase_5/"
    os.makedirs(base_path, exist_ok=True)
    path_0 = os.path.join(base_path, "instr_mem_A.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    instructions = []
    addresses = []
    used_tags = set()
    fixed_set = random.randint(0, 0xF)
    n = random.randint(1, 4)
    tags_list = []
    for _ in range(n):
        while True:
            tag = random.randint(0, 0x3F)
            if tag not in used_tags:
                used_tags.add(tag)
                tags_list.append(tag)
                break
        offset = random.choice(range(0, 64, 4))
        addr = (tag << 10) | (fixed_set << 6) | offset
        addr_hex = to_hex32(addr)
        instructions.append(f"read\t{addr_hex}")
        addresses.append(addr)
    tag = random.choice(tags_list)
    offset = random.choice(range(0, 64, 4))
    addr = (tag << 10) | (fixed_set << 6) | offset
    addr_hex = to_hex32(addr)
    data = to_hex32(random.getrandbits(32))
    instructions.append(f"write\t{addr_hex}\t{data}")
    addresses.append(addr)
    with open(path_0, "w") as f:
        for line in instructions: f.write(line + "\n")
    base_written = set()
    with open(path_mem, "w") as f:
        for addr in addresses:
            base_addr = addr & ~0x3F
            if base_addr in base_written: continue
            base_written.add(base_addr)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(base_addr)] + words) + "\n")
    print("testcase 5 created")
def testcase_6():
    def to_hex32(value): return f"0x{value:08X}"
    base_path = "cache_testcase/testcase_6/"
    os.makedirs(base_path, exist_ok=True)
    path_0 = os.path.join(base_path, "instr_mem_A.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    instructions = []
    addresses = []
    used_tags = set()
    fixed_set = random.randint(0, 0xF)
    for _ in range(3):
        while True:
            tag = random.randint(0, 0x3F)
            if tag not in used_tags:
                used_tags.add(tag)
                break
        offset = random.choice(range(0, 64, 4))
        addr = (tag << 10) | (fixed_set << 6) | offset
        addr_hex = to_hex32(addr)
        instructions.append(f"read\t{addr_hex}")
        addresses.append(addr)
    while True:
        tag = random.randint(0, 0x3F)
        if tag not in used_tags:
            used_tags.add(tag)
            break
    offset = random.choice(range(0, 64, 4))
    addr = (tag << 10) | (fixed_set << 6) | offset
    addr_hex = to_hex32(addr)
    data = to_hex32(random.getrandbits(32))
    instructions.append(f"write\t{addr_hex}\t{data}")
    addresses.append(addr)
    with open(path_0, "w") as f:
        for line in instructions: f.write(line + "\n")
    base_written = set()
    with open(path_mem, "w") as f:
        for addr in addresses:
            base_addr = addr & ~0x3F
            if base_addr in base_written: continue
            base_written.add(base_addr)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(base_addr)] + words) + "\n")
    print("testcase 6 created")
def testcase_7():
    def to_hex32(value): return f"0x{value:08X}"
    base_path = "cache_testcase/testcase_7/"
    os.makedirs(base_path, exist_ok=True)
    path_0 = os.path.join(base_path, "instr_mem_A.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    instructions = []
    addresses = []
    used_tags = set()
    fixed_set = random.randint(0, 0xF)
    for _ in range(4):
        while True:
            tag = random.randint(0, 0x3F)
            if tag not in used_tags:
                used_tags.add(tag)
                break
        offset = random.choice(range(0, 64, 4))
        addr = (tag << 10) | (fixed_set << 6) | offset
        addr_hex = to_hex32(addr)
        instructions.append(f"read\t{addr_hex}")
        addresses.append(addr)
    while True:
        tag = random.randint(0, 0x3F)
        if tag not in used_tags:
            used_tags.add(tag)
            break
    offset = random.choice(range(0, 64, 4))
    addr = (tag << 10) | (fixed_set << 6) | offset
    addr_hex = to_hex32(addr)
    data = to_hex32(random.getrandbits(32))
    instructions.append(f"write\t{addr_hex}\t{data}")
    addresses.append(addr)
    with open(path_0, "w") as f:
        for line in instructions: f.write(line + "\n")
    base_written = set()
    with open(path_mem, "w") as f:
        for addr in addresses:
            base_addr = addr & ~0x3F
            if base_addr in base_written: continue
            base_written.add(base_addr)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(base_addr)] + words) + "\n")
    print("testcase 7 created")
def testcase_8():
    def to_hex32(value): return f"0x{value:08X}"
    base_path = "cache_testcase/testcase_8/"
    os.makedirs(base_path, exist_ok=True)
    path_0 = os.path.join(base_path, "instr_mem_A.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    instructions = []
    addresses = []
    used_tags = set()
    fixed_set = random.randint(0, 0xF)
    for _ in range(5):
        while True:
            tag = random.randint(0, 0x3F)
            if tag not in used_tags:
                used_tags.add(tag)
                break
        offset = random.choice(range(0, 64, 4))
        addr = (tag << 10) | (fixed_set << 6) | offset
        addr_hex = to_hex32(addr)
        data = to_hex32(random.getrandbits(32))
        instructions.append(f"write\t{addr_hex}\t{data}")
        addresses.append(addr)
    with open(path_0, "w") as f:
        for line in instructions: f.write(line + "\n")
    base_written = set()
    with open(path_mem, "w") as f:
        for addr in addresses:
            base_addr = addr & ~0x3F
            if base_addr in base_written: continue
            base_written.add(base_addr)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(base_addr)] + words) + "\n")
    print("testcase 8 created")
def testcase_9():
    def to_hex32(value): return f"0x{value:08X}"
    base_path = "cache_testcase/testcase_9/"
    os.makedirs(base_path, exist_ok=True)
    path_0 = os.path.join(base_path, "instr_mem_A.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    instructions = []
    addresses = []
    used_tags = set()
    fixed_set = random.randint(0, 0xF)
    n = random.randint(1, 4)
    tags_list = []
    for _ in range(n):
        while True:
            tag = random.randint(0, 0x3F)
            if tag not in used_tags:
                used_tags.add(tag)
                tags_list.append(tag)
                break
        offset = random.choice(range(0, 64, 4))
        addr = (tag << 10) | (fixed_set << 6) | offset
        addr_hex = to_hex32(addr)
        instructions.append(f"read\t{addr_hex}")
        addresses.append(addr)
    tag = random.choice(tags_list)
    offset1 = random.choice(range(0, 64, 4))
    addr1 = (tag << 10) | (fixed_set << 6) | offset1
    addr_hex1 = to_hex32(addr1)
    instructions.append(f"read\t{addr_hex1}")
    addresses.append(addr1)
    offset2 = random.choice(range(0, 64, 4))
    addr2 = (tag << 10) | (fixed_set << 6) | offset2
    addr_hex2 = to_hex32(addr2)
    data = to_hex32(random.getrandbits(32))
    instructions.append(f"write\t{addr_hex2}\t{data}")
    addresses.append(addr2)
    with open(path_0, "w") as f:
        for line in instructions: f.write(line + "\n")
    base_written = set()
    with open(path_mem, "w") as f:
        for addr in addresses:
            base_addr = addr & ~0x3F
            if base_addr in base_written: continue
            base_written.add(base_addr)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(base_addr)] + words) + "\n")
    print("testcase 9 created")
def testcase_10():
    def to_hex32(value): return f"0x{value:08X}"
    base_path = "cache_testcase/testcase_10/"
    os.makedirs(base_path, exist_ok=True)
    path_0 = os.path.join(base_path, "instr_mem_A.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    instructions = []
    addresses = []
    used_tags = set()
    fixed_set = random.randint(0, 0xF)
    last_tag = None
    for i in range(4):
        while True:
            tag = random.randint(0, 0x3F)
            if tag not in used_tags:
                used_tags.add(tag)
                break
        last_tag = tag
        offset = random.choice(range(0, 64, 4))
        addr = (tag << 10) | (fixed_set << 6) | offset
        addr_hex = to_hex32(addr)
        instructions.append(f"read\t{addr_hex}")
        addresses.append(addr)
    offset = random.choice(range(0, 64, 4))
    addr = (last_tag << 10) | (fixed_set << 6) | offset
    addr_hex = to_hex32(addr)
    data = to_hex32(random.getrandbits(32))
    instructions.append(f"write\t{addr_hex}\t{data}")
    addresses.append(addr)
    with open(path_0, "w") as f:
        for line in instructions: f.write(line + "\n")
    base_written = set()
    with open(path_mem, "w") as f:
        for addr in addresses:
            base_addr = addr & ~0x3F
            if base_addr in base_written: continue
            base_written.add(base_addr)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(base_addr)] + words) + "\n")
    print("testcase 10 created")
def testcase_11():
    def to_hex32(value): return f"0x{value:08X}"
    base_path = "cache_testcase/testcase_11/"
    os.makedirs(base_path, exist_ok=True)
    path_0 = os.path.join(base_path, "instr_mem_A.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    instructions = []
    addresses = []
    used_tags = set()
    fixed_set = random.randint(0, 0xF)
    last_tag = None
    for i in range(5):
        while True:
            tag = random.randint(0, 0x3F)
            if tag not in used_tags:
                used_tags.add(tag)
                break
        last_tag = tag
        offset = random.choice(range(0, 64, 4))
        addr = (tag << 10) | (fixed_set << 6) | offset
        addr_hex = to_hex32(addr)
        instructions.append(f"read\t{addr_hex}")
        addresses.append(addr)
    offset = random.choice(range(0, 64, 4))
    addr = (last_tag << 10) | (fixed_set << 6) | offset
    addr_hex = to_hex32(addr)
    data = to_hex32(random.getrandbits(32))
    instructions.append(f"write\t{addr_hex}\t{data}")
    addresses.append(addr)
    with open(path_0, "w") as f:
        for line in instructions: f.write(line + "\n")
    base_written = set()
    with open(path_mem, "w") as f:
        for addr in addresses:
            base_addr = addr & ~0x3F
            if base_addr in base_written: continue
            base_written.add(base_addr)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(base_addr)] + words) + "\n")
    print("testcase 11 created")
def testcase_12():
    def to_hex32(value): return f"0x{value:08X}"
    base_path = "cache_testcase/testcase_12/"
    os.makedirs(base_path, exist_ok=True)
    path_0 = os.path.join(base_path, "instr_mem_A.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    instructions = []
    addresses = []
    used_tags = set()
    fixed_set = random.randint(0, 0xF)
    for _ in range(4):
        while True:
            tag = random.randint(0, 0x3F)
            if tag not in used_tags:
                used_tags.add(tag)
                break
        offset = random.choice(range(0, 64, 4))
        addr = (tag << 10) | (fixed_set << 6) | offset
        addr_hex = to_hex32(addr)
        data = to_hex32(random.getrandbits(32))
        instructions.append(f"write\t{addr_hex}\t{data}")
        addresses.append(addr)
    while True:
        tag = random.randint(0, 0x3F)
        if tag not in used_tags:
            used_tags.add(tag)
            break
    offset1 = random.choice(range(0, 64, 4))
    addr1 = (tag << 10) | (fixed_set << 6) | offset1
    addr_hex1 = to_hex32(addr1)
    instructions.append(f"read\t{addr_hex1}")
    addresses.append(addr1)
    offset2 = random.choice(range(0, 64, 4))
    addr2 = (tag << 10) | (fixed_set << 6) | offset2
    addr_hex2 = to_hex32(addr2)
    data2 = to_hex32(random.getrandbits(32))
    instructions.append(f"write\t{addr_hex2}\t{data2}")
    addresses.append(addr2)
    with open(path_0, "w") as f:
        for line in instructions: f.write(line + "\n")
    base_written = set()
    with open(path_mem, "w") as f:
        for addr in addresses:
            base_addr = addr & ~0x3F
            if base_addr in base_written: continue
            base_written.add(base_addr)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(base_addr)] + words) + "\n")
    print("testcase 12 created")
def testcase_13():
    def to_hex32(value): return f"0x{value:08X}"
    base_path = "cache_testcase/testcase_13/"
    os.makedirs(base_path, exist_ok=True)
    path_0 = os.path.join(base_path, "instr_mem_A.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    instructions = []
    addresses = []
    used_tags = set()
    fixed_set = random.randint(0, 0xF)
    n = random.randint(1, 4)
    tags_list = []
    for _ in range(n):
        while True:
            tag = random.randint(0, 0x3F)
            if tag not in used_tags:
                used_tags.add(tag)
                tags_list.append(tag)
                break
        offset = random.choice(range(0, 64, 4))
        addr = (tag << 10) | (fixed_set << 6) | offset
        addr_hex = to_hex32(addr)
        instructions.append(f"read\t{addr_hex}")
        addresses.append(addr)
    tag = random.choice(tags_list)
    offset_w = random.choice(range(0, 64, 4))
    addr_w = (tag << 10) | (fixed_set << 6) | offset_w
    addr_hex_w = to_hex32(addr_w)
    data_w = to_hex32(random.getrandbits(32))
    instructions.append(f"write\t{addr_hex_w}\t{data_w}")
    addresses.append(addr_w)
    offset_r = random.choice(range(0, 64, 4))
    addr_r = (tag << 10) | (fixed_set << 6) | offset_r
    addr_hex_r = to_hex32(addr_r)
    instructions.append(f"read\t{addr_hex_r}")
    addresses.append(addr_r)
    with open(path_0, "w") as f:
        for line in instructions: f.write(line + "\n")
    base_written = set()
    with open(path_mem, "w") as f:
        for addr in addresses:
            base_addr = addr & ~0x3F
            if base_addr in base_written: continue
            base_written.add(base_addr)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(base_addr)] + words) + "\n")
    print("testcase 13 created")
def testcase_14():
    def to_hex32(value): return f"0x{value:08X}"
    base_path = "cache_testcase/testcase_14/"
    os.makedirs(base_path, exist_ok=True)
    path_0 = os.path.join(base_path, "instr_mem_A.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    instructions = []
    addresses = []
    used_tags = set()
    fixed_set = random.randint(0, 0xF)
    for _ in range(3):
        while True:
            tag = random.randint(0, 0x3F)
            if tag not in used_tags:
                used_tags.add(tag)
                break
        offset = random.choice(range(0, 64, 4))
        addr = (tag << 10) | (fixed_set << 6) | offset
        addr_hex = to_hex32(addr)
        instructions.append(f"read\t{addr_hex}")
        addresses.append(addr)
    while True:
        tag = random.randint(0, 0x3F)
        if tag not in used_tags:
            used_tags.add(tag)
            break
    offset_w = random.choice(range(0, 64, 4))
    addr_w = (tag << 10) | (fixed_set << 6) | offset_w
    addr_hex_w = to_hex32(addr_w)
    data_w = to_hex32(random.getrandbits(32))
    instructions.append(f"write\t{addr_hex_w}\t{data_w}")
    addresses.append(addr_w)
    offset_r = random.choice(range(0, 64, 4))
    addr_r = (tag << 10) | (fixed_set << 6) | offset_r
    addr_hex_r = to_hex32(addr_r)
    instructions.append(f"read\t{addr_hex_r}")
    addresses.append(addr_r)
    with open(path_0, "w") as f:
        for line in instructions: f.write(line + "\n")
    base_written = set()
    with open(path_mem, "w") as f:
        for addr in addresses:
            base_addr = addr & ~0x3F
            if base_addr in base_written: continue
            base_written.add(base_addr)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(base_addr)] + words) + "\n")
    print("testcase 14 created")
def testcase_15():
    def to_hex32(value): return f"0x{value:08X}"
    base_path = "cache_testcase/testcase_15/"
    os.makedirs(base_path, exist_ok=True)
    path_0 = os.path.join(base_path, "instr_mem_A.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    instructions = []
    addresses = []
    used_tags = set()
    fixed_set = random.randint(0, 0xF)
    for _ in range(4):
        while True:
            tag = random.randint(0, 0x3F)
            if tag not in used_tags:
                used_tags.add(tag)
                break
        offset = random.choice(range(0, 64, 4))
        addr = (tag << 10) | (fixed_set << 6) | offset
        addr_hex = to_hex32(addr)
        instructions.append(f"read\t{addr_hex}")
        addresses.append(addr)
    while True:
        tag = random.randint(0, 0x3F)
        if tag not in used_tags:
            used_tags.add(tag)
            break
    offset_w = random.choice(range(0, 64, 4))
    addr_w = (tag << 10) | (fixed_set << 6) | offset_w
    addr_hex_w = to_hex32(addr_w)
    data_w = to_hex32(random.getrandbits(32))
    instructions.append(f"write\t{addr_hex_w}\t{data_w}")
    addresses.append(addr_w)
    offset_r = random.choice(range(0, 64, 4))
    addr_r = (tag << 10) | (fixed_set << 6) | offset_r
    addr_hex_r = to_hex32(addr_r)
    instructions.append(f"read\t{addr_hex_r}")
    addresses.append(addr_r)
    with open(path_0, "w") as f:
        for line in instructions: f.write(line + "\n")
    base_written = set()
    with open(path_mem, "w") as f:
        for addr in addresses:
            base_addr = addr & ~0x3F
            if base_addr in base_written: continue
            base_written.add(base_addr)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(base_addr)] + words) + "\n")
    print("testcase 15 created")
def testcase_16():
    def to_hex32(value): return f"0x{value:08X}"
    base_path = "cache_testcase/testcase_16/"
    os.makedirs(base_path, exist_ok=True)
    path_0 = os.path.join(base_path, "instr_mem_A.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    instructions = []
    addresses = []
    used_tags = set()
    fixed_set = random.randint(0, 0xF)
    for _ in range(5):
        while True:
            tag = random.randint(0, 0x3F)
            if tag not in used_tags:
                used_tags.add(tag)
                break
        offset = random.choice(range(0, 64, 4))
        addr = (tag << 10) | (fixed_set << 6) | offset
        addr_hex = to_hex32(addr)
        data = to_hex32(random.getrandbits(32))
        instructions.append(f"write\t{addr_hex}\t{data}")
        addresses.append(addr)
    last_tag = tag  # tag của lệnh write cuối cùng
    offset_r = random.choice(range(0, 64, 4))
    addr_r = (last_tag << 10) | (fixed_set << 6) | offset_r
    addr_hex_r = to_hex32(addr_r)
    instructions.append(f"read\t{addr_hex_r}")
    addresses.append(addr_r)
    with open(path_0, "w") as f:
        for line in instructions: f.write(line + "\n")
    base_written = set()
    with open(path_mem, "w") as f:
        for addr in addresses:
            base_addr = addr & ~0x3F
            if base_addr in base_written: continue
            base_written.add(base_addr)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(base_addr)] + words) + "\n")
    print("testcase 16 created")


def main():
    # Danh sách các hàm testcase
    list_testcases = [
        testcase_1, testcase_2, testcase_3, testcase_4, testcase_5, testcase_6, testcase_7, testcase_8,
        testcase_9, testcase_10, testcase_11, testcase_12, testcase_13, testcase_14, testcase_15, testcase_16,
    ]


    print("========== MENU TẠO TESTCASE ==========")
    print("1. Tạo tất cả 16 testcase")
    print("2. Tạo testcase cụ thể")

    choice = input("Nhập lựa chọn (1 hoặc 2): ")

    if choice == '1':
        # Gọi tuần tự tất cả các hàm testcase
        for func in list_testcases:
            func()
    elif choice == '2':
        # Yêu cầu người dùng nhập số testcase mong muốn
        tc_number = input("Nhập testcase muốn tạo (1-16): ")
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
