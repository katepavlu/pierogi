module bram_memory #(
    parameter DATA_WIDTH = 8,             // Width of the data bus
    parameter ADDR_WIDTH = 10             // Width of the address bus
)(
    input wire clk,                       // Clock input
    input wire rst,                       // Reset input
    input wire we,                        // Write enable
    input wire [ADDR_WIDTH-1:0] addr,     // Address input
    input wire [DATA_WIDTH-1:0] din,      // Data input
    output reg [DATA_WIDTH-1:0] dout      // Data output
);

    // Declare the memory array
    reg [DATA_WIDTH-1:0] mem [0:(1<<ADDR_WIDTH)-1];

    // Memory read/write operations
    always @(posedge clk) begin
        if (rst) begin
            // Optionally reset memory contents
            // You can uncomment the following loop to reset memory
            // integer i;
            // for (i = 0; i < (1<<ADDR_WIDTH); i = i + 1) begin
            //     mem[i] <= {DATA_WIDTH{1'b0}};
            // end
            dout <= {DATA_WIDTH{1'b0}};
        end else begin
            if (we) begin
                mem[addr] <= din;         // Write operation
            end
            dout <= mem[addr];            // Read operation
        end
    end

endmodule