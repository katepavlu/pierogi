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
    wire [31:0] mux3_out, mux4_out1, mux5_out1, mux6_out;

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
        instruction = {4'b1100, 4'b0001, 4'b0010, 4'b0011, 16'h0001}; // ADDI Rd = Ra + Imm
        #10;
        
        // Test instruction 2: ADDI Rd, Ra, Imm (example opcode 4'b1100 for ADDI)
        instruction = {4'b1100, 4'b0010, 4'b0010, 4'b0011, 16'h0002}; // ADDI Rd = Ra + Imm
        #10;
        
        // Test instruction 3: ADD Rd, Ra, Rb (example opcode 4'b0100 for ADD)
        instruction = {4'b0100, 4'b0011, 4'b0010, 4'b0001, 16'h0000}; // ADD Rd = Ra + Rb
        #10;
        
        // Test instruction 4: SUB Ra, Rb, Rd (example opcode 4'b0101 for SUB)
        instruction = {4'b0101, 4'b0100, 4'b0010, 4'b0011, 16'h0000}; // SUB Rd = Ra - Rb
        #10;
        
        // Test instruction 5: BEQ Ra, Rb (example opcode 4'b1000 for BEQ)
        instruction = {4'b1000, 4'b0001, 4'b0010, 4'b0000, 16'h0000}; // BEQ if Ra == Rb
        #10;
        
        // Test instruction 6: LUI Rd, imm (example opcode 4'b1101 for LUI)
        instruction = {4'b1101, 4'b0011, 4'b0000, 4'b0000, 16'hFFFF}; // LUI Rd = imm << 16
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
