`timescale 1ns / 1ps

module decodeExecutionBuffer_tb();

localparam DATA_LEN = 32;
localparam PC_LEN = 32;
localparam ADDRESS_LEN = 5;

reg i_clk;
reg i_reset;

reg [PC_LEN-1:0] i_incrementedPC;
reg i_regWrite;
reg i_aluSrc;
reg [1:0] i_aluOp;
reg i_branch;
reg i_regDest;
reg [DATA_LEN-1:0] i_readData1;
reg [DATA_LEN-1:0] i_readData2;
reg [DATA_LEN-1:0] i_immediateExtendValue;
reg [ADDRESS_LEN-1:0] i_rt;
reg [ADDRESS_LEN-1:0] i_rd;

wire [PC_LEN-1:0] o_incrementedPC;
wire o_regWrite;
wire o_aluSrc;
wire [1:0] o_aluOp;
wire o_branch;
wire o_regDest;
wire [DATA_LEN-1:0] o_readData1;
wire [DATA_LEN-1:0] o_readData2;
wire [DATA_LEN-1:0] o_immediateExtendValue;
wire [ADDRESS_LEN-1:0] o_rt;
wire [ADDRESS_LEN-1:0] o_rd;

decodeExecutionBuffer#(
    .DATA_LEN(DATA_LEN),
    .PC_LEN(PC_LEN),
    .ADDRESS_LEN(ADDRESS_LEN) 
) buffer
(

    .i_clk(i_clk),
    .i_reset(i_reset),
    .i_incrementedPC(i_incrementedPC),
    .i_regWrite(i_regWrite),
    .i_aluSrc(i_aluSrc),
    .i_aluOp(i_aluOp),
    .i_branch(i_branch),
    .i_regDest(i_regDest),
    .i_readData1(i_readData1),
    .i_readData2(i_readData2),
    .i_immediateExtendValue(i_immediateExtendValue),
    .i_rt(i_rt),
    .i_rd(i_rd),

    .o_incrementedPC(o_incrementedPC),
    .o_regWrite(o_regWrite),
    .o_aluSrc(o_aluSrc),
    .o_aluOp(o_aluOp),
    .o_branch(o_branch),
    .o_regDest(o_regDest),
    .o_readData1(o_readData1),
    .o_readData2(o_readData2),
    .o_immediateExtendValue(o_immediateExtendValue),
    .o_rt(o_rt),
    .o_rd(o_rd)
);


always begin
    #10 i_clk = ~i_clk;
end

integer i;
initial begin
    i_clk = 1'b0;
    i_reset = 1'b1;
    #20;
    i_reset = 1'b0;

    for(i=0; i<10; i=i+1) begin
        i_incrementedPC = i;
        i_regWrite = i;
        i_aluSrc = i;
        i_aluOp = i;
        i_branch = i;
        i_regDest = i;
        i_readData1 = i;
        i_readData2 = i;
        i_immediateExtendValue = i;
        i_rt = i;
        i_rd = i;

        #20;
    end

end

endmodule
