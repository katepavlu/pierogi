module ALU();

input [3:0] AluOp  // 4-bit opcode
input [31:0] busA  // 32-bit input
input [31:0] busB // 32-bit input
output [31:0] outBus // 32-bit output


output reg Overflow,       // 1-bit overflow output


); 

    always @(*) begin
        Overflow = 0; // Default overflow to 0
     

		case (AluOp)
				4'b0000: Result = busA & busB; // AND operation
				4'b0001: Result = busA | busB; // or operation
				4'b0010: Result = busA ^ busB; // XOR operation
				4'b0011: Result = busA ~ busB; // NOT operation
				4'b0100: Result = busA + busB; // ADD operation
				4'b0101: Result = busA - busB; // SUB operation
				4'b0110: Result =	(busA < busB) ? 4'b001 : 4'b000; // Compare (A < B)
				4'b1010: Result =		; // SL operation
				4'b1011: Result =		; // SR operation
				4'b1101: Result =		; // LUI operation
				
endmodule