import os
from bi_directional_port import *
from transaction import *
from system_common import *
import copy
from collections import defaultdict

class cache_block:
    def __init__(self):
        self.addr = 0
        self.data = [0] * 16
        self.index = 0


class main_memory:
    def __init__(self, name='', init_dir_path='testcase', result_dir_path='result'):
        self.name = name
        print(f"{self.name} is created!")

        # path to load and save to file
        self.init_path = os.path.join(init_dir_path, f'main_memory_init.mem')
        self.result_path = os.path.join(result_dir_path, f'main_memory_result.mem')

        # ports
        self.m_port = bi_directional_port(self.name+'.m_port')

        # state
        self.r_state = 'R_IDLE'
        self.r_next_state = 'R_IDLE'

        self.w_state = 'W_IDLE'
        self.w_next_state = 'W_IDLE'

        # data ram
        self.data_ram = []

        # queue
        self.read_q = []
        self.write_q = []

        # current master
        self.current_master = 0

        # counter
        self.r_word_cnt = 0
        self.w_word_cnt = 0

        # load mem
        self.load_mem()


    def load_mem(self):
        with open(self.init_path, "r") as file:
            self.data_ram = []
            for line in file:
                if not line.strip():
                    continue  # Skip empty lines
                parts = line.strip().split("\t")
                if len(parts) != 17:
                    continue  # Ensure correct format

                block = cache_block()
                block.addr = int(parts[0], 16)
                block.data = [int(x, 16) for x in reversed(parts[1:])]
                self.data_ram.append(block)
        # print(f"Loaded {len(self.data_ram)} blocks into data_ram.")

    def find_hit_block(self, addr):
        for index, block in enumerate(self.data_ram):
            if block.addr == addr:
                return index
        return -1  # Return -1 if no matching block is found

    def find_w_req(self, source_id):
        for i, req in enumerate(self.write_q):
            if req.source_id == source_id:
                return self.write_q.pop(i)
        return None

    def read_word(self, addr, block_offset):
        index = self.find_hit_block(addr)
        if index == -1:
            print(f"Address {addr:#010x} not found in data_ram.")
            return None

        block = self.data_ram[index]
        if 0 <= block_offset < len(block.data):
            return block.data[block_offset]
        else:
            print(f"Invalid block offset: {block_offset}")
            return None

    def write_word(self, addr, block_offset, value):
        index = self.find_hit_block(addr)
        if index == -1:
            print(f"Address {addr:#010x} not found in data_ram.")
            return False

        block = self.data_ram[index]
        if 0 <= block_offset < len(block.data):
            # block.data[block_offset] = value
            if index == 0:
                print(f'Truong An: {block.index}')
            block.data[block.index] = value
            block.index = (block.index + 1) % 16
            # print(f"Updated block at address {addr:#010x}, offset {block_offset} with value {value:#010x}.")
            return True
        else:
            # print(f"Invalid block offset: {block_offset}")
            return False

    def save_mem(self):
        with open(self.result_path, "w") as file:
            for block in self.data_ram:
                addr_str = f"{block.addr:#010x}"
                data_str = " ".join(f"{x:#010x}" for x in reversed(block.data))
                file.write(f"{addr_str} {data_str}\n")
        # print(f"Saved {len(self.data_ram)} blocks to {self.result_path}.")


    def fcfs_arbiter(self):
        # sort transactions by id (primary) in increasing order: id = 0 (CPU), id = 1 (Other Cache)
        # if two requests from both masters come at the same time, CPU has the higher priority
        if len(self.read_q) > 0:
            self.read_q = sorted(
                self.read_q,
                key=lambda trans: (trans.id, trans.source_id != self.read_q[0].source_id)
            )

        if len(self.write_q) > 0:
            self.write_q = sorted(
                self.write_q,
                key=lambda trans: (trans.id, trans.source_id != self.write_q[0].source_id)
            )

    # def fcfs_arbiter(self):
    #     def sort_grouped(transactions):
    #         # Gom nhóm theo source_id
    #         grouped = defaultdict(list)
    #         for trans in transactions:
    #             grouped[trans.source_id].append(trans)
    #
    #         # Sắp từng nhóm theo trans.id
    #         for group in grouped.values():
    #             group.sort(key=lambda t: t.id)
    #
    #         # Sắp các nhóm theo trans.id nhỏ nhất trong nhóm
    #         sorted_groups = sorted(grouped.values(), key=lambda g: g[0].id)
    #
    #         # Ghép lại thành danh sách cuối cùng
    #         return [t for group in sorted_groups for t in group]
    #
    #     if len(self.write_q) > 0:
    #         self.write_q = sort_grouped(self.write_q)
    #
    #     if len(self.read_q) > 0:
    #         self.read_q = sort_grouped(self.read_q)


    def receive_master(self):
        if self.m_port.m_valid:
            m_req = self.m_port.recv_master()
            if m_req.wr_en:
                self.write_q.append(m_req)
            else:
                self.read_q.append(m_req)

        self.fcfs_arbiter()


    def read_mem(self, sys_c):
        if self.r_state == 'R_IDLE':
            if len(self.read_q):
                self.r_next_state = 'R_ADDR'
                print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {self.name.ljust(10, ' ')}: Received a Read Request!")
        elif self.r_state == 'R_ADDR':
            r_req = copy.deepcopy(self.read_q[0])
            block_index = self.find_hit_block(r_req.addr)
            if block_index == -1:
                new_block = cache_block()
                new_block.addr = r_req.addr
                self.data_ram.append(new_block)
            self.r_next_state = 'R_DATA'
        elif self.r_state == 'R_DATA':
            resp_trans = copy.deepcopy(self.read_q[0])
            if self.m_port.m_ready and resp_trans.source_id == 0:
                resp_trans.data = self.read_word(resp_trans.addr, self.r_word_cnt)
                resp_trans.rlast = self.r_word_cnt == 15
                self.m_port.send_master(resp_trans)
                self.r_word_cnt = self.r_word_cnt + 1
                if self.r_word_cnt == 16:
                    self.read_q.pop(0)
                    self.r_next_state = 'R_IDLE'
                    self.r_word_cnt = 0
                    print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {self.name.ljust(10, ' ')}: Completed reading 16-word to Master0!")
            if self.m_port.m_ready and resp_trans.source_id == 1:
                resp_trans.data = self.read_word(resp_trans.addr, self.r_word_cnt)
                resp_trans.rlast = self.r_word_cnt == 15
                self.m_port.send_master(resp_trans)
                self.r_word_cnt = self.r_word_cnt + 1
                if self.r_word_cnt == 16:
                    self.read_q.pop(0)
                    self.r_next_state = 'R_IDLE'
                    self.r_word_cnt = 0
                    print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {self.name.ljust(10, ' ')}: Completed reading 16-word to Master1!")


    def write_mem(self, sys_c):
        if self.w_state == 'W_IDLE':
            if len(self.write_q):
                self.w_next_state = 'W_ADDR'
                print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {self.name.ljust(10, ' ')}: Received a Write Request!")
        elif self.w_state == 'W_ADDR':
            self.current_master = self.write_q[0].source_id
            w_req = copy.deepcopy(self.write_q[0])
            block_index = self.find_hit_block(w_req.addr)
            if block_index == -1:
                new_block = cache_block()
                new_block.addr = w_req.addr
                self.data_ram.append(new_block)
            self.w_next_state = 'W_DATA'
        elif self.w_state == 'W_DATA':
            if len(self.write_q):
                # w_req = copy.deepcopy(self.write_q[0])
                w_req = self.find_w_req(self.current_master)
                if w_req == None:
                    return
                # if self.w_word_cnt == 15:
                if self.current_master == w_req.source_id:
                    if w_req.wlast:
                        if self.m_port.m_ready and w_req.source_id == 0:
                            self.write_word(w_req.addr, self.w_word_cnt, w_req.data)
                            # self.write_q.pop(0)
                            w_req.wdone = 1
                            self.m_port.send_master(w_req)
                            self.w_next_state = 'W_IDLE'
                            self.w_word_cnt = 0
                            print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {self.name.ljust(10, ' ')}: Completed writing 16-word from Master0!")
                        elif self.m_port.m_ready and w_req.source_id == 1:
                            self.write_word(w_req.addr, self.w_word_cnt, w_req.data)
                            # self.write_q.pop(0)
                            w_req.wdone = 1
                            self.m_port.send_master(w_req)
                            self.w_next_state = 'W_IDLE'
                            self.w_word_cnt = 0
                            print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {self.name.ljust(10, ' ')}: Completed writing 16-word from Master1!")
                    else:
                        self.write_word(w_req.addr, self.w_word_cnt, w_req.data)
                        # self.write_q.pop(0)
                        self.w_word_cnt = self.w_word_cnt + 1
                else:
                    print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {self.name.ljust(10, ' ')}: Waitting from Master{self.current_master}!")

    def update(self):
        # update state and next_state
        self.r_state = self.r_next_state
        self.r_next_state = self.r_state

        self.w_state = self.w_next_state
        self.w_next_state = self.w_state

        # update ports
        self.m_port.update()


    def run(self, sys_c):
        self.receive_master()
        self.read_mem(sys_c)
        self.write_mem(sys_c)
