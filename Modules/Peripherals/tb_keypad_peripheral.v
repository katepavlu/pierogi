`timescale 1ns / 1ps

module tb_keypad_peripheral;
    reg clk;
    reg [3:0] rows;
    wire [3:0] cols;
    wire [7:0] filtered_out;
    
    // Instantiate the keypad peripheral module
    keypad_peripheral uut (
        .cols(cols),
        .rows(rows),
        .clk(clk),
        .filtered_out(filtered_out)
    );
    
    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // 100 MHz clock
    end
    
    // Test stimulus
    initial begin
        // Initialize inputs
        rows = 4'b0000;

        // Wait for a few clock cycles
        #100;

        // Simulate pressing each key one by one in sequence
        // Press key '1' (Row 1, Column 1)
        rows = 4'b1000;  // Row 1 active
        #20;
        rows = 4'b0000;  // Release key
        #100;

        // Press key '2' (Row 1, Column 2)
        rows = 4'b1000;  // Row 1 active
        #20;
        rows = 4'b0000;  // Release key
        #100;

        // Press key '3' (Row 1, Column 3)
        rows = 4'b1000;  // Row 1 active
        #20;
        rows = 4'b0000;  // Release key
        #100;

        // Press key '4' (Row 1, Column 4)
        rows = 4'b1000;  // Row 1 active
        #20;
        rows = 4'b0000;  // Release key
        #100;

        // Press key '5' (Row 2, Column 1)
        rows = 4'b0100;  // Row 2 active
        #20;
        rows = 4'b0000;  // Release key
        #100;

        // Additional key presses can be added here for thorough testing
        
        // End simulation
        $stop;
    end
    
    // Monitor the outputs
    initial begin
        $monitor("Time: %0t | Rows: %b | Cols: %b | Filtered Out: %d",
                 $time, rows, cols, filtered_out);
    end
endmodule
