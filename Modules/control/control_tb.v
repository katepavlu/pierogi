`timescale 1ns / 1ps

module control_tb;
    // Inputs
    reg clk;
    reg reset;
    reg [3:0] opcode;
    reg Eq;

    // Outputs
    wire M13, M2, M457, M6;
    wire pc_flag, instruction_flag, change_address_flag;
    wire Wr_en_rf, state, Wr_en;
    wire [3:0] ALU;

    // Instantiate the control module
    control uut (
        .clk(clk),
        .reset(reset),
        .opcode(opcode),
        .Eq(Eq),
        .M13(M13),
        .M2(M2),
        .M457(M457),
        .M6(M6),
        .pc_flag(pc_flag),
        .instruction_flag(instruction_flag),
        .change_address_flag(change_address_flag),
        .Wr_en_rf(Wr_en_rf),
        .state(state),
        .ALU(ALU),
        .Wr_en(Wr_en)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // 10ns clock period
    end

    // Test sequence
    initial begin
        // Initialize inputs
        reset = 1;
        opcode = 4'b0000;
        Eq = 0;

        // Apply reset
        #10 reset = 0;
        #10 reset = 1;  // Release reset

        // Test each opcode with some delay in between
        #10 opcode = 4'b0000; // AND
        #10 opcode = 4'b0001; // OR
        #10 opcode = 4'b0010; // XOR
        #10 opcode = 4'b0011; // NOT
        #10 opcode = 4'b0100; // ADD
        #10 opcode = 4'b0101; // SUB
        #10 opcode = 4'b0110; // CMP
        #10 opcode = 4'b0111; // J
        #10 opcode = 4'b1000; Eq = 1; // BEQ with Eq=1
        #10 opcode = 4'b1000; Eq = 0; // BEQ with Eq=0
        #10 opcode = 4'b1001; Eq = 1; // BNE with Eq=1
        #10 opcode = 4'b1001; Eq = 0; // BNE with Eq=0
        #10 opcode = 4'b1010; // SL
        #10 opcode = 4'b1011; // SR
        #10 opcode = 4'b1100; // ADDI
        #10 opcode = 4'b1101; // LUI
        #10 opcode = 4'b1110; // LW
        #10 opcode = 4'b1111; // SW
        #10

        // Finish the simulation
        $stop;
    end
endmodule
