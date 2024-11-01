module peripheral_controller(
	output wire [7:0]hex0,
	output wire [7:0]hex1,
	output wire [7:0]hex2,
	output wire [7:0]hex3,
	output wire [7:0]hex4,
	output wire [7:0]hex5,
	output wire [7:0]hex6,
	output wire [7:0]hex7,
	output wire [7:0]hex8,
	output wire [7:0]hex9,
	output wire [7:0]hex10,
	output wire dot,
	
	output wire [3:0]rows,
	input wire [3:0]cols,
	
	input wire clk,
	input wire [1:0]address,
	input wire din,
	input wire writeEnable,
	output reg dout);
	
	reg display_din;
	wire keyboard_dout;
	
	always @(*) begin
	
		dout <= 0;
		
		case(address)
			2'h0: begin
				dout <= keyboard_dout;
			end
			2'h4: begin
				if (writeEnable == 1) display_din <= din;
			end
		endcase
		
	end
	
	display_peripheral dp0(
		.din(display_din),
		.hex0(hex0),
		.hex1(hex1),
		.hex2(hex2),
		.hex3(hex3),
		.hex4(hex4),
		.hex5(hex5),
		.hex6(hex6),
		.hex7(hex7),
		.hex8(hex8),
		.hex9(hex9),
		.hex10(hex10),
		.dot(dot)
	);
	
	keypad_peripheral kp0(
		.cols(cols),
		.rows(rows),
		.clk(clk),
		.out(keyboard_dout)
	);
	
endmodule