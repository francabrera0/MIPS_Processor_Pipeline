`timescale 1ns / 1ps

module memoryStage#(
    DATA_LEN = 32,
    SIZE_BITS = 5
)(
    input wire i_clk,
    //Data inputs
    input wire [SIZE_BITS+1:0] i_address,
    input wire [DATA_LEN-1:0] i_writeData,
    //Control inputs
    input wire i_memWrite,
    input wire [SIZE_BITS-1:0] i_memoryAddress,
    input wire [1:0] i_loadStoreType,
    input wire i_unsigned,
    //Data outputs
    output wire [DATA_LEN-1:0] o_readData,
    output wire [DATA_LEN-1:0] o_memoryValue
);
    
    dataMemory #(
        .DATA_LEN(DATA_LEN),
        .SIZE_BITS(SIZE_BITS)
    ) dataMemory(
        .i_clk(i_clk),
        .i_address(i_address),
        .i_writeData(i_writeData),
        .i_memWrite(i_memWrite),
        .i_memoryAddress(i_memoryAddress),
        .i_loadStoreType(i_loadStoreType),
        .i_unsigned(i_unsigned),
        .o_readData(o_readData),
        .o_memoryValue(o_memoryValue)
    );

endmodule
