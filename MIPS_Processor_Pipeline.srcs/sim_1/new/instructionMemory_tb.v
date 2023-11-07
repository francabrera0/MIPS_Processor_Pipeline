`timescale 1ns / 1ps

module instructionMemory_tb();

localparam DATA_LEN = 32;
localparam PC_LEN = 32;
localparam MEM_SIZE_ADDRESS_BITS = 3;

reg i_clk;
reg i_reset;
reg [PC_LEN-1:0] i_programCounter;
reg [DATA_LEN-1:0] i_dataToWrite;
reg i_write;

wire [DATA_LEN-1:0] o_instruction;

instructionMemory#(
    .DATA_LEN(DATA_LEN),
    .PC_LEN(PC_LEN),
    .MEM_SIZE_ADDRESS_BITS(MEM_SIZE_ADDRESS_BITS)
)memory
(
    .i_clk(i_clk),
    .i_reset(i_reset),
    .i_programCounter(i_programCounter),
    .i_dataToWrite(i_dataToWrite),
    .i_write(i_write),
    .o_instruction(o_instruction)
);

always begin
    #10 i_clk = ~i_clk;
end

reg [5:0] i;

initial begin
    i_clk = 0;
    i_dataToWrite = 32'b0;
    i_programCounter = 32'b0;
    i_write = 1'b0;

    i_reset = 1'b1;
    #20;
    i_reset = 1'b0;


    for(i=0; i<(2**MEM_SIZE_ADDRESS_BITS); i=i+1) begin
        i_dataToWrite = i;
        i_write = 1'b1;
        #20;
        i_write = 1'b0;
    end

    #30;

    for(i=0; i<(2**MEM_SIZE_ADDRESS_BITS)*2; i=i+1) begin
        i_programCounter = i_programCounter + 4;
        #20;
    end

end

endmodule
