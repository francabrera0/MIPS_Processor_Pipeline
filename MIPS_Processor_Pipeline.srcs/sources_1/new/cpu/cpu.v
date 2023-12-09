module cpu
#(
    parameter DATA_LEN = 32,
    parameter PC_LEN = 32,
    parameter MEM_SIZE_ADDRESS_BITS = 10, //Bits to address instruction memory,
    parameter OPCODE_LEN = 6, 
    parameter REGISTER_BITS = 5, //Cantidad de bits que direccionan registros
    parameter IMMEDIATE_LEN = 16,
    parameter FUNCTION_LEN = 6
)
(
    //Inputs
    input wire i_clk,
    input wire i_reset,
    input wire i_writeInstruction,
    input wire i_enable,
    input wire [DATA_LEN-1:0] i_instructionToWrite,
    input wire [REGISTER_BITS-1:0] i_regMemAddress,
    input wire i_regMemCtrl,
    output wire [DATA_LEN-1:0] o_regMemValue,
    output wire [PC_LEN-1:0] o_programCounter,
    output wire [15:0] o_instruction,
    output wire o_halt
);

//////////////////////Instruction Fetch///////////////////////////
wire [PC_LEN-1:0] w_incrementedPCIF;
wire [DATA_LEN-1:0] w_instructionIF;
wire w_programCounterSrcM;
wire [DATA_LEN-1:0] w_pcBranch;

wire w_stall;

instructionFetchStage#(
    .DATA_LEN(DATA_LEN),
    .PC_LEN(PC_LEN),
    .MEM_SIZE_ADDRESS_BITS(MEM_SIZE_ADDRESS_BITS)
) instructionFetchStage
(
    //Inputs
    .i_clk(i_clk),
    .i_reset(i_reset),
    .i_programCounterBranch(w_pcBranch),
    .i_enable(i_enable & !w_stall),
    .i_programCounterSrc(w_programCounterSrcM),
    .i_instructionToWrite(i_instructionToWrite),
    .i_writeInstruction(i_writeInstruction),

    //Outputs
    .o_incrementedPC(w_incrementedPCIF),
    .o_instruction(w_instructionIF),
    .o_programCounter(o_programCounter)
);

////////////////////IF-ID Buffer////////////////////////////////////////
wire [PC_LEN-1:0] w_incrementedPCID;
wire [DATA_LEN-1:0] w_instructionID;

fetchDecodeBuffer#(
    .DATA_LEN(DATA_LEN),
    .PC_LEN(PC_LEN)
) fetchDecodeBuffer
(
    //Inputs
    .i_clk(i_clk),
    .i_reset(i_reset),
    .i_instruction(w_instructionIF),
    .i_incrementedPC(w_incrementedPCIF),
    .i_enable(i_enable & !w_stall),

    //Outputs
    .o_incrementedPC(w_incrementedPCID),
    .o_instruction(w_instructionID)
);

///////////////////Instruction decode////////////////////////////////
wire w_regWriteID;
wire [1:0] w_aluSrcID;
wire [1:0] w_aluOpID;
wire [2:0] w_immediateFunctID;
wire [1:0] w_regDestID;
wire [DATA_LEN-1:0] w_readData1ID;
wire [DATA_LEN-1:0] w_readData2ID;
wire [DATA_LEN-1:0] w_immediateExtendValueID;
wire [DATA_LEN-1:0] w_shamtID;
wire [REGISTER_BITS-1:0] w_rsID;
wire [REGISTER_BITS-1:0] w_rtID;
wire [REGISTER_BITS-1:0] w_rdID;
wire w_memReadID;
wire w_memWriteID;
wire [1:0] w_memToRegID;
wire w_haltID;
wire [1:0] w_loadStoreTypeID;
wire w_unsignedID;
wire [REGISTER_BITS-1:0] w_writeRegisterWB;
wire w_regWriteWB;
wire [DATA_LEN-1:0] w_writeDataWB;
wire [DATA_LEN-1:0] w_registerValue;

