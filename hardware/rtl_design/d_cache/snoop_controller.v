//////////////////////////////////////////////////////////////////////////////////
// this controller is used to control the access of requests coming from other Cache L1
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ns

module snoop_controller
(
    // system signals
    input                       ACLK,
    input                       ARESETn,
    
    // Snoop Channels
    // AC Channel
    input   [3:0]               ACSNOOP,
    input   [2:0]               ACPROT,
    input                       ACVALID,
    output  reg                 ACREADY,
    
    // CR Channel
    input                       CRREADY,
    output  reg                 CRVALID,
    output  reg [4:0]           CRRESP,
    
    // CD Channel
    input                       CDREADY,
    output  reg                 CDVALID,
    output  reg                 CDLAST,
    
    // signals to control datapath
    // input from checker_port2_REG
    input                       hit,
    input                       is_dirty,
    input                       is_exclusive,
    output  reg                 state_tag_w_en,
    output  reg [3:0]           control_offset,
    output  reg                 bus_in_reg_en
    // output  reg checker_port2_out_reg_en,
    // output  reg moesi_controller_out_reg_en
);
    
    // state definition
    localparam  IDLE     = 0;
    localparam  AC_ADDR  = 1;
    localparam  HIT_MISS = 2;
    localparam  CR_RESP  = 3;
    localparam  CD_DATA  = 4;
    
    // variable to store state
    reg [2:0] state, next_state;
    
    // internal registers
    reg [3:0] sent_word_cnt;
    
    always @(posedge ACLK) begin
        if (!ARESETn) begin
            state <= IDLE;
        end
        else begin
            state <= next_state;
        end
    end
    
    always @(*) begin
        case (state)
            IDLE: next_state = ACVALID ? AC_ADDR : IDLE;
            AC_ADDR: next_state = ACVALID ? HIT_MISS : AC_ADDR;
            HIT_MISS: next_state = CR_RESP;
            CR_RESP: next_state = CRREADY ? ((!hit || (ACSNOOP == 4'b1101)) ? IDLE : CD_DATA) : CR_RESP;
            CD_DATA: next_state = (sent_word_cnt == 4'b1111 && CDREADY) ? IDLE : CD_DATA;
            default: next_state = IDLE;
        endcase
    end
    
    always @(*) begin
        case (state)
            IDLE:       begin
                ACREADY = 0;
                CRVALID = 0;
                CRRESP = 0;
                CDVALID = 0;
                CDLAST = 0;
                
                state_tag_w_en = 0;
                control_offset = 4'b0000;
                bus_in_reg_en = 1;
            end
            AC_ADDR:       begin
                ACREADY = 1;
                CRVALID = 0;
                CRRESP = 0;
                CDVALID = 0;
                CDLAST = 0;
                
                state_tag_w_en = 0;
                control_offset = 4'b0000;
                bus_in_reg_en = 1;
            end
            HIT_MISS:       begin
                ACREADY = 0;
                CRVALID = 0;
                CRRESP = 0;
                CDVALID = 0;
                CDLAST = 0;
                
                state_tag_w_en = 0;
                control_offset = 4'b0000;
                bus_in_reg_en = 0;
            end
            CR_RESP:       begin
                ACREADY = 0;
                CRVALID = 1;
                CRRESP = (!hit || (ACSNOOP == 4'b1101)) ? {hit & is_exclusive, 1'b0, /*hit & is_dirty*/ 1'b0, 1'b0, 1'b0} : ((ACSNOOP == 4'b0001 || ACSNOOP == 4'b0111) ? {hit & is_exclusive, 1'b1, hit & is_dirty, 1'b0, 1'b1} : 5'b00000);
                CDVALID = 0;
                CDLAST = 0;
                
                state_tag_w_en = (hit && (ACSNOOP == 4'b1101)) ? 1 : 0;
                control_offset = 4'b0000;
                bus_in_reg_en = 0;
            end
            CD_DATA:       begin
                ACREADY = 0;
                CRVALID = 0;
                CRRESP = 0;
                CDVALID = 1;
                CDLAST = sent_word_cnt == 4'b1111;
                
                state_tag_w_en = CDLAST;
                control_offset = sent_word_cnt + 1;
                bus_in_reg_en = 0;
            end
            default:    begin
                ACREADY = 0;
                CRVALID = 0;
                CRRESP = 0;
                CDVALID = 0;
                CDLAST = 0;
                
                state_tag_w_en = 0;
                control_offset = 4'b0000;
                bus_in_reg_en = 1;
            end
        endcase
    end
    
    always @(posedge ACLK) begin
        if (!ARESETn) begin
            sent_word_cnt <= 4'b0000;
        end
        else begin
            if (next_state != state) begin
                sent_word_cnt <= 4'b0000;
            end
            else begin
                if (CDREADY) begin
                    sent_word_cnt <= sent_word_cnt + 4'b0001;
                end
            end
        end
    end
    
endmodule
