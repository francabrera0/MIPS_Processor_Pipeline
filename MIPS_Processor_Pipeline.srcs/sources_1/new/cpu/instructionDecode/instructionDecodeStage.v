module instructionDecodeStage
#(
    parameter DATA_LEN = 32,
    parameter OPCODE_LEN = 6,
    parameter REGISTER_BITS = 5,
    parameter IMMEDIATE_LEN = 16
)
(
    //Inputs
    input wire i_reset,
    input wire i_stall,
    input wire [DATA_LEN-1:0] i_instruction,
    input wire i_regWrite,
    input wire [REGISTER_BITS-1:0] i_writeRegister,
    input wire [DATA_LEN-1:0] i_writeData,
    input wire [REGISTER_BITS-1:0] i_registerAddress,
    input wire [DATA_LEN-1:0] i_incrementedPC,
    input wire [DATA_LEN-1:0] i_aluResultE,
    input wire [DATA_LEN-1:0] i_aluResultM,
    input wire [1:0] i_operandACtl,
    input wire [1:0] i_operandBCtl,

    //Outputs
    output wire o_regWrite,
    output wire [1:0] o_aluSrc,
    output wire [1:0] o_aluOp,
    output wire [2:0] o_immediateFunct,
    output wire [1:0] o_regDest,
    output wire [DATA_LEN-1:0] o_readData1,
    output wire [DATA_LEN-1:0] o_readData2,
    output wire [DATA_LEN-1:0] o_immediateExtendValue,
    output wire [REGISTER_BITS-1:0] o_rs,
    output wire [REGISTER_BITS-1:0] o_rt,
    output wire [REGISTER_BITS-1:0] o_rd,
    output wire [DATA_LEN-1:0] o_shamt,
    output wire o_memRead,
    output wire o_memWrite,
    output wire [1:0] o_memToReg,
    output wire o_halt,
    output wire [1:0] o_loadStoreType,
    output wire o_unsigned,
    output wire [DATA_LEN-1:0] o_registerValue,
    output wire o_PCSrc,
    output wire [DATA_LEN-1:0] o_pcBranch
);

wire [DATA_LEN-1:0] w_readData1;
wire [DATA_LEN-1:0] w_readData2;
wire [DATA_LEN-1:0] w_instruction;

wire [1:0] w_branch;
wire w_jumpType;

//Mux to stall o select instruction
mux2to1 #(
    .DATA_LEN(DATA_LEN)
) MUXD1(
    .i_muxInputA(i_instruction),
    .i_muxInputB(32'hffffffff),
    .i_muxSelector(i_stall),
    .o_muxOutput(w_instruction)
);

controlUnit#(
    .DATA_LEN(DATA_LEN),
    .OPCODE_LEN(OPCODE_LEN)
) controlUnit 
(
    .i_instruction(w_instruction),
    .o_regWrite(o_regWrite),
    .o_aluSrc(o_aluSrc),
    .o_aluOp(o_aluOp),
    .o_immediateFunct(o_immediateFunct),
    .o_branch(w_branch),
    .o_jumpType(w_jumpType),
    .o_regDest(o_regDest),
    .o_memRead(o_memRead),
    .o_memWrite(o_memWrite),
    .o_memToReg(o_memToReg),
    .o_halt(o_halt),
    .o_loadStoreType(o_loadStoreType),
    .o_unsigned(o_unsigned)
);

registers#(
    .DATA_LEN(DATA_LEN),
    .REGISTER_BITS(REGISTER_BITS)
) registers
(
    .i_reset(i_reset),
    .i_readRegister1(i_instruction[25:21]),
    .i_readRegister2(i_instruction[20:16]),
    .i_writeRegister(i_writeRegister),
    .i_writeData(i_writeData),
    .i_regWrite(i_regWrite),
    .i_registerAddress(i_registerAddress),
    .o_readData1(w_readData1),
    .o_readData2(w_readData2),
    .o_registerValue(o_registerValue)
);

signExtend#(
    .DATA_LEN(DATA_LEN),
    .IMMEDIATE_LEN(IMMEDIATE_LEN)
) signExtend
(
    .i_immediateValue(i_instruction[15:0]),
    .o_immediateExtendValue(o_immediateExtendValue)
);

//Mux to select readData1 fowarding
mux4to1 #(
    .DATA_LEN(DATA_LEN)
) MUXD1F
(
    .i_muxInputA(w_readData1),
    .i_muxInputB(0),
    .i_muxInputC(i_aluResultM),
    .i_muxInputD(i_aluResultE),
    .i_muxSelector(i_operandACtl),
    .o_muxOutput(o_readData1)
);

//Mux to select readData2 fowarding
mux4to1 #(
    .DATA_LEN(DATA_LEN)
) MUXD2F
(
    .i_muxInputA(w_readData2),
    .i_muxInputB(0),
    .i_muxInputC(i_aluResultM),
    .i_muxInputD(i_aluResultE),
    .i_muxSelector(i_operandBCtl),
    .o_muxOutput(o_readData2)
);

branchControl branchControl(
    //Data inputs
    .i_incrementedPC(i_incrementedPC),
    .i_immediateExtendValue(o_immediateExtendValue),
    .i_readData1(o_readData1),
    .i_readData2(o_readData2),
    .i_instrIndex(i_instruction[25:0]),
    //Control inputs
    .i_branch(w_branch),
    .i_jumpType(w_jumpType),
    //Control outputs
    .o_PCSrc(o_PCSrc),
    .o_pcBranch(o_pcBranch)
);

assign o_rs = i_instruction[25:21];
assign o_rt = i_instruction[20:16];
assign o_rd = i_instruction[15:11];
assign o_shamt = {{DATA_LEN-5{1'b0}}, i_instruction[10:6]};

endmodule