wire [DATA_LEN-1:0] w_aluResultE;
wire [DATA_LEN-1:0] w_aluResultM;
wire [1:0] w_operandACtl;
wire [1:0] w_operandBCtl;

instructionDecodeStage#(
    .DATA_LEN(DATA_LEN),
    .OPCODE_LEN(OPCODE_LEN), 
    .REGISTER_BITS(REGISTER_BITS), 
    .IMMEDIATE_LEN(IMMEDIATE_LEN) 
) instructionDecodeStage
(
    //Inputs
    .i_reset(i_reset),
    .i_stall(w_stall),
    .i_instruction(w_instructionID),
    .i_regWrite(w_regWriteWB),
    .i_writeRegister(w_writeRegisterWB),
    .i_writeData(w_writeDataWB),
    .i_registerAddress(i_regMemAddress),
    .i_incrementedPC(w_incrementedPCID),
    .i_aluResultE(w_aluResultE),
    .i_aluResultM(w_aluResultM),
    .i_operandACtl(w_operandACtl),
    .i_operandBCtl(w_operandBCtl),

    //Outputs
    .o_regWrite(w_regWriteID),
    .o_aluSrc(w_aluSrcID),
    .o_aluOp(w_aluOpID),
    .o_immediateFunct(w_immediateFunctID),
    .o_regDest(w_regDestID),
    .o_readData1(w_readData1ID),
    .o_readData2(w_readData2ID),
    .o_immediateExtendValue(w_immediateExtendValueID),
    .o_shamt(w_shamtID),
    .o_rs(w_rsID),
    .o_rt(w_rtID),
    .o_rd(w_rdID),
    .o_memRead(w_memReadID),
    .o_memWrite(w_memWriteID),
    .o_memToReg(w_memToRegID),
    .o_registerValue(w_registerValue),
    .o_halt(w_haltID),
    .o_loadStoreType(w_loadStoreTypeID),
    .o_unsigned(w_unsignedID),
    .o_pcBranch(w_pcBranch),
    .o_PCSrc(w_programCounterSrcM)
);

////////////////////ID-Ex Buffer////////////////////////////////////////
wire [PC_LEN-1:0] w_incrementedPCE;
wire [DATA_LEN-1:0] w_readData1E;
wire [DATA_LEN-1:0] w_readData2E;
wire [DATA_LEN-1:0] w_immediateExtendValueE;
wire [DATA_LEN-1:0] w_shamtE;
wire [REGISTER_BITS-1:0] w_rsE;
wire [REGISTER_BITS-1:0] w_rtE;
wire [REGISTER_BITS-1:0] w_rdE;
wire w_regWriteE;
wire [1:0] w_aluSrcE;
wire [1:0] w_aluOpE;
wire [2:0] w_immediateFunctE;
wire [1:0] w_regDestE;
wire w_memReadE;
wire w_memWriteE;
wire [1:0] w_memToRegE;
wire w_haltE;
wire [1:0] w_loadStoreTypeE;
wire w_unsignedE;

