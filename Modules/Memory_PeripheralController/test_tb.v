`timescale 1ns/1ps

module test_tb;

    reg [31:0] dataInVirt;
    reg [31:0] addressVirt;
    reg wEnVirt, rstVirt, clk;
    wire [31:0] dataOutVirt;

    // Instantiate the Top module
    memory_integrated uut (
        .dataInVirt(dataInVirt),
        .addressVirt(addressVirt),
        .wEnVirt(wEnVirt),
        .rstVirt(rstVirt),
        .clk(clk),
        .dataOutVirt(dataOutVirt)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100MHz clock
    end

    // Test sequence
    initial begin
        // Initialize inputs
        addressVirt = 32'h0000_0000; // Address within text segment
        
		  #10
		  
        rstVirt = 0;

        // Reset sequence
        #10 rstVirt = 1;
		  dataInVirt = 32'h0000_0001;
        
		  wEnVirt = 1;
        // Test writing to text segment
        #10 addressVirt = 32'h0000_0000; // VIRT_TEXT_START
        dataInVirt = 32'hA5A5_A5A5;
        wEnVirt = 1;

        #10 addressVirt = 32'h0FFF_FFFF; // VIRT_TEXT_END
        dataInVirt = 32'h5A5A_5A5A;
        wEnVirt = 1;

        // Test writing to data segment
        #10 addressVirt = 32'h1000_0000; // VIRT_DS_START
        dataInVirt = 32'h1234_5678;
        wEnVirt = 1;

        #10 addressVirt = 32'h7FFF_FFFF; // VIRT_DS_END
        dataInVirt = 32'h8765_4321;
        wEnVirt = 1;

        // Test writing to IO segment
        #10 addressVirt = 32'hFFFF_0000; // VIRT_IO_START
        dataInVirt = 32'hDEAD_BEEF;
        wEnVirt = 1;

        #10 addressVirt = 32'hFFFF_FFFF; // VIRT_IO_END
        dataInVirt = 32'hBEEF_DEAD;
        wEnVirt = 1;

        // Test read from text segment
        #10 addressVirt = 32'h0000_0000; // VIRT_TEXT_START
        wEnVirt = 0;

        #10 addressVirt = 32'h0FFF_FFFF; // VIRT_TEXT_END
        wEnVirt = 0;

        // End of test
        #10 $stop;
    end
endmodule
