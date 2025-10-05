import os
import random
from inspect_testcase import *
# Hàm xử lý từng testcase trong nhóm 1.1
def testcase_1():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "subsystem_testcase/testcase_1/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_core0(t, s, o): return (0x0000 << 16) | (t << 10) | (s << 6) | o
    instr_A = []
    addrs = []
    used_tags = set()
    fixed_set = random.randint(0, 0xF)
    n = random.randint(1, 3)
    tag_list = []
    for _ in range(n):
        while True:
            tag = random.randint(0, 0x3F)
            if tag not in used_tags:
                used_tags.add(tag)
                tag_list.append(tag)
                break
        off = random.choice(range(0, 64, 4))
        addr = make_core0(tag, fixed_set, off)
        instr_A.append(f"read\t{to_hex32(addr)}")
        addrs.append(addr)
    tag_dup = random.choice(tag_list)
    off_dup = random.choice(range(0, 64, 4))
    addr_dup = make_core0(tag_dup, fixed_set, off_dup)
    instr_A.append(f"read\t{to_hex32(addr_dup)}")
    addrs.append(addr_dup)
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
    print("testcase 1 created")
def testcase_2():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "subsystem_testcase/testcase_2/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_core0(t, s, o): return (0x0000 << 16) | (t << 10) | (s << 6) | o
    instr_A = []
    addrs = []
    used_tags = set()
    fixed_set = random.randint(0, 0xF)
    n = random.randint(2, 4)
    for _ in range(n):
        while True:
            tag = random.randint(0, 0x3F)
            if tag not in used_tags:
                used_tags.add(tag)
                break
        off = random.choice(range(0, 64, 4))
        addr = make_core0(tag, fixed_set, off)
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
    print("testcase 2 created")
def testcase_3():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "subsystem_testcase/testcase_3/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_core0(t, s, o): return (0x0000 << 16) | (t << 10) | (s << 6) | o
    instr_A = []
    addrs = []
    used_tags = set()
    fixed_set = random.randint(0, 0xF)
    for _ in range(5):
        while True:
            tag = random.randint(0, 0x3F)
            if tag not in used_tags:
                used_tags.add(tag)
                break
        off = random.choice(range(0, 64, 4))
        addr = make_core0(tag, fixed_set, off)
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
    print("testcase 3 created")
def testcase_4():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "subsystem_testcase/testcase_4/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_core0(t, s, o): return (0x0000 << 16) | (t << 10) | (s << 6) | o
    instr_A = []
    addrs = []
    used_tags = set()
    fixed_set = random.randint(0, 0xF)
    for _ in range(4):
        while True:
            tag = random.randint(0, 0x3F)
            if tag not in used_tags:
                used_tags.add(tag)
                break
        off = random.choice(range(0, 64, 4))
        addr = make_core0(tag, fixed_set, off)
        data = to_hex32(random.getrandbits(32))
        instr_A.append(f"write\t{to_hex32(addr)}\t{data}")
        addrs.append(addr)
    while True:
        tag = random.randint(0, 0x3F)
        if tag not in used_tags:
            used_tags.add(tag)
            break
    off = random.choice(range(0, 64, 4))
    addr = make_core0(tag, fixed_set, off)
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
    print("testcase 4 created")
def testcase_5():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "subsystem_testcase/testcase_5/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_core0(t, s, o): return (0x0000 << 16) | (t << 10) | (s << 6) | o
    instr_A = []
    addrs = []
    used_tags = set()
    fixed_set = random.randint(0, 0xF)
    tag_list = []
    n = random.randint(1, 3)
    for _ in range(n):
        while True:
            tag = random.randint(0, 0x3F)
            if tag not in used_tags:
                used_tags.add(tag)
                tag_list.append(tag)
                break
        off = random.choice(range(0, 64, 4))
        addr = make_core0(tag, fixed_set, off)
        instr_A.append(f"read\t{to_hex32(addr)}")
        addrs.append(addr)
    tag_w = random.choice(tag_list)
    off_w = random.choice(range(0, 64, 4))
    addr_w = make_core0(tag_w, fixed_set, off_w)
    data = to_hex32(random.getrandbits(32))
    instr_A.append(f"write\t{to_hex32(addr_w)}\t{data}")
    addrs.append(addr_w)
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
    print("testcase 5 created")
def testcase_6():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "subsystem_testcase/testcase_6/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_core0(t, s, o): return (0x0000 << 16) | (t << 10) | (s << 6) | o
    instr_A = []
    addrs = []
    used_tags = set()
    fixed_set = random.randint(0, 0xF)
    n = random.randint(1, 3)
    for _ in range(n):
        while True:
            tag = random.randint(0, 0x3F)
            if tag not in used_tags:
                used_tags.add(tag)
                break
        off = random.choice(range(0, 64, 4))
        addr = make_core0(tag, fixed_set, off)
        instr_A.append(f"read\t{to_hex32(addr)}")
        addrs.append(addr)
    while True:
        tag_w = random.randint(0, 0x3F)
        if tag_w not in used_tags:
            used_tags.add(tag_w)
            break
    off_w = random.choice(range(0, 64, 4))
    addr_w = make_core0(tag_w, fixed_set, off_w)
    data = to_hex32(random.getrandbits(32))
    instr_A.append(f"write\t{to_hex32(addr_w)}\t{data}")
    addrs.append(addr_w)
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
    print("testcase 6 created")
def testcase_7():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "subsystem_testcase/testcase_7/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_core0(t, s, o): return (0x0000 << 16) | (t << 10) | (s << 6) | o
    instr_A = []
    addrs = []
    used_tags = set()
    fixed_set = random.randint(0, 0xF)
    for _ in range(4):
        while True:
            tag = random.randint(0, 0x3F)
            if tag not in used_tags:
                used_tags.add(tag)
                break
        off = random.choice(range(0, 64, 4))
        addr = make_core0(tag, fixed_set, off)
        instr_A.append(f"read\t{to_hex32(addr)}")
        addrs.append(addr)
    while True:
        tag_w = random.randint(0, 0x3F)
        if tag_w not in used_tags:
            used_tags.add(tag_w)
            break
    off_w = random.choice(range(0, 64, 4))
    addr_w = make_core0(tag_w, fixed_set, off_w)
    data = to_hex32(random.getrandbits(32))
    instr_A.append(f"write\t{to_hex32(addr_w)}\t{data}")
    addrs.append(addr_w)
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
    print("testcase 7 created")
def testcase_8():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "subsystem_testcase/testcase_8/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_core0(t, s, o): return (0x0000 << 16) | (t << 10) | (s << 6) | o
    instr_A = []
    addrs = []
    used_tags = set()
    fixed_set = random.randint(0, 0xF)
    for _ in range(5):
        while True:
            tag = random.randint(0, 0x3F)
            if tag not in used_tags:
                used_tags.add(tag)
                break
        off = random.choice(range(0, 64, 4))
        addr = make_core0(tag, fixed_set, off)
        data = to_hex32(random.getrandbits(32))
        instr_A.append(f"write\t{to_hex32(addr)}\t{data}")
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
    print("testcase 8 created")
def testcase_9():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "subsystem_testcase/testcase_9/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_core1(t, s, o): return (0x0001 << 16) | (t << 10) | (s << 6) | o
    instr_B = []
    addrs = []
    used_tags = set()
    fixed_set = random.randint(0, 0xF)
    tag_list = []
    n = random.randint(1, 3)
    for _ in range(n):
        while True:
            tag = random.randint(0, 0x3F)
            if tag not in used_tags:
                used_tags.add(tag)
                tag_list.append(tag)
                break
        off = random.choice(range(0, 64, 4))
        addr = make_core1(tag, fixed_set, off)
        instr_B.append(f"read\t{to_hex32(addr)}")
        addrs.append(addr)
    tag_dup = random.choice(tag_list)
    off_dup = random.choice(range(0, 64, 4))
    addr_dup = make_core1(tag_dup, fixed_set, off_dup)
    instr_B.append(f"read\t{to_hex32(addr_dup)}")
    addrs.append(addr_dup)
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
    print("testcase 9 created")
def testcase_10():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "subsystem_testcase/testcase_10/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_core1(t, s, o): return (0x0001 << 16) | (t << 10) | (s << 6) | o
    instr_B = []
    addrs = []
    used_tags = set()
    fixed_set = random.randint(0, 0xF)
    n = random.randint(2, 4)
    for _ in range(n):
        while True:
            tag = random.randint(0, 0x3F)
            if tag not in used_tags:
                used_tags.add(tag)
                break
        off = random.choice(range(0, 64, 4))
        addr = make_core1(tag, fixed_set, off)
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
    print("testcase 10 created")
def testcase_11():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "subsystem_testcase/testcase_11/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_core1(t, s, o): return (0x0001 << 16) | (t << 10) | (s << 6) | o
    instr_B = []
    addrs = []
    used_tags = set()
    fixed_set = random.randint(0, 0xF)
    for _ in range(5):
        while True:
            tag = random.randint(0, 0x3F)
            if tag not in used_tags:
                used_tags.add(tag)
                break
        off = random.choice(range(0, 64, 4))
        addr = make_core1(tag, fixed_set, off)
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
    print("testcase 11 created")
def testcase_12():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "subsystem_testcase/testcase_12/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_core1(t, s, o): return (0x0001 << 16) | (t << 10) | (s << 6) | o
    instr_B = []
    addrs = []
    used_tags = set()
    fixed_set = random.randint(0, 0xF)
    for _ in range(4):
        while True:
            tag = random.randint(0, 0x3F)
            if tag not in used_tags:
                used_tags.add(tag)
                break
        off = random.choice(range(0, 64, 4))
        addr = make_core1(tag, fixed_set, off)
        data = to_hex32(random.getrandbits(32))
        instr_B.append(f"write\t{to_hex32(addr)}\t{data}")
        addrs.append(addr)
    while True:
        tag = random.randint(0, 0x3F)
        if tag not in used_tags:
            used_tags.add(tag)
            break
    off = random.choice(range(0, 64, 4))
    addr = make_core1(tag, fixed_set, off)
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
    print("testcase 12 created")
def testcase_13():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "subsystem_testcase/testcase_13/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_core1(t, s, o): return (0x0001 << 16) | (t << 10) | (s << 6) | o
    instr_B = []
    addrs = []
    used_tags = set()
    fixed_set = random.randint(0, 0xF)
    tag_list = []
    n = random.randint(1, 3)
    for _ in range(n):
        while True:
            tag = random.randint(0, 0x3F)
            if tag not in used_tags:
                used_tags.add(tag)
                tag_list.append(tag)
                break
        off = random.choice(range(0, 64, 4))
        addr = make_core1(tag, fixed_set, off)
        instr_B.append(f"read\t{to_hex32(addr)}")
        addrs.append(addr)
    tag_w = random.choice(tag_list)
    off_w = random.choice(range(0, 64, 4))
    addr_w = make_core1(tag_w, fixed_set, off_w)
    data_w = to_hex32(random.getrandbits(32))
    instr_B.append(f"write\t{to_hex32(addr_w)}\t{data_w}")
    addrs.append(addr_w)
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
    print("testcase 13 created")
def testcase_14():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "subsystem_testcase/testcase_14/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_core1(t, s, o): return (0x0001 << 16) | (t << 10) | (s << 6) | o
    instr_B = []
    addrs = []
    used_tags = set()
    fixed_set = random.randint(0, 0xF)
    n = random.randint(1, 3)
    for _ in range(n):
        while True:
            tag = random.randint(0, 0x3F)
            if tag not in used_tags:
                used_tags.add(tag)
                break
        off = random.choice(range(0, 64, 4))
        addr = make_core1(tag, fixed_set, off)
        instr_B.append(f"read\t{to_hex32(addr)}")
        addrs.append(addr)
    while True:
        tag_w = random.randint(0, 0x3F)
        if tag_w not in used_tags:
            used_tags.add(tag_w)
            break
    off_w = random.choice(range(0, 64, 4))
    addr_w = make_core1(tag_w, fixed_set, off_w)
    data_w = to_hex32(random.getrandbits(32))
    instr_B.append(f"write\t{to_hex32(addr_w)}\t{data_w}")
    addrs.append(addr_w)
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
    print("testcase 14 created")
def testcase_15():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "subsystem_testcase/testcase_15/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_core1(t, s, o): return (0x0001 << 16) | (t << 10) | (s << 6) | o
    instr_B = []
    addrs = []
    used_tags = set()
    fixed_set = random.randint(0, 0xF)
    for _ in range(4):
        while True:
            tag = random.randint(0, 0x3F)
            if tag not in used_tags:
                used_tags.add(tag)
                break
        off = random.choice(range(0, 64, 4))
        addr = make_core1(tag, fixed_set, off)
        instr_B.append(f"read\t{to_hex32(addr)}")
        addrs.append(addr)
    while True:
        tag_w = random.randint(0, 0x3F)
        if tag_w not in used_tags:
            used_tags.add(tag_w)
            break
    off_w = random.choice(range(0, 64, 4))
    addr_w = make_core1(tag_w, fixed_set, off_w)
    data = to_hex32(random.getrandbits(32))
    instr_B.append(f"write\t{to_hex32(addr_w)}\t{data}")
    addrs.append(addr_w)
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
    print("testcase 15 created")
def testcase_16():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "subsystem_testcase/testcase_16/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_core1(t, s, o): return (0x0001 << 16) | (t << 10) | (s << 6) | o
    instr_B = []
    addrs = []
    used_tags = set()
    fixed_set = random.randint(0, 0xF)
    for _ in range(5):
        while True:
            tag = random.randint(0, 0x3F)
            if tag not in used_tags:
                used_tags.add(tag)
                break
        off = random.choice(range(0, 64, 4))
        addr = make_core1(tag, fixed_set, off)
        data = to_hex32(random.getrandbits(32))
        instr_B.append(f"write\t{to_hex32(addr)}\t{data}")
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
    base_path = "subsystem_testcase/testcase_17/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_shared(p, t, s, o): return (p << 16) | (t << 10) | (s << 6) | o
    instr_A = []
    addrs = []
    used_tags = set()
    fixed_set = random.randint(0, 0xF)
    shared_prefix = random.choice([0x0002, 0x0003])
    tag_list = []
    n = random.randint(1, 3)
    for _ in range(n):
        while True:
            tag = random.randint(0, 0x3F)
            if tag not in used_tags:
                used_tags.add(tag)
                tag_list.append(tag)
                break
        off = random.choice(range(0, 64, 4))
        addr = make_shared(shared_prefix, tag, fixed_set, off)
        instr_A.append(f"read\t{to_hex32(addr)}")
        addrs.append(addr)
    tag_dup = random.choice(tag_list)
    off_dup = random.choice(range(0, 64, 4))
    addr_dup = make_shared(shared_prefix, tag_dup, fixed_set, off_dup)
    instr_A.append(f"read\t{to_hex32(addr_dup)}")
    addrs.append(addr_dup)
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
    base_path = "subsystem_testcase/testcase_18/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_shared(p, t, s, o): return (p << 16) | (t << 10) | (s << 6) | o
    instr_A = []
    addrs = []
    used_tags = set()
    fixed_set = random.randint(0, 0xF)
    shared_prefix = random.choice([0x0002, 0x0003])
    n = random.randint(2, 4)
    for _ in range(n):
        while True:
            tag = random.randint(0, 0x3F)
            if tag not in used_tags:
                used_tags.add(tag)
                break
        off = random.choice(range(0, 64, 4))
        addr = make_shared(shared_prefix, tag, fixed_set, off)
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
    print("testcase 18 created")
def testcase_19():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "subsystem_testcase/testcase_19/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_shared(p, t, s, o): return (p << 16) | (t << 10) | (s << 6) | o
    instr_A = []
    addrs = []
    used_tags = set()
    fixed_set = random.randint(0, 0xF)
    shared_prefix = random.choice([0x0002, 0x0003])
    for _ in range(5):
        while True:
            tag = random.randint(0, 0x3F)
            if tag not in used_tags:
                used_tags.add(tag)
                break
        offset = random.choice(range(0, 64, 4))
        addr = make_shared(shared_prefix, tag, fixed_set, offset)
        instr_A.append(f"read\t{to_hex32(addr)}")
        addrs.append(addr)
    with open(path_A, "w") as f:
        for l in instr_A: f.write(l + "\n")
    with open(path_B, "w") as f: pass
    written = set()
    with open(path_mem, "w") as f:
        for a in addrs:
            base = a & ~0x3F
            if base in written: continue
            written.add(base)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(base)] + words) + "\n")
    print("testcase 19 created")
def testcase_20():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "subsystem_testcase/testcase_20/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_shared(p, t, s, o): return (p << 16) | (t << 10) | (s << 6) | o
    instr_A = []
    addrs = []
    used_tags = set()
    shared_prefix = random.choice([0x0002, 0x0003])
    fixed_set = random.randint(0, 0xF)
    for _ in range(4):
        while True:
            tag = random.randint(0, 0x3F)
            if tag not in used_tags:
                used_tags.add(tag)
                break
        offset = random.choice(range(0, 64, 4))
        addr = make_shared(shared_prefix, tag, fixed_set, offset)
        data = to_hex32(random.getrandbits(32))
        instr_A.append(f"write\t{to_hex32(addr)}\t{data}")
        addrs.append(addr)
    while True:
        tag_r = random.randint(0, 0x3F)
        if tag_r not in used_tags:
            used_tags.add(tag_r)
            break
    offset_r = random.choice(range(0, 64, 4))
    addr_r = make_shared(shared_prefix, tag_r, fixed_set, offset_r)
    instr_A.append(f"read\t{to_hex32(addr_r)}")
    addrs.append(addr_r)
    with open(path_A, "w") as f:
        for l in instr_A: f.write(l + "\n")
    with open(path_B, "w") as f: pass
    written = set()
    with open(path_mem, "w") as f:
        for a in addrs:
            base = a & ~0x3F
            if base in written: continue
            written.add(base)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(base)] + words) + "\n")
    print("testcase 20 created")
def testcase_21():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "subsystem_testcase/testcase_21/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_shared(p, t, s, o): return (p << 16) | (t << 10) | (s << 6) | o
    instr_A = []
    instr_B = []
    addrs = []
    used_tags = set()
    shared_prefix = random.choice([0x0002, 0x0003])
    fixed_set = random.randint(0, 0xF)
    n = random.randint(2, 4)
    last_tag = None
    for _ in range(n):
        while True:
            tag = random.randint(0, 0x3F)
            if tag not in used_tags:
                used_tags.add(tag)
                last_tag = tag
                break
        offset = random.choice(range(0, 64, 4))
        addr = make_shared(shared_prefix, tag, fixed_set, offset)
        instr_A.append(f"read\t{to_hex32(addr)}")
        addrs.append(addr)
    offset_b = random.choice(range(0, 64, 4))
    addr_b = make_shared(shared_prefix, last_tag, fixed_set, offset_b)
    instr_B.append(f"read\t{to_hex32(addr_b)}")
    addrs.append(addr_b)
    with open(path_A, "w") as f:
        for l in instr_A: f.write(l + "\n")
    with open(path_B, "w") as f:
        for l in instr_B: f.write(l + "\n")
    written = set()
    with open(path_mem, "w") as f:
        for a in addrs:
            base = a & ~0x3F
            if base in written: continue
            written.add(base)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(base)] + words) + "\n")
    print("testcase 21 created")
def testcase_22():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "subsystem_testcase/testcase_22/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_shared(p, t, s, o): return (p << 16) | (t << 10) | (s << 6) | o

    instr_A = []
    instr_B = []
    addrs = []
    used_tags = set()
    shared_prefix = random.choice([0x0002, 0x0003])
    fixed_set = random.randint(0, 0xF)

    last_tag = None
    for _ in range(5):
        while True:
            tag = random.randint(0, 0x3F)
            if tag not in used_tags:
                used_tags.add(tag)
                last_tag = tag
                break
        offset = random.choice(range(0, 64, 4))
        addr = make_shared(shared_prefix, tag, fixed_set, offset)
        instr_A.append(f"read\t{to_hex32(addr)}")
        addrs.append(addr)

    offset_b = random.choice(range(0, 64, 4))
    addr_b = make_shared(shared_prefix, last_tag, fixed_set, offset_b)
    instr_B.append(f"read\t{to_hex32(addr_b)}")
    addrs.append(addr_b)

    with open(path_A, "w") as f:
        for l in instr_A: f.write(l + "\n")
    with open(path_B, "w") as f:
        for l in instr_B: f.write(l + "\n")

    written = set()
    with open(path_mem, "w") as f:
        for a in addrs:
            base = a & ~0x3F
            if base in written: continue
            written.add(base)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(base)] + words) + "\n")

    print("testcase 22 created")
def testcase_23():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "subsystem_testcase/testcase_23/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_shared(p, t, s, o): return (p << 16) | (t << 10) | (s << 6) | o

    instr_A = []
    instr_B = []
    addrs = []
    used_tags = set()
    shared_prefix = random.choice([0x0002, 0x0003])
    fixed_set = random.randint(0, 0xF)

    last_tag = None
    for _ in range(4):
        while True:
            tag = random.randint(0, 0x3F)
            if tag not in used_tags:
                used_tags.add(tag)
                last_tag = tag
                break
        offset = random.choice(range(0, 64, 4))
        addr = make_shared(shared_prefix, tag, fixed_set, offset)
        data = to_hex32(random.getrandbits(32))
        instr_A.append(f"write\t{to_hex32(addr)}\t{data}")
        addrs.append(addr)

    while True:
        tag = random.randint(0, 0x3F)
        if tag not in used_tags:
            used_tags.add(tag)
            last_tag = tag
            break
    offset = random.choice(range(0, 64, 4))
    addr_last = make_shared(shared_prefix, last_tag, fixed_set, offset)
    instr_A.append(f"read\t{to_hex32(addr_last)}")
    addrs.append(addr_last)

    offset_b = random.choice(range(0, 64, 4))
    addr_b = make_shared(shared_prefix, last_tag, fixed_set, offset_b)
    instr_B.append(f"read\t{to_hex32(addr_b)}")
    addrs.append(addr_b)

    with open(path_A, "w") as f:
        for l in instr_A: f.write(l + "\n")
    with open(path_B, "w") as f:
        for l in instr_B: f.write(l + "\n")

    written = set()
    with open(path_mem, "w") as f:
        for a in addrs:
            base = a & ~0x3F
            if base in written: continue
            written.add(base)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(base)] + words) + "\n")

    print("testcase 23 created")
def testcase_24():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "subsystem_testcase/testcase_24/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_shared(p, t, s, o): return (p << 16) | (t << 10) | (s << 6) | o

    instr_B = []
    addrs = []
    used_tags = set()
    tag_list = []
    shared_prefix = random.choice([0x0002, 0x0003])
    fixed_set = random.randint(0, 0xF)

    n = random.randint(1, 3)
    for _ in range(n):
        while True:
            tag = random.randint(0, 0x3F)
            if tag not in used_tags:
                used_tags.add(tag)
                tag_list.append(tag)
                break
        offset = random.choice(range(0, 64, 4))
        addr = make_shared(shared_prefix, tag, fixed_set, offset)
        instr_B.append(f"read\t{to_hex32(addr)}")
        addrs.append(addr)

    tag_dup = random.choice(tag_list)
    offset_dup = random.choice(range(0, 64, 4))
    addr_dup = make_shared(shared_prefix, tag_dup, fixed_set, offset_dup)
    instr_B.append(f"read\t{to_hex32(addr_dup)}")
    addrs.append(addr_dup)

    with open(path_A, "w") as f: pass
    with open(path_B, "w") as f:
        for l in instr_B: f.write(l + "\n")

    written = set()
    with open(path_mem, "w") as f:
        for a in addrs:
            base = a & ~0x3F
            if base in written: continue
            written.add(base)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(base)] + words) + "\n")

    print("testcase 24 created")
def testcase_25():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "subsystem_testcase/testcase_25/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_shared(p, t, s, o): return (p << 16) | (t << 10) | (s << 6) | o

    instr_B = []
    addrs = []
    used_tags = set()
    shared_prefix = random.choice([0x0002, 0x0003])
    fixed_set = random.randint(0, 0xF)
    n = random.randint(2, 4)

    for _ in range(n):
        while True:
            tag = random.randint(0, 0x3F)
            if tag not in used_tags:
                used_tags.add(tag)
                break
        offset = random.choice(range(0, 64, 4))
        addr = make_shared(shared_prefix, tag, fixed_set, offset)
        instr_B.append(f"read\t{to_hex32(addr)}")
        addrs.append(addr)

    with open(path_A, "w") as f: pass
    with open(path_B, "w") as f:
        for l in instr_B: f.write(l + "\n")

    written = set()
    with open(path_mem, "w") as f:
        for a in addrs:
            base = a & ~0x3F
            if base in written: continue
            written.add(base)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(base)] + words) + "\n")

    print("testcase 25 created")
def testcase_26():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "subsystem_testcase/testcase_26/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_shared(p, t, s, o): return (p << 16) | (t << 10) | (s << 6) | o

    instr_B = []
    addrs = []
    used_tags = set()
    shared_prefix = random.choice([0x0002, 0x0003])
    fixed_set = random.randint(0, 0xF)

    for _ in range(5):
        while True:
            tag = random.randint(0, 0x3F)
            if tag not in used_tags:
                used_tags.add(tag)
                break
        offset = random.choice(range(0, 64, 4))
        addr = make_shared(shared_prefix, tag, fixed_set, offset)
        instr_B.append(f"read\t{to_hex32(addr)}")
        addrs.append(addr)

    with open(path_A, "w") as f: pass
    with open(path_B, "w") as f:
        for l in instr_B: f.write(l + "\n")

    written = set()
    with open(path_mem, "w") as f:
        for a in addrs:
            base = a & ~0x3F
            if base in written: continue
            written.add(base)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(base)] + words) + "\n")

    print("testcase 26 created")
def testcase_27():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "subsystem_testcase/testcase_27/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_shared(p, t, s, o): return (p << 16) | (t << 10) | (s << 6) | o

    instr_B = []
    addrs = []
    used_tags = set()
    shared_prefix = random.choice([0x0002, 0x0003])
    fixed_set = random.randint(0, 0xF)

    for _ in range(4):
        while True:
            tag = random.randint(0, 0x3F)
            if tag not in used_tags:
                used_tags.add(tag)
                break
        offset = random.choice(range(0, 64, 4))
        addr = make_shared(shared_prefix, tag, fixed_set, offset)
        data = to_hex32(random.getrandbits(32))
        instr_B.append(f"write\t{to_hex32(addr)}\t{data}")
        addrs.append(addr)

    while True:
        tag_r = random.randint(0, 0x3F)
        if tag_r not in used_tags:
            used_tags.add(tag_r)
            break
    offset_r = random.choice(range(0, 64, 4))
    addr_r = make_shared(shared_prefix, tag_r, fixed_set, offset_r)
    instr_B.append(f"read\t{to_hex32(addr_r)}")
    addrs.append(addr_r)

    with open(path_A, "w") as f: pass
    with open(path_B, "w") as f:
        for l in instr_B: f.write(l + "\n")

    written = set()
    with open(path_mem, "w") as f:
        for a in addrs:
            base = a & ~0x3F
            if base in written: continue
            written.add(base)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(base)] + words) + "\n")

    print("testcase 27 created")
