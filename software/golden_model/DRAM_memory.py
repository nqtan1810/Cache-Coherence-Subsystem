import numpy as np
from subsystem_parameter import *
import random
import copy


class MemArray:
    def __init__(self, name='', n_rows=N_ROWS, n_cols=N_COLS):
        self.name = name
        # print(f"{self.name} is created!")

        self.data_array = [[0 for _ in range(n_cols)] for _ in range(n_rows)]  # 128 x 16 arrray
        self.sense_amplifier = [0 for _ in range(n_cols)]  # 16val-array - Sense Amplifier

        self.n_rows_b = np.ceil(np.log2(n_rows)).astype(dtype=np.int32)  # Cow_Address_Length = 7b
        self.n_cols_b = np.ceil(np.log2(n_cols)).astype(dtype=np.int32)  # Col_Address_Length = 4b

    def refresh(self):  # Refresh the data
        for row in range(N_ROWS):
            for col in range(N_COLS):
                self.data_array[row][col] = self.data_array[row][col]

    def row_addr_decode(self, row_address):  # Transfer Row_Address from binary to decimal
        return int(row_address, 2)

    def col_addr_decode(self, col_address):  # Transfer Col_Address from binary to decimal
        return int(col_address, 2)

    def activate(self, RAS, row):
        if RAS:
            row_dec = self.row_addr_decode(row)
            for i in range(N_COLS):
                self.sense_amplifier[i] = self.data_array[row_dec][i]

    def precharge(self, PRE):
        if PRE:
            for i in range(len(self.sense_amplifier)):
                self.sense_amplifier[i] = None

    def read(self, col):
        col_int = self.col_addr_decode(col)
        data_out = copy.deepcopy(self.sense_amplifier[col_int])
        return data_out

    def write(self, col, row, data_in):
        col_dec = self.col_addr_decode(col)
        row_dec = self.row_addr_decode(row)
        data_in = int(data_in)
        self.sense_amplifier[col_dec] = data_in
        self.data_array[row_dec][col_dec] = self.sense_amplifier[col_dec]


class Bank:
    def __init__(self, name='', n_mem_array=N_MEM_ARRS, n_rows=N_ROWS, n_cols=N_COLS):
        self.name = name
        self.row_start = 0
        self.row_end = self.row_start + ROW_ADDR_WIDTH
        self.bank_start = self.row_end
        self.bank_end = self.bank_start + BANK_ADDR_WIDTH
        self.col_start = self.bank_end
        self.col_end = self.col_start + COL_ADDR_WIDTH
        # print(f"{self.name} is created!")

        self.mem_array_list = [MemArray(name=f'MemArray_{i}', n_rows=n_rows, n_cols=n_cols) for i in
                               range(n_mem_array)]  # 8 MEM ARRAY
        self.data_buffer = []

    def read_write(self, WE, CAS, col, data, row):
        a = "********"
        if CAS == 1:
            if WE == 0:
                data_temp_8b = []  # Get 8 bit from 8 MemArray (1bit/1MemArray)
                exist = 0

                # Check if row access already have in data buffer
                # print(f'bug1: {self.data_buffer}')
                for data, collum in self.data_buffer:
                    if col == collum:
                        exist = 1
                        data_read = data

                # If already have data of that row, read it out
                if exist:
                    data_read = ''.join(map(str, data_read))

                # If not already have data of that row, load it from 8 mem array to data buffer then read it out
                elif not exist:
                    for mem_array in self.mem_array_list:
                        new_data = mem_array.read(col)
                        data_temp_8b.append(new_data)
                    # Append new (data,col) to Buffer
                    self.data_buffer.append((data_temp_8b, col))
                    # Get data to read
                    data_read = self.data_buffer[len(self.data_buffer) - 1][0]
                    # Convert 8bit data from List to String
                    data_read = ''.join(map(str, data_read))
                return (data_read)

            elif WE == 1:
                i = 0
                for mem_array in self.mem_array_list:
                    data_b = data[i]
                    mem_array.write(col, row, data_b)
                    i = i + 1
                i = 0
                return a
        else:
            return a

    def activate(self, ACT, WE, RAS, row, data, COL):
        if ACT:
            # Activate Bank Buffer
            if WE == 0:
                self.data_buffer = []
            if WE == 1:
                # print(f'bug2: {data}')
                self.data_buffer.append(([i for i in data], COL))
            # Activate Mem Array Sense Amplifier
            for mem_array in self.mem_array_list:
                mem_array.activate(RAS, row)

    def precharge(self, PRE):
        if PRE:
            self.data_buffer = []
            for mem_array in self.mem_array_list:
                mem_array.precharge(PRE)

    def process(self, signal):
        ACT = signal[0]
        PRE = signal[1]
        RAS = signal[2]
        CAS = signal[3]
        WE = signal[4]
        ROW = signal[5][self.row_start:self.row_end]
        COL = signal[5][self.col_start:self.col_end]
        DATA = signal[6]
        # print(f'bug4: {signal}')
        self.activate(ACT, WE, RAS, ROW, DATA, COL)
        self.precharge(PRE)
        data_io = self.read_write(WE, CAS, COL, DATA, ROW)
        return data_io


