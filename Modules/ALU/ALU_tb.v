module alu_tb;

    // Inputs to the ALU
    reg [3:0] AluOp;
    reg [31:0] busA;
    reg [31:0] busB;
    reg [15:0] imm;

    // Outputs from the ALU
    wire [31:0] outBus;
    wire Overflow;

    // Instantiate the ALU
    ALU uut (
        .AluOp(AluOp),
        .busA(busA),
        .busB(busB),
        .imm(imm),
        .outBus(outBus),
        .Overflow(Overflow)
    );

    // Test stimulus
    initial begin
        // Monitor signals
        $monitor("Time: %0d, AluOp: %b, busA: %h, busB: %h, imm: %h, outBus: %h, Overflow: %b",
                 $time, AluOp, busA, busB, imm, outBus, Overflow);
                 
        // Initialize inputs to 16 for busA and busB, immediate to 4
        busA = 32'h10;  // Set busA to 16 (0x10)
        busB = 32'h10;  // Set busB to 16 (0x10)
        imm = 16'h0004; // Set imm to 4 (0x4)

        // Test AND operation (AluOp = 0000)
        AluOp = 4'b0000;
        #10;
        
        // Test OR operation (AluOp = 0001)
        AluOp = 4'b0001;
        #10;
        
        // Test XOR operation (AluOp = 0010)
        AluOp = 4'b0010;
        #10;
        
        // Test NOT operation (AluOp = 0011)
        AluOp = 4'b0011;
        #10;

        // Test ADD operation (AluOp = 0100)
        AluOp = 4'b0100;
        #10;

        // Test SUB operation (AluOp = 0101)
        AluOp = 4'b0101;
        #10;
        
        // Test Compare (AluOp = 0110)
        AluOp = 4'b0110;
        #10;
        
        // Test Shift Left (AluOp = 1010)
        AluOp = 4'b1010;
        imm = 16'h0004; // Shift left by 4
        #10;

        // Test Shift Right (AluOp = 1011)
        AluOp = 4'b1011;
        imm = 16'h0004; // Shift right by 4
        #10;

        // Test LUI (AluOp = 1101)
        AluOp = 4'b1101;
        imm = 16'h0004; // Load upper immediate with 4
        #10;

        // Finish simulation
        $finish;
    end

endmodule
