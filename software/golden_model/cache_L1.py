# ******************************************************************************************************
# this class define a 4-way set associative cache L1 support: MOESI, PLRUt, Write-back, Read&Write Allocate
# ******************************************************************************************************

import os
from state_tag_mem_L1 import *
from data_mem_L1 import *
from PLRUt_mem_L1 import *
from PLRUt_controller_L1 import *
from MOESI_controller_L1 import *
from bi_directional_port import *
import copy

class cache_L1:
    def __init__(self, name='', expected_result_dir_path='result'):
        self.name = name
        print(f"{self.name} is created!")
        # path to mem file
        self.state_tag_path = os.path.join(expected_result_dir_path, f'state_tag_{self.name[len(self.name)-1]}.mem')
        self.plrut_ram_path = os.path.join(expected_result_dir_path, f'plrut_ram_{self.name[len(self.name)-1]}.mem')
        self.data_ram_path  = os.path.join(expected_result_dir_path, f'data_ram_{self.name[len(self.name)-1]}.mem')

        # to access other cache
        self.other_cache = None

        # Ports
        # port to CPU
        self.m_port = bi_directional_port(name+'.m_port', PORT_BUF_WIDTH)
        # port to Cache L1
        self.s_port = bi_directional_port(name+'.s_port', PORT_BUF_WIDTH)
        # port to request other cache
        self.req_port = bi_directional_port(name+'.req_port', PORT_BUF_WIDTH)
        # port to response other cache
        self.resp_port = bi_directional_port(name+'.resp_port', PORT_BUF_WIDTH)

        # State-Tag Mem: State: Modified (M), Owned (O), Exclusive (E), Shared (S), Invalid (I)
        self.state_tag_mem = state_tag_mem_L1('state_tag_mem')

        # Data Mem
        self.data_mem = data_mem_L1('data_mem')

        # PLRUt Mem
        self.PLRUt_mem = PLRUt_mem_L1('PLRUt_mem')

        # MOESI Controller
        self.MOESI_controller = MOESI_controller_L1('MOESI_controller')

        # PLRUt Controller
        self.PLRUt_controller = PLRUt_controller_L1('PLRUt_controller')

        # Cache Controller
        self.state = 'IDLE'  # state: 'IDLE', 'CPU_READ', 'CPU_WRITE', 'READ_MEM', 'WRITE_MEM', 'REQ_BUS', 'RESP_BUS'
        self.next_state = 'IDLE'

        # internal queues
        self.ready_q = []
        self.miss_req_q = []
        self.send2master_q = []
        self.send2bus_q = []

        # internal signals
        self.cache_busy = 0
        self.cache_busy_next = 0

        # current signals for looping 16-word
        self.word_cnt = 0
        self.dl_word_cnt = 0
        self.handshake_done = 0  # is used at 'READ_MEM' state to indicate that fetch req was already sent

        # for modeling delay
        self.check_hit_miss_delay = 0
        self.read_delay = 0
        self.write_delay = 0
        self.resp_other_cache_delay = 0


    # small functions to extract Transaction
    def get_word_offset(self, trans):
        mask = 0b1111  # get 4 bit word offset
        return (trans.addr >> 2) & mask

    def get_set(self, trans):
        mask = 0b1111  # get 4 bit set
        return (trans.addr >> 6) & mask

    def get_tag(self, trans):   # get 22 bit tag
        return trans.addr >> 10

    def is_E(self, trans):
        set = self.get_set(trans)
        tag = self.get_tag(trans)
        hit_way = self.state_tag_mem.get_way_hit(set, tag)
        return self.state_tag_mem.is_E(set, hit_way)

    def is_other_cache_hit(self, trans):
        set = self.get_set(trans)
        tag = self.get_tag(trans)
        return self.other_cache.state_tag_mem.is_hit(set, tag)

    def is_shared_address(self, addr):
        return SHARE_LOWER_BOUND <= addr <= SHARE_UPPER_BOUND

    def fcfs_arbiter(self, sys_c):
        # sort transactions by id (primary) in increasing order: id = 0 (CPU), id = 1 (Other Cache)
        # if two requests from both masters come at the same time, CPU has the higher priority
        if len(self.ready_q) > 0:
            self.ready_q = sorted(
                self.ready_q,
                key=lambda trans: (trans.id, trans.source_id)
            )
        if len(self.ready_q) > 1 and len(set(trans.source_id for trans in self.ready_q)) > 1:
            print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {self.name.ljust(10, ' ')}: Is arbitrating!")

    # receive read/write request from Master (CPU/Other Cache)
    def receive_master(self, sys_c):
        if self.state == 'IDLE':
            # get new request from master
            # receive request from CPU
            if self.m_port.m_valid:
                req = self.m_port.recv_master()
                req.source_id = 0
                self.ready_q.append(req)
                if req.wr_en and req.wlast:
                    print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {self.name.ljust(10, ' ')}: Received a Write Request from Master: {req}")
                else:
                    print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {self.name.ljust(10, ' ')}: Received a Read Request from Master: {req}")
            # receive request from Other Cache
            if self.resp_port.m_valid:
                req = self.resp_port.recv_master()
                req.source_id = 1
                self.ready_q.append(req)
                if req.wr_en:
                    print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {self.name.ljust(10, ' ')}: Received a Write Request from Other Cache: {req}")
                else:
                    print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {self.name.ljust(10, ' ')}: Received a Read Request from Other Cache: {req}")
            # arbitrating
            self.fcfs_arbiter(sys_c)
            # handle next trans
            if len(self.ready_q) > 0:
                req = self.ready_q[0]
                # CPU access
                if req.source_id == 0:
                    if req.wr_en:
                        self.next_state = 'CPU_WRITE'
                    else:
                        self.next_state = 'CPU_READ'
                elif req.source_id == 1:
                    self.next_state = 'RESP_BUS'
                self.cache_busy_next = 1
                self.word_cnt = 0

    def read_handler(self, sys_c):
        if self.state == 'CPU_READ':
            if not self.cache_busy:             # handle next trans
                # get new request from master
                # receive request from CPU
                if self.m_port.m_valid:
                    req = self.m_port.recv_master()
                    req.source_id = 0
                    self.ready_q.append(req)
                    if req.wr_en and req.wlast:
                        print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {self.name.ljust(10, ' ')}: Received a Write Request from Master: {req}")
                    else:
                        print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {self.name.ljust(10, ' ')}: Received a Read Request from Master: {req}")
                # receive request from Other Cache
                if self.resp_port.m_valid:
                    req = self.resp_port.recv_master()
                    req.source_id = 1
                    self.ready_q.append(req)
                    if req.wr_en:
                        print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {self.name.ljust(10, ' ')}: Received a Write Request from Other Cache: {req}")
                    else:
                        print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {self.name.ljust(10, ' ')}: Received a Read Request from Other Cache: {req}")
                # arbitrating
                self.fcfs_arbiter(sys_c)
                # handle next trans
                if len(self.ready_q) > 0:
                    req = self.ready_q[0]
                    # CPU access
                    if req.source_id == 0:
                        if req.wr_en:
                            self.next_state = 'CPU_WRITE'
                        else:
                            self.next_state = 'CPU_READ'
                    elif req.source_id == 1:
                        self.next_state = 'RESP_BUS'
                    self.cache_busy_next = 1
                    self.word_cnt = 0
            else:                               # handle current trans
                if self.check_hit_miss_delay == CHECK_HIT_MISS_DELAY_L1:    # delay when check hit or miss
                    read_req = copy.deepcopy(self.ready_q[0])         # just get(), not pop()
                    set = self.get_set(read_req)
                    tag = self.get_tag(read_req)
                    PLRUt = self.PLRUt_mem.read(set)
                    valid = self.state_tag_mem.get_set_valid(set)
                    full = self.state_tag_mem.is_full(set)
                    hit = self.state_tag_mem.is_hit(set, tag)
                    word_offset = self.get_word_offset(read_req)
                    if hit:                                 # cache hit
                        if self.read_delay == CACHE_READ_DELAY_L1:
                            # get hit way
                            print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {self.name.ljust(10, ' ')}: Has a Read Hit Access!")
                            hit_way = self.state_tag_mem.get_way_hit(set, tag)
                            if self.word_cnt == 0:      # need to add additional condition to ensure cache do not send more data than required
                                # read 1-word           # example (when CPU busy and not ready to receive data, word_cnt still = 0, but read data is already put to send2master_q)
                                read_req.data = self.data_mem.read(set, hit_way, word_offset)
                                read_req.rlast = 1
                                self.send2master_q.append(read_req)
                            if self.word_cnt == 1:
                                # update PLRUt bits
                                PLRUt_next = self.PLRUt_controller.get_new_PLRUt(hit, full, valid, hit_way, PLRUt)
                                self.PLRUt_mem.write(set, PLRUt_next, 1)
                                self.cache_busy_next = 0
                                self.word_cnt = 0
                                self.ready_q.pop(0)          # remove done read trans
                                self.read_delay = 0
                                self.check_hit_miss_delay = 0
                                print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {self.name.ljust(10, ' ')}: Completed Sending Read Data to Master for Read Request!")
                        else:
                            if self.read_delay == 0:
                                print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {self.name.ljust(10, ' ')}: Delay {CACHE_READ_DELAY_L1} cycles to Read Data from Its Mem!")
                            self.read_delay = self.read_delay + 1
                    else:                                   # cache  miss
                        print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {self.name.ljust(10, ' ')}: Has a Read Miss Access: {read_req}")
                        victim_way = self.PLRUt_controller.find_victim_way(full, valid, PLRUt)
                        if self.state_tag_mem.is_dirty(victim_way, set):
                            self.state_tag_mem.way_arr[victim_way].write_state(set, self.state_tag_mem.way_arr[victim_way].I, 1)
                            self.next_state = 'WRITE_MEM'
                            print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {self.name.ljust(10, ' ')}: Write-back to Slave!")
                        elif self.is_shared_address(read_req.addr) and self.is_other_cache_hit(read_req):
                            self.next_state = 'REQ_BUS'
                            read_req.snoop_type = 0
                            print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {self.name.ljust(10, ' ')}: Request to get Cache Block from Other Cache!")
                        else:
                            self.next_state = 'READ_MEM'
                            print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {self.name.ljust(10, ' ')}: Fetch from Slave!")
                        self.miss_req_q.append(read_req)
                        self.word_cnt = 0
                        self.check_hit_miss_delay = 0
                else:
                    if self.check_hit_miss_delay == 0:
                        print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {self.name.ljust(10, ' ')}: Delay {CHECK_HIT_MISS_DELAY_L1} cycles to check Read Hit/Miss!")
                    self.check_hit_miss_delay = self.check_hit_miss_delay + 1

    def write_handler(self, sys_c):
        if self.state == 'CPU_WRITE':
            if not self.cache_busy:             # handle next trans
                # get new request from master
                # receive request from CPU
                if self.m_port.m_valid:
                    req = self.m_port.recv_master()
                    req.source_id = 0
                    self.ready_q.append(req)
                    if req.wr_en and req.wlast:
                        print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {self.name.ljust(10, ' ')}: Received a Write Request from Master: {req}")
                    else:
                        print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {self.name.ljust(10, ' ')}: Received a Read Request from Master: {req}")
                # receive request from Other Cache
                if self.resp_port.m_valid:
                    req = self.resp_port.recv_master()
                    req.source_id = 1
                    self.ready_q.append(req)
                    if req.wr_en:
                        print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {self.name.ljust(10, ' ')}: Received a Write Request from Other Cache: {req}")
                    else:
                        print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {self.name.ljust(10, ' ')}: Received a Read Request from Other Cache: {req}")
                # arbitrating
                self.fcfs_arbiter(sys_c)
                # handle next trans
                if len(self.ready_q) > 0:
                    req = self.ready_q[0]
                    # CPU access
                    if req.source_id == 0:
                        if req.wr_en:
                            self.next_state = 'CPU_WRITE'
                        else:
                            self.next_state = 'CPU_READ'
                    elif req.source_id == 1:
                        self.next_state = 'RESP_BUS'
                    self.cache_busy_next = 1
                    self.word_cnt = 0
            else:                               # handle current trans
                if self.check_hit_miss_delay == CHECK_HIT_MISS_DELAY_L1:  # delay when check hit or miss
                    write_req = copy.deepcopy(self.ready_q[0])        # just get(), not pop()
                    set = self.get_set(write_req)
                    tag = self.get_tag(write_req)
                    PLRUt = self.PLRUt_mem.read(set)
                    valid = self.state_tag_mem.get_set_valid(set)
                    full = self.state_tag_mem.is_full(set)
                    hit = self.state_tag_mem.is_hit(set, tag)
                    word_offset = self.get_word_offset(write_req)
                    if hit:                                 # cache hit
                        # if self.write_delay == CACHE_WRITE_DELAY_L1:
                        if self.is_shared_address(write_req.addr) and (not self.is_E(write_req)) and self.is_other_cache_hit(write_req):
                            # send to Other Cache to request Other Cache invalid Block before writing to this Block
                            if not self.handshake_done:
                                write_req.snoop_type = 2
                                self.miss_req_q.append(write_req)
                                self.next_state = 'REQ_BUS'
                                self.word_cnt = 0
                                self.check_hit_miss_delay = 0
                        else:
                            if self.write_delay == CACHE_WRITE_DELAY_L1:
                                print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {self.name.ljust(10, ' ')}: Has a Write Hit Access!")
                                # get hit way
                                hit_way = self.state_tag_mem.get_way_hit(set, tag)
                                state = self.state_tag_mem.way_arr[hit_way].read_state(set)
                                # write word 0 --> 15
                                wr_data = write_req.data
                                self.data_mem.write(set, hit_way, word_offset, wr_data, 1)
                                # self.word_cnt = self.word_cnt + 1
                                if self.word_cnt == 0 and write_req.wlast:
                                    write_req.wdone = 1
                                    # write_req.wlast = 0
                                    self.send2master_q.append(write_req)
                                if self.word_cnt == 1:
                                    self.ready_q.pop(0)  # remove done trans
                                    # print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {self.name.ljust(10, ' ')}: Write a Write Hit to its Data Mem: {write_req}")
                                    # write request is done
                                    # update PLRUt bits
                                    PLRUt_next = self.PLRUt_controller.get_new_PLRUt(hit, full, valid, hit_way, PLRUt)
                                    self.PLRUt_mem.write(set, PLRUt_next, 1)
                                    # update state
                                    new_state = self.MOESI_controller.get_new_MOESI_state(state, hit, write_req.wr_en, 0, 0, 3, 1)
                                    self.state_tag_mem.way_arr[hit_way].write_state(set, new_state, 1)
                                    self.cache_busy_next = 0
                                    self.word_cnt = 0
                                    self.write_delay = 0
                                    self.check_hit_miss_delay = 0
                                    self.handshake_done = 0
                                    print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {self.name.ljust(10, ' ')}: Completed Writing to its Data Mem for Write Request!")
                            else:
                                if self.write_delay == 0:
                                    print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {self.name.ljust(10, ' ')}: Delay {CACHE_WRITE_DELAY_L1} cycles to Write Data to Its Mem!")
                                self.write_delay = self.write_delay + 1
                        # else:
                        #     self.write_delay = self.write_delay + 1
                    else:                                   # cache  miss
                        print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {self.name.ljust(10, ' ')}: Has a Write Miss Access: {write_req}")
                        victim_way = self.PLRUt_controller.find_victim_way(full, valid, PLRUt)
                        if self.state_tag_mem.is_dirty(victim_way, set):
                            self.state_tag_mem.way_arr[victim_way].write_state(set, self.state_tag_mem.way_arr[victim_way].I, 1)
                            self.next_state = 'WRITE_MEM'
                            print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {self.name.ljust(10, ' ')}: Write-back to Slave!")
                        elif self.is_shared_address(write_req.addr) and self.is_other_cache_hit(write_req):
                            self.next_state = 'REQ_BUS'
                            write_req.snoop_type = 1
                            print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {self.name.ljust(10, ' ')}: Request to get Cache Block from Other Cache!")
                        else:
                            self.next_state = 'READ_MEM'
                            print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {self.name.ljust(10, ' ')}: Fetch from Slave!")
                        self.miss_req_q.append(write_req)
                        self.word_cnt = 0
                        self.check_hit_miss_delay = 0
                else:
                    if self.check_hit_miss_delay == 0:
                        print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {self.name.ljust(10, ' ')}: Delay {CHECK_HIT_MISS_DELAY_L1} cycles to check Write Hit/Miss!")
                    self.check_hit_miss_delay = self.check_hit_miss_delay + 1

    def send_master(self, sys_c):
        if len(self.ready_q) > 0:
            if self.m_port.m_ready:
                if len(self.send2master_q) > 0:
                    resp = self.send2master_q.pop(0)
                    self.m_port.send_master(resp)
                    self.word_cnt = self.word_cnt + 1
                    # print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: \t{self.name} sent a Read Hit to Master: {resp}")

    def send_slave(self, sys_c):
        if self.state == 'WRITE_MEM':                       # write-back to DRAM
            if self.word_cnt == CACHE_LINE_SIZE and self.s_port.s_valid:
                wresp = self.s_port.recv_slave()
                if wresp.wdone:
                    self.word_cnt = 0
                    if self.is_shared_address(self.miss_req_q[0].addr) and self.is_other_cache_hit(self.miss_req_q[0]):
                        self.next_state = 'REQ_BUS'
                        if self.miss_req_q[0].wr_en:
                            self.miss_req_q[0].snoop_type = 1
                        else:
                            self.miss_req_q[0].snoop_type = 0
                    else:
                        self.next_state = 'READ_MEM'
                    print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {self.name.ljust(10, ' ')}: Completed write-back to Slave")
            elif self.s_port.s_ready and self.word_cnt < CACHE_LINE_SIZE:
                wb_req = copy.deepcopy(self.miss_req_q[0])
                wb_req.id = sys_c.cycle
                set = self.get_set(wb_req)
                PLRUt = self.PLRUt_mem.read(set)
                valid = self.state_tag_mem.get_set_valid(set)
                full = self.state_tag_mem.is_full(set)
                # find way to write-back
                victim_way = self.PLRUt_controller.find_victim_way(full, valid, PLRUt)
                wb_tag = self.state_tag_mem.way_arr[victim_way].read_tag(set)
                wb_addr = (wb_tag << 10) + (set << 6)
                wb_data = self.data_mem.read(set, victim_way, self.word_cnt)
                wb_req.addr = wb_addr
                wb_req.data = wb_data
                wb_req.wr_en = 1             # this must be write trans to write-back to DRAM
                wb_req.wlast = self.word_cnt == (CACHE_LINE_SIZE - 1)
                wb_req.wdone = 0
                # write-back to DRAM
                self.s_port.send_slave(wb_req)
                self.word_cnt = self.word_cnt + 1
                # print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: \t{self.name} write-back a word to Slave: {wb_req}")
                # write-back is done
                # if self.word_cnt == CACHE_LINE_SIZE:
                #     self.word_cnt = 0
                #     if self.is_other_cache_hit(self.miss_req_q[0]):
                #         self.next_state = 'REQ_BUS'
                #         if self.miss_req_q[0].wr_en:
                #             self.miss_req_q[0].snoop_type = 1
                #         else:
                #             self.miss_req_q[0].snoop_type = 0
                #     else:
                #         self.next_state = 'READ_MEM'
                #     print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {self.name.ljust(10, ' ')}: Completed write-back to Slave")
            # else:
            #     print(f'L1 stuck here')
        elif self.state == 'READ_MEM':                      # fetch from DRAM
            if self.s_port.s_ready and (not self.handshake_done):
                fetch_req = copy.deepcopy(self.miss_req_q[0])
                fetch_req.id = sys_c.cycle
                fetch_req.wr_en = 0          # this must be read trans to fetch from DRAM
                fetch_req.wlast = 0
                fetch_req.wdone = 0
                fetch_req.addr = fetch_req.addr & 0xFFFFFFC0
                self.s_port.send_slave(fetch_req)
                self.word_cnt = 0
                self.handshake_done = 1
                print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {self.name.ljust(10, ' ')}: Sent Read Request to Slave: {fetch_req}")

    def receive_slave(self, sys_c):
        if self.state == 'READ_MEM':
            # print(f'here: {self.word_cnt}')
            if self.s_port.s_valid and self.handshake_done and self.word_cnt < CACHE_LINE_SIZE:
                # receive read data from DRAM
                resp = self.s_port.recv_slave()
                # allocate block in cache
                miss_req = copy.deepcopy(self.miss_req_q[0])
                set = self.get_set(miss_req)
                tag = self.get_tag(miss_req)
                PLRUt = self.PLRUt_mem.read(set)
                valid = self.state_tag_mem.get_set_valid(set)
                full = self.state_tag_mem.is_full(set)
                victim_way = self.PLRUt_controller.find_victim_way(full, valid, PLRUt)
                self.data_mem.write(set, victim_way, self.word_cnt, resp.data, 1)
                self.word_cnt = self.word_cnt + 1
                # print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: \t{self.name} received 1-word Reading from Slave: {resp}")
                # fetch mem is done
                if self.word_cnt == CACHE_LINE_SIZE and resp.rlast:
                    # update state-tag
                    state = self.state_tag_mem.way_arr[victim_way].read_state(set)
                    new_state = self.MOESI_controller.get_new_MOESI_state(state, 0, 0, 1, 0, 3, 1)
                    if self.other_cache != None and self.other_cache.state != 'IDLE' and len(self.other_cache.miss_req_q) > 0:
                        if self.other_cache.miss_req_q[0].wr_en == 0 and (self.other_cache.miss_req_q[0].addr & 0xFFFFFFC0) == (self.miss_req_q[0].addr & 0xFFFFFFC0):
                            new_state = 'S'
                            self.other_cache.miss_req_q[0].is_E_E = 1
                    if self.miss_req_q[0].is_E_E == 1:
                        new_state = 'S'
                    self.state_tag_mem.way_arr[victim_way].write(set, new_state, tag, 1)
                    # move to next-state and remove handled miss req
                    if self.miss_req_q[0].wr_en:
                        self.next_state = 'CPU_WRITE'
                    else:
                        self.next_state = 'CPU_READ'
                    self.miss_req_q.pop(0)
                    self.word_cnt = 0
                    self.handshake_done = 0
                    print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {self.name.ljust(10, ' ')}: Completed Reading 16-word from Slave!")

    # this function is used to send 16-word from Cache to Other Cache or send request to Other Cache
    def send_other_cache(self, sys_c):
        if self.state == 'RESP_BUS':
            if not self.cache_busy:  # handle next trans
                # get new request from master
                # receive request from CPU
                if self.m_port.m_valid:
                    req = self.m_port.recv_master()
                    req.source_id = 0
                    self.ready_q.append(req)
                    if req.wr_en:
                        print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {self.name.ljust(10, ' ')}: Received a Write Request from Master: {req}")
                    else:
                        print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {self.name.ljust(10, ' ')}: Received a Read Request from Master: {req}")
                # receive request from Other Cache
                if self.resp_port.m_valid:
                    req = self.resp_port.recv_master()
                    req.source_id = 1
                    self.ready_q.append(req)
                    if req.wr_en:
                        print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {self.name.ljust(10, ' ')}: Received a Write Request from Other Cache: {req}")
                    else:
                        print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {self.name.ljust(10, ' ')}: Received a Read Request from Other Cache: {req}")
                # arbitrating
                self.fcfs_arbiter(sys_c)
                # handle next trans
                if len(self.ready_q) > 0:
                    req = self.ready_q[0]
                    # CPU access
                    if req.source_id == 0:
                        if req.wr_en:
                            self.next_state = 'CPU_WRITE'
                        else:
                            self.next_state = 'CPU_READ'
                    elif req.source_id == 1:
                        self.next_state = 'RESP_BUS'
                    self.cache_busy_next = 1
                    self.word_cnt = 0
            else:  # handle current trans
                snoop_req = copy.deepcopy(self.ready_q[0])
                if self.state_tag_mem.is_hit(self.get_set(snoop_req), self.get_tag(snoop_req)):
                    if self.resp_other_cache_delay == RESP_OTHER_CACHE_DELAY_L1:    # delay when check hit or miss
                        if self.state_tag_mem.is_hit(self.get_set(snoop_req), self.get_tag(snoop_req)):
                            if snoop_req.snoop_type == 0 or snoop_req.snoop_type == 1:
                                if self.resp_port.m_ready:
                                    snoop_resp = copy.deepcopy(snoop_req)
                                    set = self.get_set(snoop_resp)
                                    tag = self.get_tag(snoop_resp)
                                    # find way to fetch
                                    snoop_way = self.state_tag_mem.get_way_hit(set, tag)
                                    # read data from Cache to snoop to Other Cache
                                    snoop_data = self.data_mem.read(set, snoop_way, self.word_cnt)
                                    snoop_resp.data = snoop_data
                                    snoop_resp.sdone = self.word_cnt == (CACHE_LINE_SIZE-1)
                                    # send to Other Cache
                                    self.resp_port.send_master(snoop_resp)
                                    self.word_cnt = self.word_cnt + 1
                                    # print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: \t{self.name} send a snoop word to Other Cache: {snoop_resp}")
                                    # response Other Cache is done
                                    if self.word_cnt == CACHE_LINE_SIZE:
                                        # update state-tag
                                        state = self.state_tag_mem.way_arr[snoop_way].read_state(set)
                                        new_state = self.MOESI_controller.get_new_MOESI_state(state, 1, 0, 0, 0, snoop_req.snoop_type, 0)
                                        self.state_tag_mem.way_arr[snoop_way].write(set, new_state, tag, 1)
                                        self.ready_q.pop(0)  # remove done trans
                                        self.cache_busy_next = 0
                                        self.word_cnt = 0
                                        self.resp_other_cache_delay = 0
                                        print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {self.name.ljust(10, ' ')}: Completed Snooping 16-words to Other Cache!")
                            elif snoop_req.snoop_type == 2:
                                if self.resp_port.m_ready:
                                    snoop_resp = copy.deepcopy(snoop_req)
                                    snoop_resp.sdone = 1
                                    # send to Other Cache
                                    self.resp_port.send_master(snoop_resp)
                                    set = self.get_set(snoop_resp)
                                    tag = self.get_tag(snoop_resp)
                                    # find way to fetch
                                    snoop_way = self.state_tag_mem.get_way_hit(set, tag)
                                    # print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: \t{self.name} send a snoop word to Other Cache: {snoop_resp}")
                                    # response Other Cache is done
                                    # update state-tag
                                    state = self.state_tag_mem.way_arr[snoop_way].read_state(set)
                                    new_state = self.MOESI_controller.get_new_MOESI_state(state, 1, 0, 0, 0, snoop_req.snoop_type, 0)
                                    self.state_tag_mem.way_arr[snoop_way].write(set, new_state, tag, 1)
                                    self.ready_q.pop(0)  # remove done trans
                                    self.cache_busy_next = 0
                                    self.resp_other_cache_delay = 0
                                    print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {self.name.ljust(10, ' ')}: Completed Invalid Block for snoop request received from Other Cache!")
                        else:
                            self.ready_q.pop(0)
                            self.cache_busy_next = 0
                            self.word_cnt = 0
                            self.resp_other_cache_delay = 0
                    else:
                        if self.resp_other_cache_delay == 0:
                            print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {self.name.ljust(10, ' ')}: Delay {RESP_OTHER_CACHE_DELAY_L1} cycles to Response Other Cache!")
                        self.resp_other_cache_delay = self.resp_other_cache_delay + 1
                else:
                    self.ready_q.pop(0)
                    self.cache_busy_next = 0
                    self.word_cnt = 0
                    self.resp_other_cache_delay = 0
        elif self.state == 'REQ_BUS':
            if len(self.miss_req_q) > 0 and not self.handshake_done:                        # only have 1 maximum request
                if self.req_port.s_ready:
                    miss_snoop_req = copy.deepcopy(self.miss_req_q[0])
                    miss_snoop_req.id = sys_c.cycle
                    # set = self.get_set(miss_snoop_req)
                    # tag = self.get_tag(miss_snoop_req)
                    if self.is_other_cache_hit(miss_snoop_req):
                        self.req_port.send_slave(miss_snoop_req)
                        self.word_cnt = 0
                        self.handshake_done = 1
                        print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {self.name.ljust(10, ' ')}: Sent Snoop Request to Other Cache: {miss_snoop_req}")
                        # if miss_snoop_req.snoop_type == 2:
                        #     self.miss_req_q.pop(0)
                        #     self.next_state = 'CPU_WRITE'
                    else:
                        self.next_state = 'READ_MEM'

    # this function is used to receive 16-word from Other Cache
    def receive_other_cache(self, sys_c):
        if self.state == 'REQ_BUS':
            if len(self.miss_req_q) > 0 and self.handshake_done:  # wait to get enough 16-word
                miss_req = copy.deepcopy(self.miss_req_q[0])
                # if self.is_other_cache_hit(miss_req) or self.word_cnt == CACHE_LINE_SIZE-1:
                if self.is_other_cache_hit(miss_req) or self.word_cnt > 0 or miss_req.snoop_type == 2:
                    if self.req_port.s_valid:
                        if miss_req.snoop_type == 0 or miss_req.snoop_type == 1:
                            # write to Cache L1 memory...
                            # receive read data from Other Cache
                            resp = self.req_port.recv_slave()
                            # allocate block in cache
                            miss_snoop_req = copy.deepcopy(self.miss_req_q[0])
                            set = self.get_set(miss_snoop_req)
                            tag = self.get_tag(miss_snoop_req)
                            PLRUt = self.PLRUt_mem.read(set)
                            valid = self.state_tag_mem.get_set_valid(set)
                            full = self.state_tag_mem.is_full(set)
                            victim_way = self.PLRUt_controller.find_victim_way(full, valid, PLRUt)
                            self.data_mem.write(set, victim_way, self.word_cnt, resp.data, 1)
                            self.word_cnt = self.word_cnt + 1
                            # print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: \t{self.name} received 1-word Reading from Other Cache: {resp}, word_cnt={self.word_cnt}")
                            # fetch Other Cache is done
                            if self.word_cnt == CACHE_LINE_SIZE and resp.sdone:
                                # update state-tag
                                state = self.state_tag_mem.way_arr[victim_way].read_state(set)
                                new_state = self.MOESI_controller.get_new_MOESI_state(state, 0, 0, 0, 1, 3, 1)
                                self.state_tag_mem.way_arr[victim_way].write(set, new_state, tag, 1)
                                # move to next-state and remove handled miss req
                                if miss_req.wr_en:
                                    self.next_state = 'CPU_WRITE'
                                else:
                                    self.next_state = 'CPU_READ'
                                self.miss_req_q.pop(0)
                                self.word_cnt = 0
                                self.handshake_done = 0
                                print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {self.name.ljust(10, ' ')}: Completed Fetching 16-word from Other Cache!")
                        if miss_req.snoop_type == 2:
                            resp = self.req_port.recv_slave()
                            if resp.sdone:
                                self.miss_req_q.pop(0)
                                self.next_state = 'CPU_WRITE'
                                print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {self.name.ljust(10, ' ')}: Completed Invalid 16-word in Other Cache!")
                else:
                    self.next_state = 'READ_MEM'
                    self.word_cnt = 0
                    self.handshake_done = 0

    def find_and_delete_trans_in_ready_queue(self, trans):
        for i in range(len(self.ready_q)):
            if self.ready_q[i].addr == trans.addr and self.ready_q[i].source_id == 1:
                self.ready_q.pop(i)

    def find_and_delete_trans_in_port(self, trans):
        for i in range(len(self.resp_port.send_port.buffer)):
            if self.resp_port.send_port.buffer[i].addr == trans.addr:
                self.resp_port.send_port.buffer.pop(i)
                self.resp_port.update()

    def deadlock_solve(self, sys_c, snoop_req):
        if self.state_tag_mem.is_hit(self.get_set(snoop_req), self.get_tag(snoop_req)):
            if self.resp_other_cache_delay == RESP_OTHER_CACHE_DELAY_L1:  # delay when check hit or miss
                if self.state_tag_mem.is_hit(self.get_set(snoop_req), self.get_tag(snoop_req)):
                    if snoop_req.snoop_type == 0 or snoop_req.snoop_type == 1:
                        if self.resp_port.m_ready:
                            snoop_resp = copy.deepcopy(snoop_req)
                            set = self.get_set(snoop_resp)
                            tag = self.get_tag(snoop_resp)
                            # find way to fetch
                            snoop_way = self.state_tag_mem.get_way_hit(set, tag)
                            # read data from Cache to snoop to Other Cache
                            snoop_data = self.data_mem.read(set, snoop_way, self.dl_word_cnt)
                            snoop_resp.data = snoop_data
                            snoop_resp.sdone = self.dl_word_cnt == (CACHE_LINE_SIZE - 1)
                            # send to Other Cache
                            self.resp_port.send_master(snoop_resp)
                            self.resp_port.update()
                            self.dl_word_cnt = self.dl_word_cnt + 1
                            # print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: \t{self.name} send a snoop word to Other Cache: {snoop_resp}")
                            # response Other Cache is done
                            if self.dl_word_cnt == CACHE_LINE_SIZE:
                                # update state-tag
                                state = self.state_tag_mem.way_arr[snoop_way].read_state(set)
                                new_state = self.MOESI_controller.get_new_MOESI_state(state, 1, 0, 0, 0, snoop_req.snoop_type, 0)
                                self.state_tag_mem.way_arr[snoop_way].write(set, new_state, tag, 1)
                                self.find_and_delete_trans_in_ready_queue(snoop_req)
                                self.find_and_delete_trans_in_port(snoop_req)
                                self.dl_word_cnt = 0
                                self.resp_other_cache_delay = 0
                                print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {self.name.ljust(10, ' ')}: Completed Snooping 16-words to Other Cache!")
                                print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {self.name.ljust(10, ' ')}: Solved a Deadlock!")
                    elif snoop_req.snoop_type == 2:
                        if self.resp_port.m_ready:
                            snoop_resp = copy.deepcopy(snoop_req)
                            snoop_resp.sdone = 1
                            set = self.get_set(snoop_resp)
                            tag = self.get_tag(snoop_resp)
                            # find way to fetch
                            snoop_way = self.state_tag_mem.get_way_hit(set, tag)
                            # print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: \t{self.name} send a snoop word to Other Cache: {snoop_resp}")
                            # response Other Cache is done
                            # update state-tag
                            state = self.state_tag_mem.way_arr[snoop_way].read_state(set)
                            new_state = self.MOESI_controller.get_new_MOESI_state(state, 1, 0, 0, 0, snoop_req.snoop_type, 0)
                            self.state_tag_mem.way_arr[snoop_way].write(set, new_state, tag, 1)
                            self.find_and_delete_trans_in_ready_queue(snoop_req)
                            self.find_and_delete_trans_in_port(snoop_req)
                            self.dl_word_cnt = 0
                            self.resp_other_cache_delay = 0
                            print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {self.name.ljust(10, ' ')}: Completed Invalid Block for snoop request received from Other Cache!")
                            print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {self.name.ljust(10, ' ')}: Solved a Deadlock!")
                else:
                    self.find_and_delete_trans_in_ready_queue(snoop_req)
                    self.find_and_delete_trans_in_port(snoop_req)
                    self.dl_word_cnt = 0
                    self.resp_other_cache_delay = 0
            else:
                if self.resp_other_cache_delay == 0:
                    print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {self.name.ljust(10, ' ')}: Delay {RESP_OTHER_CACHE_DELAY_L1} to Response Other Cache!")
                self.resp_other_cache_delay = self.resp_other_cache_delay + 1
        else:
            self.find_and_delete_trans_in_ready_queue(snoop_req)
            self.find_and_delete_trans_in_port(snoop_req)
            self.dl_word_cnt = 0
            self.resp_other_cache_delay = 0

    def print_cache_state(self, sys_c):
        print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {'*' * 10} {self.name}'s Way State {'*' * 10}")
        temp_arr = []
        for i in self.state_tag_mem.way_arr:
            temp_arr.append(i.state_mem)
        transposed_arr = list(zip(*temp_arr))
        # Print the transposed State Array
        for set in range(len(transposed_arr)):
            state_arr = "  ".join(state for state in transposed_arr[set])
            print(f"set {set}: ".ljust(8, ' '), end='')
            print(state_arr)

    def to_22_bit_hex(self, value):
        if value == None:
            value = 0
        return f"0x{value:06X}"  # Converts to hex with at least 6 characters (zero-padded)

    def print_cache_tag(self, sys_c):
        print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {'*' * 10} {self.name}'s Way Tag {'*' * 10}")
        temp_arr = []
        for i in self.state_tag_mem.way_arr:
            temp_arr.append(i.tag_mem)
        transposed_arr = list(zip(*temp_arr))
        # Print the transposed State Array
        for set in range(len(transposed_arr)):
            hex_set = [self.to_22_bit_hex(tag) for tag in transposed_arr[set]]  # Convert each number in the row
            print(f"set {set}: ".ljust(8, ' '), end='')
            print("  ".join(hex_set))  # Join and print as space-separated string

    def print_cache_data(self, sys_c):
        mem_data_arr = []
        for set in range(SET_NUM_L1):
            set_data_arr = []
            for way in range(WAY_NUM_L1):
                way_data_arr = []
                for word in range(CACHE_LINE_SIZE-1, -1, -1):
                    way_data_arr.append(self.data_mem.read(set, way, word))
                set_data_arr.append(way_data_arr)
            mem_data_arr.append(set_data_arr)
        print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {'*' * 82} {self.name}'s Data Mem {'*' * 82}")
        for set in range(len(mem_data_arr)):
            print(f"{'*' * 95} set {set} {'*' * 95}")
            for way in range(len(mem_data_arr[set])):
                print(f"way {way}: ".ljust(8, ' '), end='')
                hex_values_arr = "  ".join(f"0x{value:08X}" for value in mem_data_arr[set][way])
                print(hex_values_arr)

    def print_cache_plrut_mem(self, sys_c):
        print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {'*' * 10} {self.name}'s PLRUt Mem {'*' * 10}")
        for set in range(len(self.PLRUt_mem.plrut_mem)):
            plrut = ''
            # Iterate from way 2 to 0
            for way in range(2, -1, -1):
                plrut += str(self.PLRUt_mem.plrut_mem[set][way])
            print(f"set {set}: ".ljust(8, ' '), end='')
            print(f"{plrut}")

    # def save_state_tag(self):
    #     for set in range(SET_NUM_L1):
    #         for way in range(WAY_NUM_L1):
    #             print(self.state_tag_mem.way_arr[way].state_mem[set] + str(self.state_tag_mem.way_arr[way].tag_mem[set]), end=' ')
    #         print()
    def save_state_tag(self):
        state_encoding = {
            'M': '000',
            'O': '001',
            'E': '010',
            'S': '011',
            'I': '100'
        }

        with open(self.state_tag_path, "w") as file:
            for set in range(SET_NUM_L1):
                line_output = []
                for way in range(WAY_NUM_L1):
                    state = self.state_tag_mem.way_arr[way].state_mem[set]
                    tag = self.state_tag_mem.way_arr[way].tag_mem[set]

                    state_bin = state_encoding.get(state, '100')
                    tag_bin = format(tag if tag is not None else 0, '022b')

                    line_output.append(state_bin + tag_bin)
                file.write(" ".join(line_output) + "\n")

    def save_plrut(self):
        with open(self.plrut_ram_path, "w") as file:
            for set in range(SET_NUM_L1):
                file.write("".join(map(str, self.PLRUt_mem.plrut_mem[set][::-1])) + "\n")

    def save_data(self):
        mem_data_flat = []
        for set in range(SET_NUM_L1):
            for way in range(WAY_NUM_L1):
                for word in range(CACHE_LINE_SIZE - 1, -1, -1):
                    mem_data_flat.append(self.data_mem.read(set, way, word))

        with open(self.data_ram_path, "w") as file:
            for i in range(0, len(mem_data_flat), 16):
                line_values = mem_data_flat[i:i + 16]
                hex_line = " ".join(f"0x{value:08x}" for value in line_values)
                file.write(hex_line + "\n")

    def init_cache(self):
        self.PLRUt_mem.init_plrut('bin/cache_L1_0/plrut.mem')
        self.state_tag_mem.way_arr[0].init_state_tag('bin/cache_L1_0/way0.mem')
        self.state_tag_mem.way_arr[1].init_state_tag('bin/cache_L1_0/way1.mem')
        self.state_tag_mem.way_arr[2].init_state_tag('bin/cache_L1_0/way2.mem')
        self.state_tag_mem.way_arr[3].init_state_tag('bin/cache_L1_0/way3.mem')
        self.data_mem.init_data_mem('bin/cache_L1_0/data.mem')

    def update(self):
        # update state and next_state
        self.state = self.next_state
        self.next_state = self.state
        # cache_busy
        self.cache_busy = self.cache_busy_next
        self.cache_busy_next = self.cache_busy

        # update ports
        self.m_port.update()
        self.s_port.update()
        self.req_port.update()
        self.resp_port.update()

    def run(self, sys_c):
        self.receive_master(sys_c)
        self.read_handler(sys_c)
        self.write_handler(sys_c)
        self.send_master(sys_c)
        self.send_slave(sys_c)
        self.receive_slave(sys_c)
        self.send_other_cache(sys_c)
        self.receive_other_cache(sys_c)

# from system_common import *
# sys_c = system_common()
# cache_L1 = cache_L1('AN')
# cache_L1.init_cache()
# cache_L1.print_cache_state(sys_c)
# cache_L1.print_cache_tag(sys_c)
# cache_L1.print_cache_plrut_mem(sys_c)
# cache_L1.print_cache_data(sys_c)
#
# cache_L1 = cache_L1('AN')
# cache_L1.save_state_tag()
