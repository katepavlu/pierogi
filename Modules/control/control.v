module control(
	input wire [3:0] opcode,
	input wire Eq, 
	output reg M1, 
	output reg M2,
	output reg M3, 
	output reg M4,
	output reg M5, 
	output reg M6,
	output reg M7, 
	output reg [3:0] ALU,
	output reg Wr_en
	);
	
	initial begin
    M1 = 1'b0;
    M2 = 1'b0;
    M3 = 1'b0;
    M4 = 1'b0;
    M5 = 1'b0;
    M6 = 1'b0;
    M7 = 1'b0;
    ALU = 4'b0000;
    Wr_en = 1'b0;
end
		
	always @(opcode or Eq) begin
		case (opcode)
			4'b0000: begin // and
				M1 = 1'b0;
				M2 = 1'b0;
				M4 = 1'b1;
				M6 = 1'b0;
				ALU = 4'b0000;
				M3 = M1;
				M5 = M4;
				M7 = M4;
			end
			4'b0001: begin // or
				M1 = 1'b0;
				M2 = 1'b0;
				M4 = 1'b1;
				M6 = 1'b0;
				ALU = 4'b0001;
				M3 = M1;
				M5 = M4;
				M7 = M4;
			end
			4'b0010: begin // xor
				M1 = 1'b0;
				M2 = 1'b0;
				M4 = 1'b1;
				M6 = 1'b0;
				ALU = 4'b0010;
				M3 = M1;
				M5 = M4;
				M7 = M4;
			end
			4'b0011: begin // not
				M1 = 1'b0;
				M2 = 1'b0;
				M4 = 1'b1;
				ALU = 4'b0011;
				M3 = M1;
				M5 = M4;
				M7 = M4;
			end
			4'b0100: begin // add
				M1 = 1'b0;
				M2 = 1'b0;
				M4 = 1'b1;
				M6 = 1'b0;
				ALU = 4'b0100;
				M3 = M1;
				M5 = M4;
				M7 = M4;
			end
			4'b0101: begin // sub
				M1 = 1'b0;
				M2 = 1'b0;
				M4 = 1'b1;
				M6 = 1'b0;
				ALU = 4'b0101;
				M3 = M1;
				M5 = M4;
				M7 = M4;
			end
			4'b0110: begin // cmp
				M1 = 1'b0;
				M2 = 1'b0;
				M4 = 1'b1;
				M6 = 1'b0;
				ALU = 4'b0110;
				M3 = M1;
				M5 = M4;
				M7 = M4;
			end
			4'b0111: begin // j
				M1 = 1'b1;
				M2 = 1'b1;
				M3 = M1;
				Wr_en = 1'b0;
			end
			4'b1000: begin // beq
				M1 = 1'b0;
				M2 = Eq;
				Wr_en = 1'b0;
				M3 = M1;
			end
			4'b1001: begin // bne
				M1 = 1'b0;
				M2 = ~Eq;
				Wr_en = 1'b0;
				M3 = M1;
			end
			4'b1010: begin // sl
				M1 = 1'b0;
				M2 = 1'b0;
				M4 = 1'b1;
				M6 = 1'b1;
				ALU = 4'b1010;
				M3 = M1;
				M5 = M4;
				M7 = M4;
			end
			4'b1011: begin // sr
				M1 = 1'b0;
				M2 = 1'b0;
				M4 = 1'b1;
				M6 = 1'b1;
				ALU = 4'b1011;
				M3 = M1;
				M5 = M4;
				M7 = M4;
			end
			4'b1100: begin // addi
				M1 = 1'b0;
				M2 = 1'b0;
				M4 = 1'b1;
				M6 = 1'b1;
				ALU = 4'b0100;
				M3 = M1;
				M5 = M4;
				M7 = M4;
			end
			4'b1101: begin // lui
				M1 = 1'b0;
				M2 = 1'b0;
				M4 = 1'b1;
				M6 = 1'b1;
				ALU = 4'b1101;
				M3 = M1;
				M5 = M4;
				M7 = M4;
			end
			4'b1110: begin // lw
				M1 = 1'b0;
				M2 = 1'b0;
				M4 = 1'b0;
				Wr_en = 1'b1;
				M3 = M1;
				M5 = M4;
				M7 = M4;
			end
			4'b1111: begin // sw
				Wr_en = 1'b1;
				M1 = 1'b0;
				M2 = 1'b0;
				M4 = 1'b0;
				M3 = M1;
				M5 = M4;
				M7 = M4;
			end
		endcase
	end
endmodule
