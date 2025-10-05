# *******************************************************************************
# this file is used to define all subsytem's parameters
# *******************************************************************************

# number of testcase
number_of_testcase = 116        # number of subsystem testcase
cache_number_of_testcase = 16        # number of cache testcase
axi_coherence_number_of_testcase = 14


# simulation time in cycles
INSTR_NUM = 5000
BURST_NUM = 200
SIMULATION_TIME = 100000
CYCLE_PRINT_WIDTH = len(str(SIMULATION_TIME))

# *******************************************************************************
# general parameters
# *******************************************************************************
DATA_WIDTH = 32
ADDR_WIDTH = 32
WORD_SIZE  = 4


# *******************************************************************************
# Port parameters
# *******************************************************************************
PORT_BUF_WIDTH = 1


# *******************************************************************************
# CPU parameters
# *******************************************************************************
# Address Map (20-bit)
CPU_0_LOWER_BOUND = 0x00000
CPU_0_UPPER_BOUND = 0x0FFFF
CPU_1_LOWER_BOUND = 0x10000
CPU_1_UPPER_BOUND = 0x1FFFF
SHARE_LOWER_BOUND = 0x20000
SHARE_UPPER_BOUND = 0x3FFFF
DMA_LOWER_BOUND   = 0x40000
DMA_UPPER_BOUND   = 0x400FF

# delay for modeling
CPU_0_RW_DELAY = 0
CPU_1_RW_DELAY = 0

# *******************************************************************************
# DMA parameters
# *******************************************************************************
DMA_DELAY = 50

# *******************************************************************************
# MMU parameters
# *******************************************************************************
# 4KB page size
PAGE_SIZE = 4096


# *******************************************************************************
# CACHE parameters
# *******************************************************************************
# Common parameters
CACHE_LINE_SIZE = 16

# *******************************************************************************
# CACHE L1 parameters
# *******************************************************************************
SET_NUM_L1     = 16
WAY_NUM_L1     = 4
STATE_WIDTH_L1 = 3
TAG_WIDTH_L1   = 22

# delay for modeling purpose
CHECK_HIT_MISS_DELAY_L1 = 1
CACHE_READ_DELAY_L1     = 1
CACHE_WRITE_DELAY_L1    = 1
RESP_OTHER_CACHE_DELAY_L1 = 1

# *******************************************************************************
# CACHE L2 parameters
# *******************************************************************************
SET_NUM_L2     = 32
WAY_NUM_L2     = 16
STATE_WIDTH_L2 = 2
TAG_WIDTH_L2   = 21

# delay for modeling purpose
CHECK_HIT_MISS_DELAY_L2 = 2
CACHE_READ_DELAY_L2     = 6
CACHE_WRITE_DELAY_L2    = 10


# *******************************************************************************
# DRAM parameters
# *******************************************************************************
# structural parameters

COL_ADDR_WIDTH  = 4
BANK_ADDR_WIDTH = 2
ROW_ADDR_WIDTH  = 12
# MEM_ARRAY
N_ROWS = 2**ROW_ADDR_WIDTH
N_COLS = 16

# BANK
N_MEM_ARRS = 8
N_BANK_DATA_BUFFER_ROW = 10 # Number of buffer row in Bank Data Buffer

#CHIP
N_BANKS = 4 # Number of Banks in each chip

#RANK
N_CHIPS = 4

#DIMM
N_RANKS = 1

# CONTROLLER:
#   -> SCHEDULER:
# read & write queue max size
WR_QUEUE_SIZE = 20

# s0 & s1 queue size
S0S1_QUEUE_SIZE = 20

# final queue max size
FINAL_QUEUE_SIZE = 20

# number of clock cycle for getting new transactions from Read&Write Queue to schedule
N_CYCLE_REGET = 20

# minimum request of final queue to get new transactions from ead&Write Queue to schedule
MIN_REQUEST_REGET = 10

# timing parameters
# # TIMING CONTROLLER:
# t_ACT   = 3
# t_PRE   = 2
# t_READ  = 1
# t_WRITE = 1

