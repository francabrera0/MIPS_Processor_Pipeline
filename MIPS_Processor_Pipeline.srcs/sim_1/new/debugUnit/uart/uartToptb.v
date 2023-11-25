`timescale 1ns / 1ns

module uartToptb();

    localparam DATA_LEN = 8;
    localparam SB_TICK = 16;
    localparam COUNTER_MOD = 27;
    localparam COUNTER_BITS = 9;
    localparam PTR_LEN = 2;

    reg clk;
    reg reset;
    reg readUart;
    reg writeUart;
    wire uartRx;
    reg [DATA_LEN-1 : 0] dataToWrite;
    wire txFull;
    wire rxEmpty;
    wire uartTx;
    wire [DATA_LEN-1 : 0] dataToRead;

    uart #
    (
        .DATA_LEN(DATA_LEN),
        .SB_TICK(SB_TICK),
        .COUNTER_MOD(COUNTER_MOD),
        .COUNTER_BITS(COUNTER_BITS),
        .PTR_LEN(PTR_LEN) 
    ) uartTop
    (
        .i_clk(clk),
        .i_reset(reset),
        .i_readUart(readUart),
        .i_writeUart(writeUart),
        .i_uartRx(uartRx),
        .i_dataToWrite(dataToWrite),
        .o_txFull(txFull),
        .o_rxEmpty(rxEmpty),
        .o_uartTx(uartTx),
        .o_dataToRead(dataToRead)
    );

    assign uartRx = uartTx;

    always begin
        #10 clk = ~clk;
    end
    
    reg [31:0] seed;
    reg [DATA_LEN-1:0] testData [3:0];
    reg [2:0] i;

    initial begin
        seed = 135;
        clk = 0;
        reset = 1;
        readUart = 0;
        writeUart = 0;
        dataToWrite = 8'b0;

        #1000 reset = 0;
        
        if(!rxEmpty) begin
            $error("Rx FIFO not empty at start");
        end
        if(txFull)begin
            $error("Rx FIFO full at start");
        end
        
        //Tx 4 bytes
        i = 8'b0;
        for(i = 0; i<4; i = i + 1)
        begin
            testData[i] = $random(seed);
            dataToWrite = testData[i];
            writeUart = 1;
            #20;
            writeUart = 0;
            #20;
        end //End for
        
        #20
        
        if(!txFull)begin
            $error("Tx FIFO not full after filling");
        end
        
        //Wait data transfer
        #1000000
        
        if(rxEmpty) begin
            $error("Rx FIFO empty after recieving data");
        end
        
        //Rx 4 bytes
        i = 8'b0;
        for(i = 0; i<4; i = i + 1)
        begin
            if(dataToRead != testData[i]) begin
                $error("Data uartRx different from uartTx, %d != %d", dataToRead, testData[i]); 
            end
            readUart = 1;
            #20;
            readUart = 0;
            #1000000;
        end //End for
        
        if(rxEmpty != 1'b1) begin
            $error("Rx FIFO not empty at end");
        end
    end
endmodule
