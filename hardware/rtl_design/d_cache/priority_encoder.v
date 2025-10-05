//////////////////////////////////////////////////////////////////////////////////
//
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ns

module priority_encoder
(
    input w3, w2, w1, w0,
    output reg [1:0] way
);

    always @(*) begin
        casex({w3, w2, w1, w0})
            4'b0001: way = 2'b00;
            4'b001x: way = 2'b01;
            4'b01xx: way = 2'b10;
            4'b1xxx: way = 2'b11;
            default: way = 2'b00;
        endcase
    end
    
endmodule
