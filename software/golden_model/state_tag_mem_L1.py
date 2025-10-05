# *******************************************************************************
# this class define a State-Tag Mem for Cache L1
# *******************************************************************************

from way_L1 import *

class state_tag_mem_L1:
    def __init__(self, name='', n_way=WAY_NUM_L1, n_set=SET_NUM_L1):
        self.name = name
        # print(f"{self.name} is created!")
        self.n_way = n_way
        self.way_arr = [way_L1(f"way_{way_id}", n_set) for way_id in range(n_way)]

    def compare(self, way_index, set_index, tag):
        return tag == self.way_arr[way_index].read_tag(set_index)

    def is_valid(self, way_index, set_index):
        return self.way_arr[way_index].read_state(set_index) != self.way_arr[way_index].I

    def is_hit(self, set_index, tag):
        return any(self.compare(way_index, set_index, tag) and self.is_valid(way_index, set_index) for way_index in range(self.n_way))

    def is_E(self, set_index, way_index):
        self.way_arr[way_index].read_state(set_index) == self.way_arr[way_index].E

    def get_way_hit(self, set_index, tag):
        encoder = [self.compare(way_index, set_index, tag) and self.is_valid(way_index, set_index) for way_index in range(self.n_way)]
        for way_index in range(self.n_way):
            if encoder[way_index]:
                return way_index

    def get_set_valid(self, set_index):  # MERGE VALID SIGNAL OF 4 BlOCK OF SET INTO VECTOR
        set_valid = [self.is_valid(way_index, set_index) for way_index in range(self.n_way)]
        return set_valid

    def is_full(self, set_index):  # SET FULL OR NOT
        return all(self.is_valid(way_index, set_index) for way_index in range(self.n_way))

    def is_dirty(self, way_index, set_index):
        return self.way_arr[way_index].read_state(set_index) in [self.way_arr[way_index].M, self.way_arr[way_index].O, self.way_arr[way_index].S]
