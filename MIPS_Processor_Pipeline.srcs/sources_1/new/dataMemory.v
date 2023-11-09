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
    output reg [DATA_LEN-1:0] o_readData
);

reg [7:0] memoryBlock [(2**SIZE_BITS)-1: 0];

always @(*) begin
    if(i_memWrite) begin
        memoryBlock[i_address] = i_writeData[7:0];
        memoryBlock[i_address + 1] = i_writeData[15:8];
        memoryBlock[i_address + 2] = i_writeData[23:16];
        memoryBlock[i_address + 3] = i_writeData[31:24];
    end
    
    if(i_memRead) begin
        o_readData[7:0] = memoryBlock[i_address];
        o_readData[15:8] = memoryBlock[i_address + 1];
        o_readData[23:16] = memoryBlock[i_address + 2];
        o_readData[31:24] = memoryBlock[i_address + 3];
    end
end

endmodule
