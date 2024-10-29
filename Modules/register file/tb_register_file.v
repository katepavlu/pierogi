`timescale 1ns / 1ps

module tb_register_file;

    // Testbench signals
    reg clk;
    reg rst_n;
    reg [3:0] read_Ra;
    reg [3:0] read_Rb;
    reg [3:0] write_Rd;
    reg [31:0] write_data;
    wire [31:0] data_Ra;
    wire [31:0] data_Rb;

    // Instantiate the register file module
    register_file uut (
        .clk(clk),
        .rst_n(rst_n),
        .read_Ra(read_Ra),
        .read_Rb(read_Rb),
        .write_Rd(write_Rd),
        .write_data(write_data),
        .data_Ra(data_Ra),
        .data_Rb(data_Rb)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns clock period
    end

    // Test procedure
    initial begin
	 
			rst_n = 0;
			read_Ra = 4'd2;
        // Test case 1: Apply reset
        rst_n = 0; // Activate reset
        #10;
        rst_n = 1; // Deactivate reset
        #10;

        // Test case 2: Write to register 5
        write_Rd = 4'd5;
        write_data = 32'hA5A5A5A5;
        #10;

        // Test case 3: Disable write and read from register 5
        read_Ra = 4'd5;
        #10;
        $display("Read data from register 5: %h", data_Ra);

        // Test case 4: Write to register 10
        write_Rd = 4'd10;
        write_data = 32'h5A5A5A5A;
        #10;

        // Test case 5: Read from register 5 and register 10
        read_Ra = 4'd5;
        read_Rb = 4'd10;
        #10;
        $display("Read data from register 5: %h", data_Ra);
        $display("Read data from register 10: %h", data_Rb);

        // Test case 6: Re-apply reset and check if all registers are reset
        rst_n = 0; // Activate reset
        #10;
        rst_n = 1; // Deactivate reset
        #10;

        read_Ra = 4'd5;
        read_Rb = 4'd10;
        #10;
        $display("Read data from register 5 after reset: %h", data_Ra);
        $display("Read data from register 10 after reset: %h", data_Rb);

        $stop;
    end

endmodule
