module decoder_tb;

    // Testbench signals
    reg [31:0] in;
    reg control;
    wire [31:0] out0;
    wire [31:0] out1;

    // Instantiate the decoder module
    decoder uut (
        .in(in),
        .control(control),
        .out0(out0),
        .out1(out1)
    );

    // Testbench procedure
    initial begin
        // Monitor the signals to observe changes
        $monitor("time=%0t | in=%h | control=%b | out0=%h | out1=%h", 
                  $time, in, control, out0, out1);
        
        // Initialize input signals
        in = 32'hAAAA5555;
        control = 1'b0;
        
        // Test case 1: control = 0
        #10;
        control = 1'b0;   // Expect out0 = in, out1 = 0

        // Test case 2: control = 1
        #10;
        control = 1'b1;   // Expect out0 = 0, out1 = in

        // Test case 3: change input while control is 0
        #10;
        control = 1'b0;
        in = 32'h12345678; // Expect out0 = in, out1 = 0

        // Test case 4: change input while control is 1
        #10;
        control = 1'b1;
        in = 32'h87654321; // Expect out0 = 0, out1 = in

        // End simulation
        #10;
        $finish;
    end
endmodule
