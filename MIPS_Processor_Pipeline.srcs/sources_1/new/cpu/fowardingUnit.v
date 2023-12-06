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

wire rsHazardM = (i_rdM == i_rs);
wire rtHazardM = (i_rdM == i_rt);

wire rsHazardWB = (i_rdWB == i_rs);
wire rtHazardWB = (i_rdWB == i_rt);

always @(*) begin
    case({i_regWriteM,i_regWriteWB})
        2'b00: begin
            o_operandACtl = 2'b00;
            o_operandBCtl = 2'b00;
        end
        2'b01: begin
            o_operandACtl = rsHazardWB? 2'b01 : 2'b00;
            o_operandBCtl = rtHazardWB? 2'b01 : 2'b00;
        end
        2'b10: begin
            o_operandACtl = rsHazardM? 2'b10 : 2'b00;
            o_operandBCtl = rtHazardM? 2'b10 : 2'b00;
        end
        2'b11: begin  
            if(rsHazardM) begin
                o_operandACtl = 2'b10;
            end else if(rsHazardWB) begin
                o_operandACtl = 2'b01;
            end else begin
                o_operandACtl = 2'b00;
            end
        
            if(rtHazardM) begin
                o_operandBCtl = 2'b10;
            end else if(rtHazardWB) begin
                o_operandBCtl = 2'b01;
            end else begin
                o_operandBCtl = 2'b00;
            end
        end
    endcase
end

endmodule
