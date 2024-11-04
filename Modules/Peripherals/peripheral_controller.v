module peripheral_controller(
	output wire [6:0] hex0,
	output wire [6:0] hex1,
	output wire [6:0] hex2,
	output wire [6:0] hex3,
	output wire [6:0] hex4,
	output wire [6:0] hex5,
	output wire [6:0] hex6,
	output wire [6:0] hex7,
	output wire [6:0] hex8,
	output wire [6:0] hex9,
	output wire [6:0] hex10,
	output wire dot,
	
	output wire [3:0] rows,
	input wire [3:0] cols,
	
	input wire clk,
	input wire reset,           // Added reset signal
	input wire [3:0] address,
	input wire [31:0] din,
	input wire writeEnable,
	output reg [31:0] dout
);
 
	reg [31:0] display_din;
	wire [7:0] keyboard_dout;
	// dummy signal
	wire [7:0] dummy_filtered_out;
	
	always @(posedge clk) begin
		if (reset) begin
			// Reset internal registers to default values
			dout <= 8'b0;
			display_din <= 32'b0;
		end else begin
			dout <= 8'b0;  // Default dout to 0 unless overridden
			
			case (address)
				4'h0: begin
					// Replace dummy with keyboard_dout if you are done simulating
					dout <= dummy_filtered_out;
				end
				4'h4: begin
					if (writeEnable) 
						display_din <= din;
				end
			endcase
		end
	end
	
	// Instantiate the display and keypad peripherals
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
		.filtered_out(keyboard_dout)
	);

	// dummy_keypad module
	dummy_keypad u_dummy_keypad (
		.clk(clk),                  
		.dummy_out(dummy_filtered_out)
	);
	
endmodule
