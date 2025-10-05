import os
import random
from inspect_testcase import *
# Hàm xử lý từng testcase trong nhóm 1.1
def testcase_1():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "moesi_testcase/testcase_1/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_shared(p, t, s, o): return (p << 16) | (t << 10) | (s << 6) | o

    shared_prefix = random.choice([0x0002, 0x0003])
    tag = random.randint(0, 0x3F)
    set_ = random.randint(0, 0xF)
    offset = random.choice(range(0, 64, 4))
    addr = make_shared(shared_prefix, tag, set_, offset)
    with open(path_A, "w") as f: pass
    with open(path_B, "w") as f:
        f.write(f"read\t{to_hex32(addr)}\n")

    base_addr = addr & ~0x3F
    with open(path_mem, "w") as f:
        words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
        f.write("\t".join([to_hex32(base_addr)] + words) + "\n")

    print("testcase 1 created")
def testcase_2():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "moesi_testcase/testcase_2/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_shared(p, t, s, o): return (p << 16) | (t << 10) | (s << 6) | o

    shared_prefix = random.choice([0x0002, 0x0003])
    tag = random.randint(0, 0x3F)
    set_ = random.randint(0, 0xF)
    offset = random.choice(range(0, 64, 4))
    addr = make_shared(shared_prefix, tag, set_, offset)
    with open(path_B, "w") as f: pass
    with open(path_A, "w") as f:
        f.write(f"read\t{to_hex32(addr)}\n")

    base_addr = addr & ~0x3F
    with open(path_mem, "w") as f:
        words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
        f.write("\t".join([to_hex32(base_addr)] + words) + "\n")

    print("testcase 2 created")
def testcase_3():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "moesi_testcase/testcase_3/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_shared(p, t, s, o): return (p << 16) | (t << 10) | (s << 6) | o

    shared_prefix = random.choice([0x0002, 0x0003])
    tag = random.randint(0, 0x3F)
    set_ = random.randint(0, 0xF)
    offset = random.choice(range(0, 64, 4))
    addr = make_shared(shared_prefix, tag, set_, offset)
    data = to_hex32(random.getrandbits(32))
    with open(path_A, "w") as f: pass
    with open(path_B, "w") as f:
        f.write(f"write\t{to_hex32(addr)}\t{data}\n")

    base_addr = addr & ~0x3F
    with open(path_mem, "w") as f:
        words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
        f.write("\t".join([to_hex32(base_addr)] + words) + "\n")

    print("testcase 3 created")
def testcase_4():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "moesi_testcase/testcase_4/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_shared(p, t, s, o): return (p << 16) | (t << 10) | (s << 6) | o

    shared_prefix = random.choice([0x0002, 0x0003])
    tag = random.randint(0, 0x3F)
    set_ = random.randint(0, 0xF)
    offset = random.choice(range(0, 64, 4))
    addr = make_shared(shared_prefix, tag, set_, offset)
    data = to_hex32(random.getrandbits(32))
    with open(path_B, "w") as f: pass
    with open(path_A, "w") as f:
        f.write(f"write\t{to_hex32(addr)}\t{data}\n")

    base_addr = addr & ~0x3F
    with open(path_mem, "w") as f:
        words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
        f.write("\t".join([to_hex32(base_addr)] + words) + "\n")

    print("testcase 4 created")
