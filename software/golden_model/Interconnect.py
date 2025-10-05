# *************************************************************************************************
# This class defines an Interconnect that supports Arbitration
# *************************************************************************************************

from bi_directional_port import *
import copy

class Interconnect:
    def __init__(self, name='', master_num=2):
        self.name = name
        print(f"{self.name} is created!")

        # Ports connect to Masters
        self.m0_port = bi_directional_port(name + '.m0_port')
        self.m1_port = bi_directional_port(name + '.m1_port')

        # Port connect to Slave
        self.s_port = bi_directional_port(name + '.s_port')

        # Number of masters
        self.master_num = master_num

        # Current grant (round-robin pointer)
        self.grant = 0

        # Internal queues
        self.ready_q = []  # Queue to store requests from masters
        self.resp_q = []   # Queue to store responses to masters

    def next_grant(self):
        self.grant = self.grant % self.master_num

    def fcfs_arbiter(self, sys_c):
        # sort transactions by id (primary) in increasing order
        # if two requests from both masters come at the same time, write request has higher priority than read request
        # if both reqs coming at the same time from masters are the same type, core0 has higher priority
        if len(self.ready_q) > 0:
            self.ready_q = sorted(
                self.ready_q,
                key=lambda trans: (trans.id, trans.id != self.grant)
            )
        # if len(self.ready_q) > 1 and len(set(trans.source_id for trans in self.ready_q)) > 1:
        #     print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {self.name} is arbitrating!")

    def receive_master(self, sys_c):
        m0_req = None
        m1_req = None
        if self.m0_port.m_valid:
            m0_req = self.m0_port.recv_master()
            m0_req.source_id = 0
            self.ready_q.append(m0_req)
            # if m0_req.wr_en:
            #     print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {self.name} received a Write Request from Master 0: {m0_req}")
            # else:
            #     print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {self.name} received a Read Request from Master 0: {m0_req}")
        if self.m1_port.m_valid:
            m1_req = self.m1_port.recv_master()
            m1_req.source_id = 1
            self.ready_q.append(m1_req)
            # if m1_req.wr_en:
            #     print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {self.name} received a Write Request from Master 1: {m1_req}")
            # else:
            #     print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {self.name} received a Read Request from Master 1: {m1_req}")
        self.fcfs_arbiter(sys_c)
        if m0_req and m1_req and m0_req.id == m1_req.id:
            self.next_grant()

    def send_master(self, sys_c):
        if len(self.resp_q) > 0 and self.resp_q[0].source_id == 0 and self.m0_port.m_ready:
            resp = self.resp_q.pop(0)
            self.m0_port.send_master(resp)
            # print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {self.name} sent a Read Response to Master 0: {resp}")
        if len(self.resp_q) > 0 and self.resp_q[0].source_id == 1 and self.m1_port.m_ready:
            resp = self.resp_q.pop(0)
            self.m1_port.send_master(resp)
            # print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {self.name} sent a Read Response to Master 1: {resp}")

    def send_slave(self, sys_c):
        if len(self.ready_q) > 0 and self.s_port.s_ready:
            req = self.ready_q.pop(0)
            req.id = sys_c.cycle
            self.s_port.send_slave(req)
            # if req.wr_en:
            #     print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {self.name} sent a Write Request to Slave: {req}")
            # else:
            #     print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {self.name} sent a Read Request to Slave: {req}")

    def receive_slave(self, sys_c):
        if self.s_port.s_valid:
            resp = self.s_port.recv_slave()
            self.resp_q.append(resp)
            # print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {self.name} received a Read Response from Slave: {resp}")

    def update(self):
        self.m0_port.update()
        self.m1_port.update()
        self.s_port.update()

    def run(self, sys_c):
        self.receive_master(sys_c)
        self.send_slave(sys_c)
        self.receive_slave(sys_c)
        self.send_master(sys_c)




