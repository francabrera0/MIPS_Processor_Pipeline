`timescale 1ns / 1ps

module memoryMask_tb;
    
    localparam DATA_LEN = 32;
    
    //Data inputs
    reg [DATA_LEN-1:0] i_readData;
    reg [1:0] i_address;
    //Control inputs
    reg i_unsigned;
    reg [1:0] i_loadStoreType;
    //Data outputs
    wire [DATA_LEN-1:0] o_readData;
    
    memoryMask #(
        .DATA_LEN(DATA_LEN)
    )memoryMask (
        .i_readData(i_readData),
        .i_loadStoreType(i_loadStoreType),
        .i_unsigned(i_unsigned),
        .i_address(i_address),
        .o_readData(o_readData)
    );
    
    initial begin
    
        i_readData = 32'haff385a9;
        i_address = 2'b10;
    
        //TEST BYTE
        i_loadStoreType = 2'b00;
        i_unsigned = 1'b0;
        
        #20
        
        if(o_readData != {1'b1,{24{1'b0}},i_readData[22:16]}) begin
            $display("Load Byte: Incorrect data");
        end
        
        //Unsigned
        i_unsigned = 1'b1;
        
        #20
        
        if(o_readData != {{24{1'b0}},i_readData[23:16]}) begin
            $display("Load Byte Unsigned: Incorrect data");
        end
        
        //TEST HALFWORD
        i_loadStoreType = 2'b01;
        i_unsigned = 1'b0;
        
        #20
        
        if(o_readData != {1'b1,{16{1'b0}},i_readData[30:16]}) begin
            $display("Load Halfword: Incorrect data");
        end
        
        //Unsigned
        i_unsigned = 1'b1;
        
        #20
        
        if(o_readData != {{16{1'b0}},i_readData[31:16]}) begin
            $display("Load Halfword Unsigned: Incorrect data");
        end
        
        //TEST WORD
        i_loadStoreType = 2'b11;
        i_unsigned = 1'b0;
        
        #20
        
        if(o_readData != i_readData[31:0]) begin
            $display("Load Word: Incorrect data");
        end   
        
        //Unsigned
        i_unsigned = 1'b1;
        
        #20
        
        if(o_readData != i_readData[31:0]) begin
            $display("Load Word Unsigned: Incorrect data");
        end
    end
endmodule
