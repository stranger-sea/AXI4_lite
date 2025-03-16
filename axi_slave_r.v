module axi_slave_r (clk, rst_n, arvalid, araddr, arready, rvalid, rdata, rresp, rready, rd_en, rd_addr, rd_data);
	
	input wire clk;
	input wire rst_n;	
	input wire arvalid;
	input wire [31:0] araddr;
	output reg arready;
	
	output reg rd_en;
	output reg [31:0] rd_addr;
	input wire [31:0] rd_data;

	output reg rvalid; 
	output reg [31:0] rdata;
	output reg [1:0] rresp;
	input wire rready;

 	localparam [1:0] idle = 2'b00;
 	localparam [1:0] r_addr_phase = 2'b01;
 	localparam [1:0] r_data_phase = 2'b10;

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
			idle: begin
			if(arvalid) begin
				next_state = r_addr_phase;
			end else begin
				next_state = idle;
			end
			end
			
	
			r_addr_phase: begin
				if(arvalid && arready) begin
				next_state = r_data_phase;
				end else begin
				next_state = r_addr_phase;
			end
			end
			

			r_data_phase: begin
				if(rvalid && rready) begin
				next_state = idle;
				end else begin 
				next_state = r_data_phase;
			end
			end
		default:next_state = idle; 
	endcase
end

//output logic 
	always@(*) begin
		//default case
		arready = 0;
		rvalid = 0;
		rdata = 0;
		rd_en = 0;
		rd_addr = 0;
			
		case(present_state)
			idle: begin
			//stay in default state
			arready = 0;
			rvalid = 0;
			rdata = 0;
			rd_en = 0;
			rd_addr = 0;
			end
			
			r_addr_phase: begin
			arready = 1;
			rd_en = 1;
			rd_addr = araddr;
			end

			r_data_phase: begin
			rvalid = 1;
			if(rready) begin
			rdata = rd_data;
			rresp = 2'b00;
			end
			end
		default:present_state = idle;	
		endcase
	end

endmodule 	