def testcase_28():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "subsystem_testcase/testcase_28/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_shared(p, t, s, o): return (p << 16) | (t << 10) | (s << 6) | o

    instr_A = []
    instr_B = []
    addrs = []
    used_tags = set()
    shared_prefix = random.choice([0x0002, 0x0003])
    fixed_set = random.randint(0, 0xF)
    n = random.randint(2, 4)

    last_tag = None
    for _ in range(n):
        while True:
            tag = random.randint(0, 0x3F)
            if tag not in used_tags:
                used_tags.add(tag)
                last_tag = tag
                break
        offset = random.choice(range(0, 64, 4))
        addr = make_shared(shared_prefix, tag, fixed_set, offset)
        instr_B.append(f"read\t{to_hex32(addr)}")
        addrs.append(addr)

    offset_a = random.choice(range(0, 64, 4))
    addr_a = make_shared(shared_prefix, last_tag, fixed_set, offset_a)
    instr_A.append(f"read\t{to_hex32(addr_a)}")
    addrs.append(addr_a)

    with open(path_A, "w") as f:
        for l in instr_A: f.write(l + "\n")
    with open(path_B, "w") as f:
        for l in instr_B: f.write(l + "\n")

    written = set()
    with open(path_mem, "w") as f:
        for a in addrs:
            base = a & ~0x3F
            if base in written: continue
            written.add(base)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(base)] + words) + "\n")

    print("testcase 28 created")
def testcase_29():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "subsystem_testcase/testcase_29/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_shared(p, t, s, o): return (p << 16) | (t << 10) | (s << 6) | o

    instr_A = []
    instr_B = []
    addrs = []
    used_tags = set()
    shared_prefix = random.choice([0x0002, 0x0003])
    fixed_set = random.randint(0, 0xF)

    last_tag = None
    for _ in range(5):
        while True:
            tag = random.randint(0, 0x3F)
            if tag not in used_tags:
                used_tags.add(tag)
                last_tag = tag
                break
        offset = random.choice(range(0, 64, 4))
        addr = make_shared(shared_prefix, tag, fixed_set, offset)
        instr_B.append(f"read\t{to_hex32(addr)}")
        addrs.append(addr)

    offset_a = random.choice(range(0, 64, 4))
    addr_a = make_shared(shared_prefix, last_tag, fixed_set, offset_a)
    instr_A.append(f"read\t{to_hex32(addr_a)}")
    addrs.append(addr_a)

    with open(path_A, "w") as f:
        for l in instr_A: f.write(l + "\n")
    with open(path_B, "w") as f:
        for l in instr_B: f.write(l + "\n")

    written = set()
    with open(path_mem, "w") as f:
        for a in addrs:
            base = a & ~0x3F
            if base in written: continue
            written.add(base)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(base)] + words) + "\n")

    print("testcase 29 created")
def testcase_30():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "subsystem_testcase/testcase_30/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_shared(p, t, s, o): return (p << 16) | (t << 10) | (s << 6) | o

    instr_A = []
    instr_B = []
    addrs = []
    used_tags = set()
    shared_prefix = random.choice([0x0002, 0x0003])
    fixed_set = random.randint(0, 0xF)

    last_tag = None
    for _ in range(4):
        while True:
            tag = random.randint(0, 0x3F)
            if tag not in used_tags:
                used_tags.add(tag)
                last_tag = tag
                break
        offset = random.choice(range(0, 64, 4))
        addr = make_shared(shared_prefix, tag, fixed_set, offset)
        data = to_hex32(random.getrandbits(32))
        instr_B.append(f"write\t{to_hex32(addr)}\t{data}")
        addrs.append(addr)

    while True:
        tag_r = random.randint(0, 0x3F)
        if tag_r not in used_tags:
            used_tags.add(tag_r)
            last_tag = tag_r
            break
    offset_r = random.choice(range(0, 64, 4))
    addr_r = make_shared(shared_prefix, last_tag, fixed_set, offset_r)
    instr_B.append(f"read\t{to_hex32(addr_r)}")
    addrs.append(addr_r)

    offset_a = random.choice(range(0, 64, 4))
    addr_a = make_shared(shared_prefix, last_tag, fixed_set, offset_a)
    instr_A.append(f"read\t{to_hex32(addr_a)}")
    addrs.append(addr_a)

    with open(path_A, "w") as f:
        for l in instr_A: f.write(l + "\n")
    with open(path_B, "w") as f:
        for l in instr_B: f.write(l + "\n")

    written = set()
    with open(path_mem, "w") as f:
        for a in addrs:
            base = a & ~0x3F
            if base in written: continue
            written.add(base)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(base)] + words) + "\n")

    print("testcase 30 created")
def testcase_31():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "subsystem_testcase/testcase_31/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_shared(p, t, s, o): return (p << 16) | (t << 10) | (s << 6) | o

    instr_A = []
    instr_B = []
    addrs = []
    used_tags = set()
    tag_list = []
    shared_prefix = random.choice([0x0002, 0x0003])
    fixed_set = random.randint(0, 0xF)
    n = random.randint(1, 3)

    for _ in range(n):
        while True:
            tag = random.randint(0, 0x3F)
            if tag not in used_tags:
                used_tags.add(tag)
                tag_list.append(tag)
                break
        offset = random.choice(range(0, 64, 4))
        addr = make_shared(shared_prefix, tag, fixed_set, offset)
        instr_A.append(f"read\t{to_hex32(addr)}")
        addrs.append(addr)

    tag_w = random.choice(tag_list)
    offset_w = random.choice(range(0, 64, 4))
    addr_w = make_shared(shared_prefix, tag_w, fixed_set, offset_w)
    data_w = to_hex32(random.getrandbits(32))
    instr_A.append(f"write\t{to_hex32(addr_w)}\t{data_w}")
    addrs.append(addr_w)

    with open(path_A, "w") as f:
        for l in instr_A: f.write(l + "\n")
    with open(path_B, "w") as f: pass

    written = set()
    with open(path_mem, "w") as f:
        for a in addrs:
            base = a & ~0x3F
            if base in written: continue
            written.add(base)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(base)] + words) + "\n")

    print("testcase 31 created")
def testcase_32():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "subsystem_testcase/testcase_32/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_shared(p, t, s, o): return (p << 16) | (t << 10) | (s << 6) | o

    instr_A = []
    instr_B = []
    addrs = []
    used_tags = set()
    shared_prefix = random.choice([0x0002, 0x0003])
    fixed_set = random.randint(0, 0xF)
    n = random.randint(1, 3)

    for _ in range(n):
        while True:
            tag = random.randint(0, 0x3F)
            if tag not in used_tags:
                used_tags.add(tag)
                break
        offset = random.choice(range(0, 64, 4))
        addr = make_shared(shared_prefix, tag, fixed_set, offset)
        instr_A.append(f"read\t{to_hex32(addr)}")
        addrs.append(addr)

    while True:
        tag_w = random.randint(0, 0x3F)
        if tag_w not in used_tags:
            used_tags.add(tag_w)
            break
    offset_w = random.choice(range(0, 64, 4))
    addr_w = make_shared(shared_prefix, tag_w, fixed_set, offset_w)
    data_w = to_hex32(random.getrandbits(32))
    instr_A.append(f"write\t{to_hex32(addr_w)}\t{data_w}")
    addrs.append(addr_w)

    with open(path_A, "w") as f:
        for l in instr_A: f.write(l + "\n")
    with open(path_B, "w") as f: pass

    written = set()
    with open(path_mem, "w") as f:
        for a in addrs:
            base = a & ~0x3F
            if base in written: continue
            written.add(base)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(base)] + words) + "\n")

    print("testcase 32 created")
def testcase_33():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "subsystem_testcase/testcase_33/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_shared(p, t, s, o): return (p << 16) | (t << 10) | (s << 6) | o

    instr_A = []
    instr_B = []
    addrs = []
    used_tags = set()
    shared_prefix = random.choice([0x0002, 0x0003])
    fixed_set = random.randint(0, 0xF)

    for _ in range(4):
        while True:
            tag = random.randint(0, 0x3F)
            if tag not in used_tags:
                used_tags.add(tag)
                break
        offset = random.choice(range(0, 64, 4))
        addr = make_shared(shared_prefix, tag, fixed_set, offset)
        instr_A.append(f"read\t{to_hex32(addr)}")
        addrs.append(addr)

    while True:
        tag_w = random.randint(0, 0x3F)
        if tag_w not in used_tags:
            used_tags.add(tag_w)
            break
    offset_w = random.choice(range(0, 64, 4))
    addr_w = make_shared(shared_prefix, tag_w, fixed_set, offset_w)
    data_w = to_hex32(random.getrandbits(32))
    instr_A.append(f"write\t{to_hex32(addr_w)}\t{data_w}")
    addrs.append(addr_w)

    with open(path_A, "w") as f:
        for l in instr_A: f.write(l + "\n")
    with open(path_B, "w") as f: pass

    written = set()
    with open(path_mem, "w") as f:
        for a in addrs:
            base = a & ~0x3F
            if base in written: continue
            written.add(base)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(base)] + words) + "\n")

    print("testcase 33 created")
def testcase_34():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "subsystem_testcase/testcase_34/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_shared(p, t, s, o): return (p << 16) | (t << 10) | (s << 6) | o

    instr_A = []
    addrs = []
    used_tags = set()
    shared_prefix = random.choice([0x0002, 0x0003])
    fixed_set = random.randint(0, 0xF)

    for _ in range(5):
        while True:
            tag = random.randint(0, 0x3F)
            if tag not in used_tags:
                used_tags.add(tag)
                break
        offset = random.choice(range(0, 64, 4))
        addr = make_shared(shared_prefix, tag, fixed_set, offset)
        data = to_hex32(random.getrandbits(32))
        instr_A.append(f"write\t{to_hex32(addr)}\t{data}")
        addrs.append(addr)

    with open(path_A, "w") as f:
        for l in instr_A: f.write(l + "\n")
    with open(path_B, "w") as f: pass

    written = set()
    with open(path_mem, "w") as f:
        for a in addrs:
            base = a & ~0x3F
            if base in written: continue
            written.add(base)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(base)] + words) + "\n")

    print("testcase 34 created")
def testcase_35():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "subsystem_testcase/testcase_35/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_shared(p, t, s, o): return (p << 16) | (t << 10) | (s << 6) | o

    instr_A, instr_B, addrs = [], [], []
    used_tags = set()
    used_sets = set()
    shared_prefix = random.choice([0x0002, 0x0003])
    fixed_set = random.randint(0, 0xF)

    used_sets.add(fixed_set)

    # 5 lệnh read/write ngẫu nhiên trong A, khác set
    for _ in range(5):
        while True:
            s = random.randint(0, 0xF)
            if s not in used_sets:
                used_sets.add(s)
                break
        tag = random.randint(0, 0x3F)
        offset = random.choice(range(0, 64, 4))
        addr = make_shared(shared_prefix, tag, s, offset)
        if random.choice([True, False]):
            instr_A.append(f"read\t{to_hex32(addr)}")
        else:
            data = to_hex32(random.getrandbits(32))
            instr_A.append(f"write\t{to_hex32(addr)}\t{data}")
        addrs.append(addr)

    n = random.randint(1, 3)

    for _ in range(n):
        while True:
            tag = random.randint(0, 0x3F)
            if tag not in used_tags:
                used_tags.add(tag)
                break
        off = random.choice(range(0, 64, 4))
        addr = make_shared(shared_prefix, tag, fixed_set, off)
        instr_A.append(f"read\t{to_hex32(addr)}")
        addrs.append(addr)

    while True:
        tag_w = random.randint(0, 0x3F)
        if tag_w not in used_tags:
            used_tags.add(tag_w)
            break
    off_w = random.choice(range(0, 64, 4))
    addr_w = make_shared(shared_prefix, tag_w, fixed_set, off_w)
    data = to_hex32(random.getrandbits(32))
    instr_A.append(f"write\t{to_hex32(addr_w)}\t{data}")
    addrs.append(addr_w)

    off_b = random.choice(range(0, 64, 4))
    addr_b = make_shared(shared_prefix, tag_w, fixed_set, off_b)
    instr_B.append(f"read\t{to_hex32(addr_b)}")
    addrs.append(addr_b)

    with open(path_A, "w") as f:
        for l in instr_A: f.write(l + "\n")
    with open(path_B, "w") as f:
        for l in instr_B: f.write(l + "\n")

    written = set()
    with open(path_mem, "w") as f:
        for a in addrs:
            base = a & ~0x3F
            if base in written: continue
            written.add(base)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(base)] + words) + "\n")

    print("testcase 35 created")
def testcase_36():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "subsystem_testcase/testcase_36/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_shared(p, t, s, o): return (p << 16) | (t << 10) | (s << 6) | o

    instr_A, instr_B, addrs = [], [], []
    used_tags = set()
    shared_prefix = random.choice([0x0002, 0x0003])
    fixed_set = random.randint(0, 0xF)

    for _ in range(4):
        while True:
            tag = random.randint(0, 0x3F)
            if tag not in used_tags:
                used_tags.add(tag)
                break
        off = random.choice(range(0, 64, 4))
        addr = make_shared(shared_prefix, tag, fixed_set, off)
        instr_A.append(f"read\t{to_hex32(addr)}")
        addrs.append(addr)

    while True:
        tag_w = random.randint(0, 0x3F)
        if tag_w not in used_tags:
            used_tags.add(tag_w)
            break
    off_w = random.choice(range(0, 64, 4))
    addr_w = make_shared(shared_prefix, tag_w, fixed_set, off_w)
    data_w = to_hex32(random.getrandbits(32))
    instr_A.append(f"write\t{to_hex32(addr_w)}\t{data_w}")
    addrs.append(addr_w)

    off_b = random.choice(range(0, 64, 4))
    addr_b = make_shared(shared_prefix, tag_w, fixed_set, off_b)
    instr_B.append(f"read\t{to_hex32(addr_b)}")
    addrs.append(addr_b)

    with open(path_A, "w") as f:
        for l in instr_A: f.write(l + "\n")
    with open(path_B, "w") as f:
        for l in instr_B: f.write(l + "\n")

    written = set()
    with open(path_mem, "w") as f:
        for a in addrs:
            base = a & ~0x3F
            if base in written: continue
            written.add(base)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(base)] + words) + "\n")

    print("testcase 36 created")
def testcase_37():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "subsystem_testcase/testcase_37/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_shared(p, t, s, o): return (p << 16) | (t << 10) | (s << 6) | o

    instr_A, instr_B, addrs = [], [], []
    used_tags = set()
    shared_prefix = random.choice([0x0002, 0x0003])
    fixed_set = random.randint(0, 0xF)

    for _ in range(5):
        while True:
            tag = random.randint(0, 0x3F)
            if tag not in used_tags:
                used_tags.add(tag)
                break
        offset = random.choice(range(0, 64, 4))
        addr = make_shared(shared_prefix, tag, fixed_set, offset)
        data = to_hex32(random.getrandbits(32))
        instr_A.append(f"write\t{to_hex32(addr)}\t{data}")
        addrs.append(addr)
        last_tag = tag

    offset_b = random.choice(range(0, 64, 4))
    addr_b = make_shared(shared_prefix, last_tag, fixed_set, offset_b)
    instr_B.append(f"read\t{to_hex32(addr_b)}")
    addrs.append(addr_b)

    with open(path_A, "w") as f:
        for l in instr_A: f.write(l + "\n")
    with open(path_B, "w") as f:
        for l in instr_B: f.write(l + "\n")

    written = set()
    with open(path_mem, "w") as f:
        for a in addrs:
            base = a & ~0x3F
            if base in written: continue
            written.add(base)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(base)] + words) + "\n")

    print("testcase 37 created")
def testcase_38():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "subsystem_testcase/testcase_38/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_shared(p, t, s, o): return (p << 16) | (t << 10) | (s << 6) | o

    instr_A, instr_B, addrs = [], [], []
    used_tags = set()
    tag_list = []
    shared_prefix = random.choice([0x0002, 0x0003])
    fixed_set = random.randint(0, 0xF)
    n = random.randint(1, 3)

    for _ in range(n):
        while True:
            tag = random.randint(0, 0x3F)
            if tag not in used_tags:
                used_tags.add(tag)
                tag_list.append(tag)
                break
        off = random.choice(range(0, 64, 4))
        addr = make_shared(shared_prefix, tag, fixed_set, off)
        instr_B.append(f"read\t{to_hex32(addr)}")
        addrs.append(addr)

    tag_w = random.choice(tag_list)
    off_w = random.choice(range(0, 64, 4))
    addr_w = make_shared(shared_prefix, tag_w, fixed_set, off_w)
    data_w = to_hex32(random.getrandbits(32))
    instr_B.append(f"write\t{to_hex32(addr_w)}\t{data_w}")
    addrs.append(addr_w)

    with open(path_A, "w") as f: pass
    with open(path_B, "w") as f:
        for l in instr_B: f.write(l + "\n")

    written = set()
    with open(path_mem, "w") as f:
        for a in addrs:
            base = a & ~0x3F
            if base in written: continue
            written.add(base)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(base)] + words) + "\n")

    print("testcase 38 created")
def testcase_39():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "subsystem_testcase/testcase_39/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_shared(p, t, s, o): return (p << 16) | (t << 10) | (s << 6) | o

    instr_B, instr_A, addrs = [], [], []
    used_tags = set()
    shared_prefix = random.choice([0x0002, 0x0003])
    fixed_set = random.randint(0, 0xF)
    n = random.randint(1, 3)

    for _ in range(n):
        while True:
            tag = random.randint(0, 0x3F)
            if tag not in used_tags:
                used_tags.add(tag)
                break
        offset = random.choice(range(0, 64, 4))
        addr = make_shared(shared_prefix, tag, fixed_set, offset)
        instr_B.append(f"read\t{to_hex32(addr)}")
        addrs.append(addr)

    while True:
        tag_w = random.randint(0, 0x3F)
        if tag_w not in used_tags:
            used_tags.add(tag_w)
            break
    offset_w = random.choice(range(0, 64, 4))
    addr_w = make_shared(shared_prefix, tag_w, fixed_set, offset_w)
    data_w = to_hex32(random.getrandbits(32))
    instr_B.append(f"write\t{to_hex32(addr_w)}\t{data_w}")
    addrs.append(addr_w)

    with open(path_A, "w") as f: pass
    with open(path_B, "w") as f:
        for l in instr_B: f.write(l + "\n")

    written = set()
    with open(path_mem, "w") as f:
        for a in addrs:
            base = a & ~0x3F
            if base in written: continue
            written.add(base)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(base)] + words) + "\n")

    print("testcase 39 created")
def testcase_40():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "subsystem_testcase/testcase_40/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_shared(p, t, s, o): return (p << 16) | (t << 10) | (s << 6) | o

    instr_B, instr_A, addrs = [], [], []
    used_tags = set()
    shared_prefix = random.choice([0x0002, 0x0003])
    fixed_set = random.randint(0, 0xF)

    for _ in range(4):
        while True:
            tag = random.randint(0, 0x3F)
            if tag not in used_tags:
                used_tags.add(tag)
                break
        offset = random.choice(range(0, 64, 4))
        addr = make_shared(shared_prefix, tag, fixed_set, offset)
        instr_B.append(f"read\t{to_hex32(addr)}")
        addrs.append(addr)

    while True:
        tag_w = random.randint(0, 0x3F)
        if tag_w not in used_tags:
            used_tags.add(tag_w)
            break
    offset_w = random.choice(range(0, 64, 4))
    addr_w = make_shared(shared_prefix, tag_w, fixed_set, offset_w)
    data_w = to_hex32(random.getrandbits(32))
    instr_B.append(f"write\t{to_hex32(addr_w)}\t{data_w}")
    addrs.append(addr_w)

    with open(path_A, "w") as f: pass
    with open(path_B, "w") as f:
        for line in instr_B: f.write(line + "\n")

    written = set()
    with open(path_mem, "w") as f:
        for a in addrs:
            base = a & ~0x3F
            if base in written: continue
            written.add(base)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(base)] + words) + "\n")

    print("testcase 40 created")
def testcase_41():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "subsystem_testcase/testcase_41/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_shared(p, t, s, o): return (p << 16) | (t << 10) | (s << 6) | o

    instr_B = []
    addrs = []
    used_tags = set()
    shared_prefix = random.choice([0x0002, 0x0003])
    fixed_set = random.randint(0, 0xF)

    for _ in range(5):
        while True:
            tag = random.randint(0, 0x3F)
            if tag not in used_tags:
                used_tags.add(tag)
                break
        offset = random.choice(range(0, 64, 4))
        addr = make_shared(shared_prefix, tag, fixed_set, offset)
        data = to_hex32(random.getrandbits(32))
        instr_B.append(f"write\t{to_hex32(addr)}\t{data}")
        addrs.append(addr)

    with open(path_A, "w") as f: pass
    with open(path_B, "w") as f:
        for line in instr_B: f.write(line + "\n")

    written = set()
    with open(path_mem, "w") as f:
        for a in addrs:
            base = a & ~0x3F
            if base in written: continue
            written.add(base)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(base)] + words) + "\n")

    print("testcase 41 created")
def testcase_42():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "subsystem_testcase/testcase_42/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_shared(p, t, s, o): return (p << 16) | (t << 10) | (s << 6) | o

    instr_A, instr_B, addrs = [], [], []
    used_tags = set()
    shared_prefix = random.choice([0x0002, 0x0003])
    fixed_set = random.randint(0, 0xF)
    n = random.randint(1, 3)

    for _ in range(n):
        while True:
            tag = random.randint(0, 0x3F)
            if tag not in used_tags:
                used_tags.add(tag)
                break
        offset = random.choice(range(0, 64, 4))
        addr = make_shared(shared_prefix, tag, fixed_set, offset)
        instr_B.append(f"read\t{to_hex32(addr)}")
        addrs.append(addr)

    # Lệnh write với tag mới chưa dùng
    while True:
        tag_w = random.randint(0, 0x3F)
        if tag_w not in used_tags:
            used_tags.add(tag_w)
            break
    offset_w = random.choice(range(0, 64, 4))
    addr_w = make_shared(shared_prefix, tag_w, fixed_set, offset_w)
    data_w = to_hex32(random.getrandbits(32))
    instr_B.append(f"write\t{to_hex32(addr_w)}\t{data_w}")
    addrs.append(addr_w)

    # Lệnh read từ mem A giống địa chỉ logic của write cuối
    offset_a = random.choice(range(0, 64, 4))
    addr_a = make_shared(shared_prefix, tag_w, fixed_set, offset_a)
    instr_A.append(f"read\t{to_hex32(addr_a)}")
    addrs.append(addr_a)

    with open(path_A, "w") as f:
        for line in instr_A: f.write(line + "\n")
    with open(path_B, "w") as f:
        for line in instr_B: f.write(line + "\n")

    written = set()
    with open(path_mem, "w") as f:
        for a in addrs:
            block_base = a & ~0x3F
            if block_base in written: continue
            written.add(block_base)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(block_base)] + words) + "\n")

    print("testcase 42 created")
def testcase_43():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "subsystem_testcase/testcase_43/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_shared(p, t, s, o): return (p << 16) | (t << 10) | (s << 6) | o

    instr_A, instr_B, addrs = [], [], []
    used_tags = set()
    shared_prefix = random.choice([0x0002, 0x0003])  # chia sẻ chung
    fixed_set = random.randint(0, 0xF)

    # 4 lệnh READ khác tag
    for _ in range(4):
        while True:
            tag = random.randint(0, 0x3F)
            if tag not in used_tags:
                used_tags.add(tag)
                break
        offset = random.choice(range(0, 64, 4))
        addr = make_shared(shared_prefix, tag, fixed_set, offset)
        instr_B.append(f"read\t{to_hex32(addr)}")
        addrs.append(addr)

    # Lệnh WRITE cuối cùng (tag mới)
    while True:
        tag_w = random.randint(0, 0x3F)
        if tag_w not in used_tags:
            used_tags.add(tag_w)
            break
    offset_w = random.choice(range(0, 64, 4))
    addr_w = make_shared(shared_prefix, tag_w, fixed_set, offset_w)
    data_w = to_hex32(random.getrandbits(32))
    instr_B.append(f"write\t{to_hex32(addr_w)}\t{data_w}")
    addrs.append(addr_w)

    # Lệnh READ từ mem A trùng tag, set, prefix với write trên
    offset_a = random.choice(range(0, 64, 4))
    addr_a = make_shared(shared_prefix, tag_w, fixed_set, offset_a)
    instr_A.append(f"read\t{to_hex32(addr_a)}")
    addrs.append(addr_a)

    # Ghi file
    with open(path_A, "w") as f:
        for l in instr_A: f.write(l + "\n")
    with open(path_B, "w") as f:
        for l in instr_B: f.write(l + "\n")

    # Ghi memory data
    written = set()
    with open(path_mem, "w") as f:
        for a in addrs:
            base = a & ~0x3F
            if base in written: continue
            written.add(base)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(base)] + words) + "\n")

    print("testcase 43 created")
def testcase_44():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "subsystem_testcase/testcase_44/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_shared(p, t, s, o): return (p << 16) | (t << 10) | (s << 6) | o

    instr_A, instr_B, addrs = [], [], []
    used_tags = set()
    shared_prefix = random.choice([0x0002, 0x0003])
    fixed_set = random.randint(0, 0xF)

    # 5 lệnh WRITE khác tag
    for _ in range(5):
        while True:
            tag = random.randint(0, 0x3F)
            if tag not in used_tags:
                used_tags.add(tag)
                break
        offset = random.choice(range(0, 64, 4))
        addr = make_shared(shared_prefix, tag, fixed_set, offset)
        data = to_hex32(random.getrandbits(32))
        instr_B.append(f"write\t{to_hex32(addr)}\t{data}")
        addrs.append(addr)
        last_tag = tag  # lưu tag cuối cùng

    # Lệnh read từ mem A trùng tag/set với write cuối trong B
    offset_a = random.choice(range(0, 64, 4))
    addr_a = make_shared(shared_prefix, last_tag, fixed_set, offset_a)
    instr_A.append(f"read\t{to_hex32(addr_a)}")
    addrs.append(addr_a)

    with open(path_A, "w") as f:
        for line in instr_A: f.write(line + "\n")
    with open(path_B, "w") as f:
        for line in instr_B: f.write(line + "\n")

    written = set()
    with open(path_mem, "w") as f:
        for a in addrs:
            base = a & ~0x3F
            if base in written: continue
            written.add(base)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(base)] + words) + "\n")

    print("testcase 44 created")
def testcase_45():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "subsystem_testcase/testcase_45/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_shared(p, t, s, o): return (p << 16) | (t << 10) | (s << 6) | o
    instr_A, instr_B, addrs = [], [], []
    used_tags = set()
    tag_list = []
    shared_prefix = random.choice([0x0002, 0x0003])
    fixed_set = random.randint(0, 0xF)
    n = random.randint(1, 3)
    for _ in range(n):
        while True:
            tag = random.randint(0, 0x3F)
            if tag not in used_tags:
                used_tags.add(tag)
                tag_list.append(tag)
                break
        offset = random.choice(range(0, 64, 4))
        addr = make_shared(shared_prefix, tag, fixed_set, offset)
        instr_A.append(f"read\t{to_hex32(addr)}")
        addrs.append(addr)
    chosen_tag = random.choice(tag_list)
    offset_r2 = random.choice(range(0, 64, 4))
    addr_r2 = make_shared(shared_prefix, chosen_tag, fixed_set, offset_r2)
    instr_A.append(f"read\t{to_hex32(addr_r2)}")
    addrs.append(addr_r2)
    offset_w = random.choice(range(0, 64, 4))
    addr_w = make_shared(shared_prefix, chosen_tag, fixed_set, offset_w)
    data = to_hex32(random.getrandbits(32))
    instr_A.append(f"write\t{to_hex32(addr_w)}\t{data}")
    addrs.append(addr_w)
    with open(path_A, "w") as f:
        for line in instr_A: f.write(line + "\n")
    with open(path_B, "w") as f: pass
    written = set()
    with open(path_mem, "w") as f:
        for a in addrs:
            base = a & ~0x3F
            if base in written: continue
            written.add(base)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(base)] + words) + "\n")
    print("testcase 45 created")
