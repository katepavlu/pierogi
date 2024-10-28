module adder (
	input wire [31:0] a,
	input wire [31:0] b,
	output reg [31:0] out
	);
	
	wire [32:0]extended;
	assign extended = a + b;
	
	always @(*) begin
		out = extended[31:0];
	end
	
	endmodule
	
	
	