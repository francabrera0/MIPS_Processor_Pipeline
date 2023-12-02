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
    output wire                  o_zero
); 

    localparam ADDU = 6'b100001;
    localparam SUBU = 6'b100011;
    
    localparam AND = 6'b100100;
    localparam OR  = 6'b100101;
    localparam XOR = 6'b100110;
    localparam NOR = 6'b100111;
    
    localparam SRA = 6'b000011;
    localparam SRAV = 6'b000111;
    localparam SRL = 6'b000010;
    localparam SRLV = 6'b000110;
        
    localparam SLL = 6'b000000;
    localparam SLLV = 6'b000100;
    
    localparam SLT = 6'b101010;
    
    reg [DATA_LEN-1 : 0] tempResult;
    
    //Alu out
    assign o_aluResult = tempResult;
    
    //Zero flag
    assign o_zero = & (~ o_aluResult);   
   
    //Calculation
    always @(*)
        begin
            case(i_opSelector)
                ADDU: tempResult = i_operandA + i_operandB;                
                SUBU: tempResult = i_operandA - i_operandB;
                
                AND: tempResult = i_operandA & i_operandB;
                OR : tempResult = i_operandA | i_operandB;
                XOR: tempResult = i_operandA ^ i_operandB;
                NOR: tempResult = ~(i_operandA | i_operandB);
                
                SRA: tempResult = $signed(i_operandA) >>> i_operandB;
                SRAV: tempResult = $signed(i_operandB) >>> i_operandA;  
                SRL: tempResult = i_operandA >> i_operandB;
                SRLV: tempResult = i_operandB >> i_operandA;
                
                SLL: tempResult = i_operandA << i_operandB;
                SLLV: tempResult = i_operandB << i_operandA;
                
                SLT: tempResult = $signed(i_operandA) < $signed(i_operandB);
                
                default : tempResult = {DATA_LEN {1'b1}};
            endcase
        end
    
endmodule