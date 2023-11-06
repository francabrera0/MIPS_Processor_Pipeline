`timescale 1ns / 1ps

module programCounterIncrement_tb();

localparam DATA_LEN = 32;

reg [DATA_LEN-1:0] i_programCounter;
wire [DATA_LEN-1:0] o_incrementedProgramCounter;


programCounterIncrement #(
    .DATA_LEN(DATA_LEN)
) pcIncrement
(
    .i_programCounter(i_programCounter),
    .o_incrementedProgramCounter(o_incrementedProgramCounter)
);

reg [5:0] i;

initial begin    

    i_programCounter = 32'h00;

    for (i = 0; i<5; i=i+1) begin
        i_programCounter = i;
        #10;
    end
end

endmodule
