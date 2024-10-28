module ALU(
    input [3:0] AluOp,         // 4-bit opcode
    input [31:0] busA,         // 32-bit input A
    input [31:0] busB,         // 32-bit input B
  
    output reg [31:0] outBus,  // 32-bit output
    output reg Overflow        // 1-bit overflow flag
);

    always @(*) begin
        // Default values
        Overflow = 0;
        outBus = 32'b0;

        case (AluOp)
            4'b0000: outBus = busA & busB;        // AND operation
            4'b0001: outBus = busA | busB;        // OR operation
            4'b0010: outBus = busA ^ busB;        // XOR operation
            4'b0011: outBus = ~busA;              // NOT operation
            4'b0100: begin                        // ADD operation
                {Overflow, outBus} = busA + busB; // Detect overflow
            end
            4'b0101: begin                        // SUB operation
                {Overflow, outBus} = busA - busB; // Detect overflow
            end
            4'b0110: outBus = (busA < busB) ? 32'b1 : 32'b0;  // Compare (A < B)
            4'b1010: outBus = busA << busB[4:0];               // Shift left by imm
            4'b1011: outBus = busA >> busB[4:0];               // Shift right by imm
            4'b1101: outBus = busB << 16;                      // Load upper immediate (LUI)
            default: outBus = 32'b0;                          // Default case (NOP)
        endcase
    end

endmodule