def testcase_46():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "subsystem_testcase/testcase_46/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_shared(p, t, s, o): return (p << 16) | (t << 10) | (s << 6) | o
    instr_A, instr_B, addrs = [], [], []
    used_tags = set()
    shared_prefix = random.choice([0x0002, 0x0003])
    fixed_set = random.randint(0, 0xF)
    for _ in range(4):
        while True:
            tag = random.randint(0, 0x3F)
            if tag not in used_tags:
                used_tags.add(tag)
                last_tag = tag
                break
        offset = random.choice(range(0, 64, 4))
        addr = make_shared(shared_prefix, tag, fixed_set, offset)
        instr_A.append(f"read\t{to_hex32(addr)}")
        addrs.append(addr)
    offset_w = random.choice(range(0, 64, 4))
    addr_w = make_shared(shared_prefix, last_tag, fixed_set, offset_w)
    data = to_hex32(random.getrandbits(32))
    instr_A.append(f"write\t{to_hex32(addr_w)}\t{data}")
    addrs.append(addr_w)
    with open(path_A, "w") as f:
        for l in instr_A: f.write(l + "\n")
    with open(path_B, "w") as f: pass
    written = set()
    with open(path_mem, "w") as f:
        for a in addrs:
            base = a & ~0x3F
            if base in written: continue
            written.add(base)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(base)] + words) + "\n")
    print("testcase 46 created")
def testcase_47():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "subsystem_testcase/testcase_47/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_shared(p, t, s, o): return (p << 16) | (t << 10) | (s << 6) | o
    instr_A, instr_B, addrs = [], [], []
    used_tags = set()
    shared_prefix = random.choice([0x0002, 0x0003])
    fixed_set = random.randint(0, 0xF)
    for _ in range(5):
        while True:
            tag = random.randint(0, 0x3F)
            if tag not in used_tags:
                used_tags.add(tag)
                last_tag = tag
                break
        offset = random.choice(range(0, 64, 4))
        addr = make_shared(shared_prefix, tag, fixed_set, offset)
        instr_A.append(f"read\t{to_hex32(addr)}")
        addrs.append(addr)
    offset_w = random.choice(range(0, 64, 4))
    addr_w = make_shared(shared_prefix, last_tag, fixed_set, offset_w)
    data = to_hex32(random.getrandbits(32))
    instr_A.append(f"write\t{to_hex32(addr_w)}\t{data}")
    addrs.append(addr_w)
    with open(path_A, "w") as f:
        for l in instr_A: f.write(l + "\n")
    with open(path_B, "w") as f: pass
    written = set()
    with open(path_mem, "w") as f:
        for a in addrs:
            base = a & ~0x3F
            if base in written: continue
            written.add(base)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(base)] + words) + "\n")
    print("testcase 47 created")
def testcase_48():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "subsystem_testcase/testcase_48/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_shared(p, t, s, o): return (p << 16) | (t << 10) | (s << 6) | o
    instr_A, addrs = [], []
    used_tags = set()
    shared_prefix = random.choice([0x0002, 0x0003])
    fixed_set = random.randint(0, 0xF)
    for _ in range(4):
        while True:
            tag = random.randint(0, 0x3F)
            if tag not in used_tags:
                used_tags.add(tag)
                break
        offset = random.choice(range(0, 64, 4))
        addr = make_shared(shared_prefix, tag, fixed_set, offset)
        data = to_hex32(random.getrandbits(32))
        instr_A.append(f"write\t{to_hex32(addr)}\t{data}")
        addrs.append(addr)
    while True:
        tag_r = random.randint(0, 0x3F)
        if tag_r not in used_tags:
            used_tags.add(tag_r)
            break
    offset_r = random.choice(range(0, 64, 4))
    addr_r = make_shared(shared_prefix, tag_r, fixed_set, offset_r)
    instr_A.append(f"read\t{to_hex32(addr_r)}")
    addrs.append(addr_r)
    offset_w2 = random.choice(range(0, 64, 4))
    addr_w2 = make_shared(shared_prefix, tag_r, fixed_set, offset_w2)
    data2 = to_hex32(random.getrandbits(32))
    instr_A.append(f"write\t{to_hex32(addr_w2)}\t{data2}")
    addrs.append(addr_w2)
    with open(path_A, "w") as f:
        for l in instr_A: f.write(l + "\n")
    with open(path_B, "w") as f: pass
    written = set()
    with open(path_mem, "w") as f:
        for a in addrs:
            base = a & ~0x3F
            if base in written: continue
            written.add(base)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(base)] + words) + "\n")
    print("testcase 48 created")
def testcase_49():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "subsystem_testcase/testcase_49/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_shared(p, t, s, o): return (p << 16) | (t << 10) | (s << 6) | o
    instr_A, instr_B, addrs = [], [], []
    used_tags = set()
    used_sets = set()
    shared_prefix = random.choice([0x0002, 0x0003])
    fixed_set = random.randint(0, 0xF)

    # Tạo 5 read/write ngẫu nhiên khác set
    used_sets.add(fixed_set)
    for _ in range(5):
        while True:
            new_set = random.randint(0, 0xF)
            if new_set not in used_sets:
                used_sets.add(new_set)
                break
        tag = random.randint(0, 0x3F)
        offset = random.choice(range(0, 64, 4))
        addr = make_shared(shared_prefix, tag, new_set, offset)
        if random.choice([True, False]):
            instr_A.append(f"read\t{to_hex32(addr)}")
        else:
            data = to_hex32(random.getrandbits(32))
            instr_A.append(f"write\t{to_hex32(addr)}\t{data}")
        addrs.append(addr)

    n = random.randint(2, 4)
    for _ in range(n):
        while True:
            tag = random.randint(0, 0x3F)
            if tag not in used_tags:
                used_tags.add(tag)
                last_tag = tag
                break
        offset = random.choice(range(0, 64, 4))
        addr = make_shared(shared_prefix, last_tag, fixed_set, offset)
        instr_A.append(f"read\t{to_hex32(addr)}")
        addrs.append(addr)
    offset_w = random.choice(range(0, 64, 4))
    addr_w = make_shared(shared_prefix, last_tag, fixed_set, offset_w)
    data = to_hex32(random.getrandbits(32))
    instr_A.append(f"write\t{to_hex32(addr_w)}\t{data}")
    addrs.append(addr_w)
    offset_b = random.choice(range(0, 64, 4))
    addr_b = make_shared(shared_prefix, last_tag, fixed_set, offset_b)
    instr_B.append(f"read\t{to_hex32(addr_b)}")
    addrs.append(addr_b)
    with open(path_A, "w") as f:
        for l in instr_A: f.write(l + "\n")
    with open(path_B, "w") as f:
        for l in instr_B: f.write(l + "\n")
    written = set()
    with open(path_mem, "w") as f:
        for a in addrs:
            base = a & ~0x3F
            if base in written: continue
            written.add(base)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(base)] + words) + "\n")
    print("testcase 49 created")
def testcase_50():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "subsystem_testcase/testcase_50/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_shared(p, t, s, o): return (p << 16) | (t << 10) | (s << 6) | o
    instr_A, instr_B, addrs = [], [], []
    used_tags = set()
    shared_prefix = random.choice([0x0002, 0x0003])
    fixed_set = random.randint(0, 0xF)
    for _ in range(5):
        while True:
            tag = random.randint(0, 0x3F)
            if tag not in used_tags:
                used_tags.add(tag)
                last_tag = tag
                break
        offset = random.choice(range(0, 64, 4))
        addr = make_shared(shared_prefix, last_tag, fixed_set, offset)
        instr_A.append(f"read\t{to_hex32(addr)}")
        addrs.append(addr)
    offset_w = random.choice(range(0, 64, 4))
    addr_w = make_shared(shared_prefix, last_tag, fixed_set, offset_w)
    data = to_hex32(random.getrandbits(32))
    instr_A.append(f"write\t{to_hex32(addr_w)}\t{data}")
    addrs.append(addr_w)
    offset_b = random.choice(range(0, 64, 4))
    addr_b = make_shared(shared_prefix, last_tag, fixed_set, offset_b)
    instr_B.append(f"read\t{to_hex32(addr_b)}")
    addrs.append(addr_b)
    with open(path_A, "w") as f:
        for l in instr_A: f.write(l + "\n")
    with open(path_B, "w") as f:
        for l in instr_B: f.write(l + "\n")
    written = set()
    with open(path_mem, "w") as f:
        for a in addrs:
            base = a & ~0x3F
            if base in written: continue
            written.add(base)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(base)] + words) + "\n")
    print("testcase 50 created")
def testcase_51():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "subsystem_testcase/testcase_51/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_shared(p, t, s, o): return (p << 16) | (t << 10) | (s << 6) | o
    instr_A, instr_B, addrs = [], [], []
    used_tags = set()
    shared_prefix = random.choice([0x0002, 0x0003])
    fixed_set = random.randint(0, 0xF)
    for _ in range(4):
        while True:
            tag = random.randint(0, 0x3F)
            if tag not in used_tags:
                used_tags.add(tag)
                break
        offset = random.choice(range(0, 64, 4))
        addr = make_shared(shared_prefix, tag, fixed_set, offset)
        data = to_hex32(random.getrandbits(32))
        instr_A.append(f"write\t{to_hex32(addr)}\t{data}")
        addrs.append(addr)
    while True:
        tag_r = random.randint(0, 0x3F)
        if tag_r not in used_tags:
            used_tags.add(tag_r)
            break
    offset_r = random.choice(range(0, 64, 4))
    addr_r = make_shared(shared_prefix, tag_r, fixed_set, offset_r)
    instr_A.append(f"read\t{to_hex32(addr_r)}")
    addrs.append(addr_r)
    offset_w2 = random.choice(range(0, 64, 4))
    addr_w2 = make_shared(shared_prefix, tag_r, fixed_set, offset_w2)
    data2 = to_hex32(random.getrandbits(32))
    instr_A.append(f"write\t{to_hex32(addr_w2)}\t{data2}")
    addrs.append(addr_w2)
    offset_b = random.choice(range(0, 64, 4))
    addr_b = make_shared(shared_prefix, tag_r, fixed_set, offset_b)
    instr_B.append(f"read\t{to_hex32(addr_b)}")
    addrs.append(addr_b)
    with open(path_A, "w") as f:
        for l in instr_A: f.write(l + "\n")
    with open(path_B, "w") as f:
        for l in instr_B: f.write(l + "\n")
    written = set()
    with open(path_mem, "w") as f:
        for a in addrs:
            base = a & ~0x3F
            if base in written: continue
            written.add(base)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(base)] + words) + "\n")
    print("testcase 51 created")
def testcase_52():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "subsystem_testcase/testcase_52/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_shared(p, t, s, o): return (p << 16) | (t << 10) | (s << 6) | o
    instr_A, instr_B, addrs = [], [], []
    used_tags = set()
    tag_list = []
    shared_prefix = random.choice([0x0002, 0x0003])
    fixed_set = random.randint(0, 0xF)
    n = random.randint(1, 3)
    for _ in range(n):
        while True:
            tag = random.randint(0, 0x3F)
            if tag not in used_tags:
                used_tags.add(tag)
                tag_list.append(tag)
                break
        offset = random.choice(range(0, 64, 4))
        addr = make_shared(shared_prefix, tag, fixed_set, offset)
        instr_A.append(f"read\t{to_hex32(addr)}")
        addrs.append(addr)
    chosen_tag = random.choice(tag_list)
    offset_w = random.choice(range(0, 64, 4))
    addr_w = make_shared(shared_prefix, chosen_tag, fixed_set, offset_w)
    data = to_hex32(random.getrandbits(32))
    instr_A.append(f"write\t{to_hex32(addr_w)}\t{data}")
    addrs.append(addr_w)
    offset_r2 = random.choice(range(0, 64, 4))
    addr_r2 = make_shared(shared_prefix, chosen_tag, fixed_set, offset_r2)
    instr_A.append(f"read\t{to_hex32(addr_r2)}")
    addrs.append(addr_r2)
    with open(path_A, "w") as f:
        for l in instr_A: f.write(l + "\n")
    with open(path_B, "w") as f: pass
    written = set()
    with open(path_mem, "w") as f:
        for a in addrs:
            base = a & ~0x3F
            if base in written: continue
            written.add(base)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(base)] + words) + "\n")
    print("testcase 52 created")
def testcase_53():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "subsystem_testcase/testcase_53/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_shared(p, t, s, o): return (p << 16) | (t << 10) | (s << 6) | o
    instr_A, instr_B, addrs = [], [], []
    used_tags = set()
    shared_prefix = random.choice([0x0002, 0x0003])
    fixed_set = random.randint(0, 0xF)
    n = random.randint(1, 3)
    for _ in range(n):
        while True:
            tag = random.randint(0, 0x3F)
            if tag not in used_tags:
                used_tags.add(tag)
                break
        offset = random.choice(range(0, 64, 4))
        addr = make_shared(shared_prefix, tag, fixed_set, offset)
        instr_A.append(f"read\t{to_hex32(addr)}")
        addrs.append(addr)
    while True:
        tag_w = random.randint(0, 0x3F)
        if tag_w not in used_tags:
            used_tags.add(tag_w)
            break
    offset_w = random.choice(range(0, 64, 4))
    addr_w = make_shared(shared_prefix, tag_w, fixed_set, offset_w)
    data_w = to_hex32(random.getrandbits(32))
    instr_A.append(f"write\t{to_hex32(addr_w)}\t{data_w}")
    addrs.append(addr_w)
    offset_r2 = random.choice(range(0, 64, 4))
    addr_r2 = make_shared(shared_prefix, tag_w, fixed_set, offset_r2)
    instr_A.append(f"read\t{to_hex32(addr_r2)}")
    addrs.append(addr_r2)
    with open(path_A, "w") as f:
        for l in instr_A: f.write(l + "\n")
    with open(path_B, "w") as f: pass
    written = set()
    with open(path_mem, "w") as f:
        for a in addrs:
            base = a & ~0x3F
            if base in written: continue
            written.add(base)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(base)] + words) + "\n")
    print("testcase 53 created")
def testcase_54():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "subsystem_testcase/testcase_54/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_shared(p, t, s, o): return (p << 16) | (t << 10) | (s << 6) | o
    instr_A, instr_B, addrs = [], [], []
    used_tags = set()
    shared_prefix = random.choice([0x0002, 0x0003])
    fixed_set = random.randint(0, 0xF)
    for _ in range(4):
        while True:
            tag = random.randint(0, 0x3F)
            if tag not in used_tags:
                used_tags.add(tag)
                break
        offset = random.choice(range(0, 64, 4))
        addr = make_shared(shared_prefix, tag, fixed_set, offset)
        instr_A.append(f"read\t{to_hex32(addr)}")
        addrs.append(addr)
    while True:
        tag_w = random.randint(0, 0x3F)
        if tag_w not in used_tags:
            used_tags.add(tag_w)
            break
    offset_w = random.choice(range(0, 64, 4))
    addr_w = make_shared(shared_prefix, tag_w, fixed_set, offset_w)
    data_w = to_hex32(random.getrandbits(32))
    instr_A.append(f"write\t{to_hex32(addr_w)}\t{data_w}")
    addrs.append(addr_w)
    offset_r2 = random.choice(range(0, 64, 4))
    addr_r2 = make_shared(shared_prefix, tag_w, fixed_set, offset_r2)
    instr_A.append(f"read\t{to_hex32(addr_r2)}")
    addrs.append(addr_r2)
    with open(path_A, "w") as f:
        for l in instr_A: f.write(l + "\n")
    with open(path_B, "w") as f: pass
    written = set()
    with open(path_mem, "w") as f:
        for a in addrs:
            base = a & ~0x3F
            if base in written: continue
            written.add(base)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(base)] + words) + "\n")
    print("testcase 54 created")
def testcase_55():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "subsystem_testcase/testcase_55/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_shared(p, t, s, o): return (p << 16) | (t << 10) | (s << 6) | o
    instr_A, instr_B, addrs = [], [], []
    used_tags = set()
    shared_prefix = random.choice([0x0002, 0x0003])
    fixed_set = random.randint(0, 0xF)
    for _ in range(5):
        while True:
            tag = random.randint(0, 0x3F)
            if tag not in used_tags:
                used_tags.add(tag)
                last_tag = tag
                break
        offset = random.choice(range(0, 64, 4))
        addr = make_shared(shared_prefix, tag, fixed_set, offset)
        data = to_hex32(random.getrandbits(32))
        instr_A.append(f"write\t{to_hex32(addr)}\t{data}")
        addrs.append(addr)
    offset_r = random.choice(range(0, 64, 4))
    addr_r = make_shared(shared_prefix, last_tag, fixed_set, offset_r)
    instr_A.append(f"read\t{to_hex32(addr_r)}")
    addrs.append(addr_r)
    with open(path_A, "w") as f:
        for l in instr_A: f.write(l + "\n")
    with open(path_B, "w") as f: pass
    written = set()
    with open(path_mem, "w") as f:
        for a in addrs:
            base = a & ~0x3F
            if base in written: continue
            written.add(base)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(base)] + words) + "\n")
    print("testcase 55 created")
def testcase_56():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "subsystem_testcase/testcase_56/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_shared(p, t, s, o): return (p << 16) | (t << 10) | (s << 6) | o
    instr_A, instr_B, addrs = [], [], []
    used_tags = set()
    used_sets = set()
    shared_prefix = random.choice([0x0002, 0x0003])
    fixed_set = random.randint(0, 0xF)

    used_sets.add(fixed_set)

    # 5 lệnh read/write ngẫu nhiên trong A, khác set
    for _ in range(5):
        while True:
            s = random.randint(0, 0xF)
            if s not in used_sets:
                used_sets.add(s)
                break
        tag = random.randint(0, 0x3F)
        offset = random.choice(range(0, 64, 4))
        addr = make_shared(shared_prefix, tag, s, offset)
        if random.choice([True, False]):
            instr_A.append(f"read\t{to_hex32(addr)}")
        else:
            data = to_hex32(random.getrandbits(32))
            instr_A.append(f"write\t{to_hex32(addr)}\t{data}")
        addrs.append(addr)

    n = random.randint(1, 3)
    for _ in range(n):
        while True:
            tag = random.randint(0, 0x3F)
            if tag not in used_tags:
                used_tags.add(tag)
                break
        offset = random.choice(range(0, 64, 4))
        addr = make_shared(shared_prefix, tag, fixed_set, offset)
        instr_A.append(f"read\t{to_hex32(addr)}")
        addrs.append(addr)
    while True:
        tag_w = random.randint(0, 0x3F)
        if tag_w not in used_tags:
            used_tags.add(tag_w)
            break
    offset_w = random.choice(range(0, 64, 4))
    addr_w = make_shared(shared_prefix, tag_w, fixed_set, offset_w)
    data = to_hex32(random.getrandbits(32))
    instr_A.append(f"write\t{to_hex32(addr_w)}\t{data}")
    addrs.append(addr_w)
    offset_r2 = random.choice(range(0, 64, 4))
    addr_r2 = make_shared(shared_prefix, tag_w, fixed_set, offset_r2)
    instr_A.append(f"read\t{to_hex32(addr_r2)}")
    addrs.append(addr_r2)
    offset_b = random.choice(range(0, 64, 4))
    addr_b = make_shared(shared_prefix, tag_w, fixed_set, offset_b)
    instr_B.append(f"read\t{to_hex32(addr_b)}")
    addrs.append(addr_b)
    with open(path_A, "w") as f:
        for l in instr_A: f.write(l + "\n")
    with open(path_B, "w") as f:
        for l in instr_B: f.write(l + "\n")
    written = set()
    with open(path_mem, "w") as f:
        for a in addrs:
            base = a & ~0x3F
            if base in written: continue
            written.add(base)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(base)] + words) + "\n")
    print("testcase 56 created")
def testcase_57():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "subsystem_testcase/testcase_57/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_shared(p, t, s, o): return (p << 16) | (t << 10) | (s << 6) | o
    instr_A, instr_B, addrs = [], [], []
    used_tags = set()
    shared_prefix = random.choice([0x0002, 0x0003])
    fixed_set = random.randint(0, 0xF)
    for _ in range(4):
        while True:
            tag = random.randint(0, 0x3F)
            if tag not in used_tags:
                used_tags.add(tag)
                break
        offset = random.choice(range(0, 64, 4))
        addr = make_shared(shared_prefix, tag, fixed_set, offset)
        instr_A.append(f"read\t{to_hex32(addr)}")
        addrs.append(addr)
    while True:
        tag_w = random.randint(0, 0x3F)
        if tag_w not in used_tags:
            used_tags.add(tag_w)
            break
    offset_w = random.choice(range(0, 64, 4))
    addr_w = make_shared(shared_prefix, tag_w, fixed_set, offset_w)
    data = to_hex32(random.getrandbits(32))
    instr_A.append(f"write\t{to_hex32(addr_w)}\t{data}")
    addrs.append(addr_w)
    offset_r2 = random.choice(range(0, 64, 4))
    addr_r2 = make_shared(shared_prefix, tag_w, fixed_set, offset_r2)
    instr_A.append(f"read\t{to_hex32(addr_r2)}")
    addrs.append(addr_r2)
    offset_b = random.choice(range(0, 64, 4))
    addr_b = make_shared(shared_prefix, tag_w, fixed_set, offset_b)
    instr_B.append(f"read\t{to_hex32(addr_b)}")
    addrs.append(addr_b)
    with open(path_A, "w") as f:
        for l in instr_A: f.write(l + "\n")
    with open(path_B, "w") as f:
        for l in instr_B: f.write(l + "\n")
    written = set()
    with open(path_mem, "w") as f:
        for a in addrs:
            base = a & ~0x3F
            if base in written: continue
            written.add(base)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(base)] + words) + "\n")
    print("testcase 57 created")
def testcase_58():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "subsystem_testcase/testcase_58/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_shared(p, t, s, o): return (p << 16) | (t << 10) | (s << 6) | o
    instr_A, instr_B, addrs = [], [], []
    used_tags = set()
    shared_prefix = random.choice([0x0002, 0x0003])
    fixed_set = random.randint(0, 0xF)
    for _ in range(5):
        while True:
            tag = random.randint(0, 0x3F)
            if tag not in used_tags:
                used_tags.add(tag)
                last_tag = tag
                break
        offset = random.choice(range(0, 64, 4))
        addr = make_shared(shared_prefix, tag, fixed_set, offset)
        data = to_hex32(random.getrandbits(32))
        instr_A.append(f"write\t{to_hex32(addr)}\t{data}")
        addrs.append(addr)
    offset_r = random.choice(range(0, 64, 4))
    addr_r = make_shared(shared_prefix, last_tag, fixed_set, offset_r)
    instr_A.append(f"read\t{to_hex32(addr_r)}")
    addrs.append(addr_r)
    offset_b = random.choice(range(0, 64, 4))
    addr_b = make_shared(shared_prefix, last_tag, fixed_set, offset_b)
    instr_B.append(f"read\t{to_hex32(addr_b)}")
    addrs.append(addr_b)
    with open(path_A, "w") as f:
        for l in instr_A: f.write(l + "\n")
    with open(path_B, "w") as f:
        for l in instr_B: f.write(l + "\n")
    written = set()
    with open(path_mem, "w") as f:
        for a in addrs:
            base = a & ~0x3F
            if base in written: continue
            written.add(base)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(base)] + words) + "\n")
    print("testcase 58 created")
def testcase_59():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "subsystem_testcase/testcase_59/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_shared(p, t, s, o): return (p << 16) | (t << 10) | (s << 6) | o
    instr_A, instr_B, addrs = [], [], []
    used_tags = set()
    tag_list = []
    shared_prefix = random.choice([0x0002, 0x0003])
    fixed_set = random.randint(0, 0xF)
    n = random.randint(1, 3)
    for _ in range(n):
        while True:
            tag = random.randint(0, 0x3F)
            if tag not in used_tags:
                used_tags.add(tag)
                tag_list.append(tag)
                break
        offset = random.choice(range(0, 64, 4))
        addr = make_shared(shared_prefix, tag, fixed_set, offset)
        instr_B.append(f"read\t{to_hex32(addr)}")
        addrs.append(addr)
    chosen_tag = random.choice(tag_list)
    offset_r2 = random.choice(range(0, 64, 4))
    addr_r2 = make_shared(shared_prefix, chosen_tag, fixed_set, offset_r2)
    instr_B.append(f"read\t{to_hex32(addr_r2)}")
    addrs.append(addr_r2)
    offset_w = random.choice(range(0, 64, 4))
    addr_w = make_shared(shared_prefix, chosen_tag, fixed_set, offset_w)
    data = to_hex32(random.getrandbits(32))
    instr_B.append(f"write\t{to_hex32(addr_w)}\t{data}")
    addrs.append(addr_w)
    with open(path_A, "w") as f: pass
    with open(path_B, "w") as f:
        for l in instr_B: f.write(l + "\n")
    written = set()
    with open(path_mem, "w") as f:
        for a in addrs:
            base = a & ~0x3F
            if base in written: continue
            written.add(base)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(base)] + words) + "\n")
    print("testcase 59 created")
def testcase_60():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "subsystem_testcase/testcase_60/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_shared(p, t, s, o): return (p << 16) | (t << 10) | (s << 6) | o
    instr_A, instr_B, addrs = [], [], []
    used_tags = set()
    shared_prefix = random.choice([0x0002, 0x0003])
    fixed_set = random.randint(0, 0xF)
    for _ in range(4):
        while True:
            tag = random.randint(0, 0x3F)
            if tag not in used_tags:
                used_tags.add(tag)
                last_tag = tag
                break
        offset = random.choice(range(0, 64, 4))
        addr = make_shared(shared_prefix, tag, fixed_set, offset)
        instr_B.append(f"read\t{to_hex32(addr)}")
        addrs.append(addr)
    offset_w = random.choice(range(0, 64, 4))
    addr_w = make_shared(shared_prefix, last_tag, fixed_set, offset_w)
    data = to_hex32(random.getrandbits(32))
    instr_B.append(f"write\t{to_hex32(addr_w)}\t{data}")
    addrs.append(addr_w)
    with open(path_A, "w") as f: pass
    with open(path_B, "w") as f:
        for l in instr_B: f.write(l + "\n")
    written = set()
    with open(path_mem, "w") as f:
        for a in addrs:
            base = a & ~0x3F
            if base in written: continue
            written.add(base)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(base)] + words) + "\n")
    print("testcase 60 created")
