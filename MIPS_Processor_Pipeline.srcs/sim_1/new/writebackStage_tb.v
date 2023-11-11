`timescale 1ns / 1ps

module writebackStage_tb;

    localparam DATA_LEN = 32;
    
    //Data inputs
    reg [DATA_LEN-1:0] i_readData;
    reg [DATA_LEN-1:0] i_aluResult;
    //Control inputs
    reg i_memToReg;
    //Data outputs
    wire [DATA_LEN-1:0] o_writeData;

    writebackStage #(
        .DATA_LEN(DATA_LEN)
    )writebackStage (
        //Data inputs
        .i_readData(i_readData),
        .i_aluResult(i_aluResult),
        //Control inputs
        .i_memToReg(i_memToReg),
        //Data outputs
        .o_writeData(o_writeData)
    );
    
    reg [DATA_LEN-1:0]seed = 100;
    
    initial begin
        i_readData = $random(seed);
        i_aluResult = $random(seed);
        
        //R-type
        i_memToReg = 0;
        
        if(o_writeData != i_aluResult) begin
            $display("R-Type should write aluResult to register");
        end
        
        #10 
        
        //Load
        i_memToReg = 1;
        
        if(o_writeData != i_aluResult) begin
            $display("Load should write memoryData to register");
        end
        
    end

endmodule
