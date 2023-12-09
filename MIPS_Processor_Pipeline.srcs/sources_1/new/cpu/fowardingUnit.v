`timescale 1ns / 1ps

module fowardingUnit #(
    parameter DATA_LEN  = 32,
    parameter REGISTER_BITS = 5
)(
    //Data inputs
    input wire [REGISTER_BITS-1:0] i_rs,
    input wire [REGISTER_BITS-1:0] i_rt,
    input wire [REGISTER_BITS-1:0] i_rdE,
    input wire [REGISTER_BITS-1:0] i_rdM,
    //Control inputs
    input wire i_regWriteE,
    input wire i_regWriteM,
    //Control outputs
    output reg [1:0] o_operandACtl,
    output reg [1:0] o_operandBCtl
);

wire rsHazardE = (i_rdE == i_rs);
wire rtHazardE = (i_rdE == i_rt);

wire rsHazardM = (i_rdM == i_rs);
wire rtHazardM = (i_rdM == i_rt);

always @(*) begin
    if(rsHazardE & i_regWriteE)
        o_operandACtl = 2'b11;
    else if(rsHazardM & i_regWriteM)
        o_operandACtl = 2'b10;
    else
        o_operandACtl = 2'b00;
        
    if(rtHazardE & i_regWriteE)
        o_operandBCtl = 2'b11;
    else if(rtHazardM & i_regWriteM)
        o_operandBCtl = 2'b10;
    else
        o_operandBCtl = 2'b00;
end

endmodule
