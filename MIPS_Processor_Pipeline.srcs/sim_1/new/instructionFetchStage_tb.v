`timescale 1ns / 1ps

module instructionFetchStage_tb();

localparam DATA_LEN = 32;
localparam PC_LEN = 32;
localparam MEM_SIZE_ADDRESS_BITS = 3;

reg i_clk;
reg i_reset;
reg [PC_LEN-1:0] i_programCounterBranch;
reg i_programCounterSrc;
reg [DATA_LEN-1:0] i_instructionToWrite;
reg i_writeMemory;
wire [PC_LEN-1:0] o_incrementedPC;
wire [DATA_LEN-1:0] o_instruction;

instructionFetchStage#(
    .DATA_LEN(DATA_LEN),
    .PC_LEN(PC_LEN),
    .MEM_SIZE_ADDRESS_BITS(MEM_SIZE_ADDRESS_BITS)
) IFStage
(
    .i_clk(i_clk),
    .i_reset(i_reset),
    .i_programCounterBranch(i_programCounterBranch),
    .i_programCounterSrc(i_programCounterSrc),
    .i_instructionToWrite(i_instructionToWrite),
    .i_writeMemory(i_writeMemory),
    .o_incrementedPC(o_incrementedPC),
    .o_instruction(o_instruction)
);


always begin
    #10 i_clk = ~i_clk;
end

reg [5:0] i;

initial begin
    i_clk = 1'b0;
    i_programCounterBranch = 32'h18;
    i_programCounterSrc = 1'b0;
    i_instructionToWrite = {DATA_LEN{1'b0}};
    i_writeMemory = 1'b0;
    i_reset = 1'b1;
    #20;
    i_reset = 1'b0;

    for(i=0; i<(2**MEM_SIZE_ADDRESS_BITS); i=i+1) begin
        i_instructionToWrite = i;
        i_writeMemory = 1'b1;
        #20;
        i_writeMemory = 1'b0;
    end

    #200;
    i_programCounterSrc = 1'b1;
    #20;
    i_programCounterSrc = 1'b0;

end

endmodule
