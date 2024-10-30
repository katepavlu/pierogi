
module BRAM(
		input wire [31:0]addr,
		input wire [31:0]din,
		input wire clk,
		input wire wren,
		output wire [31:0] dout
	);

	ram_IP	ram_IP_inst (
		.address ( addr[12:2] ),
		.clock ( clk ),
		.data ( din ),
		.wren ( wren ),
		.q ( dout )
		);

endmodule