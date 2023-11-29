`timescale 1ns / 1ps

module memoryMask #(
    DATA_LEN = 32
)(
    //Data inputs
    input wire [DATA_LEN-1:0] i_readData,
    input wire[1:0] i_address,
    //Control inputs
    input wire i_unsigned,
    input wire [1:0] i_loadStoreType,
    //Data outputs
    output reg [DATA_LEN-1:0] o_readData
);

localparam BYTE = 2'b00;
localparam HALFWORD = 2'b01;
localparam WORD = 2'b11;

localparam BYTE_SIZE = 8;
localparam HALFWORD_SIZE = DATA_LEN / 2;

wire[DATA_LEN-1:0] byteShifted = (i_readData >> (i_address * BYTE_SIZE));
wire[DATA_LEN-1:0] halfWordShifted = (i_readData >> (i_address[1] * HALFWORD_SIZE));

always @(*) begin
    case(i_loadStoreType)
        BYTE: begin
            o_readData = {
                (!i_unsigned) & byteShifted[BYTE_SIZE-1],
                {23'b0},
                i_unsigned & byteShifted[BYTE_SIZE-1], 
                byteShifted[BYTE_SIZE-2:0]};
        end
        HALFWORD: begin
            o_readData = {
                (!i_unsigned) & halfWordShifted[HALFWORD_SIZE-1],
                {15'b0},
                i_unsigned & halfWordShifted[HALFWORD_SIZE-1], 
                halfWordShifted[HALFWORD_SIZE-2:0]};
        end
        WORD: begin
            o_readData = i_readData;
        end
    endcase
end

endmodule