def testcase_61():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "subsystem_testcase/testcase_61/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_shared(p, t, s, o): return (p << 16) | (t << 10) | (s << 6) | o
    instr_A, instr_B, addrs = [], [], []
    used_tags = set()
    shared_prefix = random.choice([0x0002, 0x0003])
    fixed_set = random.randint(0, 0xF)
    for _ in range(5):
        while True:
            tag = random.randint(0, 0x3F)
            if tag not in used_tags:
                used_tags.add(tag)
                last_tag = tag
                break
        offset = random.choice(range(0, 64, 4))
        addr = make_shared(shared_prefix, tag, fixed_set, offset)
        instr_B.append(f"read\t{to_hex32(addr)}")
        addrs.append(addr)
    offset_w = random.choice(range(0, 64, 4))
    addr_w = make_shared(shared_prefix, last_tag, fixed_set, offset_w)
    data = to_hex32(random.getrandbits(32))
    instr_B.append(f"write\t{to_hex32(addr_w)}\t{data}")
    addrs.append(addr_w)
    with open(path_A, "w") as f: pass
    with open(path_B, "w") as f:
        for l in instr_B: f.write(l + "\n")
    written = set()
    with open(path_mem, "w") as f:
        for a in addrs:
            base = a & ~0x3F
            if base in written: continue
            written.add(base)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(base)] + words) + "\n")
    print("testcase 61 created")
def testcase_62():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "subsystem_testcase/testcase_62/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_shared(p, t, s, o): return (p << 16) | (t << 10) | (s << 6) | o
    instr_A, instr_B, addrs = [], [], []
    used_tags = set()
    shared_prefix = random.choice([0x0002, 0x0003])
    fixed_set = random.randint(0, 0xF)
    for _ in range(4):
        while True:
            tag = random.randint(0, 0x3F)
            if tag not in used_tags:
                used_tags.add(tag)
                break
        offset = random.choice(range(0, 64, 4))
        addr = make_shared(shared_prefix, tag, fixed_set, offset)
        data = to_hex32(random.getrandbits(32))
        instr_B.append(f"write\t{to_hex32(addr)}\t{data}")
        addrs.append(addr)
    while True:
        tag_r = random.randint(0, 0x3F)
        if tag_r not in used_tags:
            used_tags.add(tag_r)
            break
    offset_r = random.choice(range(0, 64, 4))
    addr_r = make_shared(shared_prefix, tag_r, fixed_set, offset_r)
    instr_B.append(f"read\t{to_hex32(addr_r)}")
    addrs.append(addr_r)
    offset_w2 = random.choice(range(0, 64, 4))
    addr_w2 = make_shared(shared_prefix, tag_r, fixed_set, offset_w2)
    data2 = to_hex32(random.getrandbits(32))
    instr_B.append(f"write\t{to_hex32(addr_w2)}\t{data2}")
    addrs.append(addr_w2)
    with open(path_A, "w") as f: pass
    with open(path_B, "w") as f:
        for l in instr_B: f.write(l + "\n")
    written = set()
    with open(path_mem, "w") as f:
        for a in addrs:
            base = a & ~0x3F
            if base in written: continue
            written.add(base)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(base)] + words) + "\n")
    print("testcase 62 created")
def testcase_63():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "subsystem_testcase/testcase_63/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_shared(p, t, s, o): return (p << 16) | (t << 10) | (s << 6) | o
    instr_A, instr_B, addrs = [], [], []
    used_tags = set()
    tag_list = []
    shared_prefix = random.choice([0x0002, 0x0003])
    fixed_set = random.randint(0, 0xF)
    n = random.randint(2, 4)
    for _ in range(n):
        while True:
            tag = random.randint(0, 0x3F)
            if tag not in used_tags:
                used_tags.add(tag)
                tag_list.append(tag)
                break
        offset = random.choice(range(0, 64, 4))
        addr = make_shared(shared_prefix, tag, fixed_set, offset)
        instr_B.append(f"read\t{to_hex32(addr)}")
        addrs.append(addr)
    chosen_tag = tag_list[-1]
    offset_w = random.choice(range(0, 64, 4))
    addr_w = make_shared(shared_prefix, chosen_tag, fixed_set, offset_w)
    data = to_hex32(random.getrandbits(32))
    instr_B.append(f"write\t{to_hex32(addr_w)}\t{data}")
    addrs.append(addr_w)
    offset_a = random.choice(range(0, 64, 4))
    addr_a = make_shared(shared_prefix, chosen_tag, fixed_set, offset_a)
    instr_A.append(f"read\t{to_hex32(addr_a)}")
    addrs.append(addr_a)
    with open(path_A, "w") as f:
        for l in instr_A: f.write(l + "\n")
    with open(path_B, "w") as f:
        for l in instr_B: f.write(l + "\n")
    written = set()
    with open(path_mem, "w") as f:
        for a in addrs:
            base = a & ~0x3F
            if base in written: continue
            written.add(base)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(base)] + words) + "\n")
    print("testcase 63 created")
def testcase_64():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "subsystem_testcase/testcase_64/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_shared(p, t, s, o): return (p << 16) | (t << 10) | (s << 6) | o
    instr_A, instr_B, addrs = [], [], []
    used_tags = set()
    shared_prefix = random.choice([0x0002, 0x0003])
    fixed_set = random.randint(0, 0xF)
    for _ in range(5):
        while True:
            tag = random.randint(0, 0x3F)
            if tag not in used_tags:
                used_tags.add(tag)
                last_tag = tag
                break
        offset = random.choice(range(0, 64, 4))
        addr = make_shared(shared_prefix, tag, fixed_set, offset)
        instr_B.append(f"read\t{to_hex32(addr)}")
        addrs.append(addr)
    offset_w = random.choice(range(0, 64, 4))
    addr_w = make_shared(shared_prefix, last_tag, fixed_set, offset_w)
    data = to_hex32(random.getrandbits(32))
    instr_B.append(f"write\t{to_hex32(addr_w)}\t{data}")
    addrs.append(addr_w)
    offset_a = random.choice(range(0, 64, 4))
    addr_a = make_shared(shared_prefix, last_tag, fixed_set, offset_a)
    instr_A.append(f"read\t{to_hex32(addr_a)}")
    addrs.append(addr_a)
    with open(path_A, "w") as f:
        for l in instr_A: f.write(l + "\n")
    with open(path_B, "w") as f:
        for l in instr_B: f.write(l + "\n")
    written = set()
    with open(path_mem, "w") as f:
        for a in addrs:
            base = a & ~0x3F
            if base in written: continue
            written.add(base)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(base)] + words) + "\n")
    print("testcase 64 created")
def testcase_65():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "subsystem_testcase/testcase_65/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_shared(p, t, s, o): return (p << 16) | (t << 10) | (s << 6) | o
    instr_A, instr_B, addrs = [], [], []
    used_tags = set()
    shared_prefix = random.choice([0x0002, 0x0003])
    fixed_set = random.randint(0, 0xF)
    for _ in range(4):
        while True:
            tag = random.randint(0, 0x3F)
            if tag not in used_tags:
                used_tags.add(tag)
                break
        offset = random.choice(range(0, 64, 4))
        addr = make_shared(shared_prefix, tag, fixed_set, offset)
        data = to_hex32(random.getrandbits(32))
        instr_B.append(f"write\t{to_hex32(addr)}\t{data}")
        addrs.append(addr)
    while True:
        tag_r = random.randint(0, 0x3F)
        if tag_r not in used_tags:
            used_tags.add(tag_r)
            break
    offset_r = random.choice(range(0, 64, 4))
    addr_r = make_shared(shared_prefix, tag_r, fixed_set, offset_r)
    instr_B.append(f"read\t{to_hex32(addr_r)}")
    addrs.append(addr_r)
    offset_w2 = random.choice(range(0, 64, 4))
    addr_w2 = make_shared(shared_prefix, tag_r, fixed_set, offset_w2)
    data2 = to_hex32(random.getrandbits(32))
    instr_B.append(f"write\t{to_hex32(addr_w2)}\t{data2}")
    addrs.append(addr_w2)
    offset_a = random.choice(range(0, 64, 4))
    addr_a = make_shared(shared_prefix, tag_r, fixed_set, offset_a)
    instr_A.append(f"read\t{to_hex32(addr_a)}")
    addrs.append(addr_a)
    with open(path_A, "w") as f:
        for l in instr_A: f.write(l + "\n")
    with open(path_B, "w") as f:
        for l in instr_B: f.write(l + "\n")
    written = set()
    with open(path_mem, "w") as f:
        for a in addrs:
            base = a & ~0x3F
            if base in written: continue
            written.add(base)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(base)] + words) + "\n")
    print("testcase 65 created")
def testcase_66():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "subsystem_testcase/testcase_66/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_shared(p, t, s, o): return (p << 16) | (t << 10) | (s << 6) | o
    instr_A, instr_B, addrs = [], [], []
    used_tags = set()
    tag_list = []
    shared_prefix = random.choice([0x0002, 0x0003])
    fixed_set = random.randint(0, 0xF)
    n = random.randint(1, 3)
    for _ in range(n):
        while True:
            tag = random.randint(0, 0x3F)
            if tag not in used_tags:
                used_tags.add(tag)
                tag_list.append(tag)
                break
        offset = random.choice(range(0, 64, 4))
        addr = make_shared(shared_prefix, tag, fixed_set, offset)
        instr_B.append(f"read\t{to_hex32(addr)}")
        addrs.append(addr)
    chosen_tag = random.choice(tag_list)
    offset_w = random.choice(range(0, 64, 4))
    addr_w = make_shared(shared_prefix, chosen_tag, fixed_set, offset_w)
    data = to_hex32(random.getrandbits(32))
    instr_B.append(f"write\t{to_hex32(addr_w)}\t{data}")
    addrs.append(addr_w)
    offset_r2 = random.choice(range(0, 64, 4))
    addr_r2 = make_shared(shared_prefix, chosen_tag, fixed_set, offset_r2)
    instr_B.append(f"read\t{to_hex32(addr_r2)}")
    addrs.append(addr_r2)
    with open(path_A, "w") as f: pass
    with open(path_B, "w") as f:
        for l in instr_B: f.write(l + "\n")
    written = set()
    with open(path_mem, "w") as f:
        for a in addrs:
            base = a & ~0x3F
            if base in written: continue
            written.add(base)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(base)] + words) + "\n")
    print("testcase 66 created")
def testcase_67():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "subsystem_testcase/testcase_67/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_shared(p, t, s, o): return (p << 16) | (t << 10) | (s << 6) | o
    instr_A, instr_B, addrs = [], [], []
    used_tags = set()
    shared_prefix = random.choice([0x0002, 0x0003])
    fixed_set = random.randint(0, 0xF)
    n = random.randint(1, 3)
    for _ in range(n):
        while True:
            tag = random.randint(0, 0x3F)
            if tag not in used_tags:
                used_tags.add(tag)
                break
        offset = random.choice(range(0, 64, 4))
        addr = make_shared(shared_prefix, tag, fixed_set, offset)
        instr_B.append(f"read\t{to_hex32(addr)}")
        addrs.append(addr)
    while True:
        tag_w = random.randint(0, 0x3F)
        if tag_w not in used_tags:
            used_tags.add(tag_w)
            break
    offset_w = random.choice(range(0, 64, 4))
    addr_w = make_shared(shared_prefix, tag_w, fixed_set, offset_w)
    data_w = to_hex32(random.getrandbits(32))
    instr_B.append(f"write\t{to_hex32(addr_w)}\t{data_w}")
    addrs.append(addr_w)
    offset_r2 = random.choice(range(0, 64, 4))
    addr_r2 = make_shared(shared_prefix, tag_w, fixed_set, offset_r2)
    instr_B.append(f"read\t{to_hex32(addr_r2)}")
    addrs.append(addr_r2)
    with open(path_A, "w") as f: pass
    with open(path_B, "w") as f:
        for l in instr_B: f.write(l + "\n")
    written = set()
    with open(path_mem, "w") as f:
        for a in addrs:
            base = a & ~0x3F
            if base in written: continue
            written.add(base)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(base)] + words) + "\n")
    print("testcase 67 created")
def testcase_68():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "subsystem_testcase/testcase_68/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_shared(p, t, s, o): return (p << 16) | (t << 10) | (s << 6) | o
    instr_A, instr_B, addrs = [], [], []
    used_tags = set()
    shared_prefix = random.choice([0x0002, 0x0003])
    fixed_set = random.randint(0, 0xF)
    for _ in range(4):
        while True:
            tag = random.randint(0, 0x3F)
            if tag not in used_tags:
                used_tags.add(tag)
                break
        offset = random.choice(range(0, 64, 4))
        addr = make_shared(shared_prefix, tag, fixed_set, offset)
        instr_B.append(f"read\t{to_hex32(addr)}")
        addrs.append(addr)
    while True:
        tag_w = random.randint(0, 0x3F)
        if tag_w not in used_tags:
            used_tags.add(tag_w)
            break
    offset_w = random.choice(range(0, 64, 4))
    addr_w = make_shared(shared_prefix, tag_w, fixed_set, offset_w)
    data = to_hex32(random.getrandbits(32))
    instr_B.append(f"write\t{to_hex32(addr_w)}\t{data}")
    addrs.append(addr_w)
    offset_r2 = random.choice(range(0, 64, 4))
    addr_r2 = make_shared(shared_prefix, tag_w, fixed_set, offset_r2)
    instr_B.append(f"read\t{to_hex32(addr_r2)}")
    addrs.append(addr_r2)
    with open(path_A, "w") as f: pass
    with open(path_B, "w") as f:
        for l in instr_B: f.write(l + "\n")
    written = set()
    with open(path_mem, "w") as f:
        for a in addrs:
            base = a & ~0x3F
            if base in written: continue
            written.add(base)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(base)] + words) + "\n")
    print("testcase 68 created")
def testcase_69():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "subsystem_testcase/testcase_69/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_shared(p, t, s, o): return (p << 16) | (t << 10) | (s << 6) | o
    instr_A, instr_B, addrs = [], [], []
    used_tags = set()
    shared_prefix = random.choice([0x0002, 0x0003])
    fixed_set = random.randint(0, 0xF)
    for _ in range(5):
        while True:
            tag = random.randint(0, 0x3F)
            if tag not in used_tags:
                used_tags.add(tag)
                last_tag = tag
                break
        offset = random.choice(range(0, 64, 4))
        addr = make_shared(shared_prefix, tag, fixed_set, offset)
        data = to_hex32(random.getrandbits(32))
        instr_B.append(f"write\t{to_hex32(addr)}\t{data}")
        addrs.append(addr)
    offset_r = random.choice(range(0, 64, 4))
    addr_r = make_shared(shared_prefix, last_tag, fixed_set, offset_r)
    instr_B.append(f"read\t{to_hex32(addr_r)}")
    addrs.append(addr_r)
    with open(path_A, "w") as f: pass
    with open(path_B, "w") as f:
        for l in instr_B: f.write(l + "\n")
    written = set()
    with open(path_mem, "w") as f:
        for a in addrs:
            base = a & ~0x3F
            if base in written: continue
            written.add(base)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(base)] + words) + "\n")
    print("testcase 69 created")
def testcase_70():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "subsystem_testcase/testcase_70/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_shared(p, t, s, o): return (p << 16) | (t << 10) | (s << 6) | o
    instr_A, instr_B, addrs = [], [], []
    used_tags = set()
    used_sets = set()
    shared_prefix = random.choice([0x0002, 0x0003])
    fixed_set = random.randint(0, 0xF)

    used_sets.add(fixed_set)

    # 5 lệnh read/write ngẫu nhiên trong A, khác set
    for _ in range(10):
        while True:
            s = random.randint(0, 0xF)
            if s not in used_sets:
                used_sets.add(s)
                break
        tag = random.randint(0, 0x3F)
        offset = random.choice(range(0, 64, 4))
        addr = make_shared(shared_prefix, tag, s, offset)
        if random.choice([True, False]):
            instr_A.append(f"read\t{to_hex32(addr)}")
        else:
            data = to_hex32(random.getrandbits(32))
            instr_A.append(f"write\t{to_hex32(addr)}\t{data}")
        addrs.append(addr)

    n = random.randint(1, 3)
    for _ in range(n):
        while True:
            tag = random.randint(0, 0x3F)
            if tag not in used_tags:
                used_tags.add(tag)
                break
        offset = random.choice(range(0, 64, 4))
        addr = make_shared(shared_prefix, tag, fixed_set, offset)
        instr_A.append(f"read\t{to_hex32(addr)}")
        addrs.append(addr)
    while True:
        tag_w = random.randint(0, 0x3F)
        if tag_w not in used_tags:
            used_tags.add(tag_w)
            break
    offset_w = random.choice(range(0, 64, 4))
    addr_w = make_shared(shared_prefix, tag_w, fixed_set, offset_w)
    data = to_hex32(random.getrandbits(32))
    instr_A.append(f"write\t{to_hex32(addr_w)}\t{data}")
    addrs.append(addr_w)
    offset_r2 = random.choice(range(0, 64, 4))
    addr_r2 = make_shared(shared_prefix, tag_w, fixed_set, offset_r2)
    instr_A.append(f"read\t{to_hex32(addr_r2)}")
    addrs.append(addr_r2)
    offset_b = random.choice(range(0, 64, 4))
    addr_b = make_shared(shared_prefix, tag_w, fixed_set, offset_b)
    instr_B.append(f"read\t{to_hex32(addr_b)}")
    addrs.append(addr_b)
    with open(path_A, "w") as f:
        for l in instr_A: f.write(l + "\n")
    with open(path_B, "w") as f:
        for l in instr_B: f.write(l + "\n")
    written = set()
    with open(path_mem, "w") as f:
        for a in addrs:
            base = a & ~0x3F
            if base in written: continue
            written.add(base)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(base)] + words) + "\n")
    print("testcase 70 created")
def testcase_71():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "subsystem_testcase/testcase_71/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_shared(p, t, s, o): return (p << 16) | (t << 10) | (s << 6) | o
    instr_A, instr_B, addrs = [], [], []
    used_tags = set()
    shared_prefix = random.choice([0x0002, 0x0003])
    fixed_set = random.randint(0, 0xF)

    for _ in range(4):
        while True:
            tag = random.randint(0, 0x3F)
            if tag not in used_tags:
                used_tags.add(tag)
                break
        offset = random.choice(range(0, 64, 4))
        addr = make_shared(shared_prefix, tag, fixed_set, offset)
        instr_B.append(f"read\t{to_hex32(addr)}")
        addrs.append(addr)

    while True:
        tag_w = random.randint(0, 0x3F)
        if tag_w not in used_tags:
            used_tags.add(tag_w)
            break
    offset_w = random.choice(range(0, 64, 4))
    addr_w = make_shared(shared_prefix, tag_w, fixed_set, offset_w)
    data = to_hex32(random.getrandbits(32))
    instr_B.append(f"write\t{to_hex32(addr_w)}\t{data}")
    addrs.append(addr_w)

    offset_r2 = random.choice(range(0, 64, 4))
    addr_r2 = make_shared(shared_prefix, tag_w, fixed_set, offset_r2)
    instr_B.append(f"read\t{to_hex32(addr_r2)}")
    addrs.append(addr_r2)

    offset_a = random.choice(range(0, 64, 4))
    addr_a = make_shared(shared_prefix, tag_w, fixed_set, offset_a)
    instr_A.append(f"read\t{to_hex32(addr_a)}")
    addrs.append(addr_a)

    with open(path_A, "w") as f:
        for l in instr_A: f.write(l + "\n")
    with open(path_B, "w") as f:
        for l in instr_B: f.write(l + "\n")

    written = set()
    with open(path_mem, "w") as f:
        for a in addrs:
            base = a & ~0x3F
            if base in written: continue
            written.add(base)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(base)] + words) + "\n")
    print("testcase 71 created")
def testcase_72():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "subsystem_testcase/testcase_72/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_shared(p, t, s, o): return (p << 16) | (t << 10) | (s << 6) | o
    instr_A, instr_B, addrs = [], [], []
    used_tags = set()
    shared_prefix = random.choice([0x0002, 0x0003])
    fixed_set = random.randint(0, 0xF)

    for _ in range(5):
        while True:
            tag = random.randint(0, 0x3F)
            if tag not in used_tags:
                used_tags.add(tag)
                last_tag = tag
                break
        offset = random.choice(range(0, 64, 4))
        addr = make_shared(shared_prefix, tag, fixed_set, offset)
        data = to_hex32(random.getrandbits(32))
        instr_B.append(f"write\t{to_hex32(addr)}\t{data}")
        addrs.append(addr)

    offset_r = random.choice(range(0, 64, 4))
    addr_r = make_shared(shared_prefix, last_tag, fixed_set, offset_r)
    instr_B.append(f"read\t{to_hex32(addr_r)}")
    addrs.append(addr_r)

    offset_a = random.choice(range(0, 64, 4))
    addr_a = make_shared(shared_prefix, last_tag, fixed_set, offset_a)
    instr_A.append(f"read\t{to_hex32(addr_a)}")
    addrs.append(addr_a)

    with open(path_A, "w") as f:
        for l in instr_A: f.write(l + "\n")
    with open(path_B, "w") as f:
        for l in instr_B: f.write(l + "\n")

    written = set()
    with open(path_mem, "w") as f:
        for a in addrs:
            base = a & ~0x3F
            if base in written: continue
            written.add(base)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(base)] + words) + "\n")
    print("testcase 72 created")
def testcase_73():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "subsystem_testcase/testcase_73/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_shared(p, t, s, o): return (p << 16) | (t << 10) | (s << 6) | o

    instr_A, instr_B, addrs = [], [], []
    used_tags = set()
    used_sets = set()
    shared_prefix = random.choice([0x0002, 0x0003])
    fixed_set = random.randint(0, 0xF)

    # 4 WRITE + 1 READ khác tag trong A
    # 4 WRITE khác tag trong A
    for _ in range(4):
        while True:
            tag = random.randint(0, 0x3F)
            if tag not in used_tags:
                used_tags.add(tag)
                break
        offset = random.choice(range(0, 64, 4))
        addr = make_shared(shared_prefix, tag, fixed_set, offset)
        data = to_hex32(random.getrandbits(32))
        instr_A.append(f"write\t{to_hex32(addr)}\t{data}")
        addrs.append(addr)

    # 1 READ trong A (tag khác)
    while True:
        tag_read = random.randint(0, 0x3F)
        if tag_read not in used_tags:
            used_tags.add(tag_read)
            break
    offset_r = random.choice(range(0, 64, 4))
    addr_r = make_shared(shared_prefix, tag_read, fixed_set, offset_r)
    instr_A.append(f"read\t{to_hex32(addr_r)}")
    addrs.append(addr_r)

    # B: read trùng địa chỉ cuối của A
    addr_match = make_shared(shared_prefix, tag_read, fixed_set, random.choice(range(0, 64, 4)))
    instr_B.append(f"read\t{to_hex32(addr_match)}")
    addrs.append(addr_match)

    # Tạo 10 read/write ngẫu nhiên khác set
    used_sets.add(fixed_set)
    for _ in range(10):
        while True:
            new_set = random.randint(0, 0xF)
            if new_set not in used_sets:
                used_sets.add(new_set)
                break
        tag = random.randint(0, 0x3F)
        offset = random.choice(range(0, 64, 4))
        addr = make_shared(shared_prefix, tag, new_set, offset)
        if random.choice([True, False]):
            instr_B.append(f"read\t{to_hex32(addr)}")
        else:
            data = to_hex32(random.getrandbits(32))
            instr_B.append(f"write\t{to_hex32(addr)}\t{data}")
        addrs.append(addr)

    # WRITE cuối cùng trùng tag/set với lệnh READ cuối của A
    addr_w = make_shared(shared_prefix, tag_read, fixed_set, random.choice(range(0, 64, 4)))
    data_w = to_hex32(random.getrandbits(32))
    instr_B.append(f"write\t{to_hex32(addr_w)}\t{data_w}")
    addrs.append(addr_w)

    with open(path_A, "w") as f:
        for l in instr_A: f.write(l + "\n")
    with open(path_B, "w") as f:
        for l in instr_B: f.write(l + "\n")

    written = set()
    with open(path_mem, "w") as f:
        for a in addrs:
            base = a & ~0x3F
            if base in written: continue
            written.add(base)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(base)] + words) + "\n")
    print("testcase 73 created")
def testcase_74():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "subsystem_testcase/testcase_74/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_shared(p, t, s, o): return (p << 16) | (t << 10) | (s << 6) | o

    instr_A, instr_B, addrs = [], [], []
    used_tags = set()
    used_sets = set()
    shared_prefix = random.choice([0x0002, 0x0003])
    fixed_set = random.randint(0, 0xF)

    # 4 WRITE trong A
    for _ in range(4):
        while True:
            tag = random.randint(0, 0x3F)
            if tag not in used_tags:
                used_tags.add(tag)
                break
        offset = random.choice(range(0, 64, 4))
        addr = make_shared(shared_prefix, tag, fixed_set, offset)
        data = to_hex32(random.getrandbits(32))
        instr_A.append(f"write\t{to_hex32(addr)}\t{data}")
        addrs.append(addr)

    # 1 READ cuối trong A
    while True:
        tag_r = random.randint(0, 0x3F)
        if tag_r not in used_tags:
            used_tags.add(tag_r)
            break
    offset_r = random.choice(range(0, 64, 4))
    addr_r = make_shared(shared_prefix, tag_r, fixed_set, offset_r)
    instr_A.append(f"read\t{to_hex32(addr_r)}")
    addrs.append(addr_r)

    # B: 1 read trùng logic với lệnh cuối của A
    offset_b1 = random.choice(range(0, 64, 4))
    addr_b1 = make_shared(shared_prefix, tag_r, fixed_set, offset_b1)
    instr_B.append(f"read\t{to_hex32(addr_b1)}")
    addrs.append(addr_b1)
    used_sets.add(fixed_set)

    # 5 READ khác set
    for _ in range(5):
        while True:
            s = random.randint(0, 0xF)
            if s not in used_sets:
                used_sets.add(s)
                break
        tag = random.randint(0, 0x3F)
        offset = random.choice(range(0, 64, 4))
        addr = make_shared(shared_prefix, tag, s, offset)
        instr_B.append(f"read\t{to_hex32(addr)}")
        addrs.append(addr)

    # 1 WRITE khác set (với read đầu tiên trong B)
    while True:
        s = random.randint(0, 0xF)
        if s != fixed_set and s not in used_sets:
            used_sets.add(s)
            break
    tag_w = random.randint(0, 0x3F)
    offset = random.choice(range(0, 64, 4))
    addr = make_shared(shared_prefix, tag_w, s, offset)
    data = to_hex32(random.getrandbits(32))
    instr_B.append(f"write\t{to_hex32(addr)}\t{data}")
    addrs.append(addr)

    with open(path_A, "w") as f:
        for l in instr_A: f.write(l + "\n")
    with open(path_B, "w") as f:
        for l in instr_B: f.write(l + "\n")
    written = set()
    with open(path_mem, "w") as f:
        for a in addrs:
            base = a & ~0x3F
            if base in written: continue
            written.add(base)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(base)] + words) + "\n")
    print("testcase 74 created")
