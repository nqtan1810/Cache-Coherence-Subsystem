//////////////////////////////////////////////////////////////////////////////////
// this module is used to store 3-bit MOESI state and 22-bit Tag
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ns

module state_tag_ram
#(
    parameter SET_WIDTH = 4,   // set - addr[9:6]
    parameter STATE_WIDTH = 3,
    parameter TAG_WIDTH = 22    // tag - addr[31:10]
)
(
    input   clk, rst_n, w_en1, w_en2, 
    input   [STATE_WIDTH+TAG_WIDTH-1:0] w_state_tag1,
    input   [STATE_WIDTH+TAG_WIDTH-1:0] w_state_tag2,
    input   [SET_WIDTH-1:0] rw_addr1,
    input   [SET_WIDTH-1:0] rw_addr2,
    output  reg [STATE_WIDTH+TAG_WIDTH-1:0] r_state_tag1,
    output  reg [STATE_WIDTH+TAG_WIDTH-1:0] r_state_tag2
);
     
    // Declare the RAM variable
	reg [STATE_WIDTH+TAG_WIDTH-1:0] state_tag_ram [0:2**SET_WIDTH-1];
    
    integer i;
    initial for (i=0; i<2**SET_WIDTH; i=i+1) state_tag_ram[i] = {3'b100, 22'b0};
    
    always @(posedge clk) begin
        // write
        if(w_en1)
            state_tag_ram[rw_addr1] <= w_state_tag1;
        // read
        if(!rst_n)
            r_state_tag1 <= 0;
        else
            r_state_tag1 <= state_tag_ram[rw_addr1];
    end
    
    always @(posedge clk) begin
        // write
        // if(w_en2 && (rw_addr2 != rw_addr1))
        // if(w_en2 && (rw_addr2 != rw_addr1) && !w_en1)
        if(w_en2 && ((rw_addr2 != rw_addr1) || ((rw_addr2 == rw_addr1) && !w_en1)))
            state_tag_ram[rw_addr2] <= w_state_tag2;
        // read
        if(!rst_n)
            r_state_tag2 <= 0;
        else
            r_state_tag2 <= state_tag_ram[rw_addr2];
    end

endmodule



