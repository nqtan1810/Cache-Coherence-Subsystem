from itertools import groupby
import random
import queue
import time
from threading import Thread
from queue import Queue
from subsystem_parameter import *
from DRAM_memory import *
from transaction import *
from bi_directional_port import *


class Scheduler:
    def __init__(self, name=''):
        self.name = name
        # print(f"{self.name} is created!")

        # DRAM Accessed Address Width
        self.col_end = 30
        self.col_start = self.col_end - COL_ADDR_WIDTH
        self.bank_end = self.col_start
        self.bank_start = self.bank_end - BANK_ADDR_WIDTH
        self.row_end = self.bank_start
        self.row_start = self.row_end - ROW_ADDR_WIDTH

        # port to connect to Master
        self.m_port = bi_directional_port(name + '.m_port')

        # Difines queues size
        self.final_queue_size = FINAL_QUEUE_SIZE
        self.wr_queue_size = WR_QUEUE_SIZE
        self.s0s1_queue_size = S0S1_QUEUE_SIZE

        # Creates Queues
        self.final_queue = Queue(maxsize=self.final_queue_size)
        self.read_queue = Queue(maxsize=self.wr_queue_size)
        self.write_queue = Queue(maxsize=self.wr_queue_size)
        self.S0_queue = Queue(maxsize=self.s0s1_queue_size)  # Each value in queue contains 16 transactions of 1 write request
        self.S1_queue = Queue(maxsize=self.s0s1_queue_size)  # Each value in queue contains 16 transactions of 1 wrire request

        self.request_sche2time = None
        self.last_schedule_cycle = -1
        self.write_count = 0
        self.write_done = 1
        self.s0_count = 0
        self.s1_count = 0
        self.read_done = 1
        self.read_count = 0

    def add_request(self, sys_c):

        # these code lines are used for debugging
        # print(f'An Nguyen: {self.m_port.m_valid}')
        # if len(self.m_port.send_port.buffer)!=0:
        #     for i in range(len(self.m_port.send_port.buffer)):
        #         print(f"Port in before: {self.m_port.send_port.buffer[i]}")

        if self.m_port.m_valid == 1:
            if self.m_port.send_port.buffer[0].wr_en == 0:
                if not self.read_queue.full():
                    trans = self.m_port.recv_master()
                    trans.convert_int2bin()   #comment for new design, need to uncomment when combine
                    self.read_queue.put(trans)
                else:
                    return
            elif self.m_port.send_port.buffer[0].wr_en == 1:
                if self.m_port.send_port.buffer[0].source_id == 0 and self.S0_queue.full() and (len(self.S0_queue.queue[self.S0_queue.qsize()-1]) == 16):
                    return
                elif self.m_port.send_port.buffer[0].source_id == 1 and self.S1_queue.full() and (len(self.S1_queue.queue[self.S1_queue.qsize()-1]) == 16):
                    return
                if not self.write_queue.full():
                    trans = self.m_port.recv_master()
                    trans.convert_int2bin() #comment for new design, need to uncomment when combine
                    if trans.source_id == 0:
                        if self.s0_count == 0:  # When meet new write request (1st of 16)
                            mini_queue = []  # Create new queue to store 16 write request
                            mini_queue.append(trans)
                            self.S0_queue.put(mini_queue)
                            self.s0_count += 1
                        elif self.s0_count < 15:
                            mini_queue_idx = self.S0_queue.qsize() - 1
                            self.S0_queue.queue[mini_queue_idx].append(trans)
                            self.s0_count += 1
                        elif self.s0_count == 15:  # Last addr - 16th
                            mini_queue_idx = self.S0_queue.qsize() - 1
                            self.S0_queue.queue[mini_queue_idx].append(trans)
                            if trans.wlast == 1:
                                self.write_queue.put(
                                    self.S0_queue.queue[mini_queue_idx][0])  # add 1st of 16 addr to write queue
                                self.s0_count = 0  # reset s0 write count, ready for new 16 write requests
                            # print(f"Mini queue size: {len(self.S0_queue.queue[mini_queue_idx])}")
                    elif trans.source_id == 1:
                        if self.s1_count == 0:  # When meet new write request (1st of 16)
                            mini_queue = []  # Create new queue to store 16 write request
                            mini_queue.append(trans)
                            self.S1_queue.put(mini_queue)
                            self.s1_count += 1
                        elif self.s1_count < 15:
                            mini_queue_idx = self.S1_queue.qsize() - 1
                            self.S1_queue.queue[mini_queue_idx].append(trans)
                            self.s1_count += 1
                        elif self.s1_count == 15:  # Last addr - 16th
                            mini_queue_idx = self.S1_queue.qsize() - 1
                            self.S1_queue.queue[mini_queue_idx].append(trans)
                            if trans.wlast == 1:
                                self.write_queue.put(
                                    self.S1_queue.queue[mini_queue_idx][0])  # add 1st of 16 addr to write queue
                                self.s1_count = 0  # reset s0 write count, ready for new 16 write requests]
                                # print(f"Mini queue size: {len(self.S1_queue.queue[mini_queue_idx])}")
                else:
                    return

    def schedule_request(self, sys_c):
        if (sys_c.cycle - self.last_schedule_cycle) >= N_CYCLE_REGET or self.final_queue.qsize() < MIN_REQUEST_REGET:
            self.last_schedule_cycle = sys_c.cycle
            requests_needed = FINAL_QUEUE_SIZE - self.final_queue.qsize()  # Request needed to fill Final Queue

            # For example: Need 7 request to fill => Get 4 from Read Queue + 3 from Write Queue
            read_requests_needed = (requests_needed + 1) // 2 if requests_needed % 2 != 0 else requests_needed // 2
            write_requests_needed = requests_needed // 2

            temp_requests = []
            # Get Read requests needed to fill Final Queue
            while not self.read_queue.empty() and read_requests_needed > 0:
                temp_requests.append(self.read_queue.get())
                read_requests_needed -= 1

            # Get Write requests needed to fill Final Queue
            while not self.write_queue.empty() and write_requests_needed > 0:
                temp_requests.append(self.write_queue.get())
                write_requests_needed -= 1

            temp_requests.sort(key=lambda r: r.id)  # Sorted Write+Read request needed by id
            temp_requests.sort(key=lambda req: req.id)  # sorted by id
            temp_requests.sort(key=lambda req: req.bin_addr[self.bank_start:self.bank_end])  # Sorted by bank

            # Grouped by bank
            grouped_by_bank = []
            for bank, bank_group in groupby(temp_requests, key=lambda req: req.bin_addr[self.bank_start:self.bank_end]):
                grouped_by_bank.append(sorted(bank_group, key=lambda req: req.id))

            # Sorted all bank groups by smallest id of each group
            grouped_by_bank.sort(key=lambda group: group[0].id)

            # Sorted request in each bank group by row, wr_en and id
            sorted_list = []
            for group in grouped_by_bank:

                # Sorted by row
                group.sort(key=lambda req: req.bin_addr[self.row_start:self.row_end])

                # In each group by row, sorted requests by id
                grouped_by_row = []
                for row, row_group in groupby(group, key=lambda req: req.bin_addr[self.row_start:self.row_end]):
                    grouped_by_row.append(sorted(row_group, key=lambda req: req.id))

                # Sorted all row groups by smallest id of each group
                grouped_by_row.sort(key=lambda group: group[0].id)

                for row_group in grouped_by_row:

                    # In each row groups, sorted request by wr_en then by id
                    row_group.sort(key=lambda req: req.wr_en)  # Sorted by wr_en
                    grouped_by_type = []

                    # Groups by wr_en then sorted requests by id
                    for req_type, type_group in groupby(row_group, key=lambda req: req.wr_en):
                        grouped_by_type.append(sorted(type_group, key=lambda req: req.id))

                    # Sorted all wr_en groups by smallest id of each group
                    grouped_by_type.sort(key=lambda group: group[0].id)

                    # Final sorted list
                    for type_group in grouped_by_type:
                        sorted_list.extend(type_group)

            for request in sorted_list:  # Add whole sorted list to Final queue
                if self.final_queue.qsize() < 40:
                    self.final_queue.put(request)

            list_req = list(self.final_queue.queue)
            # print("\n".join([
            #     f'[Memory Controller] / [Scheduler]',
            #     f'\t Schedule Completed',
            #     f'\t Final queue size: {self.final_queue.qsize()}',
            #     f'\t Final queue requests:'] + [f"\t {list_req[i].wr_en} | {list_req[i].bin_addr[17:26]} | {list_req[i].id}" for i in range(self.final_queue.qsize())]))

    def get_finalqueue_request(self, mem_ready):
        # print("\n".join([
        #     f'[Memory Controller]/[Scheduler]',
        #     f'\t Executer Ready = {executer_ready}\n']))
        if mem_ready and not self.final_queue.empty():
            if self.write_done:  # Write done
                if self.read_done:  # Read done
                    new_request = self.final_queue.get()
                    if self.request_sche2time is None:
                        if new_request.wr_en == 0:
                            self.read_count = 0
                            binary_suffix = f"{self.read_count:04b}"
                            new_address = (new_request.bin_addr[:self.col_start] + binary_suffix + new_request.bin_addr[self.col_end:])
                            new_request.bin_addr = new_address
                            self.read_done = 0
                            self.request_sche2time = new_request
                        if new_request.wr_en == 1:
                            self.write_count = 0
                            self.write_done = 0
                            if new_request.source_id == 0:
                                new_col = f"{self.write_count:04b}"
                                new_req = self.S0_queue.queue[0][self.write_count]
                                new_req.bin_addr = (new_req.bin_addr[:self.col_start] + new_col + new_req.bin_addr[self.col_end:])
                                self.request_sche2time = new_req
                            elif new_request.source_id == 1:
                                new_col = f"{self.write_count:04b}"
                                new_req = self.S1_queue.queue[0][self.write_count]
                                new_req.bin_addr = (new_req.bin_addr[:self.col_start] + new_col + new_req.bin_addr[self.col_end:])
                                self.request_sche2time = new_req
                    else:
                        if self.request_sche2time.wr_en == 0:
                            self.request_sche2time = None
                        elif self.request_sche2time.wr_en == 1:
                            if self.request_sche2time.source_id == 0:
                                new_queue = Queue(maxsize=self.s0s1_queue_size)
                                queue_list = list(self.S0_queue.queue)
                                for mini_queue in queue_list:
                                    if len(mini_queue) == 16:
                                        if self.request_sche2time.id != mini_queue[15].id:
                                            new_queue.put(mini_queue)
                                    elif len(mini_queue) < 16:
                                        new_queue.put(mini_queue)
                                self.S0_queue = new_queue
                            elif self.request_sche2time.source_id == 1:
                                new_queue = Queue(maxsize=self.s0s1_queue_size)
                                queue_list = list(self.S1_queue.queue)
                                for mini_queue in queue_list:
                                    if len(mini_queue) == 16:
                                        if self.request_sche2time.id != mini_queue[15].id:
                                            new_queue.put(mini_queue)
                                    elif len(mini_queue) < 16:
                                        new_queue.put(mini_queue)
                                self.S1_queue = new_queue
                        if new_request.wr_en == 0:
                            self.read_count = 0
                            binary_suffix = f"{self.read_count:04b}"
                            new_address = (new_request.bin_addr[:self.col_start] + binary_suffix + new_request.bin_addr[self.col_end:])
                            new_request.bin_addr = new_address
                            self.read_done = 0
                            self.request_sche2time = new_request
                        elif new_request.wr_en == 1:
                            self.write_count = 0
                            self.write_done = 0
                            if new_request.source_id == 0:
                                new_col = f"{self.write_count:04b}"
                                new_req = self.S0_queue.queue[0][self.write_count]
                                new_req.bin_addr = (new_req.bin_addr[:self.col_start] + new_col + new_req.bin_addr[self.col_end:])
                                self.request_sche2time = new_req
                            elif new_request.source_id == 1:
                                new_col = f"{self.write_count:04b}"
                                new_req = self.S1_queue.queue[0][self.write_count]
                                new_req.bin_addr = (new_req.bin_addr[:self.col_start] + new_col + new_req.bin_addr[self.col_end:])
                                self.request_sche2time = new_req
                elif self.read_done == 0:  # Read not done
                    self.read_count += 1
                    binary_suffix = f"{self.read_count:04b}"
                    new_address = (self.request_sche2time.bin_addr[:self.col_start] + binary_suffix + self.request_sche2time.bin_addr[self.col_end:])
                    self.request_sche2time.bin_addr = new_address
                    if self.read_count == 15:
                        self.read_done = 1
                        self.read_count = 0
            elif self.write_done == 0:
                self.write_count += 1
                if self.request_sche2time.source_id == 0:
                    new_col = f"{self.write_count:04b}"
                    new_req = self.S0_queue.queue[0][self.write_count]
                    new_req.bin_addr = (new_req.bin_addr[:self.col_start] + new_col + new_req.bin_addr[self.col_end:])
                    self.request_sche2time = new_req
                elif self.request_sche2time.source_id == 1:
                    new_col = f"{self.write_count:04b}"
                    new_req = self.S1_queue.queue[0][self.write_count]
                    new_req.bin_addr = (new_req.bin_addr[:self.col_start] + new_col + new_req.bin_addr[self.col_end:])
                    self.request_sche2time = new_req
                if self.write_count == 15:
                    self.write_count = 0
                    self.write_done = 1
            # These code lines are used for debugging
            # if self.request_sche2time is None:
            #     print("No request")
            # else:
            #     print(f"Request Sended: {self.request_sche2time.wr_en} | {self.request_sche2time.bin_addr} | {self.request_sche2time.data} | {self.request_sche2time.id}")
            # print(f"Write Done: {self.write_done} - Write Count: {self.write_count} | Read Done: {self.read_done} - Read Count: {self.read_count}")
            return self.request_sche2time
        elif mem_ready and self.final_queue.empty():
            if self.write_done == 0:
                self.write_count += 1
                if self.request_sche2time.source_id == 0:
                    new_col = f"{self.write_count:04b}"
                    new_req = self.S0_queue.queue[0][self.write_count]
                    new_req.bin_addr = (new_req.bin_addr[:self.col_start] + new_col + new_req.bin_addr[self.col_end:])
                    self.request_sche2time = new_req
                elif self.request_sche2time.source_id == 1:
                    new_col = f"{self.write_count:04b}"
                    new_req = self.S1_queue.queue[0][self.write_count]
                    new_req.bin_addr = (new_req.bin_addr[:self.col_start] + new_col + new_req.bin_addr[self.col_end:])
                    self.request_sche2time = new_req
                if self.write_count == 15:
                    self.write_count = 0
                    self.write_done = 1
            elif self.read_done == 0:  # Read not done
                self.read_count += 1
                binary_suffix = f"{self.read_count:04b}"
                new_address = (self.request_sche2time.bin_addr[:self.col_start] + binary_suffix + self.request_sche2time.bin_addr[self.col_end:])
                self.request_sche2time.bin_addr = new_address
                if self.read_count == 15:
                    self.read_done = 1
                    self.read_count = 0
            elif self.read_done == 1 and self.write_done == 1:
                if self.request_sche2time is not None:
                    if self.request_sche2time.wr_en == 0:
                        self.request_sche2time = None
                    elif self.request_sche2time.wr_en == 1:
                        if self.request_sche2time.source_id == 0:
                            new_queue = Queue(maxsize=self.s0s1_queue_size)
                            queue_list = list(self.S0_queue.queue)
                            for mini_queue in queue_list:
                                if len(mini_queue) == 16:
                                    if self.request_sche2time.id != mini_queue[15].id:
                                        new_queue.put(mini_queue)
                                elif len(mini_queue) < 16:
                                    new_queue.put(mini_queue)
                            self.S0_queue = new_queue
                        elif self.request_sche2time.source_id == 1:
                            new_queue = Queue(maxsize=self.s0s1_queue_size)
                            queue_list = list(self.S1_queue.queue)
                            for mini_queue in queue_list:
                                if len(mini_queue) == 16:
                                    if self.request_sche2time.id != mini_queue[15].id:
                                        new_queue.put(mini_queue)
                                elif len(mini_queue) < 16:
                                    new_queue.put(mini_queue)
                            self.S1_queue = new_queue
                    self.request_sche2time = None
            elif self.read_done == 1 or self.write_done == 1:
                self.request_sche2time = None
            # These code lines are used for debugging
            # if self.request_sche2time is None:
            #     print("No request")
            # else:
            #     print(f"Request Sended: {self.request_sche2time.wr_en} | {self.request_sche2time.bin_addr} | {self.request_sche2time.data} | {self.request_sche2time.id}")
            # print(f"Write Done: {self.write_done} - Write Count: {self.write_count}")
            # print(f"Read Done: {self.read_done} - Read Count: {self.read_count}")
            return self.request_sche2time
        else:
            # These code lines are used for debugging
            # if self.request_sche2time is None:
            #     print("No request")
            # else:
            #     print(f"Request Sended: {self.request_sche2time.wr_en} | {self.request_sche2time.bin_addr} | {self.request_sche2time.data} | {self.request_sche2time.id}")
            # print(f"Write Done: {self.write_done} - Write Count: {self.write_count}")
            # print(f"Read Done: {self.read_done} - Read Count: {self.read_count}")
            return None


    def update(self):
        self.m_port.update()


