module registers
#(
    parameter DATA_LEN = 32,
    parameter REGISTER_BITS = 5
)
(
    //Inputs
    input wire i_clk,
    input wire i_reset,
    input wire [REGISTER_BITS-1:0] i_readRegister1,
    input wire [REGISTER_BITS-1:0] i_readRegister2,
    input wire [REGISTER_BITS-1:0] i_writeRegister,
    input wire [DATA_LEN-1:0] i_writeData,
    input wire i_regWrite,
    input wire [REGISTER_BITS-1:0] i_registerAddress,

    //Outputs
    output wire [DATA_LEN-1:0] o_readData1,
    output wire [DATA_LEN-1:0] o_readData2,
    output wire [DATA_LEN-1:0] o_registerValue

);

reg [DATA_LEN-1:0] r_registers [(2**REGISTER_BITS)-1:0];

integer i;

always @(posedge i_clk) begin
    if(i_reset) begin
        for(i=0; i<(2**REGISTER_BITS); i=i+1) begin
            r_registers[i] <= 0;            
        end
        r_registers[0] <= 32'h2;
        r_registers[5] <= 32'h8;
        r_registers[8] <= 32'ha;
        r_registers[20] <= 32'hf2;
        r_registers[30] <= 32'hff;
        r_registers[31] <= 32'hff;
    end
end

always @(*) begin
    if(i_regWrite) begin
        r_registers[i_writeRegister] = i_writeData;
    end
end


assign o_readData1 = r_registers[i_readRegister1];
assign o_readData2 = r_registers[i_readRegister2];
assign o_registerValue = r_registers[i_registerAddress];

endmodule
