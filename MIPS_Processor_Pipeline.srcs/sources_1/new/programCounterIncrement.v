module programCounterIncrement 
#(
    parameter PC_LEN = 32
)
(
    //Inputs
    input wire [PC_LEN-1:0] i_programCounter,

    //Outputs
    output wire [PC_LEN-1:0] o_incrementedProgramCounter
);

reg [PC_LEN-1:0] r_incrementedProgramCounter;

always @(*) begin
    r_incrementedProgramCounter = i_programCounter + 4;
end

//Assigns
assign o_incrementedProgramCounter = r_incrementedProgramCounter;
    
endmodule