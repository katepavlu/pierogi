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
	input wire [3:0] address,
	input wire din,
	input wire writeEnable,
	output reg dout
);

	reg display_din;           // Internal register to hold display data
	wire keyboard_dout;        // Output from the keypad_peripheral module
	
	// Use an always block to control the dout and display_din based on address
	always @(posedge clk) begin
		dout = 0;  // Default dout to 0 unless overridden
		
		case (address)
			4'h0: begin
				// Read operation: output keyboard_dout when address is 0
				dout = keyboard_dout;
			end
			4'h4: begin
				// Write operation: update display_din when address is 4 and writeEnable is high
				if (writeEnable) 
					display_din = din;
			end
		endcase
	end
	
	// Instantiate the display and keypad peripherals
	display_peripheral dp0(
		.din(display_din),       // Connect display_din to the display module input
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
		.cols(cols),             // Connect the columns to cols
		.rows(rows),             // Connect rows to the keypad peripheral's row outputs
		.clk(clk),               // Use clk for the keypad peripheral clock
		.filtered_out(keyboard_dout)      // Connect keyboard_dout to get the keypad output
	);

endmodule