def testcase_75():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "subsystem_testcase/testcase_75/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_shared(p, t, s, o): return (p << 16) | (t << 10) | (s << 6) | o

    instr_A, instr_B, addrs = [], [], []
    used_tags = set()
    used_sets = set()
    shared_prefix = random.choice([0x0002, 0x0003])
    fixed_set = random.randint(0, 0xF)

    # 5 WRITE trong A
    for _ in range(5):
        while True:
            tag = random.randint(0, 0x3F)
            if tag not in used_tags:
                used_tags.add(tag)
                last_tag = tag
                break
        offset = random.choice(range(0, 64, 4))
        addr = make_shared(shared_prefix, last_tag, fixed_set, offset)
        data = to_hex32(random.getrandbits(32))
        instr_A.append(f"write\t{to_hex32(addr)}\t{data}")
        addrs.append(addr)

    used_sets.add(fixed_set)

    # 1 READ khác set trong A
    while True:
        read_set_a = random.randint(0, 0xF)
        if read_set_a not in used_sets:
            used_sets.add(read_set_a)
            break
    tag_read_a = random.randint(0, 0x3F)
    offset = random.choice(range(0, 64, 4))
    addr_read_a = make_shared(shared_prefix, tag_read_a, read_set_a, offset)
    instr_A.append(f"read\t{to_hex32(addr_read_a)}")
    addrs.append(addr_read_a)

    # 1 READ trong B trùng với WRITE cuối cùng trong A
    offset_b0 = random.choice(range(0, 64, 4))
    addr_b0 = make_shared(shared_prefix, last_tag, fixed_set, offset_b0)
    instr_B.append(f"read\t{to_hex32(addr_b0)}")
    addrs.append(addr_b0)

    # 10 read/write ngẫu nhiên, khác set
    for _ in range(10):
        while True:
            s = random.randint(0, 0xF)
            if s not in used_sets:
                used_sets.add(s)
                break
        tag = random.randint(0, 0x3F)
        offset = random.choice(range(0, 64, 4))
        addr = make_shared(shared_prefix, tag, s, offset)
        if random.choice([True, False]):
            instr_B.append(f"read\t{to_hex32(addr)}")
        else:
            data = to_hex32(random.getrandbits(32))
            instr_B.append(f"write\t{to_hex32(addr)}\t{data}")
        addrs.append(addr)

    # 1 READ trong B trùng với READ cuối trong A
    offset_last = random.choice(range(0, 64, 4))
    addr_final = make_shared(shared_prefix, tag_read_a, read_set_a, offset_last)
    instr_B.append(f"read\t{to_hex32(addr_final)}")
    addrs.append(addr_final)

    with open(path_A, "w") as f:
        for l in instr_A: f.write(l + "\n")
    with open(path_B, "w") as f:
        for l in instr_B: f.write(l + "\n")
    written = set()
    with open(path_mem, "w") as f:
        for a in addrs:
            base = a & ~0x3F
            if base in written: continue
            written.add(base)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(base)] + words) + "\n")
    print("testcase 75 created")
def testcase_76():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "subsystem_testcase/testcase_76/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_shared(p, t, s, o): return (p << 16) | (t << 10) | (s << 6) | o

    instr_A, instr_B, addrs = [], [], []
    used_tags = set()
    used_sets = set()
    shared_prefix = random.choice([0x0002, 0x0003])
    fixed_set = random.randint(0, 0xF)

    # 5 WRITE cùng set, khác tag trong A
    for _ in range(5):
        while True:
            tag = random.randint(0, 0x3F)
            if tag not in used_tags:
                used_tags.add(tag)
                last_tag = tag
                break
        offset = random.choice(range(0, 64, 4))
        addr = make_shared(shared_prefix, last_tag, fixed_set, offset)
        data = to_hex32(random.getrandbits(32))
        instr_A.append(f"write\t{to_hex32(addr)}\t{data}")
        addrs.append(addr)
    used_sets.add(fixed_set)

    # 1 READ trong B trùng với write cuối của A
    offset_b0 = random.choice(range(0, 64, 4))
    addr_b0 = make_shared(shared_prefix, last_tag, fixed_set, offset_b0)
    instr_B.append(f"read\t{to_hex32(addr_b0)}")
    addrs.append(addr_b0)

    # 5 lệnh read/write ngẫu nhiên khác set
    for _ in range(5):
        while True:
            s = random.randint(0, 0xF)
            if s not in used_sets:
                used_sets.add(s)
                break
        tag = random.randint(0, 0x3F)
        offset = random.choice(range(0, 64, 4))
        addr = make_shared(shared_prefix, tag, s, offset)
        if random.choice([True, False]):
            instr_B.append(f"read\t{to_hex32(addr)}")
        else:
            data = to_hex32(random.getrandbits(32))
            instr_B.append(f"write\t{to_hex32(addr)}\t{data}")
        addrs.append(addr)

    # 1 READ cuối trong B với set khác WRITE cuối của A
    while True:
        new_set = random.randint(0, 0xF)
        if new_set != fixed_set and new_set not in used_sets:
            break
    tag_r2 = random.randint(0, 0x3F)
    offset = random.choice(range(0, 64, 4))
    addr_r2 = make_shared(shared_prefix, tag_r2, new_set, offset)
    instr_B.append(f"read\t{to_hex32(addr_r2)}")
    addrs.append(addr_r2)

    with open(path_A, "w") as f:
        for l in instr_A: f.write(l + "\n")
    with open(path_B, "w") as f:
        for l in instr_B: f.write(l + "\n")
    written = set()
    with open(path_mem, "w") as f:
        for a in addrs:
            base = a & ~0x3F
            if base in written: continue
            written.add(base)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(base)] + words) + "\n")
    print("testcase 76 created")
def testcase_77():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "subsystem_testcase/testcase_77/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_shared(p, t, s, o): return (p << 16) | (t << 10) | (s << 6) | o

    instr_A, instr_B, addrs = [], [], []
    used_tags = set()
    used_sets = set()
    shared_prefix = random.choice([0x0002, 0x0003])
    fixed_set = random.randint(0, 0xF)

    # 4 WRITE trong B
    for _ in range(4):
        while True:
            tag = random.randint(0, 0x3F)
            if tag not in used_tags:
                used_tags.add(tag)
                break
        offset = random.choice(range(0, 64, 4))
        addr = make_shared(shared_prefix, tag, fixed_set, offset)
        data = to_hex32(random.getrandbits(32))
        instr_B.append(f"write\t{to_hex32(addr)}\t{data}")
        addrs.append(addr)

    # 1 READ trong B (khác tag)
    while True:
        tag_r = random.randint(0, 0x3F)
        if tag_r not in used_tags:
            used_tags.add(tag_r)
            break
    offset_r = random.choice(range(0, 64, 4))
    addr_r = make_shared(shared_prefix, tag_r, fixed_set, offset_r)
    instr_B.append(f"read\t{to_hex32(addr_r)}")
    addrs.append(addr_r)

    # A: 1 READ trùng logic với lệnh cuối của B
    offset_a0 = random.choice(range(0, 64, 4))
    addr_a0 = make_shared(shared_prefix, tag_r, fixed_set, offset_a0)
    instr_A.append(f"read\t{to_hex32(addr_a0)}")
    addrs.append(addr_a0)

    used_sets.add(fixed_set)

    # 5 lệnh read/write ngẫu nhiên trong A, khác set
    for _ in range(10):
        while True:
            s = random.randint(0, 0xF)
            if s not in used_sets:
                used_sets.add(s)
                break
        tag = random.randint(0, 0x3F)
        offset = random.choice(range(0, 64, 4))
        addr = make_shared(shared_prefix, tag, s, offset)
        if random.choice([True, False]):
            instr_A.append(f"read\t{to_hex32(addr)}")
        else:
            data = to_hex32(random.getrandbits(32))
            instr_A.append(f"write\t{to_hex32(addr)}\t{data}")
        addrs.append(addr)

    # 1 WRITE cuối trong A trùng logic với lệnh READ cuối của B
    offset_a_last = random.choice(range(0, 64, 4))
    addr_a_last = make_shared(shared_prefix, tag_r, fixed_set, offset_a_last)
    data_last = to_hex32(random.getrandbits(32))
    instr_A.append(f"write\t{to_hex32(addr_a_last)}\t{data_last}")
    addrs.append(addr_a_last)

    with open(path_A, "w") as f:
        for l in instr_A: f.write(l + "\n")
    with open(path_B, "w") as f:
        for l in instr_B: f.write(l + "\n")

    written = set()
    with open(path_mem, "w") as f:
        for a in addrs:
            base = a & ~0x3F
            if base in written: continue
            written.add(base)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(base)] + words) + "\n")

    print("testcase 77 created")
def testcase_78():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "subsystem_testcase/testcase_78/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_shared(p, t, s, o): return (p << 16) | (t << 10) | (s << 6) | o

    instr_A, instr_B, addrs = [], [], []
    used_tags = set()
    used_sets = set()
    shared_prefix = random.choice([0x0002, 0x0003])
    fixed_set = random.randint(0, 0xF)

    # B: 4 write
    for _ in range(4):
        while True:
            tag = random.randint(0, 0x3F)
            if tag not in used_tags:
                used_tags.add(tag)
                break
        offset = random.choice(range(0, 64, 4))
        addr = make_shared(shared_prefix, tag, fixed_set, offset)
        data = to_hex32(random.getrandbits(32))
        instr_B.append(f"write\t{to_hex32(addr)}\t{data}")
        addrs.append(addr)

    # B: 1 read (khác tag)
    while True:
        tag_r = random.randint(0, 0x3F)
        if tag_r not in used_tags:
            used_tags.add(tag_r)
            break
    offset_r = random.choice(range(0, 64, 4))
    addr_r = make_shared(shared_prefix, tag_r, fixed_set, offset_r)
    instr_B.append(f"read\t{to_hex32(addr_r)}")
    addrs.append(addr_r)

    # A: 1 read trùng logic với read cuối của B
    offset_a0 = random.choice(range(0, 64, 4))
    addr_a0 = make_shared(shared_prefix, tag_r, fixed_set, offset_a0)
    instr_A.append(f"read\t{to_hex32(addr_a0)}")
    addrs.append(addr_a0)

    used_sets.add(fixed_set)

    # A: 5 read khác set
    for _ in range(5):
        while True:
            s = random.randint(0, 0xF)
            if s not in used_sets:
                used_sets.add(s)
                break
        tag = random.randint(0, 0x3F)
        offset = random.choice(range(0, 64, 4))
        addr = make_shared(shared_prefix, tag, s, offset)
        instr_A.append(f"read\t{to_hex32(addr)}")
        addrs.append(addr)

    # A: 1 write khác set với lệnh read đầu tiên trong A (set = fixed_set, đã tránh)
    while True:
        s = random.randint(0, 0xF)
        if s not in used_sets:
            break
    tag_w = random.randint(0, 0x3F)
    offset = random.choice(range(0, 64, 4))
    addr = make_shared(shared_prefix, tag_w, s, offset)
    data = to_hex32(random.getrandbits(32))
    instr_A.append(f"write\t{to_hex32(addr)}\t{data}")
    addrs.append(addr)

    with open(path_A, "w") as f:
        for l in instr_A: f.write(l + "\n")
    with open(path_B, "w") as f:
        for l in instr_B: f.write(l + "\n")

    written = set()
    with open(path_mem, "w") as f:
        for a in addrs:
            base = a & ~0x3F
            if base in written: continue
            written.add(base)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(base)] + words) + "\n")

    print("testcase 78 created")
def testcase_79():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "subsystem_testcase/testcase_79/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_shared(p, t, s, o): return (p << 16) | (t << 10) | (s << 6) | o

    instr_A, instr_B, addrs = [], [], []
    used_tags = set()
    used_sets = set()
    shared_prefix = random.choice([0x0002, 0x0003])
    fixed_set = random.randint(0, 0xF)

    # B: 5 write cùng set, khác tag
    for _ in range(5):
        while True:
            tag = random.randint(0, 0x3F)
            if tag not in used_tags:
                used_tags.add(tag)
                last_tag = tag
                break
        offset = random.choice(range(0, 64, 4))
        addr = make_shared(shared_prefix, last_tag, fixed_set, offset)
        data = to_hex32(random.getrandbits(32))
        instr_B.append(f"write\t{to_hex32(addr)}\t{data}")
        addrs.append(addr)
    used_sets.add(fixed_set)

    # B: 1 read khác set
    while True:
        read_set_b = random.randint(0, 0xF)
        if read_set_b not in used_sets:
            used_sets.add(read_set_b)
            break
    tag_rb = random.randint(0, 0x3F)
    offset = random.choice(range(0, 64, 4))
    addr_rb = make_shared(shared_prefix, tag_rb, read_set_b, offset)
    instr_B.append(f"read\t{to_hex32(addr_rb)}")
    addrs.append(addr_rb)

    # A: 1 read giống write cuối của B
    offset_a0 = random.choice(range(0, 64, 4))
    addr_a0 = make_shared(shared_prefix, last_tag, fixed_set, offset_a0)
    instr_A.append(f"read\t{to_hex32(addr_a0)}")
    addrs.append(addr_a0)

    # A: 10 lệnh read/write khác set
    for _ in range(10):
        while True:
            s = random.randint(0, 0xF)
            if s not in used_sets:
                used_sets.add(s)
                break
        tag = random.randint(0, 0x3F)
        offset = random.choice(range(0, 64, 4))
        addr = make_shared(shared_prefix, tag, s, offset)
        if random.choice([True, False]):
            instr_A.append(f"read\t{to_hex32(addr)}")
        else:
            data = to_hex32(random.getrandbits(32))
            instr_A.append(f"write\t{to_hex32(addr)}\t{data}")
        addrs.append(addr)

    # A: 1 read giống read cuối của B
    offset_afinal = random.choice(range(0, 64, 4))
    addr_afinal = make_shared(shared_prefix, tag_rb, read_set_b, offset_afinal)
    instr_A.append(f"read\t{to_hex32(addr_afinal)}")
    addrs.append(addr_afinal)

    with open(path_A, "w") as f:
        for l in instr_A: f.write(l + "\n")
    with open(path_B, "w") as f:
        for l in instr_B: f.write(l + "\n")

    written = set()
    with open(path_mem, "w") as f:
        for a in addrs:
            base = a & ~0x3F
            if base in written: continue
            written.add(base)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(base)] + words) + "\n")

    print("testcase 79 created")
def testcase_80():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "subsystem_testcase/testcase_80/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_shared(p, t, s, o): return (p << 16) | (t << 10) | (s << 6) | o

    instr_A, instr_B, addrs = [], [], []
    used_tags = set()
    used_sets = set()
    shared_prefix = random.choice([0x0002, 0x0003])
    fixed_set = random.randint(0, 0xF)

    # B: 5 write cùng set, khác tag
    for _ in range(5):
        while True:
            tag = random.randint(0, 0x3F)
            if tag not in used_tags:
                used_tags.add(tag)
                last_tag = tag
                break
        offset = random.choice(range(0, 64, 4))
        addr = make_shared(shared_prefix, last_tag, fixed_set, offset)
        data = to_hex32(random.getrandbits(32))
        instr_B.append(f"write\t{to_hex32(addr)}\t{data}")
        addrs.append(addr)
    used_sets.add(fixed_set)

    # A: 1 read trùng với write cuối của B
    offset_a0 = random.choice(range(0, 64, 4))
    addr_a0 = make_shared(shared_prefix, last_tag, fixed_set, offset_a0)
    instr_A.append(f"read\t{to_hex32(addr_a0)}")
    addrs.append(addr_a0)

    # A: 5 lệnh read/write ngẫu nhiên khác set
    for _ in range(5):
        while True:
            s = random.randint(0, 0xF)
            if s not in used_sets:
                used_sets.add(s)
                break
        tag = random.randint(0, 0x3F)
        offset = random.choice(range(0, 64, 4))
        addr = make_shared(shared_prefix, tag, s, offset)
        if random.choice([True, False]):
            instr_A.append(f"read\t{to_hex32(addr)}")
        else:
            data = to_hex32(random.getrandbits(32))
            instr_A.append(f"write\t{to_hex32(addr)}\t{data}")
        addrs.append(addr)

    # A: 1 read có set khác set của write cuối trong B
    while True:
        other_set = random.randint(0, 0xF)
        if other_set != fixed_set and other_set not in used_sets:
            break
    tag_r2 = random.randint(0, 0x3F)
    offset = random.choice(range(0, 64, 4))
    addr_r2 = make_shared(shared_prefix, tag_r2, other_set, offset)
    instr_A.append(f"read\t{to_hex32(addr_r2)}")
    addrs.append(addr_r2)

    with open(path_A, "w") as f:
        for l in instr_A: f.write(l + "\n")
    with open(path_B, "w") as f:
        for l in instr_B: f.write(l + "\n")

    written = set()
    with open(path_mem, "w") as f:
        for a in addrs:
            base = a & ~0x3F
            if base in written: continue
            written.add(base)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(base)] + words) + "\n")

    print("testcase 80 created")
def testcase_81():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "subsystem_testcase/testcase_81/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_shared(p, t, s, o): return (p << 16) | (t << 10) | (s << 6) | o

    instr_A, instr_B, addrs = [], [], []
    shared_prefix = random.choice([0x0002, 0x0003])
    used_pairs = set()
    used_sets = set()

    # A: 2 read, khác set và tag
    read_refs = []
    while len(read_refs) < 2:
        tag = random.randint(0, 0x3F)
        set_ = random.randint(0, 0xF)
        if (tag, set_) not in used_pairs:
            used_pairs.add((tag, set_))
            used_sets.add(set_)
            offset = random.choice(range(0, 64, 4))
            addr = make_shared(shared_prefix, tag, set_, offset)
            instr_A.append(f"read\t{to_hex32(addr)}")
            addrs.append(addr)
            read_refs.append((tag, set_))

    # --- Thêm 2 lệnh read vào giữa ở A ---
    middle_reads_A = []
    middle_sets_A = set()
    while len(middle_reads_A) < 2:
        set_ = random.randint(0, 0xF)
        if set_ not in used_sets and set_ not in middle_sets_A:
            tag = random.randint(0, 0x3F)
            offset = random.choice(range(0, 64, 4))
            addr = make_shared(shared_prefix, tag, set_, offset)
            middle_reads_A.append(f"read\t{to_hex32(addr)}")
            addrs.append(addr)
            middle_sets_A.add(set_)
            used_sets.add(set_)
    # Chèn 2 lệnh này vào giữa
    instr_A = [instr_A[0]] + middle_reads_A + [instr_A[1]]

    # B: 1 read giống với A[1]
    tag1, set1 = read_refs[1]
    offset_b1 = random.choice(range(0, 64, 4))
    addr_b1 = make_shared(shared_prefix, tag1, set1, offset_b1)
    instr_B.append(f"read\t{to_hex32(addr_b1)}")
    addrs.append(addr_b1)
    # B: Thêm 2 lệnh read giữa 2 read B (giống như A, phải khác các set đã dùng!)
    middle_reads_B = []
    middle_sets_B = set()
    while len(middle_reads_B) < 2:
        set_ = random.randint(0, 0xF)
        if set_ not in used_sets and set_ not in middle_sets_B:
            tag = random.randint(0, 0x3F)
            offset = random.choice(range(0, 64, 4))
            addr = make_shared(shared_prefix, tag, set_, offset)
            middle_reads_B.append(f"read\t{to_hex32(addr)}")
            addrs.append(addr)
            middle_sets_B.add(set_)
            used_sets.add(set_)
    # B: 1 read giống với A[0]
    tag0, set0 = read_refs[0]
    offset_b0 = random.choice(range(0, 64, 4))
    addr_b0 = make_shared(shared_prefix, tag0, set0, offset_b0)
    # Chèn vào đúng giữa
    instr_B = [instr_B[0]] + middle_reads_B + [f"read\t{to_hex32(addr_b0)}"]

    with open(path_A, "w") as f:
        for l in instr_A: f.write(l + "\n")
    with open(path_B, "w") as f:
        for l in instr_B: f.write(l + "\n")

    written = set()
    with open(path_mem, "w") as f:
        for a in addrs:
            base = a & ~0x3F
            if base in written: continue
            written.add(base)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(base)] + words) + "\n")

    print("testcase 81 created")

def testcase_82():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "subsystem_testcase/testcase_82/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_shared(p, t, s, o): return (p << 16) | (t << 10) | (s << 6) | o

    instr_A, instr_B, addrs = [], [], []
    shared_prefix = random.choice([0x0002, 0x0003])
    used_sets = set()

    # Sinh 3 lệnh read đầu cho A (set khác nhau)
    read_addrs_A = []
    for _ in range(3):
        while True:
            tag = random.randint(0, 0x3F)
            set_ = random.randint(0, 0xF)
            if set_ not in used_sets:
                used_sets.add(set_)
                offset = random.choice(range(0, 64, 4))
                addr = make_shared(shared_prefix, tag, set_, offset)
                instr_A.append(f"read\t{to_hex32(addr)}")
                addrs.append(addr)
                read_addrs_A.append((tag, set_, offset))
                break

    # Lệnh read cuối của A (tag/set/offset random, set khác 3 cái trên)
    while True:
        tag = random.randint(0, 0x3F)
        set_ = random.randint(0, 0xF)
        if set_ not in used_sets:
            used_sets.add(set_)
            offset = random.choice(range(0, 64, 4))
            addr_A4 = make_shared(shared_prefix, tag, set_, offset)
            instr_A.append(f"read\t{to_hex32(addr_A4)}")
            addrs.append(addr_A4)
            last_tag, last_set, last_offset = tag, set_, offset
            break

    # IMEM B: lệnh đầu trùng hệt lệnh read cuối của A
    instr_B.append(f"read\t{to_hex32(addr_A4)}")
    addrs.append(addr_A4)
    used_sets_B = set([last_set])  # set đã dùng ở B

    # Sinh 3 lệnh read tiếp theo cho B (set khác hoàn toàn, không trùng 4 set A và các set B đã dùng)
    for _ in range(3):
        while True:
            tag = random.randint(0, 0x3F)
            set_ = random.randint(0, 0xF)
            if set_ not in used_sets and set_ not in used_sets_B:
                used_sets_B.add(set_)
                offset = random.choice(range(0, 64, 4))
                addr = make_shared(shared_prefix, tag, set_, offset)
                instr_B.append(f"read\t{to_hex32(addr)}")
                addrs.append(addr)
                break

    with open(path_A, "w") as f:
        for l in instr_A: f.write(l + "\n")
    with open(path_B, "w") as f:
        for l in instr_B: f.write(l + "\n")

    written = set()
    with open(path_mem, "w") as f:
        for a in addrs:
            base = a & ~0x3F
            if base in written: continue
            written.add(base)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(base)] + words) + "\n")

    print("testcase 82 created")

def testcase_83():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "subsystem_testcase/testcase_83/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_shared(p, t, s, o): return (p << 16) | (t << 10) | (s << 6) | o

    instr_A, instr_B, addrs = [], [], []
    shared_prefix = random.choice([0x0002, 0x0003])
    used_pairs = set()
    used_sets = set()

    # B: 2 read, khác set và tag
    read_refs = []
    while len(read_refs) < 2:
        tag = random.randint(0, 0x3F)
        set_ = random.randint(0, 0xF)
        if (tag, set_) not in used_pairs:
            used_pairs.add((tag, set_))
            used_sets.add(set_)
            offset = random.choice(range(0, 64, 4))
            addr = make_shared(shared_prefix, tag, set_, offset)
            instr_B.append(f"read\t{to_hex32(addr)}")
            addrs.append(addr)
            read_refs.append((tag, set_))

    # A: 1 read giống với B[1]
    tag1, set1 = read_refs[1]
    offset_a1 = random.choice(range(0, 64, 4))
    addr_a1 = make_shared(shared_prefix, tag1, set1, offset_a1)
    instr_A.append(f"read\t{to_hex32(addr_a1)}")
    addrs.append(addr_a1)

    # A: 1 read khác set với B[0]
    while True:
        set2 = random.randint(0, 0xF)
        if set2 != read_refs[0][1] and set2 not in used_sets:
            break
    tag2 = random.randint(0, 0x3F)
    offset_a2 = random.choice(range(0, 64, 4))
    addr_a2 = make_shared(shared_prefix, tag2, set2, offset_a2)
    instr_A.append(f"read\t{to_hex32(addr_a2)}")
    addrs.append(addr_a2)

    with open(path_A, "w") as f:
        for l in instr_A: f.write(l + "\n")
    with open(path_B, "w") as f:
        for l in instr_B: f.write(l + "\n")

    written = set()
    with open(path_mem, "w") as f:
        for a in addrs:
            base = a & ~0x3F
            if base in written: continue
            written.add(base)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(base)] + words) + "\n")

    print("testcase 83 created")
def testcase_84():
    import random, os
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "subsystem_testcase/testcase_84/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_shared(p, t, s, o): return (p << 16) | (t << 10) | (s << 6) | o

    shared_prefix = random.choice([0x0002, 0x0003])

    # --- Chọn set cho IMEM A (4 số khác nhau)
    sets_A = random.sample(range(0, 16), 4)
    set_r = sets_A[0]    # cho read đầu A và write cuối B
    set_m1 = sets_A[1]
    set_m2 = sets_A[2]
    set_w = sets_A[3]    # cho write cuối A và read đầu B

    # --- Chọn set cho IMEM B (4 số khác nhau), đầu là set_w, cuối là set_r ---
    # Chọn 2 set khác hẳn set_w, set_r, nhau
    sets_remain = [x for x in range(16) if x not in {set_w, set_r}]
    b1, b2 = random.sample(sets_remain, 2)

    # --- IMEM A ---
    instr_A, instr_B, addrs = [], [], []

    tag_r = random.randint(0, 0x3F)
    offset_r = random.choice(range(0, 64, 4))
    addr_r = make_shared(shared_prefix, tag_r, set_r, offset_r)
    instr_A.append(f"read\t{to_hex32(addr_r)}")
    addrs.append(addr_r)

    tag_m1 = random.randint(0, 0x3F)
    offset_m1 = random.choice(range(0, 64, 4))
    addr_m1 = make_shared(shared_prefix, tag_m1, set_m1, offset_m1)
    instr_A.append(f"read\t{to_hex32(addr_m1)}")
    addrs.append(addr_m1)

    tag_m2 = random.randint(0, 0x3F)
    offset_m2 = random.choice(range(0, 64, 4))
    addr_m2 = make_shared(shared_prefix, tag_m2, set_m2, offset_m2)
    instr_A.append(f"read\t{to_hex32(addr_m2)}")
    addrs.append(addr_m2)

    tag_w = random.randint(0, 0x3F)
    offset_w = random.choice(range(0, 64, 4))
    addr_w = make_shared(shared_prefix, tag_w, set_w, offset_w)
    data_w = to_hex32(random.getrandbits(32))
    instr_A.append(f"write\t{to_hex32(addr_w)}\t{data_w}")
    addrs.append(addr_w)

    # --- IMEM B ---
    # read đầu: giống write cuối cùng của A
    offset_b0 = random.choice(range(0, 64, 4))
    addr_b0 = make_shared(shared_prefix, tag_w, set_w, offset_b0)
    instr_B.append(f"read\t{to_hex32(addr_b0)}")
    addrs.append(addr_b0)

    tag_b1 = random.randint(0, 0x3F)
    offset_b1 = random.choice(range(0, 64, 4))
    addr_b1 = make_shared(shared_prefix, tag_b1, b1, offset_b1)
    instr_B.append(f"read\t{to_hex32(addr_b1)}")
    addrs.append(addr_b1)

    tag_b2 = random.randint(0, 0x3F)
    offset_b2 = random.choice(range(0, 64, 4))
    addr_b2 = make_shared(shared_prefix, tag_b2, b2, offset_b2)
    instr_B.append(f"read\t{to_hex32(addr_b2)}")
    addrs.append(addr_b2)

    # write cuối: giống read đầu của A
    offset_b3 = random.choice(range(0, 64, 4))
    addr_b3 = make_shared(shared_prefix, tag_r, set_r, offset_b3)
    data_b3 = to_hex32(random.getrandbits(32))
    instr_B.append(f"write\t{to_hex32(addr_b3)}\t{data_b3}")
    addrs.append(addr_b3)

    # Ghi file
    with open(path_A, "w") as f:
        for l in instr_A: f.write(l + "\n")
    with open(path_B, "w") as f:
        for l in instr_B: f.write(l + "\n")
    written = set()
    with open(path_mem, "w") as f:
        for a in addrs:
            base = a & ~0x3F
            if base in written: continue
            written.add(base)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(base)] + words) + "\n")
    print("testcase 85 created")
