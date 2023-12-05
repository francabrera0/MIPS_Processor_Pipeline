`timescale 1ns / 1ps

module writebackStage #(
    DATA_LEN = 32
)
(
    //Data inputs
    input wire [DATA_LEN-1:0] i_readData,
    input wire [DATA_LEN-1:0] i_aluResult,
    input wire [DATA_LEN-1:0] i_returnPC,
    //Control inputs
    input wire [1:0] i_memToReg,
    //Data outputs
    output wire [DATA_LEN-1:0] o_writeData
);

    mux4to1 #(
        .DATA_LEN(DATA_LEN)
    ) mux2to1(
        .i_muxInputA(i_aluResult),
        .i_muxInputB(i_readData),
        .i_muxInputC(i_returnPC),
        .i_muxInputD(0),
        .i_muxSelector(i_memToReg),
        .o_muxOutput(o_writeData)
    );

endmodule
