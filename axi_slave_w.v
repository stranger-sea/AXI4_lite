module axi_slave_w(
  
    input clk,            
    input rst_n,
  
    output reg wr_en,          
    output reg [31:0] wr_addr, 
    output reg [31:0] wr_data, 
    
    input awvalid,   
    output reg awready,        
    input [31:0] awaddr, 

    input wvalid,    
    output reg wready,         
    input [31:0] wdata,  
    input [3:0] wstrb,   

    input bready,    
    output reg bvalid,        
    output reg [1:0] bresp     
);

localparam IDLE          = 2'b00;
localparam W_ADDR_PHASE  = 2'b01;
localparam W_DATA_PHASE  = 2'b10;
localparam W_RESP_PHASE  = 2'b11;

reg [1:0] present_state;
reg [1:0] next_state;

//PRESENT STATE RESET LOGIC
  
always @(posedge clk or negedge rst_n) 
begin
    if (!rst_n) begin
        present_state <= IDLE;
    end else begin
        present_state <= next_state;
    end
end
  
//NEXT STATE LOGIC
  
always @(*) 
begin
    case (present_state)
        IDLE: begin
          if (awvalid) begin
                next_state = W_ADDR_PHASE;
            end else begin
                next_state = IDLE;
            end
        end

        W_ADDR_PHASE: begin
          if (awvalid && awready) begin
                next_state = W_DATA_PHASE;
            end else begin
                next_state = W_ADDR_PHASE;
            end
        end

        W_DATA_PHASE: begin
          if (wvalid && wready) begin
                next_state = W_RESP_PHASE;
            end else begin
                next_state = W_DATA_PHASE;
            end
        end

        W_RESP_PHASE: begin
          if (bready && bvalid) begin
                next_state = IDLE;
            end else begin
                next_state = W_RESP_PHASE;
            end
        end
      
        default: next_state = IDLE;
      
    endcase
end
  
  
//OUTPUT 
  
always @(*) begin
  
    awready = 0;
    wr_addr = 32'd0;
    wr_en = 0;
    wr_data = 32'd0;
    wready = 0;
    bvalid = 0;
	bresp = 0;
    case (present_state)
        IDLE: begin
         
              end
     

        W_ADDR_PHASE: begin
          	awready = 1;
          if (awvalid) begin
            	wr_en = 1;
              	wr_addr = awaddr;

            end
        end

        W_DATA_PHASE: begin
          	wready = 1;
          if (wvalid) begin
                wr_data = wdata;
				wr_en = 1;
                end
        end

        W_RESP_PHASE: begin
          	bvalid = 1;
          if (bready) begin
   				bresp = 2'b00;
       		        end
        end
    endcase
end
  
endmodule
