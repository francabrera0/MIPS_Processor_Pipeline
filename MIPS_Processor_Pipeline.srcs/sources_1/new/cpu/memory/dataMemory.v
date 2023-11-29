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
    input wire [4:0] i_memoryAddress,
    input wire [1:0] i_loadStoreType,
    input wire i_unsigned,
    //Data outputs
    output wire [DATA_LEN-1:0] o_readData,
    output reg [DATA_LEN-1:0] o_memoryValue
);

reg [DATA_LEN-1:0] memoryBlock [(2**SIZE_BITS)-1: 0];

wire [DATA_LEN-3:0] alingnedAddress = i_address[DATA_LEN-1:2];

reg [DATA_LEN-1:0] r_readData;

initial begin
    memoryBlock[0] = 32'hffaaffaa;
    memoryBlock[31] = 32'hffaaffaa;
end

    memoryMask #(
        .DATA_LEN(DATA_LEN)
    )memoryMask (
        .i_readData(r_readData),
        .i_loadStoreType(i_loadStoreType),
        .i_unsigned(i_unsigned),
        .i_address(i_address[1:0]),
        .o_readData(o_readData)
    );

always @(*) begin
    if(i_memWrite) begin
        memoryBlock[alingnedAddress] = i_writeData;
    end
    
    if(i_memRead) begin
        r_readData = memoryBlock[alingnedAddress];
    end

    o_memoryValue = memoryBlock[i_memoryAddress];
    
end

endmodule
