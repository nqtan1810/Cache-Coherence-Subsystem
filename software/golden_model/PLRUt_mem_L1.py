# *******************************************************************************
# this class define a PLRUt Mem for storing PLRUt bits
# *******************************************************************************

import copy
from subsystem_parameter import *

class PLRUt_mem_L1:
    def __init__(self, name='', n_set=SET_NUM_L1, n_way=WAY_NUM_L1):
        self.name = name
        # print(f"{self.name} is created!")
        # self.n_set = n_set
        self.n_way = n_way
        self.plrut_mem = [[0 for _ in range(n_way-1)] for _ in range(n_set)]

    def write(self, set_index, next_PLRUt, wr_en):
        if wr_en:
            for i in range(self.n_way-1):
                self.plrut_mem[set_index][i] = next_PLRUt[i]

    def read(self, set_index):
        return copy.deepcopy(self.plrut_mem[set_index])

    def init_plrut(self, file_path=''):
        if file_path == '':
            return
        else:
            set = 0
            with open(file_path, 'r') as file:
                for line in file:
                    binary_string = line.strip()
                    if binary_string != '':
                        for way in range(3):
                            self.plrut_mem[set][way] = int(binary_string[way])
                        set += 1

