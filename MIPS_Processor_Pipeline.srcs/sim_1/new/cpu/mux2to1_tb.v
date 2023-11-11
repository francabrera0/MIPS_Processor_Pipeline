`timescale 1ns / 1ps

module mux2to1_tb();

localparam DATA_LEN = 32;

reg [DATA_LEN-1:0] i_muxInputA;
reg [DATA_LEN-1:0] i_muxInputB;
reg                i_muxSelector;

wire [DATA_LEN-1:0] o_muxOutput;

mux2to1 #(
    .DATA_LEN(DATA_LEN)
) mux
(
    .i_muxInputA(i_muxInputA),
    .i_muxInputB(i_muxInputB),
    .i_muxSelector(i_muxSelector),
    .o_muxOutput(o_muxOutput)
);

initial begin
    i_muxInputA = 32'hf0f0f0f0;
    i_muxInputB = 32'h0f0f0f0f;

    #10;
    i_muxSelector = 1'b0;
    #10;
    i_muxSelector = 1'b1;
    #10;
    i_muxInputB = 32'h0a0a0a0a;
end


endmodule
