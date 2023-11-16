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
    //Control inputs
    input wire [1:0] i_aluSrc,
    input wire [1:0] i_aluOP,
    input wire i_regDst,
    //Data outputs
    output wire [DATA_LEN-1:0] o_branchPC,
    output wire [DATA_LEN-1:0] o_aluResult,
    output wire [REGISTER_BITS-1:0] o_writeRegister,
    //Control outputs
    output wire o_zero
);
    //Calculates branch program counter
    assign o_branchPC = i_incrementedPC + (i_immediateExtendValue << 2);
    
    wire [DATA_LEN-1:0] aluOperand2;
    
    //Mux to select ALU second operand
    mux4to1 #(
        .DATA_LEN(DATA_LEN)
    )MUXD2
    (
        .i_muxInputA(i_readData2),
        .i_muxInputB(i_immediateExtendValue),
        .i_muxInputC(i_shamt),
        .i_muxInputD(0),
        .i_muxSelector(i_aluSrc),
        .o_muxOutput(aluOperand2)
    );
    
    wire [FUNCTION_LEN-1:0] aluCtlTOALU;
    
    ALUControl ALUControl
    (
        .i_funct(i_immediateExtendValue[FUNCTION_LEN-1:0]),
        .i_aluOP(i_aluOP),
        .o_opSelector(aluCtlTOALU)
    );
    
    ALU #(
        .DATA_LEN(DATA_LEN)    
    ) ALU
    (
        .i_operandA(i_readData1),
        .i_operandB(aluOperand2),
        .i_opSelector(aluCtlTOALU),
        .o_aluResult(o_aluResult),
        .o_zero(o_zero)
    );
    
    //Mux to select write register
    mux2to1 #(
        .DATA_LEN(REGISTER_BITS)
    ) MUXWR
    (
        .i_muxInputA(i_rt),
        .i_muxInputB(i_rd),
        .i_muxSelector(i_regDst),
        .o_muxOutput(o_writeRegister)
    );

endmodule
