`timescale 1ns / 1ps

module test_tb();

    // Declare inputs as reg type
    reg [31:0] dataInVirt;
    reg [31:0] addressVirt;
    reg wEnVirt;
    reg rstVirt;
    reg clk;

    // Declare outputs as wire type
    wire [31:0] dataOutVirt;
    wire [6:0] hex0, hex1, hex2, hex3, hex4, hex5, hex6, hex7, hex8, hex9, hex10;
    wire dot;
    wire [35:0] GPIO_0;
    wire [3:0] rows;
    reg [3:0] cols;

    // Instantiate the memory_integrated module
    memory_integrated uut (
        .dataInVirt(dataInVirt),
        .addressVirt(addressVirt),
        .wEnVirt(wEnVirt),
        .rstVirt(rstVirt),
        .clk(clk),
        .dataOutVirt(dataOutVirt),
        .hex0(hex0),
        .hex1(hex1),
        .hex2(hex2),
        .hex3(hex3),
        .hex4(hex4),
        .hex5(hex5),
        .hex6(hex6),
        .hex7(hex7),
        .hex8(hex8),
        .hex9(hex9),
        .hex10(hex10),
        .dot(dot),
        .GPIO_0(GPIO_0),
        .GPIO_1(GPIO_1),
        .rows(rows),
        .cols(cols)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns clock period
    end

    // Test sequence
    initial begin
        // Initialize inputs
        dataInVirt = 32'hA5A5A5A5;
        addressVirt = 32'h00000000; // Starting with TEXT segment
        wEnVirt = 0;
        rstVirt = 1;
        cols = 4'b0000;

        // Reset pulse
        #10;
        rstVirt = 0;

        // Test writing to TEXT segment
        #10;
        dataInVirt = 32'h11111111;
        addressVirt = 32'h00000010; // TEXT segment
        wEnVirt = 1;
        #10;
        wEnVirt = 0;

        // Read back from TEXT segment
        #10;
        addressVirt = 32'h00000010;
        #10;
        $display("TEXT Segment - DataOutVirt: %h (Expected: 11111111)", dataOutVirt);

        // Test writing to DS segment
        #10;
        dataInVirt = 32'h22222222;
        addressVirt = 32'h10000020; // DS segment
        wEnVirt = 1;
        #10;
        wEnVirt = 0;

        // Read back from DS segment
        #10;
        addressVirt = 32'h10000020;
        #10;
        $display("DS Segment - DataOutVirt: %h (Expected: 22222222)", dataOutVirt);

        // Test writing to IO segment
        #10;
        dataInVirt = 32'h33333333;
        addressVirt = 32'hFFFF0004; // IO segment
        wEnVirt = 1;
        #10;
        wEnVirt = 0;

        // Read back from IO segment
        #10;
        addressVirt = 32'hFFFF0004;
        #10;
        $display("IO Segment - DataOutVirt: %h (Expected: 33333333)", dataOutVirt);

        // Additional test cases can be added as needed for further address space coverage
        
        // End of test
        #50;
        $stop;
    end

endmodule
