`timescale 1ns / 1ps

module programCounter_tb();

localparam PC_LEN = 32;

reg i_clk;
reg i_reset;
reg [PC_LEN-1:0] i_programCounter;
wire [PC_LEN-1:0] o_programCounter;

programCounter#(
    .PC_LEN(PC_LEN)
) PC
(
    .i_clk(i_clk),
    .i_reset(i_reset),
    .i_programCounter(i_programCounter),
    .o_programCounter(o_programCounter)
);


always begin
    #10 i_clk = ~i_clk;
end

reg [5:0] i;

initial begin
    i_clk = 1'b0;
    i_programCounter = {PC_LEN{1'b0}};
    i_reset = 1'b1;

    #20;

    i_reset = 1'b0;

    for (i=0; i<10; i=i+1) begin
        i_programCounter = i_programCounter+4;
        #20;
    end
    
end

endmodule
