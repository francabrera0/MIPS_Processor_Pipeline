module registers
#(
    parameter DATA_LEN = 32,
    parameter ADDRESS_LEN = 5,
    parameter REGISTERS = 32
)
(
    //Inputs
    input wire i_clk,
    input wire i_reset,
    input wire [ADDRESS_LEN-1:0] i_readRegister1,
    input wire [ADDRESS_LEN-1:0] i_readRegister2,
    input wire [ADDRESS_LEN-1:0] i_writeRegister,
    input wire [DATA_LEN-1:0] i_writeData,
    input wire i_regWrite,

    //Outputs
    output wire [DATA_LEN-1:0] o_readData1,
    output wire [DATA_LEN-1:0] o_readData2
);

reg [DATA_LEN-1:0] r_registers [REGISTERS-1:0];

integer i;

always @(posedge i_clk) begin
    if(i_reset) begin
        for(i=0; i<REGISTERS; i=i+1) begin
            r_registers[i] <= 0;            
        end
    end
end

always @(posedge i_clk) begin
    if(i_regWrite) begin
        r_registers[i_writeRegister] <= i_writeData;
    end
end

assign o_readData1 = r_registers[i_readRegister1];
assign o_readData2 = r_registers[i_readRegister2];

endmodule
