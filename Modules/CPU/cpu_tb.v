`timescale 1ns / 1ps

module cpu_tb;

    // Testbench signals
    reg clk;
    reg rst;
    wire [1:0] state;
    wire [31:0] instruction, address;
    wire [31:0] Ra_rf, Rb_rf;
    wire [31:0] pc;
    wire M1, M2, M3, M4, M5, M6, M7, Wr_en, Eq, Wr_en_rf;
    wire [3:0] ALU;
    wire [31:0] mux5_out0, mux4_out0, mux7_out;

    // Clock generation
    initial begin
        clk = 0;
        forever #20 clk = ~clk;  // Toggle clock every 10 ns (50 MHz clock)
    end

    // Reset generation
    initial begin
        rst = 0;
        #15 rst = 1;  // Deassert reset after 15 ns
    end

    // Instantiate CPU
     cpu uut(
    .CLOCK_50(clk), // 50 MHz
    .KEY(rst),
    .instruction(instruction), .address(address),
    .pc(pc),
    .state(state),
    .M1(M1), .M2(M2), .M3(M3), .M4(M4), .M5(M5), .M6(M6), .M7(M7),
    .Wr_en(Wr_en), .Eq(Eq), .pc_flag(pc_flag), .instruction_flag(instruction_flag),
    .change_address_flag(change_address_flag), .Wr_en_rf(Wr_en_rf),
    .ALU(ALU),
    .mux7_out(mux7_out)   
    );

    // Simulation control
    initial begin
        // Run the simulation for a certain period
        #1500;
        $stop;   // End the simulation after 2500 ns
    end

    // Monitor to observe changes
    initial begin
    $monitor("Time=%0t | PC=%h | Address=%h | Instruction=%h",
             $time, pc, address, instruction);
end


endmodule
