`timescale 1ns / 1ps

module dataMemory_tb;

    localparam DATA_LEN = 32;

    //Data inputs
    reg [DATA_LEN-1:0] i_address;
    reg [DATA_LEN-1:0] i_writeData;
    //Control inputs
    reg i_memRead = 0;
    reg i_memWrite = 0;
    //Data outputs
    wire [DATA_LEN-1:0] o_readData;

    dataMemory #(
        .DATA_LEN(DATA_LEN)
    ) dataMemory(
         //Data inputs
        .i_address(i_address),
        .i_writeData(i_writeData),
        //Control inputs
        .i_memRead(i_memRead),
        .i_memWrite(i_memWrite),
        //Data outputs
        .o_readData(o_readData)
    );
    
    reg [2:0] i = 0;
    
    initial begin
        //Write 8 words
        for(i=0; i<7;i=i+1) begin
            #10
            i_address = i*4;
            i_writeData = i;
            i_memWrite = 1'b1;
            i_memRead = 1'b0;
        end
        
        #10
        
        //Read 8 words
        for(i=0; i<7;i=i+1) begin
            #10
            i_address = i*4;
            i_memWrite = 1'b0;
            i_memRead = 1'b1;
            if(o_readData != i-1) begin
                $display("Incorrect data at %d", i-1);
            end
        end
    end

endmodule
