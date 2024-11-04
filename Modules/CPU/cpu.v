module cpu(
    input clk, // 50 MHz
    input rst,
    output reg [31:0] instruction, address,
    output [31:0] Ra_rf, Rb_rf,
    output reg [31:0] pc,
    output wire [1:0] state,
    output M1, M2, M3, M4, M5, M6, M7, Wr_en, Eq, pc_flag, instruction_flag, change_address_flag,
    output [3:0] ALU,
    output [31:0] mux5_out0, mux4_out0, mux7_out
);

// Memory unit
wire [31:0] memory_out;

// Initialize opcode, registers
wire [3:0] opcode, Ra, Rb, Rd;
wire [15:0] imm;
wire [31:0] extended_imm;

// Instruction decoding
assign opcode = instruction[31:28];
assign Rd = instruction[27:24];
assign Ra = instruction[23:20];
assign Rb = instruction[19:16];
assign imm = instruction[15:0];

// Mux outputs
wire [31:0] mux1_out, mux2_out, adder_out, ALU_out, mux3_out, mux6_out;

// Declare outputs for mux4 and mux5
wire [31:0] mux4_out1, mux5_out1;

// Initialize pc
initial begin 
    pc = 32'b0;
end

// Address to pc and instruction fetch
always @(posedge clk) begin
    if (instruction_flag  == 1'b1) begin
        address <= pc;
        instruction <= memory_out;
    end else if (change_address_flag  == 1'b1) begin
        address <= mux4_out0;
    end
end


// Always block to update 'pc'
always @(posedge clk or negedge rst) begin
        if (!rst)
            pc <= 32'b0;
        else  if (pc_flag==1'b1)
            pc <= mux1_out;
        
end


// Equality check
assign Eq = (Ra_rf == Rb_rf) ? 1'b1 : 1'b0;

// Adder instance
adder add (
    .a(pc),
    .b(mux2_out),
    .out(adder_out)
);

// Register file instance
register_file RF (
    .clk(clk),
    .rst_n(rst),
    .read_Ra(Ra),
    .read_Rb(Rb),
    .write_Rd(Rd),
    .write_data(mux3_out),
    .data_Ra(Ra_rf),
    .data_Rb(Rb_rf)
);

// Control unit instance
control ctrl (
	.clk(clk),
    .reset(rst),
    .opcode(opcode),
    .Eq(Eq),
    .M1(M1),
    .M2(M2),
    .M3(M3),
    .M4(M4),
    .M5(M5),
    .M6(M6),
    .M7(M7),
    .state(state),
    .pc_flag(pc_flag),
    .change_address_flag(change_address_flag),
    .instruction_flag(instruction_flag),
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
    .in1(Ra_rf),
    .control(M1),
    .out(mux1_out)
);

mux mux2 (
    .in0(32'd4),
    .in1(extended_imm),
    .control(M2),
    .out(mux2_out)
);

mux mux3 (
    .in0(mux7_out),
    .in1(pc),
    .control(M3),
    .out(mux3_out)
);

mux mux6 (
    .in0(mux4_out1),
    .in1(extended_imm),
    .control(M6),
    .out(mux6_out)
);

mux mux7 (
    .in0(memory_out),
    .in1(ALU_out),
    .control(M7),
    .out(mux7_out)
);

// Decoder instances
decoder mux4 (
    .in(Rb_rf),
    .control(M4),
    .out0(mux4_out0),
    .out1(mux4_out1)
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

// Memory instantiate
memory_integrated mem(
    .dataInVirt(mux5_out0),
    .addressVirt(address),
    .wEnVirt(Wr_en),
    .rstVirt(rst),
    .clk(clk),
    .dataOutVirt(memory_out)
);

   



endmodule