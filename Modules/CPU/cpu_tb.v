`timescale 1ns / 1ps

module cpu_tb;

    // Testbench signals
    reg clk;
	 wire clk0, clk2;
    reg rst;
    wire [31:0] instruction, address;
    wire [31:0] Ra_rf, Rb_rf;
    wire [31:0] pc;
    wire M1, M2, M3, M4, M5, M6, M7, Wr_en, Eq;
    wire [3:0] ALU;
    wire [31:0] mux5_out0, mux4_out0, mux6_out, mux7_out;

    // Clock generation
    initial begin
        clk = 0;
        forever #10 clk = ~clk;  // Toggle clock every 5 ns (100 MHz clock)
    end

    // Reset generation
    initial begin
        rst = 0;
        #15 rst = 1;  // Deassert reset after 15 ns
    end

    // Instantiate CPU
    // Testbench instantiation of CPU
cpu uut (
    .clk(clk),
	 .clk0(clk0),
	 .clk2(clk2),
    .rst(rst),
	 .address(address),
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
    .mux5_out0(mux5_out0),
    .mux4_out0(mux4_out0),
    .mux7_out(mux7_out)
);

	 
    // Simulation control
    initial begin
        // Run the simulation for a certain period
        #1500;


    end

    // Monitor to observe changes
    initial begin
        $monitor("Time=%0t | PC=%h | Ra_rf=%h | Rb_rf=%h | ALU=%h | Mux5=%h | Mux4=%h | Mux7=%h",
                 $time, pc, Ra_rf, Rb_rf, ALU, mux5_out0, mux4_out0, mux7_out);
    end

endmodule
