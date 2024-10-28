module decoder(
	input wire [31:0] in,
	input control,
	output reg [31:0] out0,
	output reg[31:0] out1
	);
	
	always @(*) begin
		if (control == 1'b0) begin
			out0 = in;
			out1 = 32'b0;
		end else begin
			out0 = 32'b0;
			out1 = in;
			end
	end
endmodule
		