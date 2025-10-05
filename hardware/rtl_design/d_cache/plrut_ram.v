//////////////////////////////////////////////////////////////////////////////////
// this module is used to store 3-bit PLRUt for 4-way set associative cache
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ns

module plrut_ram
#(
    parameter ADDR_WIDTH = 4,
    parameter DATA_WIDTH = 3
)
(
    input   clk, rst_n, w_en,          // plrut_wr_en = cpu_wr_en | bus_wr_en
    input   [DATA_WIDTH-1:0] w_plrut,
    input   [ADDR_WIDTH-1:0] w_addr,      // using addr[9:6] to access
    input   [ADDR_WIDTH-1:0] r_addr,
    output  reg [DATA_WIDTH-1:0] r_plrut
);

    // Declare the RAM variable
	reg [DATA_WIDTH-1:0] plrut_ram[0:2**ADDR_WIDTH-1];
	
	integer i;
    initial for (i=0; i<2**ADDR_WIDTH; i=i+1) plrut_ram[i] = 0;

	always @ (posedge clk) begin
        // write
        if (w_en)
            plrut_ram[w_addr] <= w_plrut;
        
        // read    
        if (!rst_n)
            r_plrut <= 0;
        else
            r_plrut <= plrut_ram[r_addr];
    end

endmodule