class TimingController:
    def __init__(self, name=''):
        self.name = name
        # print(f"{self.name} is created!")
        self.t_RCD = t_RCD      # 3
        self.t_RP = t_RP        # 2
        self.t_RL = t_RL        # 1
        self.t_CWD = t_CWD      # 1
        self.t_BURST = t_BURST  # 2
        self.t_RTP = t_RTP      # 4
        self.t_WR = t_WR        # 5
        self.t_CCD = t_CCD      # 2
        self.t_WTR = t_WTR      # 3
        self.t_RTW = t_RTW      # 4
        self.t_WRD = t_WRD
        self.t_WWD = t_WWD

    def add_timing(self, trans):
        if trans != None:
            trans.t_RCD = self.t_RCD
            trans.t_RP = self.t_RP
            trans.t_RL = self.t_RL
            trans.t_CWD = self.t_CWD
            trans.t_BURST = self.t_BURST
            trans.t_RTP = self.t_RTP
            trans.t_WR = self.t_WR
            trans.t_CCD = self.t_CCD
            trans.t_WTR = self.t_WTR
            trans.t_RTW = self.t_RTW
            trans.t_WRD = self.t_WRD
            trans.t_WWD = self.t_WWD
            return trans
        else:
            return None


class ControlLogic:
    def __init__(self, name=''):
        self.name = name
        # print(f"{self.name} is created!")

        # DRAM Accessed Address Width
        self.col_end = 30
        self.col_start = self.col_end - COL_ADDR_WIDTH
        self.bank_end = self.col_start
        self.bank_start = self.bank_end - BANK_ADDR_WIDTH
        self.row_end = self.bank_start
        self.row_start = self.row_end - ROW_ADDR_WIDTH
        self.addr_end = self.col_end
        self.addr_start = self.addr_end - COL_ADDR_WIDTH - BANK_ADDR_WIDTH - ROW_ADDR_WIDTH

        # port to connect to Master
        self.m_port = bi_directional_port(name + '.m_port')
        self.state = "IDLE"  # Trạng thái hiện tại
        self.next_state = None  # Trạng thái kế tiếp
        self.ready = 1  # Biến Ready (1: sẵn sàng nhận request, 0: không sẵn sàng)
        self.current_row = None  # Row đang được truy cập
        self.current_bank = None  # Bank đang được truy cập
        self.current_request = None
        self.start_cycle = None
        self.signal = []
        self.memory = DIMM('DIMM')
        self.rd_data = None
        self.read_done = None
        self.RL_done = 0
        self.RL_count = 0
        self.BURST_done = 0
        self.BURST_count = 0
        self.WaitPRE_done = 0
        self.WaitPRE_count = 0
        self.CWD_done = 0
        self.CWD_count = 0
        self.read_count = 0
        self.write_count = 0
        self.read_idx = 0
        self.read_last_idx = 0
        self.read_word_done = 0
        self.get_word = None
        self.write_idx = 0
        self.idle_print = 0
        self.check_next_trans = 0
        self.write_last = 0

    def update_state(self):
        # update state from next_state
        if self.next_state:
            self.state = self.next_state
            self.next_state = None

    def state_process(self, request, sys_c, final_queue):
        global t_temp
        global state_temp
        if request is None:  # No request was sended or still processing
            if self.ready == 0:  # Still processing (busy)
                self.state = self.state
            elif self.ready == 1:  # No request in processing, No request sended
                if self.state != "IDLE":  # Read Done/ Write Done then receive no request => Precharge
                    self.state = "PRECHARGE"
                else:  # Still no request sended, ready to take new one
                    self.state = "IDLE"
        else:  # Receive new request
            bank = request.bin_addr[self.bank_start:self.bank_end]
            row = request.bin_addr[self.row_start:self.row_end]
            self.current_request = request
            self.read_done = 0
            if self.state == "IDLE":  # No busy, already precharged
                self.state = "ACTIVATE"
                self.current_bank = bank
                self.current_row = row
            else:  # Wait to see if new request access to same bank/row to decide precharge or not ?
                if self.current_bank != bank:  # Access to different bank -> Need to precharge
                    self.current_bank = bank
                    self.current_row = row
                    self.state = "PRECHARGE"
                else:  # Access to same bank
                    if self.current_row != row:  # Access to different row -> Need to precharge
                        self.current_bank = bank
                        self.current_row = row
                        self.state = "PRECHARGE"
                    else:  # Access to same row
                        self.current_bank = bank
                        self.current_row = row
                        if self.current_request.wr_en == 0:
                            self.state = "READ"
                            self.current_request = request
                            self.next_state = None
                        elif self.current_request.wr_en == 1:
                            self.state = "WRITE"
                            self.next_state = None

        if self.state == "IDLE":
            if self.idle_print == 1:
                print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {self.name.ljust(10, ' ')}: Current state: {self.state} - Not busy, still wait for new request!")
                self.ready = 1
                self.idle_print = 0
            else:
                self.ready = 1

        elif self.state == "PRECHARGE":
            self.read_count = 0
            self.write_count = 0
            if request == None:  # Receive no request => IDLE or Still wait to Precharge Done
                if self.start_cycle == None:  # Not precharging
                    if (self.current_request.t_RP - 1) == 0:
                        self.signal = [0, 1, 0, 0, None, self.current_request.bin_addr[self.addr_start:self.addr_end], None]
                        self.next_state = "IDLE"
                        self.memory.process(self.signal)
                        self.idle_print = 1
                        print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {self.name.ljust(10, ' ')}: Current state: {self.state} - RP Delay: {t_RP} - DRAM is precharging.")
                    else:
                        self.start_cycle = sys_c.cycle
                        self.signal = [0, 1, 0, 0, None, self.current_request.bin_addr[self.addr_start:self.addr_end], None]
                        self.memory.process(self.signal)
                        print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {self.name.ljust(10, ' ')}: Current state: {self.state} - RP Delay: {t_RP} - DRAM is precharging.")
                else:  # Precharging
                    if (sys_c.cycle - self.start_cycle) < (self.current_request.t_RP - 1):  # Precharging
                        # ACT, PRE, RAS, CAS, WE, ADDR, DATA
                        self.signal = [0, 0, 0, 0, None, None, None]
                        self.memory.process(self.signal)
                        print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {self.name.ljust(10, ' ')}: Current state: {self.state} - RP Delay: {t_RP} - DRAM is precharging")
                    elif (sys_c.cycle - self.start_cycle) == (self.current_request.t_RP - 1):  # Last Cycle Precharge
                        if self.ready == 1:
                            self.signal = [0, 0, 0, 0, None, None, None]
                            self.start_cycle = None
                            self.next_state = "IDLE"
                            self.memory.process(self.signal)
                            self.idle_print = 1
                        # ACT, PRE, RAS, CAS, WE, ADDR, DATA
                        else:
                            self.signal = [0, 0, 0, 0, None, None, None]
                            self.start_cycle = None  # Reset Start Cycle
                            self.next_state = "ACTIVATE"  # Change State
                            self.memory.process(self.signal)
                        print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {self.name.ljust(10, ' ')}: Current state: {self.state} - RP Delay: {t_RP} - DRAM precharge done!")
            else:
                self.start_cycle = sys_c.cycle
                self.ready = 0
                self.signal = [0, 1, 0, 0, None, self.current_request.bin_addr[self.addr_start:self.addr_end], None]
                self.memory.process(self.signal)
                if (sys_c.cycle - self.start_cycle) == (self.current_request.t_RP - 1):  # Just need 1 cycle to Precharge
                    self.start_cycle = None  # Reset Start Cycle
                    self.next_state = "ACTIVATE"  # Change State
                    print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {self.name.ljust(10, ' ')}: Current state: {self.state} - RP Delay: {t_RP} - DRAM precharge done!")
                else:
                    print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {self.name.ljust(10, ' ')}: Current state: {self.state} - RP Delay: {t_RP} - DRAM is precharging")

        elif self.state == "ACTIVATE":
            if self.start_cycle == None:
                self.start_cycle = sys_c.cycle
                self.ready = 0
                # self.signal = [1, 0, 1, 0, self.current_request.wr_en, self.current_request.bin_addr[17:30], None]
                if self.current_request.wr_en == 0:
                    self.signal = [1, 0, 1, 0, self.current_request.wr_en, self.current_request.bin_addr[self.addr_start:self.addr_end], None]
                elif self.current_request.wr_en == 1:
                    self.signal = [1, 0, 1, 0, self.current_request.wr_en, self.current_request.bin_addr[self.addr_start:self.addr_end], self.current_request.bin_data]
                if (sys_c.cycle - self.start_cycle) == (self.current_request.t_RCD - 1):
                    self.start_cycle = None  # Reset Start Cycle
                    if self.current_request.wr_en == 0:
                        self.next_state = "READ"
                    elif self.current_request.wr_en == 1:
                        self.next_state = "WRITE"
                    print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {self.name.ljust(10, ' ')}: Current state: {self.state} - RCD Delay: {t_RCD} - Mem Activate Done - DRAM Activate Done!")
                else:
                    print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {self.name.ljust(10, ' ')}: Current state: {self.state} - RCD Delay: {t_RCD} - Mem Activate Done - DRAM Activate is waitting to Done!")
                self.memory.process(self.signal)
            else:
                if (sys_c.cycle - self.start_cycle) < (self.current_request.t_RCD - 1):  # Activating
                    # ACT, PRE, RAS, CAS, WE, ADDR, DATA
                    self.signal = [0, 0, 0, 0, None, None, None]
                    self.memory.process(self.signal)
                    print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {self.name.ljust(10, ' ')}: Current state: {self.state} - RCD Delay: {t_RCD} - DRAM Activate is waitting to Done!")
                elif (sys_c.cycle - self.start_cycle) == (self.current_request.t_RCD - 1):  # Last Cycle Activating
                    # ACT, PRE, RAS, CAS, WE, ADDR, DATA
                    self.signal = [0, 0, 0, 0, None, None, None]
                    self.start_cycle = None  # Reset Start Cycle
                    if self.current_request.wr_en == 0:
                        self.next_state = "READ"
                    elif self.current_request.wr_en == 1:
                        self.next_state = "WRITE"
                    self.memory.process(self.signal)
                    print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {self.name.ljust(10, ' ')}: Current state: {self.state} - RCD Delay: {t_RCD} - DRAM Activate Done!")
            self.ready = 0

        elif self.state == "READ":
            if self.read_idx == 0:
                # READ 1ST WORD
                if self.RL_done == 0:
                    # READ LATENCY TIMING
                    if self.RL_count != (self.current_request.t_RL - 1):
                        # ACT, PRE, RAS, CAS, WE, ADDR, DATA
                        self.signal = [0, 0, 0, 0, None, None, None]
                        self.memory.process(self.signal)
                        self.RL_count += 1
                        self.ready = 0
                        print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {self.name.ljust(10, ' ')}: Current state: {self.state} -  RL Delay: {t_RL} - Read Command Sended - Time for Read Latency has not been completed!")
                    elif self.RL_count == (self.current_request.t_RL - 1):
                        self.signal = [0, 0, 0, 0, None, None, None]
                        self.memory.process(self.signal)
                        self.RL_count = 0
                        self.ready = 0
                        self.RL_done = 1
                        print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {self.name.ljust(10, ' ')}: Current state: {self.state} - RL Delay: {t_RL} - Time for Read Latency has been completed! ")
                elif self.RL_done == 1:
                    if self.get_word is None:
                        self.signal = [0, 0, 1, 1, self.current_request.wr_en, self.current_request.bin_addr[self.addr_start:self.addr_end], self.current_request.bin_data]
                        self.rd_data = self.memory.process(self.signal)
                        self.ready = 0
                        #SEND 1 WORD DATA TO PORT
                        if self.m_port.recv_port.ready == 1:
                            req = transaction()
                            req.bin_addr = self.current_request.bin_addr
                            req.id = self.current_request.id
                            req.wr_en = self.current_request.wr_en
                            req.source_id = self.current_request.source_id
                            req.bin_data = self.rd_data
                            req.convert_bin2int()
                            self.m_port.send_master(req)
                            self.get_word = 1
                            print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {self.name.ljust(10, ' ')}: Current state: {self.state} - Data word {self.read_idx} is now available to be read out. ")
                        else:
                            self.get_word = 0
                            print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {self.name.ljust(10, ' ')}: Current state: {self.state} -  Data word {self.read_idx} is not available to be read out.")
                    elif self.get_word == 0:
                        if self.m_port.recv_port.ready == 1:
                            req = transaction()
                            req.bin_addr = self.current_request.bin_addr
                            req.id = self.current_request.id
                            req.wr_en = self.current_request.wr_en
                            req.source_id = self.current_request.source_id
                            req.bin_data = self.rd_data
                            req.convert_bin2int()
                            self.m_port.send_master(req)
                            self.get_word = 1
                            # print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {self.name.ljust(10, ' ')}: Current state: {self.state} - Data word {self.read_idx} is now available to be read out. ")
                        else:
                            self.get_word = 0
                            # print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {self.name.ljust(10, ' ')}: Current state: {self.state} -  Data word {self.read_idx} is not available to be read out.")
                    elif self.get_word == 1:
                        if self.WaitPRE_count != (self.current_request.t_WRD - 1):
                            self.signal = [0, 0, 0, 0, None, None, None]
                            self.memory.process(self.signal)
                            self.WaitPRE_count += 1
                            # print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {self.name.ljust(10, ' ')}: Current state: {self.state} - Preparing for next Read")
                        elif self.WaitPRE_count == (self.current_request.t_WRD - 1):
                            self.signal = [0, 0, 0, 0, None, None, None]
                            self.memory.process(self.signal)
                            self.WaitPRE_count = 0
                            # print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {self.name.ljust(10, ' ')}: Current state: {self.state} - Ready for next Read")
                            self.ready = 1
                            self.RL_done = 0
                            self.BURST_done = 0
                            self.read_idx += 1
                            self.get_word = None

            elif (self.read_idx > 0) and (self.read_idx < 15):
                if self.get_word is None:
                    self.signal = [0, 0, 1, 1, self.current_request.wr_en,
                                   self.current_request.bin_addr[self.addr_start:self.addr_end],
                                   self.current_request.bin_data]
                    self.rd_data = self.memory.process(self.signal)
                    self.ready = 0
                    # SEND 1 WORD DATA TO PORT
                    if self.m_port.recv_port.ready == 1:
                        req = transaction()
                        req.bin_addr = self.current_request.bin_addr
                        req.id = self.current_request.id
                        req.wr_en = self.current_request.wr_en
                        req.source_id = self.current_request.source_id
                        req.bin_data = self.rd_data
                        req.convert_bin2int()
                        self.m_port.send_master(req)
                        self.get_word = 1
                        # print(
                        #     f"[Cycle {sys_c.cycle}]: {self.name} - Current state: {self.state} - Data word {self.read_idx} is now available to be read out. ")
                    else:
                        self.get_word = 0
                        # print(
                        #     f"[Cycle {sys_c.cycle}]: {self.name} - Current state: {self.state} -  Data word {self.read_idx} is not available to be read out.")
                elif self.get_word == 0:
                    if self.m_port.recv_port.ready == 1:
                        req = transaction()
                        req.bin_addr = self.current_request.bin_addr
                        req.id = self.current_request.id
                        req.wr_en = self.current_request.wr_en
                        req.source_id = self.current_request.source_id
                        req.bin_data = self.rd_data
                        req.convert_bin2int()
                        self.m_port.send_master(req)
                        self.get_word = 1
                        # print(
                        #     f"[Cycle {sys_c.cycle}]: {self.name} - Current state: {self.state} - Data word {self.read_idx} is now available to be read out. ")
                    else:
                        self.get_word = 0
                        # print(
                        #     f"[Cycle {sys_c.cycle}]: {self.name} - Current state: {self.state} -  Data word {self.read_idx} is not available to be read out.")
                elif self.get_word == 1:
                    if self.WaitPRE_count != (self.current_request.t_WRD - 1):
                        self.signal = [0, 0, 0, 0, None, None, None]
                        self.memory.process(self.signal)
                        self.WaitPRE_count += 1
                        # print(
                        #     f"[Cycle {sys_c.cycle}]: {self.name} - Current state: {self.state} - Preparing for next Read")
                    elif self.WaitPRE_count == (self.current_request.t_WRD - 1):
                        self.signal = [0, 0, 0, 0, None, None, None]
                        self.memory.process(self.signal)
                        self.WaitPRE_count = 0
                        # print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {self.name.ljust(10, ' ')}: Current state: {self.state} - Ready for next Read")
                        self.ready = 1
                        self.RL_done = 0
                        self.BURST_done = 0
                        self.read_idx += 1
                        self.get_word = None
            elif self.read_idx == 15:
                if self.get_word is None:
                    self.signal = [0, 0, 1, 1, self.current_request.wr_en,
                                   self.current_request.bin_addr[self.addr_start:self.addr_end],
                                   self.current_request.bin_data]
                    self.rd_data = self.memory.process(self.signal)
                    self.ready = 0
                    # SEND 1 WORD DATA TO PORT
                    if self.m_port.recv_port.ready == 1:
                        req = transaction()
                        req.bin_addr = self.current_request.bin_addr
                        req.id = self.current_request.id
                        req.wr_en = self.current_request.wr_en
                        req.source_id = self.current_request.source_id
                        req.bin_data = self.rd_data
                        req.convert_bin2int()
                        req.rlast = 1
                        self.m_port.send_master(req)
                        self.get_word = 1
                        print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {self.name.ljust(10, ' ')}: Current state: {self.state} - Data word {self.read_idx} is now available to be read out. ")
                    else:
                        self.get_word = 0
                        print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {self.name.ljust(10, ' ')}: Current state: {self.state} - Data word {self.read_idx} is not available to be read out.")
                elif self.get_word == 0:
                    if self.m_port.recv_port.ready == 1:
                        req = transaction()
                        req.bin_addr = self.current_request.bin_addr
                        req.id = self.current_request.id
                        req.wr_en = self.current_request.wr_en
                        req.source_id = self.current_request.source_id
                        req.bin_data = self.rd_data
                        req.convert_bin2int()
                        req.rlast = 1
                        self.m_port.send_master(req)
                        self.get_word = 1
                        print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {self.name.ljust(10, ' ')}: Current state: {self.state} - Data word {self.read_idx} is now available to be read out. ")
                    else:
                        self.get_word = 0
                        print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {self.name.ljust(10, ' ')}: Current state: {self.state} -  Data word {self.read_idx} is not available to be read out.")
                elif self.get_word == 1:
                    if self.BURST_done == 0:
                        if self.BURST_count != (self.current_request.t_BURST - 1):
                            self.signal = [0, 0, 0, 0, None, None, None]
                            self.memory.process(self.signal)
                            self.BURST_count += 1
                            print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {self.name.ljust(10, ' ')}: Current state: {self.state} - BURST Delay: {t_BURST} - The Read data is being prepared to be burst to the port ")
                        elif self.BURST_count == (self.current_request.t_BURST - 1):
                            self.signal = [0, 0, 0, 0, None, None, None]
                            self.memory.process(self.signal)
                            self.BURST_done = 1
                            print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {self.name.ljust(10, ' ')}: Current state: {self.state} - BURST Delay: {t_BURST} - The Read Data has been burst to the port successfully ")
                    elif self.BURST_done == 1:
                        # SELECT TIMING PARAMETERS DEPEND ON NEXT REQUEST
                        if not final_queue.empty():  # FINAL QUEUE HAS REQUESTS
                            next_trans = final_queue.queue[0]
                            # NEXT TRANSACTION -> ACCESS TO DIFFERENT ROW OR BANK
                            if (next_trans.bin_addr[self.bank_start:self.bank_end] != self.current_request.bin_addr[
                                                                                      self.bank_start:self.bank_end]) or (
                                    next_trans.bin_addr[
                                    self.row_start:self.row_end] != self.current_request.bin_addr[
                                                                    self.row_start:self.row_end]):
                                t_temp = self.current_request.t_RTP - self.current_request.t_RCD - self.current_request.t_RL - self.current_request.t_BURST
                                state_temp = "PRECHARGE"
                            # NEXT TRANSACTION -> ACCESS TO SAME BANK, SAME ROW
                            elif (next_trans.bin_addr[
                                  self.bank_start:self.bank_end] == self.current_request.bin_addr[
                                                                    self.bank_start:self.bank_end]) or (
                                    next_trans.bin_addr[
                                    self.row_start:self.row_end] == self.current_request.bin_addr[
                                                                    self.row_start:self.row_end]):
                                if next_trans.wr_en == 0:  # NEXT TRANSACTION IS READ (R to R)
                                    t_temp = self.current_request.t_CCD
                                    state_temp = "READ"
                                if next_trans.wr_en == 1:  # NEXT TRANSACTION IS WRITE (R to W)
                                    t_temp = self.current_request.t_RTW
                                    state_temp = "WRITE"
                        else:  # FINAL QUEUE IS EMPTY -> AUTO PRECHARGE
                            t_temp = self.current_request.t_RTP - self.current_request.t_RCD - self.current_request.t_RL - self.current_request.t_BURST
                            state_temp = "PRECHARGE"
                        # WAIT FOR PRECHARGE SIGNAL
                        if self.WaitPRE_count != (t_temp - 1):
                            self.signal = [0, 0, 0, 0, None, None, None]
                            self.memory.process(self.signal)
                            self.WaitPRE_count += 1
                            if state_temp == "READ":
                                print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {self.name.ljust(10, ' ')}: Current state: {self.state} - CCD Delay: {t_temp} - Preparing for next Read")
                            if state_temp == "WRITE":
                                print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {self.name.ljust(10, ' ')}: Current state: {self.state} - RTW Delay: {t_temp} - Preparing for next Write")
                            if state_temp == "PRECHARGE":
                                print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {self.name.ljust(10, ' ')}: Current state: {self.state} - RTP Delay: {t_temp} - Preparing for Precharge")
                        elif self.WaitPRE_count == (t_temp - 1):
                            self.signal = [0, 0, 0, 0, None, None, None]
                            self.memory.process(self.signal)
                            self.WaitPRE_count = 0
                            self.WaitPRE_done = 1
                            if state_temp == "READ":
                                print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {self.name.ljust(10, ' ')}: Current state: {self.state} - CCD Delay: {t_temp} - Ready for next Read")
                            if state_temp == "WRITE":
                                print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {self.name.ljust(10, ' ')}: Current state: {self.state} - RTW Delay: {t_temp} - Ready for next Write")
                            if state_temp == "PRECHARGE":
                                print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {self.name.ljust(10, ' ')}: Current state: {self.state} - RTP Delay: {t_temp} - Ready for Precharge")
                            self.BURST_count = 0
                            self.ready = 1
                            self.RL_done = 0
                            self.BURST_done = 0
                            self.WaitPRE_count = 0
                            self.next_state = state_temp
                            self.read_idx = 0
                            self.get_word = None

        elif self.state == "WRITE":
            # print(f"Write IDX: {self.write_idx}")
            if self.write_idx == 0:
                # READ 1ST WORD
                if self.CWD_done == 0:
                    # WRITE LATENCY TIMING
                    if self.CWD_count != (self.current_request.t_CWD - 1):
                        # ACT, PRE, RAS, CAS, WE, ADDR, DATA
                        self.signal = [0, 0, 0, 0, None, None, None]
                        self.memory.process(self.signal)
                        self.CWD_count += 1
                        self.ready = 0
                        print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {self.name.ljust(10, ' ')}: Current state: {self.state} -  CWD Delay: {t_CWD} - Write Command Sended - Time for Write Latency has not been completed!")
                    elif self.CWD_count == (self.current_request.t_CWD - 1):
                        self.signal = [0, 0, 0, 0, None, None, None]
                        self.memory.process(self.signal)
                        self.CWD_count = 0
                        self.ready = 0
                        self.CWD_done = 1
                        print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {self.name.ljust(10, ' ')}: Current state: {self.state} - CWD Delay: {t_CWD} - Time for Write Latency has been completed!")
                elif self.CWD_done == 1:
                        if self.WaitPRE_count != (self.current_request.t_WWD - 1):
                            self.signal = [0, 0, 0, 0, None, None, None]
                            self.memory.process(self.signal)
                            self.WaitPRE_count += 1
                            print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {self.name.ljust(10, ' ')}: Current state: {self.state} - WWD Delay: {t_WWD} - Writing 1st word data")
                        elif self.WaitPRE_count == (self.current_request.t_WWD - 1):
                            self.signal = [0, 0, 1, 1, self.current_request.wr_en,
                                           self.current_request.bin_addr[self.addr_start:self.addr_end],
                                           self.current_request.bin_data]
                            self.memory.process(self.signal)
                            self.WaitPRE_count = 0
                            print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {self.name.ljust(10, ' ')}: Current state: {self.state} - WWD Delay: {t_WWD} - Writing 1st word data done")
                            self.ready = 1
                            self.write_idx += 1

            elif (self.write_idx > 0) and (self.write_idx < 15):
                self.ready = 0
                if self.WaitPRE_count != (self.current_request.t_WWD - 1):
                    self.signal = [0, 0, 0, 0, None, None, None]
                    self.memory.process(self.signal)
                    self.WaitPRE_count += 1
                    # print(
                    #     f"[Cycle {sys_c.cycle}]: {self.name} - Current state: {self.state} - Preparing for next Write")
                elif self.WaitPRE_count == (self.current_request.t_WWD - 1):
                    self.signal = [0, 0, 1, 1, self.current_request.wr_en,
                                   self.current_request.bin_addr[self.addr_start:self.addr_end],
                                   self.current_request.bin_data]
                    self.memory.process(self.signal)
                    self.WaitPRE_count = 0
                    # print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {self.name.ljust(10, ' ')}: Current state: {self.state} - Ready for next Write")
                    self.ready = 1
                    self.write_idx += 1

            elif self.write_idx == 15:
                self.ready = 0
                if self.BURST_done == 0:
                    if self.write_last == 0:
                        if self.BURST_count != (self.current_request.t_BURST - 1):
                            self.signal = [0, 0, 0, 0, None, None, None]
                            self.memory.process(self.signal)
                            self.BURST_count += 1
                            print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {self.name.ljust(10, ' ')}: Current state: {self.state} - BURST Delay: {t_BURST} - Last data is being written into Memory ")
                        elif self.BURST_count == (self.current_request.t_BURST - 1):
                            self.signal = [0, 0, 1, 1, self.current_request.wr_en,
                                           self.current_request.bin_addr[self.addr_start:self.addr_end],
                                           self.current_request.bin_data]
                            self.memory.process(self.signal)
                            if self.m_port.recv_port.ready == 1:
                                req = transaction()
                                req.bin_addr = self.current_request.bin_addr
                                req.id = self.current_request.id
                                req.wr_en = self.current_request.wr_en
                                req.source_id = self.current_request.source_id
                                req.wdone = 1
                                self.m_port.send_master(req)
                                self.write_last = 0
                                self.BURST_done = 1
                                print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {self.name.ljust(10, ' ')}: Current state: {self.state} - BURST Delay: {t_BURST} - All data has been successfully written into Memory ")
                            else:
                                self.write_last = 1
                                print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {self.name.ljust(10, ' ')}: Current state: {self.state} - BURST Delay: {t_BURST} - Write done last data, wait for send port to complete ")
                    if self.write_last == 1:
                        if self.m_port.recv_port.ready == 1:
                            req = transaction()
                            req.bin_addr = self.current_request.bin_addr
                            req.id = self.current_request.id
                            req.wr_en = self.current_request.wr_en
                            req.source_id = self.current_request.source_id
                            req.wdone = 1
                            self.m_port.send_master(req)
                            self.write_last = 0
                            self.BURST_done = 1
                            print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {self.name.ljust(10, ' ')}: Current state: {self.state} - BURST Delay: {t_BURST} - All data has been successfully written into Memory ")
                        else:
                            self.write_last = 1
                            print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {self.name.ljust(10, ' ')}: Current state: {self.state} - BURST Delay: {t_BURST} - Write done last data, wait for send port to complete ")
                elif self.BURST_done == 1:
                    # SELECT TIMING PARAMETERS DEPEND ON NEXT REQUEST
                    if self.check_next_trans == 0:
                        # print(f"Final Queue Size: {final_queue.qsize()}")
                        if not final_queue.empty():  # FINAL QUEUE HAS REQUESTS
                            next_trans = final_queue.queue[0]
                            # print(f"Next Transaction: {next_trans.bin_addr}")
                            # NEXT TRANSACTION -> ACCESS TO DIFFERENT ROW OR BANK
                            if (next_trans.bin_addr[self.bank_start:self.bank_end] != self.current_request.bin_addr[self.bank_start:self.bank_end]) or (next_trans.bin_addr[self.row_start:self.row_end] != self.current_request.bin_addr[self.row_start:self.row_end]):
                                t_temp = self.current_request.t_WR
                                state_temp = "PRECHARGE"
                            # NEXT TRANSACTION -> ACCESS TO SAME BANK, SAME ROW
                            elif (next_trans.bin_addr[
                                  self.bank_start:self.bank_end] == self.current_request.bin_addr[
                                                                    self.bank_start:self.bank_end]) or (
                                    next_trans.bin_addr[
                                    self.row_start:self.row_end] == self.current_request.bin_addr[
                                                                    self.row_start:self.row_end]):
                                if next_trans.wr_en == 0:  # NEXT TRANSACTION IS READ (W to R)
                                    t_temp = self.current_request.t_WTR
                                    state_temp = "READ"
                                if next_trans.wr_en == 1:  # NEXT TRANSACTION IS WRITE (W to W)
                                    t_temp = self.current_request.t_CCD
                                    state_temp = "WRITE"
                        else:  # FINAL QUEUE IS EMPTY -> AUTO PRECHARGE
                            t_temp = self.current_request.t_WR
                            state_temp = "PRECHARGE"
                        self.check_next_trans = 1
                        print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {self.name.ljust(10, ' ')}: Current state: {self.state} - Check for next request")
                    elif self.check_next_trans == 1:
                        # WAIT FOR PRECHARGE SIGNAL
                        if self.WaitPRE_count != (t_temp - 1):
                            self.signal = [0, 0, 0, 0, None, None, None]
                            self.memory.process(self.signal)
                            self.WaitPRE_count += 1
                            if state_temp == "READ":
                                # print(f'[Cycle {sys_c.cycle}: Tuan debug: WaitPRe_Count = {self.WaitPRE_count}, t_temp = {t_temp}, state_temp = {state_temp}')
                                print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {self.name.ljust(10, ' ')}: Current state: {self.state} - WTR Delay: {t_temp} - Preparing for next Read")
                            if state_temp == "WRITE":
                                print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {self.name.ljust(10, ' ')}: Current state: {self.state} - CCD Delay: {t_temp} - Preparing for next Write")
                            if state_temp == "PRECHARGE":
                                print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {self.name.ljust(10, ' ')}: Current state: {self.state} - WR Delay: {t_temp} - Preparing for Precharge")
                        elif self.WaitPRE_count == (t_temp - 1):
                            self.signal = [0, 0, 0, 0, None, None, None]
                            self.memory.process(self.signal)
                            self.WaitPRE_count = 0
                            self.WaitPRE_done = 1
                            if state_temp == "READ":
                                print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {self.name.ljust(10, ' ')}: Current state: {self.state} - WTR Delay: {t_temp} - Ready for next Read")
                            if state_temp == "WRITE":
                                print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {self.name.ljust(10, ' ')}: Current state: {self.state} - CCD Delay: {t_temp} - Ready for next Write")
                            if state_temp == "PRECHARGE":
                                print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {self.name.ljust(10, ' ')}: Current state: {self.state} - WR Delay: {t_temp} - Ready for Precharge")
                            self.BURST_count = 0
                            self.ready = 1
                            self.CWD_done = 0
                            self.BURST_done = 0
                            self.WaitPRE_count = 0
                            self.next_state = state_temp
                            self.write_idx = 0
                            self.check_next_trans = 0

        self.update_state()

    def update(self):
        self.m_port.update()


