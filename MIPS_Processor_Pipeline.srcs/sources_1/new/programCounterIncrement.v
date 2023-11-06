module programCounterIncrement 
#(
    parameter DATA_LEN = 32
)
(
    //Inputs
    input wire [DATA_LEN-1:0] i_programCounter,

    //Outputs
    output wire [DATA_LEN-1:0] o_incrementedProgramCounter
);

reg [DATA_LEN-1:0] r_incrementedProgramCounter;

always @(*) begin
    r_incrementedProgramCounter = i_programCounter + 1;
end

//Assigns
assign o_incrementedProgramCounter = r_incrementedProgramCounter;
    
endmodule