`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// this FIFO is used to store request in AXI channels
//////////////////////////////////////////////////////////////////////////////////


module sync_fifo 
#(
    parameter DATA_WIDTH = 32,               // Data width
    parameter ADDR_WIDTH = 1,            // Address width (depth = 2^ADDR)
    parameter DEPTH      = (1 << ADDR_WIDTH)      // FIFO depth
)
(
    input                           clk,
    input                           rst_n,

    // Wri
    input                           wen,
    input       [DATA_WIDTH-1:0]    din,
    output                          full,

    // Re
    input                           ren,
    output reg  [DATA_WIDTH-1:0]    dout,
    output                          empty
);

    // Memory
    reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];

    // Pointers and counter
    reg [ADDR_WIDTH-1:0] wptr = 0;
    reg [ADDR_WIDTH-1:0] rptr = 0;
    reg [ADDR_WIDTH:0]   count = 0;  // One bit wider to count up to D

    // Write operation
    always @(posedge clk) begin
        if (!rst_n) begin
            wptr <= 0;
        end 
        else 
        if (wen && !full) begin
            mem[wptr] <= din;
            wptr <= wptr + 1;
        end
    end

    // Read operation (write-first behavior)
    always @(posedge clk) begin
        if (!rst_n) begin
            dout <= {DATA_WIDTH{1'b0}};
            rptr <= 0;
        end 
        else 
        if (ren && !empty) begin
            dout <= mem[rptr];
            rptr <= rptr + 1;
        end
    end

    // Counter logic for full/empty detection
    always @(posedge clk) begin
        if (!rst_n) begin
            count <= 0;
        end else begin
            case ({wen && !full, ren && !empty})
                2'b10:   count <= count + 1;  // write only
                2'b01:   count <= count - 1;  // read only
                2'b11:   count <= count;      // simultaneous read and write
                default: count <= count;    // no activity
            endcase
        end
    end

    // Status flags
    assign full  = (count == DEPTH);
    assign empty = (count == 0);

endmodule

