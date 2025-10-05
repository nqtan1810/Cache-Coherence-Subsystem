`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// state controller for I-Cache: I, C, D
//////////////////////////////////////////////////////////////////////////////////


module instr_state_controller
(
    input [1:0]      hit_way_state,     // both hit_way and evicted_way
    input            hit,
    input            instr_type,               // read = 0, write = 1
    input            is_mem_fetch,
    
    output reg       is_dirty,
    output reg [1:0] next_state
);

    parameter I = 2'b10;
    parameter C = 2'b01;
    parameter D = 2'b00;
    
    always @(*) begin
        // is this block dirty or not
        if(hit_way_state == D) begin
            is_dirty = 1;
        end
        else begin
            is_dirty = 0;
        end
        
        // generate the next MOESI state for cpu access
        if(hit) begin                   // hit
            if(instr_type) begin        // write hit
                next_state = D;
            end
            else begin                  // read hit
                next_state = hit_way_state;
            end
        end 
        else
        if(is_mem_fetch) begin       // fetch data from memory
            next_state = C;
        end
        else begin
            next_state = I;
        end
    end

endmodule
