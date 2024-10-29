module cpu(
    input clk,
    input rst,
    input wire [31:0] instruction
);

reg [31:0] PC;

// Instead of memory
wire [31:0] Din, Address;

// Initialize opcode, registers.
wire [3:0] opcode, Ra, Rb, Rd;
wire [15:0] imm;
wire [31:0] extended_imm;

parameter PC_count = 32'd4;

// Control signals
wire M1, M2, M3, M4, M5, M6, M7, Wr_en, Eq;
wire [3:0] ALU;

// Instruction decoding
assign opcode = instruction[31:28];
assign Rd = instruction[27:24];
assign Ra = instruction[23:20];
assign Rb = instruction[19:16];
assign imm = instruction[15:0];

// Mux outputs
wire [31:0] mux1_out, mux2_out, mux3_out, mux6_out, mux7_out, adder_out, ALU_out;
// Mux inputs
wire [31:0] mux4_out0, mux4_out1, mux5_out0, mux5_out1;

wire [31:0] Ra_rf, Rb_rf;
initial begin
    PC = 32'b0;
end

// Equality check
assign Eq = (Ra_rf == Rb_rf) ? 1'b1 : 1'b0;


// Adder instance
adder add (
    .a(PC),
    .b(mux2_out),
    .out(adder_out)
);

// Register file instance
register_file RF (
    .clk(clk),
    .rst_n(rst),
    .read_Ra(Ra),
    .read_Rb(Rb),
    .write_Rd(mux3_out),
    .write_data(mux7_out),
    .data_Ra(Ra_rf),
    .data_Rb(Rb_rf)
);

// Control unit instance
control ctrl (
    .opcode(opcode),
    .Eq(Eq),
    .M1(M1),
    .M2(M2),
    .M3(M3),
    .M4(M4),
    .M5(M5),
    .M6(M6),
    .M7(M7),
    .ALU(ALU),
    .Wr_en(Wr_en)
);

// Sign extension instance
sign_extend extend (
    .immediate(imm),
    .extended_immediate(extended_imm)
);

// Multiplexer instances
mux mux1 (
    .in0(adder_out),
    .in1(mux2_out),
    .control(M1),
    .out(mux1_out)
);

mux mux2 (
    .in0(PC_count),
    .in1(extended_imm),
    .control(M2),
    .out(mux2_out)
);

mux mux3 (
    .in0(Rd),
    .in1(PC),
    .control(M3),
    .out(mux3_out)
);

mux mux6 (
    .in0(mux4_out0),
    .in1(extended_imm),
    .control(M6),
    .out(mux6_out)
);

mux mux7 (
    .in0(mux5_out0),
    .in1(ALU_out),
    .control(M7),
    .out(mux7_out)
);

// Decoder instances
decoder mux4 (
    .in(Rb_rf),
    .control(M4),
    .out0(mux4_out0),
    .out1(mux5_out1)
);

decoder mux5 (
    .in(Ra_rf),
    .control(M5),
    .out0(mux5_out0),
    .out1(mux5_out1)
);

// ALU instance
ALU alu (
    .AluOp(ALU),
    .busA(mux5_out1),
    .busB(mux6_out),
    .outBus(ALU_out)
);

endmodule