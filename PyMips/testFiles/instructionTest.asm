SLL r0, r4, 5               #syntax: SLL rd, rt, sa  rd <-- rt << sa
SRL r2, r4, 3               #syntax: SRL rd, rt, sa  rd <-- rt >> sa
SRA r5, r1, 2               #syntax: SRA rd, rt, sa  rd <-- rt >>> sa

SLLV r10, r3, r5            #syntax: SLLV rd, rt, rs  rd <-- rt << rs
SRLV r10, r3, r5            #syntax: SRLV rd, rt, rs  rd <-- rt >> rs
SRAV r10, r3, r5            #syntax: SRAV rd, rt, rs  rd <-- rt >>> rs

ADDU r15, r2, r9            #syntax: ADDU rd, rs, rt  rd <-- rs + rt
SUBU r15, r2, r9            #syntax: SUBU rd, rs, rt  rd <-- rs - rt
AND r10, r5, r8             #syntax: AND  rd, rs, rt  rd <-- rs AND rt
OR  r10, r5, r8             #syntax: OR   rd, rs, rt  rd <-- rs OR rt
XOR r10, r5, r8             #syntax: XOR  rd, rs, rt  rd <-- rs XOR rt
NOR r10, r5, r8             #syntax: NOR  rd, rs, rt  rd <-- rs NOR rt
SLT r10, r5, r8             #syntax: SLT  rd, rs, rt  rd <-- (rs < rt)


LB  r10, r5, 32             #syntax: LB  rt, rs, imm  rt <-- memory[rs+offset]
LB  r10, 32(r5)
LH  r10, r5, 32             #syntax: LH  rt, rs, imm  rt <-- memory[rs+offset]
LH   r10, 32(r5)
LW  r10, r5, 32             #syntax: LW  rt, rs, imm  rt <-- memory[rs+offset]
LBU r10, r5, 32             #syntax: LBU rt, rs, imm  rt <-- memory[rs+offset]
LHU r10, r5, 32             #syntax: LHU rt, rs, imm  rt <-- memory[rs+offset]
LWU r10, r5, 32             #syntax: LWU rt, rs, imm  rt <-- memory[rs+offset]
SB  r10, r5, 32             #syntax: SB  rt, rs, imm  memory[rs+offset] <-- rt
SH  r10, r5, 32             #syntax: SB  rt, rs, imm  memory[rs+offset] <-- rt
SW  r10, r5, 32             #syntax: SB  rt, rs, imm  memory[rs+offset] <-- rt


ADDI r10, r5, 32            #syntax: ADDI rt, rs, imm  rt <-- rs + imm
ANDI r10, r5, 32            #syntax: ANDI rt, rs, imm  rt <-- rs AND imm
ORI  r10, r5, 32            #syntax: ORI  rt, rs, imm  rt <-- rs OR imm
XORI r10, r5, 32            #syntax: XORI rt, rs, imm  rt <-- rs XOR imm

LUI r10, 45                 #syntax: LUI rt, imm  rt <-- imm || 0^16

SLTI r10, r5, 32            #syntax: SLTI rt, rs, imm  rt <-- (rs < imm)
 
BEQ r10, r5, SALTO          #syntax: BEQ rs, rt, imm   if(rs==rt) branch
BNE r10, r5, SALTO          #syntax: BEQ rs, rt, imm   if(rs==rt) branch

JR r10                      #syntax: JR rs  PC <-- rs
JALR r10                    #syntax: JALR rs (rd = 31 implied)  rd <-- return address PC <-- rs
JALR r20, r10               #syntax: JALR rd, rs                rd <-- return address PC <-- rs



J SALTO                     #syntax: J target
JAL SALTO                   #syntax: J target

SALTO: ANDI r10, r5, 32     #syntax: ANDI rt, rs, imm  rt <-- rs AND imm

NOP
HALT