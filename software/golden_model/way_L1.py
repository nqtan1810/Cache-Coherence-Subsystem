# *******************************************************************************
# this class define a Way for Cache L1
# *******************************************************************************

import copy
from subsystem_parameter import *

class way_L1:
    def __init__(self, name='', n_set=SET_NUM_L1):
        self.name = name
        # print(f"{self.name} is created!")
        # state for cache block
        self.M = 'M'
        self.O = 'O'
        self.E = 'E'
        self.S = 'S'
        self.I = 'I'
        # number of set
        self.n_set = n_set

        # state-tag ram
        self.state_mem = [self.I] * n_set
        self.tag_mem = [None] * n_set

    def read_state(self, set_index):
        return copy.deepcopy(self.state_mem[set_index])

    def write_state(self, set_index, state, wr_en):
        if(wr_en):
            self.state_mem[set_index] = state

    def read_tag(self, set_index):
        return copy.deepcopy(self.tag_mem[set_index])

    def write_tag(self, set_index, tag, wr_en):
        if(wr_en):
            self.tag_mem[set_index] = tag

    def read(self, set_index):
        return copy.deepcopy(self.state_mem[set_index]), copy.deepcopy(self.tag_mem[set_index])

    def write(self, set_index, state, tag, wr_en):
        if(wr_en):
            self.state_mem[set_index] = state
            self.tag_mem[set_index] = tag

    def init_state_tag(self, file_path=''):
        if file_path == '':
            return
        else:
            char_map = {0: 'M', 1: 'O', 2: 'E', 3: 'S', 4: 'I'}
            index = 0
            with open(file_path, 'r') as file:
                for line in file:
                    binary_string = line.strip()
                    if binary_string != '':
                        # Extract the first 3 MSB bits and the next 22 LSB bits
                        state = int(binary_string[:3], 2)
                        tag = int(binary_string[3:25], 2)
                        # Convert the first number to the corresponding character
                        state_char = char_map.get(state, '?')  # Default to '?' if out of range
                        self.state_mem[index] = state_char
                        self.tag_mem[index] = tag
                        index += 1