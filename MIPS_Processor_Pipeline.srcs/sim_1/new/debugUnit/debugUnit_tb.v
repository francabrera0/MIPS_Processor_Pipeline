module debugUnit_tb();

reg i_clk;
reg i_reset;

reg r_writeUart;
reg [7:0] r_dataToWrite;

wire w_pcTx;
wire w_pcRx;

uart#(
    .DATA_LEN(8),
    .SB_TICK(16),
    .COUNTER_MOD(27),
    .COUNTER_BITS(5),
    .PTR_LEN(6)       
) uartPc
(
    .i_clk(i_clk),
    .i_reset(i_reset),
    .i_readUart(),
    .i_writeUart(r_writeUart),
    .i_uartRx(w_pcRx),
    .i_dataToWrite(r_dataToWrite),
    .o_txFull(),
    .o_rxEmpty(),
    .o_uartTx(w_pcTx),
    .o_dataToRead()
);


wire o_enable;
wire o_writeInstruction;
wire [32-1:0] o_instructionToWrite;

debugUnit#(
    .UART_DATA_LEN(8),
    .SB_TICK(16),
    .COUNTER_MOD(27),
    .COUNTER_BITS(5),
    .PTR_LEN(6),
    .CPU_DATA_LEN(32)
) debugUnit
(
    .i_clk(i_clk),
    .i_reset(i_reset),
    .i_uartRx(w_pcTx),
    .o_uartTx(w_pcRx),
    .o_enable(o_enable),
    .o_writeInstruction(o_writeInstruction),
    .o_instructionToWrite(o_instructionToWrite)
);

always begin
    #10 i_clk = ~i_clk;
end


reg [31:0] seed;
reg [2:0] i;
reg [3:0] j;
    initial begin
        seed = 135;
        i_clk = 0;
        i_reset = 1;
        r_writeUart = 0;
        r_dataToWrite = 8'b0;

        #20 i_reset = 0;

        j = 0;
        for (j=0; j<9; j=j+1) begin
            
            r_dataToWrite = 8'h23;
            r_writeUart = 1'b1;
            #20;
            //Tx 4 bytes
            i = 8'b0;
            for(i = 0; i<4; i = i + 1) begin
                r_dataToWrite = $random(seed);
                #20;
            end //End for
            r_writeUart = 0;
            #200000;
        end
        
        r_dataToWrite = 8'h12;
        r_writeUart = 1'b1;
        #60;
        r_writeUart = 1'b0;

        r_dataToWrite = 8'h54;
        r_writeUart = 1'b1;
        #20;
        r_writeUart = 1'b0;

        #500000;  
        j = 0;
        for (j=0; j<9; j=j+1) begin
            
            r_dataToWrite = 8'h23;
            r_writeUart = 1'b1;
            #20;
            //Tx 4 bytes
            i = 8'b0;
            for(i = 0; i<4; i = i + 1) begin
                r_dataToWrite = $random(seed);
                #20;
            end //End for
            r_writeUart = 0;
            #200000;
        end
        
        r_dataToWrite = 8'h54;
        r_writeUart = 1'b1;
        #20;
        r_writeUart = 1'b0;

    end

endmodule