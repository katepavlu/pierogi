`timescale 1ns / 1ps

module tb_keypad_peripheral;

    // Testbench signals
    reg clk;
    reg [3:0] rows;
    wire [3:0] cols;
    wire [6:0] hex0;
    wire [6:0] hex1;

    // Instantiate the keypad_peripheral module
    keypad_peripheral uut (
        .cols(cols),
        .rows(rows),
        .clk(clk),
        .hex0(hex0),
        .hex1(hex1)
    );

    // Clock generation (10ns period for a 100MHz clock)
    initial clk = 0;
    always #5 clk = ~clk;

    // Task to simulate pressing a specific key
    task press_key;
        input [3:0] row;
        begin
            rows = row;            // Set the rows input to simulate a key press
            @(posedge clk);        // Wait for a clock edge
            rows = 4'b0000;        // Release the row after one clock cycle
        end
    endtask

    // Simulation control
    initial begin
        // Initialize inputs
        rows = 4'b0000;

        // Wait for reset and stabilization
        #100;

        // Press key '1' (Row 1, Col 1)
        press_key(4'b0001);  // Set row 1
        #500000;  // Wait for debounce duration

        // Press key '5' (Row 2, Col 2)
        press_key(4'b0010);  // Set row 2
        #500000;  // Wait for debounce duration

        // Press key 'A' (Row 1, Col 4)
        press_key(4'b0001);  // Set row 1
        #500000;  // Wait for debounce duration

        // Press key '0' (Row 4, Col 2)
        press_key(4'b1000);  // Set row 4
        #500000;  // Wait for debounce duration

        // End the simulation
        $stop;
    end

    // Monitor output
    initial begin
        $monitor("Time: %0t | Key pressed: %b%b%b%b | Hex0: %b | Hex1: %b", 
                 $time, rows, cols, hex0, hex1);
    end

endmodule