class Controller:
    def __init__(self, name=''):
        self.name = name
        # print(f"{self.name} is created!")

        # port to connect to Master
        self.m_port = bi_directional_port(name + '.m_port')

        self.scheduler = Scheduler('DRAM_Scheduler')
        self.timing_controller = TimingController('DRAM_Timing_Controller')
        self.control_logic = ControlLogic('DRAM_Logic_Controller')

    def process(self, sys_c):
        self.scheduler.add_request(sys_c)
        self.scheduler.schedule_request(sys_c)
        sche2time_req = self.scheduler.get_finalqueue_request(self.control_logic.ready)
        fixed_req = self.timing_controller.add_timing(sche2time_req)
        # # if a is not None:
        # #     print(a.source_id, a.id, a.bin_addr, a.act_time, a.pre_time, a.rd_time, a.wr_time, a.id, a.bin_data)
        # # else:
        # #     print("No No No")
        self.control_logic.state_process(fixed_req, sys_c, self.scheduler.final_queue)
        # if fixed_req != None:
        #     print(f"Request Sended: {fixed_req.bin_addr} | ID: {fixed_req.id}")
        # elif fixed_req == None:
        #     print(f"Request Sended: {fixed_req}")
        # print(f"In Port Size: {len(self.m_port.send_port.buffer)} | Out Port Size: {len(self.m_port.recv_port.buffer)}")

    def update(self):
        self.control_logic.update()
        self.scheduler.update()

    def print_mem(self, hex_address):
        bin_address = bin(hex_address)[2:].zfill(32)
        bank_idx = int(bin_address[24:26], 2)
        row_idx = int(bin_address[12:24], 2)
        col = 0
        data_row = []
        while col < 16:
            data32b = ""
            for chip in self.control_logic.memory.RANK.chip_list:
                bank = chip.bank_list[bank_idx]
                data8b = ""
                for mem_array in bank.mem_array_list:
                    data8b += str(mem_array.data_array[row_idx][col])
                data32b += data8b
            data32b = int(data32b, 2)
            data32b = hex(data32b)
            data_row.append(data32b)
            col += 1
        # print(data_row)
        data_row.reverse()
        hex_values_arr = "  ".join(f"0x{int(value, 16):08X}" for value in data_row)
        print(f"Block at Addr = {hex_address:08X}: ".ljust(8, ' '), end='')
        print(hex_values_arr)