def testcase_5():
    def to_hex32(value): return f"0x{value:08X}"
    base_path = "moesi_testcase/testcase_5/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")

    def make_shared_addr(prefix, tag, set_, offset):
        addr_low = (tag << 10) | (set_ << 6) | offset
        return (prefix << 16) | addr_low

    instructions_A = []
    instructions_B = []
    addresses = []
    used_tags = set()
    fixed_set = random.randint(0, 0xF)
    shared_prefix = random.choice([0x0002, 0x0003])  # vùng chia sẻ chung

    # instr_mem_A.mem - 1 lệnh read
    while True:
        tag_A = random.randint(0, 0x3F)
        if tag_A not in used_tags:
            used_tags.add(tag_A)
            break
    offset_A = random.choice(range(0, 64, 4))
    addr_A = make_shared_addr(shared_prefix, tag_A, fixed_set, offset_A)
    instructions_A.append(f"read\t{to_hex32(addr_A)}")
    addresses.append(addr_A)

    # instr_mem_B.mem - 1 lệnh read/write (khác tag)
    while True:
        tag_B = random.randint(0, 0x3F)
        if tag_B not in used_tags:
            used_tags.add(tag_B)
            break
    offset_B1 = random.choice(range(0, 64, 4))
    addr_B1 = make_shared_addr(shared_prefix, tag_B, fixed_set, offset_B1)
    instr_type = random.choice(["read", "write"])
    if instr_type == "read":
        instructions_B.append(f"read\t{to_hex32(addr_B1)}")
    else:
        data1 = to_hex32(random.getrandbits(32))
        instructions_B.append(f"write\t{to_hex32(addr_B1)}\t{data1}")
    addresses.append(addr_B1)

    # instr_mem_B.mem - 1 write có cùng tag, set, prefix với addr_A
    offset_B2 = random.choice(range(0, 64, 4))
    addr_B2 = make_shared_addr(shared_prefix, tag_A, fixed_set, offset_B2)
    data2 = to_hex32(random.getrandbits(32))
    instructions_B.append(f"write\t{to_hex32(addr_B2)}\t{data2}")
    addresses.append(addr_B2)

    # Ghi instr_mem_A.mem
    with open(path_A, "w") as f:
        for line in instructions_A: f.write(line + "\n")

    # Ghi instr_mem_B.mem
    with open(path_B, "w") as f:
        for line in instructions_B: f.write(line + "\n")

    # Ghi main_memory_init.mem (loại trùng block)
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
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "moesi_testcase/testcase_6/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_shared(prefix, tag, set_, off): return (prefix << 16) | (tag << 10) | (set_ << 6) | off
    instr_A = []
    instr_B = []
    addrs = []
    used_tags = set()
    fixed_set = random.randint(0, 0xF)
    prefix = random.choice([0x0002, 0x0003])
    while True:
        tag_B = random.randint(0, 0x3F)
        if tag_B not in used_tags:
            used_tags.add(tag_B)
            break
    off_B = random.choice(range(0, 64, 4))
    addr_B = make_shared(prefix, tag_B, fixed_set, off_B)
    instr_B.append(f"read\t{to_hex32(addr_B)}")
    addrs.append(addr_B)
    while True:
        tag_A = random.randint(0, 0x3F)
        if tag_A not in used_tags:
            used_tags.add(tag_A)
            break
    off_A1 = random.choice(range(0, 64, 4))
    addr_A1 = make_shared(prefix, tag_A, fixed_set, off_A1)
    if random.choice([True, False]):
        instr_A.append(f"read\t{to_hex32(addr_A1)}")
    else:
        data = to_hex32(random.getrandbits(32))
        instr_A.append(f"write\t{to_hex32(addr_A1)}\t{data}")
    addrs.append(addr_A1)
    off_A2 = random.choice(range(0, 64, 4))
    addr_A2 = make_shared(prefix, tag_B, fixed_set, off_A2)
    data2 = to_hex32(random.getrandbits(32))
    instr_A.append(f"write\t{to_hex32(addr_A2)}\t{data2}")
    addrs.append(addr_A2)
    with open(path_A, "w") as f:
        for l in instr_A: f.write(l + "\n")
    with open(path_B, "w") as f:
        for l in instr_B: f.write(l + "\n")
    written = set()
    with open(path_mem, "w") as f:
        for a in addrs:
            b = a & ~0x3F
            if b in written: continue
            written.add(b)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(b)] + words) + "\n")
    print("testcase 6 created")
def testcase_7():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "moesi_testcase/testcase_7/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_shared(p, t, s, o): return (p << 16) | (t << 10) | (s << 6) | o

    prefix = random.choice([0x0002, 0x0003])
    tag = random.randint(0, 0x3F)
    set_ = random.randint(0, 0xF)
    offsets = random.sample(range(0, 64, 4), 2)

    instructions = []
    addresses = []

    for offset in offsets:
        addr = make_shared(prefix, tag, set_, offset)
        data = to_hex32(random.getrandbits(32))
        instructions.append(f"write\t{to_hex32(addr)}\t{data}")
        addresses.append(addr)
    with open(path_B, "w") as f:
        pass
    with open(path_A, "w") as f:
        for line in instructions:
            f.write(line + "\n")

    base_written = set()
    with open(path_mem, "w") as f:
        for addr in addresses:
            base = addr & ~0x3F
            if base in base_written: continue
            base_written.add(base)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(base)] + words) + "\n")

    print("testcase 7 created")
