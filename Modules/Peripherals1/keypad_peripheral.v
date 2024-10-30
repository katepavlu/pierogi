module keypad_peripheral(
	output reg [3:0] cols,
	input wire [3:0] rows,
	input clk,
	output reg [7:0] out);
	
	parameter _4 = 4'b0001;
	parameter _3 = 4'b0010;
	parameter _2 = 4'b0100;
	parameter _1 = 4'b1000;
	
	reg [7:0] c1;
	reg [7:0] c2;
	reg [7:0] c3;
	reg [7:0] c4;
	
	initial begin
		cols <= _1;
		out <= 0;
	end
	
	always @(posedge clk) begin
		case(cols)
			_1: begin 
				case (rows)
					_1: c1 <= 8'd49;
					_2: c1 <= 8'd52;
					_3: c1 <= 8'd55;
					_4: c1 <= 8'd42;
					default: c1 <= 0;
				endcase
				cols <= _2;
			end
			_2: begin
				case (rows)
					_1: c2 <= 8'd50;
					_2: c2 <= 8'd53;
					_3: c2 <= 8'd56;
					_4: c2 <= 8'd48;
					default: c2 <= 0;
				endcase
				cols <= _3;
			end
			_3:begin
				case (rows)
					_1: c3 <= 8'd51;
					_2: c3 <= 8'd54;
					_3: c3 <= 8'd57;
					_4: c3 <= 8'd35;
					default: c3 <= 0;
				endcase
				cols <= _4;
			end
			_4:begin
				case (rows)
					_1: c4 <= 8'd65;
					_2: c4 <= 8'd66;
					_3: c4 <= 8'd67;
					_4: c4 <= 8'd68;
					default: c4 <= 0;
				endcase
				cols <= _1;
			end
			default:begin
				cols <= _1;
			end
		endcase
		
		if(c1 != 0 && c2 == 0 && c3 == 0 && c4 == 0) out <= c1;
		else if(c1 == 0 && c2 != 0 && c3 == 0 && c4 == 0) out <= c2;
		else if(c1 == 0 && c2 == 0 && c3 != 0 && c4 == 0) out <= c3;
		else if(c1 == 0 && c2 == 0 && c3 == 0 && c4 != 0) out <= c4;
		else out <= 0;
	end
endmodule