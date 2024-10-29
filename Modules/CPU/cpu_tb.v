`timescale 1ns / 1ps

module cpu_tb;
    // Testbench signals
    reg clk;
    reg rst;
    reg [31:0] instruction;
    
    // Outputs from the CPU module
    wire [31:0] Ra_rf, Rb_rf;
    wire [31:0] pc;
    wire M1, M2, M3, M4, M5, M6, M7, Wr_en, Eq;
    wire [3:0] ALU;
	 wire [3:0] mux3_out;
    wire [31:0] mux4_out1, mux5_out1, mux6_out, ALU_out;

    // Instantiate the CPU module
    cpu uut (
        .clk(clk),
        .rst(rst),
        .instruction(instruction),
        .Ra_rf(Ra_rf),
        .Rb_rf(Rb_rf),
        .pc(pc),
        .M1(M1),
        .M2(M2),
        .M3(M3),
        .M4(M4),
        .M5(M5),
        .M6(M6),
        .M7(M7),
        .Wr_en(Wr_en),
        .Eq(Eq),
        .ALU(ALU),
		  .ALU_out(ALU_out),
        .mux3_out(mux3_out),
        .mux4_out1(mux4_out1),
        .mux5_out1(mux5_out1),
        .mux6_out(mux6_out)
    );
    
    // Clock generation
    always #5 clk = ~clk;  // 10 ns period (100 MHz)
    
    // Initial setup
    initial begin
        // Initialize signals
        clk = 0;
        rst = 0;
        instruction = 32'b0;
        
        // Apply reset
        #10;
        rst = 1;  // Release reset after 10 ns
        
        // Test instruction 1: ADDI Rd, Ra, Imm (example opcode 4'b1100 for ADDI)
        instruction = {4'b1100, 4'b0001, 4'b0010, 4'b0011, 16'h0001}; // ADDI Rd(nr2) = Ra(nr1 value 0) + Imm(1)
        #10;
        
        // Test instruction 2: ADDI Rd, Ra, Imm (example opcode 4'b1100 for ADDI)
        instruction = {4'b1100, 4'b0010, 4'b0010, 4'b0000, 16'h0002}; // ADDI Rd(nr2) = Ra(nr2 value0) + Imm(2)
        #10;
        
        // Test instruction 3: ADD Rd, Ra, Rb (example opcode 4'b0100 for ADD)
        instruction = {4'b0100, 4'b0011, 4'b0010, 4'b0001, 16'h0000}; // ADD Rd(nr3) = Ra(nr2 value 2) + Rb(nr1 value1)
        #10;
        
        // Test instruction 4: SUB Rd, Ra, Rb (example opcode 4'b0101 for SUB)
        instruction = {4'b0101, 4'b0100, 4'b0011, 4'b0010,  16'h0000}; // SUB Rd(nr4) = Ra(nr2 value2) - Rb(nr3 value3)
        #10;
        
        // Test instruction 5: BEQ Ra, Rb (example opcode 4'b1000 for BEQ)
        //instruction = {4'b1000, 4'b0000, 4'b0010, 4'b0001, 16'h0000}; // BEQ if Ra (nr2 value 2) == Rb(nr1 value1)
        //#10;
        
        // Test instruction 6: LUI Rd, imm (example opcode 4'b1101 for LUI)
        instruction = {4'b1101, 4'b0100, 4'b0000, 4'b0000, 16'b1}; // LUI Rd(nr4) = imm << 16
        #10;
		  
		  // Test instruction 7: AND Rd, Ra, Rb (example opcode 4'b0000 for AND)
        instruction = {4'b0000, 4'b1111, 4'b0101, 4'b0100, 16'b0}; // AND Rd(nr15) = Ra(nr5) and Rb(nr 4 value -1)
        #10;
		  
		  // Test instruction 8: Or Rd, Ra, Rb (example opcode 4'b0001 for OR)
        instruction = {4'b0001, 4'b1111, 4'b0101, 4'b0100, 16'b0}; // OR Rd(nr15) = Ra(nr5) or Rb(nr 4 value -1)
        #10;
		  
		  // Test instruction 9: Xor Rd, Ra, Rb (example opcode 4'b0000 for XOR)
        instruction = {4'b0010, 4'b1111, 4'b0101, 4'b0100, 16'b0}; // XOR Rd(nr15) = Ra(nr5) xor Rb(nr 4 value -1)
        #10;
		  
		  // Test instruction 10: Not Rd, Ra (example opcode 4'b0011 for NOT)
        instruction = {4'b0011, 4'b1111, 4'b0101, 4'b0000, 16'b0}; // NOT Rd(nr15) = not Ra(nr5)
        #10;
		  
		  // Test instruction 11: Or Rd, Ra, Rb (example opcode 4'b0100 for CMP)
        instruction = {4'b0110, 4'b1111, 4'b0101, 4'b0100, 16'b0}; // CMP Rd(nr15) = (Ra>Rb)
        #10;
		  
		  // Test instruction 12: SR Rd, Ra, Imm (example opcode 4'b0100 for NOT)
        instruction = {4'b1011, 4'b1111, 4'b0000, 4'b0000, 16'b11}; // SR Rd(nr15) = Ra >> Imm
        #10;
        
        // Finish simulation
        #20;
        $stop;
    end
    
    // Monitor signals
    initial begin
        $monitor("Time=%0t | Reset=%b | Instruction=%h | PC=%h | Ra_rf=%h | Rb_rf=%h | M1=%b | M2=%b | ALU=%h", 
                 $time, rst, instruction, pc, Ra_rf, Rb_rf, M1, M2, ALU);
    end
endmodule
