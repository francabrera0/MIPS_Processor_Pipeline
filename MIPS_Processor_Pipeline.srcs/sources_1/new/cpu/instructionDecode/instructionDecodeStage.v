module instructionDecodeStage
#(
    parameter DATA_LEN = 32,
    parameter OPCODE_LEN = 6,
    parameter REGISTER_BITS = 5,
    parameter IMMEDIATE_LEN = 16
)
(
    //Inputs
    input wire i_clk,
    input wire i_reset,
    input wire [DATA_LEN-1:0] i_instruction,
    input wire i_regWrite,
    input wire [REGISTER_BITS-1:0] i_writeRegister,
    input wire [DATA_LEN-1:0] i_writeData,

    //Outputs
    output wire o_regWrite,
    output wire [1:0] o_aluSrc,
    output wire [1:0] o_aluOp,
    output wire o_branch,
    output wire o_regDest,
    output wire [DATA_LEN-1:0] o_readData1,
    output wire [DATA_LEN-1:0] o_readData2,
    output wire [DATA_LEN-1:0] o_immediateExtendValue,
    output wire [REGISTER_BITS-1:0] o_rt,
    output wire [REGISTER_BITS-1:0] o_rd,
    output wire [DATA_LEN-1:0] o_shamt,
    output wire o_memRead,
    output wire o_memWrite,
    output wire o_memToReg
);


controlUnit#(
    .DATA_LEN(DATA_LEN),
    .OPCODE_LEN(OPCODE_LEN)
) controlUnit 
(
    .i_instruction(i_instruction),
    .o_regWrite(o_regWrite),
    .o_aluSrc(o_aluSrc),
    .o_aluOp(o_aluOp),
    .o_branch(o_branch),
    .o_regDest(o_regDest),
    .o_memRead(o_memRead),
    .o_memWrite(o_memWrite),
    .o_memToReg(o_memToReg)
);

registers#(
    .DATA_LEN(DATA_LEN),
    .REGISTER_BITS(REGISTER_BITS)
) registers
(
    .i_clk(i_clk),
    .i_reset(i_reset),
    .i_readRegister1(i_instruction[25:21]),
    .i_readRegister2(i_instruction[20:16]),
    .i_writeRegister(i_writeRegister),
    .i_writeData(i_writeData),
    .i_regWrite(i_regWrite),
    .o_readData1(o_readData1),
    .o_readData2(o_readData2)
);

signExtend#(
    .DATA_LEN(DATA_LEN),
    .IMMEDIATE_LEN(IMMEDIATE_LEN)
) signExtend
(
    .i_immediateValue(i_instruction[15:0]),
    .o_immediateExtendValue(o_immediateExtendValue)
);

assign o_rt = i_instruction[20:16];
assign o_rd = i_instruction[15:11];
assign o_shamt = {{DATA_LEN-5{1'b0}}, i_instruction[10:6]};

endmodule
