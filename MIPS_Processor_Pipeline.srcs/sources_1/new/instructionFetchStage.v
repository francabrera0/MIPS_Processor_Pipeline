module instructionFetchStage
#(
    parameter DATA_LEN = 32,
    parameter PC_LEN = 32,
    parameter MEM_SIZE_ADDRESS_BITS = 10
)
(
    //Inputs
    input wire i_clk,
    input wire i_reset,
    input wire [PC_LEN-1:0] i_programCounterBranch,
    input wire i_programCounterSrc,
    input wire [DATA_LEN-1:0] i_instructionToWrite,
    input wire i_writeMemory,

    //Outputs
    output wire [PC_LEN-1:0] o_incrementedProgramCounter,
    output wire [DATA_LEN-1:0] o_instruction
);

wire [PC_LEN-1:0] w_programCounterOut;
wire [PC_LEN-1:0] w_programCounterIn;

//Program counter instance
programCounter#(
    .PC_LEN(PC_LEN)
) programCounter
(
    .i_clk(i_clk),
    .i_reset(i_reset),
    .i_programCounter(w_programCounterIn),
    .i_enable(~i_writeMemory),
    .o_programCounter(w_programCounterOut)
);

//Program counter increment instance
programCounterIncrement#(
    .PC_LEN(PC_LEN)
) programCounterIncrement
(
    .i_programCounter(w_programCounterOut),
    .o_incrementedProgramCounter(o_incrementedProgramCounter)
);

//Instruction memory instance
instructionMemory#(
    .DATA_LEN(DATA_LEN),
    .PC_LEN(PC_LEN),
    .MEM_SIZE_ADDRESS_BITS(MEM_SIZE_ADDRESS_BITS)
) instructionMemory
(
    .i_clk(i_clk),
    .i_reset(i_reset),
    .i_programCounter(w_programCounterOut),
    .i_dataToWrite(i_instructionToWrite),
    .i_write(i_writeMemory),
   .o_instruction(o_instruction)
);

//Mux instance
mux2to1#(
    .DATA_LEN(DATA_LEN)
) programCounterMux
(
    .i_muxInputA(o_incrementedProgramCounter),
    .i_muxInputB(i_programCounterBranch),
    .i_muxSelector(i_programCounterSrc),
    .o_muxOutput(w_programCounterIn)
);

endmodule