def testcase_8():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "moesi_testcase/testcase_8/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_shared(p, t, s, o): return (p << 16) | (t << 10) | (s << 6) | o

    shared_prefix = random.choice([0x0002, 0x0003])
    tag = random.randint(0, 0x3F)
    set_A = random.randint(0, 0xF)
    offset_A = random.choice(range(0, 64, 4))
    addr_base = make_shared(shared_prefix, tag, set_A, offset_A)

    # memA: 2 read + 1 write (same tag, set, prefix)
    instr_A = [
        f"read\t{to_hex32(addr_base)}",
        f"read\t{to_hex32(addr_base)}",
        f"write\t{to_hex32(addr_base)}\t{to_hex32(random.getrandbits(32))}"
    ]

    # memB:
    #   1st read with different set
    #   2nd read with same addr as addr_base
    set_B = (set_A + 1) % 16
    offset_B = random.choice(range(0, 64, 4))
    addr_diff = make_shared(shared_prefix, tag, set_B, offset_B)

    instr_B = [
        f"read\t{to_hex32(addr_diff)}",
        f"read\t{to_hex32(addr_base)}"
    ]

    all_addresses = [addr_base, addr_diff]

    with open(path_A, "w") as f:
        for line in instr_A: f.write(line + "\n")
    with open(path_B, "w") as f:
        for line in instr_B: f.write(line + "\n")

    with open(path_mem, "w") as f:
        written_blocks = set()
        for addr in all_addresses:
            block_addr = addr & ~0x3F
            if block_addr in written_blocks: continue
            written_blocks.add(block_addr)
            data = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(block_addr)] + data) + "\n")

    print("testcase 8 created")
def testcase_9():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "moesi_testcase/testcase_9/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_shared(prefix, tag, set_, off): return (prefix << 16) | (tag << 10) | (set_ << 6) | off
    instr_A = []
    instr_B = []
    addrs = []
    tag = random.randint(0, 0x3F)
    set_ = random.randint(0, 0xF)
    prefix = random.choice([0x0002, 0x0003])
    off1 = random.choice(range(0, 64, 4))
    addr1 = make_shared(prefix, tag, set_, off1)
    instr_A.append(f"read\t{to_hex32(addr1)}")
    addrs.append(addr1)
    off2 = random.choice(range(0, 64, 4))
    addr2 = make_shared(prefix, tag, set_, off2)
    data = to_hex32(random.getrandbits(32))
    instr_A.append(f"write\t{to_hex32(addr2)}\t{data}")
    addrs.append(addr2)
    with open(path_A, "w") as f:
        for l in instr_A: f.write(l + "\n")
    with open(path_B, "w") as f:
        pass
    written = set()
    with open(path_mem, "w") as f:
        for a in addrs:
            b = a & ~0x3F
            if b in written: continue
            written.add(b)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(b)] + words) + "\n")
    print("testcase 9 created")
def testcase_10():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "moesi_testcase/testcase_10/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_shared(prefix, tag, set_, off): return (prefix << 16) | (tag << 10) | (set_ << 6) | off
    instr_A = []
    instr_B = []
    addrs = []
    tag = random.randint(0, 0x3F)
    set_ = random.randint(0, 0xF)
    prefix = random.choice([0x0002, 0x0003])
    off1 = random.choice(range(0, 64, 4))
    addr1 = make_shared(prefix, tag, set_, off1)
    instr_B.append(f"read\t{to_hex32(addr1)}")
    addrs.append(addr1)
    off2 = random.choice(range(0, 64, 4))
    addr2 = make_shared(prefix, tag, set_, off2)
    data = to_hex32(random.getrandbits(32))
    instr_B.append(f"write\t{to_hex32(addr2)}\t{data}")
    addrs.append(addr2)
    with open(path_A, "w") as f: pass
    with open(path_B, "w") as f:
        for l in instr_B: f.write(l + "\n")
    written = set()
    with open(path_mem, "w") as f:
        for a in addrs:
            b = a & ~0x3F
            if b in written: continue
            written.add(b)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(b)] + words) + "\n")
    print("testcase 10 created")
