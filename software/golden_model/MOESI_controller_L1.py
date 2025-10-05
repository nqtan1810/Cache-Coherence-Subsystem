# *******************************************************************************
# this class define a MOESI Controller for Cache L1
# *******************************************************************************

from subsystem_parameter import *

class MOESI_controller_L1:
    def __init__(self, name=''):
        self.name = name
        # print(f"{self.name} is created!")
        self.M = 'M'
        self.O = 'O'
        self.E = 'E'
        self.S = 'S'
        self.I = 'I'

    def get_new_MOESI_state(self, MOESI_state_in, is_hit, instr_type, is_mem_fetch, is_bus_fetch, bus_noop, cpu_bus_access):
        if cpu_bus_access:                                  # cpu read/write
            if is_hit:                                      # cache hit
                if instr_type:
                    return self.M
                else:
                    return MOESI_state_in
            elif is_bus_fetch:                              # miss and fetch from other cache
                if instr_type:
                    return self.M
                else:
                    return self.S
            elif is_mem_fetch:                              # miss and fetch from memory
                if instr_type:
                    return self.M
                else:
                    return self.E
            else:
                return MOESI_state_in
        else:                                               # other cache read/write
            if is_hit:
                if bus_noop == 0:                           # request block from other cache
                    if MOESI_state_in == self.E:
                        return self.S
                    elif MOESI_state_in == self.M:
                        return self.O
                    else:
                        return MOESI_state_in
                elif bus_noop == 1:                         # request block from other cache and invalid this block in other cache
                    return self.I
                elif bus_noop == 2:                         # request other cache invalid this block
                    return self.I
                else:
                    return MOESI_state_in
            else:
                return MOESI_state_in
