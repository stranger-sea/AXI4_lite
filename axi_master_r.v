module axi_master_r(clk, rst_n, rd_en, rd_addr, rd_data, arvalid, arready, araddr, rvalid, rready, rdata, rresp);

input  clk;
input  rst_n;
input  rd_en;
input  [31:0] rd_addr;
output reg [31:0] rd_data;

output reg arvalid;
input  arready;
output reg [31:0] araddr;

input rvalid;
output reg rready;
input [31:0] rdata;
output reg [1:0] rresp;


localparam [1:0] idle = 2'b00;
localparam [1:0] r_addr_phase = 2'b01;
localparam [1:0] r_data_phase = 2'b10;


reg [1:0] present_state, next_state;


//present state logic
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n) begin
		present_state <= idle;
	end else begin
		present_state <= next_state;
end
end

//state transition logic 
always@(*) begin 
	case(present_state)
	idle:	 if(rd_en) begin
		next_state = r_addr_phase;
		end else begin
	next_state = idle;
		end

	r_addr_phase: if(arready) begin
		next_state = r_data_phase;
		end else begin
		next_state = r_addr_phase;
		end

	r_data_phase: if(rvalid) begin
		next_state = idle;
		end else begin
		next_state = r_data_phase;
		end
	default:next_state = idle;
	endcase
end

//output logic
always@(*) begin
	//default state
	arvalid = 1'b0;
	araddr = 32'h00000000;
	rready = 1'b0;
	rd_data = 32'h00000000;
		case(present_state)
		idle: begin
			//stay in default state
			end

		r_addr_phase: begin
			arvalid = 1'b1;
			if(arready) begin
			araddr = rd_addr;
			end
		end
		
		r_data_phase: begin
		rready = 1'b1;
		if(rvalid) begin
		rd_data = rdata;
		rresp = 2'b0;	
		end
		end
endcase
end

endmodule
