# *******************************************************************************
# this class define the bi-directional port model to connect between subsystem's component
# *******************************************************************************

from port import *

class bi_directional_port:
    def __init__(self, name='', buf_width=PORT_BUF_WIDTH):
        # set port name
        self.name = name
        # print(f"{self.name} is created!")

        # send port
        self.send_port = port(name+'.send_port', buf_width)
        self.recv_port = port(name+'.recv_port', buf_width)

        # Control signals
        # master side
        self.s_valid = 0  # Indicates if the slave port has a valid transaction for output
        self.s_ready = 1  # Indicates whether the slave port can accept a new transaction

        # slave side
        self.m_valid = 0  # Indicates if the master port has a valid transaction for output
        self.m_ready = 1  # Indicates whether the master port can accept a new transaction


    # master side
    def send_slave(self, trans):
        self.send_port.write(trans)

    def recv_slave(self):
        return self.recv_port.read()

    # slave side
    def send_master(self, trans):
        self.recv_port.write(trans)

    def recv_master(self):
        return self.send_port.read()

    def update(self):
        self.send_port.update()
        self.recv_port.update()
        self.s_valid = self.recv_port.valid
        self.s_ready = self.send_port.ready
        self.m_valid = self.send_port.valid
        self.m_ready = self.recv_port.ready