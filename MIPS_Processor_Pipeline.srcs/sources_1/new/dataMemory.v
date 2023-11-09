`timescale 1ns / 1ps

module dataMemory #(
    DATA_LEN = 32,   
    SIZE_BITS = 8
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

reg [DATA_LEN-1:0] memoryBlock [(2**SIZE_BITS)-1: 0];

always @(*) begin
    if(i_memWrite) begin
        memoryBlock[i_address] = i_writeData;
    end
    
    if(i_memRead) begin
        o_readData = memoryBlock[i_address];
    end
end

endmodule
