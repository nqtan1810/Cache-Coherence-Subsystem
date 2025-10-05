//////////////////////////////////////////////////////////////////////////////////
// this module is used to check hit/miss for request from other cache L1
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ns

module checker_port2
#(
    parameter STATE_WIDTH = 3,
    parameter TAG_WIDTH = 22,
    parameter I = 3'b100
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
    
    // write enable in state_tag_ram
    output  w_en_w0,
    output  w_en_w1,
    output  w_en_w2,
    output  w_en_w3,
    
    output  hit,
    output  [1:0] hit_way,
    output  [STATE_WIDTH-1:0] hit_way_state
);
    
    wire equal0, equal1, equal2, equal3;
    wire hit0, hit1, hit2, hit3;
    wire [3:0] valid;
    
    assign equal0 = (tag_w0 == tag_compare);
    assign equal1 = (tag_w1 == tag_compare);
    assign equal2 = (tag_w2 == tag_compare);
    assign equal3 = (tag_w3 == tag_compare);
    
    assign valid[0] = (state_w0 != I);
    assign valid[1] = (state_w1 != I);
    assign valid[2] = (state_w2 != I);
    assign valid[3] = (state_w3 != I);
    
    assign hit0 = valid[0] && equal0;
    assign hit1 = valid[1] && equal1;
    assign hit2 = valid[2] && equal2;
    assign hit3 = valid[3] && equal3;
    
    assign hit = hit0 || hit1 || hit2 || hit3;
    
    // generate way_hit[1:0]
    priority_encoder encoder (.w3(hit3), .w2(hit2), .w1(hit1), .w0(hit0), .way(hit_way));
    
    assign w_en_w0 = state_tag_w_en && hit0;
    assign w_en_w1 = state_tag_w_en && hit1;
    assign w_en_w2 = state_tag_w_en && hit2;
    assign w_en_w3 = state_tag_w_en && hit3;
    
    // generate hit_way_state[2:0]
    // assign hit_way_state = (hit_way[1]) ? ((hit_way[0]) ? state_w3 : state_w2) : ((hit_way[0]) ? state_w1 : state_w0);
    assign hit_way_state = hit0 ? state_w0 : hit1 ? state_w1 : hit2 ? state_w2 : hit3 ? state_w3 : state_w0;
    
endmodule