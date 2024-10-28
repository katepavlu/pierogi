`timescale 1ns / 1ps

module cpu_tb;
    // Testbench signals
    reg clk;
    reg rst;
    reg [31:0] instruction;
    
    // Instantiate the cpu module
    cpu uut (
        .clk(clk),
        .rst(rst),
        .instruction(instruction)
    );
    
    // Clock generation
    always #5 clk = ~clk;  // 10 ns period (100 MHz)
    
    // Initial setup
    initial begin
        // Initialize signals
        clk = 0;
        rst = 1;
        instruction = 32'b0;
        
        // Apply reset
        #10;
        rst = 0;  // Release reset after 10 ns
        
        // Test instruction 1: ADD Ra, Rb, Rd (example opcode 4'b0100 for ADD)
        instruction = {4'b0100, 4'b0001, 4'b0010, 4'b0011, 16'h0000}; // ADD Rd = Ra + Rb
        #10;
        
        // Test instruction 2: SUB Ra, Rb, Rd (example opcode 4'b0101 for SUB)
        instruction = {4'b0101, 4'b0001, 4'b0010, 4'b0011, 16'h0000}; // SUB Rd = Ra - Rb
        #10;
        
        // Test instruction 3: BEQ Ra, Rb (example opcode 4'b1000 for BEQ)
        instruction = {4'b1000, 4'b0001, 4'b0010, 4'b0000, 16'h0000}; // BEQ if Ra == Rb
        #10;
        
        // Test instruction 4: LUI Rd, imm (example opcode 4'b1101 for LUI)
        instruction = {4'b1101, 4'b0011, 4'b0000, 4'b0000, 16'hFFFF}; // LUI Rd = imm << 16
        #10;
        
        // Additional test instructions can be added here...
        
        // Finish simulation
        #20;
        $finish;
    end
    
    // Monitor signals
    initial begin
        $monitor("Time=%0t | Reset=%b | Instruction=%h | PC=%h", 
                 $time, rst, instruction, uut.PC);
    end
endmodule
