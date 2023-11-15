`timescale 1ns / 1ps

module memoryStage_tb;
    localparam DATA_LEN = 32;

    //Data inputs
    reg [DATA_LEN-1:0] i_address;
    reg [DATA_LEN-1:0] i_writeData;
    //Control inputs
    reg i_memRead;
    reg i_memWrite;
    reg i_branch = 0;
    reg i_zero;
    //Data outputs
    wire [DATA_LEN-1:0] o_readData;
    //Control outputs
    wire o_PCSrc;

    memoryStage #(
        .DATA_LEN(DATA_LEN)
    ) memoryStage(
         //Data inputs
        .i_address(i_address),
        .i_writeData(i_writeData),
        //Control inputs
        .i_memRead(i_memRead),
        .i_memWrite(i_memWrite),
        .i_branch(i_branch),
        .i_zero(i_zero),
        //Data outputs
        .o_readData(o_readData),
        //Control outputs
        .o_PCSrc(o_PCSrc)
    );
    
    reg [2:0] i = 0;
    
    initial begin    
        //Simulates 8 stores
        for(i=0; i<7;i=i+1) begin
            #10
            i_memWrite = 1'b1;
            i_memRead = 1'b0;
            i_address = i*4;
            i_writeData = i;
        end
        
        #10
        
        //Simulates 8 loads
        for(i=0; i<7;i=i+1) begin
            #10
            i_memWrite = 1'b0;
            i_memRead = 1'b1;
            i_address = i*4;
            if(o_readData != i-1) begin
                $display("Incorrect data at %d", i-1);
            end
        end
        
        #10
        
        //Simulate R-Type
        i_memWrite = 1'b0;
        i_memRead = 1'b0;
        i_zero = 1;
        
        #1
        
        if(o_PCSrc != 0) begin
            $display("R-Type instruction should not trigger branch");
        end
        
        #10
        
        //Simulate Beq with zero
        i_branch = 1;
        i_zero = 1;
        
        #1
        
        if(o_PCSrc != 1) begin
            $display("Beq instruction should trigger branch when aluResult is zero");
        end
        
    end
endmodule
