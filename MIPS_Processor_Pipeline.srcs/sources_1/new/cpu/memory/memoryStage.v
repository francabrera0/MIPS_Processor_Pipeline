`timescale 1ns / 1ps

module memoryStage#(
    DATA_LEN = 32
)(
    //Data inputs
    input wire [DATA_LEN-1:0] i_address,
    input wire [DATA_LEN-1:0] i_writeData,
    //Control inputs
    input wire i_memRead,
    input wire i_memWrite,
    input wire [1:0] i_branch,
    input wire i_zero,
    input wire [4:0] i_memoryAddress,
    input wire [1:0] i_loadStoreType,
    input wire i_unsigned,
    //Data outputs
    output wire [DATA_LEN-1:0] o_readData,
    output wire [DATA_LEN-1:0] o_memoryValue,
    //Control outputs
    output wire o_PCSrc
);
    
    branchControl branchControl(
        .i_branch(i_branch),
        .i_zero(i_zero),
        .o_PCSrc(o_PCSrc)
    );
    
    dataMemory #(
        .DATA_LEN(DATA_LEN)
    ) dataMemory(
        .i_address(i_address),
        .i_writeData(i_writeData),
        .i_memRead(i_memRead),
        .i_memWrite(i_memWrite),
        .i_memoryAddress(i_memoryAddress),
        .i_loadStoreType(i_loadStoreType),
        .i_unsigned(i_unsigned),
        .o_readData(o_readData),
        .o_memoryValue(o_memoryValue)
    );

endmodule
