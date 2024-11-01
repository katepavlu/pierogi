module cpu(
    input clk, // 50 MHz
    input rst,
    output wire clk0, clk2,
    output reg [31:0] instruction, address,
    output [31:0] Ra_rf, Rb_rf,
    output reg [31:0] pc,
    output M1, M2, M3, M4, M5, M6, M7, Wr_en, Eq,
    output [3:0] ALU,
    output [31:0] mux5_out0, mux4_out0, mux7_out
);

wire locked;

// Assign clk0 to clk
assign clk0 = clk;

// Internal clock divider for clk2
reg [1:0] clk2_counter = 0;
reg clk2_internal = 0;

always @(posedge clk or negedge rst) begin
    if (!rst) begin
        clk2_counter <= 0;
        clk2_internal <= 0;
    end else if (clk2_counter == 2) begin
        clk2_counter <= 0;
        clk2_internal <= ~clk2_internal;  // Toggle clk2 every third rising edge
    end else begin
        clk2_counter <= clk2_counter + 1;
    end
end

assign clk2 = clk2_internal;


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

always @(posedge clk0) begin
    if (M7==0) 
        address = mux4_out0;
	else begin
		  address = pc;
        instruction = memory_out;
		  end
end

// Initialize pc
initial begin 
    pc = 32'b0;
end

// Equality check
assign Eq = (Ra_rf == Rb_rf) ? 1'b1 : 1'b0;


// Always block to update 'pc'
always @(negedge clk2 or negedge rst) begin
    if (!rst)
        pc <= 32'b0;
    else
        pc <= mux1_out;
end

// Adder instance
adder add (
    .a(pc),
    .b(mux2_out),
    .out(adder_out)
);

// Register file instance
register_file RF (
    .clk(clk2),
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
    .clk(clk0),
    .dataOutVirt(memory_out)
);

   



endmodule