def testcase_11():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "moesi_testcase/testcase_11/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_shared(prefix, tag, set_, off): return (prefix << 16) | (tag << 10) | (set_ << 6) | off
    instr_A = []
    instr_B = []
    addrs = []
    tag = random.randint(0, 0x3F)
    set_ = random.randint(0, 0xF)
    prefix = random.choice([0x0002, 0x0003])
    off_B = random.choice(range(0, 64, 4))
    addr_B = make_shared(prefix, tag, set_, off_B)
    instr_B.append(f"read\t{to_hex32(addr_B)}")
    addrs.append(addr_B)
    while True:
        tag_A = random.randint(0, 0x3F)
        if tag_A != tag: break
    off_A1 = random.choice(range(0, 64, 4))
    addr_A1 = make_shared(prefix, tag_A, set_, off_A1)
    if random.choice([True, False]):
        instr_A.append(f"read\t{to_hex32(addr_A1)}")
    else:
        data1 = to_hex32(random.getrandbits(32))
        instr_A.append(f"write\t{to_hex32(addr_A1)}\t{data1}")
    addrs.append(addr_A1)
    off_A2 = random.choice(range(0, 64, 4))
    addr_A2 = make_shared(prefix, tag, set_, off_A2)
    instr_A.append(f"read\t{to_hex32(addr_A2)}")
    addrs.append(addr_A2)
    with open(path_A, "w") as f:
        for l in instr_A: f.write(l + "\n")
    with open(path_B, "w") as f:
        for l in instr_B: f.write(l + "\n")
    written = set()
    with open(path_mem, "w") as f:
        for a in addrs:
            b = a & ~0x3F
            if b in written: continue
            written.add(b)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(b)] + words) + "\n")
    print("testcase 11 created")
def testcase_12():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "moesi_testcase/testcase_12/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_shared(prefix, tag, set_, off): return (prefix << 16) | (tag << 10) | (set_ << 6) | off
    instr_A = []
    instr_B = []
    addrs = []
    tag = random.randint(0, 0x3F)
    set_ = random.randint(0, 0xF)
    prefix = random.choice([0x0002, 0x0003])
    off_A = random.choice(range(0, 64, 4))
    addr_A = make_shared(prefix, tag, set_, off_A)
    instr_A.append(f"read\t{to_hex32(addr_A)}")
    addrs.append(addr_A)
    while True:
        tag_B = random.randint(0, 0x3F)
        if tag_B != tag: break
    off_B1 = random.choice(range(0, 64, 4))
    addr_B1 = make_shared(prefix, tag_B, set_, off_B1)
    if random.choice([True, False]):
        instr_B.append(f"read\t{to_hex32(addr_B1)}")
    else:
        data1 = to_hex32(random.getrandbits(32))
        instr_B.append(f"write\t{to_hex32(addr_B1)}\t{data1}")
    addrs.append(addr_B1)
    off_B2 = random.choice(range(0, 64, 4))
    addr_B2 = make_shared(prefix, tag, set_, off_B2)
    instr_B.append(f"read\t{to_hex32(addr_B2)}")
    addrs.append(addr_B2)
    with open(path_A, "w") as f:
        for l in instr_A: f.write(l + "\n")
    with open(path_B, "w") as f:
        for l in instr_B: f.write(l + "\n")
    written = set()
    with open(path_mem, "w") as f:
        for a in addrs:
            b = a & ~0x3F
            if b in written: continue
            written.add(b)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(b)] + words) + "\n")
    print("testcase 12 created")
