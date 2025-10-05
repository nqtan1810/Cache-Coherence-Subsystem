# *******************************************************************************************
# this class contain all things like clock cycle, components ... for easily sharing between components
# *******************************************************************************************

from port import *

class system_common:
    def __init__(self):
        # common signals
        self.cycle = 1
        self.rst_n = 1
        print(f"CLOCK generator is created!")

        # system's component
        self.cpu0 = None
        self.cpu1 = None
        self.cache_l1_0 = None
        self.cache_l1_1 = None
        self.axi_bus = None
        self.cache_l2 = None
        self.dram = None
        # ports to connect components together

    def clk_posedge(self):
        self.cycle += 1


