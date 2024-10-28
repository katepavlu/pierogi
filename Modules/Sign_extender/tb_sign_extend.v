`timescale 1ns / 1ps

module tb_sign_extend;
    // Inputs
    reg [15:0] immediate;

    // Outputs
    wire [31:0] immediate_extended;

    // Instantiate the sign_extender module
    sign_extend uut (
        .immediate(immediate),
        .extended_immediate(immediate_extended)
    );

    initial begin
        // Test case 1: Positive number
        immediate = 16'b0000_0000_0000_1010; // 10 in decimal
        #10;
        $display("Immediate: %b, Extended: %b", immediate, immediate_extended);

        // Test case 2: Negative number
        immediate = 16'b1111_1111_1111_1010; // -6 in 16-bit signed
        #10;
        $display("Immediate: %b, Extended: %b", immediate, immediate_extended);

        // Test case 3: Maximum positive 16-bit number
        immediate = 16'b0111_1111_1111_1111; // 32767 in decimal
        #10;
        $display("Immediate: %b, Extended: %b", immediate, immediate_extended);

        // Test case 4: Minimum negative 16-bit number
        immediate = 16'b1000_0000_0000_0000; // -32768 in decimal
        #10;
        $display("Immediate: %b, Extended: %b", immediate, immediate_extended);

        $stop;
    end
endmodule