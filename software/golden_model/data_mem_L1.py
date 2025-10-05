# *******************************************************************************
# this class define a Data Mem for storing Read/Write data
# 1-word access by address = {set, way, word_offset}
# *******************************************************************************

from subsystem_parameter import *
import math
import copy

class data_mem_L1:
    def __init__(self, name='', n_set=SET_NUM_L1, n_way=WAY_NUM_L1):
        self.name = name
        # print(f"{self.name} is created!")
        self.data_mem = [0] * (n_set * n_way * CACHE_LINE_SIZE)

    def read(self, set, way, word_offset):
        return copy.deepcopy(self.data_mem[(((set << int(math.log2(WAY_NUM_L1))) + way) << int(math.log2(CACHE_LINE_SIZE))) + word_offset])

    def write(self, set, way, word_offset, wr_data, wr_en):
        if(wr_en):
            self.data_mem[(((set << int(math.log2(WAY_NUM_L1))) + way) << int(math.log2(CACHE_LINE_SIZE))) + word_offset] = wr_data

    def init_data_mem(self, file_path):
        with open(file_path, 'r') as file:
            index = 0
            for line in file:
                tmp_line = line.strip()
                if tmp_line != '':
                    # Strip whitespace and split the line into 16-character words
                    words = [line[i - 8:i] for i in range(len(line.strip()), 0, -8)]
                    for w in words:
                        self.data_mem[index] = int(w, 16)
                        index += 1

