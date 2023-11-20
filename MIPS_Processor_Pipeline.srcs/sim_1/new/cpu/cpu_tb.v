`timescale 1ns / 1ps

module cpu_tb();

    localparam DATA_LEN = 32;
    localparam PC_LEN = 32;
    localparam MEM_SIZE_ADDRESS_BITS = 10; //Bits to address instruction memory;
    localparam OPCODE_LEN = 6; 
    localparam REGISTER_BITS = 5; //Cantidad de bits que direccionan registros
    localparam IMMEDIATE_LEN = 16;
    localparam FUNCTION_LEN = 6;

    localparam NOP = {32{1'b1}};

    reg i_clk;
    reg i_reset;
    reg i_writeInstruction;
    reg i_enable;
    reg [DATA_LEN-1:0] i_instructionToWrite;
    reg [REGISTER_BITS-1:0] i_registerAddress;
    
    wire [DATA_LEN-1:0] o_registerValue;

cpu#(
    .DATA_LEN(DATA_LEN),
    .PC_LEN(PC_LEN),
    .MEM_SIZE_ADDRESS_BITS(MEM_SIZE_ADDRESS_BITS),
    .OPCODE_LEN(OPCODE_LEN), 
    .REGISTER_BITS(REGISTER_BITS),
    .IMMEDIATE_LEN(IMMEDIATE_LEN),
    .FUNCTION_LEN(FUNCTION_LEN)
) cpu
(
    .i_clk(i_clk),
    .i_reset(i_reset),
    .i_writeInstruction(i_writeInstruction),
    .i_enable(i_enable),
    .i_instructionToWrite(i_instructionToWrite),
    .i_registerAddress(i_registerAddress),
    .o_registerValue(o_registerValue)
);


always begin
    #10 i_clk = ~i_clk;
end

integer i;

initial begin
    i_clk = 1'b0;
    i_writeInstruction = 1'b0;
    i_enable = 1'b0;
    i_reset = 1'b1;
    i_registerAddress = 0;
    #20;
    i_reset = 1'b0;

    //Add: Suma el contenido de register[0] + register[5] y lo guarda en register[10]
    i_instructionToWrite = {6'b000000, 5'b00000, 5'b00101, 5'b01010, 5'b00000, 6'b100001};
    i_writeInstruction = 1'b1;
    #20;
    //Store: Guardamos en la posici�n de memoria register[0]+inmediato, el valor de register[20]
    i_instructionToWrite = {6'b101011, 5'b00000, 5'b10100, 16'b0000000000000110};
    #20;
    //Load: Guarda en el register[31] el contenido de la direcci�n apuntada por register[0]+inmediato
    i_instructionToWrite = {6'b100011, 5'b00000, 5'b11111, 16'b0000000000000110};
    #20;
    //Beq: Si el contenido del register[10] es igual a register[8] salta a la instrucci�n nextPC + 7 
    i_instructionToWrite = {6'b000100, 5'b01010, 5'b01000, 16'b0000000000000100};
    #20;
    //Nop: tres nop para permitir el c�lculo de direcci�n y verificaci�n de la condici�n del branch
    i_instructionToWrite = NOP;
    #60;
    //OR: Esta instrucci�n se ejecuta si la condici�n del beq es falsa
    //Guarda en register[11] = register[0] | register[5]
    i_instructionToWrite = {6'b000000, 5'b00000, 5'b00101, 5'b01011, 5'b00000, 6'b100110};
    #20;
    //AND: A esta instrucci�n salta el branch si la condici�n fue verdadera 
    //Guarda en register[11] = register[0] & register[5]
    i_instructionToWrite = {6'b000000, 5'b00000, 5'b00101, 5'b01011, 5'b00000, 6'b100100};
    #20;
    //SLL: Shift en 2 el contenido del register[20] y lo guarda en register[20]
    i_instructionToWrite = {6'b000000, 5'b00000, 5'b10100, 5'b10100, 5'b10, 6'b000000};
    #20;
    //SLLV: Shift en 2 el contenido del register[8] y lo guarda en register[8]
    i_instructionToWrite = {6'b000000, 5'b00000, 5'b01000, 5'b01000, 5'b00000, 6'b000100};
    #20;
    i_writeInstruction = 1'b0;
    #60;
    i_enable = 1'b1;

    #500;

    for(i=0; i<32; i=i+1) begin
        i_registerAddress = i;
        #10;
    end

end

endmodule
