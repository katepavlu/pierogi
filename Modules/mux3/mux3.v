module mux3 (
    input wire [3:0] in0,      // 32-bit input 0
    input wire [31:0] in1,      // 32-bit input 1
    input wire control,         // Single-bit selector
    output reg [31:0] out       // 32-bit output
);

    always @(*) begin
        if (control == 1'b0)
            out = in0;
        else
            out = in1;
    end

endmodule