def testcase_85():
    import random, os
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "subsystem_testcase/testcase_85/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_shared(p, t, s, o): return (p << 16) | (t << 10) | (s << 6) | o

    shared_prefix = random.choice([0x0002, 0x0003])
    # Chọn 4 set khác nhau cho IMEM_A
    sets_A = random.sample(range(16), 4)
    # Lệnh read đầu, read giữa, write cuối cho IMEM_A
    tag_a0 = random.randint(0, 0x3F)
    tag_a1 = random.randint(0, 0x3F)
    tag_a2 = random.randint(0, 0x3F)
    tag_w  = random.randint(0, 0x3F)
    offset_a0 = random.choice(range(0, 64, 4))
    offset_a1 = random.choice(range(0, 64, 4))
    offset_a2 = random.choice(range(0, 64, 4))
    offset_w  = random.choice(range(0, 64, 4))
    # Địa chỉ cho IMEM_A
    addr_a0 = make_shared(shared_prefix, tag_a0, sets_A[0], offset_a0)
    addr_a1 = make_shared(shared_prefix, tag_a1, sets_A[1], offset_a1)
    addr_a2 = make_shared(shared_prefix, tag_a2, sets_A[2], offset_a2)
    addr_aw = make_shared(shared_prefix, tag_w,  sets_A[3], offset_w)
    data_aw = to_hex32(random.getrandbits(32))

    instr_A = [
        f"read\t{to_hex32(addr_a0)}",
        f"read\t{to_hex32(addr_a1)}",
        f"read\t{to_hex32(addr_a2)}",
        f"write\t{to_hex32(addr_aw)}\t{data_aw}",
    ]
    addrs = [addr_a0, addr_a1, addr_a2, addr_aw]

    # IMEM_B: 4 lệnh, set khác nhau, lệnh đầu (read) trùng tag_w + set của write cuối A
    # 3 set còn lại khác set đã dùng ở IMEM_A[3]
    set_bw = sets_A[3]
    used_b_sets = {set_bw}
    b_sets = random.sample([s for s in range(16) if s not in used_b_sets], 3)
    # Lệnh đầu B: read (giống write cuối cùng của A)
    offset_b0 = random.choice(range(0, 64, 4))
    addr_b0 = make_shared(shared_prefix, tag_w, set_bw, offset_b0)
    # Các lệnh còn lại B
    tag_b1 = random.randint(0, 0x3F)
    tag_b2 = random.randint(0, 0x3F)
    tag_b3 = random.randint(0, 0x3F)
    offset_b1 = random.choice(range(0, 64, 4))
    offset_b2 = random.choice(range(0, 64, 4))
    offset_b3 = random.choice(range(0, 64, 4))
    addr_b1 = make_shared(shared_prefix, tag_b1, b_sets[0], offset_b1)
    addr_b2 = make_shared(shared_prefix, tag_b2, b_sets[1], offset_b2)
    addr_b3 = make_shared(shared_prefix, tag_b3, b_sets[2], offset_b3)
    instr_B = [
        f"read\t{to_hex32(addr_b0)}",
        f"read\t{to_hex32(addr_b1)}",
        f"read\t{to_hex32(addr_b2)}",
        f"read\t{to_hex32(addr_b3)}",
    ]
    addrs += [addr_b0, addr_b1, addr_b2, addr_b3]

    with open(path_A, "w") as f:
        for l in instr_A: f.write(l + "\n")
    with open(path_B, "w") as f:
        for l in instr_B: f.write(l + "\n")
    written = set()
    with open(path_mem, "w") as f:
        for a in addrs:
            base = a & ~0x3F
            if base in written: continue
            written.add(base)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(base)] + words) + "\n")
    print("testcase 85 created")

def testcase_86():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "subsystem_testcase/testcase_86/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_shared(p, t, s, o): return (p << 16) | (t << 10) | (s << 6) | o

    instr_A, instr_B, addrs = [], [], []
    shared_prefix = random.choice([0x0002, 0x0003])
    used_pairs = set()
    used_sets = set()

    # B: 1 read
    while True:
        tag_r = random.randint(0, 0x3F)
        set_r = random.randint(0, 0xF)
        if (tag_r, set_r) not in used_pairs:
            used_pairs.add((tag_r, set_r))
            used_sets.add(set_r)
            break
    offset_r = random.choice(range(0, 64, 4))
    addr_r = make_shared(shared_prefix, tag_r, set_r, offset_r)
    instr_B.append(f"read\t{to_hex32(addr_r)}")
    addrs.append(addr_r)

    # B: 1 write (khác tag + set)
    while True:
        tag_w = random.randint(0, 0x3F)
        set_w = random.randint(0, 0xF)
        if (tag_w, set_w) not in used_pairs:
            used_pairs.add((tag_w, set_w))
            used_sets.add(set_w)
            break
    offset_w = random.choice(range(0, 64, 4))
    addr_w = make_shared(shared_prefix, tag_w, set_w, offset_w)
    data_w = to_hex32(random.getrandbits(32))
    instr_B.append(f"write\t{to_hex32(addr_w)}\t{data_w}")
    addrs.append(addr_w)

    # A: 1 read trùng với write trong B
    offset_a0 = random.choice(range(0, 64, 4))
    addr_a0 = make_shared(shared_prefix, tag_w, set_w, offset_a0)
    instr_A.append(f"read\t{to_hex32(addr_a0)}")
    addrs.append(addr_a0)

    # A: 1 write khác set với read trong B
    while True:
        set_a1 = random.randint(0, 0xF)
        if set_a1 != set_r and set_a1 not in used_sets:
            break
    tag_a1 = random.randint(0, 0x3F)
    offset_a1 = random.choice(range(0, 64, 4))
    addr_a1 = make_shared(shared_prefix, tag_a1, set_a1, offset_a1)
    data_a1 = to_hex32(random.getrandbits(32))
    instr_A.append(f"write\t{to_hex32(addr_a1)}\t{data_a1}")
    addrs.append(addr_a1)

    with open(path_A, "w") as f:
        for l in instr_A: f.write(l + "\n")
    with open(path_B, "w") as f:
        for l in instr_B: f.write(l + "\n")

    written = set()
    with open(path_mem, "w") as f:
        for a in addrs:
            base = a & ~0x3F
            if base in written: continue
            written.add(base)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(base)] + words) + "\n")

    print("testcase 86 created")
def testcase_87():
    import random, os
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "subsystem_testcase/testcase_87/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_shared(p, t, s, o): return (p << 16) | (t << 10) | (s << 6) | o

    shared_prefix = random.choice([0x0002, 0x0003])
    # Chọn 2 cặp (tag,set) khác nhau cho A
    used_pairs = set()
    used_sets = set()
    read_refs = []
    while len(read_refs) < 2:
        tag = random.randint(0, 0x3F)
        set_ = random.randint(0, 0xF)
        if (tag, set_) not in used_pairs:
            used_pairs.add((tag, set_))
            read_refs.append((tag, set_))
            used_sets.add(set_)

    tag_a0, set_a0 = read_refs[0]
    tag_a1, set_a1 = read_refs[1]
    # Chuẩn bị danh sách set cấm dùng cho các lệnh giữa
    forbidden_sets_A = {set_a0, set_a1}
    forbidden_sets_B = set(forbidden_sets_A)  # tạm thời, sẽ cộng thêm set B

    # Chọn 2 set cho lệnh read giữa A, khác nhau, khác forbidden_sets_A, và khác với tất cả set sẽ dùng ở B
    # Chọn 2 set cho lệnh read giữa B, khác nhau, khác forbidden_sets_B, và khác với tất cả set đã dùng ở A

    # Đặt trước 2 set B để đảm bảo không trùng với A
    all_sets = set(range(16))
    forbidden_sets_B.update({})  # tạm thời chưa có set B, sẽ update tiếp ở dưới

    # Chọn 2 set giữa cho B, khác nhau, khác set_a0, set_a1
    sets_candidate_B = list(all_sets - forbidden_sets_B)
    random.shuffle(sets_candidate_B)
    set_bm1, set_bm2 = sets_candidate_B[:2]

    # Cập nhật forbidden set cho A: phải khác 2 set của B luôn
    forbidden_sets_A.update({set_bm1, set_bm2})
    sets_candidate_A = list(all_sets - forbidden_sets_A)
    random.shuffle(sets_candidate_A)
    set_am1, set_am2 = sets_candidate_A[:2]

    # Địa chỉ và tag cho 2 lệnh giữa A
    tag_am1 = random.randint(0, 0x3F)
    tag_am2 = random.randint(0, 0x3F)
    offset_am1 = random.choice(range(0, 64, 4))
    offset_am2 = random.choice(range(0, 64, 4))
    addr_am1 = make_shared(shared_prefix, tag_am1, set_am1, offset_am1)
    addr_am2 = make_shared(shared_prefix, tag_am2, set_am2, offset_am2)

    # Địa chỉ và tag cho 2 lệnh giữa B
    tag_bm1 = random.randint(0, 0x3F)
    tag_bm2 = random.randint(0, 0x3F)
    offset_bm1 = random.choice(range(0, 64, 4))
    offset_bm2 = random.choice(range(0, 64, 4))
    addr_bm1 = make_shared(shared_prefix, tag_bm1, set_bm1, offset_bm1)
    addr_bm2 = make_shared(shared_prefix, tag_bm2, set_bm2, offset_bm2)

    # Địa chỉ 2 lệnh đầu cuối A (giữ như cũ)
    offset_a0 = random.choice(range(0, 64, 4))
    addr_a0 = make_shared(shared_prefix, tag_a0, set_a0, offset_a0)
    offset_a1 = random.choice(range(0, 64, 4))
    addr_a1 = make_shared(shared_prefix, tag_a1, set_a1, offset_a1)

    # B: lệnh đầu read trùng logic với A[1]
    offset_b0 = random.choice(range(0, 64, 4))
    addr_b0 = make_shared(shared_prefix, tag_a1, set_a1, offset_b0)
    # B: lệnh cuối write trùng logic với A[0]
    offset_b1 = random.choice(range(0, 64, 4))
    addr_b1 = make_shared(shared_prefix, tag_a0, set_a0, offset_b1)
    data_b1 = to_hex32(random.getrandbits(32))

    # Tổng hợp IMEM_A
    instr_A = [
        f"read\t{to_hex32(addr_a0)}",
        f"read\t{to_hex32(addr_am1)}",
        f"read\t{to_hex32(addr_am2)}",
        f"read\t{to_hex32(addr_a1)}",
    ]
    # Tổng hợp IMEM_B
    instr_B = [
        f"read\t{to_hex32(addr_b0)}",
        f"read\t{to_hex32(addr_bm1)}",
        f"read\t{to_hex32(addr_bm2)}",
        f"write\t{to_hex32(addr_b1)}\t{data_b1}",
    ]
    # Địa chỉ cho mem
    addrs = [addr_a0, addr_am1, addr_am2, addr_a1, addr_b0, addr_bm1, addr_bm2, addr_b1]

    with open(path_A, "w") as f:
        for l in instr_A: f.write(l + "\n")
    with open(path_B, "w") as f:
        for l in instr_B: f.write(l + "\n")
    written = set()
    with open(path_mem, "w") as f:
        for a in addrs:
            base = a & ~0x3F
            if base in written: continue
            written.add(base)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(base)] + words) + "\n")
    print("testcase 87 created")

def testcase_88():
    import random, os
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "subsystem_testcase/testcase_88/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_shared(p, t, s, o): return (p << 16) | (t << 10) | (s << 6) | o

    shared_prefix = random.choice([0x0002, 0x0003])

    # Chọn 4 set khác nhau cho IMEM A
    sets_A = random.sample(range(16), 4)
    tags_A = [random.randint(0, 0x3F) for _ in range(4)]
    offsets_A = [random.choice(range(0, 64, 4)) for _ in range(4)]
    addrs_A = [make_shared(shared_prefix, tags_A[i], sets_A[i], offsets_A[i]) for i in range(4)]
    instr_A = [f"read\t{to_hex32(addrs_A[i])}" for i in range(4)]

    # IMEM B: 3 lệnh read, 1 write
    # Lệnh read đầu trùng với read cuối của A
    addr_b0 = make_shared(shared_prefix, tags_A[3], sets_A[3], random.choice(range(0, 64, 4)))
    # Chọn 2 set cho 2 lệnh read tiếp, khác 4 set A và khác nhau
    remain_sets_B = [s for s in range(16) if s not in sets_A]
    sets_B_read = random.sample(remain_sets_B, 2)
    tags_B_read = [random.randint(0, 0x3F) for _ in range(2)]
    offsets_B_read = [random.choice(range(0, 64, 4)) for _ in range(2)]
    addrs_B_read = [make_shared(shared_prefix, tags_B_read[i], sets_B_read[i], offsets_B_read[i]) for i in range(2)]

    # Lệnh write, set khác tất cả 4 set A và 2 set vừa dùng ở read của B
    sets_for_write = [s for s in remain_sets_B if s not in sets_B_read]
    set_Bw = random.choice(sets_for_write)
    tag_Bw = random.randint(0, 0x3F)
    offset_Bw = random.choice(range(0, 64, 4))
    addr_Bw = make_shared(shared_prefix, tag_Bw, set_Bw, offset_Bw)
    data_Bw = to_hex32(random.getrandbits(32))

    instr_B = [
        f"read\t{to_hex32(addr_b0)}",
        f"read\t{to_hex32(addrs_B_read[0])}",
        f"read\t{to_hex32(addrs_B_read[1])}",
        f"write\t{to_hex32(addr_Bw)}\t{data_Bw}"
    ]

    # Địa chỉ dùng cho mem
    addrs = addrs_A + [addr_b0] + addrs_B_read + [addr_Bw]

    with open(path_A, "w") as f:
        for l in instr_A: f.write(l + "\n")
    with open(path_B, "w") as f:
        for l in instr_B: f.write(l + "\n")
    written = set()
    with open(path_mem, "w") as f:
        for a in addrs:
            base = a & ~0x3F
            if base in written: continue
            written.add(base)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(base)] + words) + "\n")
    print("testcase 88 created")


def testcase_89():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "subsystem_testcase/testcase_89/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_shared(p, t, s, o): return (p << 16) | (t << 10) | (s << 6) | o

    instr_A, instr_B, addrs = [], [], []
    shared_prefix = random.choice([0x0002, 0x0003])
    used_pairs = set()
    used_sets = set()

    # B: 1 read
    while True:
        tag_r = random.randint(0, 0x3F)
        set_r = random.randint(0, 0xF)
        if (tag_r, set_r) not in used_pairs:
            used_pairs.add((tag_r, set_r))
            used_sets.add(set_r)
            break
    offset_r = random.choice(range(0, 64, 4))
    addr_r = make_shared(shared_prefix, tag_r, set_r, offset_r)
    instr_B.append(f"read\t{to_hex32(addr_r)}")
    addrs.append(addr_r)

    # B: 1 write (khác tag + set)
    while True:
        tag_w = random.randint(0, 0x3F)
        set_w = random.randint(0, 0xF)
        if (tag_w, set_w) not in used_pairs:
            used_pairs.add((tag_w, set_w))
            used_sets.add(set_w)
            break
    offset_w = random.choice(range(0, 64, 4))
    addr_w = make_shared(shared_prefix, tag_w, set_w, offset_w)
    data_w = to_hex32(random.getrandbits(32))
    instr_B.append(f"write\t{to_hex32(addr_w)}\t{data_w}")
    addrs.append(addr_w)

    # A: 1 read trùng logic với write cuối của B
    offset_a0 = random.choice(range(0, 64, 4))
    addr_a0 = make_shared(shared_prefix, tag_w, set_w, offset_a0)
    instr_A.append(f"read\t{to_hex32(addr_a0)}")
    addrs.append(addr_a0)

    # A: 1 read khác set với read đầu của B
    while True:
        set_a1 = random.randint(0, 0xF)
        if set_a1 != set_r and set_a1 not in used_sets:
            break
    tag_a1 = random.randint(0, 0x3F)
    offset_a1 = random.choice(range(0, 64, 4))
    addr_a1 = make_shared(shared_prefix, tag_a1, set_a1, offset_a1)
    instr_A.append(f"read\t{to_hex32(addr_a1)}")
    addrs.append(addr_a1)

    with open(path_A, "w") as f:
        for l in instr_A: f.write(l + "\n")
    with open(path_B, "w") as f:
        for l in instr_B: f.write(l + "\n")

    written = set()
    with open(path_mem, "w") as f:
        for a in addrs:
            base = a & ~0x3F
            if base in written: continue
            written.add(base)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(base)] + words) + "\n")

    print("testcase 89 created")
def testcase_90():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "subsystem_testcase/testcase_90/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_shared(p, t, s, o): return (p << 16) | (t << 10) | (s << 6) | o

    instr_A, instr_B, addrs = [], [], []
    shared_prefix = random.choice([0x0002, 0x0003])
    used_sets = set()

    # A[0]: 1 read đầu tiên
    tag_a0 = random.randint(0, 0x3F)
    set_a0 = random.randint(0, 0xF)
    used_sets.add(set_a0)
    offset_a0 = random.choice(range(0, 64, 4))
    addr_a0 = make_shared(shared_prefix, tag_a0, set_a0, offset_a0)
    instr_A.append(f"read\t{to_hex32(addr_a0)}")
    addrs.append(addr_a0)

    # A[1-2]: 2 read cùng tag + set với nhau, khác tag + set A[0]
    while True:
        tag_shared = random.randint(0, 0x3F)
        set_shared = random.randint(0, 0xF)
        if tag_shared != tag_a0 or set_shared != set_a0:
            break
    for _ in range(2):
        offset = random.choice(range(0, 64, 4))
        addr = make_shared(shared_prefix, tag_shared, set_shared, offset)
        instr_A.append(f"read\t{to_hex32(addr)}")
        addrs.append(addr)

    # B[0-1]: 2 read khác set với mọi lệnh trong A
    b_read_sets = set()
    while len(b_read_sets) < 2:
        s = random.randint(0, 0xF)
        if s != set_a0 and s != set_shared:
            b_read_sets.add(s)
    for s in b_read_sets:
        t = random.randint(0, 0x3F)
        o = random.choice(range(0, 64, 4))
        addr = make_shared(shared_prefix, t, s, o)
        instr_B.append(f"read\t{to_hex32(addr)}")
        addrs.append(addr)

    # B[2]: read trùng logic với A[0]
    offset_match = random.choice(range(0, 64, 4))
    addr_b3 = make_shared(shared_prefix, tag_a0, set_a0, offset_match)
    instr_B.append(f"read\t{to_hex32(addr_b3)}")
    addrs.append(addr_b3)

    with open(path_A, "w") as f:
        for line in instr_A: f.write(line + "\n")
    with open(path_B, "w") as f:
        for line in instr_B: f.write(line + "\n")

    written = set()
    with open(path_mem, "w") as f:
        for addr in addrs:
            base = addr & ~0x3F
            if base in written: continue
            written.add(base)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(base)] + words) + "\n")

    print("testcase 90 created")
def testcase_91():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "subsystem_testcase/testcase_91/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_shared(p, t, s, o): return (p << 16) | (t << 10) | (s << 6) | o

    instr_A, instr_B, addrs = [], [], []
    shared_prefix = random.choice([0x0002, 0x0003])
    used_sets = set()

    # A[0]: 1 read đầu tiên
    tag_a0 = random.randint(0, 0x3F)
    set_a0 = random.randint(0, 0xF)
    used_sets.add(set_a0)
    offset_a0 = random.choice(range(0, 64, 4))
    addr_a0 = make_shared(shared_prefix, tag_a0, set_a0, offset_a0)
    instr_A.append(f"read\t{to_hex32(addr_a0)}")
    addrs.append(addr_a0)

    # A[1-2]: 2 read cùng tag + set với nhau, khác với A[0]
    while True:
        tag_shared = random.randint(0, 0x3F)
        set_shared = random.randint(0, 0xF)
        if (tag_shared != tag_a0 or set_shared != set_a0):
            break
    for _ in range(2):
        offset = random.choice(range(0, 64, 4))
        addr = make_shared(shared_prefix, tag_shared, set_shared, offset)
        instr_A.append(f"read\t{to_hex32(addr)}")
        addrs.append(addr)

    # B[0-1]: 2 read khác set với A
    b_sets = set()
    while len(b_sets) < 2:
        s = random.randint(0, 0xF)
        if s != set_a0 and s != set_shared:
            b_sets.add(s)
    for s in b_sets:
        t = random.randint(0, 0x3F)
        o = random.choice(range(0, 64, 4))
        addr = make_shared(shared_prefix, t, s, o)
        instr_B.append(f"read\t{to_hex32(addr)}")
        addrs.append(addr)

    # B[2]: read khác logic hoàn toàn với A[0]
    while True:
        tag_b3 = random.randint(0, 0x3F)
        set_b3 = random.randint(0, 0xF)
        if tag_b3 != tag_a0 or set_b3 != set_a0:
            break
    offset_b3 = random.choice(range(0, 64, 4))
    addr_b3 = make_shared(shared_prefix, tag_b3, set_b3, offset_b3)
    instr_B.append(f"read\t{to_hex32(addr_b3)}")
    addrs.append(addr_b3)

    with open(path_A, "w") as f:
        for line in instr_A: f.write(line + "\n")
    with open(path_B, "w") as f:
        for line in instr_B: f.write(line + "\n")

    written = set()
    with open(path_mem, "w") as f:
        for addr in addrs:
            base = addr & ~0x3F
            if base in written: continue
            written.add(base)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(base)] + words) + "\n")

    print("testcase 91 created")
def testcase_92():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "subsystem_testcase/testcase_92/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_shared(p, t, s, o): return (p << 16) | (t << 10) | (s << 6) | o

    instr_A, instr_B, addrs = [], [], []
    shared_prefix = random.choice([0x0002, 0x0003])
    used_sets = set()

    # A[0]: 1 read đầu tiên
    tag_a0 = random.randint(0, 0x3F)
    set_a0 = random.randint(0, 0xF)
    used_sets.add(set_a0)
    offset_a0 = random.choice(range(0, 64, 4))
    addr_a0 = make_shared(shared_prefix, tag_a0, set_a0, offset_a0)
    instr_A.append(f"read\t{to_hex32(addr_a0)}")
    addrs.append(addr_a0)

    # A[1-2]: 2 read cùng tag + set với nhau, khác với A[0]
    while True:
        tag_shared = random.randint(0, 0x3F)
        set_shared = random.randint(0, 0xF)
        if tag_shared != tag_a0 or set_shared != set_a0:
            break
    for _ in range(2):
        offset = random.choice(range(0, 64, 4))
        addr = make_shared(shared_prefix, tag_shared, set_shared, offset)
        instr_A.append(f"read\t{to_hex32(addr)}")
        addrs.append(addr)

    # B[0-1]: 2 read khác set với A
    b_sets = set()
    while len(b_sets) < 2:
        s = random.randint(0, 0xF)
        if s != set_a0 and s != set_shared:
            b_sets.add(s)
    for s in b_sets:
        t = random.randint(0, 0x3F)
        o = random.choice(range(0, 64, 4))
        addr = make_shared(shared_prefix, t, s, o)
        instr_B.append(f"read\t{to_hex32(addr)}")
        addrs.append(addr)

    # B[2]: write trùng logic với A[0]
    offset_b2 = random.choice(range(0, 64, 4))
    addr_b2 = make_shared(shared_prefix, tag_a0, set_a0, offset_b2)
    data_b2 = to_hex32(random.getrandbits(32))
    instr_B.append(f"write\t{to_hex32(addr_b2)}\t{data_b2}")
    addrs.append(addr_b2)

    with open(path_A, "w") as f:
        for line in instr_A: f.write(line + "\n")
    with open(path_B, "w") as f:
        for line in instr_B: f.write(line + "\n")

    written = set()
    with open(path_mem, "w") as f:
        for addr in addrs:
            base = addr & ~0x3F
            if base in written: continue
            written.add(base)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(base)] + words) + "\n")

    print("testcase 92 created")
def testcase_93():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "subsystem_testcase/testcase_93/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_shared(p, t, s, o): return (p << 16) | (t << 10) | (s << 6) | o

    instr_A, instr_B, addrs = [], [], []
    shared_prefix = random.choice([0x0002, 0x0003])
    used_sets = set()

    # A[0]: read đầu tiên
    tag_a0 = random.randint(0, 0x3F)
    set_a0 = random.randint(0, 0xF)
    used_sets.add(set_a0)
    offset_a0 = random.choice(range(0, 64, 4))
    addr_a0 = make_shared(shared_prefix, tag_a0, set_a0, offset_a0)
    instr_A.append(f"read\t{to_hex32(addr_a0)}")
    addrs.append(addr_a0)

    # A[1-2]: 2 read cùng tag/set khác với A[0]
    while True:
        tag_shared = random.randint(0, 0x3F)
        set_shared = random.randint(0, 0xF)
        if tag_shared != tag_a0 or set_shared != set_a0:
            break
    for _ in range(2):
        offset = random.choice(range(0, 64, 4))
        addr = make_shared(shared_prefix, tag_shared, set_shared, offset)
        instr_A.append(f"read\t{to_hex32(addr)}")
        addrs.append(addr)
    used_sets.add(set_shared)

    # B[0-1]: 2 read với set khác A
    b_sets = set()
    while len(b_sets) < 2:
        s = random.randint(0, 0xF)
        if s != set_a0 and s != set_shared:
            b_sets.add(s)
    for s in b_sets:
        t = random.randint(0, 0x3F)
        o = random.choice(range(0, 64, 4))
        addr = make_shared(shared_prefix, t, s, o)
        instr_B.append(f"read\t{to_hex32(addr)}")
        addrs.append(addr)

    # B[2]: write khác tag, set với A[0]
    while True:
        tag_w = random.randint(0, 0x3F)
        set_w = random.randint(0, 0xF)
        if tag_w != tag_a0 or set_w != set_a0:
            break
    offset_w = random.choice(range(0, 64, 4))
    addr_w = make_shared(shared_prefix, tag_w, set_w, offset_w)
    data_w = to_hex32(random.getrandbits(32))
    instr_B.append(f"write\t{to_hex32(addr_w)}\t{data_w}")
    addrs.append(addr_w)

    with open(path_A, "w") as f:
        for line in instr_A: f.write(line + "\n")
    with open(path_B, "w") as f:
        for line in instr_B: f.write(line + "\n")

    written = set()
    with open(path_mem, "w") as f:
        for addr in addrs:
            base = addr & ~0x3F
            if base in written: continue
            written.add(base)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(base)] + words) + "\n")

    print("testcase 93 created")
