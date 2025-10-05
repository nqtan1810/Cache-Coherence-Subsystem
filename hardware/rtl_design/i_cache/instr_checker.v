`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// this is checker used to check hit/miss for I-Cache
//////////////////////////////////////////////////////////////////////////////////


module instr_checker
#(
    parameter STATE_WIDTH = 2,
    parameter TAG_WIDTH = 22,
    parameter I = 2'b10        // Invalid state
)
(
    input   [TAG_WIDTH-1:0] tag_compare,
    
    input   [TAG_WIDTH-1:0] tag_w0,
    input   [TAG_WIDTH-1:0] tag_w1,
    input   [TAG_WIDTH-1:0] tag_w2,
    input   [TAG_WIDTH-1:0] tag_w3,
    
    input   [STATE_WIDTH-1:0] state_w0,
    input   [STATE_WIDTH-1:0] state_w1,
    input   [STATE_WIDTH-1:0] state_w2,
    input   [STATE_WIDTH-1:0] state_w3,
    
    input   state_tag_w_en,
    input   [1:0] way,      // hit_way/evicted_way
    
    // write enable in state_tag_ram
    output  w_en_w0,
    output  w_en_w1,
    output  w_en_w2,
    output  w_en_w3,
    
    output  hit,
    output  [1:0] hit_way,
    output  full,
    output  [3:0] valid,
    output  [STATE_WIDTH-1:0] hit_way_state
);
    
    // to check whether hit/miss when request coming from CPU
    checker_port1   
    #(
        .STATE_WIDTH(STATE_WIDTH),
        .TAG_WIDTH  (TAG_WIDTH  ),
        .I          (I          )        // Invalid state
    )
    i_checker
    (
        .tag_compare(tag_compare),         // input
                                // input
        .tag_w0(tag_w0),              // input
        .tag_w1(tag_w1),              // input
        .tag_w2(tag_w2),              // input
        .tag_w3(tag_w3),              // input
                                // input
        .state_w0(state_w0),            // input
        .state_w1(state_w1),            // input
        .state_w2(state_w2),            // input
        .state_w3(state_w3),            // input
        
        .state_tag_w_en(state_tag_w_en),      // input
        .way(way),                 // input
        
        // write enable in state_tag_ram
        .w_en_w0(w_en_w0),             // output
        .w_en_w1(w_en_w1),             // output
        .w_en_w2(w_en_w2),             // output
        .w_en_w3(w_en_w3),             // output
                                
        .hit(hit),                 // output
        .hit_way(hit_way),             // output
        .full(full),                // output
        .valid(valid),               // output
        .hit_way_state(hit_way_state)        // output
    );
    
endmodule
