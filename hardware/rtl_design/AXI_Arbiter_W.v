//=============================================================================
// This is an Arbiter for Write Transactions using Round Robin Algorithm for two Master
//=============================================================================

`timescale 1ns/1ns

module AXI_Arbiter_W (
    /********* System signals *********/
	input                       ACLK,
	input      	                ARESETn,
	/********** Master 0 **********/
    input                       m0_AWVALID,
    input                       m0_WVALID,
    input                       m0_BREADY,
	/********** Master 1 **********/
    input                       m1_AWVALID,
    input                       m1_WVALID,
    input                       m1_BREADY,
    /********** Master 2 **********/
    input                       m2_AWVALID,
    input                       m2_WVALID,
    input                       m2_BREADY,
	/********** Master 3 **********/
    input                       m3_AWVALID,
    input                       m3_WVALID,
    input                       m3_BREADY,
    /********** Slave **********/
    input                       s_AWREADY,
    input                       s_WREADY,
    input                       s_BVALID,
    
    output reg                  m0_wgrnt,
	output reg	                m1_wgrnt,
	output reg	                m2_wgrnt,
	output reg	                m3_wgrnt
);

    // state define
    parameter AXI_MASTER_0 = 0;
    parameter AXI_MASTER_1 = 1;
    parameter AXI_MASTER_2 = 2;
    parameter AXI_MASTER_3 = 3;
    
    reg [1:0] state, next_state;

    //---------------------------------------------------------
    always @(*) begin
        case (state)
            AXI_MASTER_0: begin                 // 0 --> 1, 2, 3
                if(m0_AWVALID)                  
                    next_state = AXI_MASTER_0;  
                else if(m0_WVALID/*||s_WREADY*/)    
                    next_state = AXI_MASTER_0;  
                else if(s_BVALID&&m0_BREADY)    
                    next_state = AXI_MASTER_1;  
                else if(m1_AWVALID)             
                    next_state = AXI_MASTER_1;
                else if(m2_AWVALID)             
                    next_state = AXI_MASTER_2;  
                else if(m3_AWVALID)             
                    next_state = AXI_MASTER_3; 
                else                            
                    next_state = AXI_MASTER_0;  
            end
            AXI_MASTER_1: begin                 // 1 --> 2, 3, 0
                if(m1_AWVALID)                  
                    next_state = AXI_MASTER_1;
                else if(m1_WVALID/*||s_WREADY*/)
                    next_state = AXI_MASTER_1;
                else if(s_BVALID&&m1_BREADY)
                    next_state = AXI_MASTER_2;
                else if(m2_AWVALID)
                    next_state = AXI_MASTER_2;
                else if(m3_AWVALID)
                    next_state = AXI_MASTER_3;
                else if(m0_AWVALID)
                    next_state = AXI_MASTER_0;
                else
                    next_state = AXI_MASTER_1;
            end
            AXI_MASTER_2: begin                 // 2 --> 3, 0, 1
                if(m2_AWVALID)                  
                    next_state = AXI_MASTER_2;
                else if(m2_WVALID/*||s_WREADY*/)
                    next_state = AXI_MASTER_2;
                else if(s_BVALID&&m2_BREADY)
                    next_state = AXI_MASTER_3;
                else if(m3_AWVALID)
                    next_state = AXI_MASTER_3;
                else if(m0_AWVALID)
                    next_state = AXI_MASTER_0;
                else if(m1_AWVALID)
                    next_state = AXI_MASTER_1;
                else
                    next_state = AXI_MASTER_2;
            end
            AXI_MASTER_3: begin                 // 3 --> 0, 1, 2
                if(m3_AWVALID)                  
                    next_state = AXI_MASTER_3;
                else if(m3_WVALID/*||s_WREADY*/)
                    next_state = AXI_MASTER_3;
                else if(s_BVALID&&m3_BREADY)
                    next_state = AXI_MASTER_0;
                else if(m0_AWVALID)
                    next_state = AXI_MASTER_0;
                else if(m1_AWVALID)
                    next_state = AXI_MASTER_1;
                else if(m2_AWVALID)
                    next_state = AXI_MASTER_2;
                else
                    next_state = AXI_MASTER_3;
            end
            default:
                next_state = AXI_MASTER_0;      
        endcase
    end


    //---------------------------------------------------------
    always @(posedge ACLK)begin
        if(!ARESETn)
            state <= AXI_MASTER_0;        
        else
            state <= next_state;
    end

    //---------------------------------------------------------
    always @(*) begin
        case (state)
            AXI_MASTER_0: {m0_wgrnt,m1_wgrnt,m2_wgrnt,m3_wgrnt} = 4'b1000;
            AXI_MASTER_1: {m0_wgrnt,m1_wgrnt,m2_wgrnt,m3_wgrnt} = 4'b0100;
            AXI_MASTER_2: {m0_wgrnt,m1_wgrnt,m2_wgrnt,m3_wgrnt} = 4'b0010;
            AXI_MASTER_3: {m0_wgrnt,m1_wgrnt,m2_wgrnt,m3_wgrnt} = 4'b0001;
            default:      {m0_wgrnt,m1_wgrnt,m2_wgrnt,m3_wgrnt} = 4'b0000;
        endcase
    end

endmodule