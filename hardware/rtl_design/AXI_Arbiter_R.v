//=============================================================================
// This is an Arbiter for Read Transactions using Round Robin Algorithm for two Master
//=============================================================================

`timescale 1ns/1ns

module AXI_Arbiter_R (
    /********* System signals *********/
	input                       ACLK,
	input      	                ARESETn,
	/********** Master 0 **********/
    input                       m0_ARVALID,
    input                       m0_RREADY,
	/********** Master 1 **********/
    input                       m1_ARVALID,
    input                       m1_RREADY,
    /********** Master 2 **********/
    input                       m2_ARVALID,
    input                       m2_RREADY,
	/********** Master 3 **********/
    input                       m3_ARVALID,
    input                       m3_RREADY,
	/********** Slave **********/
    input                       s_RVALID,
    input                       s_RLAST,
	
    output reg                  m0_rgrnt,
	output reg	                m1_rgrnt,
	output reg	                m2_rgrnt,
	output reg	                m3_rgrnt
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
                if(m0_ARVALID)                  
                    next_state = AXI_MASTER_0;  
                else if(s_RVALID||m0_RREADY)    
                    next_state = AXI_MASTER_0;  
                else if(s_RLAST&&s_RVALID)      
                    next_state = AXI_MASTER_1;  
                else if(m1_ARVALID)             
                    next_state = AXI_MASTER_1;  
                else if(m2_ARVALID)             
                    next_state = AXI_MASTER_2;
                else if(m3_ARVALID)             
                    next_state = AXI_MASTER_3;
                else                            
                    next_state = AXI_MASTER_0;  
            end
            AXI_MASTER_1: begin                 // 1 --> 2, 3, 0
                if(m1_ARVALID)                  
                    next_state = AXI_MASTER_1;
                else if(s_RVALID||m1_RREADY)
                    next_state = AXI_MASTER_1;
                else if(s_RLAST&&s_RVALID)
                    next_state = AXI_MASTER_2;
                else if(m2_ARVALID)             
                    next_state = AXI_MASTER_2;
                else if(m3_ARVALID)             
                    next_state = AXI_MASTER_3;
                else if(m0_ARVALID)
                    next_state = AXI_MASTER_0;
                else
                    next_state = AXI_MASTER_1;
            end
            AXI_MASTER_2: begin                 // 2 --> 3, 0, 1
                if(m2_ARVALID)                  
                    next_state = AXI_MASTER_2;
                else if(s_RVALID||m2_RREADY)
                    next_state = AXI_MASTER_2;
                else if(s_RLAST&&s_RVALID)
                    next_state = AXI_MASTER_3;
                else if(m3_ARVALID)             
                    next_state = AXI_MASTER_3;
                else if(m0_ARVALID)             
                    next_state = AXI_MASTER_0;
                else if(m1_ARVALID)
                    next_state = AXI_MASTER_1;
                else
                    next_state = AXI_MASTER_2;
            end
            AXI_MASTER_3: begin                 // 3 --> 0, 1, 2
                if(m3_ARVALID)                  
                    next_state = AXI_MASTER_3;
                else if(s_RVALID||m3_RREADY)
                    next_state = AXI_MASTER_3;
                else if(s_RLAST&&s_RVALID)
                    next_state = AXI_MASTER_0;
                else if(m0_ARVALID)             
                    next_state = AXI_MASTER_0;
                else if(m1_ARVALID)             
                    next_state = AXI_MASTER_1;
                else if(m2_ARVALID)
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
    always @(*)begin
        case (state)
            AXI_MASTER_0: {m0_rgrnt,m1_rgrnt,m2_rgrnt,m3_rgrnt} = 4'b1000;
            AXI_MASTER_1: {m0_rgrnt,m1_rgrnt,m2_rgrnt,m3_rgrnt} = 4'b0100;
            AXI_MASTER_2: {m0_rgrnt,m1_rgrnt,m2_rgrnt,m3_rgrnt} = 4'b0010;
            AXI_MASTER_3: {m0_rgrnt,m1_rgrnt,m2_rgrnt,m3_rgrnt} = 4'b0001;
            default:      {m0_rgrnt,m1_rgrnt,m2_rgrnt,m3_rgrnt} = 4'b0000;
        endcase
    end

endmodule