def testcase_13():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "moesi_testcase/testcase_13/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_addr(prefix, tag, set_, offset): return (prefix << 16) | (tag << 10) | (set_ << 6) | offset

    shared_prefix = random.choice([0x0002, 0x0003])
    tag = random.randint(0, 0x3F)
    set_ = random.randint(0, 0xF)
    offset = random.choice(range(0, 64, 4))
    addr_base = make_addr(shared_prefix, tag, set_, offset)

    instr_B = [
        f"read\t{to_hex32(addr_base)}",
        f"write\t{to_hex32(addr_base)}\t{to_hex32(random.getrandbits(32))}"
    ]

    all_addrs = {addr_base}
    used_sets_B = {set_}

    # 5 random reads with different sets
    for _ in range(5):
        while True:
            s = random.randint(0, 0xF)
            if s not in used_sets_B:
                used_sets_B.add(s)
                break
        t = random.randint(0, 0x3F)
        o = random.choice(range(0, 64, 4))
        addr = make_addr(shared_prefix, t, s, o)
        instr_B.append(f"read\t{to_hex32(addr)}")
        all_addrs.add(addr)

    # Read again with same addr_base
    instr_B.append(f"read\t{to_hex32(addr_base)}")

    # mem A
    instr_A = []
    used_sets_A = {set_}
    for _ in range(3):
        while True:
            s = random.randint(0, 0xF)
            if s not in used_sets_A:
                used_sets_A.add(s)
                break
        t = random.randint(0, 0x3F)
        o = random.choice(range(0, 64, 4))
        addr = make_addr(shared_prefix, t, s, o)
        instr_A.append(f"read\t{to_hex32(addr)}")
        all_addrs.add(addr)

    # Final read same addr as addr_base
    instr_A.append(f"read\t{to_hex32(addr_base)}")

    with open(path_A, "w") as f:
        for line in instr_A: f.write(line + "\n")
    with open(path_B, "w") as f:
        for line in instr_B: f.write(line + "\n")

    with open(path_mem, "w") as f:
        written = set()
        for addr in all_addrs:
            block = addr & ~0x3F
            if block in written: continue
            written.add(block)
            data = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(block)] + data) + "\n")

    print("testcase 13 created")

def testcase_14():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "moesi_testcase/testcase_14/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_addr(prefix, tag, set_, offset): return (prefix << 16) | (tag << 10) | (set_ << 6) | offset

    shared_prefix = random.choice([0x0002, 0x0003])
    tag = random.randint(0, 0x3F)
    set_ = random.randint(0, 0xF)
    offset = random.choice(range(0, 64, 4))
    addr_base = make_addr(shared_prefix, tag, set_, offset)

    instr_A = [
        f"read\t{to_hex32(addr_base)}",
        f"write\t{to_hex32(addr_base)}\t{to_hex32(random.getrandbits(32))}"
    ]

    all_addrs = {addr_base}
    used_sets_A = {set_}

    for _ in range(5):
        while True:
            s = random.randint(0, 0xF)
            if s not in used_sets_A:
                used_sets_A.add(s)
                break
        t = random.randint(0, 0x3F)
        o = random.choice(range(0, 64, 4))
        addr = make_addr(shared_prefix, t, s, o)
        instr_A.append(f"read\t{to_hex32(addr)}")
        all_addrs.add(addr)

    instr_A.append(f"read\t{to_hex32(addr_base)}")

    instr_B = []
    used_sets_B = {set_}
    for _ in range(3):
        while True:
            s = random.randint(0, 0xF)
            if s not in used_sets_B:
                used_sets_B.add(s)
                break
        t = random.randint(0, 0x3F)
        o = random.choice(range(0, 64, 4))
        addr = make_addr(shared_prefix, t, s, o)
        instr_B.append(f"read\t{to_hex32(addr)}")
        all_addrs.add(addr)

    instr_B.append(f"read\t{to_hex32(addr_base)}")

    with open(path_A, "w") as f:
        for line in instr_A: f.write(line + "\n")
    with open(path_B, "w") as f:
        for line in instr_B: f.write(line + "\n")

    with open(path_mem, "w") as f:
        written = set()
        for addr in all_addrs:
            base = addr & ~0x3F
            if base in written: continue
            written.add(base)
            data = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(base)] + data) + "\n")

    print("testcase 14 created")

