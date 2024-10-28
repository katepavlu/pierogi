module sdram_controller (
    input            clk,        // System clock
    input            reset,      // Asynchronous reset
    input            we,         // Write enable
    input  [23:0]    addr,       // Address bus (24-bit for 64MB)
    input  [15:0]    data_in,    // Data input (16-bit)
    output reg [15:0] data_out,  // Data output (16-bit)

    // SDRAM interface
    output reg [12:0] DRAM_ADDR, // SDRAM address bus
    inout  [15:0]    DRAM_DQ,    // SDRAM data bus
    output reg       DRAM_WE_N,  // SDRAM Write Enable
    output reg       DRAM_CAS_N, // SDRAM Column Address Strobe
    output reg       DRAM_RAS_N, // SDRAM Row Address Strobe
    output reg       DRAM_CS_N,  // SDRAM Chip Select
    output           DRAM_CLK    // SDRAM Clock
);

    // State encoding for FSM using parameter (standard Verilog)
    parameter IDLE             = 4'b0000;
    parameter INIT_DELAY       = 4'b0001;
    parameter PRECHARGE_ALL    = 4'b0010;
    parameter AUTO_REFRESH1    = 4'b0011;
    parameter AUTO_REFRESH2    = 4'b0100;
    parameter LOAD_MODE_REGISTER = 4'b0101;
    parameter READY            = 4'b0110;
    parameter WRITE            = 4'b0111;
    parameter READ             = 4'b1000;
    
    reg [3:0] state, next_state;
    
    reg [15:0] data_buffer;      // Buffer to hold data to be written
    reg data_direction;          // 0 = Read, 1 = Write
    reg [15:0] refresh_counter;  // Counter for refresh and delay
    reg [9:0]  init_delay_count; // Counter for initialization delay

    // Assign SDRAM clock to the system clock
    assign DRAM_CLK = clk;

    // Tri-state buffer for data lines
    assign DRAM_DQ = (data_direction) ? data_buffer : 16'bz;

    // State transition
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (!reset) begin
                    next_state = INIT_DELAY;
                end
            end
            INIT_DELAY: begin
                if (init_delay_count == 10'd1000) begin // Simulating 100us delay
                    next_state = PRECHARGE_ALL;
                end
            end
            PRECHARGE_ALL: begin
                next_state = AUTO_REFRESH1;
            end
            AUTO_REFRESH1: begin
                next_state = AUTO_REFRESH2;
            end
            AUTO_REFRESH2: begin
                next_state = LOAD_MODE_REGISTER;
            end
            LOAD_MODE_REGISTER: begin
                next_state = READY;
            end
            READY: begin
                // Wait for read or write command
                if (we) begin
                    next_state = WRITE;
                end else begin
                    next_state = READ;
                end
            end
            WRITE: begin
                next_state = READY;
            end
            READ: begin
                next_state = READY;
            end
        endcase
    end

    // State output and control signals
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Reset all control signals
            DRAM_ADDR  <= 13'b0;
            DRAM_WE_N  <= 1'b1;
            DRAM_CAS_N <= 1'b1;
            DRAM_RAS_N <= 1'b1;
            DRAM_CS_N  <= 1'b1;
            data_direction <= 0;
            init_delay_count <= 10'd0;
        end else begin
            // Default outputs
            DRAM_CS_N  <= 1'b0;
            DRAM_WE_N  <= 1'b1;
            DRAM_CAS_N <= 1'b1;
            DRAM_RAS_N <= 1'b1;
            
            case (state)
                INIT_DELAY: begin
                    // Increment delay counter
                    init_delay_count <= init_delay_count + 1;
                end
                PRECHARGE_ALL: begin
                    // Issue Precharge All command
                    DRAM_RAS_N <= 1'b0;
                    DRAM_CAS_N <= 1'b1;
                    DRAM_WE_N  <= 1'b0;
                    DRAM_ADDR  <= 13'b0100000000000; // Precharge all banks
                end
                AUTO_REFRESH1: begin
                    // Issue first Auto-Refresh command
                    DRAM_RAS_N <= 1'b0;
                    DRAM_CAS_N <= 1'b0;
                    DRAM_WE_N  <= 1'b1;
                end
                AUTO_REFRESH2: begin
                    // Issue second Auto-Refresh command
                    DRAM_RAS_N <= 1'b0;
                    DRAM_CAS_N <= 1'b0;
                    DRAM_WE_N  <= 1'b1;
                end
                LOAD_MODE_REGISTER: begin
                    // Configure Mode Register
                    DRAM_RAS_N <= 1'b0;
                    DRAM_CAS_N <= 1'b0;
                    DRAM_WE_N  <= 1'b0;
                    DRAM_ADDR  <= 13'b0000011000111; // Example mode settings
                end
                WRITE: begin
                    data_direction <= 1; // Set to write
                    DRAM_RAS_N <= 1'b0;
                    DRAM_CAS_N <= 1'b0;
                    DRAM_WE_N  <= 1'b0;
                    DRAM_ADDR  <= addr[12:0]; // Write address
                    data_buffer <= data_in;
                end
                READ: begin
                    data_direction <= 0; // Set to read
                    DRAM_RAS_N <= 1'b0;
                    DRAM_CAS_N <= 1'b0;
                    DRAM_WE_N  <= 1'b1;
                    DRAM_ADDR  <= addr[12:0]; // Read address
                    data_out <= DRAM_DQ;
                end
                READY: begin
                    // Do nothing, wait for commands
                end
            endcase
        end
    end
endmodule