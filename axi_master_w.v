module axi_master_w(clk, rst_n, wr_en, wr_addr, wr_data, awvalid, awready, awaddr, wvalid, wready, wdata, wstrb, bvalid, bready, bresp, b_err );

input clk;
input rst_n;
input wr_en;
input [31:0]wr_data;
input [31:0]wr_addr;

output reg awvalid;
input awready;
output reg [31:0]awaddr;

output reg wvalid;
input wready;
output reg [31:0]wdata; 
output reg [3:0] wstrb;

input bvalid;
output reg bready;
input [1:0]bresp;


localparam idle = 2'b00;
localparam w_addr_phase = 2'b01;
localparam w_data_phase = 2'b10;
localparam w_resp_phase = 2'b11;


reg [1:0] present_state, next_state;

//present state logic 
always@(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		present_state <= idle;
	end else begin
		present_state <= next_state;
	end
end 

//state transition logic 
always@(*) begin
	case(present_state)
	idle: 
		if(wr_en) begin
		next_state = w_addr_phase;
		end else begin
		next_state = idle;
		end

    	w_addr_phase: 
		if(awready) begin
		next_state = w_data_phase;
		end else begin
		next_state = w_addr_phase;
		end
 
	w_data_phase: 
		if(wready) begin
		next_state = w_resp_phase;
		end else begin
		next_state = w_data_phase;
		end

	w_resp_phase: 
		if(bvalid) begin
		next_state = idle;
		end else begin
		next_state = w_resp_phase;
		end
 
	default: next_state = idle;
		endcase 
	
end


//output logic 
always@(*) begin
	awvalid = 0;
	awaddr  = 32'h00000000;
	wvalid = 0;
	wdata = 32'h00000000;
	wstrb = 4'b0000;
	bready = 0;
	
	case(present_state)
	idle: begin
	//stay in default state 
	end

	w_addr_phase: begin
	awvalid = 1;
	awaddr = wr_addr;
	end

	w_data_phase: begin
	wvalid = 1;
	if(wready) begin
	wdata = wr_data;
	wstrb = 4'b1111;
	end 
	end

	w_resp_phase: begin
	bready = 1;
	if(bvalid) begin
	
	end
end
endcase
end

endmodule