def testcase_15():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "moesi_testcase/testcase_15/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_shared(p, t, s, o): return (p << 16) | (t << 10) | (s << 6) | o
    instr_A = []
    addrs = []
    tag = random.randint(0, 0x3F)
    set_ = random.randint(0, 0xF)
    prefix = random.choice([0x0002, 0x0003])
    off = random.choice(range(0, 64, 4))
    addr = make_shared(prefix, tag, set_, off)
    instr_A.append(f"read\t{to_hex32(addr)}")
    addrs.append(addr)
    with open(path_A, "w") as f:
        for l in instr_A: f.write(l + "\n")
    with open(path_B, "w") as f: pass
    written = set()
    with open(path_mem, "w") as f:
        for a in addrs:
            b = a & ~0x3F
            if b in written: continue
            written.add(b)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(b)] + words) + "\n")
    print("testcase 15 created")
def testcase_16():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "moesi_testcase/testcase_16/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_shared(p, t, s, o): return (p << 16) | (t << 10) | (s << 6) | o
    instr_B = []
    addrs = []
    tag = random.randint(0, 0x3F)
    set_ = random.randint(0, 0xF)
    prefix = random.choice([0x0002, 0x0003])
    off = random.choice(range(0, 64, 4))
    addr = make_shared(prefix, tag, set_, off)
    instr_B.append(f"read\t{to_hex32(addr)}")
    addrs.append(addr)
    with open(path_A, "w") as f: pass
    with open(path_B, "w") as f:
        for l in instr_B: f.write(l + "\n")
    written = set()
    with open(path_mem, "w") as f:
        for a in addrs:
            b = a & ~0x3F
            if b in written: continue
            written.add(b)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(b)] + words) + "\n")
    print("testcase 16 created")
def testcase_17():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "moesi_testcase/testcase_17/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_shared(p, t, s, o): return (p << 16) | (t << 10) | (s << 6) | o
    instr_A = []
    addrs = []
    tag = random.randint(0, 0x3F)
    set_ = random.randint(0, 0xF)
    prefix = random.choice([0x0002, 0x0003])
    off1 = random.choice(range(0, 64, 4))
    addr1 = make_shared(prefix, tag, set_, off1)
    instr_A.append(f"read\t{to_hex32(addr1)}")
    addrs.append(addr1)
    off2 = random.choice(range(0, 64, 4))
    addr2 = make_shared(prefix, tag, set_, off2)
    instr_A.append(f"read\t{to_hex32(addr2)}")
    addrs.append(addr2)
    with open(path_A, "w") as f:
        for l in instr_A: f.write(l + "\n")
    with open(path_B, "w") as f: pass
    written = set()
    with open(path_mem, "w") as f:
        for a in addrs:
            b = a & ~0x3F
            if b in written: continue
            written.add(b)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(b)] + words) + "\n")
    print("testcase 17 created")
def testcase_18():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "moesi_testcase/testcase_18/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_shared(p, t, s, o): return (p << 16) | (t << 10) | (s << 6) | o
    instr_B = []
    addrs = []
    tag = random.randint(0, 0x3F)
    set_ = random.randint(0, 0xF)
    prefix = random.choice([0x0002, 0x0003])
    off1 = random.choice(range(0, 64, 4))
    addr1 = make_shared(prefix, tag, set_, off1)
    instr_B.append(f"read\t{to_hex32(addr1)}")
    addrs.append(addr1)
    off2 = random.choice(range(0, 64, 4))
    addr2 = make_shared(prefix, tag, set_, off2)
    instr_B.append(f"read\t{to_hex32(addr2)}")
    addrs.append(addr2)
    with open(path_A, "w") as f: pass
    with open(path_B, "w") as f:
        for l in instr_B: f.write(l + "\n")
    written = set()
    with open(path_mem, "w") as f:
        for a in addrs:
            b = a & ~0x3F
            if b in written: continue
            written.add(b)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(b)] + words) + "\n")
    print("testcase 18 created")