# new timing parameters
t_RCD = 3   # row to collumn delay => time for activating
t_RP = 2    # row precharge => time for precharging

t_RL = 2    # read latency => from read signal to 1st bit data read out
t_CWD = 2   # collumn write delay (write latency - RL) => from write signal to 1st bit data write into

t_BURST = 2 # time for reading/writing data after (from 1st bit to last bit)

t_RTP = 9   # from read signal to precharge signal (similarly to t_WR, t_RR = RTP - t_RCD - t_RL - t_BURST)
t_WR = 4    # from completed writing data to precharge signal

t_WRD = 1   # word to word read delay in the same row
t_WWD = 1   # word to word write delay in the same row

t_CCD = 2   # from completed reading to read signal / completed writing to write signal
t_WTR = 3   # from completed writing to read signal
t_RTW = 3   # from completed reading to write signal
t_WRD = 1

# timing parameters
# # READ timing parameters
# # Minimum time interval that row address must be available before RAS_n signal becomes active.
# t_ASR = 1
#
# # row address must be hold t_RAH cycles after RAS_n signal becomes active
# t_RAH = 1
#
# # RAS_n is active t_RAS cycles (ACT to PRE delay)
# t_RAS = 5
#
# # Minimum time interval that col address must be available before CAS_n signal becomes active.
# t_ASC = 1
#
# # col address must be hold t_CAH cycles after CAS_n signal becomes active
# t_CAH = 1
#
# # Minimum time that WE_n = 1 before CAS_n signal is active
# t_RCS = 1
#
# # time interval that WE_n remain 1 after CAS_n is inactive
# t_RCH = 1
#
# # time interval that CAS_n signal is active (from high to low, remain low and go high again)
# t_CAS = 5
#
# # time interval from RAS_n is active to the time that output is available
# t_RAC = 5
#
# # time interval from CAS_n is active to the time that output is available
# t_CAC = 2
#
# # time interval from OE_n is active to the time that output is available
# t_OEA = 2
#
# # # time interval from col address is available to the time that output is available
# t_AA  = 3
#
# # the minimum time interval that CAS_n must be inactive after completing transaction
# t_CRP = 5
#
# # the minimum time interval that RAS_n must be inactive after completing transaction (PRE to ACT delay)
# t_RP  = 5
#
# # WRITE timing parameters
# # the minimum time interval that WE_n = 0 before CAS_n is active
# t_WCS = 1
#
# # the time interval that WE_n remain =0 after CAS_n is active
# t_WCH = 1
#
# # the time interval that WE_n = 0 (from high to low, remain low and go high again)
# t_WP  = 5
#
# # minimum time interval that write data must be available before CAS_n is active
# t_DS  = 1
#
# # minimum time interval that write data must remain after CAS_n is active
# t_DH  = 1
#
# # ACTIVE timing parameters
# #row-to-row delay, time interval between ACT commands (ACT to ACT delay, different bank)
# t_RRD = 5
#
# # Four-Activate-Window or Fifth-Activate-Window,
# # if 4 commands is back-to-back, then there must be a t_RRD delay between them. (Four ACT window, different bank)
# t_FAW = 25
#
# # ACT to RD/WR delay (same bank)
# t_RCD = 1
#
# # ACT to ACT delay (the same bank)
# t_RC  = t_RAS + t_RP
#
# # REFRESH timing parameters
# # retention time for each cell (64ms)
# t_REF  = 64 * (1**20)
#
# # The device requires REFRESH commands at an average interval of t_REFI
# t_REFI = t_REF / ROW_NUM
#
# # Delay between the REFRESH command and the next valid command, except DES
# t_RFC  = 5
#
# # READ<-->WRITE timing parameters
# # RD to WR delay (any bank)
# t_RTW = 5
#
# # WR to RD delay (any bank)
# t_WTR = 5
#
# # RD-to-RD or WR-to-WR delay (any bank)
# t_CCD = 5
