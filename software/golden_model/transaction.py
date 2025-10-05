# *******************************************************************************
# this class define the transaction communicating between subsystem's component
# *******************************************************************************

class transaction:
    def __init__(self, id=0, source_id=0, wr_en=0, data=0, data_strobe=0xf, addr=0, snoop_type=3):
        self.id = id
        self.source_id = source_id          # used by axi interconnect for routing and arbitration
        self.wr_en = wr_en                  # Read: wr_en = 0; Write: wr_en = 1
        self.data = data
        self.data_strobe = data_strobe
        self.addr = addr
        self.snoop_type = snoop_type        # 0:rd, 1:rdx, 2:invalid (use by Cache L1), 3:Not used
        self.bin_addr = format(self.addr & 0xFFFFFFFF, '032b')
        self.bin_data = format(self.data & 0xFFFFFFFF, '032b')
        self.length = 0                     # this field is used for DMA only (byte)
        self.rlast = 0
        self.wlast = 0
        self.wdone = 0
        self.sdone = 0
        self.is_E_E = 0

    def __str__(self):
        return (f"Transaction(ID=0x{self.id:01x}, "
                f"Source_ID=0x{self.source_id:01x}, "        # may be string type??
                f"wr_en=0x{self.wr_en:01x}, "
                f"data=0x{self.data:08x}, "
                f"data_strobe=0x{self.data_strobe:01x}, "
                f"addr=0x{self.addr:08x}, "
                f"snoop_type=0x{self.snoop_type:01x}, "
                f"length=0x{self.length:04x}, "
                f"rlast=0x{self.rlast}, "
                f"wlast=0x{self.wlast}, "
                f"wdone=0x{self.wdone}, "
                f"sdone=0x{self.sdone})")

    def pack_trans(self, trans):
        if trans[0] == 'read':
            self.wr_en = 0
            self.addr = trans[1]
        elif trans[0] == 'write':
            self.wr_en = 1
            self.addr = trans[1]
            self.data = trans [2]

    def convert_int2bin(self):
        self.bin_addr = format(self.addr & 0xFFFFFFFF, '032b')
        self.bin_data = format(self.data & 0xFFFFFFFF, '032b')

    def convert_bin2int(self):
        self.addr = int(self.bin_addr, 2)
        self.data = int(self.bin_data, 2)
