module ClockDivider(input clk, output reg clkd);

	reg [31:0]ctr;

	initial clkd = 0;
	initial ctr = 0;
	
	reg clk2;
	initial clk2 = 0;
	
	always @(posedge clk) clk2 = ~clk2;
	
	always @(posedge clk2)
	begin
		if(ctr<25_000)
			ctr <= ctr+1;
		else begin
			ctr <= 0;
			clkd <= !clkd;
		end
	end

endmodule

module peripherals(
	output wire [6:0]HEX0,
	output wire [6:0]HEX1,
	output wire [6:0]HEX2,
	output wire [6:0]HEX3,
	output wire [6:0]HEX4,
	output wire [6:0]HEX5,
	output wire [35:0]GPIO_0,
	
	inout wire [35:0]GPIO_1,	
	input wire CLOCK_50,
	
	input wire [1:0]KEY);
	
	wire signed [31:0]data_out;
	
	wire clkd;
	
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
	
	keypad_peripheral kp0(
		.cols(GPIO_1[35:32]),
		.rows(GPIO_1[31:28]),
		.clk(clkd),
		.out(data_out)
	);
	
	ClockDivider ckd0(
		.clk(CLOCK_50),
		.clkd(clkd),
	);
	
/*	// a simple dummy program
	initial begin
		data_out <= 32'h7fff_fff0;
	end
	
	always @(posedge KEY[0]) begin
		data_out <= data_out + 1;
	end
*/
endmodule