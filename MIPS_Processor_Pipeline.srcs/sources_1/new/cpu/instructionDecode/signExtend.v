module signExtend
#(
    parameter DATA_LEN = 32,
    parameter IMMEDIATE_LEN = 16
)
(
    input wire [IMMEDIATE_LEN-1:0] i_immediateValue,
    output wire [DATA_LEN-1:0] o_immediateExtendValue
);

assign o_immediateExtendValue = 
    {i_immediateValue[IMMEDIATE_LEN-1],{DATA_LEN-IMMEDIATE_LEN{1'b0}},i_immediateValue[IMMEDIATE_LEN-2:0]};

endmodule
