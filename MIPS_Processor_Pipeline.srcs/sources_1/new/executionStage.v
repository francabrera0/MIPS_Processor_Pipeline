`timescale 1ns / 1ps


module executionStage(
    //Data inputs
    input wire [31:0] i_nextPC,
    input wire [31:0] i_d1,
    input wire [31:0] i_d2,
    input wire [31:0] i_inmediatoEx,
    input wire [4:0] i_rt,
    input wire [4:0] i_rd,
    //Control inputs
    input wire i_aluSrc,
    input wire [1:0] i_aluOP,
    input wire i_regDst,
    //Data outputs
    output wire [31:0] o_branchPC,
    output wire [31:0] o_d2,
    output wire [31:0] o_aluResult,
    output wire [31:0] o_writeRegister,
    //Control outputs
    output wire o_zero
);

    assign o_branchPC = i_nextPC + (i_inmediatoEx << 2);

    assign o_d2 = i_d2;
    
    wire [5:0] aluCtlTOALU;
    
    ALUControl #(
        .DATA_LEN(32)    
    ) ALUControl
    (
        .i_funct(i_inmediatoEx[5:0]),
        .i_aluOP(i_aluOP),
        .o_opSelector(aluCtlTOALU)
    );
    
    ALU #(
        .DATA_LEN(32)    
    ) ALU
    (
        .i_operandA(i_d1),
        .i_operandB(),
        .i_opSelector(aluCtlTOALU),
        .o_result(o_aluResult),
        .o_zero(o_zero)
    );

endmodule
