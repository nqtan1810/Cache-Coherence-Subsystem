from DRAM_controller import *
from bi_directional_port import *
class DRAM:
    def __init__(self, name=''):
        self.name = name
        print(f"{self.name} is created!")

        # port to connect to Master
        self.m_port = bi_directional_port(name+'.m_port')

        # DRAM Controller
        self.controller = Controller('DRAM_Controller')

        # connect port to sub-components
        self.controller.m_port = self.m_port
        self.controller.m_port.send_port = self.m_port.send_port
        self.controller.m_port.recv_port = self.m_port.recv_port

        # connect port to sub-components
        self.controller.scheduler.m_port = self.m_port
        self.controller.scheduler.m_port.send_port = self.m_port.send_port
        self.controller.scheduler.m_port.recv_port = self.m_port.recv_port

        self.controller.control_logic.m_port = self.m_port
        self.controller.control_logic.m_port.send_port = self.m_port.send_port
        self.controller.control_logic.m_port.recv_port = self.m_port.recv_port

        # init data
        self.controller.control_logic.memory.generate_original_data()

        # overwrite name
        self.controller.control_logic.name = self.name

    def run(self, sys_c):
        self.controller.process(sys_c)

    def update(self):
        self.controller.update()
        self.m_port.update()