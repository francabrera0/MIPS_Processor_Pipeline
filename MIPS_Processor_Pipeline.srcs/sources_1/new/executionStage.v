`timescale 1ns / 1ps


module executionStage #(
    parameter DATA_LEN  = 32
)(
    //Data inputs
    input wire [DATA_LEN-1:0] i_nextPC,
    input wire [DATA_LEN-1:0] i_d1,
    input wire [DATA_LEN-1:0] i_d2,
    input wire [DATA_LEN-1:0] i_inmediatoEx,
    input wire [4:0] i_rt,
    input wire [4:0] i_rd,
    //Control inputs
    input wire i_aluSrc,
    input wire [1:0] i_aluOP,
    input wire i_regDst,
    //Data outputs
    output wire [DATA_LEN-1:0] o_branchPC,
    output wire [DATA_LEN-1:0] o_aluResult,
    output wire [DATA_LEN-1:0] o_writeRegister,
    //Control outputs
    output wire o_zero
);
    //Calculates branch program counter
    assign o_branchPC = i_nextPC + (i_inmediatoEx << 2);
    
    wire [DATA_LEN-1:0] aluOperand2;
    
    //Mux to select ALU second operand
    mux2to1 #(
        .DATA_LEN(DATA_LEN)
    )MUXD2
    (
        .i_muxInputA(i_d2),
        .i_muxInputB(i_inmediatoEx),
        .i_muxSelector(i_aluSrc),
        .o_muxOutput(aluOperand2)
    );
    
    wire [5:0] aluCtlTOALU;
    
    ALUControl ALUControl
    (
        .i_funct(i_inmediatoEx[5:0]),
        .i_aluOP(i_aluOP),
        .o_opSelector(aluCtlTOALU)
    );
    
    ALU #(
        .DATA_LEN(DATA_LEN)    
    ) ALU
    (
        .i_operandA(i_d1),
        .i_operandB(aluOperand2),
        .i_opSelector(aluCtlTOALU),
        .o_aluResult(o_aluResult),
        .o_zero(o_zero)
    );
    
    //Mux to select write register
    mux2to1 #(
        .DATA_LEN(5)
    ) MUXWR
    (
        .i_muxInputA(i_rt),
        .i_muxInputB(i_rd),
        .i_muxSelector(i_regDst),
        .o_muxOutput(o_writeRegister)
    );

endmodule