class Chip:
    def __init__(self, name='', n_bank=N_BANKS, n_mem_array=N_MEM_ARRS, n_rows=N_ROWS, n_cols=N_COLS):
        self.name = name
        self.bank_start = ROW_ADDR_WIDTH
        self.bank_end = self.bank_start + BANK_ADDR_WIDTH
        # print(f"{self.name} is created!")
        self.bank_list = [Bank(name=f'BANK_{i}', n_mem_array=n_mem_array, n_rows=n_rows, n_cols=n_cols) for i in
                          range(n_bank)]  # 4 BANK

    def process(self, signal):
        if signal[5] is None:
            return None
        else:
            bank_idx = signal[5][self.bank_start:self.bank_end]
            bank_idx = int(bank_idx, 2)
            # print(f'bug5: {signal}')
            data_io = self.bank_list[bank_idx].process(signal)
            return data_io


class RANK:
    def __init__(self, name='', n_chip=N_CHIPS, n_bank=N_BANKS, n_mem_array=N_MEM_ARRS, n_rows=N_ROWS, n_cols=N_COLS):
        self.name = name
        # print(f"{self.name} is created!")

        self.chip_list = [Chip(name=f'CHIP_{i}', n_bank=n_bank, n_mem_array=n_mem_array, n_rows=n_rows, n_cols=n_cols)
                          for i in range(n_chip)]  # 4 CHIP

    def process(self, signal):
        i = 0
        data_io = ""
        for chip in self.chip_list:
            if signal == None:
                chip.process(signal)
            else:
                # fixed_signal = signal
                fixed_signal = []
                fixed_signal.append(signal[0])  # avoid pointer with fixed_signal = signal
                fixed_signal.append(signal[1])
                fixed_signal.append(signal[2])
                fixed_signal.append(signal[3])
                fixed_signal.append(signal[4])
                fixed_signal.append(signal[5])
                fixed_signal.append(signal[6])
                if fixed_signal[6] != None:
                    fixed_signal[6] = signal[6][i:(i + 8)]
                    result = chip.process(fixed_signal)
                    data_io = data_io + result
                    i = i + 8
                else:
                    result = chip.process(signal)
                    if result != None:
                        data_io = data_io + result
        return data_io

    pass


class DIMM:
    def __init__(self, name=''):
        self.name = name
        # print(f"{self.name} is created!")

        self.RANK = RANK('RANK')
        self.data_io = None

    def process(self, signal):
        # print(f'bug6: {signal}')
        self.data_io = self.RANK.process(signal)
        return self.data_io

    def generate_original_data(self):
        # Initializes all data arrays in all memory arrays with random 0s and 1s.
        for chip in self.RANK.chip_list:
            for bank in chip.bank_list:
                for mem_array in bank.mem_array_list:
                    for row in range(N_ROWS):
                        for col in range(N_COLS):
                            # mem_array.data_array[row][col] = random.randint(0, 1)
                            mem_array.data_array[row][col] = 1
                        # print(mem_array.data_array[row])