def testcase_94():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "subsystem_testcase/testcase_94/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_shared(p, t, s, o): return (p << 16) | (t << 10) | (s << 6) | o

    instr_A, instr_B, addrs = [], [], []
    shared_prefix = random.choice([0x0002, 0x0003])
    used_sets = set()

    # A[0]: read1
    tag_a0 = random.randint(0, 0x3F)
    set_a0 = random.randint(0, 0xF)
    used_sets.add(set_a0)
    offset_a0 = random.choice(range(0, 64, 4))
    addr_a0 = make_shared(shared_prefix, tag_a0, set_a0, offset_a0)
    instr_A.append(f"read\t{to_hex32(addr_a0)}")
    addrs.append(addr_a0)

    # A[1]: read2 (khác set/tag với A[0])
    while True:
        tag_a1 = random.randint(0, 0x3F)
        set_a1 = random.randint(0, 0xF)
        if tag_a1 != tag_a0 or set_a1 != set_a0:
            break
    used_sets.add(set_a1)
    offset_a1 = random.choice(range(0, 64, 4))
    addr_a1 = make_shared(shared_prefix, tag_a1, set_a1, offset_a1)
    instr_A.append(f"read\t{to_hex32(addr_a1)}")
    addrs.append(addr_a1)

    # A[2]: write trùng tag/set với A[1]
    offset_w = random.choice(range(0, 64, 4))
    addr_w = make_shared(shared_prefix, tag_a1, set_a1, offset_w)
    data_w = to_hex32(random.getrandbits(32))
    instr_A.append(f"write\t{to_hex32(addr_w)}\t{data_w}")
    addrs.append(addr_w)

    # B[0-1]: read khác set với cả A[0] và A[1]
    b_sets = set()
    while len(b_sets) < 2:
        s = random.randint(0, 0xF)
        if s != set_a0 and s != set_a1:
            b_sets.add(s)
    for s in b_sets:
        t = random.randint(0, 0x3F)
        o = random.choice(range(0, 64, 4))
        addr = make_shared(shared_prefix, t, s, o)
        instr_B.append(f"read\t{to_hex32(addr)}")
        addrs.append(addr)

    # B[2]: read trùng logic với A[0]
    offset_b2 = random.choice(range(0, 64, 4))
    addr_b2 = make_shared(shared_prefix, tag_a0, set_a0, offset_b2)
    instr_B.append(f"read\t{to_hex32(addr_b2)}")
    addrs.append(addr_b2)

    with open(path_A, "w") as f:
        for line in instr_A: f.write(line + "\n")
    with open(path_B, "w") as f:
        for line in instr_B: f.write(line + "\n")

    written = set()
    with open(path_mem, "w") as f:
        for addr in addrs:
            base = addr & ~0x3F
            if base in written: continue
            written.add(base)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(base)] + words) + "\n")

    print("testcase 94 created")
def testcase_95():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "subsystem_testcase/testcase_95/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_shared(p, t, s, o): return (p << 16) | (t << 10) | (s << 6) | o

    instr_A, instr_B, addrs = [], [], []
    shared_prefix = random.choice([0x0002, 0x0003])
    used_combos = set()

    # A[0]: read 1
    while True:
        tag_a0 = random.randint(0, 0x3F)
        set_a0 = random.randint(0, 0xF)
        if (tag_a0, set_a0) not in used_combos:
            used_combos.add((tag_a0, set_a0))
            break
    offset_a0 = random.choice(range(0, 64, 4))
    addr_a0 = make_shared(shared_prefix, tag_a0, set_a0, offset_a0)
    instr_A.append(f"read\t{to_hex32(addr_a0)}")
    addrs.append(addr_a0)

    # A[1]: read 2 (khác set/tag với A[0])
    while True:
        tag_a1 = random.randint(0, 0x3F)
        set_a1 = random.randint(0, 0xF)
        if (tag_a1, set_a1) not in used_combos:
            used_combos.add((tag_a1, set_a1))
            break
    offset_a1 = random.choice(range(0, 64, 4))
    addr_a1 = make_shared(shared_prefix, tag_a1, set_a1, offset_a1)
    instr_A.append(f"read\t{to_hex32(addr_a1)}")
    addrs.append(addr_a1)

    # A[2]: write giống A[1]
    offset_w = random.choice(range(0, 64, 4))
    addr_w = make_shared(shared_prefix, tag_a1, set_a1, offset_w)
    data_w = to_hex32(random.getrandbits(32))
    instr_A.append(f"write\t{to_hex32(addr_w)}\t{data_w}")
    addrs.append(addr_w)

    # B[0-2]: 3 read khác tag/set với toàn bộ A
    while len(instr_B) < 3:
        tag_b = random.randint(0, 0x3F)
        set_b = random.randint(0, 0xF)
        if (tag_b, set_b) not in used_combos:
            used_combos.add((tag_b, set_b))
            offset = random.choice(range(0, 64, 4))
            addr = make_shared(shared_prefix, tag_b, set_b, offset)
            instr_B.append(f"read\t{to_hex32(addr)}")
            addrs.append(addr)

    with open(path_A, "w") as f:
        for line in instr_A: f.write(line + "\n")
    with open(path_B, "w") as f:
        for line in instr_B: f.write(line + "\n")

    written = set()
    with open(path_mem, "w") as f:
        for addr in addrs:
            base = addr & ~0x3F
            if base in written: continue
            written.add(base)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(base)] + words) + "\n")

    print("testcase 95 created")
def testcase_96():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "subsystem_testcase/testcase_96/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_shared(p, t, s, o): return (p << 16) | (t << 10) | (s << 6) | o

    instr_A, instr_B, addrs = [], [], []
    shared_prefix = random.choice([0x0002, 0x0003])
    used_combos = set()

    # A[0]: read1
    while True:
        tag_a0 = random.randint(0, 0x3F)
        set_a0 = random.randint(0, 0xF)
        if (tag_a0, set_a0) not in used_combos:
            used_combos.add((tag_a0, set_a0))
            break
    offset_a0 = random.choice(range(0, 64, 4))
    addr_a0 = make_shared(shared_prefix, tag_a0, set_a0, offset_a0)
    instr_A.append(f"read\t{to_hex32(addr_a0)}")
    addrs.append(addr_a0)

    # A[1]: read2 khác tag/set với A[0]
    while True:
        tag_a1 = random.randint(0, 0x3F)
        set_a1 = random.randint(0, 0xF)
        if (tag_a1, set_a1) not in used_combos:
            used_combos.add((tag_a1, set_a1))
            break
    offset_a1 = random.choice(range(0, 64, 4))
    addr_a1 = make_shared(shared_prefix, tag_a1, set_a1, offset_a1)
    instr_A.append(f"read\t{to_hex32(addr_a1)}")
    addrs.append(addr_a1)

    # A[2]: write cùng tag/set với A[1]
    offset_w = random.choice(range(0, 64, 4))
    addr_w = make_shared(shared_prefix, tag_a1, set_a1, offset_w)
    data_w = to_hex32(random.getrandbits(32))
    instr_A.append(f"write\t{to_hex32(addr_w)}\t{data_w}")
    addrs.append(addr_w)

    # B[0-1]: 2 read khác set với A[0] và A[1]
    b_sets = set()
    while len(b_sets) < 2:
        s = random.randint(0, 0xF)
        if s != set_a0 and s != set_a1:
            b_sets.add(s)
    for s in b_sets:
        t = random.randint(0, 0x3F)
        o = random.choice(range(0, 64, 4))
        addr = make_shared(shared_prefix, t, s, o)
        instr_B.append(f"read\t{to_hex32(addr)}")
        addrs.append(addr)

    # B[2]: write trùng tag/set với A[0]
    offset_b2 = random.choice(range(0, 64, 4))
    addr_b2 = make_shared(shared_prefix, tag_a0, set_a0, offset_b2)
    data_b2 = to_hex32(random.getrandbits(32))
    instr_B.append(f"write\t{to_hex32(addr_b2)}\t{data_b2}")
    addrs.append(addr_b2)

    with open(path_A, "w") as f:
        for line in instr_A: f.write(line + "\n")
    with open(path_B, "w") as f:
        for line in instr_B: f.write(line + "\n")

    written = set()
    with open(path_mem, "w") as f:
        for addr in addrs:
            base = addr & ~0x3F
            if base in written: continue
            written.add(base)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(base)] + words) + "\n")

    print("testcase 96 created")
def testcase_97():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "subsystem_testcase/testcase_97/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_shared(p, t, s, o): return (p << 16) | (t << 10) | (s << 6) | o

    instr_A, instr_B, addrs = [], [], []
    shared_prefix = random.choice([0x0002, 0x0003])
    used_combos = set()

    # A[0]: read1
    while True:
        tag_a0 = random.randint(0, 0x3F)
        set_a0 = random.randint(0, 0xF)
        if (tag_a0, set_a0) not in used_combos:
            used_combos.add((tag_a0, set_a0))
            break
    offset_a0 = random.choice(range(0, 64, 4))
    addr_a0 = make_shared(shared_prefix, tag_a0, set_a0, offset_a0)
    instr_A.append(f"read\t{to_hex32(addr_a0)}")
    addrs.append(addr_a0)

    # A[1]: read2 khác set/tag với A[0]
    while True:
        tag_a1 = random.randint(0, 0x3F)
        set_a1 = random.randint(0, 0xF)
        if (tag_a1, set_a1) not in used_combos:
            used_combos.add((tag_a1, set_a1))
            break
    offset_a1 = random.choice(range(0, 64, 4))
    addr_a1 = make_shared(shared_prefix, tag_a1, set_a1, offset_a1)
    instr_A.append(f"read\t{to_hex32(addr_a1)}")
    addrs.append(addr_a1)

    # A[2]: write cùng tag/set với A[1]
    offset_w_a = random.choice(range(0, 64, 4))
    addr_w_a = make_shared(shared_prefix, tag_a1, set_a1, offset_w_a)
    data_w_a = to_hex32(random.getrandbits(32))
    instr_A.append(f"write\t{to_hex32(addr_w_a)}\t{data_w_a}")
    addrs.append(addr_w_a)

    # B[0-1]: 2 read khác set với A[0] và A[1]
    b_sets = set()
    while len(b_sets) < 2:
        s = random.randint(0, 0xF)
        if s != set_a0 and s != set_a1:
            b_sets.add(s)
    for s in b_sets:
        t = random.randint(0, 0x3F)
        o = random.choice(range(0, 64, 4))
        addr = make_shared(shared_prefix, t, s, o)
        instr_B.append(f"read\t{to_hex32(addr)}")
        addrs.append(addr)

    # B[2]: write với set/tag khác A[0], và prefix cũng khác
    while True:
        new_prefix = random.choice([0x0002, 0x0003])
        tag_b2 = random.randint(0, 0x3F)
        set_b2 = random.randint(0, 0xF)
        if (tag_b2 != tag_a0 or set_b2 != set_a0) or new_prefix != shared_prefix:
            break
    offset_b2 = random.choice(range(0, 64, 4))
    addr_b2 = make_shared(new_prefix, tag_b2, set_b2, offset_b2)
    data_b2 = to_hex32(random.getrandbits(32))
    instr_B.append(f"write\t{to_hex32(addr_b2)}\t{data_b2}")
    addrs.append(addr_b2)

    with open(path_A, "w") as f:
        for line in instr_A: f.write(line + "\n")
    with open(path_B, "w") as f:
        for line in instr_B: f.write(line + "\n")

    written = set()
    with open(path_mem, "w") as f:
        for addr in addrs:
            base = addr & ~0x3F
            if base in written: continue
            written.add(base)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(base)] + words) + "\n")

    print("testcase 97 created")
def testcase_98():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "subsystem_testcase/testcase_98/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_shared(p, t, s, o): return (p << 16) | (t << 10) | (s << 6) | o

    instr_A, instr_B, addrs = [], [], []
    shared_prefix = random.choice([0x0002, 0x0003])
    used_combos = set()

    # A[0]: read1
    while True:
        tag_a0 = random.randint(0, 0x3F)
        set_a0 = random.randint(0, 0xF)
        if (tag_a0, set_a0) not in used_combos:
            used_combos.add((tag_a0, set_a0))
            break
    offset_a0 = random.choice(range(0, 64, 4))
    addr_a0 = make_shared(shared_prefix, tag_a0, set_a0, offset_a0)
    instr_A.append(f"read\t{to_hex32(addr_a0)}")
    addrs.append(addr_a0)

    # A[1]: read2 khác set/tag
    while True:
        tag_a1 = random.randint(0, 0x3F)
        set_a1 = random.randint(0, 0xF)
        if (tag_a1, set_a1) not in used_combos:
            used_combos.add((tag_a1, set_a1))
            break
    offset_a1 = random.choice(range(0, 64, 4))
    addr_a1 = make_shared(shared_prefix, tag_a1, set_a1, offset_a1)
    instr_A.append(f"read\t{to_hex32(addr_a1)}")
    addrs.append(addr_a1)

    # B[0]: read khác set/tag với A
    while True:
        tag_b0 = random.randint(0, 0x3F)
        set_b0 = random.randint(0, 0xF)
        if (tag_b0, set_b0) not in used_combos:
            used_combos.add((tag_b0, set_b0))
            break
    offset_b0 = random.choice(range(0, 64, 4))
    addr_b0 = make_shared(shared_prefix, tag_b0, set_b0, offset_b0)
    instr_B.append(f"read\t{to_hex32(addr_b0)}")
    addrs.append(addr_b0)

    # B[1]: read giống tag/set với A[0]
    offset_b1 = random.choice(range(0, 64, 4))
    addr_b1 = make_shared(shared_prefix, tag_a0, set_a0, offset_b1)
    instr_B.append(f"read\t{to_hex32(addr_b1)}")
    addrs.append(addr_b1)

    with open(path_A, "w") as f:
        for line in instr_A: f.write(line + "\n")
    with open(path_B, "w") as f:
        for line in instr_B: f.write(line + "\n")

    written = set()
    with open(path_mem, "w") as f:
        for addr in addrs:
            base = addr & ~0x3F
            if base in written: continue
            written.add(base)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(base)] + words) + "\n")

    print("testcase 98 created")
def testcase_99():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "subsystem_testcase/testcase_99/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_shared(p, t, s, o): return (p << 16) | (t << 10) | (s << 6) | o

    instr_A, instr_B, addrs = [], [], []
    shared_prefix = random.choice([0x0002, 0x0003])
    used_combos = set()

    # A[0]: read1
    while True:
        tag_a0 = random.randint(0, 0x3F)
        set_a0 = random.randint(0, 0xF)
        if (tag_a0, set_a0) not in used_combos:
            used_combos.add((tag_a0, set_a0))
            break
    offset_a0 = random.choice(range(0, 64, 4))
    addr_a0 = make_shared(shared_prefix, tag_a0, set_a0, offset_a0)
    instr_A.append(f"read\t{to_hex32(addr_a0)}")
    addrs.append(addr_a0)

    # A[1]: read2 khác set/tag
    while True:
        tag_a1 = random.randint(0, 0x3F)
        set_a1 = random.randint(0, 0xF)
        if (tag_a1, set_a1) not in used_combos:
            used_combos.add((tag_a1, set_a1))
            break
    offset_a1 = random.choice(range(0, 64, 4))
    addr_a1 = make_shared(shared_prefix, tag_a1, set_a1, offset_a1)
    instr_A.append(f"read\t{to_hex32(addr_a1)}")
    addrs.append(addr_a1)

    # B[0-1]: read khác hoàn toàn với A
    while len(instr_B) < 2:
        tag_b = random.randint(0, 0x3F)
        set_b = random.randint(0, 0xF)
        if (tag_b, set_b) not in used_combos:
            used_combos.add((tag_b, set_b))
            offset = random.choice(range(0, 64, 4))
            addr = make_shared(shared_prefix, tag_b, set_b, offset)
            instr_B.append(f"read\t{to_hex32(addr)}")
            addrs.append(addr)

    with open(path_A, "w") as f:
        for line in instr_A: f.write(line + "\n")
    with open(path_B, "w") as f:
        for line in instr_B: f.write(line + "\n")

    written = set()
    with open(path_mem, "w") as f:
        for addr in addrs:
            base = addr & ~0x3F
            if base in written: continue
            written.add(base)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(base)] + words) + "\n")

    print("testcase 99 created")
def testcase_100():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "subsystem_testcase/testcase_100/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_shared(p, t, s, o): return (p << 16) | (t << 10) | (s << 6) | o

    instr_A, instr_B, addrs = [], [], []
    shared_prefix = random.choice([0x0002, 0x0003])
    used_combos = set()
    used_sets = set()

    # A[0]: read1
    while True:
        tag_a0 = random.randint(0, 0x3F)
        set_a0 = random.randint(0, 0xF)
        if (tag_a0, set_a0) not in used_combos:
            used_combos.add((tag_a0, set_a0))
            break
    offset_a0 = random.choice(range(0, 64, 4))
    addr_a0 = make_shared(shared_prefix, tag_a0, set_a0, offset_a0)
    instr_A.append(f"read\t{to_hex32(addr_a0)}")
    addrs.append(addr_a0)

    # A[1]: read2 khác set/tag
    while True:
        tag_a1 = random.randint(0, 0x3F)
        set_a1 = random.randint(0, 0xF)
        if (tag_a1, set_a1) not in used_combos:
            used_combos.add((tag_a1, set_a1))
            break
    offset_a1 = random.choice(range(0, 64, 4))
    addr_a1 = make_shared(shared_prefix, tag_a1, set_a1, offset_a1)
    instr_A.append(f"read\t{to_hex32(addr_a1)}")
    addrs.append(addr_a1)

    # B[0]: read khác tag/set với A
    while True:
        tag_b0 = random.randint(0, 0x3F)
        set_b0 = random.randint(0, 0xF)
        if (tag_b0, set_b0) not in used_combos:
            used_combos.add((tag_b0, set_b0))
            break
    offset_b0 = random.choice(range(0, 64, 4))
    addr_b0 = make_shared(shared_prefix, tag_b0, set_b0, offset_b0)
    instr_B.append(f"read\t{to_hex32(addr_b0)}")
    addrs.append(addr_b0)

    # Tạo 10 read/write ngẫu nhiên khác set
    used_sets.add(set_a0)
    used_sets.add(set_a1)
    for _ in range(10):
        while True:
            new_set = random.randint(0, 0xF)
            if new_set not in used_sets:
                used_sets.add(new_set)
                break
        tag = random.randint(0, 0x3F)
        offset = random.choice(range(0, 64, 4))
        addr = make_shared(shared_prefix, tag, new_set, offset)
        if random.choice([True, False]):
            instr_B.append(f"read\t{to_hex32(addr)}")
        else:
            data = to_hex32(random.getrandbits(32))
            instr_B.append(f"write\t{to_hex32(addr)}\t{data}")
        addrs.append(addr)

    # B[1]: write cùng tag/set với A[0]
    offset_b1 = random.choice(range(0, 64, 4))
    addr_b1 = make_shared(shared_prefix, tag_a0, set_a0, offset_b1)
    data_b1 = to_hex32(random.getrandbits(32))
    instr_B.append(f"write\t{to_hex32(addr_b1)}\t{data_b1}")
    addrs.append(addr_b1)

    with open(path_A, "w") as f:
        for line in instr_A: f.write(line + "\n")
    with open(path_B, "w") as f:
        for line in instr_B: f.write(line + "\n")

    written = set()
    with open(path_mem, "w") as f:
        for addr in addrs:
            base = addr & ~0x3F
            if base in written: continue
            written.add(base)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(base)] + words) + "\n")

    print("testcase 100 created")
def testcase_101():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "subsystem_testcase/testcase_101/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_shared(p, t, s, o): return (p << 16) | (t << 10) | (s << 6) | o

    instr_A, instr_B, addrs = [], [], []
    shared_prefix = random.choice([0x0002, 0x0003])
    used_combos = set()

    # A[0]: read
    while True:
        tag_a0 = random.randint(0, 0x3F)
        set_a0 = random.randint(0, 0xF)
        if (tag_a0, set_a0) not in used_combos:
            used_combos.add((tag_a0, set_a0))
            break
    offset_a0 = random.choice(range(0, 64, 4))
    addr_a0 = make_shared(shared_prefix, tag_a0, set_a0, offset_a0)
    instr_A.append(f"read\t{to_hex32(addr_a0)}")
    addrs.append(addr_a0)

    # A[1]: read khác set/tag với A[0]
    while True:
        tag_a1 = random.randint(0, 0x3F)
        set_a1 = random.randint(0, 0xF)
        if (tag_a1, set_a1) not in used_combos:
            used_combos.add((tag_a1, set_a1))
            break
    offset_a1 = random.choice(range(0, 64, 4))
    addr_a1 = make_shared(shared_prefix, tag_a1, set_a1, offset_a1)
    instr_A.append(f"read\t{to_hex32(addr_a1)}")
    addrs.append(addr_a1)

    # B[0]: read khác với A
    while True:
        tag_b0 = random.randint(0, 0x3F)
        set_b0 = random.randint(0, 0xF)
        if (tag_b0, set_b0) not in used_combos:
            used_combos.add((tag_b0, set_b0))
            break
    offset_b0 = random.choice(range(0, 64, 4))
    addr_b0 = make_shared(shared_prefix, tag_b0, set_b0, offset_b0)
    instr_B.append(f"read\t{to_hex32(addr_b0)}")
    addrs.append(addr_b0)

    # B[1]: write khác tag/set với A[0]
    while True:
        tag_b1 = random.randint(0, 0x3F)
        set_b1 = random.randint(0, 0xF)
        if (tag_b1 != tag_a0 or set_b1 != set_a0) and (tag_b1, set_b1) not in used_combos:
            used_combos.add((tag_b1, set_b1))
            break
    offset_b1 = random.choice(range(0, 64, 4))
    addr_b1 = make_shared(shared_prefix, tag_b1, set_b1, offset_b1)
    data_b1 = to_hex32(random.getrandbits(32))
    instr_B.append(f"write\t{to_hex32(addr_b1)}\t{data_b1}")
    addrs.append(addr_b1)

    with open(path_A, "w") as f:
        for line in instr_A: f.write(line + "\n")
    with open(path_B, "w") as f:
        for line in instr_B: f.write(line + "\n")

    written = set()
    with open(path_mem, "w") as f:
        for addr in addrs:
            base = addr & ~0x3F
            if base in written: continue
            written.add(base)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(base)] + words) + "\n")

    print("testcase 101 created")
def testcase_102():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "subsystem_testcase/testcase_102/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_shared(p, t, s, o): return (p << 16) | (t << 10) | (s << 6) | o

    instr_A, instr_B, addrs = [], [], []
    shared_prefix = random.choice([0x0002, 0x0003])
    used_combos = set()
    used_sets = set()

    # A[0]: read
    while True:
        tag_a0 = random.randint(0, 0x3F)
        set_a0 = random.randint(0, 0xF)
        if (tag_a0, set_a0) not in used_combos:
            used_combos.add((tag_a0, set_a0))
            break
    offset_a0 = random.choice(range(0, 64, 4))
    addr_a0 = make_shared(shared_prefix, tag_a0, set_a0, offset_a0)
    instr_A.append(f"read\t{to_hex32(addr_a0)}")
    addrs.append(addr_a0)

    # A[1]: write khác set/tag với A[0]
    while True:
        tag_a1 = random.randint(0, 0x3F)
        set_a1 = random.randint(0, 0xF)
        if (tag_a1, set_a1) not in used_combos:
            used_combos.add((tag_a1, set_a1))
            break
    offset_a1 = random.choice(range(0, 64, 4))
    addr_a1 = make_shared(shared_prefix, tag_a1, set_a1, offset_a1)
    data_a1 = to_hex32(random.getrandbits(32))
    instr_A.append(f"write\t{to_hex32(addr_a1)}\t{data_a1}")
    addrs.append(addr_a1)

    # Tạo 10 read/write ngẫu nhiên khác set
    used_sets.add(set_a0)
    used_sets.add(set_a1)
    for _ in range(10):
        while True:
            new_set = random.randint(0, 0xF)
            if new_set not in used_sets:
                used_sets.add(new_set)
                break
        tag = random.randint(0, 0x3F)
        offset = random.choice(range(0, 64, 4))
        addr = make_shared(shared_prefix, tag, new_set, offset)
        if random.choice([True, False]):
            instr_B.append(f"read\t{to_hex32(addr)}")
        else:
            data = to_hex32(random.getrandbits(32))
            instr_B.append(f"write\t{to_hex32(addr)}\t{data}")
        addrs.append(addr)

    # B[0]: read khác với tất cả A
    while True:
        tag_b0 = random.randint(0, 0x3F)
        set_b0 = random.randint(0, 0xF)
        if (tag_b0, set_b0) not in used_combos:
            used_combos.add((tag_b0, set_b0))
            break
    offset_b0 = random.choice(range(0, 64, 4))
    addr_b0 = make_shared(shared_prefix, tag_b0, set_b0, offset_b0)
    instr_B.append(f"read\t{to_hex32(addr_b0)}")
    addrs.append(addr_b0)

    # B[1]: read giống tag/set với A[0]
    offset_b1 = random.choice(range(0, 64, 4))
    addr_b1 = make_shared(shared_prefix, tag_a0, set_a0, offset_b1)
    instr_B.append(f"read\t{to_hex32(addr_b1)}")
    addrs.append(addr_b1)

    with open(path_A, "w") as f:
        for line in instr_A: f.write(line + "\n")
    with open(path_B, "w") as f:
        for line in instr_B: f.write(line + "\n")

    written = set()
    with open(path_mem, "w") as f:
        for addr in addrs:
            base = addr & ~0x3F
            if base in written: continue
            written.add(base)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(base)] + words) + "\n")

    print("testcase 102 created")
def testcase_103():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "subsystem_testcase/testcase_103/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_shared(p, t, s, o): return (p << 16) | (t << 10) | (s << 6) | o

    instr_A, instr_B, addrs = [], [], []
    shared_prefix = random.choice([0x0002, 0x0003])
    used_combos = set()

    # A[0]: read
    while True:
        tag_a0 = random.randint(0, 0x3F)
        set_a0 = random.randint(0, 0xF)
        if (tag_a0, set_a0) not in used_combos:
            used_combos.add((tag_a0, set_a0))
            break
    offset_a0 = random.choice(range(0, 64, 4))
    addr_a0 = make_shared(shared_prefix, tag_a0, set_a0, offset_a0)
    instr_A.append(f"read\t{to_hex32(addr_a0)}")
    addrs.append(addr_a0)

    # A[1]: write khác set/tag
    while True:
        tag_a1 = random.randint(0, 0x3F)
        set_a1 = random.randint(0, 0xF)
        if (tag_a1, set_a1) not in used_combos:
            used_combos.add((tag_a1, set_a1))
            break
    offset_a1 = random.choice(range(0, 64, 4))
    addr_a1 = make_shared(shared_prefix, tag_a1, set_a1, offset_a1)
    data_a1 = to_hex32(random.getrandbits(32))
    instr_A.append(f"write\t{to_hex32(addr_a1)}\t{data_a1}")
    addrs.append(addr_a1)

    # B[0-1]: 2 read khác hoàn toàn với A
    while len(instr_B) < 2:
        tag_b = random.randint(0, 0x3F)
        set_b = random.randint(0, 0xF)
        if (tag_b, set_b) not in used_combos:
            used_combos.add((tag_b, set_b))
            offset_b = random.choice(range(0, 64, 4))
            addr_b = make_shared(shared_prefix, tag_b, set_b, offset_b)
            instr_B.append(f"read\t{to_hex32(addr_b)}")
            addrs.append(addr_b)

    with open(path_A, "w") as f:
        for line in instr_A: f.write(line + "\n")
    with open(path_B, "w") as f:
        for line in instr_B: f.write(line + "\n")

    written = set()
    with open(path_mem, "w") as f:
        for addr in addrs:
            base = addr & ~0x3F
            if base in written: continue
            written.add(base)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(base)] + words) + "\n")

    print("testcase 103 created")
