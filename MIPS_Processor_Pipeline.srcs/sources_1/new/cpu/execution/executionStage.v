`timescale 1ns / 1ps

module executionStage #(
    parameter DATA_LEN  = 32,
    parameter REGISTER_BITS = 5,
    parameter FUNCTION_LEN = 6
)(
    //Data inputs
    input wire [DATA_LEN-1:0] i_incrementedPC,
    input wire [DATA_LEN-1:0] i_readData1,
    input wire [DATA_LEN-1:0] i_readData2,
    input wire [DATA_LEN-1:0] i_immediateExtendValue,
    input wire [DATA_LEN-1:0] i_shamt,
    input wire [REGISTER_BITS-1:0] i_rt,
    input wire [REGISTER_BITS-1:0] i_rd,
    input wire [25:0] i_instrIndex,
    input wire [DATA_LEN-1:0] i_aluResultM,
    input wire [DATA_LEN-1:0] i_aluResultWB,
    //Control inputs
    input wire [1:0] i_aluSrc,
    input wire [1:0] i_aluOP,
    input wire [2:0] i_immediateFunct,
    input wire [1:0] i_regDst,
    input wire i_jumpType,
    input wire [1:0] i_operandACtl,
    input wire [1:0] i_operandBCtl,
    input wire [1:0] i_branch,
    //Data outputs
    output wire [DATA_LEN-1:0] o_returnPC,
    output wire [DATA_LEN-1:0] o_aluResult,
    output wire [REGISTER_BITS-1:0] o_writeRegister
);

    assign o_returnPC = i_incrementedPC + 4;
    
    wire [DATA_LEN-1:0] readData1;
    wire [DATA_LEN-1:0] readData2;
    
    wire [DATA_LEN-1:0] aluOperand1;
    wire [DATA_LEN-1:0] aluOperand2;
    
    wire w_zero;
    
    //Mux to select readData1 fowarding
    mux4to1 #(
        .DATA_LEN(DATA_LEN)
    ) MUXD1F
    (
        .i_muxInputA(i_readData1),
        .i_muxInputB(i_aluResultWB),
        .i_muxInputC(i_aluResultM),
        .i_muxInputD(0),
        .i_muxSelector(i_operandACtl),
        .o_muxOutput(readData1)
    );
    
    //Mux to select ALU first operand
    mux2to1 #(
        .DATA_LEN(DATA_LEN)
    ) MUXD1
    (
        .i_muxInputA(readData1),
        .i_muxInputB(i_shamt),
        .i_muxSelector(i_aluSrc[1]),
        .o_muxOutput(aluOperand1)
    );
    
    //Mux to select readData2 fowarding
    mux4to1 #(
        .DATA_LEN(DATA_LEN)
    ) MUXD2F
    (
        .i_muxInputA(i_readData2),
        .i_muxInputB(i_aluResultWB),
        .i_muxInputC(i_aluResultM),
        .i_muxInputD(0),
        .i_muxSelector(i_operandBCtl),
        .o_muxOutput(readData2)
    );
    
    //Mux to select ALU second operand
    mux2to1 #(
        .DATA_LEN(DATA_LEN)
    )MUXD2
    (
        .i_muxInputA(readData2),
        .i_muxInputB(i_immediateExtendValue),
        .i_muxSelector(i_aluSrc[0]),
        .o_muxOutput(aluOperand2)
    );
    
    wire [FUNCTION_LEN-1:0] aluCtlTOALU;
    
    ALUControl ALUControl
    (
        .i_funct(i_immediateExtendValue[FUNCTION_LEN-1:0]),
        .i_aluOP(i_aluOP),
        .i_immediateFunct(i_immediateFunct),
        .o_opSelector(aluCtlTOALU)
    );
    
    ALU #(
        .DATA_LEN(DATA_LEN)    
    ) ALU
    (
        .i_operandA(aluOperand1),
        .i_operandB(aluOperand2),
        .i_opSelector(aluCtlTOALU),
        .o_aluResult(o_aluResult),
        .o_zero(w_zero)
    );
    
    //Mux to select write register
    mux4to1 #(
        .DATA_LEN(REGISTER_BITS)
    ) MUXWR
    (
        .i_muxInputA(i_rt),
        .i_muxInputB(i_rd),
        .i_muxInputC(0),
        .i_muxInputD(5'h1f), //Registro 31
        .i_muxSelector(i_regDst),
        .o_muxOutput(o_writeRegister)
    );
endmodule
