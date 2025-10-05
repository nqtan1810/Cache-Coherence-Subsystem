`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// state-tag ram for I-Cache
//////////////////////////////////////////////////////////////////////////////////


module instr_state_tag_ram
#(
    parameter SET_WIDTH = 4,   // set - addr[9:6]
    parameter STATE_WIDTH = 2,  // I (Invalid) = 10, C (Clean) = 01, D (Dirty) = 00
    parameter TAG_WIDTH = 22    // tag - addr[31:10]
)
(
    input   clk, rst_n, w_en, 
    input   [STATE_WIDTH+TAG_WIDTH-1:0] w_state_tag,
    input   [SET_WIDTH-1:0] rw_addr,
    output  reg [STATE_WIDTH+TAG_WIDTH-1:0] r_state_tag
);

    // Declare the RAM variable
	reg [STATE_WIDTH+TAG_WIDTH-1:0] state_tag_ram [0:2**SET_WIDTH-1];
	
	integer i;
    initial for (i=0; i<2**SET_WIDTH; i=i+1) state_tag_ram[i] = {2'b10, 22'b0};
    
    always @(posedge clk) begin
        // write
        if(w_en)
            state_tag_ram[rw_addr] <= w_state_tag;
        // read
        if(!rst_n)
            r_state_tag <= 0;
        else
            r_state_tag <= state_tag_ram[rw_addr];
    end
	
endmodule
