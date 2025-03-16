module axi_top(
	
	//cpu signals
	input clk,
	input rst_n,
	input cpu_wr_en,
	input [31:0] cpu_wr_addr,
	input [31:0] cpu_wr_data,

	input cpu_rd_en,
	input [31:0] cpu_rd_addr,
	output [31:0] cpu_rd_data,

	//memory signals
	output mem_wr_en,
	output [31:0] mem_wr_addr,
	output [31:0] mem_wr_data,

	output mem_rd_en,
	output [31:0] mem_rd_addr,
	input [31:0] mem_rd_data
);

	wire awvalid_w;
	wire awready_w;
	wire [31:0] awaddr_w;
	wire wvalid_w;
	wire wready_w;
	wire [31:0] wdata_w;
	wire [3:0] wstrb_w;
	wire bready_w;
	wire bvalid_w;
	wire [1:0] besp_w;

	wire arvalid_w;
        wire arready_w;
	wire [31:0] araddr_w;
	wire rready_w;	
	wire rvalid_w;
	wire [31:0] rdata_w;
	wire [1:0] rresp_w;


//module istantiation
	axi_master_w inst1(.clk(clk),
		.rst_n(rst_n),
		.wr_en(cpu_wr_en),
		.wr_addr(cpu_wr_addr),
		.wr_data(cpu_wr_data),
		.awvalid(awvalid_w),
		.awready(awready_w),
		.awaddr(awaddr_w),
		.wvalid(wvalid_w),
		.wready(wready_w),
		.wdata(wdata_w),
		.wstrb(wstrb_w),
		.bready(bready_w),
		.bvalid(bvalid_w),
		.bresp(bresp_w)		
	);

	axi_master_r inst2(.clk(clk),
		.rst_n(rst_n),
		.rd_en(cpu_rd_en),
		.rd_addr(cpu_rd_addr),
		.rd_data(cpu_rd_data),
		.arvalid(arvalid_w),
		.arready(arready_w),
		.araddr(araddr_w),		
		.rready(rready_w),
		.rvalid(rvalid_w),
		.rdata(rdata_w),
		.rresp(rresp_w)
	);

	axi_slave_w inst3(.clk(clk),
		.rst_n(rst_n),
		.wr_en(mem_wr_en),
		.wr_addr(mem_wr_addr),
		.wr_data(mem_wr_data),
		.awvalid(awvalid_w),
		.awready(awready_w),
		.awaddr(awaddr_w),
		.wvalid(wvalid_w),
		.wready(wready_w),
		.wdata(wdata_w),
		.wstrb(wstrb_w),
		.bready(bready_w),
		.bvalid(bvalid_w),
		.bresp(bresp_w)
	
	);

	axi_slave_r inst4(.clk(clk),
		.rst_n(rst_n),
		.rd_en(mem_rd_en),
		.rd_addr(mem_rd_addr),
		.rd_data(mem_rd_data),
		.arvalid(arvalid_w),
		.arready(arready_w),
		.araddr(araddr_w),
		.rvalid(rvalid_w),
		.rready(rready_w),
		.rdata(rdata_w),
		.rresp(rresp_w)
	);


endmodule

