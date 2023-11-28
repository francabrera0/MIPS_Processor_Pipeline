`timescale 1ns / 1ps

module signExtend_tb();

localparam DATA_LEN = 32;
localparam IMMEDIATE_LEN = 16;

reg [IMMEDIATE_LEN-1:0] i_immediateValue;
wire [DATA_LEN-1:0] o_immediateExtendValue;


signExtend#(
    .DATA_LEN(DATA_LEN),
    .IMMEDIATE_LEN(IMMEDIATE_LEN)
) se
(
    .i_immediateValue(i_immediateValue),
    .o_immediateExtendValue(o_immediateExtendValue)
);


initial begin
    i_immediateValue = 16'h00;
    #10;
    i_immediateValue = 16'h05;
    #10;
    i_immediateValue = 16'hf0ff;
    #10;
end

endmodule