def testcase_104():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "subsystem_testcase/testcase_104/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_shared(p, t, s, o): return (p << 16) | (t << 10) | (s << 6) | o

    instr_A, instr_B, addrs = [], [], []
    shared_prefix = random.choice([0x0002, 0x0003])
    used_combos = set()

    # A[0]: read
    while True:
        tag_a0 = random.randint(0, 0x3F)
        set_a0 = random.randint(0, 0xF)
        if (tag_a0, set_a0) not in used_combos:
            used_combos.add((tag_a0, set_a0))
            break
    offset_a0 = random.choice(range(0, 64, 4))
    addr_a0 = make_shared(shared_prefix, tag_a0, set_a0, offset_a0)
    instr_A.append(f"read\t{to_hex32(addr_a0)}")
    addrs.append(addr_a0)

    # A[1]: write khác set/tag
    while True:
        tag_a1 = random.randint(0, 0x3F)
        set_a1 = random.randint(0, 0xF)
        if (tag_a1, set_a1) not in used_combos:
            used_combos.add((tag_a1, set_a1))
            break
    offset_a1 = random.choice(range(0, 64, 4))
    addr_a1 = make_shared(shared_prefix, tag_a1, set_a1, offset_a1)
    data_a1 = to_hex32(random.getrandbits(32))
    instr_A.append(f"write\t{to_hex32(addr_a1)}\t{data_a1}")
    addrs.append(addr_a1)

    # B[0]: read khác với tất cả A
    while True:
        tag_b0 = random.randint(0, 0x3F)
        set_b0 = random.randint(0, 0xF)
        if (tag_b0, set_b0) not in used_combos:
            used_combos.add((tag_b0, set_b0))
            break
    offset_b0 = random.choice(range(0, 64, 4))
    addr_b0 = make_shared(shared_prefix, tag_b0, set_b0, offset_b0)
    instr_B.append(f"read\t{to_hex32(addr_b0)}")
    addrs.append(addr_b0)

    # B[1]: write giống set/tag của A[0]
    offset_b1 = random.choice(range(0, 64, 4))
    addr_b1 = make_shared(shared_prefix, tag_a0, set_a0, offset_b1)
    data_b1 = to_hex32(random.getrandbits(32))
    instr_B.append(f"write\t{to_hex32(addr_b1)}\t{data_b1}")
    addrs.append(addr_b1)

    with open(path_A, "w") as f:
        for line in instr_A: f.write(line + "\n")
    with open(path_B, "w") as f:
        for line in instr_B: f.write(line + "\n")

    written = set()
    with open(path_mem, "w") as f:
        for addr in addrs:
            base = addr & ~0x3F
            if base in written: continue
            written.add(base)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(base)] + words) + "\n")

    print("testcase 104 created")
def testcase_105():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "subsystem_testcase/testcase_105/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_shared(p, t, s, o): return (p << 16) | (t << 10) | (s << 6) | o

    instr_A, instr_B, addrs = [], [], []
    shared_prefix = random.choice([0x0002, 0x0003])
    used_combos = set()

    # A[0]: read
    while True:
        tag_a0 = random.randint(0, 0x3F)
        set_a0 = random.randint(0, 0xF)
        if (tag_a0, set_a0) not in used_combos:
            used_combos.add((tag_a0, set_a0))
            break
    offset_a0 = random.choice(range(0, 64, 4))
    addr_a0 = make_shared(shared_prefix, tag_a0, set_a0, offset_a0)
    instr_A.append(f"read\t{to_hex32(addr_a0)}")
    addrs.append(addr_a0)

    # A[1]: write khác set/tag
    while True:
        tag_a1 = random.randint(0, 0x3F)
        set_a1 = random.randint(0, 0xF)
        if (tag_a1, set_a1) not in used_combos:
            used_combos.add((tag_a1, set_a1))
            break
    offset_a1 = random.choice(range(0, 64, 4))
    addr_a1 = make_shared(shared_prefix, tag_a1, set_a1, offset_a1)
    data_a1 = to_hex32(random.getrandbits(32))
    instr_A.append(f"write\t{to_hex32(addr_a1)}\t{data_a1}")
    addrs.append(addr_a1)

    # B[0]: read khác hoàn toàn với A
    while True:
        tag_b0 = random.randint(0, 0x3F)
        set_b0 = random.randint(0, 0xF)
        if (tag_b0, set_b0) not in used_combos:
            used_combos.add((tag_b0, set_b0))
            break
    offset_b0 = random.choice(range(0, 64, 4))
    addr_b0 = make_shared(shared_prefix, tag_b0, set_b0, offset_b0)
    instr_B.append(f"read\t{to_hex32(addr_b0)}")
    addrs.append(addr_b0)

    # B[1]: write khác set/tag với A[0]
    while True:
        tag_b1 = random.randint(0, 0x3F)
        set_b1 = random.randint(0, 0xF)
        if (tag_b1 != tag_a0 or set_b1 != set_a0) and (tag_b1, set_b1) not in used_combos:
            used_combos.add((tag_b1, set_b1))
            break
    offset_b1 = random.choice(range(0, 64, 4))
    addr_b1 = make_shared(shared_prefix, tag_b1, set_b1, offset_b1)
    data_b1 = to_hex32(random.getrandbits(32))
    instr_B.append(f"write\t{to_hex32(addr_b1)}\t{data_b1}")
    addrs.append(addr_b1)

    with open(path_A, "w") as f:
        for line in instr_A: f.write(line + "\n")
    with open(path_B, "w") as f:
        for line in instr_B: f.write(line + "\n")

    written = set()
    with open(path_mem, "w") as f:
        for addr in addrs:
            base = addr & ~0x3F
            if base in written: continue
            written.add(base)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(base)] + words) + "\n")

    print("testcase 105 created")
def testcase_106():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "subsystem_testcase/testcase_106/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_shared(p, t, s, o): return (p << 16) | (t << 10) | (s << 6) | o

    instr_A, instr_B, addrs = [], [], []
    shared_prefix = random.choice([0x0002, 0x0003])
    used_combos = set()

    # A[0] and A[1]: same set/tag, different offset
    tag_a = random.randint(0, 0x3F)
    set_a = random.randint(0, 0xF)
    used_combos.add((tag_a, set_a))

    offset_a0 = random.choice(range(0, 64, 4))
    addr_a0 = make_shared(shared_prefix, tag_a, set_a, offset_a0)
    instr_A.append(f"read\t{to_hex32(addr_a0)}")
    addrs.append(addr_a0)

    offset_a1 = offset_a0
    while offset_a1 == offset_a0:
        offset_a1 = random.choice(range(0, 64, 4))
    addr_a1 = make_shared(shared_prefix, tag_a, set_a, offset_a1)
    instr_A.append(f"read\t{to_hex32(addr_a1)}")
    addrs.append(addr_a1)

    # B[0]: read khác với A
    while True:
        tag_b0 = random.randint(0, 0x3F)
        set_b0 = random.randint(0, 0xF)
        if (tag_b0, set_b0) not in used_combos:
            used_combos.add((tag_b0, set_b0))
            break
    offset_b0 = random.choice(range(0, 64, 4))
    addr_b0 = make_shared(shared_prefix, tag_b0, set_b0, offset_b0)
    instr_B.append(f"read\t{to_hex32(addr_b0)}")
    addrs.append(addr_b0)

    # B[1]: read giống với A[0] (same tag, set, 16-bit prefix)
    offset_b1 = random.choice(range(0, 64, 4))
    addr_b1 = make_shared(shared_prefix, tag_a, set_a, offset_b1)
    instr_B.append(f"read\t{to_hex32(addr_b1)}")
    addrs.append(addr_b1)

    with open(path_A, "w") as f:
        for line in instr_A: f.write(line + "\n")
    with open(path_B, "w") as f:
        for line in instr_B: f.write(line + "\n")

    written = set()
    with open(path_mem, "w") as f:
        for addr in addrs:
            base = addr & ~0x3F
            if base in written: continue
            written.add(base)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(base)] + words) + "\n")

    print("testcase 106 created")

def testcase_107():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "subsystem_testcase/testcase_107/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_shared(p, t, s, o): return (p << 16) | (t << 10) | (s << 6) | o

    instr_A, instr_B, addrs = [], [], []
    shared_prefix = random.choice([0x0002, 0x0003])
    used_tags = set()

    # Chọn set chung
    fixed_set = random.randint(0, 0xF)

    # A: 4 write khác tag
    tag_a_list = []
    addr_A0 = None  # Địa chỉ write đầu tiên của A
    while len(tag_a_list) < 4:
        tag = random.randint(0, 0x3F)
        if tag not in used_tags:
            used_tags.add(tag)
            tag_a_list.append(tag)
            offset = random.choice(range(0, 64, 4))
            addr = make_shared(shared_prefix, tag, fixed_set, offset)
            if len(tag_a_list) == 1:
                addr_A0 = addr  # Lưu lại địa chỉ write đầu tiên
            data = to_hex32(random.getrandbits(32))
            instr_A.append(f"write\t{to_hex32(addr)}\t{data}")
            addrs.append(addr)

    # A[4]: read khác tag hoàn toàn
    while True:
        tag_r = random.randint(0, 0x3F)
        if tag_r not in used_tags:
            used_tags.add(tag_r)
            break
    offset_r = random.choice(range(0, 64, 4))
    addr_r = make_shared(shared_prefix, tag_r, fixed_set, offset_r)

    # Thêm 10 lệnh read vào địa chỉ write đầu tiên của A trước lệnh read cuối
    for _ in range(10):
        instr_A.append(f"read\t{to_hex32(addr_A0)}")
        addrs.append(addr_A0)

    instr_A.append(f"read\t{to_hex32(addr_r)}")
    addrs.append(addr_r)

    # B: 4 write với tag khác hoàn toàn với A, cùng set
    tag_b_list = []
    addr_B0 = None  # Địa chỉ write đầu tiên của B
    while len(tag_b_list) < 4:
        tag = random.randint(0, 0x3F)
        if tag not in used_tags:
            used_tags.add(tag)
            tag_b_list.append(tag)
            offset = random.choice(range(0, 64, 4))
            addr = make_shared(shared_prefix, tag, fixed_set, offset)
            if len(tag_b_list) == 1:
                addr_B0 = addr  # Lưu lại địa chỉ write đầu tiên của B
            data = to_hex32(random.getrandbits(32))
            instr_B.append(f"write\t{to_hex32(addr)}\t{data}")
            addrs.append(addr)

    # Thêm 10 lệnh read vào địa chỉ write đầu tiên của B trước lệnh read cuối
    for _ in range(10):
        instr_B.append(f"read\t{to_hex32(addr_B0)}")
        addrs.append(addr_B0)

    # B[4]: read giống hệt lệnh read cuối của A
    instr_B.append(f"read\t{to_hex32(addr_r)}")
    addrs.append(addr_r)

    with open(path_A, "w") as f:
        for line in instr_A: f.write(line + "\n")
    with open(path_B, "w") as f:
        for line in instr_B: f.write(line + "\n")

    written = set()
    with open(path_mem, "w") as f:
        for addr in addrs:
            base = addr & ~0x3F
            if base in written: continue
            written.add(base)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(base)] + words) + "\n")

    print("testcase 107 created")


def testcase_108():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "subsystem_testcase/testcase_108/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_shared(p, t, s, o): return (p << 16) | (t << 10) | (s << 6) | o

    instr_A, addrs = [], []
    shared_prefix = random.choice([0x0002, 0x0003])
    used_tags = set()
    fixed_set = random.randint(0, 0xF)

    # 4 lệnh read: cùng set, khác tag
    read_tags = []
    while len(read_tags) < 4:
        tag = random.randint(0, 0x3F)
        if tag not in used_tags:
            used_tags.add(tag)
            read_tags.append(tag)
            offset = random.choice(range(0, 64, 4))
            addr = make_shared(shared_prefix, tag, fixed_set, offset)
            instr_A.append(f"read\t{to_hex32(addr)}")
            addrs.append(addr)

    # Chọn 1 tag từ 4 cái trên
    repeat_tag = random.choice(read_tags)
    # 4 lệnh read: cùng tag vừa chọn, cùng set, khác offset
    for _ in range(4):
        offset = random.choice(range(0, 64, 4))
        addr = make_shared(shared_prefix, repeat_tag, fixed_set, offset)
        instr_A.append(f"read\t{to_hex32(addr)}")
        addrs.append(addr)

    # Ghi file
    with open(path_A, "w") as f:
        for line in instr_A: f.write(line + "\n")
    with open(path_B, "w") as f:
        f.write("")

    written = set()
    with open(path_mem, "w") as f:
        for addr in addrs:
            base = addr & ~0x3F
            if base in written: continue
            written.add(base)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(base)] + words) + "\n")

    print("testcase 108 created")
def testcase_109():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "subsystem_testcase/testcase_109/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_shared(p, t, s, o): return (p << 16) | (t << 10) | (s << 6) | o

    instr_A, addrs = [], []
    shared_prefix = random.choice([0x0002, 0x0003])
    used_tags = set()
    fixed_set = random.randint(0, 0xF)

    # 4 lệnh read: cùng set, khác tag
    read_tags = []
    while len(read_tags) < 4:
        tag = random.randint(0, 0x3F)
        if tag not in used_tags:
            used_tags.add(tag)
            read_tags.append(tag)
            offset = random.choice(range(0, 64, 4))
            addr = make_shared(shared_prefix, tag, fixed_set, offset)
            instr_A.append(f"read\t{to_hex32(addr)}")
            addrs.append(addr)

    # Chọn tag từ 4 tag đã đọc
    chosen_tag = random.choice(read_tags)

    # 4 lệnh write: cùng tag vừa chọn, cùng set
    for _ in range(4):
        offset = random.choice(range(0, 64, 4))
        addr = make_shared(shared_prefix, chosen_tag, fixed_set, offset)
        data = to_hex32(random.getrandbits(32))
        instr_A.append(f"write\t{to_hex32(addr)}\t{data}")
        addrs.append(addr)

    with open(path_A, "w") as f:
        for line in instr_A: f.write(line + "\n")
    with open(path_B, "w") as f:
        f.write("")

    written = set()
    with open(path_mem, "w") as f:
        for addr in addrs:
            base = addr & ~0x3F
            if base in written: continue
            written.add(base)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(base)] + words) + "\n")

    print("testcase 109 created")
def testcase_110():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "subsystem_testcase/testcase_110/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_shared(p, t, s, o): return (p << 16) | (t << 10) | (s << 6) | o

    instr_A, addrs = [], []
    shared_prefix = random.choice([0x0002, 0x0003])
    used_tags = set()
    fixed_set = random.randint(0, 0xF)

    # 4 lệnh read: cùng set, khác tag
    while len(used_tags) < 4:
        tag = random.randint(0, 0x3F)
        if tag not in used_tags:
            used_tags.add(tag)
            offset = random.choice(range(0, 64, 4))
            addr = make_shared(shared_prefix, tag, fixed_set, offset)
            instr_A.append(f"read\t{to_hex32(addr)}")
            addrs.append(addr)

    with open(path_A, "w") as f:
        for line in instr_A: f.write(line + "\n")
    with open(path_B, "w") as f:
        f.write("")

    written = set()
    with open(path_mem, "w") as f:
        for addr in addrs:
            base = addr & ~0x3F
            if base in written: continue
            written.add(base)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(base)] + words) + "\n")

    print("testcase 110 created")
def testcase_111():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "subsystem_testcase/testcase_111/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_shared(p, t, s, o): return (p << 16) | (t << 10) | (s << 6) | o

    instr_A, addrs = [], []
    shared_prefix = random.choice([0x0002, 0x0003])
    used_tags = set()
    fixed_set = random.randint(0, 0xF)

    # 4 lệnh write: cùng set, khác tag
    while len(used_tags) < 4:
        tag = random.randint(0, 0x3F)
        if tag not in used_tags:
            used_tags.add(tag)
            offset = random.choice(range(0, 64, 4))
            addr = make_shared(shared_prefix, tag, fixed_set, offset)
            data = to_hex32(random.getrandbits(32))
            instr_A.append(f"write\t{to_hex32(addr)}\t{data}")
            addrs.append(addr)

    with open(path_A, "w") as f:
        for line in instr_A: f.write(line + "\n")
    with open(path_B, "w") as f:
        f.write("")

    written = set()
    with open(path_mem, "w") as f:
        for addr in addrs:
            base = addr & ~0x3F
            if base in written: continue
            written.add(base)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(base)] + words) + "\n")

    print("testcase 111 created")
def testcase_112():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "subsystem_testcase/testcase_112/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_shared(p, t, s, o): return (p << 16) | (t << 10) | (s << 6) | o

    instr_A, addrs = [], []
    shared_prefix = random.choice([0x0002, 0x0003])
    used_tags = set()
    fixed_set = random.randint(0, 0xF)

    # 4 lệnh write: cùng set, khác tag
    while len(used_tags) < 4:
        tag = random.randint(0, 0x3F)
        if tag not in used_tags:
            used_tags.add(tag)
            offset = random.choice(range(0, 64, 4))
            addr = make_shared(shared_prefix, tag, fixed_set, offset)
            data = to_hex32(random.getrandbits(32))
            instr_A.append(f"write\t{to_hex32(addr)}\t{data}")
            addrs.append(addr)

    # 4 lệnh read: cùng set, khác tag (khác với 4 tag đã dùng)
    while len(used_tags) < 8:
        tag = random.randint(0, 0x3F)
        if tag not in used_tags:
            used_tags.add(tag)
            offset = random.choice(range(0, 64, 4))
            addr = make_shared(shared_prefix, tag, fixed_set, offset)
            instr_A.append(f"read\t{to_hex32(addr)}")
            addrs.append(addr)

    with open(path_A, "w") as f:
        for line in instr_A: f.write(line + "\n")
    with open(path_B, "w") as f:
        f.write("")

    written = set()
    with open(path_mem, "w") as f:
        for addr in addrs:
            base = addr & ~0x3F
            if base in written: continue
            written.add(base)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(base)] + words) + "\n")

    print("testcase 112 created")
def testcase_113():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "subsystem_testcase/testcase_113/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_shared(p, t, s, o): return (p << 16) | (t << 10) | (s << 6) | o

    instr_A, addrs = [], []
    shared_prefix = random.choice([0x0002, 0x0003])
    used_tags = set()
    fixed_set = random.randint(0, 0xF)

    while len(used_tags) < 8:
        tag = random.randint(0, 0x3F)
        if tag not in used_tags:
            used_tags.add(tag)
            offset = random.choice(range(0, 64, 4))
            addr = make_shared(shared_prefix, tag, fixed_set, offset)
            data = to_hex32(random.getrandbits(32))
            instr_A.append(f"write\t{to_hex32(addr)}\t{data}")
            addrs.append(addr)

    with open(path_A, "w") as f:
        for line in instr_A: f.write(line + "\n")
    with open(path_B, "w") as f:
        f.write("")

    written = set()
    with open(path_mem, "w") as f:
        for addr in addrs:
            base = addr & ~0x3F
            if base in written: continue
            written.add(base)
            words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(base)] + words) + "\n")

def testcase_114():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "subsystem_testcase/testcase_114/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_shared(p, t, s, o): return (p << 16) | (t << 10) | (s << 6) | o

    shared_prefix = random.choice([0x0002, 0x0003])
    tag = random.randint(0, 0x3F)
    set_ = random.randint(0, 0xF)
    offset = random.choice(range(0, 64, 4))  # Cùng word offset

    addr = make_shared(shared_prefix, tag, set_, offset)

    with open(path_A, "w") as f:
        f.write(f"read\t{to_hex32(addr)}\n")
    with open(path_B, "w") as f:
        f.write(f"read\t{to_hex32(addr)}\n")

    base_addr = addr & ~0x3F
    with open(path_mem, "w") as f:
        words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
        f.write("\t".join([to_hex32(base_addr)] + words) + "\n")

    print("testcase 114 created")

def testcase_115():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "subsystem_testcase/testcase_115/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_shared(p, t, s, o): return (p << 16) | (t << 10) | (s << 6) | o

    shared_prefix = random.choice([0x0002, 0x0003])
    set_ = random.randint(0, 0xF)
    used_tags = set()
    instructions_A, instructions_B, all_addrs = [], [], []

    # Tạo 2 lệnh read cho memA: cùng set, khác tag
    while len(used_tags) < 2:
        tag = random.randint(0, 0x3F)
        if tag in used_tags: continue
        used_tags.add(tag)
        offset = random.choice(range(0, 64, 4))
        addr = make_shared(shared_prefix, tag, set_, offset)
        instructions_A.append(f"read\t{to_hex32(addr)}")
        all_addrs.append(addr)

    # Tạo 2 lệnh read cho memB: cùng set, tag khác memA
    while len(used_tags) < 4:
        tag = random.randint(0, 0x3F)
        if tag in used_tags: continue
        used_tags.add(tag)
        offset = random.choice(range(0, 64, 4))
        addr = make_shared(shared_prefix, tag, set_, offset)
        instructions_B.append(f"read\t{to_hex32(addr)}")
        all_addrs.append(addr)

    with open(path_A, "w") as f:
        for line in instructions_A: f.write(line + "\n")
    with open(path_B, "w") as f:
        for line in instructions_B: f.write(line + "\n")

    written_blocks = set()
    with open(path_mem, "w") as f:
        for addr in all_addrs:
            base = addr & ~0x3F
            if base in written_blocks: continue
            written_blocks.add(base)
            data_words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(base)] + data_words) + "\n")

    print("testcase 115 created")
def testcase_116():
    def to_hex32(v): return f"0x{v:08X}"
    base_path = "subsystem_testcase/testcase_116/"
    os.makedirs(base_path, exist_ok=True)
    path_A = os.path.join(base_path, "instr_mem_A.mem")
    path_B = os.path.join(base_path, "instr_mem_B.mem")
    path_mem = os.path.join(base_path, "main_memory_init.mem")
    def make_shared(p, t, s, o): return (p << 16) | (t << 10) | (s << 6) | o

    shared_prefix = random.choice([0x0002, 0x0003])
    set_ = random.randint(0, 0xF)
    used_tags = set()
    instructions_A, instructions_B, all_addrs = [], [], []

    # memA: 2 lệnh write
    while len(used_tags) < 2:
        tag = random.randint(0, 0x3F)
        if tag in used_tags: continue
        used_tags.add(tag)
        offset = random.choice(range(0, 64, 4))
        addr = make_shared(shared_prefix, tag, set_, offset)
        data = to_hex32(random.getrandbits(32))
        instructions_A.append(f"write\t{to_hex32(addr)}\t{data}")
        all_addrs.append(addr)

    # memB: 2 lệnh write khác tag
    while len(used_tags) < 4:
        tag = random.randint(0, 0x3F)
        if tag in used_tags: continue
        used_tags.add(tag)
        offset = random.choice(range(0, 64, 4))
        addr = make_shared(shared_prefix, tag, set_, offset)
        data = to_hex32(random.getrandbits(32))
        instructions_B.append(f"write\t{to_hex32(addr)}\t{data}")
        all_addrs.append(addr)

    with open(path_A, "w") as f:
        for line in instructions_A: f.write(line + "\n")
    with open(path_B, "w") as f:
        for line in instructions_B: f.write(line + "\n")

    written_blocks = set()
    with open(path_mem, "w") as f:
        for addr in all_addrs:
            base = addr & ~0x3F
            if base in written_blocks: continue
            written_blocks.add(base)
            data_words = [to_hex32(random.getrandbits(32)) for _ in range(16)]
            f.write("\t".join([to_hex32(base)] + data_words) + "\n")

    print("testcase 116 created")







def main():
    # Danh sách các hàm testcase
    list_testcases = [
        testcase_1, testcase_2, testcase_3, testcase_4, testcase_5, testcase_6, testcase_7, testcase_8,
        testcase_9, testcase_10, testcase_11, testcase_12, testcase_13, testcase_14, testcase_15, testcase_16,
        testcase_17, testcase_18, testcase_19, testcase_20, testcase_21, testcase_22, testcase_23, testcase_24,
        testcase_25, testcase_26, testcase_27, testcase_28, testcase_29, testcase_30, testcase_31, testcase_32,
        testcase_33, testcase_34, testcase_35, testcase_36, testcase_37, testcase_38, testcase_39, testcase_40,
        testcase_41, testcase_42, testcase_43, testcase_44, testcase_45, testcase_46, testcase_47, testcase_48,
        testcase_49, testcase_50, testcase_51, testcase_52, testcase_53, testcase_54, testcase_55, testcase_56,
        testcase_57, testcase_58, testcase_59, testcase_60, testcase_61, testcase_62, testcase_63, testcase_64,
        testcase_65, testcase_66, testcase_67, testcase_68, testcase_69, testcase_70, testcase_71, testcase_72,
        testcase_73, testcase_74, testcase_75, testcase_76, testcase_77, testcase_78, testcase_79, testcase_80,
        testcase_81, testcase_82, testcase_83, testcase_84, testcase_85, testcase_86, testcase_87, testcase_88,
        testcase_89, testcase_90, testcase_91, testcase_92, testcase_93, testcase_94, testcase_95, testcase_96,
        testcase_97, testcase_98, testcase_99, testcase_100, testcase_101, testcase_102, testcase_103,
        testcase_104, testcase_105, testcase_106, testcase_107, testcase_108, testcase_109, testcase_110,
        testcase_111, testcase_112, testcase_113, testcase_114, testcase_115, testcase_116
    ]


    print("========== MENU TẠO TESTCASE ==========")
    print("1. Tạo tất cả 116 testcase")
    print("2. Tạo testcase cụ thể")

    choice = input("Nhập lựa chọn (1 hoặc 2): ")

    if choice == '1':
        # Gọi tuần tự tất cả các hàm testcase
        for func in list_testcases:
            func()
    elif choice == '2':
        # Yêu cầu người dùng nhập số testcase mong muốn
        tc_number = input("Nhập testcase muốn tạo (1-116): ")
        if tc_number.isdigit():
            tc_number = int(tc_number)
            if 1 <= tc_number <= 117:
                # Gọi hàm tương ứng (do index trong list bắt đầu từ 0)
                list_testcases[tc_number - 1]()
                inspect_testcase(f"subsystem_testcase/{list_testcases[tc_number - 1].__name__}")
            else:
                print("Số testcase không hợp lệ!")
        else:
            print("Vui lòng nhập số hợp lệ!")
    else:
        print("Lựa chọn không hợp lệ!")


if __name__ == "__main__":
    main()
