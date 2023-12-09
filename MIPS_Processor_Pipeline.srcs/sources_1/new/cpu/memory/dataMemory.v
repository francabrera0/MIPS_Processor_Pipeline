`timescale 1ns / 1ps

module dataMemory #(
    DATA_LEN = 32,   
    SIZE_BITS = 5
)(
    input wire i_clk,
    //Data inputs
    input wire [DATA_LEN-1:0] i_address,
    input wire [DATA_LEN-1:0] i_writeData,
    //Control inputs
    input wire i_memWrite,
    input wire [4:0] i_memoryAddress,
    input wire [1:0] i_loadStoreType,
    input wire i_unsigned,
    //Data outputs
    output wire [DATA_LEN-1:0] o_readData,
    output wire [DATA_LEN-1:0] o_memoryValue
);

localparam BYTE = 2'b00;
localparam HALFWORD = 2'b01;
localparam WORD = 2'b11;

localparam BYTE_SIZE = 8;
localparam HALFWORD_SIZE = DATA_LEN / 2;

reg [DATA_LEN-1:0] memoryBlock [(2**SIZE_BITS)-1: 0];

wire [DATA_LEN-3:0] alingnedAddress = i_address[DATA_LEN-1:2];

wire [DATA_LEN-1:0] w_readData;

wire[BYTE_SIZE-1:0] byteSigned = {i_writeData[DATA_LEN-1], i_writeData[BYTE_SIZE-2:0]};
wire[HALFWORD_SIZE-1:0] halfWordSigned = {i_writeData[DATA_LEN-1], i_writeData[HALFWORD_SIZE-2:0]};

memoryMask #(
    .DATA_LEN(DATA_LEN)
)memoryMask (
    .i_readData(w_readData),
    .i_loadStoreType(i_loadStoreType),
    .i_unsigned(i_unsigned),
    .i_address(i_address[1:0]),
    .o_readData(o_readData)
);

always @(posedge i_clk) begin
    if(i_memWrite) begin
        case(i_loadStoreType)
            BYTE: begin
                case(i_address[1:0])
                    2'b00: begin
                        memoryBlock[alingnedAddress][BYTE_SIZE-1:0] = byteSigned;
                    end
                    2'b01: begin
                        memoryBlock[alingnedAddress][BYTE_SIZE*2-1:BYTE_SIZE] = byteSigned;
                    end
                    2'b10: begin
                        memoryBlock[alingnedAddress][BYTE_SIZE*3-1:BYTE_SIZE*2] = byteSigned;
                    end
                    2'b11: begin
                        memoryBlock[alingnedAddress][DATA_LEN-1:BYTE_SIZE*3] = byteSigned;
                    end
                endcase
            end
            HALFWORD: begin
                if(i_address[1]) begin
                    memoryBlock[alingnedAddress][DATA_LEN-1:HALFWORD_SIZE] = halfWordSigned;
                end else begin
                    memoryBlock[alingnedAddress][HALFWORD_SIZE-1:0] = halfWordSigned;
                end
            end
            default: begin
                memoryBlock[alingnedAddress] = i_writeData;
            end
        endcase
    end    
end

assign o_memoryValue = memoryBlock[i_memoryAddress];
assign w_readData = memoryBlock[alingnedAddress];

endmodule
