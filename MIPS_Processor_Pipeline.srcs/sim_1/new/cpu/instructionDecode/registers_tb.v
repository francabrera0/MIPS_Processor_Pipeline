`timescale 1ns / 1ps

module registers_tb();

localparam DATA_LEN = 32;
localparam ADDRESS_LEN = 5;
localparam REGISTERS = 32;


reg i_clk;
reg i_reset;
reg [ADDRESS_LEN-1:0] i_readRegister1;
reg [ADDRESS_LEN-1:0] i_readRegister2;
reg [ADDRESS_LEN-1:0] i_writeRegister;
reg [DATA_LEN-1:0] i_writeData;
reg i_regWrite;

wire [DATA_LEN-1:0] o_readData1;
wire [DATA_LEN-1:0] o_readData2;


registers#(
    .DATA_LEN(DATA_LEN),
    .ADDRESS_LEN(ADDRESS_LEN),
    .REGISTERS(REGISTERS)
) regis
(
    .i_clk(i_clk),
    .i_reset(i_reset),
    .i_readRegister1(i_readRegister1),
    .i_readRegister2(i_readRegister2),
    .i_writeRegister(i_writeRegister),
    .i_writeData(i_writeData),
    .i_regWrite(i_regWrite),
    .o_readData1(o_readData1),
    .o_readData2(o_readData2)
);


always begin
    #10 i_clk = ~i_clk;
end

integer i;

initial begin
    i_clk = 1'b0;
    i_readRegister1 = {ADDRESS_LEN{1'b0}};
    i_readRegister2 = {ADDRESS_LEN{1'b0}};
    i_writeRegister = {ADDRESS_LEN{1'b0}};
    i_regWrite = 1'b0;
    i_writeData = {DATA_LEN{1'b0}};

    i_reset = 1'b1;
    #20;
    i_reset = 1'b0;

    for(i=0; i<REGISTERS; i=i+1) begin
        i_regWrite = 1'b1;
        i_writeRegister = i;
        i_writeData = i*2;
        #20;
    end
    i_regWrite = 1'b0;

    for (i=0; i<REGISTERS; i=i+1) begin
        i_readRegister1 = i;
        #10;
    end

    for (i=0; i<REGISTERS; i=i+1) begin
        i_readRegister1 = i;
        i_readRegister2 = i;
        #10;
    end

end

endmodule
