module peripherals(
	output wire [6:0]HEX0,
	output wire [6:0]HEX1,
	output wire [6:0]HEX2,
	output wire [6:0]HEX3,
	output wire [6:0]HEX4,
	output wire [6:0]HEX5,
	output wire [35:0]GPIO_0,
	input wire [1:0]KEY);
	
	reg signed [31:0]data_out;
	
	// copy the pin assignments from here
	display_peripheral dp0(
		.din(data_out),
		.hex0(HEX0),
		.hex1(HEX1),
		.hex2(HEX2),
		.hex3(HEX3),
		.hex4(HEX4),
		.hex5(HEX5),
		.hex6(GPIO_0[6:0]),
		.hex7(GPIO_0[13:7]),
		.hex8(GPIO_0[20:14]),
		.hex9(GPIO_0[27:21]),
		.hex10(GPIO_0[34:28]),
		.dot(GPIO_0[35])
	);
	
	// a simple dummy program
	initial begin
		data_out <= 32'h7fff_fff0;
	end
	
	always @(posedge KEY[0]) begin
		data_out <= data_out + 1;
	end
	
endmodule