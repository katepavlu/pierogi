module register_file (
    input clk,                       // Clock signal
    input rst_n,                     // Synchronized active-low reset
    input [3:0] read_Ra,             // Address for the first read port
    input [3:0] read_Rb,             // Address for the second read port
    input [3:0] write_Rd,            // Address for the write port
    input [31:0] write_data,         // Data to write
    output reg [31:0] data_Ra,       // Data from the first read port
    output reg [31:0] data_Rb        // Data from the second read port
);

    // 16 registers, each 32 bits wide
    reg [31:0] registers [15:0];

    // Declare the integer for the loop outside the always block
    integer i;

    // Initialize all registers to 0 at the start of the simulation
    initial begin
        for (i = 0; i < 16; i = i + 1) begin
            registers[i] <= 32'b0;
        end
    end

    // Read operations
    always @(*) begin
        data_Ra <= registers[read_Ra];
        data_Rb <= registers[read_Rb];
    end

    // Write operation with synchronized active-low reset
    always @(negedge clk) begin
        if (!rst_n) begin
            // Reset all registers to 0 when rst_n is low
            for (i = 0; i < 16; i = i + 1) begin
                registers[i] <= 32'b0;
            end
        end 
        // Write data to the specified register
        registers[write_Rd] <= write_data;
		  registers[0] = 32'b0;
    end

endmodule