decodeExecutionBuffer#(
    .DATA_LEN(DATA_LEN),
    .PC_LEN(PC_LEN),
    .REGISTER_BITS(REGISTER_BITS) 
) decodeExecutionBuffer
(
    //Inputs
    .i_clk(i_clk),
    .i_reset(i_reset),
    .i_enable(i_enable),
    .i_incrementedPC(w_incrementedPCID),
    .i_regWrite(w_regWriteID),
    .i_aluSrc(w_aluSrcID),
    .i_aluOp(w_aluOpID),
    .i_immediateFunct(w_immediateFunctID),
    .i_regDest(w_regDestID),
    .i_readData1(w_readData1ID),
    .i_readData2(w_readData2ID),
    .i_immediateExtendValue(w_immediateExtendValueID),
    .i_shamt(w_shamtID),
    .i_rs(w_rsID),
    .i_rt(w_rtID),
    .i_rd(w_rdID),
    .i_memRead(w_memReadID),
    .i_memWrite(w_memWriteID),
    .i_memToReg(w_memToRegID),
    .i_halt(w_haltID),
    .i_loadStoreType(w_loadStoreTypeID),
    .i_unsigned(w_unsignedID),

    //Outputs
    .o_incrementedPC(w_incrementedPCE),
    .o_regWrite(w_regWriteE),
    .o_aluSrc(w_aluSrcE),
    .o_aluOp(w_aluOpE),
    .o_immediateFunct(w_immediateFunctE),
    .o_regDest(w_regDestE),
    .o_readData1(w_readData1E),
    .o_readData2(w_readData2E),
    .o_immediateExtendValue(w_immediateExtendValueE),
    .o_shamt(w_shamtE),
    .o_rs(w_rsE),
    .o_rt(w_rtE),
    .o_rd(w_rdE),
    .o_memRead(w_memReadE),
    .o_memWrite(w_memWriteE),
    .o_memToReg(w_memToRegE),
    .o_halt(w_haltE),
    .o_loadStoreType(w_loadStoreTypeE),
    .o_unsigned(w_unsignedE)
);

///////////////////Execution stage////////////////////////////////
wire [DATA_LEN-1:0] w_returnPCE;
wire [REGISTER_BITS-1:0] w_writeRegisterE;

executionStage#(
    .DATA_LEN(DATA_LEN),
    .REGISTER_BITS(REGISTER_BITS),
    .FUNCTION_LEN(FUNCTION_LEN)
) executienStage
(
    //Data inputs
    .i_incrementedPC(w_incrementedPCE),
    .i_readData1(w_readData1E),
    .i_readData2(w_readData2E),
    .i_immediateExtendValue(w_immediateExtendValueE),
    .i_shamt(w_shamtE),
    .i_rt(w_rtE),
    .i_rd(w_rdE),
    //Control inputs
    .i_aluSrc(w_aluSrcE),
    .i_aluOP(w_aluOpE),
    .i_immediateFunct(w_immediateFunctE),
    .i_regDst(w_regDestE),
    //Data outputs
    .o_returnPC(w_returnPCE),
    .o_aluResult(w_aluResultE),
    .o_writeRegister(w_writeRegisterE)
);

////////////////////Ex-Mem Buffer////////////////////////////////////////
wire [DATA_LEN-1:0] w_readData2M;
wire [REGISTER_BITS-1:0] w_writeRegisterM;
wire [DATA_LEN-1:0] w_returnPCM;
wire w_regWriteM;
wire w_memReadM;
wire w_memWriteM;
wire [1:0] w_memToRegM;
wire w_haltM;
wire [1:0] w_loadStoreTypeM;
wire w_unsignedM;

executionMemoryBuffer#(
    .DATA_LEN(DATA_LEN)
) executionMemoryBuffer
(
    //Special inputs
    .i_clk(i_clk),
    .i_reset(i_reset),
    .i_enable(i_enable),
    //Data inputs
    .i_returnPC(w_returnPCE),
    .i_readData2(w_readData2E),
    .i_aluResult(w_aluResultE),
    .i_writeRegister(w_writeRegisterE),
    //Control inputs
    .i_regWrite(w_regWriteE),
    .i_memRead(w_memReadE),
    .i_memWrite(w_memWriteE),
    .i_memToReg(w_memToRegE),
    .i_halt(w_haltE),
    .i_loadStoreType(w_loadStoreTypeE),
    .i_unsigned(w_unsignedE),
    //Data outputs
    .o_returnPC(w_returnPCM),
    .o_readData2(w_readData2M),
    .o_aluResult(w_aluResultM),
    .o_writeRegister(w_writeRegisterM),
    //Control outputs
    .o_regWrite(w_regWriteM),
    .o_memRead(w_memReadM),
    .o_memWrite(w_memWriteM),
    .o_memToReg(w_memToRegM),
    .o_halt(w_haltM),
    .o_loadStoreType(w_loadStoreTypeM),
    .o_unsigned(w_unsignedM)
);

