module debugUnitWithCPU();

localparam CPU_DATA_LEN = 32;
localparam UART_DATA_LEN = 8;
localparam SB_TICK = 16;
localparam COUNTER_MOD = 27;
localparam COUNTER_BITS = 5;
localparam PTR_LEN = 10;
localparam PC_LEN = 32;
localparam MEM_SIZE_ADDRESS_BITS = 10;
localparam OPCODE_LEN = 6; 
localparam REGISTER_BITS = 5; //Cantidad de bits que direccionan registros
localparam IMMEDIATE_LEN = 16;
localparam FUNCTION_LEN = 6;

localparam NOP = {32{1'b1}};

reg i_clk;
reg i_reset;

reg r_PCwriteUart;
reg [UART_DATA_LEN-1:0] r_PCdataToWrite;
reg r_PCreadUart;
wire [UART_DATA_LEN-1:0] w_PCdataToRead;

wire w_pcTx;
wire w_pcRx;

//PC uart
uart#(
    .DATA_LEN(UART_DATA_LEN),
    .SB_TICK(SB_TICK),
    .COUNTER_MOD(COUNTER_MOD),
    .COUNTER_BITS(COUNTER_BITS),
    .PTR_LEN(PTR_LEN)       
) uartPc
(
    .i_clk(i_clk),
    .i_reset(i_reset),
    .i_readUart(r_PCreadUart),
    .i_writeUart(r_PCwriteUart),
    .i_uartRx(w_pcRx),
    .i_dataToWrite(r_PCdataToWrite),
    .o_txFull(),
    .o_rxEmpty(),
    .o_uartTx(w_pcTx),
    .o_dataToRead(w_PCdataToRead)
);


wire w_enable;
wire w_halt;
wire [CPU_DATA_LEN-1:0] w_registerValue;
wire w_writeInstruction;
wire [CPU_DATA_LEN-1:0] w_instructionToWrite;
wire [REGISTER_BITS-1:0] w_registerAddress;

//Debug unit
debugUnit#(
    .UART_DATA_LEN(UART_DATA_LEN),
    .SB_TICK(SB_TICK),
    .COUNTER_MOD(COUNTER_MOD),
    .COUNTER_BITS(COUNTER_BITS),
    .PTR_LEN(PTR_LEN),
    .CPU_DATA_LEN(CPU_DATA_LEN)
) debugUnit
(
    .i_clk(i_clk),
    .i_reset(i_reset),
    .i_uartRx(w_pcTx),
    .i_registerValue(w_registerValue),
    .i_halt(w_halt),
    .o_uartTx(w_pcRx),
    .o_enable(w_enable),
    .o_writeInstruction(w_writeInstruction),
    .o_instructionToWrite(w_instructionToWrite),
    .o_registerAddress(w_registerAddress)
);


cpu#(
    .DATA_LEN(CPU_DATA_LEN),
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
    .i_writeInstruction(w_writeInstruction),
    .i_enable(w_enable),
    .i_instructionToWrite(w_instructionToWrite),
    .i_registerAddress(w_registerAddress),
    .o_registerValue(w_registerValue),
    .o_halt(w_halt)
);


always begin
    #10 i_clk = ~i_clk;
end

integer i;
integer j;
reg [CPU_DATA_LEN-1:0] instructions [11:0];

initial begin
    i_clk = 0;
    i_reset = 1;
    r_PCwriteUart = 0;
    r_PCreadUart = 0;
    r_PCdataToWrite = 0;

    //Add: Suma el contenido de register[0] + register[5] y lo guarda en register[10]
    instructions[0] = {6'b000000, 5'b00000, 5'b00101, 5'b01010, 5'b00000, 6'b100001};
    //Store: Guardamos en la posici�n de memoria register[0]+inmediato, el valor de register[20]
    instructions[1] = {6'b101011, 5'b00000, 5'b10100, 16'b0000000000000110};
    //Load: Guarda en el register[31] el contenido de la direcci�n apuntada por register[0]+inmediato
    instructions[2] = {6'b100011, 5'b00000, 5'b11111, 16'b0000000000000110};
    //Beq: Si el contenido del register[10] es igual a register[8] salta a la instrucci�n nextPC + 7 
    instructions[3] = {6'b000100, 5'b01010, 5'b01000, 16'b0000000000000100};
    //Nop: tres nop para permitir el c�lculo de direcci�n y verificaci�n de la condici�n del branch
    instructions[4] = NOP;
    instructions[5] = NOP;
    instructions[6] = NOP;
    //OR: Esta instrucci�n se ejecuta si la condici�n del beq es falsa
    //Guarda en register[11] = register[0] | register[5]
    instructions[7] = {6'b000000, 5'b00000, 5'b00101, 5'b01011, 5'b00000, 6'b100110};
    //AND: A esta instrucci�n salta el branch si la condici�n fue verdadera 
    //Guarda en register[11] = register[0] & register[5]
    instructions[8] = {6'b000000, 5'b00000, 5'b00101, 5'b01011, 5'b00000, 6'b100100};
    //SLL: Shift en 2 el contenido del register[20] y lo guarda en register[20]
    instructions[9] = {6'b000000, 5'b00000, 5'b10100, 5'b10100, 5'b10, 6'b000000};
    //SLLV: Shift en 2 el contenido del register[8] y lo guarda en register[8]
    instructions[10] = {6'b000000, 5'b00000, 5'b01000, 5'b01000, 5'b00000, 6'b000100};
    //Halt
    instructions[11] = {6'b111000, {26{1'b0}}};
    
    #20;

    i_reset = 0;
    
    j = 0;
    for (j=0; j<12; j=j+1) begin
        
        r_PCdataToWrite = 8'h23;
        r_PCwriteUart = 1'b1;
        #20;
        i = 0;
        for(i = 0; i<4; i = i + 1) begin
            if (i==0) r_PCdataToWrite = instructions[j][7:0];
            if (i==1) r_PCdataToWrite = instructions[j][15:8];
            if (i==2) r_PCdataToWrite = instructions[j][23:16];
            if (i==3) r_PCdataToWrite = instructions[j][31:24];
            #20;
        end 
        r_PCwriteUart = 0;
    end

    for(j=0; j<4; j=j+1) begin
        r_PCdataToWrite = 8'h12;
        r_PCwriteUart = 1;
        #20;
        r_PCwriteUart = 0;
    end
        
    r_PCdataToWrite = 8'h54;
    r_PCwriteUart = 1;
    #20;
    r_PCwriteUart = 0;
    
        


end

endmodule