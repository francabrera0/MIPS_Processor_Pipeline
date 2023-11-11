`timescale 1ns / 1ns


module ALU #(
    parameter DATA_LEN  = 32,
    parameter OP_LEN    = 6
)
( 
    input wire  [DATA_LEN-1 : 0] i_operandA,
    input wire  [DATA_LEN-1 : 0] i_operandB,
    input wire    [OP_LEN-1 : 0] i_opSelector,
    output wire [DATA_LEN-1 : 0] o_aluResult,
    output wire                  o_zero,
    output wire                  o_overFlow
); 

    localparam ADD = 6'b100000;
    localparam SUB = 6'b100010;
    localparam AND = 6'b100100;
    localparam OR  = 6'b100101;
    localparam XOR = 6'b100110;
    localparam NOR = 6'b100111;
    localparam SRA = 6'b000011;
    localparam SRL = 6'b000010;

    
    //Adder Substractor module    
    wire [DATA_LEN-1 : 0] tempAddSubResult;
    wire                  tempAddSubOverFlow;  
    
    SumadorRestador #(
        .DATA_LEN(DATA_LEN)    
    ) SumRes
    (
        .i_operandA(i_operandA),
        .i_operandB(i_operandB),
        .i_substract(i_opSelector[1]),
        .o_result(tempAddSubResult),
        .o_overflow(tempAddSubOverFlow)
    );
    
    
    reg [DATA_LEN-1 : 0] tempResult;
    
    //Alu out
    assign o_aluResult = tempResult;
    
    //Zero flag
    assign o_zero = & (~ o_aluResult);

    assign o_overFlow = (i_opSelector == ADD | i_opSelector == SUB) ? tempAddSubOverFlow : 0; 
    
   
    //Calculation
    always @(*)
        begin
            case(i_opSelector)
                ADD: tempResult = tempAddSubResult;                
                SUB: tempResult = tempAddSubResult;
                
                AND: tempResult = i_operandA & i_operandB;
                OR : tempResult = i_operandA | i_operandB;
                XOR: tempResult = i_operandA ^ i_operandB;
                NOR: tempResult = ~(i_operandA | i_operandB);
                
                SRA: tempResult = $signed(i_operandA) >>> i_operandB;
                SRL: tempResult = i_operandA >> i_operandB;
                
                default : tempResult = {DATA_LEN {1'b1}};
            endcase
        end
    
endmodule