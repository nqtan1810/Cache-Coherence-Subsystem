//////////////////////////////////////////////////////////////////////////////////
// this module is used to find access way (hit) or evictim way (miss) and generate
// the next PLRUt bit for replacement purpose
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ns

module plrut_controller
#(
    parameter DATA_WIDTH = 3
)
(
    input   hit,
    input   full,
    input   [3:0] valid,
    input   [1:0] hit_way,  // used to find next_PLRUt bits if hit
    input   [2:0] current_PLRUt,
    
    output  reg [2:0] next_PLRUt,
    output  reg [1:0] access_way    // hit_way if hit, evicted_way if miss
);
     
    function [1:0] plrut2way(input [2:0] plrut);
        if(plrut[1] == 0) begin
            if(plrut[0] == 0) begin
                plrut2way = 2'b00;
            end
            else begin
                plrut2way = 2'b01;
            end
        end
        else begin
            if(plrut[2] == 0) begin
                plrut2way = 2'b10;
            end
            else begin
                plrut2way = 2'b11;
            end
        end
    endfunction
    
    function [2:0] way2plrut(input [1:0] way, input [2:0] PLRUt);
        case(way) 
            2'b00: way2plrut = {PLRUt[2], 2'b00};
            2'b01: way2plrut = {PLRUt[2], 2'b01};
            2'b10: way2plrut = {2'b01, PLRUt[0]};
            2'b11: way2plrut = {2'b11, PLRUt[0]};
            default: way2plrut = {PLRUt[2], 2'b00};
        endcase
    endfunction
    
    function [1:0] find_way(input [3:0] valid);
        if(valid[0] == 0) begin
            find_way = 2'b00;  
        end
        else
        if(valid[1] == 0) begin
            find_way = 2'b01;
        end
        else 
        if(valid[2] == 0) begin
            find_way = 2'b10;
        end
        else begin
            find_way = 2'b11;
        end
    endfunction
    
    function [2:0] inverse_plrut(input [2:0] plrut);
        if(plrut[1] == 0) begin
            inverse_plrut = plrut ^ 3'b110;
        end
        else begin
            inverse_plrut = plrut ^ 3'b011;
        end
    endfunction
    
    always @(*) begin
        if (hit) begin
            next_PLRUt = way2plrut(hit_way, current_PLRUt);
            access_way = hit_way;
        end
        else begin
            if (full) begin
                next_PLRUt = inverse_plrut(current_PLRUt);
                access_way = plrut2way(next_PLRUt);
            end
            else begin
                access_way = find_way(valid);
                next_PLRUt = way2plrut(access_way, current_PLRUt);
            end
        end
    end

endmodule