///////////////////Memory stage////////////////////////////////

wire [DATA_LEN-1:0] w_readDataM;
wire [DATA_LEN-1:0] w_memoryValue;

memoryStage#(
    .DATA_LEN(DATA_LEN)
) memoryStage
(
    //Data inputs
    .i_address(w_aluResultM),
    .i_writeData(w_readData2M),
    //Control inputs
    .i_memRead(w_memReadM),
    .i_memWrite(w_memWriteM),
    .i_memoryAddress(i_regMemAddress),
    .i_loadStoreType(w_loadStoreTypeM),
    .i_unsigned(w_unsignedM),
    //Data outputs
    .o_readData(w_readDataM),
    .o_memoryValue(w_memoryValue)
);

////////////////////Mem-WB Buffer////////////////////////////////////////
wire [DATA_LEN-1:0] w_memDataWB;
wire [DATA_LEN-1:0] w_aluResultWB;
wire [DATA_LEN-1:0] w_returnPCWB;

wire [1:0] w_memToRegWB;

memoryWritebackBuffer#(
    .DATA_LEN(DATA_LEN)
) memoryWriteBackBuffer
(
    //Special inputs
    .i_clk(i_clk),
    .i_reset(i_reset),
    .i_enable(i_enable),
    //Data inputs
    .i_memData(w_readDataM),
    .i_aluResult(w_aluResultM),
    .i_returnPC(w_returnPCM),
    .i_writeRegister(w_writeRegisterM),
    //Control inputs
    .i_regWrite(w_regWriteM),
    .i_memToReg(w_memToRegM),
    .i_halt(w_haltM),
    //Data outputs
    .o_memData(w_memDataWB),
    .o_aluResult(w_aluResultWB),
    .o_returnPC(w_returnPCWB),
    .o_writeRegister(w_writeRegisterWB),
    //Control outputs
    .o_regWrite(w_regWriteWB),
    .o_memToReg(w_memToRegWB),
    .o_halt(o_halt)
);

////////////////////Write Back Stage////////////////////////////////////////
writebackStage #(
    .DATA_LEN(DATA_LEN)
) writeBackStage
(
    //Data inputs
    .i_readData(w_memDataWB),
    .i_aluResult(w_aluResultWB),
    .i_returnPC(w_returnPCWB),
    //Control inputs
    .i_memToReg(w_memToRegWB),
    //Data outputs
    .o_writeData(w_writeDataWB)
);

////////////////////Fowarding Unit////////////////////////////////////////
fowardingUnit #(
    .DATA_LEN(DATA_LEN),
    .REGISTER_BITS(REGISTER_BITS)
)fowardingUnit(
    //Data inputs
    .i_rs(w_rsID),
    .i_rt(w_rtID),
    .i_rdE(w_writeRegisterE),
    .i_rdM(w_writeRegisterM),
    //Control inputs
    .i_regWriteE(w_regWriteE),
    .i_regWriteM(w_regWriteM),
    //Control outputs
    .o_operandACtl(w_operandACtl),
    .o_operandBCtl(w_operandBCtl)
);

////////////////////Hazard Detector////////////////////////////////////////
hazardDetector #(
    .DATA_LEN(DATA_LEN),
    .REGISTER_BITS(REGISTER_BITS)
)hazardDetector(
    //Data inputs
    .i_rsID(w_rsID),
    .i_rtID(w_rtID),
    .i_rtE(w_rtE),
    .i_rtM(w_writeRegisterM),
    //Control inputs
    .i_memReadE(w_memReadE),
    .i_memReadM(w_memReadM),
    //Control outputs
    .o_stall(w_stall)
);

assign o_regMemValue = i_regMemCtrl ?  w_memoryValue : w_registerValue;
assign o_instruction = w_instructionIF[31:16];

endmodule