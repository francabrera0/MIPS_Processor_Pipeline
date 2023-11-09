`timescale 1ns / 1ps

module dataMemory #(
    DATA_LEN = 32,   
    SIZE_BITS = 10
)(
    //Data inputs
    input wire [DATA_LEN-1:0] i_address,
    input wire [DATA_LEN-1:0] i_writeData,
    //Control inputs
    input wire i_memRead,
    input wire i_memWrite,
    //Data outputs
    output wire [DATA_LEN-1:0] i_readData
);
endmodule
