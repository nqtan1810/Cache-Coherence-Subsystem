# *************************************************************************************************
# this class define a module which can detect and solve deadlock problems between two Cache L1
# *************************************************************************************************

import copy
from subsystem_parameter import *

class deadlock_handler:
    def __init__(self, name=''):
        self.name = name
        print(f"{self.name} is created!")

        # ports to monitor and solve deadlock
        self.m0_port = None
        self.m1_port = None

        # to access Cache L1
        self.cache_L1_0 = None
        self.cache_L1_1 = None

        # deadlock flag
        self.deadlock_triggered = 0

    def deadlock_detect(self, sys_c):
        if (self.cache_L1_0.state == 'REQ_BUS' and self.cache_L1_0.handshake_done) and (self.cache_L1_1.state == 'REQ_BUS' and self.cache_L1_1.handshake_done):
            if not self.deadlock_triggered:
                print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {self.name.ljust(10, ' ')}: Found a Deadlock!")
                print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {self.name.ljust(10, ' ')}: Found a Deadlock at {self.cache_L1_0.miss_req_q[0]}")
                print(f"[Cycle {str(sys_c.cycle).rjust(CYCLE_PRINT_WIDTH, ' ')}]: {self.name.ljust(10, ' ')}: Found a Deadlock at {self.cache_L1_1.miss_req_q[0]}")
                # print(f"[Cycle {sys_c.cycle}]: {self.name} is handling Deadlock!")
                self.deadlock_triggered = 1
            # else:
            #     print(f"[Cycle {sys_c.cycle}]: {self.name} is handling Deadlock!")
            return True
        self.deadlock_triggered = 0
        # print(f'{self.cache_L1_0.state} -- {self.cache_L1_1.state}')
        return False

    def deadlock_solve(self, sys_c):
        if self.deadlock_detect(sys_c):
            # when deadlock is detected, solve snoop request for both cores
            self.cache_L1_1.deadlock_solve(sys_c, copy.deepcopy(self.cache_L1_0.miss_req_q[0]))
            self.cache_L1_0.deadlock_solve(sys_c, copy.deepcopy(self.cache_L1_1.miss_req_q[0]))

    def run(self, sys_c):
        self.deadlock_solve(sys_c)
