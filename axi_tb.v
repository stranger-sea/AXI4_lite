module axi_top_tb;

	reg clk;
	reg rst_n;
	reg cpu_wr_en;
	reg [31:0] cpu_wr_addr;
	reg [31:0] cpu_wr_data;

	reg cpu_rd_en;
	reg [31:0] cpu_rd_addr;
	wire [31:0] cpu_rd_data;

	
	wire mem_wr_en;
	wire [31:0] mem_wr_addr;
	wire [31:0] mem_wr_data;

	wire mem_rd_en;
	wire [31:0] mem_rd_addr;
	reg [31:0] mem_rd_data;

	axi_top uut(.clk(clk),
		.rst_n(rst_n),
		.cpu_wr_en(cpu_wr_en),
		.cpu_wr_addr(cpu_wr_addr),
		.cpu_wr_data(cpu_wr_data),
		.cpu_rd_en(cpu_rd_en),
		.cpu_rd_addr(cpu_rd_addr),
		.cpu_rd_data(cpu_rd_data),
		.mem_wr_en(mem_wr_en),
    		.mem_wr_addr(mem_wr_addr),
		.mem_wr_data(mem_wr_data),
		.mem_rd_en(mem_rd_en),
		.mem_rd_addr(mem_rd_addr),
		.mem_rd_data(mem_rd_data)
	);

	//clock generation
	always #10 clk = ~clk;

		initial begin
			clk = 0;
			rst_n = 0;
			cpu_wr_en = 0;
			cpu_wr_addr = 32'h00000000;
			cpu_wr_data = 32'h00000000;
			cpu_rd_en = 0;
			cpu_rd_addr = 32'h00000000;
			mem_rd_data = 32'h00000000;
		end

		initial begin
			#10;
			rst_n = 1;

			#10;
			cpu_wr_en = 1;
			cpu_wr_addr = 32'h02020202;
			cpu_wr_data = 32'h00001111;

			#100;
			cpu_wr_en = 0;
			cpu_wr_addr = 32'h00000000;
			cpu_wr_data = 32'h00000000;

			#10;
			mem_rd_data = 32'h00001111;
			cpu_rd_en = 1;
			cpu_rd_addr = 32'h02020202;
			
			#100;
			cpu_rd_en = 0;
			cpu_rd_addr = 32'h00000000;

		end

		initial begin
			$shm_open("wave.shm");
			$shm_probe("ACTMF");
			#250;
			$finish;
		end

		endmodule
			