def testcase_19():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "moesi_testcase/testcase_19/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_shared(p, t, s, o): return (p << 16) | (t << 10) | (s << 6) | o
    instr_A = []
    instr_B = []
    addrs = []
    tag = random.randint(0, 0x3F)
    set_ = random.randint(0, 0xF)
    prefix = random.choice([0x0002, 0x0003])
    off1 = random.choice(range(0, 64, 4))
    addr_A1 = make_shared(prefix, tag, set_, off1)
    instr_A.append(f"read\t{to_hex32(addr_A1)}")
    addrs.append(addr_A1)
    off2 = random.choice(range(0, 64, 4))
    addr_A2 = make_shared(prefix, tag, set_, off2)
    data_A2 = to_hex32(random.getrandbits(32))
    instr_A.append(f"write\t{to_hex32(addr_A2)}\t{data_A2}")
    addrs.append(addr_A2)
    for _ in range(2):
        t = random.randint(0, 0x3F)
        s = random.randint(0, 0xF)
        o = random.choice(range(0, 64, 4))
        a = make_shared(prefix, t, s, o)
        if random.choice([True, False]):
            instr_B.append(f"read\t{to_hex32(a)}")
        else:
            d = to_hex32(random.getrandbits(32))
            instr_B.append(f"write\t{to_hex32(a)}\t{d}")
        addrs.append(a)
    off_B = random.choice(range(0, 64, 4))
    addr_B = make_shared(prefix, tag, set_, off_B)
    instr_B.append(f"read\t{to_hex32(addr_B)}")
    addrs.append(addr_B)
    with open(path_A, "w") as f:
        for l in instr_A: f.write(l + "\n")
    with open(path_B, "w") as f:
        for l in instr_B: f.write(l + "\n")
    written = set()
    with open(path_mem, "w") as f:
        for a in addrs:
            b = a & ~0x3F
            if b in written: continue
            written.add(b)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(b)] + words) + "\n")
    print("testcase 19 created")
def testcase_20():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "moesi_testcase/testcase_20/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_shared(p, t, s, o): return (p << 16) | (t << 10) | (s << 6) | o
    instr_A = []
    instr_B = []
    addrs = []
    tag = random.randint(0, 0x3F)
    set_ = random.randint(0, 0xF)
    prefix = random.choice([0x0002, 0x0003])
    off1 = random.choice(range(0, 64, 4))
    addr_B1 = make_shared(prefix, tag, set_, off1)
    instr_B.append(f"read\t{to_hex32(addr_B1)}")
    addrs.append(addr_B1)
    off2 = random.choice(range(0, 64, 4))
    addr_B2 = make_shared(prefix, tag, set_, off2)
    data_B2 = to_hex32(random.getrandbits(32))
    instr_B.append(f"write\t{to_hex32(addr_B2)}\t{data_B2}")
    addrs.append(addr_B2)
    for _ in range(2):
        t = random.randint(0, 0x3F)
        s = random.randint(0, 0xF)
        o = random.choice(range(0, 64, 4))
        a = make_shared(prefix, t, s, o)
        if random.choice([True, False]):
            instr_A.append(f"read\t{to_hex32(a)}")
        else:
            d = to_hex32(random.getrandbits(32))
            instr_A.append(f"write\t{to_hex32(a)}\t{d}")
        addrs.append(a)
    off3 = random.choice(range(0, 64, 4))
    addr_A3 = make_shared(prefix, tag, set_, off3)
    instr_A.append(f"read\t{to_hex32(addr_A3)}")
    addrs.append(addr_A3)
    with open(path_A, "w") as f:
        for l in instr_A: f.write(l + "\n")
    with open(path_B, "w") as f:
        for l in instr_B: f.write(l + "\n")
    written = set()
    with open(path_mem, "w") as f:
        for a in addrs:
            b = a & ~0x3F
            if b in written: continue
            written.add(b)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(b)] + words) + "\n")
    print("testcase 20 created")


def main():
    # Danh sách các hàm testcase
    list_testcases = [
        testcase_1, testcase_2, testcase_3, testcase_4, testcase_5, testcase_6, testcase_7, testcase_8,
        testcase_9, testcase_10, testcase_11, testcase_12, testcase_13, testcase_14, testcase_15, testcase_16,
        testcase_17, testcase_18, testcase_19, testcase_20
    ]


    print("========== MENU TẠO TESTCASE ==========")
    print("1. Tạo tất cả 20 testcase")
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
                inspect_testcase(f"moesi_testcase/{list_testcases[tc_number - 1].__name__}")
            else:
                print("Số testcase không hợp lệ!")
        else:
            print("Vui lòng nhập số hợp lệ!")
    else:
        print("Lựa chọn không hợp lệ!")


if __name__ == "__main__":
    main()


