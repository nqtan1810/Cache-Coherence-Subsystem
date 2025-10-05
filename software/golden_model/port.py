# *******************************************************************************
# this class define the port model to connect between subsystem's component
# *******************************************************************************

import sys
from subsystem_parameter import *

class port:
    def __init__(self, name='', buf_width=PORT_BUF_WIDTH):
        # set port name
        self.name = name
        # print(f"{self.name} is created!")

        # Internal buffer
        self.buf_width = buf_width  # this is the buffer's size
        self.buffer = []  # Buffer to hold the transactions, initially empty

        # Control signals
        self.ready = 1  # Indicates whether the port can accept a new transaction
        self.valid = 0  # Indicates if the port has a valid transaction for output


    def write(self, trans):
        # Write a transaction to the buffer if the port is ready.
        if self.ready == 1:
            self.buffer.append(trans)
            # print(f"Transaction {trans} added to buffer. Buffer size: {len(self.buffer)}")
        else:
            # print("Port not ready to accept the transaction or buffer is full.")
            sys.exit(f"[ERROR.{self.port_name}]: Can't write into full buffer")

    def read(self):
        # Read a transaction from the buffer if the port has a valid output.
        trans = None
        if self.valid == 1:
            trans = self.buffer.pop(0)  # Get the first transaction from the buffer (FIFO)
            # print(f"Transaction {trans} sent from buffer. Buffer size: {len(self.buffer)}")
        else:
            # print("No valid transaction to read or output not ready.")
            sys.exit(f"[ERROR.{self.port_name}]: Can't read from empty buffer")
        return trans

    def update(self):
        self.valid = len(self.buffer) != 0
        self.ready = len(self.buffer) < self.buf_width