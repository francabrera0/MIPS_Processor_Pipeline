`timescale 1ns / 1ps

module fowardingUnit #(
    parameter DATA_LEN  = 32,
    parameter REGISTER_BITS = 5
)(
    //Data inputs
    input wire [REGISTER_BITS-1:0] i_rs,
    input wire [REGISTER_BITS-1:0] i_rt,
    input wire [REGISTER_BITS-1:0] i_rdM,
    input wire [REGISTER_BITS-1:0] i_rdWB,
    //Control inputs
    input wire i_regWriteM,
    input wire i_regWriteWB,
    //Control outputs
    output reg [1:0] o_operandACtl,
    output reg [1:0] o_operandBCtl
);

always @(*) begin
    if(i_regWriteM) begin
        if(i_rdM == i_rs) o_operandACtl = 2'b10;
        if(i_rdM == i_rt) o_operandBCtl = 2'b10;
    end else begin
        o_operandACtl = 2'b00;
        o_operandBCtl = 2'b00;
    end
    if(i_regWriteWB) begin
        if(i_rdWB == i_rs & ((i_rdM != i_rs) | !i_regWriteM)) o_operandACtl = 2'b01;
        if(i_rdWB == i_rt & ((i_rdM != i_rt) | !i_regWriteM)) o_operandBCtl = 2'b01;
    end else begin
        o_operandACtl = 2'b00;
        o_operandBCtl = 2'b00;
    end
end

endmodule
