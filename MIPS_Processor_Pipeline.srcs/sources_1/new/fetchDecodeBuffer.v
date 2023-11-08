module fetchDecodeBuffer
#(
    parameter DATA_LEN = 32,
    parameter PC_LEN = 32
)
(
    //Inputs
    input wire i_clk,
    input wire i_reset,
    input wire [DATA_LEN-1:0] i_instruction,
    input wire [PC_LEN-1:0] i_incrementedProgramCounter,
    input wire i_enable,

    //Outputs
    output wire [PC_LEN-1:0] o_incrementedProgramCounter,
    output wire [DATA_LEN-1:0] o_instruction
);

reg [DATA_LEN-1:0] r_instruction;
reg [PC_LEN-1:0] r_incrementedProgramCounter;

always @(posedge i_clk) begin
    if(i_reset) begin
        r_instruction <= 0;
        r_incrementedProgramCounter <= 0;
    end
    else if(i_enable) begin
        r_instruction <= i_instruction;
        r_incrementedProgramCounter <= i_incrementedProgramCounter;
    end
end

//Assigns
assign o_instruction = r_instruction;
assign o_incrementedProgramCounter = r_incrementedProgramCounter;

endmodule
