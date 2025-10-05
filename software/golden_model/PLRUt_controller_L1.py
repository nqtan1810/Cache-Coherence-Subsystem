# *******************************************************************************
# this class define a PLRUt Mem for controlling PLRUt bits
# *******************************************************************************

from subsystem_parameter import *

class PLRUt_controller_L1:
    def __init__(self, name='', n_set=SET_NUM_L1, n_way=WAY_NUM_L1):
        self.name = name
        # print(f"{self.name} is created!")
        self.n_way = n_way

    def find_invalid_way(self, valid):
        for way in range(len(valid)):
            if not valid[way]:
                return way

    def way2plrut(self, way, PLRUt):
        match way:
            case 0: PLRUt[0], PLRUt[1] = 0, 0
            case 1: PLRUt[0], PLRUt[1] = 1, 0
            case 2: PLRUt[2], PLRUt[1] = 0, 1
            case 3: PLRUt[2], PLRUt[1] = 1, 1
            case _: PLRUt[0], PLRUt[1] = 0, 0
        return PLRUt

    def plrut2way(self, PLRUt):
        if PLRUt[1]:
            if PLRUt[2]:
                return 3
            else:
                return 2
        else:
            if PLRUt[0]:
                return 1
            else:
                return 0

    def inverse_plrut(self, PLRUt):
        if PLRUt[1]:
            PLRUt[1] = 0
            if PLRUt[0]:
                PLRUt[0] = 0
            else:
                PLRUt[0] = 1
        else:
            PLRUt[1] = 1
            if PLRUt[2]:
                PLRUt[2] = 0
            else:
                PLRUt[2] = 1
        return PLRUt

    def get_new_PLRUt(self, hit, full, valid, way_hit, PLRUt):
        if hit:
            return self.way2plrut(way_hit, PLRUt)
        else:
            if full:
                return self.inverse_plrut(PLRUt)
            else:
                victim_way = self.find_invalid_way(valid)
                return self.way2plrut(victim_way, PLRUt)

    def find_victim_way(self, full, valid, PLRUt):        # could be valid or invalid way
        if full:
            PLRUt_next = self.inverse_plrut(PLRUt)
            return self.plrut2way(PLRUt_next)
        else:
            return self.find_invalid_way(valid)
