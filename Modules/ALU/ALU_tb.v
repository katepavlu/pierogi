`timescale 1ns / 1ps

module ALU_tb;

    // Inputs
    reg [3:0] AluOp;
    reg [31:0] busA;
    reg [31:0] busB;

    // Outputs
    wire [31:0] outBus;

    // Instantiate the ALU module
    ALU uut (
        .AluOp(AluOp),
        .busA(busA),
        .busB(busB),
        .outBus(outBus)
    );

    // Task to display results
    task display_result;
        begin
            $display("Time=%0t | AluOp=%b | busA=%d | busB=%d | outBus=%d",
                     $time, AluOp, busA, busB, outBus);
        end
    endtask

    initial begin
        // Initialize Inputs
        AluOp = 4'b0000;
        busA = 32'd0;
        busB = 32'd0;

        // Wait for global reset
        #10;

        // -------------------------------------
        // 1. Test AND operation (AluOp = 0000)
        // -------------------------------------
        AluOp = 4'b0000;
        busA = 4;   // 0100
        busB = 3;   // 0011
        #10;
        display_result(); // Expected outBus = 0

        // -------------------------------------
        // 2. Test OR operation (AluOp = 0001)
        // -------------------------------------
        AluOp = 4'b0001;
        busA = 4;   // 0100
        busB = 3;   // 0011
        #10;
        display_result(); // Expected outBus = 7

        // -------------------------------------
        // 3. Test XOR operation (AluOp = 0010)
        // -------------------------------------
        AluOp = 4'b0010;
        busA = 5;   // 0101
        busB = 3;   // 0011
        #10;
        display_result(); // Expected outBus = 6

        // -------------------------------------
        // 4. Test NOT operation (AluOp = 0011)
        // -------------------------------------
        AluOp = 4'b0011;
        busA = 1;   // 0001
        busB = 0;   // Ignored
        #10;
        display_result(); // Expected outBus = ~1 = 4294967294

        // -------------------------------------
        // 5. Test ADD operation without overflow (AluOp = 0100)
        // -------------------------------------
        AluOp = 4'b0100;
        busA = 10;
        busB = 15;
        #10;
        display_result(); // Expected outBus = 25

        // -------------------------------------
        // 6. Test ADD operation with potential overflow (AluOp = 0100)
        // Note: Overflow is not flagged in this version
        // -------------------------------------
        AluOp = 4'b0100;
        busA = 2147483647; // Max positive for 32-bit signed
        busB = 1;
        #10;
        display_result(); // Expected outBus = -2147483648 (due to wrap-around)

        // -------------------------------------
        // 7. Test SUB operation without overflow (AluOp = 0101)
        // -------------------------------------
        AluOp = 4'b0101;
        busA = 20;
        busB = 5;
        #10;
        display_result(); // Expected outBus = 15

        // -------------------------------------
        // 8. Test SUB operation with potential overflow (AluOp = 0101)
        // Note: Overflow is not flagged in this version
        // -------------------------------------
        AluOp = 4'b0101;
        busA = -2147483648; // Min negative for 32-bit signed
        busB = 1;
        #10;
        display_result(); // Expected outBus = 2147483647 (due to wrap-around)

        // -------------------------------------
        // 9. Test Compare (A < B) operation (AluOp = 0110)
        // -------------------------------------
        AluOp = 4'b0110;
        busA = 5;
        busB = 10;
        #10;
        display_result(); // Expected outBus = 1

        AluOp = 4'b0110;
        busA = 15;
        busB = 10;
        #10;
        display_result(); // Expected outBus = 0

        // -------------------------------------
        // 10. Test Shift Left operation (AluOp = 1010)
        // -------------------------------------
        AluOp = 4'b1010;
        busA = 1;   // 0001
        busB = 2;   // Shift left by 2
        #10;
        display_result(); // Expected outBus = 4

        // -------------------------------------
        // 11. Test Shift Right operation (AluOp = 1011)
        // -------------------------------------
        AluOp = 4'b1011;
        busA = 8;   // 1000
        busB = 3;   // Shift right by 3
        #10;
        display_result(); // Expected outBus = 1

        // -------------------------------------
        // 12. Test Load Upper Immediate (LUI) operation (AluOp = 1101)
        // -------------------------------------
        AluOp = 4'b1101;
        busA = 0;   // Ignored
        busB = 1;   // Load 1 into upper 16 bits
        #10;
        display_result(); // Expected outBus = 65536

        // -------------------------------------
        // 13. Test Default case (NOP)
        // -------------------------------------
        AluOp = 4'b1111; // Undefined opcode
        busA = 123;
        busB = 456;
        #10;
        display_result(); // Expected outBus = 0

        // Finish simulation
        $finish;
    end

endmodule
