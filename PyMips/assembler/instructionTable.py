instructionTable = {
    
    #R type
    'SLL' : ['0x00', 'rs', 'rt', 'rd', 'shamt', '0x00'], #Shift Word Left Logical, rs = 0x00
    'SRL' : ['0x00', 'rs', 'rt', 'rd', 'shamt', '0x02'], #Shift Word Right Logical, rs = 0x00
    'SRA' : ['0x00', 'rs', 'rt', 'rd', 'shamt', '0x03'], #Shift Word Right Arithmetic, rs = 0x00
    'SLLV' : ['0x00', 'rs', 'rt', 'rd', 'shamt', '0x04'], #Shift Word Left Logical Variable, shamt = 0x00
    'SRLV' : ['0x00', 'rs', 'rt', 'rd', 'shamt', '0x06'], #Shift Word Right Logical Variable, shamt = 0x00
    'SRAV' : ['0x00', 'rs', 'rt', 'rd', 'shamt', '0x07'], #Shift Word Right Arithmetic Variable, shamt = 0x00
    'ADDU' : ['0x00', 'rs', 'rt', 'rd', 'shamt', '0x21'], #Add Unsigned Word, shamt = 0x00
    'SUBU' : ['0x00', 'rs', 'rt', 'rd', 'shamt', '0x23'], #Subtract Unsigned Word, shamt = 0x00
    'AND' : ['0x00', 'rs', 'rt', 'rd', 'shamt', '0x24'], #And, shamt = 0x00
    'OR' : ['0x00', 'rs', 'rt', 'rd', 'shamt', '0x25'], #Or, shamt = 0x00
    'XOR' : ['0x00', 'rs', 'rt', 'rd', 'shamt', '0x26'], #Xor, shamt = 0x00
    'NOR' : ['0x00', 'rs', 'rt', 'rd', 'shamt', '0x27'], #Nor, shamt = 0x00
    'SLT' : ['0x00', 'rs', 'rt', 'rd', 'shamt', '0x2a'], #Set on Less Than, shamt = 0x00

    #I type
    'LB' : ['0x20', 'rs', 'rt', 'imm'], #Load Byte
    'LH' : ['0x21', 'rs', 'rt', 'imm'], #Load Halfword
    'LW' : ['0x23', 'rs', 'rt', 'imm'], #Load Word
    'LWU' : ['0x27', 'rs', 'rt', 'imm'], #Load Word Unsigned
    'LBU' : ['0x24', 'rs', 'rt', 'imm'], #Load Byte Unsigned
    'LHU' : ['0x25', 'rs', 'rt', 'imm'], #Load Halfword Unsigned
    'SB' : ['0x28', 'rs', 'rt', 'imm'], #Store Byte
    'SH' : ['0x29', 'rs', 'rt', 'imm'], #Store Halfword
    'SW' : ['0x2b', 'rs', 'rt', 'imm'], #Store Word
    'ADDI' : ['0x08', 'rs', 'rt', 'imm'], #Add Immediate Word
    'ANDI' : ['0x0c', 'rs', 'rt', 'imm'], #And Immediate
    'ORI' : ['0x0d', 'rs', 'rt', 'imm'], #Or Immediate
    'XORI' : ['0x0e', 'rs', 'rt', 'imm'], #Xor Immediate
    'LUI' : ['0x0f', 'rs', 'rt', 'imm'], #Load Upper Immediate, rs = 0x00
    'SLTI' : ['0x0a', 'rs', 'rt', 'imm'], #Set on Less Than Immediate
    'BEQ' : ['0x04', 'rs', 'rt', 'imm'], #Branch on Equal
    'BNE' : ['0x05', 'rs', 'rt', 'imm'], #Branch on Not Equal

    'JALR' : ['0x00', 'rs', 'rt', 'rd', 'shamt', '0x09'], #Jump And Link Register, rs, shamt = 0x00
    'JR' : ['0x00', 'rs', 'rt', 'rd', 'shamt', '0x08'], #Jump Register
    
    #J type
    'J' : ['0x02', 'address'], #Jump
    'JAL' : ['0x03', 'address'], #Jump And Link

    'NOP' : ['0x3f'],
    'HALT' : ['0x38']

}