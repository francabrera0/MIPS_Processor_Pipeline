module programCounterIncrement 
#(
    parameter PC_LEN = 32
)
(
    //Inputs
    input wire [PC_LEN-1:0] i_programCounter,

    //Outputs
    output wire [PC_LEN-1:0] o_incrementedPC
);

reg [PC_LEN-1:0] r_incrementedPC;

always @(*) begin
    r_incrementedPC = i_programCounter + 4;
end

//Assigns
assign o_incrementedPC = r_incrementedPC;
    
endmodule